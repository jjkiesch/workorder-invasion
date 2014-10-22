window.Game =
  ns: 'http://www.w3.org/2000/svg'
  xlink: 'http://www.w3.org/1999/xlink'
  width: 500

  runGame: ->
    Sound.init()
    Ship.init()
    Shield.init()
    Ctrl.init()
    Hud.init()
    Enemy.init()
    Sound.gamestart.play()

    @updateHandler = window.setInterval Game.update, 20

  init: ->
    @welcome = document.getElementById 'welcomeScreen'
    @restart = document.getElementById 'gameoverScreen'
    @board = document.getElementById 'invasion'
    @runGame()

  update: ->
    Ship.update()
    Laser.update()

  elRemove: (name) ->
    items = name.split(' ')
    for item in items
      type = item.charAt(0)
      string = item.slice(1)
      el = if type == '.' then document.getElementsByClassName(string) else document.getElementById(string)

      if type == '.'
        while el[0]
          el[0].parentNode.removeChild(el[0])
      else
        if typeof el == 'object' and el != null
          @board.removeChild el

  endGame: ->
    Ctrl.cancelGamepad()
    Sound.gameover.play()

    window.clearInterval Enemy.timer
    window.removeEventListener 'keydown', Ctrl.keyDown, true
    window.removeEventListener 'keyup', Ctrl.keyUp, true

    window.clearInterval @updateHandler

    el = angular.element('#invasion')
    $scope = el.scope()
    $scope.setScore(Hud.score)
    $injector = el.injector()
    $location = $injector.get('$location')
    $location.path('/gameover')
    $scope.$apply()

Ship =
  init: ->
    @x = 220
    @y = 460
    @width = 35
    @height = 35
    @speed = 3
    @build @x, @y, 'player active'

  build: (x, y, shipClass) ->
    el = document.createElementNS Game.ns, 'image'
    el.setAttribute 'class', shipClass
    el.setAttribute 'x', x
    el.setAttribute 'y', y
    el.setAttribute 'width', @width
    el.setAttribute 'height', @height
    el.setAttributeNS Game.xlink, 'xlink:href', 'images/ship.svg'
    Game.board.appendChild el

    @player = document.getElementsByClassName 'player'

  update: ->
    if Ctrl.left and @x >= 0
      @x -= @speed
    else if Ctrl.right and @x <= (Game.width - @width)
      @x += @speed

    if @player[0] then @player[0].setAttribute 'x', @x

  collide: ->
    Sound.playerexplosion.play()
    Hud.lives -= 1
    Game.board.removeChild @player[0]
    Game.board.removeChild @lives[Hud.lives]

    if Hud.lives > 0
      window.setTimeout ->
        Ship.build Ship.x, Ship.y, 'player active'
      , 1000
    else
      Game.endGame()

Ctrl =
  init: ->
    @left = false
    @right = false
    window.addEventListener 'keydown', @keyDown, true
    window.addEventListener 'keyup', @keyUp, true
    window.cancelAnimationFrame @lastFrame if @lastFrame
    @lastFrame = window.requestAnimationFrame Ctrl.updateGamepad

  keyDown: (event) ->
    switch event.keyCode
      when 39
        Ctrl.right = true
      when 37
        Ctrl.left = true
      when 32
        Sound.laser.play()
        laser = document.getElementsByClassName 'negative'
        player = document.getElementsByClassName 'player'
        Laser.build Ship.x + (Ship.width / 2) - Laser.width, Ship.y - Laser.height, true

  keyUp: (event) ->
    switch event.keyCode
      when 39
        Ctrl.right = false
      when 37
        Ctrl.left = false

  updateGamepad: ->
    Ctrl.id = window.requestAnimationFrame Ctrl.updateGamepad

    gamepad = navigator.getGamepads()[0]
    unless gamepad is undefined
      if gamepad.buttons[3].pressed and not Ctrl.fire
        Sound.laser.play()
        Ctrl.fire = true
        Laser.build Ship.x + (Ship.width / 2) - Laser.width, Ship.y - Laser.height, true
      else if not gamepad.buttons[3].pressed and Ctrl.fire
        Ctrl.fire = false

      if gamepad.buttons[15].pressed
        Ctrl.right = true
      else if gamepad.buttons[14].pressed
        Ctrl.left = true
      else
        Ctrl.left = false
        Ctrl.right = false

  cancelGamepad: ->
    window.cancelAnimationFrame(@id)

Shield =
  init: ->
    @x = 64
    @y = 390
    @hp = 3
    @size = 15
    for block in [3..0]
      for piece in [7..0]
        @build block, piece

  build: (loc, piece) ->
    x = @x + (loc * @x) + (loc * (@size * 3))
    el = document.createElementNS Game.ns, 'rect'
    el.setAttribute 'x', @locX piece, x
    el.setAttribute 'y', @locY piece
    el.setAttribute 'class', 'shield active'
    el.setAttribute 'hp', @hp
    el.setAttribute 'width', @size
    el.setAttribute 'height', @size
    Game.board.appendChild el

  locX: (piece, x) ->
    switch piece
      when 0 then x
      when 1 then x
      when 2 then x
      when 3 then x + @size
      when 4 then x + @size
      when 5 then x + (@size * 2)
      when 6 then x + (@size * 2)
      when 7 then x + (@size * 2)

  locY: (piece) ->
    switch piece
      when 0 then @y
      when 1 then @y + @size
      when 2 then @y + (@size * 2)
      when 3 then @y
      when 4 then @y + @size
      when 5 then @y
      when 6 then @y + @size
      when 7 then @y + (@size * 2)

  collide: (el) ->
    hp = parseInt(el.getAttribute('hp'), 10) - 1
    switch hp
      when 1 then opacity = 0.33
      when 2 then opacity = 0.66
      else return Game.board.removeChild(el)
    el.setAttribute 'hp', hp
    el.setAttribute 'fill-opacity', opacity

Laser =
  speed: 8
  width: 2
  height: 10

  build: (x, y, negative) ->
    el = document.createElementNS Game.ns, 'rect'

    if negative
      el.setAttribute 'class', 'laser negative'
    else
      el.setAttribute 'class', 'laser'

    el.setAttribute 'x', x
    el.setAttribute 'y', y
    el.setAttribute 'width', @width
    el.setAttribute 'height', @height
    Game.board.appendChild el

  direction: (y, laserClass) ->
    speed = if laserClass == 'laser negative' then -(@speed) else @speed
    y += speed

  collide: (laser) ->
    if laser != undefined then Game.board.removeChild laser

  update: ->
    lasers = document.getElementsByClassName 'laser'

    if lasers.length
      active = document.getElementsByClassName 'active'
      for laser in lasers
        laserX = parseInt laser.getAttribute('x'), 10
        laserY = parseInt laser.getAttribute('y'), 10

        if Game.height < laserX < 0
          @collide(laser)
        else
          laserY = @direction laserY, laser.getAttribute('class')
          laser.setAttribute 'y', laserY

        for current in active
          return if current == undefined

          activeX = parseInt(current.getAttribute('x'), 10) or Ship.x
          activeY = parseInt(current.getAttribute('y'), 10) or Ship.y
          activeW = parseInt(current.getAttribute('width'), 10) or Ship.width
          activeH = parseInt(current.getAttribute('height'), 10) or Ship.height

          if laserX + @width >= activeX and laserX <= (activeX + activeW) and laserY + @height >= activeY and laserY <= (activeY + activeH)
            @collide(laser)

            activeClass = current.getAttribute 'class'
            if activeClass == 'enemy active'
              Enemy.collide(current)
            else if activeClass == 'shield active'
              Shield.collide(current)
            else if Ship.player[0]
              Ship.collide()

Hud =
  livesX: 360
  livesY: 10
  livesGap: 10

  init: ->
    @score = 0
    @lives = 3
    @level = 1

    for life in [1..Hud.lives]
      x = @livesX + (Ship.width * life) + (@livesGap * life)
      Ship.build x, @livesY, 'life'
    @build 'Lives:', 310, 30, 'textLives'
    @build 'Score: 0', 20, 30, 'textScore'

    Ship.lives = document.getElementsByClassName('life')

  build: (text, x, y, classText) ->
    el = document.createElementNS(Game.ns, 'text')
    el.setAttribute 'x', x
    el.setAttribute 'y', y
    el.setAttribute 'id', classText
    el.setAttribute 'fill', '#fff'
    el.appendChild document.createTextNode(text)
    Game.board.appendChild el

  updateScore: (pts) ->
    @score += pts
    @bonus += pts

    el = document.getElementById('textScore')
    el.replaceChild document.createTextNode('Score: ' + @score), el.firstChild

    return if @bonus < 100 or @lives == 3

    x = @livesX + (Ship.width * @lives) + (@livesGap * @lives)
    Ship.build x, @livesY, 'life'
    @lives += 1
    @bonus = 0

  levelUp: ->
    Enemy.counter += 1
    invTotal = Enemy.col * Enemy.row

    if Enemy.counter == invTotal
      @level += 1
      Enemy.counter = 0

      window.clearInterval Enemy.timer
      Game.board.removeChild(Enemy.flock);

      setTimeout ->
        Enemy.init()
      , 300
    else if Enemy.counter == Math.round(invTotal / 2)
      Enemy.delay -= 100
      window.clearInterval(Enemy.timer)
      Enemy.timer = window.setInterval Enemy.update, Enemy.delay
    else if Enemy.counter == (Enemy.col * Enemy.row) - 10
      Enemy.delay -= 200
      window.clearInterval Enemy.timer
      Enemy.timer = window.setInterval Enemy.update, Enemy.delay

Enemy =
  width: 25
  height: 19
  x: 64
  y: 90
  gap: 10
  row: 5
  col: 10

  init: ->
    @speed = 10
    @counter = 0
    @build()
    @delay = 600 - (20 * Hud.level)
    if @timer then window.clearInterval @update, @delay
    @timer = window.setInterval @update, @delay

  build: ->
    group = document.createElementNS Game.ns, 'g'
    group.setAttribute 'class', 'open'
    group.setAttribute 'id', 'flock'

    enemyImages = ['faucet', 'heater', 'mouse', 'toilet', 'window']

    for row in [@row...0]
      for col in [@col...0]
        el = document.createElementNS Game.ns, 'image'
        el.setAttribute 'x', @locX(col)
        el.setAttribute 'y', @locY(row)
        el.setAttribute 'class', 'enemy active'
        el.setAttribute 'row', row
        el.setAttribute 'col', col
        el.setAttribute 'width', @width
        el.setAttribute 'height', @height
        el.setAttributeNS Game.xlink, 'xlink:href', 'images/' + enemyImages[row - 1] + '.svg'

        group.appendChild el

    Game.board.appendChild group
    @flock = document.getElementById 'flock'

  locX: (col) ->
    @x + (col * @width) + (col * @gap)

  locY: (row) ->
    @y + (row * @height) + (row * @gap)

  update: ->
    enemies = document.getElementsByClassName 'enemy'
    return if enemies.length == 0

    flockData = @flock.getBBox()
    flockWidth = Math.round flockData.width
    flockHeight = Math.round flockData.height
    flockX = Math.round flockData.x
    flockY = Math.round flockData.y
    moveX = 0
    moveY = 0

    if flockWidth + flockX + Enemy.speed >= Game.width or flockX + Enemy.speed <= 0
      moveY = Math.abs Enemy.speed
      Enemy.speed *= -1
    else
      moveX = Enemy.speed

    for enemy in enemies
      newX = parseInt(enemy.getAttribute('x'), 10) + moveX
      newY = parseInt(enemy.getAttribute('y'), 10) + moveY
      enemy.setAttribute 'x', newX
      enemy.setAttribute 'y', newY

    if flockY + flockHeight >= Shield.y
      Game.endGame()

    Enemy.shoot(enemies, flockY + flockHeight - Enemy.height)

  collide: (el) ->
    Sound.enemyexplosion.play()
    Hud.updateScore 1
    Hud.levelUp()
    el.parentNode.removeChild(el)

  shoot: (enemies, lastRowY) ->
    return if Math.floor(Math.random() * 5) < 2

    stack = []
    for enemy in enemies
      currentY = parseInt(enemy.getAttribute('y'), 10)
      if currentY >= lastRowY
        stack.push(enemy)

    randomEnemy = Math.floor(Math.random() * stack.length)
    Laser.build(parseInt(stack[randomEnemy].getAttribute('x'), 10) + (@width / 2), lastRowY + @height + 10, false)

Sound =
  init: ->
    @enemyexplosion = new Audio('/workorder-invasion/sounds/enemyexplosion.wav')
    @gameover = new Audio('/workorder-invasion/sounds/gameover.wav')
    @gamestart = new Audio('/workorder-invasion/sounds/gamestart.wav')
    @laser = new Audio('/workorder-invasion/sounds/laser.wav')
    @playerexplosion = new Audio('/workorder-invasion/sounds/playerexplosion.wav')
