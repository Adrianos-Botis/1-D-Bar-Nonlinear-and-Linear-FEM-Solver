function FGgl = FgeomG(rho, n, EA, DL)
%% Function for calculating the global non-linear vector
    dim = n*4 - (n-1)*2;
    L1 = zeros(4,n);
    for i = 1:n
       L1(:,i) = Fgeom(rho(:,i),EA,DL);
    end
    LG = zeros(dim,n);
    shift = 0;
    for i = 1:n
        for j = 1:4
            LG(j + shift,i) = L1(j,i);
        end
        shift = shift + 2;
    end
    FGgl = zeros(dim,1);
    for i = 1:n
        FGgl = FGgl + LG(:,i);
    end
end