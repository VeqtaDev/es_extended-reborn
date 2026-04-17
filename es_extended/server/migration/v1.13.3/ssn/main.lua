local esxVersion = "v1.13.3"

Core.Migrations = Core.Migrations or {}
Core.Migrations[esxVersion] = Core.Migrations[esxVersion] or {}

if GetResourceKvpInt(("esx_migration:%s"):format(esxVersion)) == 1 then
  return
end

---@return boolean restartRequired
Core.Migrations[esxVersion].ssn = function()
  print("^4[esx_migration:v.1.13.3:ssn]^7 SSN migration disabled by configuration.")
  return true
end
