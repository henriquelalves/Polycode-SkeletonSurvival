-- Class initialization
class "Player"

function Player:Player(scene, playerBody, powerBar)
	self.scene = scene
	self.body = playerBody
	self.powerBar = powerBar

	self.power = 100.0

	self.dead = false

	-- Movement related variables
	self.moveDirX = 0.0
	self.moveDirY = 0.0

end

function Player:Update(elapsed)
	-- Move player
	self.moveDirX = 0.0
	self.moveDirY = 0.0

	if Services.Input:getKeyState(KEY_LEFT) then
		self.moveDirX = -1.0
	end

	if Services.Input:getKeyState(KEY_RIGHT) then
		self.moveDirX = 1.0
	end

	if Services.Input:getKeyState(KEY_UP) and self.power > 0 then
		self.power = self.power - 0.5
		self.moveDirY = 1.0
		self.powerBar:setScaleY(self.power/100.0)
	elseif self.power < 100.0 then
		self.power = self.power + 0.4
		self.powerBar:setScaleY(self.power/100.0)
	end

	if Services.Input:getKeyState(KEY_DOWN) then
		self.moveDirY = -1.0
	end

	--self.scene:setVelocityX(self.body, self.moveDirX*50)
	--self.scene:setVelocityY(self.body, self.moveDirY*50)
	self.scene:applyImpulse(self.body, self.moveDirX*50000, self.moveDirY*50000)

end
