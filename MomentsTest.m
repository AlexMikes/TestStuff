clear
clc

% function [M]= moments(I)
% I=double(I);
% [r c]=size(I);
% m=zeros(r,c);
% % geometric moments
% for i=0:1
%     for j=0:1
%         for x=1:r
%             for y=1:c
%                 m(i+1,j+1)=m(i+1,j+1)+(x^i*y^j*I(x,y));
%             end
%         end
%     end
% end

% xb=m(2,1)/m(1,1);
% yb=m(1,2)/m(1,1);
% % central moments
% u=[ 0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0];
% for i=0:3
%     for j=0:3
%         for x=1:r
%             for y=1:c
%                 u(i+1,j+1)=u(i+1,j+1)+(x-xb)^i*(y-yb)^j*I(x,y);
%             end
%         end
%     end
% end

gridValues = csvread('gridValues.csv');

gridValues = reshape(gridValues,[20,20,20]);

order = 1;

moments =zeros((order+1)^3,1);

ms = length(moments);

numGrid = 20;
grid = linspace(0,100,numGrid);
centroid = (max(grid) + min(grid)) / 2;

[x_dim y_dim z_dim] = size(gridValues);
vol = x_dim*y_dim*z_dim;

for o = 0:ms
    for i = 0:order
        for j = 0:order
            for k = 0:order
                for x = 1:x_dim
                    for y = 1:y_dim
                        for z = 1:z_dim
                            if gridValues(x,y,z) > 0
                                dx(x,y,z) = grid(x) - centroid;
                                dy(x,y,z) = grid(y) - centroid;
                                dz(x,y,z) = grid(z) - centroid;
                                %                                 m(x,y,z) = (dx(x,y,z)^i)*(dy(x,y,z)^j)*(dz(x,y,z)^k)*(gridValues(x,y,z)/vol);
                            end
                        end
                    end
                end
            end
        end
    end
    %moments(ms) = sum(m(:,y,z)
end


for o = 0:ms
    for i = 0:order
        for j = 0:order
            for k = 0:order
                moments(ms+1)= sum((dx(:,j+1,k+1)^i)*(dy(i+1,:,k+1)^j+1)*(dz(i+1,j+1,:)^k+1))
            end
        end
    end
end





%
% for o = 1:order+1
%     for m = 1:ms
%         for i=1:numGrid
%             for j=1:numGrid
%                 for k=1:numGrid
%                     if gridValues(i,j,k) > 0
%                         dxs(m,i) = grid(i) - centroid;
%                         dys(m,j) = grid(j) - centroid;
%                         dzs(m,k) = grid(k) - centroid;
%                         xs(m,i) = dxs(m,i)/vol;
%                         ys(m,j) = dys(m,j)/vol;
%                         zs(m,k) = dzs(m,k)/vol;
%                     end
%                 end
%             end
%         end
%         moments(m) = sum(xs(m)^(o)*ys(m)^(o)*zs(m)^(o));
%     end
% end