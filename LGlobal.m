function [LGL] = LGlobal(n,q,DL)
%% Function for combining the load vectors of each element to assemble the global load vector
dim = n*4 - (n-1)*2;   
L1 = zeros(4,n);
    for i = 1:n
       L1(:,i) = Lmat(q,DL);
    end
    LG = zeros(dim,n);
    shift = 0;
    for i = 1:n
        for j = 1:4
            LG(j + shift,i) = L1(j,i);
        end
        shift = shift + 2;
    end
    LGL = zeros(dim,1);
    for i = 1:n
        LGL = LGL + LG(:,i);
    end
end