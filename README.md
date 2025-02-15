Assignment - 2D and 3D Transformations
Overview

This project implements 2D and 3D transformations in Processing 4.3. It includes a camera system, a hierarchical transformation model, and custom matrix operations to manipulate shapes in a scene. The assignment focuses on manual matrix transformations rather than built-in Processing functions.
Features Implemented

![image](https://github.com/user-attachments/assets/34f2b265-c055-4437-ba95-06b11803d8c7)
![image](https://github.com/user-attachments/assets/0f157b9a-4a2f-43a7-8d8e-f45ff76b25a2)
![image](https://github.com/user-attachments/assets/6c828646-7623-4db9-8620-8a220f98acf4)

Camera and Projection System

    Implemented a custom camera system with adjustable zoom, rotation, and movement.
    Supported orthographic projections with different viewport configurations.
    Allowed switching between predefined orthographic modes.
    Used view, projection, and viewport matrices to transform objects.

Hierarchical Transformations

    Implemented custom transformation functions (myScale(), myTranslate(), myRotate()).
    Used matrix stack operations (myPush(), myPop()) for hierarchical transformations.
    Constructed a procedural tree structure using recursive transformations.

Scene and Object Rendering

    Rendered a dynamic scene with multiple objects, using transformations for positioning.
    Implemented a custom vertex transformation pipeline (myVertex()) that applies model, view, projection, and viewport matrices before plotting points.
    Generated and moved random flying shapes, with 3D perspective projection applied.
    Implemented a test pattern mode for debugging transformations and projection matrices.

Custom Matrix Operations

    Created custom projection matrices for orthographic and frustum-based views.
    Implemented camera transformation matrices using up and perpendicular vectors.
    Used a perspective division step to properly project 3D coordinates onto the 2D viewport.

Interactive Controls

    Allowed real-time camera movement and zooming via mouse drag.
    Enabled switching between different display modes (test pattern, scene, flying shapes) using hotkeys.
    Supported interactive transformations using keyboard inputs.

Usage

    Open the .pde files in Processing 4.3 and run the program.
    Use keyboard shortcuts to switch projection modes and display configurations.
    Drag the mouse to adjust the camera position.
    Observe the hierarchical transformations in the tree structure and flying shapes.

Submission

All .pde files required for execution are included. The implementation follows structured and modular design principles.
