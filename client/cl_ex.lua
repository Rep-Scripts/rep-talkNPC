RegisterCommand("testnpc", function()
	local npc = exports['rep-talkNPC']:CreateNPC({
		npc = 'u_m_y_abner',
		coords =  GetEntityCoords(PlayerPedId()) - vector3(0.5, 0.5, 1.0),
		heading = 160.0,
		name = 'Hưng Ngố',
		animName ="mini@strip_club@idles@bouncer@base",
		animDist = "base",
        startMSG = 'Xin chào, tôi là lập trình viên Front End'
	}, {
        {label = "Bạn tên là gì", value = 1},
        {label = "Hưng bao nhiêu tuổi?", value = 2},
        {label = "Tôi có thể đấm bạn được không?", value = 3},
    }, function(ped, data, menu)
        Boss = ped -- To delete ped when source stop
        if data then
            if data.value == 1 then
                menu.addMessage({msg = "Tôi tên là Hưng. Mọi người hay gọi tôi là Hưng Ngố", from = "npc"})
            elseif data.value == 2 then
                menu.addMessage({msg = "Tôi 20 tuổi", from = "npc"})
                Wait(1000)
                menu.addMessage({msg = "Hiện tại tôi đang là một sinh viên IT", from = "npc"})
            elseif data.value == 3 then
                menu.addMessage({msg = "Cút đi", from = "npc"})
                Wait(1000)
                menu.close()
            end
        end
    end)
end)
