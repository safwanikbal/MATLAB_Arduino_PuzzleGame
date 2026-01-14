%This demo shows how to layer sprites on top of each other and use a
%keyboard to control character movement. 
%In this simple demo a wizard sprite is put on top of a grass backround and
%is able to walk around the image using the arrow keys until reaching the 
% door at which point you "win"

function [] = getKeyboardInput()

close all

%initialize sprites
room = escapeRoomEngine('retro_pack.png',16,16,0,1,16,[255,255,255]);

%Set room to a dim x dim filled with background
max_dim=5;
background=ones(max_dim,max_dim)*17*32+2; %Checkered background
%background(2,3)=22;
background(end, end)=14*32+1; %initialize bottom corner to a door image to navigate to

%fill the foreground matrix with blank cells except 1 which is the wizard
foreground=ones(max_dim,max_dim)*1; %the 1st cell is a blank cell
wizard_r=1;
wizard_c=1;
blue_guy_pos=7*32+22;
foreground(wizard_r,wizard_c)=blue_guy_pos; %initialize the first cell to the little wizard. 

%initialize scene
drawScene(room, background, foreground)

framerate = 30; % frames per second
in_door=0;
%will continuously run until person walks through door
while(in_door==0)
    %Get user input
    key_down = getKeyboardInput(room);
    
    %Get user input every time throught the loop
    %Foreground matrix updated every time through the loop depending on
    %arrow pushed
    if(strcmp(key_down,'rightarrow')==1 && wizard_c<max_dim)
        foreground(wizard_r,wizard_c)=1;
        wizard_c=wizard_c+1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'leftarrow')==1 && wizard_c>1)
        foreground(wizard_r,wizard_c)=1;
        wizard_c=wizard_c-1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'uparrow')==1 && wizard_r>1)
        foreground(wizard_r,wizard_c)=1;
        wizard_r=wizard_r-1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    elseif(strcmp(key_down,'downarrow')==1 && wizard_r<max_dim)
        foreground(wizard_r,wizard_c)=1;
        wizard_r=wizard_r+1;
        foreground(wizard_r,wizard_c)=blue_guy_pos;
    end

    %Test if wizard is at the door matrix positions
    if(wizard_r==max_dim && wizard_c==max_dim)
        in_door=1; %got to door
        msgbox('You win!');
    end

    %Update the matrix image to the screen. 
    drawScene(room, background, foreground)
end

end