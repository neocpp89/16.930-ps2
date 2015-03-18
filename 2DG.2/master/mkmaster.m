function master=mkmaster(mesh,pgauss)
%MKMASTER  Initialize Master Element structures
%    MASTER=MKMASTER(MESH)
%
%      MESH:      Mesh data structure
%      PGAUSS:    Degree of the polynomila to be integrated exactly
%                 (default: PGAUSS = 4*MESH.PORDER)
%

if nargin < 2, 
    pgauss = 4*mesh.porder; 
end

master.porder=mesh.porder;
master.plocal=mesh.plocal;
 
% In order to test the 1d shape and mass matrix functions, the
% nodes on the edge where third barycentric coordinate = 0 are
% being used to set the node location for the 1d reference
% element.  
ii=find(master.plocal(:,3)<1.e-6);
[xc,jj]=sort(master.plocal(ii,2));
master.ploc1d=master.plocal(ii(jj),2);

master.corner = [find(master.plocal(:,1) > 1-1.e-6);
                 find(master.plocal(:,2) > 1-1.e-6);
                 find(master.plocal(:,3) > 1-1.e-6)];

master.perm=zeros(master.porder+1,3);
for i=1:3
    ii=find(master.plocal(:,i)<1.e-6);
    [xc,jj]=sort(master.plocal(ii,mod(i+1,3)+1));
    master.perm(:,i)=ii(jj);
end
master.perm=[master.perm,flipud(master.perm)];
master.perm=reshape(master.perm,[master.porder+1,3,2]);

[master.gpts,master.gwgh]=gaussquad2d(pgauss);
[master.gp1d,master.gw1d]=gaussquad1d(pgauss);

master.shap=shape2d(master.porder,master.plocal,master.gpts);
master.sh1d=shape1d(master.porder,master.ploc1d,master.gp1d);

W = diag(master.gwgh);
V(:, :) = master.shap(:, 1, :);
DX(:, :) = master.shap(:, 2, :);
DY(:, :) = master.shap(:, 3, :);

master.mass = V*W*V';
master.conv(:,:,1) = DX*W*V';
master.conv(:,:,2) = DY*W*V';

W1D = diag(master.gw1d);
V1D(:, :) = master.sh1d(:, 1, :);

master.ma1d = V1D*W1D*V1D'; 
end
