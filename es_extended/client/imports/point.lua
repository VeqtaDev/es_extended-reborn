local Point = ESX.Class()

local nearby, nearbyCount, loop = {}, 0, nil

function Point:constructor(properties)
	self.coords = properties.coords
	self.hidden = properties.hidden
	self.enter = properties.enter
	self.leave = properties.leave
	self.inside = properties.inside
	self.handle = ESX.CreatePointInternal(properties.coords, properties.distance, properties.hidden, function()
		if not nearby[self.handle] then
			nearby[self.handle] = self
			nearbyCount = nearbyCount + 1
		end

		if self.enter then
			self:enter()
		end
		if not loop then
			loop = true
			CreateThread(function()
				while loop do
					local coords = GetEntityCoords(ESX.PlayerData.ped)
					for _, point in pairs(nearby) do
						if point.inside then
							point:inside(#(coords - point.coords))
						end
					end
					Wait(0)
				end
			end)
		end
	end, function()
		if nearby[self.handle] then
			nearby[self.handle] = nil
			nearbyCount = nearbyCount - 1
		end

		if self.leave then
			self:leave()
		end

		if nearbyCount <= 0 then
			nearbyCount = 0
			loop = false
		end
	end)
end

function Point:delete()
	ESX.RemovePointInternal(self.handle)
end

function Point:toggle(hidden)
	if hidden == nil then
		hidden = not self.hidden
	end
	self.hidden = hidden
	ESX.HidePointInternal(self.handle, hidden)
end

return Point