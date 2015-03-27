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
if nargin < 3
    whichopts = logical([0, 0, 0, 0]);
else
    whichopts = ((2+[1:4]) <= nargin);
end

% This is somewhat ugly, but the curved version is much slower.
% I don't want to use it unless we want refinements or curved edges.
% XXX: I'm aware theres a problem (namely, if you want to refine,
%      you can't get straight mesh lines). I don't think it's worth
%      resolving this, since you already pay the cost of curving, you
%      might as well look at it.
if ((whichopts(2) && nref ~= 0) || (whichopts(3) && pltmesh == 2))
    % This looks so dirty. I don't know how to forward in matlab though...
    switch nargin
        case 2
            scaplot_curved(mesh,u);
        case 3
            scaplot_curved(mesh,u,clim);
        case 4
            scaplot_curved(mesh,u,clim,nref);
        case 5
            scaplot_curved(mesh,u,clim,nref,pltmesh);
        case 6
            scaplot_curved(mesh,u,clim,nref,pltmesh,surf);
    end
else
    p=mesh.p;
    t=mesh.t;
    ma = mkmaster(mesh);
    hh=[];
    pars={'facecolor','interp'};
    noedgeline_pars = {'edgecolor', 'none'};
    edgeline_pars = {'edgecolor','k','Linew',1};
    if (~whichopts(3) || pltmesh == 0)
        pars = [pars, noedgeline_pars];
    else
        if pltmesh == 1
            pars = [pars, edgeline_pars];
        elseif pltmesh == 2
            pars = [pars, edgeline_pars];
        end
    end
    clipped_u = u;
    if (whichopts(1) && ~isempty(clim))
        clipped_u(u < clim(1)) = clim(1);
        clipped_u(u > clim(2)) = clim(2);
        % the clipping automatically sets the axis as well.
    end
    %clf,hh=[hh;patch('faces',t,'vertices',p,'FaceVertexCData',clipped_u,pars{:})];
    xx(:,:) = mesh.dgnodes(ma.corner,1,:);
    yy(:,:) = mesh.dgnodes(ma.corner,2,:);
    clipped_u = clipped_u(ma.corner, :);
    clf,hh=[hh;patch(xx,yy,zeros(size(yy)), clipped_u,pars{:})];
    colorbar;
    if (whichopts(4) && surf == 1)
        view(3);
    else
        view(2);
    end
    axis equal;
end

if nargout<1, clear hh;
end
