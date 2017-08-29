# BruteSolver

Just crazy straight way of solving(finding at least one solution) equation.

Should always place tactical spaces when providing equation. Like x + 1 instead of x+1.

## Variants

Right now its only 2 brutes. Completely random and intelligent one.

## Usage

Very poor right now, but at least something.

Do this: 
```bash
mix do deps.get, deps.compile
```
then:
```bash
iex -S mix
```
and then:
```elixir
BruteSolver.solve(IntelligentBrute, "x ^ 2 + y ^ 2 - 1")
```
So sad though that it is a bad example. But: 
```elixir
BruteSolver.solve(RandomBrute, "x ^ 2 + y ^ 2 - 1")
``` 
is much worse.

Also you can do this: 
```elixir
BruteSolver.solve_and_draw(IntelligentBrute, "x ^ 2 + y ^ 2 - 1")
```
which result in a drawing.
The name of which will be "#{notation}.png". And it will be containing process of selecting possible solutions, but only
after complete halt of the brute.

## TODO

- [ ] What is that thing they call `Behavior`?
- [ ] What is that things they call `Supervisor` and `GenServer`?
- [ ] Why is that simply one threaded? Should you probably make the tree of brutes that have each only little block and that crunch for solution in it?
- [ ] Why even the most intelligent brute could not solve "x ^ 2 + y ^ 2"? Maybe you should use gradient slide(is that what it called?).
- [ ] Maybe should add more options, like limits and such. But on the other hand, when it is wrapped in GenServer, do I really need it?

