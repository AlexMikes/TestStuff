using CSV

apriori = CSV.read("ApriTest2.csv")

testCase = CSV.read("testCase.csv")




name = apriori[1]
funcs = apriori[2]
confidence = apriori[3]
lift = apriori[4]
support = apriori[5]

# rep = falses(length(name))

for i in range(2,length(testCase[1]))
    if name[i] == name[i-1]
        # rep[i] = true
    end
end

lastName = "start"
testName = Array{String}(length(testCase[1]))
for i in range(1,length(testCase[1]))
    testName[i] = testCase[1][i]
end

givenFunc = Array{String}(length(testName))
for i in range(1,length(testName))
    givenFunc[i] = "empty"
end


for j in range(1,length(testName))
    for i in range(1,length(name))

        if testName[j] == name[i]
            if lastName!= name[i]
                println("j = ", j, ", i = ",i,", name = ",name[i])
                givenFunc[j] = funcs[i]
                lastName = name[i]
            end
            # elseif lastName == name[i]
            #     givenFunc[j] = funcs

        end
    end


end



givenFunc
testCase[1]



combined = Array{String}(length(testCase[1]),2)

for i in range(1,length(testCase[1]))

    combined[i,1] = testName[i]
    combined[i,2] = givenFunc[i]




end

combined
