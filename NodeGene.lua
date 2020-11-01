local NodeGene = {
    TYPE = {INPUT = 1, HIDDEN = 2, OUTPUT = 3,}}
NodeGene.__index = NodeGene

function NodeGene:new (type, id)
    local self = setmetatable({}, NodeGene)
    self.type = NodeGene.TYPE[type]
    self.id = id
    return self
end

function NodeGene:getType()
    return self.type
end

function NodeGene:getId()
    return self.id
end

function NodeGene:copy()
    return NodeGene:new(self.type, self.id)
end

function NodeGene.printNodeGene(nodeGene)
    local revTYPE = {"INPUT","HIDDEN","OUTPUT"}
    io.write("Type: ", revTYPE[nodeGene:getType()], "\n")
    io.write("ID:   ", nodeGene:getId(), "\n")
end

return NodeGene