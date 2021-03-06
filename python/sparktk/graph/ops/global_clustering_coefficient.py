# vim: set encoding=utf-8

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


def global_clustering_coefficient(self):
    """

    The clustering coefficient of a graph provides a measure of how tightly
    clustered an undirected graph is.

    More formally:

    .. math::

        cc(G)  = \frac{ \| \{ (u,v,w) \in V^3: \ \{u,v\}, \{u, w\}, \{v,w \} \in \
            E \} \| }{\| \{ (u,v,w) \in V^3: \ \{u,v\}, \{u, w\} \in E \} \|}


    Parameters
    ----------

    :return: (Double) The global clustering coefficient of the graph

    Examples
    --------
        
        The clustering coefficient on a graph with some triangles will be
        greater than 0

        >>> vertex_schema = [('id', int)]
        >>> vertex_rows = [ [1], [2], [3], [4], [5] ]
        >>> vertex_frame = tc.frame.create(vertex_rows, vertex_schema)

        >>> edge_schema = [('src', int), ('dst', int)]
        >>> edge_rows = [ [1, 2], [1, 3], [2, 3], [1, 4], [4, 5] ]
        >>> edge_frame = tc.frame.create(edge_rows, edge_schema)

        >>> graph = tc.graph.create(vertex_frame, edge_frame)

        >>> graph.global_clustering_coefficient()
        0.5

        The clustering coefficient on a graph with no triangles (a tree) is
        0

        >>> vertex_rows_star = [ [1], [2], [3], [4]]
        >>> vertex_frame_star = tc.frame.create(vertex_rows_star, vertex_schema)

        >>> edge_rows_star = [ [1, 2], [1, 3], [1, 4]]
        >>> edge_frame_star = tc.frame.create(edge_rows_star, edge_schema)

        >>> graph_star = tc.graph.create(vertex_frame_star, edge_frame_star)

        >>> graph_star.global_clustering_coefficient()
        0.0

    """
    return self._scala.globalClusteringCoefficient()
