function [ euclid,class ] = euclideanDist( x,y,n )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

sumOfData = 0;
kolomKelas = n+1;

for i= 1:n
    distance = (x(1,i)-y(1,i))^2;
    sumOfData = sumOfData + distance;
end

euclid = sqrt(sumOfData);
class = x(1,kolomKelas);

end

