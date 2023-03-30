function [Rvect,iterations] = Nonlinearsolve(n, NI, Rhoen, KGlobal, FGlobal, EA,DL, lnode, rnode)
  %% Function that utilizes Newton-Raphson Numerical method for solving the non linear beam
  for i = 1:NI    
    % Splitting deformation data for each element
    rhoel = Wtotel(Rhoen(:,i),n);
    
    % Global geometric stiffness matrix in KGgeoG.m function
    KGgl = KGgeoG(rhoel,n,DL,EA);
    
    % Reduced geometric stiffness matrix in KGlobBCs.m function
    KGglR = KGlobBCs(lnode,rnode,KGgl);
    
    % Deivative of function G
    DGDQ = KGlobal + KGglR;
    
    % Global geometric functional in FgeomG.m function
    FGL = FgeomG(rhoel,n,EA,DL);
    
    % Reduced global geometric functional in LGlobBCs.m function
    FGLR = LGlobBCs(lnode,rnode,FGL);
    
    % RHS of equilibrium equation
    RHSF = FGLR + FGlobal;
    
    % Value of fucntion G
    G = KGlobal*Rhoen(:,i) - RHSF;
    
    % Application of Newton-Raphson
    Rhoen(:,i+1) = Rhoen(:,i) - (inv(DGDQ))*G;
    
    % Convergence criterion
    if (abs(Rhoen((2*(n+1)/2 - 1),i+1) - Rhoen((2*(n+1)/2-1),i)) < 1e-8 && i > 3)
        break
    end
  end
  iterations = i;
  Rvect = Rhoen;
end