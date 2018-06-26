clear
clc

nds =  [64.0   19.0
 64.0  202.0
 70.0   25.0
 71.0   36.0
 72.0   39.0
 75.0   12.0
 76.0  223.0
 76.0  225.0
 79.0    9.0
 80.0   24.0
 84.0  214.0
 85.0   17.0];

ndsr = zeros(1,1);

for k = 1:10
    h = round(length(nds(:,1))/k)
    ndsr(k,1) = nds(h,1)
    ndsr(k,2) = nds(h,2)
end

adj = zeros(10,2);

for i = 1:10
    for j = 1:10
        
        if j == i+1 | j == i-1
            
            adj(i,j) = 1;
            
        end
    
    end
    
    
end
