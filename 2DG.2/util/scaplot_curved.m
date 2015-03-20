function scaplot_curved(mesh,u,clim,nref,pltmesh,surf)
%SCAPLOT_CURVED  Plot Scalar function with curved mesh
%    SCAPLOT_CURVED(MESH,U,CLIM,NREF,PLTMESH,SURF)
%    XXX: This function is always slow! Use the non-curved version if possible.
%
%    MESH:       Mesh structure
%    U:          Scalar fucntion to be plotted: U(npl,nt)
%                npl = size(mesh.plocal,1)
%                nt = size(mesh.t,1)
%    CLIM:       CLIM(2) Limits for thresholding (default: no limits)
%    NREF:       Number of refinements used for plotting (default=0)
%    PLTMESH:    0 - do not plot mesh
%                1 - plot mesh with straight edges 
%                2 - plot mesh with curved edges
%    SURF:       0 - Normal 2D view
%                1 - 3D View
%
if nargin < 3
    whichopts = logical([0, 0, 0, 0]);
else
    whichopts = ((2+[1:4]) <= nargin);
end

dgnodes=mesh.dgnodes;
tlocal=mesh.tlocal;
plocal=mesh.plocal;
porder=double(mesh.porder);

U = u(mesh.t);
PU = plocal*U';
if (whichopts(2) && nref>0)
  A0=koornwinder(plocal(:,1:2),porder);
  [plocal,tlocal]=uniref(plocal,tlocal,nref);
  A=koornwinder(plocal(:,1:2),porder)/A0;
  dgnodes=reshape(A*reshape(dgnodes,size(A0,1),[]),size(A,1),2,[]);
  PU=A*PU;
end

e=boundedges(plocal(:,2:3),tlocal);
e1=segcollect(e);

nt=size(dgnodes,3);
hh=zeros(nt,1);
pars={'facecolor','interp'};
noedgeline_pars = {'edgecolor', 'none'};
edgeline_pars = {'edgecolor','k','Linew',1};
if (whichopts(3) && pltmesh ~= 0)
    pars = [pars, edgeline_pars];
else
    pars = [pars, noedgeline_pars];
end
for it=1:nt
  px=dgnodes(:,1,it);
  py=dgnodes(:,2,it);
  pu=PU(:, it);
  if (whichopts(1) && ~isempty(clim))
    pu(pu < clim(1)) = clim(1);
    pu(pu > clim(2)) = clim(2);
  end
  idx = e1{1}';
  hh(it)=patch(px(idx),py(idx),pu(idx), ...
               pu(idx),pars{:});
end
colorbar;
if (whichopts(4) && surf == 1)
    view(3);
else
    view(2);
end
axis equal;
if nargout<1, clear hh;
end


function e=boundedges(p,t)
%BOUNDEDGES Find boundary edges from triangular mesh
%   E=BOUNDEDGES(P,T)

% Form all edges, non-duplicates are boundary edges
edges=[t(:,[1,2]);
       t(:,[1,3]);
       t(:,[2,3])];
node3=[t(:,3);t(:,2);t(:,1)];
edges=sort(edges,2);
[foo,ix,jx]=unique(edges,'rows');
vec=histc(jx,1:max(jx));
qx=find(vec==1);
e=edges(ix(qx),:);
node3=node3(ix(qx));

% Orientation
v1=p(e(:,2),:)-p(e(:,1),:);
v2=p(node3,:)-p(e(:,1),:);
ix=find(v1(:,1).*v2(:,2)-v1(:,2).*v2(:,1)>0);
e(ix,[1,2])=e(ix,[2,1]);


function e1=segcollect(e)
%SEGCOLLECT Collect polygons from edge segments.

ue=unique(e(:));
he=histc(e(:),ue);
current=ue(min(find(he==1))); % Find an endpoint
if isempty(current) % Closed curve
  current=e(1,1);
end
e1=current;
while ~isempty(e)
  ix=min(find(e(:,1)==e1(end)));
  if isempty(ix)
    ix=min(find(e(:,2)==e1(end)));
    if isempty(ix) % >1 disjoint curves, recur
      rest=segcollect(e);
      e1={e1,rest{:}};
      return;
    end
    next=e(ix,1);
  else
    next=e(ix,2);
  end
  e1=[e1,next];
  e(ix,:)=[];
end
e1={e1};




