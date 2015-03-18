function nsf=shape1d(porder,plocal,pts)
%SHAPE1D Calculates the nodal shapefunctions and its derivatives for 
%        the master 1D element [0,1]
%   NFS=SHAPE1D(PORDER,PLOCAL,PTS)
%
%      PORDER:    Polynomial order
%      PLOCAL:    Node positions (NP) (NP=PORDER+1)
%      PTS:       Coordinates of the points where the shape functions
%                 and derivatives are to be evaluated (npoints)
%      NSF:       shape function and derivatives (np,2,npoints)
%                 nsf(:,1,:) shape functions 
%                 nsf(:,2,:) shape functions derivatives w.r.t. x
%
[V, ~] = koornwinder1d(plocal, porder);
[P, DP] = koornwinder1d(pts, porder);
VT_inv = (V')^(-1);
nsf(:,1,:) = VT_inv*P';
nsf(:,2,:) = VT_inv*DP';
end
