# Gamajun System

The Gamajun Platform is specifically designed for educators who are teaching BPMN modeling.
This application aims to facilitate an interactive learning experience by offering a comprehensive system to train and verify the knowledge of BPMN diagrams.
Instructors can use this tool to create engaging lessons that reinforce students' understanding of business process modeling and notations, while students can benefit from a hands-on approach to mastering the intricacies of BPMN diagrams.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)

## Requirements
- Linux (WSL works well too!)
- Docker
- Docker-compose

## Installation
***Warning: Due to OAuth2 presence, you always have to use device/public ip addresses (eg. ip address of the computer in local network, public ip address or domain); localhosts and loopbacks will not probably work***

### Guided 
1. Clone the repository ```git clone  --recurse-submodules git@github.com:pan-sveta/gamajun-system.git```
2. Add run privilidge ```chmod +x install.sh```
3. Run the script ```./install.sh```

***WSL Note: You have to clone directly from WSL (to get right line endings) and provide ip address from Windows not WSL (get it from ipconfig in CMD or use public ip address)***

### Manual 
1. Clone the repository ```git clone  --recurse-submodules git@github.com:pan-sveta/gamajun-system.git```
2. Configure environment variables in gamajun-client and gamajun-server
3. Build the image ```docker compose build```
4. Run the container ```docker compose run```

