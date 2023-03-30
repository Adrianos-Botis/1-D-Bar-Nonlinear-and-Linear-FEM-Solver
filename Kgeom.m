%KGEOM   Geometric stiffness matrix. 
%   KGEOM (rhoe,EA,L) computes the current geometric stiffness matrix 
%   for a beam bending element of length L, axial stiffness EA, and
%   with nodal displacements/rotations given by rhoe. The 
%   beam has 4 degrees of freedom, given by:
%     i,j=1: displacement at first node; 
%     i,j=2: rotation at first node;
%     i,j=3: displacement at second node;
%     i,j=4: rotation at second node.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function StiffMat=Kgeom(rhoe,EA,L)

% Compute the derivative of the displacements in the element.
Wprime= @(x)shapeder(x,L,1)*rhoe(1) ...
           +shapeder(x,L,2)*rhoe(2) ...
           +shapeder(x,L,3)*rhoe(3) ...
           +shapeder(x,L,4)*rhoe(4);

% Evaluate the elements of the geometric stiffness matrix.
for i=1:4
  for j=1:4
    KFun  = @(x)(3*EA/2)*(Wprime(x).^2).*shapeder(x,L,i).*shapeder(x,L,j);
    StiffMat(i,j)=quadl(KFun,0,L);
  end
end
% eof