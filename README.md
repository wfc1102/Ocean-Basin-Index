# Ocean-Basin-Index

Basin averaged variables, like T/S, need unified geographical domain for the comparision of different models.

Here, a well-assigned 0.1 degree basin index data is used for those ~1 degree models. make sure the configuration of land/sea in coarse grids don't change.

Assign the index of closest fine grid to coarse grid.

If Coarse is sea but Fine is land, we assign nearby index to it.

Some model set variables within land domain 0 instead of _FillValue, we have to identify if the 0s is real value of certain variable (like velocity) or permanent land. 

目的：用涡分辨（0.1°）网格的海盆指标给粗网格（~1°）规划统一海盆。
要求：粗网格海陆点各自不变。
方法：根据粗网格的经纬度，找到细网格最临近点的海盆指标予以赋值。
难点：
（1）	陆地不是缺测值而是0：若变量在前12个月&整层的绝对值之和 * 100 < 1，那么就可判定该点为land=-9999，反之为sea。
（2）	粗为sea而对应的细为land：这些点多出现在沿海，被标记为0，大洋内部已分配好了index，因而可以用0点相邻的海洋点予以赋值。最后仅剩下内陆湖泊仍为0.
