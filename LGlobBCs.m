function LGLnew = LGlobBCs(n1,n2,LGL)
    % n1 the number of constrained left BC, integer
    % n2 the number of constrained right BC, integer
    LGLnew = LGL;
    %% Boundary condition on the left wall
    LGLnew(n1) = []; LGLnew(n1) = [];
    %% Boundary condition on the right wall
    LGLnew(n2-2) = []; LGLnew(n2-3) = [];
end