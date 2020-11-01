ConnectionGene = require("ConnectionGene")
NodeGene = require("NodeGene")
require("Set")
require("GenomeHelper")

local Genome = {}
Genome.__index = Genome

function Genome:new()
    local self = setmetatable({}, Genome)
    self.nodeList = {}
    self.connections = {}
    return self
end


function Genome:getNodeGenes()
    return self.nodeList
end

function Genome:getConnections()
    return self.connections
end

function Genome:addNodeGene(nodeGene)
    table.insert(self.nodeList, nodeGene)
end

function Genome:addConnection(connection)
    table.insert(self.connections, connection)
end

function Genome:addConnectionMutation(maxAttempts)
    local tries = 0
    local success = false
    while (tries < maxAttempts and success == false) do
        math.randomseed(os.time())
        local node1 = self.nodeList[math.random(#self.nodeList)]
        local node2 = self.nodeList[math.random(#self.nodeList)]

        local reversed = false
        if (node1:getType() == NodeGene.TYPE.HIDDEN and node2:getType() == NodeGene.TYPE.INPUT) then
            reversed = true
        elseif (node1:getType() == NodeGene.TYPE.OUTPUT and node2:getType() == NodeGene.TYPE.HIDDEN) then
            reversed = true
        elseif (node1:getType() == NodeGene.TYPE.OUTPUT and node2:getType() == NodeGene.TYPE.INPUT) then
            reversed = true
        end

        local connectionImpossible = false
        if (node1:getType() == NodeGene.TYPE.INPUT and node2:getType() == NodeGene.TYPE.INPUT) then
            connectionImpossible = true
        elseif (node1:getType() == NodeGene.TYPE.OUTPUT and node2:getType() == NodeGene.TYPE.OUTPUT) then
            connectionImpossible = true
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
        
        if (connectionExists or connectionImpossible) then
            tries = tries + 1
        else 
            local tempConnection = ConnectionGene:new(Ternary(reversed, node2:getId(), node1:getId()), Ternary(reversed, node1:getId(), node2:getId()),
                                            math.random(), true, 0)
            table.insert(self.connections, tempConnection)
            success = true
        end
    end
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

function Genome.crossover(genome1, genome2)
    local child = Genome:new()
    for key, parent1Node in pairs(genome1:getNodeGenes()) do
        child:addNodeGene(parent1Node)
    end

    for _, parent1Connection in pairs(genome1:getConnections()) do
        for _, parent2Connection in pairs(genome2:getConnections()) do
            if parent1Connection:getInn() == parent2Connection:getInn() then
                local childConGene = Ternary(math.random(0, 1), parent1Connection:copy(), parent2Connection:copy())
                child:addConnection(childConGene)
            else
                local childConGene = parent1Connection:copy()
                child:addConnection(childConGene)
            end
        end
    end

    return child
end



