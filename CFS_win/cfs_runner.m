function [ ] = cfs_runner(x1, x2, y1, y2, warmup, NoWarmups, noise_start_interval, noise_random_interval, fade_rate, refresh_rate, bgcolor, noise_data, fixation_cross_color, noise_coord, info_coord, info_brd_coord, brd_coord, disparity, TimeOut, stimulus_loc, randTrial, audioTiming, audioOff, answerKeys)
    

    %pkg load image % OCTAVE
   
    % reading trial parameters
    data = dlmread ('trial_parameters.csv', ';', 1, 0); % wWIN
    %data = dlmread ('trial_parameters.csv', ',', 1, 0, 'emptyvalue', 9999); % OCTAVE
    
    setup_matrix(:,2) = data(:,5); % Audio stimulus timing
    setup_matrix(:,3) = data(:,3); % Visual stimulus location
    setup_matrix(:,4) = data(:,4); % Audio stimulus type
    setup_matrix(:,5) = data(:,2); % Visual stimulus type
    window_size = [x1 y1 x2 y2];
    
    seed = input('Give user ID: ');

    
    % Priority(2); %set the priority of this program above normal for smooth and accurate timings
    Screen('Preference', 'SkipSyncTests', 2 );
    Screen('Preference', 'Verbosity', 0);
    Screen('Preference', 'SuppressAllWarnings', 1);
    
    
    
    % initialize the fullscreen window used to draw test on
    stimulus_window = Screen('OpenWindow', 0, bgcolor, window_size);
    % determine how to blend the images (background and stimulus) when fading in the stimulus
    Screen('BlendFunction',stimulus_window,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');

    % "Wait a moment" text for noise target processing
    Screen('TextFont', stimulus_window, 'Courier New');
    Screen('TextSize', stimulus_window, 22); 
    Screen('DrawText', stimulus_window, 'Please wait a moment...', (x2-x1)/3, (y2-y1)/3, [255, 255, 255, 255]);
    VBLTimestamp = Screen('Flip', stimulus_window, refresh_rate);
    
    
    %% creating the noise images
    idx = 1;
    noise_temp = {};
    for frame = 1:noise_data{3}
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
        

        for times = 1:round(75/noise_data{2})
            noise_temp{1,idx}  = img;
            idx = idx + 1;
        end
        
    end
    noise_images = noise_temp;
    %% creating the noise textures (to be ready for Psychtoolbox 'Flip' command)
    noise_textures = {};
    
    for i = 1:length(noise_images)
        noise_textures{i} = Screen('MakeTexture',stimulus_window,noise_images{1,i});
    end
    
    

    %% directory path of the visual stimulus images
    current_director=pwd;
    image_path = strcat(current_director,'\Visual_targets\'); %WIN
    %image_path = strcat(current_director,'/Visual_targets/'); %OCTAVE
    image_dir=dir(image_path);     
    [image1 map alpha] = imread([image_path image_dir(3).name]); % The first image of the folder
    target_image1=image1;
    [image2 map alpha] = imread([image_path image_dir(4).name]); % The second image of the folder
    target_image2=image2;
    


    %% putting ten random visual stimulus images into a warmup variable
    if (NoWarmups == 0)
      images_warmup = []
    else
      for j = 1:NoWarmups
    %for j = 1:10
        [image_warmup map alpha] = imread([image_path image_dir(randi(3:4)).name]); 
        images_warmup{j,1} = image_warmup;
      end
    end
    
    stimulus_targets_warmup = images_warmup; 
    number_of_images=size(setup_matrix,1);
    
    answers = {}; % cell for storing the answers
    
    
    if (randTrial == 1)
      stimulus_showing_orders(1,:) = randperm(number_of_images); % OCTAVE
    else
      stimulus_showing_orders(1,:) = 1:number_of_images; % NO randomization
    end
    

    %% running the actual test (drawStimulus.m)
    stimulus_showing_order = stimulus_showing_orders(1,:); % storing the respective order of stimuli into a variable
    subjectdate = datestr(now, 'dd.mm.yyyy-HH.MM.ss'); %used in filename to differentiate each run
    subjectday = datestr(now, 'dd.mm.yyyy');
    path = ['results/' subjectday '/']; % directory path for the results file
    mkdir(path); % creating that directory
    
    answers{1,1} = drawStimulus(answers, stimulus_window, target_image1,target_image2, stimulus_targets_warmup, stimulus_showing_order, noise_textures, fade_rate, refresh_rate, noise_start_interval, noise_random_interval, fixation_cross_color, warmup, setup_matrix, noise_coord, info_coord, info_brd_coord, brd_coord, disparity, TimeOut, stimulus_loc, audioTiming, audioOff, answerKeys);

      
    %% saving the answers to a text file with headers
    headers = {'trial', 'trial_rand', 'stimulus_file', 'stimulus_position', 'stimulus_start', 'sound_file', 'sound_start', 'answer', 'ansdur'};
    filename = [path 'seed-' int2str(seed) '-date-' subjectdate '.txt'];
    fid = fopen(filename, 'w');

    for i = 1:length(headers)
      fprintf(fid, [headers{i} '\t']);
    end
        
    fprintf(fid,'\r\n');
    for line = 1:length(answers{1,1}{1}(:,1))              
      fprintf(fid, '%d\t%d\t%s\t%s\t%.4f\t%s\t%.4f\t%s\t%.4f\r\n', line, answers{1,1}{3}{line,1}, answers{1,1}{9}{line,1}, answers{1,1}{5}{line,1}, answers{1,1}{8}{line,1}, answers{1,1}{2}{line,1}, answers{1,1}{1}{line,1}, answers{1,1}{4}{line,1}, answers{1,1}{7}{line,1});
    end
    fclose(fid);
    
    
end

