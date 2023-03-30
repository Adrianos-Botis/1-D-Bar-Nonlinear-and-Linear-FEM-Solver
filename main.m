%% Computational Mechanics clamped-clamped beam
clear all
clc
%% Main script for solving the linear and non linear problems
%%  Beam Properties 
EA = 10^5;      % Young's modulus times area of beam
EI = 10^2;      % Young's modulus times moment of area 
L = 1;          % Lenght of beam
m = 5;          % Multiplication factor for q
q = m*10^3;     % Vertical force per unit length magnitude
%%  Linear Solver
n = 20;        % Number of elements
DL = L/n;      % Length of element

% Global stiffness matrix Creation from local stiffness and assembly in KGlobal.m function
KG = KGlobal(n,DL,EI);

% Reduction of global stiffness matrix from constraints
lnode = 1;              % nodes with B.C.s
rnode = n*4-(n-1)*2;    % nodes with B.C.s

% Reduction of global stiffness matrix in KGlobBCs.m fuction
KGreduced = KGlobBCs(lnode,rnode, KG); 

% Global Force vector from local force vectors and assembly in LGlobal.m function
LG = LGlobal(n,q,DL);

% Reduction of global load vector from constraints in LGlobBCs.m Function
LGL = LGlobBCs(lnode,rnode,LG);

% System solution
tic
RHOE = linsolve(KGreduced,LGL);
toc
% Deflection Calculation
Wofel = Wtotel(RHOE,n);     % Calling function Wtotel for defining deformations for each element
xel = [0:0.0001:DL];         % vector with x coordinates 
Wt = zeros(length(xel),n);   
Wtotal = [];

% Creating the vector Wtotal which contains the whole displacement field
% through the length of the beam
for j = 1:n
    rhoe = Wofel(:,j);
    W = Wel(rhoe,DL);
    for i = 1:length(xel)
        y = feval(W,xel(i));
        Wt(i,j) =  y;
    end
    Wtotal = [ Wtotal ;Wt(:,j)];
end
dxel = L/length(Wtotal);
xtot = [0:dxel:L-dxel];
%% Non-Linear solver

% Initial deformations equal to the linear solution for faster convergence
Rhoen = RHOE;   % Initial solution of displacement vector
Nit = 50;       % Maximum iterations for the Newton-Rapshon method

% Non-linear function solve
tic 
[Rhoenl,its] = Nonlinearsolve(n,Nit, Rhoen, KGreduced, LGL, EA, DL, lnode, rnode);
toc

% Deflection Calculation
Wofeln = Wtotel(Rhoenl(:,end),n);
xeln = [0:0.0001:DL];
Wtn = zeros(length(xeln),n);
Wtotaln = [];
for j = 1:n
    rhoenew = Wofeln(:,j);
    Wn = Wel(rhoenew,DL);
    for i = 1:length(xeln)
        y = feval(Wn,xeln(i));
        Wtn(i,j) =  y;
    end
    Wtotaln = [ Wtotaln ;Wtn(:,j)];
end
dxeln = L/length(Wtotaln);
xtotn = [0:dxeln:L-dxeln];
%%  Analytical Solution
dx = 0.001;                  % Discretisation                               
x = [0:dx:L];                % x vector
W_x = (q/(24*EI))*(x.^2)...  % Analytical solution
.*(L^2 - 2*L*x + x.^2);
%% Peak values for different loads with converged results
WmaxL  = [0, 0.013, 0.026, 0.0521, 0.1302];
WmaxNL = [0, 0.0128, 0.0247, 0.0445, 0.0827];
ReW    = 100*(WmaxL-WmaxNL)./WmaxNL;
ReW(1) = 0;
Qv     = [0, 0.5, 1, 2, 5];
WmaxE  = [1.234, 0.0152, 7.67e-04, 1.73e-05, 3e-06, 1.5e-07];
Nele   = [3, 9,19, 49, 99, 199];
Nelt   = [10, 50, 100, 200, 300];
%% Plotting results
figure()
plot(x,W_x, 'LineWidth', 1.5)
hold on
plot(xtot,Wtotal, '-.','LineWidth',1.5)
xlabel('x[m]')
ylabel('w[m]')
legend('Analytical', 'Linear');
grid on
grid minor
figure()
plot(xtot,Wtotal)
figure()
%title('Displacement fields for linear vs non-linear solutions for q = 5 kN/m') 
xlabel('x[m]')
ylabel('w[m]')
% plot(x,W_x,'g' ,'LineWidth', 1.5)
% hold on
plot(xtot, Wtotal,'r', 'LineWidth', 1.5)
hold on
plot(xtotn, Wtotaln,'b','LineWidth', 1.5)
legend('Linear', 'Non-linear')
grid on
grid minor
figure()
plot(Qv, WmaxL, '-o', 'LineWidth', 1.5)
hold on
plot(Qv, WmaxNL,'-s' , 'LineWidth', 1.5)
xlabel('W_{max} [m]')
ylabel('q [kN/m]')
legend('Linear', 'Non-Linear')
grid on
grid minor
xlim([0 6.5])
figure()
loglog(Nele, WmaxE,'LineWidth', 1.5)
xlabel('Number of elements')
ylabel('Relative Error %')
grid on 
grid minor
figure()
plot(Qv,ReW, '-o','LineWidth', 1.5)
ylabel('Relative Error %')
xlabel('q [kN/m]')
grid on
grid minor
xlim([0 6.5])