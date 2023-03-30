function x = Wtotel(W,n)
%% Function for assigning resultant displacements and rotations from global vector to element level 
    dim = n*4-(n-1)*2;
    W = [0;0;W;0;0];
    x = zeros(4,n);
    shift = 0;
    for i = 1:n
        for j = 1:4
            x(j,i) = W(j+shift);
        end
       shift = shift + 2; 
    end 
end