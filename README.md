 # Doxygenerate
A package that leverages [Doxygen](https://www.doxygen.nl/) to create a set of static pages documenting the classes in a namespace.

## Description
This package is my entry to the December 2024 Developer Community ["Bringing Ideas to Reality"](https://openexchange.intersystems.com/contest/39) contest, implementingthe idea of  [a generator that produces a static set of class reference pages ](https://ideas.intersystems.com/ideas/DPI-I-188).

## Installation

### Option A: Clone repository locally and launch its IRIS Community Edition container

For convenience this option uses VS Code, but it is also possible to use similar steps independent of VS Code.

1. Make sure you have VS Code, git and Docker Desktop installed locally.
2. Launch VS Code, then close any existing open workspace / folder / files.
3. Clone the `https://github.com/gjsjohnmurray/doxygenerate.git` repository locally (e.g. by running `Git: Clone` from Command Palette, or by clicking the equivalent Welcome page link).
4. Open the folder this created, and if prompted confirm that you trust its contents.
5. If prompted, install recommended extensions.
6. If a notification suggests reopening the folder in a container, ignore this and continue working locally.
7. In Explorer view, use the context menu of the `docker-compose.yml` file to run `Compose Up`.
8. Wait for the container to start. This is likely to take several minutes. The `Building doc...` steps take a while, particularly for the IRISLIB and ENSLIB databases.
9. Click on the `ObjectScript` panel of the VS Code status bar. From the top-center menu choose `Refresh Connection`. The status bar panel's label will change to `docker:iris:NNNNN[USER]`.
10. Click that panel again and choose `Browse Generated Documentation`.
11. Click the `USER` link on the launch page.

You can now browse the Doxygen documentation for Doxygenerate's own ObjectScript packages.

Other links from the `/csp/doxygen/Home.csp` launch page let you explore the extensive IRIS library packages.

Import your own IRIS classes into the USER namespace, then use the `Regenerate` button to update the static documentation.

Alternatively, add your own namespace to the container's IRIS instance and put your classes there. Then reload the Doxygenerate launch page and generate that namespace's documentation.

### Option B: Add Doxygenerate to your own IRIS instance
1. Make sure you have Doxygen installed on your IRIS host.
    - A Windows installer is available [here](https://www.doxygen.nl/download.html).
    - Linux platforms can typically install it using their package manager. The `graphviz` package is also recommended in order to get diagrams in the generated documentation. For example:
        ```
        $ apt-get install doxygen graphviz
        ```
2. Use [IPM / ZPM](https://github.com/intersystems/ipm) to install the Doxygenerate package. It only needs to be installed in one namespace, from where it can generate documentation for any namespace. Choose an interop-enabled namespace if you want to document any interop applications. We suggest picking the USER namespace:
    ```
    USER>zpm "install Doxygenerate"
    ```
3. Point your web browser at the `/csp/doxygen/Home.csp` launch page of whichever web server that hosts your IRIS Portal.

You can now browse the Doxygen documentation for the namespace you installed Doxygenerate into, including its own ObjectScript packages. You can also generate documentation for other namespaces in your IRIS environment.

## Use
Links from the launch page let you:
- explore the extensive IRIS library packages;
- generate documentation for other namespaces;
- regenerate documentation after updating classes in a namespace.

Remember that (re)generation can take a while, particularly for a namespace whose code database contains a lot of classes.

We host the generated documentation in an IRIS webapp merely as a convenience. The files Doxygen created for us are static and can be found in subfolders of the folder that the Physical Path property of the `/csp/doxygen` IRIS web application points to. In each subfolder the home page is `index.html`.
- For ordinary namespaces the subfolder name matches the namespace name (e.g. USER).
- For %SYS the subfolder is `_SYS`
- For the IRISLIB and ENSLIB library databases, which don't have their own namespaces, the subfolders are `__IRISLIB` and `__ENSLIB` respectively.

## How does it work?
1. The `Build` method of IRIS's `%Atelier.v1.Utils.MetaData` class is used to create files that each contain a JSON representation of a class's structure (not including implementation code or storage details).
2. Our package ingests these JSON files and emits Python [simulacrum](https://en.wikipedia.org/wiki/Simulacrum) files whose structure mimics the IRIS classes sufficiently well to meet Doxygen's expectations for Python code documentation.
3. Doxygen gets to work and eventually emits a set of static files headed by `index.html`.

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
Contains unit tests for the ObjectScript classes.

### dev.md

Contains a set of useful commands that may help during development.

### docker-compose.yml

A docker engine helper file to manage image building, host-to-container mapping rules for ports and folders (volumes), etc.

### Dockerfile

The dockerfile which starts an IRIS container and loads the package into it. You can use the related docker-compose.yml to adjust parameters, for example to bind to fixed local port numbers.

### iris.script

Contains objectscript commands that are fed to IRIS during the image building

### module.xml

IPM module specification.
