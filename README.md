# FiniteStateMachine
A Plugin with an FSM and its components State and Transition as Nodes.

## Getting Started
### Requirement
* Godot Engine v3.2+

### Installation
After downloading, move the folder "addons/fsm-node" to your project folder.

For additional script templates, move folder "script_templates" to your project folder as well.

## Usage
After adding FSM, add States and Transitions as its children Nodes.

* A State can run its logic by calling ```_process(delta)```, ```_physics_process(delta)``` and/or ```_input(event)```
* Other Nodes can connect their signals to a Tranistion using a method, ```_condition()```. This is to prompt the FPS to change State.

Upon running the project, all States deactivate their process functions, and all Transitions disconnect their incoming signals. The FSM will keep one State activated and re-connect the incoming signals of the Transitions connected to the State.

## Author
* mechPenSketch

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Contributions
In addition to sponsors, you can support me by buying these merch:
* [Shirts](https://mechpensketch.creator-spring.com/listing/mechPenSketch-fsm?product=2) - [Phone Cases](https://mechpensketch.creator-spring.com/listing/mechPenSketch-fsm?product=1532) - [Pillows](https://mechpensketch.creator-spring.com/listing/mechPenSketch-fsm?product=585)
* [Mugs](https://mechpensketch.creator-spring.com/listing/mechPenSketch-fsm?product=658) - [Pouches](https://mechpensketch.creator-spring.com/listing/mechPenSketch-fsm?product=1097) - [Bags](https://mechpensketch.creator-spring.com/listing/mechPenSketch-fsm?product=933)

## Acknowledgements
* GDQuest and PigDev's youtube videos for helping me understand the concept of FSM better.
* Using [FSM by kubecz3k](https://github.com/kubecz3k/FiniteStateMachine) also helps me understand the concept better.
