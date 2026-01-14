%Code used for a MATLAB project in joint with two other partners

%Following code was written by Safwan Ikbal, as contribution to the project

%Code will not run without the specific arduino UNO, light/force sensor setup

%Section B of the code will run. 
%Will limit user to viewing the game's map as well as moving the character


%% Section A
function [currentRoom, keyobtained] = SafwanPuzzle(com) %Turn the room into a function

a = arduino(com, "Uno"); %Initialize Arduino

%Initialize the buttons and their pins on the Arduino

buttonAPin = 'D7'; 
buttonA = readDigitalPin(a, buttonAPin);

buttonBPin = 'D8';
buttonB = readDigitalPin(a, buttonBPin);

lightAPin = 'D9';
lightA = readDigitalPin(a, lightAPin);

lightBPin = 'D2';
lightB = readDigitalPin(a, lightBPin);

speakerPin = 'D3';
configurePin(a, speakerPin, 'PWM');

FSR_PIN = 'A0';
fsrVoltage = readVoltage(a, 'A0'); % Read initial force sensor voltage

%% Section B
%Define the spritesheet
sprites = escapeRoomEngine('SlasherSpritesheet.png',16,16,1,1,16,[255,255,255]); %Load sprite sheet

%Dimensions of the playing space in cell units
roomwidth = 15; %Grid width in cells
roomheight = 15; %Grid height in cells
invis_tile = 42; %Invisible/blank tile

%Create the background
background = [... 
    5,5,5,5,5,5,5,5,5,5,5,5,5,5,5;
    5,5,5,5,5,5,5,5,5,5,5,5,5,5,5;
    5,9,62,9,9,9,9,9,9,9,9,9,9,9,5;
    5,23,76,2,2,2,2,2,79,80,2,2,2,9,5;
    5,9,2,2,2,2,2,94,2,95,2,96,2,9,5;
    5,23,2,2,2,2,2,2,2,2,2,2,2,9,5;
    5,9,2,2,2,2,2,85,2,88,2,89,2,9,5;
    5,23,2,2,2,2,2,2,2,2,2,2,2,9,5;
    5,9,2,2,2,2,2,2,2,2,2,2,2,9,5;
    5,23,2,2,2,2,2,2,2,2,2,2,2,9,5;
    5,9,2,2,2,2,2,2,2,2,2,2,2,9,5;
    5,23,2,2,2,2,2,2,2,2,2,2,2,9,5;
    5,9,23,23,23,23,23,9,9,9,9,9,9,9,5;
    5,5,5,5,5,5,5,5,5,5,5,5,5,5,5;
    5,5,5,5,5,5,5,5,5,5,5,5,5,5,5];

%fill the foreground matrix with blank cells except wizard
foreground = ones(roomheight, roomwidth)*invis_tile; %blank foreground
wizard_y = 4;
wizard_x = 3;
fwd_pos = 22; %wizard sprite facing forward
right_pos = 64; % wizard sprite facing right
left_pos = 36; % wizard sprite facing left
back_pos = 50; % wizard sprite facing backward
foreground(wizard_y, wizard_x) = fwd_pos; %initialize the first cell to the little wizard. 
foreground(end, end) = 14; % initialize door sprite

%initialize scene
drawScene(sprites, background, foreground)

framerate = 30; % frames per second
in_door = 0;
keyobtained = 0;

%while loop for the game
while (in_door == 0)
    %Get user input
    key_down = getKeyboardInput(sprites);

    %Update foreground based on input
    %Foreground matrix updated every time through the loop depending on arrow pushed
    %Set boundaries of specific sprite sheets for the walls

    if (strcmp(key_down,'rightarrow') == 1 && wizard_x < roomwidth)
        foreground(wizard_y,wizard_x) = invis_tile;
        if background(wizard_y, wizard_x+1) == 9 || background(wizard_y, wizard_x+1) == 23
            wizard_x = wizard_x + 0; %wall hit, stay in place
        else
            wizard_x = wizard_x + 1;
        end
        foreground(wizard_y, wizard_x) = right_pos;
    elseif (strcmp(key_down,'leftarrow') == 1 && wizard_x > 1)
        foreground(wizard_y, wizard_x) = invis_tile;
        if background(wizard_y, wizard_x-1) == 9 || background(wizard_y, wizard_x-1) == 23
            wizard_x = wizard_x + 0; %wall hit, stay in place
        else
            wizard_x = wizard_x - 1;
        end
        foreground(wizard_y, wizard_x) = left_pos;
    elseif (strcmp(key_down,'uparrow') == 1 && wizard_y > 2)
        foreground(wizard_y, wizard_x) = invis_tile;
        if background(wizard_y-1, wizard_x) == 9 || background(wizard_y-1, wizard_x) == 23
            wizard_y = wizard_y + 0; %wall hit, stay in place
        else
            wizard_y = wizard_y - 1;
        end
        foreground(wizard_y, wizard_x) = back_pos;
    elseif (strcmp(key_down,'downarrow') == 1 && wizard_y < roomheight)
        foreground(wizard_y, wizard_x) = invis_tile;
        if background(wizard_y+1, wizard_x) == 9 || background(wizard_y+1, wizard_x) == 23
            wizard_y = wizard_y + 0; %wall hit, stay in place
        else
            wizard_y = wizard_y + 1;
        end
        foreground(wizard_y, wizard_x) = fwd_pos;
    end

    %Code below commented out for functionality of the puzzle for viewers
    %Allows user to test game without Arduino
    % fsrVoltage = readVoltage(a, FSR_PIN); %Read force sensor voltage
    % V_plus = 5;        %Voltage in volts
    % Rm = 10000;        % Resistor value in ohms
    % R_FSR = (Rm*V_plus - fsrVoltage*Rm)/fsrVoltage; %FSR resistance
    % G = 1 / R_FSR;     %Inverse resistance

    drawScene(sprites, background, foreground)
    disp(foreground);
    disp(background);

    % Test wizard position for messages, keys, win conditions
    if ( (wizard_y==5 && wizard_x==3 && keyobtained==0) || (wizard_y==4 && wizard_x==4 && keyobtained==0) )
        msgbox('Hold force sensor BEFORE you pick your answer') %Show instructions
        pause(2);
    end

    if (wizard_y == 5 && (wizard_x == 12 || wizard_x == 8)) %incorrect answer
        msgbox('Incorrect answer. Restart') %Show incorrect message
        pause(2);
        configurePin(a, 'D9','DigitalOutput'); %Turn on red light for incorrect answwer
        writeDigitalPin(a, 'D9', 1);  
        pause(3); 
        writeDigitalPin(a, 'D9', 0); %play sad tune for incorrect answer
        %play sad tone
        playTone(a,speakerPin,1430,1.2);
        pause(0.8)
        playTone(a,speakerPin,1000,1.2);
        pause(0.8)
        playTone(a,speakerPin,900,0.4);
        playTone(a,speakerPin,850,0.4);
        playTone(a,speakerPin,900,0.4);
        playTone(a,speakerPin,850,0.4);

        foreground(wizard_y, wizard_x) = invis_tile;
        wizard_x = 3;
        wizard_y = 4; % Reset wizard position
        foreground(wizard_y, wizard_x) = fwd_pos;
        drawScene(sprites, background, foreground);
    end

    if (wizard_y == 5 && wizard_x == 10) %check for the correct answer location
        msgbox('Squeeze the force sensor!!'); %Prompt to press force sensor
        pause(2);
        configurePin(a, 'D2','DigitalOutput'); %Turn on the green light for the correct answer
        writeDigitalPin(a, 'D2', 1);
        pause(3);
        writeDigitalPin(a, 'D2', 0);

        %play tone for win
        playTone(a,speakerPin,261.63,1); 
        playTone(a,speakerPin,293.66,1); 
        playTone(a,speakerPin,329.63,1); 
        playTone(a,speakerPin,349.23,1); 

        % Clear wizard's previous position
        foreground(wizard_y, wizard_x) = invis_tile;
        %Update wizard's position
        wizard_x = 10; 
        wizard_y = 6;
        foreground(wizard_y, wizard_x) = fwd_pos;
        drawScene(sprites, background, foreground);


       if fsrVoltage > 0.5 %check if user presses the force sensor
            foreground(7, 10) = 91; %unlock the chest by changing the sprite image to unlocked chest
            foreground(wizard_y, wizard_x) = fwd_pos; % Update new position
            drawScene(sprites, background, foreground); % Update the scene
        end

       if (wizard_y == 6 && wizard_x == 10) %Check user position to ask the user to collect the key
            msgbox('Collect The Key!')
            pause(2);
            keyobtained=1; %set keyobtained to one, to let the code know that the key is obtained
            %Change foreground to display unlocked door
            foreground(3, 3) = 63;
            foreground(4,3) =77;
            foreground(wizard_y, wizard_x) = fwd_pos; % Update new position
            drawScene(sprites, background, foreground); % Update the scene
        end
    end

    %check if the user has the key, and if the user is in exit position
    if (wizard_y == 4 && wizard_x == 3) && keyobtained ==1
        msgbox('You win'); %display win message
        pause(2);
        in_door=1;
        currentRoom=2; %send the user back to the living room
    end
end
end

