# FiniteStateMachine
A Plugin with an FSM and its components State and Transition as Nodes.

## Getting Started
### Requirement
* Godot Engine v3.2+

### Installation
After downloading, move the folder "addons/fsm-node" to your project folder.

## Usage
After adding FSM, add States and Transitions as its children Nodes.

* A State can run its logic by calling ```_process(delta)```, ```_physics_process(delta)``` and/or ```_input(event)```
* Other Nodes can connect their signals to a Tranistion using a method, ```_condition()```. This is to prompt the FPS to change State.

Upon running the project, all States deactivate their process functions, and all Transitions disconnect their incoming signals. The FSM will keep one State activated and re-connect the incoming signals of the Transitions connected to the State.

## Author
* mechPenSketch

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgements
* GDQuest and PigDev's youtube videos for helping me understand the concept of FSM better.
* Using [FSM by kubecz3k](https://github.com/kubecz3k/FiniteStateMachine) also helps me understand the concept better.
