# EinsteinMonotile_GameOfLife
 
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Godot 4](https://img.shields.io/badge/Godot-4.x-blue)
 
Hi Everybody! Welcome to my page. I've made a toy version of Conway's Game of Life, but on the aperiodic grid using the Einstein (also known as the "Hat") tile. I hope you find it interesting!

https://github.com/user-attachments/assets/a28f04a6-b8c0-467b-82bb-d9637c3f7193

## About
 
The Game of Life is a cellular automaton devised by mathematician John Conway in 1970. Every cell is either alive or dead, and each generation applies four simple rules simultaneously to every cell — underpopulation, survival, overpopulation, and reproduction. From these four rules, extraordinary complexity can emerge.
 
What makes this implementation different is the grid itself.
 
In 2023, David Smith et al. discovered the **Einstein monotile** — a 13-sided shape, nicknamed the "hat," that tiles the plane without ever repeating. This was a landmark result in mathematics, solving a decades-old open problem in the theory of aperiodic tilings.
 
On a standard square grid, every cell has the same number of neighbors. The uniformity is what makes classic Game of Life patterns portable and predictable. The hat tiling breaks that invariance entirely. Depending on where it sits in the tiling, each cell has either **6 or 7 neighbors**, and no two tiles share exactly the same local geometry. A pattern that oscillates in one region may stabilize, mutate, or collapse entirely if placed just a few tiles over.
 
This makes the aperiodic grid a genuinely different computational substrate — and what survives here is largely an open question.

Because of my implementation of the tiling procedure, the game is actually too big to host on GitHub Pages, so you will have to clone the repository and play it yourself in Godot. This is because it's nontrivially difficult to infinitely tile the plane with this shape. I used a bottom-up approach, with an algorithm that builds progressively larger structures given a handful of starting structures. The grid in this game is not infinite, unfortunately! It can only be used to investigate local Game of Life patterns.
I hope to make this game smaller and browser friendly in the future! 


## Controls
 
| Input | Action |
|---|---|
| Left click | Toggle cell alive / dead |
| Click and drag | Paint multiple cells |
| Scroll wheel | Zoom in / out |
| Middle click drag | Pan |
---
 
## Built With
 
- [Godot 4.6](https://godotengine.org/)
- [GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/)
---

## Gallery
As we discover interesting patterns, share them below!

### Blinker
<img width="630" height="548" alt="Blinker" src="https://github.com/user-attachments/assets/88140700-77f5-4c57-8159-95ebbd75aa48" />

### Carabiner
<img width="558" height="544" alt="carabiner" src="https://github.com/user-attachments/assets/1441fea2-254c-48a2-8dc7-69fe1e3e37f6" />
 
## Further Reading
- Smith et al. (2023) — [An aperiodic monotile](https://arxiv.org/abs/2303.10798)
- [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) — Wikipedia
- [asmoly's Tile Generator](https://github.com/asmoly/Einstein_Tile_Generator)
---
 
