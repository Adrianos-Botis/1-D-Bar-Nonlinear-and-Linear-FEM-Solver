function [KGlobalnew] = KGlobBCs(n1, n2, KGlobal)
    % n1 the number of constrained left BC, integer
    % n2 the number of constrained right BC, integer
    KGlobalnew = KGlobal;
    %% Boundary condition on the left wall
    KGlobalnew(:,n1) = []; KGlobalnew(n1,:) = [];
    KGlobalnew(:,n1) = []; KGlobalnew(n1,:) = [];
    %% Boundary condition on the right wall
    KGlobalnew(:,n2-2) = []; KGlobalnew(n2-2,:) = [];
    KGlobalnew(:,n2-3) = []; KGlobalnew(n2-3,:) = [];
end