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
### Guided 
1. Clone the repository ```git clone  --recurse-submodules git@github.com:pan-sveta/gamajun-system.git```
2. Add run privilidge ```chmod +x install.sh```
3. Run the script ```./install.sh```

### Manual 
1. Clone the repository ```git clone  --recurse-submodules git@github.com:pan-sveta/gamajun-system.git```
2. Configure environment variables in gamajun-client and gamajun-server
3. Build the image ```docker compose build```
4. Run the container ```docker compose run```

