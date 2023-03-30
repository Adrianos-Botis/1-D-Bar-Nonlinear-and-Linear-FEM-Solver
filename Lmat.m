function [LV] =Lmat(q,DL)
%% Function for calculating the load vector of element
   for i = 1:4
     LFun = @(x)q*shape(x,DL,i);
     LV(i) = quadl(LFun,0,DL);
   end
   LV = LV';
end
