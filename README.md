# MP Fighter

MP Fighter is a fighting game where you can record yourself to create a custom character.
It was created as a submission for Hack K-State 2022 https://devpost.com/software/mp-fighter.

The game consists of two components:
 - A Flask webserver which runs the vision processing
 - A Godot Engine game

To run the game, you should first start up the server with:

`python main.py`

Once the server is running, you can start the game which will connect to the server at `127.0.0.1:8080`.

## Dependencies for the webserver
 - mediapipe
 - opencv2
 - pygrabber
 - flask

## Dependencies for the game
 - Godot Engine

## Third-party assets in repo
 - [Godot Kenney UI Theme](https://azagaya.itch.io/kenneys-ui-theme) licensed CC0
 - [Kenney UI Pack](https://www.kenney.nl/assets/ui-pack) licensed CC0
 - [Kenney Button Prompts: Pixel x16](https://www.kenney.nl/assets/input-prompts-pixel-16) licensed CC0
 - [Kenney Particle Pack](https://www.kenney.nl/assets/particle-pack) licensed CC0
 - [Game Icons](https://game-icons.net/) licensed CC-BY3.0
 - [Kenney Impact Sounds](https://www.kenney.nl/assets/impact-sounds) licensed CC0
 - [Kenney Voiceover Pack: Fighter](https://www.kenney.nl/assets/voiceover-pack-fighter) licensed CC0
