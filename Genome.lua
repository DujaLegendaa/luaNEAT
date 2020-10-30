ConnectionGene = require("ConnectionGene")
NodeGene = require("NodeGene")

local Genome = {}

function ternary ( cond , T , F )
    if cond then return T else return F end
end

function Genome:new()
    self.nodeList = {
        NodeGene:new("INPUT", 1),
        NodeGene:new("OUTPUT", 2)
    }
    self.connections = {
        ConnectionGene:new(Genome.nodeList[1]:getId(), Genome.nodeList[2]:getId(), 0.3, true, 1)
    }
    return self
end

function Genome:addConectionMutation()
    math.randomseed(os.time())
    local node1 = self.nodeList[math.random(#self.nodeList)]
    local node2 = self.nodeList[math.random(#self.nodeList)]

    local reversed = false
    if (node1:getType() == NodeGene.TYPE["HIDDEN"] and node2:getType() == NodeGene.TYPE["INPUT"]) then
        reversed = true
    elseif (node1:getType() == NodeGene.TYPE["OUTPUT"] and node2:getType() == NodeGene.TYPE["HIDDEN"]) then
        reversed = true
    elseif (node1:getType() == NodeGene.TYPE["OUTPUT"] and node2:getType() == NodeGene.TYPE["INPUT"]) then
        reversed = true
    end

    local connectionExists = false
    for key, con in pairs(self.connections) do
        if (con:getInNode() == node1:getId() and con:getOutNode() == node2:getId()) then
            connectionExists = true
            break
        elseif (con:getInNode() == node2:getId() and con:getOutNode() == node1:getId()) then
            connectionExists = true
            break
        end
    end
    
    if connectionExists then
        return
    end
    local tempConnection = ConnectionGene:new(ternary(reversed, node2:getId(), node1:getId()), ternary(reversed, node1:getId(), node2:getId()),
                                        math.random(), true, 0)
    table.insert(self.connections, tempConnection)
end

function Genome:addNodeMutation() 
    local con = self.connections[math.random(#self.connections)]

    local inNode = self.nodeList[con:getInNode()]
    local outNode = self.nodeList[con:getOutNode()]

    con:disable()

    local newNode = NodeGene:new("HIDDEN", #self.nodeList + 1)
    local inToNew = ConnectionGene:new(inNode:getId(), newNode:getId(), 1, true, 0)
    local newToOut = ConnectionGene:new(newNode:getId(), outNode:getId(), con:getWeight(), true, 0)

    table.insert(self.nodeList, newNode)
    table.insert(self.connections, inToNew)
    table.insert(self.connections, newToOut)
end

local temp = Genome:new()
temp:addNodeMutation()

ConnectionGene.printConnectionGene(temp.connections[1])
ConnectionGene.printConnectionGene(temp.connections[2])
ConnectionGene.printConnectionGene(temp.connections[3])

