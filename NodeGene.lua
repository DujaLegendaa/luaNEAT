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

return NodeGene