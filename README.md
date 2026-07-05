# 🪨 📜 ✂️ FEUD CLASH

A chaotic, fast-paced, 1-keyboard multiplayer game built with **Godot 4.3+** for Hack Club Feud.

---

## 🎮 Game Overview
In **Feud Clash**, two players crowd around a single keyboard in a real-time, high-stakes game of Rock Paper Scissors. 

Instead of taking turns, you can constantly swap your item (Rock, Paper, or Scissors) on the fly. You can choose to stay still and defend, or launch an aggressive lunge attack. Points are only scored when hands touch **and** at least one person is attacking. First player to 5 points wins!

## ⚙️ Core Mechanics
* **Defensive Stance (Idle):** If both players are still, their hands sit at their respective sides. If they touch while both players are idle, nothing happens (it counts as a successful defense).
* **Aggressive Lunge (Attacking):** Pressing your attack key triggers an immediate sprint forward across the screen. 
* **The Clash:** If both players attack at the exact same time with the *same* item, it results in a tie/clash. They bounce back with no points awarded.

---

## 🎹 Input Mapping (Controls)
To prevent keyboard ghosting (where keys jam when mashed together), the controls are split on opposite sides of the keyboard:

### 🔵 Player 1 (Left Side)
* `W` — Select Rock
* `A` — Select Paper
* `S` — Select Scissors
* `D` — Launch Attack Lunge

### 🔴 Player 2 (Right Side)
* `I` — Select Rock
* `J` — Select Paper
* `K` — Select Scissors
* `L` — Launch Attack Lunge

---

## 🌲 Scene Structure (Node2D Layout)
Set up your scene tree using a single main script on the root node:

```text
Node2D (Main Scene Root)
├── Parallax2D (Infinitely Scrolling Background Layer)
│   └── Sprite2D (Seamless Background Texture)
├── TextureRect / Sprite2D (P1 Hand Visual Asset)
├── TextureRect / Sprite2D (P2 Hand Visual Asset)
└── CanvasLayer (UI Overlay)
	├── Label (Player 1 Score)
	└── Label (Player 2 Score)
