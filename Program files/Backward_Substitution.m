% usually to Find X in matrix equation AX = Y, we take inverse of A
% to get X = inv(A) * Y, which is very easy for small size matrix equations
% But For large size systems, taking inverse take very high computational
% power as well as takes a long time to give result. To overcome this, we use
% Linear System Solver(LSS) to perform calculations and get result, as the
% no. of equations to get solution also reduces drastically.

% we have our Coefficient Matrix and Parameter Vector in .CSV files

% Here, we are using Back substitution which will give us a new coefficient 
% matrix which will be in a form of upper triangular matrix, along with new
% coefficient matrix, our Parameter input file will also change.

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


%% Calculating using Backward Substitution
for j = 1:n
    for i = j+1:n
        Y(i,1) = Y(i,1) - (A(i,j)/A(j,j)).*Y(j,1); % Updating i^th element in Y
        A(i,:) = A(i,:) - (A(i,j)/A(j,j)).*A(j,:); % Updating i^th row in A
    end
end


%% Comupting Final Solution
for i = n:-1:1
    sum = 0;
    for j = n:-1:i+1
        sum = sum + A(i,j)*X(j,1);
    end
    X(i,1) = (Y(i,1) - sum)/A(i,i);
end

%% writing the new coefficient Matrix, new parameter Vector and complete Solution
filename = 'Result.xlsx';
delete(filename);
A = num2cell(A);
A = cellfun(@num2str , A, 'UniformOutput', false);
X = num2cell(X);
X = cellfun(@num2str , X, 'UniformOutput', false);
Y = num2cell(Y);
Y = cellfun(@num2str , Y, 'UniformOutput', false);
result = table(A,X,Y);
writetable(result,filename);




