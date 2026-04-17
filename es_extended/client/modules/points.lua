local points = {}
local pointsCount = 0
local pointsLoopStarted = false

function ESX.CreatePointInternal(coords, distance, hidden, enter, leave)
	local point = {
		coords = coords,
		distance = distance,
		hidden = hidden,
		enter = enter,
		leave = leave,
		resource = GetInvokingResource()
	}
	local handle = ESX.Table.SizeOf(points) + 1
	points[handle] = point
	pointsCount = pointsCount + 1
	return handle
end

function ESX.RemovePointInternal(handle)
	if points[handle] then
		points[handle] = nil
		pointsCount = math.max(0, pointsCount - 1)
	end
end

function ESX.HidePointInternal(handle, hidden)
	if points[handle] then
		points[handle].hidden = hidden
	end
end

function StartPointsLoop()
	if pointsLoopStarted then
		return
	end

	pointsLoopStarted = true

	CreateThread(function()
		while true do
			local sleep = 1500
			local ped = ESX.PlayerData.ped

			if ESX.PlayerLoaded and ped and pointsCount > 0 and DoesEntityExist(ped) then
				sleep = 500
				local coords = GetEntityCoords(ped)
				for handle, point in pairs(points) do
					if not point.hidden and #(coords - point.coords) <= point.distance then
						if not point.nearby then
							points[handle].nearby = true
							points[handle].enter()
						end
					elseif point.nearby then
						points[handle].nearby = false
						points[handle].leave()
					end
				end
			end

			Wait(sleep)
		end
	end)
end


AddEventHandler('onResourceStop', function(resource)
	for handle, point in pairs(points) do
		if point.resource == resource then
			points[handle] = nil
			pointsCount = math.max(0, pointsCount - 1)
		end
	end
end)