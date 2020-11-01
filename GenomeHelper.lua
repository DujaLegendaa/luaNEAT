local function printAllConnections(genome)
    io.write("----------CONNECTIONS----------", "\n")
    for _, conn in pairs(genome:getConnections()) do
        ConnectionGene.printConnectionGene(conn)
        io.write("\n")
    end
    io.write("-------------------------------", "\n")
end

local function printAllNodeGenes(genome)
    io.write("----------NODE GENES-----------", "\n")
    for _, nodeGene in pairs(genome:getNodeGenes()) do
        nodeGene.printNodeGene(nodeGene)
    end
    io.write("-------------------------------", "\n")
end

function PrintGenome(genome, name)
    io.write("########## ", name:upper(), " ##########", "\n")
    printAllNodeGenes(genome)
    printAllConnections(genome)
    io.write("##############################", "\n")
end

function Ternary ( cond , T , F )
    if cond then return T else return F end
end