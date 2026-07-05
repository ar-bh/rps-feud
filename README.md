# 🪨 📜 ✂️ ROCK PAPER SCISSORS FEUD!

A remake of the classic game - Rock Paper Scissors!
Rock Paper Scissors Feud is a chaotic and fast-paced game that you can play with a friend on just 1 keyboard! Built with **Godot 4.3** for Hack Club Feud and Stardance Challenge.

## Idea 🧠
I came up with the idea of this game while I was playing normal rock paper scissors with my friend, and I started moving my hand so he couldn't touch it and make me lose.
That "cheating" evolved into both of us doing the same and the eventual adoption of the rule where you have to touch the other person's fist to win.
I also cheated by changing the pose of my hand (between rock paper or scissors) right before my friend would touch my hand, and he started doing the same.
The combination of those two ideas led to this game that I had a lot of fun building and playing.

## How my game works 🎮
In **RPS Feud**, two players use a single keyboard in a real-time and high-stakes game of enhanced Rock Paper Scissors.
Instead of taking turns, you can constantly swap your item and try to touch the other peron's fist to win.

## Mechanics ⚙
**Idle** If both players are idle by the end of the round, the game ends in a draw, but a person cannot be touched by the opponent when idle. However, you can switch your item while idle.
** Attacking** This aggresive lunge makes your hand go forward to try to touch the other person. However, it only works if the other person is also in attack mode. When both players are in attack mode, the game follows regular RPS rules to decide who wins. If both players have the same item, nothing happens.

## 🎹 Input Mapping (Controls)
To prevent keyboard ghosting (where keys jam when mashed together), the controls are split on opposite sides of the keyboard:

### 🔵 Player 1 (Left Side)
* `W` — Select Rock
* `A` — Select Paper
* `S` — Select Scissors
* `D` — Launch Attack Lunge

### 🔴 Player 2 (Right Side)
* `LEFT ARROW` — Select Rock
* `DOWN ARROW` — Select Paper
* `RIGHT ARROW` — Select Scissors
* `UP ARROW` — Launch Attack Lunge
