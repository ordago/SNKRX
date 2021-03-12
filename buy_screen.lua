BuyScreen = Object:extend()
BuyScreen:implement(State)
BuyScreen:implement(GameObject)
function BuyScreen:init(name)
  self:init_state(name)
  self:init_game_object()
end


function BuyScreen:on_enter(from, level, units)
  self.level = level
  self.units = units

  self.main = Group()
  self.top = Group()
  self.ui = Group()

  if self.level == 0 then
    pop1:play{pitch = random:float(0.95, 1.05), volume = 0.5}
    ui_switch2:play{pitch = random:float(0.95, 1.05), volume = 0.5}
    player_hit_wall1:play{pitch = r, volume = 0.5}
    self.first_screen = true
    self.cards = {}
    self.selected_card_index = 1
    local units = {'vagrant', 'swordsman', 'wizard', 'archer', 'scout', 'cleric'}
    self.cards[1] = PairCard{group = self.main, x = gw/2, y = 85, w = gw, h = gh/4, unit_1 = random:table_remove(units), unit_2 = random:table_remove(units), i = 1, parent = self}
    local units = {'vagrant', 'swordsman', 'wizard', 'archer', 'scout', 'cleric'}
    self.cards[2] = PairCard{group = self.main, x = gw/2, y = 155, w = gw, h = gh/4, unit_1 = random:table_remove(units), unit_2 = random:table_remove(units), i = 2, parent = self}
    local units = {'vagrant', 'swordsman', 'wizard', 'archer', 'scout', 'cleric'}
    self.cards[3] = PairCard{group = self.main, x = gw/2, y = 225, w = gw, h = gh/4, unit_1 = random:table_remove(units), unit_2 = random:table_remove(units), i = 3, parent = self}
    self.title_sy = 1
    self.title = Text({{text = '[wavy_mid, fg]choose your initial party', font = pixul_font, alignment = 'center'}}, global_text_tags)

  else
    local level_to_tier_weights = {
      [1] = {100, 0, 0},
      [2] = {95, 5, 0},
      [3] = {90, 10, 0},
      [4] = {85, 15, 0},
      [5] = {80, 20, 0},
      [6] = {75, 25, 0},
      [7] = {70, 30, 0},
      [8] = {65, 35, 0},
      [9] = {60, 40, 0},
      [10] = {55, 45, 0},
      [11] = {50, 50, 0},
      [12] = {45, 50, 5},
      [13] = {40, 50, 10},
      [14] = {35, 50, 15},
      [15] = {30, 50, 20},
      [16] = {25, 50, 25},
      [17] = {20, 55, 25},
      [18] = {15, 60, 25},
      [19] = {10, 65, 25},
      [20] = {5, 70, 25},
      [21] = {0, 75, 25},
      [22] = {0, 70, 30},
      [23] = {0, 65, 35},
      [24] = {0, 60, 40},
      [25] = {0, 55, 45},
    }
    self.cards = {}
    self.selected_index = 1
    self.cards[1] = ShopCard{group = self.main, x = 60, y = 75, w = 80, h = 90, unit = random:table(tier_to_characters[random:weighted_pick(unpack(level_to_tier_weights[self.level]))]), parent = self}
    self.cards[2] = ShopCard{group = self.main, x = 140, y = 75, w = 80, h = 90, unit = random:table(tier_to_characters[random:weighted_pick(unpack(level_to_tier_weights[self.level]))]), parent = self}
    self.cards[3] = ShopCard{group = self.main, x = 220, y = 75, w = 80, h = 90, unit = random:table(tier_to_characters[random:weighted_pick(unpack(level_to_tier_weights[self.level]))]), parent = self}
    self.shop_text_sy = 1
    self.shop_text = Text({{text = '[wavy_mid, fg]shop', font = pixul_font, alignment = 'center'}}, global_text_tags)
    self.gold_text = Text2{group = self.main, x = 88, y = 20, lines = {{text = '[fg]- your gold: [yellow]' .. gold, font = pixul_font, alignment = 'center'}}}

    self.characters = {}
    local y = 40
    for i, unit in ipairs(self.units) do
      table.insert(self.characters, CharacterPart{group = self.main, x = gw - 30, y = y + (i-1)*20, character = unit.character, level = unit.level, reserve = unit.reserve})
    end
    self.party_text = Text({{text = '[wavy_mid, fg]party', font = pixul_font, alignment = 'center'}}, global_text_tags)

    self.sets = {}
    for i, class in ipairs(get_classes(self.units)) do
      local x, y = math.index_to_coordinates(i, 2)
      table.insert(self.sets, ClassIcon{group = self.main, x = 319 + (x-1)*20, y = 45 + (y-1)*56, class = class, units = self.units})
    end
    self.sets_text = Text({{text = '[wavy_mid, fg]sets', font = pixul_font, alignment = 'center'}}, global_text_tags)

    self.items_text = Text({{text = '[wavy_mid, fg]items', font = pixul_font, alignment = 'center'}}, global_text_tags)
    self.under_text = Text2{group = self.main, x = 140, y = gh - 60, r = -math.pi/48, lines = {
      {text = '[light_bg]under', font = fat_font, alignment = 'center'},
      {text = '[light_bg]construction', font = fat_font, alignment = 'center'},
    }}

    RerollButton{group = self.main, x = 255, y = 140, parent = self}
  end
end


function BuyScreen:update(dt)
  self:update_game_object(dt*slow_amount)
  self.main:update(dt*slow_amount)
  self.top:update(dt*slow_amount)
  self.ui:update(dt*slow_amount)

  if self.level == 0 and self.first_screen then
    if self.title then self.title:update(dt) end

    if input.move_up.pressed then
      self.selected_card_index = self.selected_card_index - 1
      if self.selected_card_index == 0 then self.selected_card_index = 3 end
      for i = 1, 3 do self.cards[i]:unselect() end
      self.cards[self.selected_card_index]:select()
      pop1:play{pitch = random:float(0.95, 1.05), volume = 0.5}
      ui_switch2:play{pitch = random:float(0.95, 1.05), volume = 0.5}
      player_hit_wall1:play{pitch = r, volume = 0.5}
    end
    if input.move_down.pressed then
      self.selected_card_index = self.selected_card_index + 1
      if self.selected_card_index == 4 then self.selected_card_index = 1 end
      for i = 1, 3 do self.cards[i]:unselect() end
      self.cards[self.selected_card_index]:select()
      pop1:play{pitch = random:float(0.95, 1.05), volume = 0.5}
      ui_switch2:play{pitch = random:float(0.95, 1.05), volume = 0.5}
      player_hit_wall1:play{pitch = r, volume = 0.5}
    end

    if input.enter.pressed and not self.transitioning then
      ui_switch1:play{pitch = random:float(0.95, 1.05), volume = 0.5}
      ui_transition1:play{pitch = random:float(0.95, 1.05), volume = 0.5}
      self.transitioning = true
      self.t:tween(0.1, self, {title_sy = 0}, math.linear, function() self.title_sy = 0; self.title = nil end)

      local unit_1, unit_2 = self.cards[self.selected_card_index].unit_1, self.cards[self.selected_card_index].unit_2
      TransitionEffect{group = main.transitions, x = 50, y = 85 + (self.selected_card_index-1)*70, color = character_colors[unit_1], transition_action = function()
        main:add(Arena'arena')
        main:go_to('arena', 1, {{character = unit_1, level = 1}, {character = unit_2, level = 1}})
      end}
      --[[
      , text = Text({
        {text = '[' .. character_color_strings[unit_1] .. ']' .. unit_1:upper() .. ' [yellow]Lv.1 [fg]- ' .. table.reduce(character_classes[unit_1],
        function(memo, v) return memo .. '[' .. class_color_strings[v] .. ']' .. v .. '[fg], ' end, ''):sub(1, -3), font = pixul_font, height_multiplier = 1.7, alignment = 'center'},
        {text = character_stats[unit_1](1), font = pixul_font, height_multiplier = 1.3, alignment = 'center'},
        {text = character_descriptions[unit_1](get_character_stat(unit_1, 1, 'dmg')), font = pixul_font, alignment = 'center', height_multiplier = 3},
        {text = '[' .. character_color_strings[unit_2] .. ']' .. unit_2:upper() .. ' [yellow]Lv.1 [fg]- ' .. table.reduce(character_classes[unit_2],
        function(memo, v) return memo .. '[' .. class_color_strings[v] .. ']' .. v .. '[fg], ' end, ''):sub(1, -3), font = pixul_font, height_multiplier = 1.7, alignment = 'center'},
        {text = character_stats[unit_2](1), font = pixul_font, height_multiplier = 1.3, alignment = 'center'},
        {text = character_descriptions[unit_2](get_character_stat(unit_2, 1, 'dmg')), font = pixul_font, alignment = 'center', height_multiplier = 1.5},
      }, global_text_tags)}
      ]]--
    end

  else
    if self.shop_text then self.shop_text:update(dt) end
    if self.sets_text then self.sets_text:update(dt) end
    if self.party_text then self.party_text:update(dt) end
    if self.items_text then self.items_text:update(dt) end
  end
end


function BuyScreen:draw()
  self.main:draw()
  self.top:draw()
  if self.items_text then self.items_text:draw(32, 150) end
  self.ui:draw()

  if self.level == 0 then
    if self.title then self.title:draw(3.25*gw/4, 32, 0, 1, self.title_sy) end
  else
    if self.shop_text then self.shop_text:draw(32, 20, 0, 1, self.shop_text_sy) end
    if self.sets_text then self.sets_text:draw(328, 20) end
    if self.party_text then self.party_text:draw(440, 20) end
  end
end




RerollButton = Object:extend()
RerollButton:implement(GameObject)
function RerollButton:init(args)
  self:init_game_object(args)
  self.shape = Rectangle(self.x, self.y, 54, 16)
  self.interact_with_mouse = true
  self.text = Text({{text = '[bg10]reroll: [yellow]2', font = pixul_font, alignment = 'center'}}, global_text_tags)
end


function RerollButton:update(dt)
  self:update_game_object(dt)
end


function RerollButton:draw()
  graphics.push(self.x, self.y, 0, self.spring.x, self.spring.y)
    graphics.rectangle(self.x, self.y, self.shape.w, self.shape.h, 4, 4, self.selected and fg[0] or bg[1])
    self.text:draw(self.x, self.y + 1)
  graphics.pop()
end


function RerollButton:on_mouse_enter()
  self.selected = true
  self.text:set_text{{text = '[fgm5]reroll: 2', font = pixul_font, alignment = 'center'}}
  self.spring:pull(0.2, 200, 10)
end

function RerollButton:on_mouse_exit()
  self.text:set_text{{text = '[bg10]reroll: [yellow]2', font = pixul_font, alignment = 'center'}}
  self.selected = false
end




CharacterPart = Object:extend()
CharacterPart:implement(GameObject)
function CharacterPart:init(args)
  self:init_game_object(args)
  self.shape = Rectangle(self.x, self.y, self.sx*20, self.sy*20)
  self.interact_with_mouse = true
  self.parts = {}
  local x = self.x - 20
  if self.reserve then
    if self.reserve[2] == 1 then
      table.insert(self.parts, CharacterPart{group = main.current.main, x = x, y = self.y, character = self.character, level = 2})
      x = x - 20
    end
    for i = 1, self.reserve[1] do
      table.insert(self.parts, CharacterPart{group = main.current.main, x = x, y = self.y, character = self.character, level = 1, sx = 0.9, sy = 0.9})
      x = x - 20
    end
  end
end


function CharacterPart:update(dt)
  self:update_game_object(dt)
end


function CharacterPart:draw()
  graphics.push(self.x, self.y, 0, self.sx*self.spring.x, self.sy*self.spring.x)
    graphics.rectangle(self.x, self.y, 14, 14, 3, 3, character_colors[self.character])
    graphics.print_centered(self.level, pixul_font, self.x + 0.5, self.y + 2, 0, 1, 1, 0, 0, _G[character_color_strings[self.character]][-5])
  graphics.pop()
end


function CharacterPart:on_mouse_enter()
  local get_sale_price = function()
    local total = 0
    total = total + self.level
    if self.reserve then
      if self.reserve[2] then total = total + self.reserve[2]*2 end
      if self.reserve[1] then total = total + self.reserve[1] end
    end
    return total
  end

  self.spring:pull(0.2, 200, 10)
  self.info_text = InfoText{group = main.current.ui}
  self.info_text:activate({
    {text = '[' .. character_color_strings[self.character] .. ']' .. self.character:capitalize() .. '[fg] - [yellow]Lv.' .. self.level .. '[fg] - sells for [yellow]' .. get_sale_price(),
    font = pixul_font, alignment = 'center', height_multiplier = 1.25},
    {text = character_descriptions[self.character](get_character_stat(self.character, self.level, 'dmg')), font = pixul_font, alignment = 'center'},
  }, nil, nil, nil, nil, 16, 4, nil, 2)
  self.info_text.x, self.info_text.y = gw/2, gh/2 + 10
end


function CharacterPart:on_mouse_exit()
  self.info_text:deactivate()
  self.info_text = nil
end



ShopCard = Object:extend()
ShopCard:implement(GameObject)
function ShopCard:init(args)
  self:init_game_object(args)
  self.shape = Rectangle(self.x, self.y, self.w, self.h)
  self.interact_with_mouse = true
  self.character_icon = CharacterIcon{group = main.current.top, x = self.x, y = self.y - 26, character = self.unit, parent = self}
  self.class_icons = {}
  for i, class in ipairs(character_classes[self.unit]) do
    local x = self.x
    if #character_classes[self.unit] == 2 then x = self.x - 10
    elseif #character_classes[self.unit] == 3 then x = self.x - 20 end
    table.insert(self.class_icons, ClassIcon{group = main.current.top, x = x + (i-1)*20, y = self.y + 6, class = class, units = self.parent.units})
  end
  self.cost = character_tiers[self.unit]
end


function ShopCard:update(dt)
  self:update_game_object(dt)
end


function ShopCard:select()
  self.selected = true
  self.spring:pull(0.2, 200, 10)
  self.t:every_immediate(1.4, function()
    if self.selected then
      self.t:tween(0.7, self, {sx = 0.97, sy = 0.97, plus_r = -math.pi/32}, math.linear, function()
        self.t:tween(0.7, self, {sx = 1.03, sy = 1.03, plus_r = math.pi/32}, math.linear, nil, 'pulse_1')
      end, 'pulse_2')
    end
  end, nil, nil, 'pulse')
end


function ShopCard:unselect()
  self.selected = false
  self.t:cancel'pulse'
  self.t:cancel'pulse_1'
  self.t:cancel'pulse_2'
  self.t:tween(0.1, self, {sx = 1, sy = 1, plus_r = 0}, math.linear, function() self.sx, self.sy, self.plus_r = 1, 1, 0 end, 'pulse')
end


function ShopCard:draw()
  graphics.push(self.x, self.y, 0, self.spring.x, self.spring.x)
    if self.selected then
      graphics.rectangle(self.x, self.y, self.w, self.h, 6, 6, bg[-1])
    end
  graphics.pop()
end


function ShopCard:on_mouse_enter()
  self.selected = true
  self.spring:pull(0.1)
  self.character_icon.spring:pull(0.1, 200, 10)
  for _, class_icon in ipairs(self.class_icons) do
    class_icon.selected = true
    class_icon.spring:pull(0.1, 200, 10)
  end
end


function ShopCard:on_mouse_exit()
  self.selected = false
  for _, class_icon in ipairs(self.class_icons) do class_icon.selected = false end
end




CharacterIcon = Object:extend()
CharacterIcon:implement(GameObject)
function CharacterIcon:init(args)
  self:init_game_object(args)
  self.shape = Rectangle(self.x, self.y, 40, 20)
  self.interact_with_mouse = true
  self.character_text = Text({{text = '[' .. character_color_strings[self.character] .. ']' .. self.character, font = pixul_font, alignment = 'center'}}, global_text_tags)
end


function CharacterIcon:update(dt)
  self:update_game_object(dt)
  self.character_text:update(dt)
end


function CharacterIcon:draw()
  graphics.push(self.x, self.y, 0, self.spring.x, self.spring.x)
    graphics.rectangle(self.x, self.y - 7, 14, 14, 3, 3, character_colors[self.character])
    graphics.print_centered(self.parent.cost, pixul_font, self.x + 0.5, self.y - 5, 0, 1, 1, 0, 0, _G[character_color_strings[self.character]][-5])
    self.character_text:draw(self.x, self.y + 10)
  graphics.pop()
end


function CharacterIcon:on_mouse_enter()
  self.spring:pull(0.2, 200, 10)
  self.info_text = InfoText{group = main.current.ui}
  self.info_text:activate({
    {text = '[' .. character_color_strings[self.character] .. ']' .. self.character:capitalize() .. '[fg] - cost: [yellow]' .. self.parent.cost, font = pixul_font, alignment = 'center', height_multiplier = 1.25},
    {text = character_descriptions[self.character](get_character_stat(self.character, 1, 'dmg')), font = pixul_font, alignment = 'center'},
  }, nil, nil, nil, nil, 16, 4, nil, 2)
  self.info_text.x, self.info_text.y = gw/2, gh/2 + 10
end


function CharacterIcon:on_mouse_exit()
  self.info_text:deactivate()
  self.info_text = nil
end



ClassIcon = Object:extend()
ClassIcon:implement(GameObject)
function ClassIcon:init(args)
  self:init_game_object(args)
  self.shape = Rectangle(self.x, self.y + 11, 20, 40)
  self.interact_with_mouse = true
end


function ClassIcon:update(dt)
  self:update_game_object(dt)
end


function ClassIcon:draw()
  graphics.push(self.x, self.y, 0, self.spring.x, self.spring.x)
    local i, j, n = class_set_numbers[self.class](self.units)
    graphics.rectangle(self.x, self.y, 16, 24, 4, 4, (n >= i) and class_colors[self.class] or bg[3])
    _G[self.class]:draw(self.x, self.y, 0, 0.3, 0.3, 0, 0, (n >= i) and _G[class_color_strings[self.class]][-5] or bg[10])
    graphics.rectangle(self.x, self.y + 26, 16, 16, 3, 3, bg[3])
    if i == 2 then
      graphics.line(self.x - 3, self.y + 20, self.x - 3, self.y + 25, (n >= 1) and class_colors[self.class] or bg[10], 3)
      graphics.line(self.x - 3, self.y + 27, self.x - 3, self.y + 32, (n >= 2) and class_colors[self.class] or bg[10], 3)
      graphics.line(self.x + 4, self.y + 20, self.x + 4, self.y + 25, (n >= 3) and class_colors[self.class] or bg[10], 3)
      graphics.line(self.x + 4, self.y + 27, self.x + 4, self.y + 32, (n >= 4) and class_colors[self.class] or bg[10], 3)
    elseif i == 3 then
      graphics.line(self.x - 4, self.y + 22, self.x - 4, self.y + 30, (n >= 1) and class_colors[self.class] or bg[10], 2)
      graphics.line(self.x, self.y + 22, self.x, self.y + 30, (n >= 2) and class_colors[self.class] or bg[10], 2)
      graphics.line(self.x + 4, self.y + 22, self.x + 4, self.y + 30, (n >= 3) and class_colors[self.class] or bg[10], 2)
    elseif i == 1 then
      graphics.line(self.x - 3, self.y + 22, self.x - 3, self.y + 30, (n >= 1) and class_colors[self.class] or bg[10], 3)
      graphics.line(self.x + 4, self.y + 22, self.x + 4, self.y + 30, (n >= 2) and class_colors[self.class] or bg[10], 3)
    end
  graphics.pop()
end


function ClassIcon:on_mouse_enter()
  self.spring:pull(0.2, 200, 10)
  local i, j, owned = class_set_numbers[self.class](self.units)
  self.info_text = InfoText{group = main.current.ui}
  self.info_text:activate({
    {text = '[' .. class_color_strings[self.class] .. ']' .. self.class:capitalize() .. '[fg] - owned: [yellow]' .. owned, font = pixul_font, alignment = 'center', height_multiplier = 1.25},
    {text = class_descriptions[self.class]((owned >= j and 2) or (owned >= i and 1) or 0), font = pixul_font, alignment = 'center'},
  }, nil, nil, nil, nil, 16, 4, nil, 2)
  self.info_text.x, self.info_text.y = gw/2, gh/2 + 10
end


function ClassIcon:on_mouse_exit()
  self.info_text:deactivate()
  self.info_text = nil
end




PairCard = Object:extend()
PairCard:implement(GameObject)
function PairCard:init(args)
  self:init_game_object(args)
  self.plus_r = 0
  if self.i == 1 then self:select() end
end


function PairCard:update(dt)
  self:update_game_object(dt)
end


function PairCard:select()
  self.selected = true
  self.spring:pull(0.2, 200, 10)
  self.t:every_immediate(1.4, function()
    if self.selected then
      self.t:tween(0.7, self, {sx = 0.97, sy = 0.97, plus_r = -math.pi/32}, math.linear, function()
        self.t:tween(0.7, self, {sx = 1.03, sy = 1.03, plus_r = math.pi/32}, math.linear, nil, 'pulse_1')
      end, 'pulse_2')
    end
  end, nil, nil, 'pulse')
end


function PairCard:unselect()
  self.selected = false
  self.t:cancel'pulse'
  self.t:cancel'pulse_1'
  self.t:cancel'pulse_2'
  self.t:tween(0.1, self, {sx = 1, sy = 1, plus_r = 0}, math.linear, function() self.sx, self.sy, self.plus_r = 1, 1, 0 end, 'pulse')
end


function PairCard:draw()
  local x = self.x - self.w/3

  if self.selected then
    graphics.push(x + (fat_font:get_text_width(self.i) + 20)/2, self.y - 25 + 37/2, 0, self.spring.x*self.sx, self.spring.x*self.sy)
      graphics.rectangle2(x - 52, self.y - 25, fat_font:get_text_width(self.i) + 20, 37, 6, 6, bg[2])
    graphics.pop()
  end

  -- 1, 2, 3
  graphics.push(x - 40 + fat_font:get_text_width(self.i)/2, self.y - fat_font.h/8, 0, self.spring.x*self.sx, self.spring.x*self.sy)
    graphics.print(self.i, fat_font, x - 40, self.y, 0, self.sx, self.sy, nil, fat_font.h/2, fg[0])
  graphics.pop()

  -- Unit 1 + class symbols
  graphics.push(x + (fat_font:get_text_width(self.unit_1:capitalize() .. 'w') + table.reduce(character_classes[self.unit_1], function(memo, v) return memo + 0.5*_G[v].w end, 0))/2, self.y - fat_font.h/8, 0,
  self.spring.x*self.sx, self.spring.x*self.sy)
    graphics.print(self.unit_1:capitalize(), fat_font, x, self.y, 0, 1, 1, nil, fat_font.h/2, character_colors[self.unit_1])
    x = x + fat_font:get_text_width(self.unit_1 .. 'w')
    for i, class in ipairs(character_classes[self.unit_1]) do
      _G[class]:draw(x, self.y, 0, 0.4, 0.4, nil, 20, class_colors[class])
      x = x + 0.5*_G[class].w
    end
  graphics.pop()

  -- +
  graphics.push(x + fat_font:get_text_width('+')/2, self.y, self.plus_r, self.spring.x*self.sx, self.spring.x*self.sy)
    graphics.print('+', fat_font, x, self.y, 0, 1, 1, nil, fat_font.h/2, fg[0])
  graphics.pop()

  -- Unit 2 + class symbols
  x = x + fat_font:get_text_width('+l')
  graphics.push(x + (fat_font:get_text_width(self.unit_2:capitalize() .. 'w') + table.reduce(character_classes[self.unit_2], function(memo, v) return memo + 0.5*_G[v].w end, 0))/2, self.y - fat_font.h/8, 0,
  self.spring.x*self.sx, self.spring.x*self.sy)
    graphics.print(self.unit_2:capitalize(), fat_font, x, self.y, 0, 1, 1, nil, fat_font.h/2, character_colors[self.unit_2])
    x = x + fat_font:get_text_width(self.unit_2 .. 'w')
    for i, class in ipairs(character_classes[self.unit_2]) do
      _G[class]:draw(x, self.y, 0, 0.4, 0.4, nil, 20, class_colors[class])
      x = x + 0.5*_G[class].w
    end
  graphics.pop()
end