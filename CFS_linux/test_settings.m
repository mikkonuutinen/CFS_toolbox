function test_settings

  pkg load image % OCTAVE
  
  % Stimulus parameters
  stimuli_parameters = dlmread('stimulus_parameters.csv',',',1,2);
  

  % Set the variable values
  x1 = stimuli_parameters(2); % location x1
  x2 = stimuli_parameters(3); % location x2
  y1 = stimuli_parameters(4); % location y1
  y2 = stimuli_parameters(5); % location y2
  window_size = [x1 y1 x2 y2];
  bgcolor = stimuli_parameters(6); % intensity of gray background
  fixation_cross_color = [stimuli_parameters(7) stimuli_parameters(8) stimuli_parameters(9)]; % fixation cross color
  disparity = stimuli_parameters(10); % fixation cross distance
  refresh_rate = stimuli_parameters(27); % waiting time for Screen('Flip') in seconds

  brd_coord(1,:) = [stimuli_parameters(19) stimuli_parameters(20) stimuli_parameters(21) stimuli_parameters(22)]; % left stimulus image border coordinates
  brd_coord(2,:) = [stimuli_parameters(23) stimuli_parameters(24) stimuli_parameters(25) stimuli_parameters(26)]; % right stimulus image border coordinates

  stimulus_loc(1,:) = [stimuli_parameters(29) stimuli_parameters(30) stimuli_parameters(31) stimuli_parameters(32)]; % Stimulus 1 (right_down_right)
  stimulus_loc(2,:) = [stimuli_parameters(33) stimuli_parameters(34) stimuli_parameters(35) stimuli_parameters(36)]; % Stimulus 2 (right_down_left)                
  stimulus_loc(3,:) = [stimuli_parameters(37) stimuli_parameters(38) stimuli_parameters(39) stimuli_parameters(40)]; % Stimulus 3 (right_up_right)
  stimulus_loc(4,:) = [stimuli_parameters(41) stimuli_parameters(42) stimuli_parameters(43) stimuli_parameters(44)]; % Stimulus 4 (right_up_left)
  stimulus_loc(5,:) = [stimuli_parameters(45) stimuli_parameters(46) stimuli_parameters(47) stimuli_parameters(48)]; % Stimulus 5 (left_down_right)
  stimulus_loc(6,:) = [stimuli_parameters(49) stimuli_parameters(50) stimuli_parameters(51) stimuli_parameters(52)]; % Stimulus 6 (left_down_left)
  stimulus_loc(7,:) = [stimuli_parameters(53) stimuli_parameters(54) stimuli_parameters(55) stimuli_parameters(56)]; % Stimulus 7 (left_up_right)
  stimulus_loc(8,:) = [stimuli_parameters(57) stimuli_parameters(58) stimuli_parameters(59) stimuli_parameters(60)]; % Stimulus 8 (left_up_left)

    % initialize the fullscreen window
  stimulus_window = Screen('OpenWindow', 0, bgcolor, window_size);
  Screen('BlendFunction',stimulus_window,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');
  
  current_director=pwd;

  % Initialize screen function parameters
  Screen('Preference', 'SkipSyncTests', 2 );
  Screen('Preference', 'Verbosity', 0);
  Screen('Preference', 'SuppressAllWarnings', 1);
  Screen('TextFont', stimulus_window, 'Courier New');
  Screen('TextSize', stimulus_window, 12);    
      
  

  % DRAW BORDERS
  %[pixels map alpha] = imread('/home/mikko/grive/CFS/binocular_rivalry_v6/koodi/stimuli/border_test.png'); % OCTAVE
  [pixels map alpha] = imread(strcat(current_director,'/Borders_and_info/border.png')); % OCTAVE
  border = uint8(pixels);
  border(:,:,4) = uint8(alpha);
  brd = Screen('MakeTexture',stimulus_window,border*255); % make the texture
  Screen('DrawTexture',stimulus_window,brd,[],brd_coord(1,:),[],[],1.0);
  Screen('DrawTexture',stimulus_window,brd,[],brd_coord(2,:),[],[],1.0);

  % DRAW ALL STIMULUS POSITION OPTIONS
  image_path = strcat(current_director,'/Visual_targets/'); %OCTAVE
  image_dir=dir(image_path);     
  [image1 map alpha] = imread([image_path image_dir(3).name]); % The first image of the folder
  target1=image1;
  stimulus=target1;
  tex = Screen('MakeTexture',stimulus_window,stimulus);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(1,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(2,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(3,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(4,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(5,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(6,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(7,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(8,:) ,[],[],1.0);

  % DRAW POSITION TEXTS
  Screen('DrawText', stimulus_window, 'Position 1', stimulus_loc(1,1), stimulus_loc(1,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 2', stimulus_loc(2,1), stimulus_loc(2,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 3', stimulus_loc(3,1), stimulus_loc(3,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 4', stimulus_loc(4,1), stimulus_loc(4,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 5', stimulus_loc(5,1), stimulus_loc(5,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 6', stimulus_loc(6,1), stimulus_loc(6,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 7', stimulus_loc(7,1), stimulus_loc(7,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 8', stimulus_loc(8,1), stimulus_loc(8,2), [255, 0, 0, 255]);


  % DRAW FIXATION CROSS
  drawFixation(stimulus_window, disparity, fixation_cross_color);

  VBLTimestamp = Screen('Flip', stimulus_window, refresh_rate);
  pause(2)
  Screen('CloseAll');
  
  
  #######################################################################################################################
  
  % Set the variable values
  x1 = stimuli_parameters(2); % location x1
  x2 = stimuli_parameters(3); % location x2
  y1 = stimuli_parameters(4); % location y1
  y2 = stimuli_parameters(5); % location y2
  window_size = [x1 y1 x2 y2];
  bgcolor = stimuli_parameters(6); % intensity of gray background
  fixation_cross_color = [stimuli_parameters(7) stimuli_parameters(8) stimuli_parameters(9)]; % fixation cross color
  disparity = stimuli_parameters(10); % fixation cross distance
  refresh_rate = stimuli_parameters(27); % waiting time for Screen('Flip') in seconds

  brd_coord(1,:) = [stimuli_parameters(19) stimuli_parameters(20) stimuli_parameters(21) stimuli_parameters(22)]; % left stimulus image border coordinates
  brd_coord(2,:) = [stimuli_parameters(23) stimuli_parameters(24) stimuli_parameters(25) stimuli_parameters(26)]; % right stimulus image border coordinates

      
  % initialize the fullscreen window
  stimulus_window = Screen('OpenWindow', 0, bgcolor, window_size);
  Screen('BlendFunction',stimulus_window,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');

  

  % DRAW BORDERS
  %[pixels map alpha] = imread('/home/mikko/grive/CFS/binocular_rivalry_v6/koodi/stimuli/border_test.png'); % OCTAVE
  [pixels map alpha] = imread(strcat(current_director,'/Borders_and_info/border.png')); % OCTAVE
  border = uint8(pixels);
  border(:,:,4) = uint8(alpha);
  brd = Screen('MakeTexture',stimulus_window,border*255); % make the texture
  Screen('DrawTexture',stimulus_window,brd,[],brd_coord(1,:),[],[],1.0);
  Screen('DrawTexture',stimulus_window,brd,[],brd_coord(2,:),[],[],1.0);
  
  % Lets draw noise examples for visual target options 1,2,3 and 4 OR 5,6,7 and 8
  noise_coord(1,:) = [stimuli_parameters(11) stimuli_parameters(12) stimuli_parameters(13) stimuli_parameters(14)]; % left stimulus image border coordinates
  noise_coord(2,:) = [stimuli_parameters(15) stimuli_parameters(16) stimuli_parameters(17) stimuli_parameters(18)];
  noise_type = stimuli_parameters(61);
  sigma = stimuli_parameters(62); % sigma value for dead leaves noise
  noise_frequency = stimuli_parameters(63); % frequency of noise (in Hz)
  noise_variations = stimuli_parameters(64); % number of how many different images of noise to show
  range = stimuli_parameters(65); % upper limit for tonal range of 0 to 255 values 
  block_size = stimuli_parameters(66); % pixel size m x m
  filter = [1 1];
  noise_data = {noise_type, noise_frequency, noise_variations, block_size, range, filter, sigma};
  
  
  if (noise_data{1} == 1)
    img = create_noise_basic('grayscale',noise_data{4},noise_data{5},noise_data{6});
  end
  if (noise_data{1} == 2)
    img = create_noise_basic('pepper',noise_data{4},noise_data{5},noise_data{6});
  end
  if (noise_data{1} == 3)
    img = create_noise_basic('color',noise_data{4},noise_data{5},noise_data{6});
  end
  if (noise_data{1} == 4)
    img = double(create_noise_dead_leaves(noise_data{7},'disk'))*255;
  end
  if (noise_data{1} == 5)
    img = double(create_noise_dead_leaves(noise_data{7},'square'))*255;
  end
  
  noise_texture = Screen('MakeTexture',stimulus_window,img);
  Screen('DrawTexture',stimulus_window,noise_texture,[],noise_coord(1,:),[],[],1.0); 
  tex = Screen('MakeTexture',stimulus_window,stimulus); 
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(1,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(2,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(3,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(4,:) ,[],[],1.0);
  Screen('DrawText', stimulus_window, 'Position 1', stimulus_loc(1,1), stimulus_loc(1,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 2', stimulus_loc(2,1), stimulus_loc(2,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 3', stimulus_loc(3,1), stimulus_loc(3,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 4', stimulus_loc(4,1), stimulus_loc(4,2), [255, 0, 0, 255]);
  
  VBLTimestamp = Screen('Flip', stimulus_window, refresh_rate);
  pause(5)
  
  
  
  #######################################################################################################################
  
  % Set the variable values
  x1 = stimuli_parameters(2); % location x1
  x2 = stimuli_parameters(3); % location x2
  y1 = stimuli_parameters(4); % location y1
  y2 = stimuli_parameters(5); % location y2
  window_size = [x1 y1 x2 y2];
  bgcolor = stimuli_parameters(6); % intensity of gray background
  fixation_cross_color = [stimuli_parameters(7) stimuli_parameters(8) stimuli_parameters(9)]; % fixation cross color
  disparity = stimuli_parameters(10); % fixation cross distance
  refresh_rate = stimuli_parameters(27); % waiting time for Screen('Flip') in seconds

  brd_coord(1,:) = [stimuli_parameters(19) stimuli_parameters(20) stimuli_parameters(21) stimuli_parameters(22)]; % left stimulus image border coordinates
  brd_coord(2,:) = [stimuli_parameters(23) stimuli_parameters(24) stimuli_parameters(25) stimuli_parameters(26)]; % right stimulus image border coordinates

      
  % initialize the fullscreen window
  stimulus_window = Screen('OpenWindow', 0, bgcolor, window_size);
  Screen('BlendFunction',stimulus_window,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');

  

  % DRAW BORDERS
  %[pixels map alpha] = imread('/home/mikko/grive/CFS/binocular_rivalry_v6/koodi/stimuli/border_test.png'); % OCTAVE
  [pixels map alpha] = imread(strcat(current_director,'/Borders_and_info/border.png')); % OCTAVE
  border = uint8(pixels);
  border(:,:,4) = uint8(alpha);
  brd = Screen('MakeTexture',stimulus_window,border*255); % make the texture
  Screen('DrawTexture',stimulus_window,brd,[],brd_coord(1,:),[],[],1.0);
  Screen('DrawTexture',stimulus_window,brd,[],brd_coord(2,:),[],[],1.0);
  
  % Lets draw noise examples for visual target options 1,2,3 and 4 OR 5,6,7 and 8
  noise_coord(1,:) = [stimuli_parameters(11) stimuli_parameters(12) stimuli_parameters(13) stimuli_parameters(14)]; % left stimulus image border coordinates
  noise_coord(2,:) = [stimuli_parameters(15) stimuli_parameters(16) stimuli_parameters(17) stimuli_parameters(18)];
  noise_type = stimuli_parameters(61);
  sigma = stimuli_parameters(62); % sigma value for dead leaves noise
  noise_frequency = stimuli_parameters(63); % frequency of noise (in Hz)
  noise_variations = stimuli_parameters(64); % number of how many different images of noise to show
  range = stimuli_parameters(65); % upper limit for tonal range of 0 to 255 values 
  block_size = stimuli_parameters(66); % pixel size m x m
  filter = [1 1];
  noise_data = {noise_type, noise_frequency, noise_variations, block_size, range, filter, sigma};
  
  
  if (noise_data{1} == 1)
    img = create_noise_basic('grayscale',noise_data{4},noise_data{5},noise_data{6});
  end
  if (noise_data{1} == 2)
    img = create_noise_basic('pepper',noise_data{4},noise_data{5},noise_data{6});
  end
  if (noise_data{1} == 3)
    img = create_noise_basic('color',noise_data{4},noise_data{5},noise_data{6});
  end
  if (noise_data{1} == 4)
    img = double(create_noise_dead_leaves(noise_data{7},'disk'))*255;
  end
  if (noise_data{1} == 5)
    img = double(create_noise_dead_leaves(noise_data{7},'square'))*255;
  end
  
  noise_texture = Screen('MakeTexture',stimulus_window,img);
  Screen('DrawTexture',stimulus_window,noise_texture,[],noise_coord(2,:),[],[],1.0); 
  tex = Screen('MakeTexture',stimulus_window,stimulus); 
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(5,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(6,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(7,:) ,[],[],1.0);
  Screen('DrawTexture',stimulus_window,tex,[],stimulus_loc(8,:) ,[],[],1.0);
  Screen('DrawText', stimulus_window, 'Position 5', stimulus_loc(5,1), stimulus_loc(5,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 6', stimulus_loc(6,1), stimulus_loc(6,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 7', stimulus_loc(7,1), stimulus_loc(7,2), [255, 0, 0, 255]);
  Screen('DrawText', stimulus_window, 'Position 8', stimulus_loc(8,1), stimulus_loc(8,2), [255, 0, 0, 255]);
  
  VBLTimestamp = Screen('Flip', stimulus_window, refresh_rate);
  pause(5)
  Screen('CloseAll');