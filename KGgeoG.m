function KGgl = KGgeoG(rho,n, DL,EA)
%% Function for calculating each element's geometric stiffness matrix and assembling the global geometric stiffnes matrix
dim = n*4 - (n-1)*2;
kloc = zeros(4,4,n);
stepp = 2;
    for i = 1:n
        kloc(:,:,i)=Kgeom(rho(:,i),EA,DL); 
    end
    shift = 0;
    GlobalStiffness = zeros(dim,dim,n);
    for k = 1:n
      for i = 1:4
        for j = 1:4
         GlobalStiffness(i+shift,j+shift,k) = kloc(i,j,k);
        end
      end
       shift = shift + stepp;
    end
    KGgl = zeros(dim,dim);
    for m = 1:n
        KGgl = KGgl + GlobalStiffness(:,:,m);
    end
end