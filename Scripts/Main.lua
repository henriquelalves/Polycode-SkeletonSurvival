-- Made by Henrique Lacreta Alves
-- https://github.com/henriquelalves
-- 

-- Import
require "Scripts/Player"
require "Scripts/Wraith"

-- Scene initialization
scene = PhysicsScene2D(1.0, 60)
scene:setGravity(Vector2(0.0, -500.0))
scene:getDefaultCamera():setOrthoSize(320, 320)

-- Setting points and states variables
state = 1 -- 0 = intro, 1 = game, 2 = gameover
points = 0.0

-- Background
background = SceneImage("Resources/textures/background3.png")
scene:addChild(background)

-- Level initialization
level = SceneEntityInstance(scene, "Resources/entities/level.entity")
scene:addChild(level)

-- Walls
walls = level:getEntitiesByTag("wall", true)

for i=1,count(walls) do
	scene:trackPhysicsChild(walls[i], PhysicsScene2DEntity.ENTITY_RECT, true,0.1, 1, 0, false, false, -2)
end

-- Power bar
powerBar = SceneImage("Resources/textures/powerBar.png")
powerBar:setPosition(-152, 90)
powerBar:setAnchorPoint(Vector3(0.0,-1.0,0.0))
scene:addChild(powerBar)

-- Assembling player
-- Skull
skullBody = SceneImage("Resources/textures/skull.png")
scene:addPhysicsChild(skullBody, PhysicsScene2DEntity.ENTITY_CIRCLE, false, 0.1, 1, 0, false, false, -1)
--skullBody:setAnchorPoint(Vector3(0.0,-1.0,0.0))
--skullBody:setPosition(0,32)
skull = Player(scene, skullBody, powerBar)

-- Torso
skeletonBody = SceneImage("Resources/textures/skeletonTorso.png")
skeletonBody:setPosition(0,-32)
scene:addPhysicsChild(skeletonBody, PhysicsScene2DEntity.ENTITY_CIRCLE, false, 0.1, 1, 0, false, false, -1)
--skeletonBody:setAnchorPoint(Vector3(0.0,1.0,0.0))

-- Legs
skeletonLegs = SceneImage("Resources/textures/skeletonLegs.png")
skeletonLegs:setPosition(0,-62)
scene:addPhysicsChild(skeletonLegs, PhysicsScene2DEntity.ENTITY_RECT, false, 0.1, 1, 0, false, false, -1)

-- Arms
skeletonArmLeft = SceneImage("Resources/textures/skeletonArm.png")
skeletonArmLeft:setPosition(-16,-28)
scene:addPhysicsChild(skeletonArmLeft, PhysicsScene2DEntity.ENTITY_RECT,false, 0.1, 1, 0, false, false, -1)

skeletonArmRight = SceneImage("Resources/textures/skeletonArmInv.png")

skeletonArmRight:setPosition(16,-28)
scene:addPhysicsChild(skeletonArmRight, PhysicsScene2DEntity.ENTITY_RECT,false, 0.1, 1, 0, false, false, -1)

-- ASSSEEEEMMBLEEEEE
scene:createRevoluteJoint(skullBody, skeletonBody, 0, -16)
scene:createRevoluteJoint(skeletonBody, skeletonLegs, 0, -16)
scene:createRevoluteJoint(skeletonBody, skeletonArmLeft, -8,14)
scene:createRevoluteJoint(skeletonBody, skeletonArmRight, 8,14)

-- Wraiths

wraithBodies = level:getEntitiesByTag("wraith", true)
wraiths = {}

for i=1,count(wraithBodies) do
  local wraith = Wraith(scene, wraithBodies[i], skullBody)
  print(wraith)
  wraiths[i] = wraith
end

wraithTimer = 0.0

function Update(elapsed)

	if state == 0 then -- INTRO
		if Services.Input:getKeyState(KEY_UP) then
			state = 1
			points = 0.0
			--scene:setTransform(skullBody,Vector2(0, 0),0)
			skullBody:setPosition(0,32)
			skeletonLegs:setPosition(0,-62)
			skeletonBody:setPosition(0,-32)
			skeletonArmRight:setPosition(16,-28)
			skeletonArmLeft:setPosition(-16,-28)
		end
	elseif state == 1 then -- GAME
		-- Skull update
		skull:Update(elapsed)

		-- Wraith update
	  reviveWraith(elapsed)
	  for i=1,count(wraiths) do
	    wraiths[i]:Update()
	  end

		-- Points!
		points = points + elapsed

		-- Gameover?
		if (skullBody:getPosition().y < -180) then
			state = 2
		end
	else -- GAMEOVER
		labelgameover = SceneLabel("Score:", 32)
		labelgameover:setPosition(0,90)
		labelPoints = SceneLabel(tostring(points), 32)
		labelPoints:setPosition(0,0)
		scene:addChild(labelgameover)
		scene:addChild(labelPoints)
	end
end

function reviveWraith(elapsed)
  wraithTimer = wraithTimer + elapsed
  if wraithTimer > 0.6 then
    wraithTimer = 0
    for i=1,count(wraiths) do
      if(not wraiths[i].alive) then
        print(wraiths[i])
        wraiths[i]:Respawn()
        break
      end
    end
  end
end
