# Druid Demo

A simple GDScript game demo for DRUID. In DRUID, you play as a dark-fantasy Druid of the Forest. Use your natural abilities to kill as many farmers as you can. WASD to move, and left-click to spawn volatile mushrooms which explode after a short duration. At level 2, you learn to cast Entangling Vines with right-click, rooting farmers in place.

## Overview

DRUID is designed as a fast, expressive demo of gameplay systems built in Godot 4. It combines responsive movement with ability casting, and simple progression so that lighting-fast skill usage feels rewarding. The experience highlights immersive feedback loops such as HUD elements, pause/resume flow, and score tracking.

## Key Features

- **Player experience**: Responsive WASD movement with fluid acceleration/deceleration, clear health visualization via floating health bars, and a satisfying feedback loop from killing enemies.
- **Abilities**: Left-click spawns timed mushrooms that detonate, while right-click (unlocked at level 2) casts Entangling Vines to root enemies, giving the player tactical control.
- **Cast bars & status indicators**: Visually communicate channeling using dedicated cast bar UI elements
- **Kill counter & XP tracking**: A persistent kill counter and experience display celebrate performance and encourage competitive play.
- **Pause flow**: Easily pause/resume gameplay to take breaks or inspect UI without losing progress.

## Controls

| Action             | Input          |
|--------------------|----------------|
| Move               | `W`, `A`, `S`, `D` |
| Spawn Exploding Mushrooms | Left Mouse Button |
| Cast Entangling Vines (level 2+) | Right Mouse Button |
| Pause/Resume        | `Esc` key (default Godot shortcut) |

## Known Issues

- When rooted, the player can collide with farmers without taking damage. This is unintended. Farmers should deal damage on collision with the player while rooted.

## Getting Started

1. Open the project in Godot 4.2 or later.
2. Run `scenes/main.tscn` to start the demo.
3. Use the HUD feedback (health bars, kill counter, cast bars) to monitor your status as you fight through waves of farmers.

## To Do List
- Add visual feedback on the UI to indicate the remaining cooldown on Entangling Vines.
- Add a persitent "Most Kills" tracker that saves between sessions. Display the "Most Kills" along with the current kill counter on player death.
- Add a settings menu to the pause screen. Add a simple UI to change abilities and movement key bindings.
- Fix the bug where farmers can not deal damage while rooted by Entangling Vines.
- Add sounds effects or music
- Add new types of farmers. For example, a torch-wielding farmer. Very similar to the current pitchfork farmer, except their attack is a damage-over-time burning effect. Remain modular and scalable so DRUID can have many different types of enemies to slaughter!
- Refactor the game to have less nodes and scenes. Explore using the rendering server for better performance and optimization.

## Suggested Best Practices

- Keep the UI modular: scene files like `ui/kill_counter.tscn`, `ui/xp_counter.tscn`, and ability-specific overlays are great candidates for reusable control nodes.
- Document input mappings in `project.godot` so contributors can align on consistent controls or add alternative bindings.
- When adding new abilities or enemies, consider creating new scripts with `class_name` definitions and strict type hints (e.g., `class_name Villager`, `var player: Player`).
- Use version control-friendly commits that describe gameplay tweaks (e.g., "Adjust mushroom explosion timing").
- Add tests if you expand to deterministic logic (e.g., ability cooldown calculations) to keep the experience stable as features grow.

## Contributing

Pull requests are welcome! Feel free to file issues for bugs or feature ideas. Include a short summary of your changes and how to test them.

## License

This project is open source. Please specify a license (MIT, GPL, etc.) in your GitHub repository before publishing.
