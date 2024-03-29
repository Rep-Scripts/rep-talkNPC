local NPC = {}
local npcId = 0
local currentNPC = nil
local cam
local camRotation
local interect = false

local function CreateCam()
    local px, py, pz = table.unpack(GetEntityCoords(currentNPC.npc, true))
    local x, y, z = px + GetEntityForwardX(currentNPC.npc) * 1.2, py + GetEntityForwardY(currentNPC.npc) * 1.2, pz + 0.52
    local rx = GetEntityRotation(currentNPC.npc, 2)
    camRotation = rx + vector3(0.0, 0.0, 181.0)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, camRotation, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, 1, 1)
end

local function talkNPC(id)
    for k, v in pairs(NPC) do
        if id == v.npc then
            currentNPC = v
            CreateCam()
            interect = true
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = 'show',
                msg = v.startMSG,
                from = "npc",
                elements = v.elements,
                npcName = v.name
            })
        end
    end
end

local function CreateNPC(data, elements, cb)
    npcId = npcId + 1
    RequestModel(GetHashKey(data.npc))
    while not HasModelLoaded(GetHashKey(data.npc)) do
        Wait(1)
    end
    local ped = CreatePed(0, GetHashKey(data.npc), data.coords.x, data.coords.y, data.coords.z, data.heading, false, true)
    SetEntityHeading(ped, data.heading)
	SetPedFleeAttributes(ped, 0, 0)
    SetPedDiesWhenInjured(ped, false)
    SetPedKeepTask(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    RequestAnimDict(data.animName)
    TaskLookAtEntity(ped, PlayerPedId(), -1, 2048, 3)
    SetModelAsNoLongerNeeded(GetHashKey(data.npc))
	while not HasAnimDictLoaded(data.animName) do
		Wait(1)
	end
    TaskPlayAnim(ped, data.animName, data.animDist, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    exports[Config.Target]:AddTargetEntity(ped, {
        options = {
                    {
                        type = "client",
                        action = function(entity)
                            talkNPC(entity)
                        end,
                        icon = "fas fa-user-friends",
                        label = Config.Talk:format(data.name)
                    },
                },
        distance = 3.0,
    })
    NPC[#NPC+1] = {
        id = npcId,
        npc = ped,
        resource = GetInvokingResource(),
        coords = data.coords,
        name = data.name,
        startMSG = data.startMSG or 'Hello',
        elements = elements,
        cb = cb
    }
    NPC[#NPC].cb(ped)
end

RegisterNUICallback('close', function()
    currentNPC = nil
    interect = false
    SetNuiFocus(false, false)
    ClearFocus()
	RenderScriptCams(false, true, 1000, true, false)
	DestroyCam(cam, false)
	SetEntityAlpha(PlayerPedId(), 255, false)
	cam = nil
end)

RegisterNUICallback('click', function(data)
    SetPedTalk(currentNPC.npc)
    currentNPC.cb(currentNPC.npc ,data, {
        ['close'] = function(...)
            SetNuiFocus(false, false)
            ClearFocus()
            RenderScriptCams(false, true, 1000, true, false)
            DestroyCam(cam, false)
            SetEntityAlpha(PlayerPedId(), 255, false)
            cam = nil
            currentNPC = nil
            interect = false
            SendNUIMessage({
                type = 'close',
            })
        end,
        ['addMessage'] = function(data)
            SendNUIMessage({
                type = 'addmsg',
                msg = data.msg,
                from = data.from,
            })
        end,
        ['updateMenu'] = function(data)
            SendNUIMessage({
                type = 'updatemenu',
                elements = data.elements,
            })
        end
    })
end)


exports('CreateNPC', function(...)
    CreateNPC(...)
end)

CreateThread(function ()
    while true do
        if currentNPC and interect == true then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            if #(pos - currentNPC.coords) > 5 then
                SetNuiFocus(false, false)
                ClearFocus()
                RenderScriptCams(false, true, 1000, true, false)
                DestroyCam(cam, false)
                SetEntityAlpha(PlayerPedId(), 255, false)
                cam = nil
                currentNPC = nil
                interect = false
                SendNUIMessage({
                    type = 'close',
                })
            end
        end
        Wait(500)
    end
end)

AddEventHandler('onClientResourceStop', function(resource)
   for k, v in pairs(NPC) do
        if v.resource == resource then
            DeleteEntity(v.npc)
            table.remove(NPC, k)
        end
   end
end)