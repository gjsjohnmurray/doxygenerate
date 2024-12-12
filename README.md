 # Doxygenerate
A package that leverages [Doxygen](https://www.doxygen.nl/) to create a set of static pages documenting the classes in a namespace.

## Description
TODO

## Installation

### Option A: Add Doxygenerate to your own IRIS instance
1. Make sure you have Doxygen installed on your IRIS host.
    - A Windows installer is available [here](https://www.doxygen.nl/download.html).
    - Linux platforms can typically install it using their package manager. The `graphviz` package is also recommended in order to get diagrams in the generated documentation. For example:
        ```
        $ apt-get install doxygen graphviz
        ```
2. Use IPM / ZPM to install the Doxygenerate package. This can be done from any namespace as it will add a DOXYGEN namespace to your IRIS environment:
    ```
    USER>zpm "install Doxygenerate"
    ```

### Option B: Clone repository locally and launch its IRIS Community Edition Docker container
1. Make sure you have Docker Desktop and git installed locally.

2. Clone the repository locally.
    ```
    git clone https://github.com/gjsjohnmurray/doxygenerate.git
    ```

3. Switch into the folder this created, then build and launch the container
    ```
    cd doxygenerate
    docker-compose build
    ...
    docker-compose up -d
    ```
*Note: Linux users may need to use "docker compose" instead of "docker-compose"*

TODO

## Usage

Point your web browser at the `/csp/doxygen/Home.csp` page of the web server that hosts your IRIS instance's web applications (including the IRIS Portal).

## How does it work?

## Repository structure

### .github folder

Contains two GitHub actions workflows:
1. `github-registry.yml`
    Once changes pushed to the repo, the action builds the docker image on Github side and pushes the image to Github registry that can be very convenient to further cloud deployement, e.g. kubernetes.
2. `objectscript-qaulity.yml`
    with every push to the main branch the workflow launches the repo test on objectscript issues with Objectscript Quality tool, [see the examples](https://community.objectscriptquality.com/projects?sort=-analysis_date). This works if the repo is open-source only.

Both workflows are repo agnostic: so they work with any repository where they exist.

### .vscode folder
Contains three files to setup the VS Code environment:

#### .vscode/settings.json

Settings file to let you work in VS Code with the [InterSystems ObjectScript extension pack](https://marketplace.visualstudio.com/items?itemName=intersystems-community.objectscript-pack).

#### .vscode/launch.json

Config file ready for if you want to debug with the InterSystems ObjectScript extension.

#### .vscode/extensions.json

Extension recommendations for this workspace.

### src folder

Contains source files.

### tests folder
Contains unit tests for the ObjectScript classes

### dev.md

Contains a set of useful commands that will help during the development

### docker-compose.yml

A docker engine helper file to manage images building and rule ports mapping an the host to container folders(volumes) mapping

### Dockerfile

The simplest dockerfile which starts IRIS and imports code from /src folder into it.
Use the related docker-compose.yml to easily setup additional parameters like port number and where you map keys and host folders.

### iris.script

Contains objectscript commands that are fed to IRIS during the image building

### module.xml

IPM Module's description of the code in the repository.
It describes what is loaded with the method, how it is being tested and what apps neeed to be created, what files need to be copied.


## Troubleshooting

If you have issues with docker image building here are some recipes that could help.

1. You are out of free space in docker. You can expand the amount of space or clean up maually via docker desktop. Or you can call the following line to clean up:
```
docker system prune -f
```
