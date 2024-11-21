isSelecting = nil
isPlacing = false
local obj = nil
local heading = 0.0
local currentCoords = nil
local drawtext = false
local weedPlanting = false
RegisterNetEvent('ex_weed:createProp')
AddEventHandler('ex_weed:createProp', function()
  local playerPed = PlayerPedId()
  
  if weedPlanting or IsPedInAnyVehicle(playerPed) then
    return
  end
  weedPlanting = true
  obj = CreateObject(GetHashKey('bkr_prop_weed_01_small_01c'), GetEntityCoords(playerPed), 0, 0, 0)
  SetEntityHeading(obj, 0)
  SetEntityAlpha(obj, 100)
  drawtext = true
  CreateThread(function ()
      while obj ~= nil do
          Wait(1)
          DisableControlAction(0, 22, true)
          if not isPlacing then
              getSelection()
          end
          if currentCoords then
              SetEntityCoords(obj, currentCoords.x, currentCoords.y, currentCoords.z)
              if drawtext == true then
                DrawText3Ds(currentCoords.x, currentCoords.y, currentCoords.z, "[E] Постави [C] Отказ")
              end
          end
          if IsControlJustPressed(0, 38) then -- E
            TriggerServerEvent("ex_weed:plantSeed", currentCoords)
            stopSelecting()
            drawtext = false
            weedPlanting = false
            break
          end
          if IsControlJustPressed(0, 26) then -- C
              stopSelecting()
              drawtext = false
              weedPlanting = false
              break
          end
      end
  end)
end)

function cameraToWorld(flags, ignore)
  local coord = GetGameplayCamCoord()
  local rot = GetGameplayCamRot(0)
  local rx = math.pi / 180 * rot.x
  local rz = math.pi / 180 * rot.z
  local cosRx = math.abs(math.cos(rx))
  local direction = {
      x = -math.sin(rz) * cosRx,
      y = math.cos(rz) * cosRx,
      z = math.sin(rx)
  }
  local sphereCast = StartShapeTestSweptSphere(
      coord.x + direction.x,
      coord.y + direction.y,
      coord.z + direction.z,
      coord.x + direction.x * 200,
      coord.y + direction.y * 200,
      coord.z + direction.z * 200,
      0.2,
      flags,
      ignore,
      7
  );
  return GetShapeTestResult(sphereCast);
end

function getSelection()
  local retval, hit, endCoords, _, entityHit = cameraToWorld(1, obj)
  if hit then
      currentCoords = endCoords
  end
end

function stopSelecting()
  if obj then
      DeleteObject(obj)
  end
  isSelecting = nil
  currentCoords = nil
  isPlacing = false
end

function DrawText3Ds(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())

  SetTextScale(0.32, 0.32)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 255)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 500
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  if obj then
    DeleteObject(obj)
  end
end)
