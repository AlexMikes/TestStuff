clear
clc

gridValues = csvread('gridValues.csv');

gridValues = reshape(gridValues,[20,20,20]);

order = 5;

moments =zeros((order+1)^3,1);

ms = length(moments);

numGridX = 20;
numGridY = 20;
numGridZ = 20;
gridX = linspace(0,100,numGridX);
gridY = linspace(0,100,numGridY);
gridZ = linspace(0,100,numGridZ);

centroidX = (max(gridX) + min(gridX)) / 2;
centroidY = (max(gridY) + min(gridY)) / 2;
centroidZ = (max(gridZ) + min(gridZ)) / 2;

[x_dim y_dim z_dim] = size(gridValues);
vol = x_dim*y_dim*z_dim;

m = zeros(ms,ms,ms);

u = zeros(order+1,order+1,order+1);

for i = 0:order
    for j = 0:order
        for k = 0:order
            for x = 1:x_dim
                for y = 1:y_dim
                    for z = 1:z_dim
                        if gridValues(x,y,z) > 0
                            u(i+1,j+1,k+1) = u(i+1,j+1,k+1) + (((gridX(x)-centroidX)^i)*((gridY(y)-centroidY)^j)*(gridZ(z)-centroidZ)^k)*(gridValues(x,y,z)/vol);
                        end
                    end
                end
            end
        end
    end
end