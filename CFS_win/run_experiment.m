function run_experiment

    try

        % Make sure we have OpenGL support
        AssertOpenGL;
        
        InitializePsychSound(0)
        
        close all
        clear all
        clc
        
        
        % Read parameter file
        stimuli_parameters = dlmread('stimulus_parameters.csv',';',1,2);
        
        
        % Number of warmup rounds
        NoWarmups = stimuli_parameters(1);
        
        % Warmup (Yes/No)
        if (NoWarmups == 0)
          warmup = 0;
        else
          warmup = 1;
        end
        
        
        % Experiment window parameters 
        w_x1 = stimuli_parameters(2); % location x1
        w_x2 = stimuli_parameters(3); % location x2
        w_y1 = stimuli_parameters(4); % location y1
        w_y2 = stimuli_parameters(5); % location y2
        bgcolor = stimuli_parameters(6); % intensity of gray background
        fixation_cross_color = [stimuli_parameters(7) stimuli_parameters(8) stimuli_parameters(9)]; % fixation cross color
        disparity = stimuli_parameters(10); % fixation cross distance
        
        info_coord(1,:) = [stimuli_parameters(11) stimuli_parameters(12) stimuli_parameters(13) stimuli_parameters(14)]; % left info image coordinates
        info_coord(2,:) = [stimuli_parameters(15) stimuli_parameters(16) stimuli_parameters(17) stimuli_parameters(18)]; % right info image coordinates
        info_brd_coord(1,:) = [stimuli_parameters(19) stimuli_parameters(20) stimuli_parameters(21) stimuli_parameters(22)]; % left info image border coordinates
        info_brd_coord(2,:) = [stimuli_parameters(23) stimuli_parameters(24) stimuli_parameters(25) stimuli_parameters(26)]; % right info image border coordinates
        
        brd_coord(1,:) = [stimuli_parameters(19) stimuli_parameters(20) stimuli_parameters(21) stimuli_parameters(22)]; % left stimulus image border coordinates
        brd_coord(2,:) = [stimuli_parameters(23) stimuli_parameters(24) stimuli_parameters(25) stimuli_parameters(26)]; % right stimulus image border coordinates
        
        % Stimulus parameters
        refresh_rate = stimuli_parameters(27); % waiting time for Screen('Flip') in seconds
        fade_rate = stimuli_parameters(28); % the amount to fade (on every refresh)
        stimulus_loc(1,:) = [stimuli_parameters(29) stimuli_parameters(30) stimuli_parameters(31) stimuli_parameters(32)]; % Stimulus 1 (right_down_right)
        stimulus_loc(2,:) = [stimuli_parameters(33) stimuli_parameters(34) stimuli_parameters(35) stimuli_parameters(36)]; % Stimulus 2 (right_down_left)                
        stimulus_loc(3,:) = [stimuli_parameters(37) stimuli_parameters(38) stimuli_parameters(39) stimuli_parameters(40)]; % Stimulus 3 (right_up_right)
        stimulus_loc(4,:) = [stimuli_parameters(41) stimuli_parameters(42) stimuli_parameters(43) stimuli_parameters(44)]; % Stimulus 4 (right_up_left)
        stimulus_loc(5,:) = [stimuli_parameters(45) stimuli_parameters(46) stimuli_parameters(47) stimuli_parameters(48)]; % Stimulus 5 (left_down_right)
        stimulus_loc(6,:) = [stimuli_parameters(49) stimuli_parameters(50) stimuli_parameters(51) stimuli_parameters(52)]; % Stimulus 6 (left_down_left)
        stimulus_loc(7,:) = [stimuli_parameters(53) stimuli_parameters(54) stimuli_parameters(55) stimuli_parameters(56)]; % Stimulus 7 (left_up_right)
        stimulus_loc(8,:) = [stimuli_parameters(57) stimuli_parameters(58) stimuli_parameters(59) stimuli_parameters(60)]; % Stimulus 8 (left_up_left)
        
        
        % Noise parameters
        noise_type = stimuli_parameters(61); % 1=grayscale, 2=pepper, 3=color, 4=disk (Dead leaves), 5=square (Dead leaves)
        sigma = stimuli_parameters(62); % sigma value for dead leaves noise
        noise_frequency = stimuli_parameters(63); % frequency of noise (in Hz)
        noise_variations = stimuli_parameters(64); % number of how many different images of noise to show
        range = stimuli_parameters(65); % upper limit for tonal range of 0 to 255 values 
        block_size = stimuli_parameters(66); % pixel size m x m
        noise_start_interval = stimuli_parameters(67); 
        noise_random_interval = stimuli_parameters(68); 
        noise_coord(1,:) = [stimuli_parameters(11) stimuli_parameters(12) stimuli_parameters(13) stimuli_parameters(14)]; % left stimulus image border coordinates
        noise_coord(2,:) = [stimuli_parameters(15) stimuli_parameters(16) stimuli_parameters(17) stimuli_parameters(18)];
        
        % Random trial order
        randTrial = stimuli_parameters(69);
        
        % Audio stimuli timing
        audioTiming(1) = stimuli_parameters(70);
        audioTiming(2) = stimuli_parameters(71);
        audioTiming(3) = stimuli_parameters(72);
        audioTiming(4) = stimuli_parameters(73);
        audioTiming(5) = stimuli_parameters(74);
        audioTiming(6) = stimuli_parameters(75);
        
        filter = [1 1];
        
        noise_data = {noise_type, noise_frequency, noise_variations, block_size, range, filter, sigma}; % gathering all the noise relevant data into one variable
        
        % Timeout of trial
        TimeOut=stimuli_parameters(76);
        
        % Disable audiodevinfo
        audioOff=stimuli_parameters(77);
        
        % Answer keys
        if (stimuli_parameters(78) == 1)
          answerKeys{1} = 'down';
        end
        if (stimuli_parameters(78) == 2)
          answerKeys{1} = 'up';
        end
        if (stimuli_parameters(78) == 3)
          answerKeys{1} = 'left';
        end
        if (stimuli_parameters(78) == 4)
          answerKeys{1} = 'right';
        end

        if (stimuli_parameters(79) == 1)
          answerKeys{2} = 'down';
        end
        if (stimuli_parameters(79) == 2)
          answerKeys{2} = 'up';
        end
        if (stimuli_parameters(79) == 3)
          answerKeys{2} = 'left';
        end
        if (stimuli_parameters(79) == 4)
          answerKeys{2} = 'right';
        end
        
        
        

        HideCursor();
        
        % running the actual test with given experiment parameters
        cfs_runner(w_x1, w_x2, w_y1, w_y2, warmup, NoWarmups, noise_start_interval, noise_random_interval, fade_rate, refresh_rate, bgcolor, noise_data, fixation_cross_color, noise_coord, info_coord, info_brd_coord, brd_coord, disparity, TimeOut, stimulus_loc, randTrial, audioTiming, audioOff, answerKeys);

        % Set priority back to 0
        Priority(0);

        % Close the textures (this will close all offscreen windows and
        % textures). Redundant with 'CloseAll', but we will do it just to 
        % avoid PTB errors about open textures.
        Screen('Close');

        % Close the window (this will close everything)
        Screen('CloseAll');

        % Show mouse cursor again
        ShowCursor();

    catch

        Screen('CloseAll');
        Priority(0);
        ShowCursor();
        psychrethrow(psychlasterror);

    end
end
