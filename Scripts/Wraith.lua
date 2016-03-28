class "Wraith"

function Wraith:Wraith(scene, body, player)
  self.scene = scene
  self.body = body
  self.alive = false
  self.player = player
  self.direction = false

  -- Setting phyisic body
  self.physicsBody = scene:trackPhysicsChild(body, PhysicsScene2DEntity.ENTITY_CIRCLE, false, 0.1, 1, 0, false, false, -2)
  --self.physicsBody:setTransform(Vector2(-100,0), 0)
  self.body:setPosition(-100,0)
end

function Wraith:Respawn()
  -- Set random direction and position
  self.alive = true
  self.direction = random(2) - 1
  local randomy = random(200)
  if(self.direction==1) then
    --self.body:setPositionX(-100)
    self.physicsBody:setTransform(Vector2(-400,-1*randomy),0)
    self.scene:setVelocityX(self.body, 500)
  else
    --self.body:setPositionX(100)
    self.physicsBody:setTransform(Vector2(-50,-1*randomy),0)
    self.scene:setVelocityX(self.body, -500)
  end

  if(self.player:getPosition().y > self.body:getPosition().y) then
    self.scene:setVelocityY(self.body, 90)
  else
    self.scene:setVelocityY(self.body, -90)
  end

end

function Wraith:Update()
  -- Move update
  if (self.alive) then
    if(self.direction==1) then
      self.scene:setVelocityX(self.body, 500)
    else
      self.scene:setVelocityX(self.body, -500)
    end

    if(self.player:getPosition().y > self.body:getPosition().y) then
      self.scene:setVelocityY(self.body, 90)
    else
      self.scene:setVelocityY(self.body, -90)
    end
  end
  -- Checks if out of screen
  if((self.direction == 1 and self.body:getPosition().x > 180) or (self.direction == 0 and self.body:getPosition().x < -180) or (self.body:getPosition().y<-180)) then
    self.alive = false
  end
end
