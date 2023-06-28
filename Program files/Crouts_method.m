% usually to Find X in matrix equation AX = Y, we take inverse of A
% to get X = inv(A) * Y, which is very easy for small size matrix equations
% But For large size systems, taking inverse take very high computational
% power as well as takes a long time to give result. To overcome this, we use
% Linear System Solver(LSS) to perform calculations and get result, as the
% no. of equations to get solution also reduces drastically.

% we have our Coefficient Matrix and Parameter Vector in .CSV files

% Here, we are using LU Factorization using Crout's Method which will give 
% two new coefficient matrices: [L] and [U]. We will first find solution 
% for LB = Y, where B is an assumed vector. Then we will find UX = B. So,
% we can see our parameter is kept unchanged.

clear;

%% Asking for size of the system
n = input("Input the Size of the System: ");

%% reading the Coefficient file
filename = 'Coefficient Matrix.csv';
Coefficient_file = readtable(filename);
A = table2array(Coefficient_file(1:n,1:n)); %storing coefficient data upto n*n in A


%% reading the Parameter Vector file
filename = 'Parameter Vector.csv';
Parameter_file = readtable(filename);
Y = table2array(Parameter_file(1:n,1)); %storing Vector data upto n*1 in Y



%% Avoiding Pivoting
e = sum(sum(A))/(n^3);
for i = 1:(n-1)
    if abs(A(i,i)) < e
        k = i+1;
        t_A = A(i,:);
        A(i,:) = A(k,:);
        A(k,:) = t_A;
        t_Y = Y(i,:);
        Y(i,:) = Y(k,:);
        Y(k,:) = t_Y;
        i = k;
    end
end

%% LU factorization using Crout's method
L = zeros(n,n); % initially, L is a zero matrix
U = eye(n,n); % initially, U is an identity matrix
for i = 1:n
    for j =1:n
        sum = 0;
        if i<j
            for k = 1:i-1
                sum = sum + L(i,k)*U(k,j);
            end
            U(i,j) = (A(i,j) - sum)/L(i,i);
        else
            for k = 1:j-1
                sum = sum + L(i,k)*U(k,j);
            end
            L(i,j) = A(i,j) - sum;
        end
    end
end



%% Forward substitution -> LZ = Y
for i = 1:n
    sum = 0;
    for j = 1:i-1
        sum = sum + L(i,j)*Z(j,1);
    end
    Z(i,1) = (Y(i,1) - sum)/L(i,i);
end


%% Backward substitution -> UX = Z
for i = n:-1:1
    sum = 0;
    for j = n:-1:i+1
        sum = sum + U(i,j)*X(j,1);
    end
    X(i,1) = (Z(i,1) - sum)/U(i,i);
end


%% writing the new coefficient Matrices and complete Solution
filename = 'Result.xlsx';
delete(filename);
L = num2cell(L);
L = cellfun(@num2str , L, 'UniformOutput', false);
U = num2cell(U);
U = cellfun(@num2str , U, 'UniformOutput', false);
X = num2cell(X);
X = cellfun(@num2str , X, 'UniformOutput', false);
result = table(L,U,X);
writetable(result,filename);





