function nsf=shape2d(porder,plocal,pts)
%SHAPE2D Calculates the nodal shapefunctions and its derivatives for 
%        the master triangle [0,0]-[1,0]-[0,1]
%   NFS=SHAPE2D(PORDER,PLOCAL,PTS)
%
%      PORDER:    Polynomial order
%      PLOCAL:    Node positions (NP,2) (NP=(PORDER+1)*(PORDER+2)/2)
%      PTS:       Coordinates of the points where the shape functions
%                 and derivatives are to be evaluated (npoints,2)
%      NSF:       shape function and derivatives (np,3,npoints)
%                 nsf(:,1,:) shape functions 
%                 nsf(:,2,:) shape functions derivatives w.r.t. x
%                 nsf(:,3,:) shape functions derivatives w.r.t. y
%
[V, ~] = koornwinder2d(plocal, porder);
[P, DPX, DPY] = koornwinder2d(pts, porder);
VT_inv = (V')^(-1);
nsf(:,1,:) = VT_inv*P';
nsf(:,2,:) = VT_inv*DPX';
nsf(:,3,:) = VT_inv*DPY';
end
