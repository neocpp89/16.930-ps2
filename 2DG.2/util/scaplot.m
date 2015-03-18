function scaplot(mesh,u,clim,nref,pltmesh,surf)
%SCAPLOT  Plot Scalar function
%    SCAPLOT(MESH,U,CLIM,NREF,PLTMESH,SURF)
%
%    MESH:       Mesh structure
%    U:          Scalar fucntion to be plotted: U(npl,nt)
%                npl = size(mesh.plocal,1)
%                nt = size(mesh.t,1)
%    CLIM:       CLIM(2) Limits for thresholding (default: no limits)
%    NREF:       Number of refinements used for plotting (default=0)
%    PLTMESH:    0 - do not plot mesh
%                1 - plot mesh with straight edges 
%                2 - plot mesh with curved edges (slow)
%    SURF:       0 - Normal 2D view
%                1 - 3D View
%