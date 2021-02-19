# Day 1 - 17/02/21

Ideaguyed the basics of the game's classes and mechanics, and implemented basic movement and setting of all the stats it will have. Here are the initial characters, synergies and stats I want to have:

### Characters

* Vagrant: shoots a projectile at any nearby enemy, medium range
* Scout: throws a knife at any nearby enemy that chains, small range
* Cleric: heals every unit when any one drops below 50% HP
* Swordsman: deals damage in an area around the unit, small range
* Archer: shoots an arrow at any nearby enemy in front of the unit, long range
* Wizard: shoots a projectile at any nearby enemy and deals AoE damage on contact, small range

### Synergies

* Ranger: yellow, buff attack speed
* Warrior: orange, buff attack damage
* Healer: green, buff healing effectiveness
* Mage: blue, debuff enemy defense
* Cycler: purple, buff cycle speed

### Stats

* HP
* Damage
* Attack speed: stacks additively, starts at 1 and capped at minimum 0.125s or +300%
* Defense: if defense >= 0 then dmg_m = 100/(100+defense) else dmg_m = 2-100/(100-defense)
* Cycle speed: stacks additively, starts at 2 and capped at minimum 0.5s or +300%

Perhaps I'm overengineering it already with the stats but I wanna see where this goes. From SHOOTRX it seems like figuring out stats earlier is better than later, and these seem like they have enough flexibility.

# Day 2 - 18/02/21

Went through like 3 small refactors of how I was laying out Unit, Player and Enemy classes and how I wanted enemies to behave.
Settled on just copying enemy behavior 100% from SHOOTRX, which is likely the more correct decision since it saves a lot of time.

Right now basic player and enemy movement works, as well as melee collisions between player and enemy. To do for tomorrow:

* HP bar should be drawn on top of all player units
* Projectiles 
* Areas
* Stats: attack speed, damage, cycle
* One or a few of the characters
* Port over enemy spawn logic from SHOOTRX
* Sounds