local lib = nil
if (love ~= nil) then
  lib = love
elseif (lutro ~= nil) then
  lib = lutro
end

-- Load
function lib.load()
		games = {}


	table.insert(games, 1, {
		slug = '',
    flags = '',
		name = 'Launch x',
	})

	table.insert(games, {
		slug = [[""C:\Program Files (x86)\Steam\Steam.exe""]],
    flags = [[-start steam://open/bigpicture]],
		name = 'Launch Steam BigPicture',
	})

  table.insert(games, {
    slug = [[""C:\Program Files (x86)\Steam\Steam.exe""]],
    flags = [[]],
    name = 'Launch Steam',
  })


	-- Allow the user to quit.
	table.insert(games, {
		slug = 'quit',
		name = 'Quit Lutris Launcher',
	})

	-- Initialization
	if (lutro ~= nil) then
		font = lutro.graphics.newImageFont("resources/sofia24.png",
		" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
		lib.graphics.setFont(font)
	else
		font = love.graphics.newFont(24)
		lib.graphics.setFont(font)
	end

	-- Background
	lib.graphics.setBackgroundColor(1, 53, 146)
	bg = lib.graphics.newImage("resources/bg.png")

	-- Sounds
	soundBackground = lib.audio.newSource("resources/bgmusic.wav", "stream")
	soundBackground:setVolume(0.1)
	soundBackground:setLooping(true)
	soundFocus = lib.audio.newSource("resources/focus.wav", "static")
	soundSelect = lib.audio.newSource("resources/select.wav", "static")
	lib.audio.play(soundBackground)

	-- Settings
	lineHeight = 30
	currentSelection = 1

	logo = lib.graphics.newImage('resources/logo.png')
end

-- Draw
function lib.draw()
	lib.graphics.clear()
	lib.graphics.draw(bg, 0, 0)
	lib.graphics.draw(logo, lineHeight, lineHeight)

	-- Show each game.
	local y = lineHeight * 4
	for i, game in ipairs(games) do
		-- Display the menu cursor if needed
		if currentSelection == i then
			lib.graphics.rectangle('fill', 256 + lineHeight * 2, y + lineHeight / 4, lineHeight / 3, lineHeight / 3)
		end
		-- Display the menu item
		lib.graphics.print(game.name, 256 + lineHeight * 3, y)
		y = y + lineHeight
	end
end

-- Process input
function lib.keypressed(key)
	if key == "down" then
		currentSelection = currentSelection + 1
		if currentSelection > table.getn(games) then
			currentSelection = table.getn(games)
		end
		lib.audio.play(soundFocus)
		soundBackground:setVolume(0.1)
	elseif key == "up" then
		currentSelection = currentSelection - 1
		if currentSelection < 1 then
			currentSelection = 1
		end
		lib.audio.play(soundFocus)
		soundBackground:setVolume(0.1)
	elseif key == "return" or key == "x" then
		lib.audio.play(soundSelect)
		soundBackground:setVolume(0)
		game = games[currentSelection]
		launchGame(game.slug)
	end
end

-- Launch the given menu item.
function launchGame(slug)
	if (slug == 'quit') then
		lib.event.quit(0)
	else
		os.execute(game.slug .. " " .. game.flags)
	end
end


-- Capture the standard output from running an executable.
function capture(cmd, raw)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	if raw then return s end
	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')
	return s
end
