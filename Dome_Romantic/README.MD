Hi, I’m Nezvers and I do stuff.
Today I want to look at the fun movement mechanic in Dome Romantik's game. Funnily enough, Dome Romantik is also made with the Godot engine.
So in this video, I will show you how to create:
- Simple top-down movent that suits well with floaty, space side-scroller like Dome Romantik
- So simple that we will add kickback, like Dome Romantik walls. In a way, you can insert your logic to expand this behavior for your game
- Rigidbodies that feel hard to drag
- Physics joints to pull those heavy objects
- Manually drawn lines
It won’t be the most performant way how to handle things but it’s easy enough to improve and expand.

First, let’s set up our project windowing and input. I’m going for a lower resolution game so the game’s resolution is set to 460x320 you can make it the way you like. Stretch mode 2D and keep the “keep height” as my settings. For inputs, I created move_right, left, up, down, and interact actions. Map them how you like, but for myself, I used physical keys (introduced in 3.4 update).

Now we can start with the easiest part, making walls. For that, I’ll use simple StaticBody2D and my script to make shapes visible in color. With that ready, we can block out the level. The project is going to a repository so you can take a look at it yourself. The link is in the description. I won’t be covering the drilling in the game but you’ll get the kickback mechanic, about that a little bit later.

The even simpler task will be making a scene for the game's rope which I found easy to replicate with DampedSpring2D. We need a scene for spawning them for each connection and have the spring settings ready.

For rocks, we need RigidBody2D and the crucial detail is PhysicsMaterial that gives harder dragging. I’ll give it my shape drawing script. Play with all available parameters on RigidBody to find the game feel you like or even spark a new game idea. The most important part is to decide which collision bits to set for your items. I’ll put the 3rd bit for the layer and for the mask, I want to have items not only collide with walls that are left in the default 1st bit but I also want items to collide with other items, so I’ll set the 3rd bit too.

Now we can start to work on the player scene. To keep visuals simple it also will get my shape drawing script. Camera2D for a built-in camera that follows the player. I’ll add Area2D to detect items we want to connect. Again now the important part is to assign collision bits. I’m reserving the 2nd bit for the player, so that goes for the layer and I want the player to collide only with walls, so it’s the 1st bit.
For the player's script, I like to start with an empty script. I want to export a few variables for easier control in the Inspector. Those are movement speed, acceleration for the game feel, strength for carrying weight, springScene which will do the preload of the spring scene, and the last one “areaPath” for players detector. Then assign right away the reference to the area node with an onready variable.

I’m using couple of variables for the player. Velocity will keep movement speed, dir for input direction, bumpStrength depends on your acceleration speed and game feel. The itemList array keeps references to items and the same for springList array.

The draw function for each item will draw a line connecting it to the player. It means no item, no drawing.
I’ve seen a lot of beginners codes that are using if checks for each direction and that is comparable to shooting in your own leg with a black hole. Because that’s where you’ll spend your time when you’ll need to add something more than a walking direction to your game. Always create a usable solution for more than one purpose (mainly in numbers rather than binary bool values true or false). So here’s my approach.
In the physics_process, I put together a neat vector for desired movement direction. For that, I reset it to zero. It works by subtracting opposite movement directions strength - positive direction subtracted by negative direction strength. In the result holding to the right will be zero to one, to the left will be zero to the minus one, but holding both directions will cancel each other getting zero. The same for the Y-axis. And after that, I normalize Vector always to get a vector with a length of one if there is any input.

For readability, carryMultiply is used as a percent for Encumbrance. I used the max function for the value to stop at zero.
With all the needed data I calculate the theoretical maximal velocity. Then using linear interpolation it’s easy to get acceleration and deacceleration values. 
The important part is to actually tell physics to move the player and conveniently Godot also solves collisions. To do that give move_and_slide function a velocity, but optionally also direction floor faces are facing if later you need to detect floors, walls, or ceilings. It is returning the remainder of the movement in case of a collision so it’s better to assign that value back to velocity.
To create bumping off walls I’m using functions in the KinematicBody2d class. Starting with creating for loop for each slide which is basically touching against surfaces. Then reference each collision by using loop index “i”. I don’t have any fancy checking for collision, so my rule is simply a valid collision value.
In the end, I’m triggering the draw function by calling the update function.

I prefer to use _unhandled_input for player inputs that don’t influence movement physics and it allows GUI or other situations to stop inputs that shouldn’t go further. So if an “interact” action event is triggered I use a built-in function in Area2D get_overlapping_bodies. Then I go through each detected item and check if it isn’t already inside the “itemList”, and if so I pass it to my function ConnectItem() then force the function to stop with the return. If all detected items are already inside the list and the for loop didn’t return I trigger the RemoveItem function.

In the ConnectItem function first thing, I check if the itemList is under the allowed size if no force to return. After that, I spawn a spring from the scene and add it as a child. To link with spring it requires NodePaths relative to it, so I use a built-in function for that with the player and the item. THen save references into lists.

The removal is simple. At the start, I check if the list is empty, if so return. I chose to remove things from the last added because it’s the fastest way with Arrays and it comes with the nice function “pop_back”. In my example, I need to queue_free only for the spring but maybe you have some other ideas for the item.
