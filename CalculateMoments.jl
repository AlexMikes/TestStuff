using GraphSynth#, GLVisualize, GLWindow, GeometryTypes, GLAbstraction

function CalculateMoments(g::GraphSynth.Graph, minCoord::Array{Float64,1},maxCoord::Array{Float64,1}, order::Int64, numVoxels::Int64)

    moments = zeros(maxCoord[1],maxCoord[2],maxCoord[3],order+1,order+1,order+1)

    for i = 0:order
        for j = 0:order
            for k = 0:order
                for x = 0:convert(Int64,maxCoord[1]-1)
                    for y = 0:convert(Int64,maxCoord[2]-1)
                        for z = 0:convert(Int64,maxCoord[3]-1)
                            o = [x,y,z]*5.0
                            moments[x+1,y+1,z+1,i+1,j+1,k+1] = CalculateCellMoments(g,o,numVoxels,order)
                        end
                    end
                end
            end
        end
    end

    return moments

end

function CalculateCellMoments(g::GraphSynth.Graph, origin::Array{Float64,1}, numVoxels::Int64, order::Int64)

    numMoments = (order+1)^3

    cellMoments = zeros(order+1,order+1,order+1)

    # numGridX = 20
    # numGridY = 20
    # numGridZ = 20

    # numGridX = (maxCoord[1]-minCoord[1])*numVoxels
    # numGridY = (maxCoord[2]-minCoord[2])*numVoxels
    # numGridZ = (maxCoord[3]-minCoord[3])*numVoxels

    numGridX = numVoxels
    numGridY = numVoxels
    numGridZ = numVoxels

    gridX = origin[1]:1/length(numGridX):numGridX
    gridY = origin[2]:1/length(numGridY):numGridY
    gridZ = origin[3]:1/length(numGridZ):numGridZ



    centroidX = (origin[1]+numVoxels) / 2
    centroidY = (origin[2]+numVoxels) / 2
    centroidZ = (origin[3]+numVoxels) / 2

    # x_dim = size(gridValues,1);
    # y_dim = size(gridValues,2);
    # z_dim = size(gridValues,3);
    # vol = x_dim*y_dim*z_dim;

    coords = collect(Iterators.product(1:numVoxels,1:numVoxels,1:numVoxels))

    for i = 0:order
        for j = 0:order
            for k = 0:order
                for x = 1:convert(Int64,numGridX)
                    for y = 1:convert(Int64,numGridY)
                        for z = 1:convert(Int64,numGridZ)
                            # for a in coords[:]
                            c = origin + collect(coords[x,y,z])
                            if g.displayShape([Float64(c[1]),Float64(c[2]),Float64(c[3])],g) > 0
                                cellMoments[i+1,j+1,k+1] = cellMoments[i+1,j+1,k+1] + (((gridX[x]-centroidX)^i)*((gridY[y]-centroidY)^j)*(gridZ[z]-centroidZ)^k)#*(gridValues[x,y,z]/vol)
                                println(c)
                                println(g.displayShape([Float64(c[1]),Float64(c[2]),Float64(c[3])],g))
                                println(i,j,k)
                                println(x," ",y," ",z," ")
                            end
                            # end
                        end
                    end
                end
            end
        end
    end

    return cellMoments

end
