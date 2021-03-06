#!/usr/bin/env bash
#
#  Copyright (c) 2016 Intel Corporation 
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#


# builds the python documentation using pdoc

NAME="[`basename $0`]"
DIR="$( cd "$( dirname "$0" )" && pwd )"
echo "$NAME DIR=$DIR"
cd $DIR

SPARKTK_DIR="$(dirname "$DIR")"

tmp_dir=`mktemp -d`
echo $NAME created temp dir $tmp_dir

cp -r $SPARKTK_DIR $tmp_dir
TMP_SPARKTK_DIR=$tmp_dir/sparktk

# skip documenting the doc
rm -r $TMP_SPARKTK_DIR/doc

echo $NAME pre-processing the python for the special doctest flags
python2.7 -m docgen -py=$TMP_SPARKTK_DIR


echo $NAME cd $TMP_SPARKTK_DIR
pushd $TMP_SPARKTK_DIR > /dev/null

TMP_SPARKTK_PARENT_DIR="$(dirname "$TMP_SPARKTK_DIR")"
TEMPLATE_DIR=$SPARKTK_DIR/doc/templates

# specify output folder:
HTML_DIR=$SPARKTK_DIR/doc/html
rm -rf $HTML_DIR

# call pdoc
echo $NAME PYTHONPATH=$TMP_SPARKTK_PARENT_DIR pdoc --only-pypath --html --html-dir=$HTML_DIR --template-dir $TEMPLATE_DIR --overwrite sparktk
PYTHONPATH=$TMP_SPARKTK_PARENT_DIR pdoc --only-pypath --html --html-dir=$HTML_DIR --template-dir $TEMPLATE_DIR --overwrite sparktk

popd > /dev/null

# convert a copy of the README.md to python and call pdoc to get the html version
echo $NAME convert README.md to python and run pdoc
(echo '"""'; tail -n +6 ../../../README.md; echo '"""') > readme.py
pdoc --html --html-no-source --overwrite readme.py
echo $NAME mv readme.m.html html/readme.m.html
mv readme.m.html html/readme.m.html

# **special handling for the class instance properties - ONLY does Frame and Graph for now
# (todo: the ambitious reader can add processing the models as well, by walking the models dir tree)
echo $NAME python2.7 -m sidebar html/sparktk/frame/frame.m.html # Add props to sidebar
python2.7 -m sidebar html/sparktk/frame/frame.m.html
echo $NAME python2.7 -m sidebar html/sparktk/graph/graph.m.html # Add props to sidebar
python2.7 -m sidebar html/sparktk/graph/graph.m.html

# **special handling for the functions in models/_selection
TMP_MODELS_DIR=$TMP_SPARKTK_DIR/models
TMP_SELECTION_DIR=$TMP_MODELS_DIR/_selection
pushd $TMP_MODELS_DIR > /dev/null
echo $NAME PYTHONPATH=$TMP_SPARKTK_PARENT_DIR:$TMP_SELECTION_DIR pdoc --only-pypath --html --html-dir=$TMP_SELECTION_DIR/html --template-dir $TEMPLATE_DIR --overwrite _selection
PYTHONPATH=$TMP_SPARKTK_PARENT_DIR:$TMP_SELECTION_DIR pdoc --only-pypath --html --html-dir=$TMP_SELECTION_DIR/html --template-dir $TEMPLATE_DIR --overwrite _selection
# copy the special index.html file out of tmp and up to a spot in the output that's easy to find by docgen for post-proc
echo $NAME cp $TMP_SELECTION_DIR/html/_selection/index.html $HTML_DIR/selection.html
cp $TMP_SELECTION_DIR/html/_selection/index.html $HTML_DIR/selection.html
popd > /dev/null

# Post-processing:  Patch the "Up" links
echo $NAME post-processing the HTML
python2.7 -m docgen -html=$HTML_DIR -main

echo $NAME cleaning up...
rm readme.py
rm readme.pyc
rm html/full/readme.m.html

echo $NAME rm $tmp_dir
rm -r $tmp_dir

echo $NAME Done.
