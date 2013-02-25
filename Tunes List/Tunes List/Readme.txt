Tunes List - Created by Arvin Bhatnagar

Simple application for Mac OS X 10.7 or greater.

Purpose: Scan iTunes data and list its contents.

There is a plethora of techniques in this app, so let's get started.

1. The Files are well organized both physically and in the project.

- Resources
	|___ XIBs - User Interface XIB Files
	|___ Images - Images for the application

- Source
	|___ XIB Controllers - Typical Controllers for XIBs
	|___ Tunes - Set of classes that read iTunes Data

- Data - Classes for Core Data and other sticky info

- Modules
	|___ Communication - Reusable module for communication

- Tunes List - Standard application files

2. The XIB Window and View and Menu are in separate files.
Most noteably is the use of Autolayout versus springs and struts.

3. The images use an iconset for the application icon.
Also included is a vector graphic that scales well for retina displays.

4. The XIB Controllers includes a basic window controller,
view controller, and an object controller.
The view controller handles the one view in this app.
The object controller keeps references to the outlets
and also houses the TunesDB entity.

5. The design of Tunes is split-up in true object oriented style.
Tunes strings file contains user status text that can be localized.
Tunes manager is a singleton which reads and parses iTunes data.
In addition, the manager observes iTunes for saves and acts.
Tunes Parser controls the parsing of iTunes.
Tunes Tracks is a data class of iTunes data to access.
Tunes Objects works with core data and the iTunes data.

6. Data has two items A) Core Data B) Paths
A) Core Data is where the stack is created and an in-memory store.
B) Path has data to acquire the path for the iTunes Library XML file.

7. Modules contains code that can be reused for any project.
Communication is the module I am using with a receptionist design pattern.
I also created a class to use GCD as a timer versus NSTimer.

