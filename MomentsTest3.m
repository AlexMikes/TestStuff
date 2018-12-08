clear
clc

topOptRead = csvread('top3d_result.csv');

topOptRead = reshape(topOptRead,[10,30,2]);

order = 1;

numVoxels = 20
numMoments = zeros((order+1)^3)

moments = zeros(order+1,order+1,order+1)

minCoord = [0.0 0.0 0.0]
maxCoord = [10.0 30.0 2.0]

numGridX = (maxCoord(1)-minCoord(1))*numVoxels
numGridY = (maxCoord(2)-minCoord(2))*numVoxels
numGridZ = (maxCoord(3)-minCoord(3))*numVoxels

gridX = minCoord(1):1/length(numGridX):numGridX
gridY = minCoord(2):1/length(numGridY):numGridY
gridZ = minCoord(3):1/length(numGridZ):numGridZ



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

[x_dim y_dim z_dim] = size(topOptRead);
vol = x_dim*y_dim*z_dim;

m = zeros(ms,ms,ms);

u = zeros(order+1,order+1,order+1);

for i = 0:order
    for j = 0:order
        for k = 0:order
            for x = 1:x_dim
                for y = 1:y_dim
                    for z = 1:z_dim
                        if topOptRead(x,y,z) > 0
                            u(i+1,j+1,k+1) = u(i+1,j+1,k+1) + (((gridX(x)-centroidX)^i)*((gridY(y)-centroidY)^j)*(gridZ(z)-centroidZ)^k)*(topOptRead(x,y,z)/vol);
                        end
                    end
                end
            end
        end
    end
end