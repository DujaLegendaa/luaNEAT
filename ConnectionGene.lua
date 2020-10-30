local ConnectionGene = {}
ConnectionGene.__index = ConnectionGene

function ConnectionGene:new (inNode, outNode,
                            weight, expressed, inn)
    local self = setmetatable({}, ConnectionGene)
    self.inNode = inNode
    self.outNode = outNode
    self.weight = weight
    self.expressed = expressed
    self.inn = inn
    return self
end

function ConnectionGene:getInNode()
    return self.inNode
end

function ConnectionGene:getOutNode()
    return self.outNode
end

function ConnectionGene:disable()
    self.expressed = false
end

function ConnectionGene:getWeight()
    return self.weight
end

function ConnectionGene.printConnectionGene(connectionGene)
    io.write("In Node: ", tostring(connectionGene.inNode), "\n")
    io.write("Out Node: ", tostring(connectionGene.outNode), "\n")
    io.write("Weight: ", connectionGene.weight, "\n")
    io.write("Expressed: ", tostring(connectionGene.expressed), "\n")
    io.write("Inn: ", connectionGene.inn, "\n")
    io.write("\n")
end

return ConnectionGene