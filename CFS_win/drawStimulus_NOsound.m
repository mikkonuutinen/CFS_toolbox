 function answers = drawStimulus_NOsound(answers, stimulus_window, stimulus_target1, stimulus_target2, stimulus_targets_warmup, stimulus_showing_order, noise_textures, fade_rate, refresh_rate, noise_start_interval, noise_random_interval, fixation_cross_color, warmup, setup_matrix, noise_coord, info_coord, info_brd_coord, brd_coord, disparity, TimeOut, stimulus_loc, audioTiming, audioOff, answerKeys)
        
    current_director=pwd;
    number_of_trials=size(setup_matrix,1);

    
    % OBS!! there is some problems to read wav files with Octave 4!!
    if (audioOff == 0)
      %  [y_high, freq_high] = wavread('1500Hz_new_amp');
      [y_high, freq_high] = wavread(strcat(current_director,'/Auditory_targets/auditory_stimulus_1.wav'));
      wavedata_high = y_high';
      nrchannels_high = size(wavedata_high,1);
      % [y_low, freq_low] = wavread('250Hz_new_no_amp');
      [y_low, freq_low] = wavread(strcat(current_director,'/Auditory_targets/auditory_stimulus_2.wav'));
      wavedata_low = y_low';
      nrchannels_low = size(wavedata_low,1); 
      
      %% Make sure we have always 2 channels stereo output.
      %% Why? Because some low-end and embedded soundcards
      %% only support 2 channels, not 1 channel.
      if nrchannels_high < 2
        wavedata_high = [wavedata_high ; wavedata_high];
        nrchannels_high = 2;
      end
      if nrchannels_low < 2
        wavedata_low = [wavedata_low ; wavedata_low];
        nrchannels_low = 2;
      end
      
      % Perform basic initialization of the sound driver:
      InitializePsychSound(1); 
    end 
    
      
    % Noise image coordinates
    left = noise_coord(1,:);
    right = noise_coord(2,:);
    % Info image coordinates
    info_left = info_coord(1,:);
    info_right = info_coord(2,:);
    % Info image border coordinates
    info_pos_brd_l=info_brd_coord(1,:);
    info_pos_brd_r=info_brd_coord(2,:);
    % Stimulus image border coordinates
    brd_pos_l=brd_coord(1,:);
    brd_pos_r=brd_coord(2,:);
    
             
    %% setting the noise image coordinates
    up=1;
    down=1;
    positions_noise = {};
    for j = 1:number_of_trials
        if(setup_matrix(stimulus_showing_order(j),3) == 1)
            positions_noise{j} = left;
            sound_types_down(down)=setup_matrix(stimulus_showing_order(j),4);
            down=down+1;
        elseif(setup_matrix(stimulus_showing_order(j),3) == 2)
            positions_noise{j} = left;
            sound_types_down(down)=setup_matrix(stimulus_showing_order(j),4);
            down=down+1;
        elseif(setup_matrix(stimulus_showing_order(j),3) == 3)
            positions_noise{j} = left;
            sound_types_up(up)=setup_matrix(stimulus_showing_order(j),4);
            up=up+1;
        elseif(setup_matrix(stimulus_showing_order(j),3) == 4)
            positions_noise{j} = left;
            sound_types_up(up)=setup_matrix(stimulus_showing_order(j),4);
            up=up+1;
        elseif(setup_matrix(stimulus_showing_order(j),3) == 5)
            positions_noise{j} = right;
            sound_types_down(down)=setup_matrix(stimulus_showing_order(j),4);
            down=down+1;
        elseif(setup_matrix(stimulus_showing_order(j),3) == 6)
            positions_noise{j} = right;
            sound_types_down(down)=setup_matrix(stimulus_showing_order(j),4);
            down=down+1;
        elseif(setup_matrix(stimulus_showing_order(j),3) == 7)
            positions_noise{j} = right;
            sound_types_up(up)=setup_matrix(stimulus_showing_order(j),4);
            up=up+1;    
        else
            positions_noise{j} = right;
            sound_types_up(up)=setup_matrix(stimulus_showing_order(j),4);
            up=up+1;
        end
    end

    sound_types_up_nro=1;
    sound_types_down_nro=1;

    
    %% creating the stimulus textures out of the image files (PNGs)  
    stimulus_tex = {};
    for i = 1:number_of_trials
        if (setup_matrix(stimulus_showing_order(i),5) == 2)
            stimulus=stimulus_target2;
        else
            stimulus=stimulus_target1;
        end
        tex = Screen('MakeTexture',stimulus_window,stimulus);
        stimulus_tex{i} = tex;
    end
    
     
    %% display instructions if we have a warmup to do
    if(warmup)
    
        %% create the textures for the warmup instruction PNGs (these image were created separately using Photoshop)       
        %[pixels map_ alpha] = imread('C:\Science\MATLAB\CFS\binocular_rivalry_v6\koodi\stimuli\border_tut.png'); % WIN
        [pixels map_ alpha] = imread(strcat(current_director,'/Borders_and_info/border.png')); % OCTAVE  
        border = uint8(pixels);
        border(:,:,4) = uint8(alpha);
        info_brd = Screen('MakeTexture',stimulus_window,border*255); % make the texture   

        %info = Screen('MakeTexture',stimulus_window,imread('C:\Science\MATLAB\CFS\binocular_rivalry_v6\koodi\stimuli\intro.png')); % WIN
        info = Screen('MakeTexture',stimulus_window,imread(strcat(current_director,'/Borders_and_info/intro.png'))); % OCTAVE 
        
        %disparity_test_l = Screen('MakeTexture',stimulus_window,imread('C:\Science\MATLAB\CFS\binocular_rivalry_v6\koodi\stimuli\disparity_l.png')); % WIN
        %disparity_test_r = Screen('MakeTexture',stimulus_window,imread('C:\Science\MATLAB\CFS\binocular_rivalry_v6\koodi\stimuli\disparity_r.png')); % WIN  
        disparity_test_l = Screen('MakeTexture',stimulus_window,imread(strcat(current_director,'\Borders_and_info\disparity_l.png'))); % WIN
        disparity_test_r = Screen('MakeTexture',stimulus_window,imread(strcat(current_director,'\Borders_and_info\disparity_r.png'))); % WIN  
        %disparity_test_l = Screen('MakeTexture',stimulus_window,imread(strcat(current_director,'/Borders_and_info/disparity_l.png'))); % OCTAVE 
        %disparity_test_r = Screen('MakeTexture',stimulus_window,imread(strcat(current_director,'/Borders_and_info/disparity_r.png'))); % OCTAVE  
        
        
        % draw the textures into to the window with the given coordinates
        Screen('DrawTexture',stimulus_window,info_brd,[],info_pos_brd_l,[],[],1.0);
        Screen('DrawTexture',stimulus_window,info_brd,[],info_pos_brd_r,[],[],1.0);
        Screen('DrawTexture',stimulus_window,disparity_test_l,[],info_left,[],[],1.0);
        Screen('DrawTexture',stimulus_window,disparity_test_r,[],info_right,[],[],1.0);
        
        % draw the fixation cross, too
        drawFixation(stimulus_window, disparity, fixation_cross_color);
        
        % flip (=display) the image!
        VBLTimestamp = Screen('Flip', stimulus_window, refresh_rate);
        page = 1; % there are 2 pages, we start from page 1 (= disparity test)
        
        %% wait for user input (space key) to change the page
        while(1)
            pause();
            [keyIsDown, secs, keyCode] = KbCheck;
            if(keyIsDown)
              sum(keyCode)
                if(sum(keyCode)<2)
                  KbName(keyCode)
                    if(page ~= 1 && strcmp(KbName(keyCode),'space') == 1)
                        break
                        elseif(strcmp(KbName(keyCode),'escape') == 1) % WIN
                        %elseif(strcmp(KbName(keyCode),'Escape') == 1) % OCTAVE
                            Screen('CloseAll');
                            close all
                            clear all
                            elseif(strcmp(KbName(keyCode),'return') == 1) % WIN
                            %elseif(strcmp(KbName(keyCode),'Return') == 1) % OCTAVE                          
                                if(page == 1) page = 2; else page = 1; end
                                  % always draw the borders
                                  Screen('DrawTexture',stimulus_window,info_brd,[],info_pos_brd_l,[],[],1.0);
                                  Screen('DrawTexture',stimulus_window,info_brd,[],info_pos_brd_r,[],[],1.0);
                                  if(page == 1)
                                      % page 1 = disparity test
                                      Screen('DrawTexture',stimulus_window,disparity_test_l,[],info_left,[],[],1.0);
                                      Screen('DrawTexture',stimulus_window,disparity_test_r,[],info_right,[],[],1.0);
                                      drawFixation(stimulus_window, disparity, fixation_cross_color);
                                  else
                                      % page 2 = test instructions
                                      Screen('DrawTexture',stimulus_window,info,[],info_left,[],[],1.0);
                                      Screen('DrawTexture',stimulus_window,info,[],info_right,[],[],1.0);
                                  end
                                  VBLTimestamp = Screen('Flip', stimulus_window, refresh_rate);
                                end
                            end
                        end
                    end
                end
    
      
              %[pixels map alpha] = imread('C:\Science\MATLAB\CFS\binocular_rivalry_v6\koodi\stimuli\border_test.png'); % WIN
              [pixels map alpha] = imread(strcat(current_director,'\Borders_and_info\border.png')); % WIN
              %[pixels map alpha] = imread(strcat(current_director,'/Borders_and_info/border.png')); % OCTAVE
              
              % create the necessary image matrix (with the 4th channel, that is the alpha channel)
              border = uint8(pixels);
              border(:,:,4) = uint8(alpha);
              brd = Screen('MakeTexture',stimulus_window,border*255); % make the texture
              pause(0.1);
              %% running the test 
              while(1)
                  for trial = 1:number_of_trials
                      if(warmup) % if it is still a warmup, display the respective warmup image
                          tex = Screen('MakeTexture',stimulus_window,stimulus_targets_warmup{trial});
                          % in a random position (1 to 4)
                          i = randi(number_of_trials);
                          pos_noise = positions_noise{i};
                      else % otherwise set the texture and its position to correspond the current trial
                          tex = stimulus_tex{trial};
                          pos_noise = positions_noise{trial};
                      end
                      % draw the borders
                      Screen('DrawTexture',stimulus_window,brd,[],brd_pos_l,[],[],1.0);
                      Screen('DrawTexture',stimulus_window,brd,[],brd_pos_r,[],[],1.0);
                      
                      % draw the fixation cross
                      drawFixation(stimulus_window, disparity, fixation_cross_color);
                      
                      Screen('Flip', stimulus_window);  % display the image in the window
                      waitForSpace % wait for the user to press space
                      
                      guard = 1; % guard for checking if we can start fading in the stimulus image
                      fade = 0.0;
                      
                      % time duration after stimulus is presented after noise
                      noise_intercept=noise_start_interval;
                      rand_time = noise_random_interval;
                      noise_start = noise_intercept+rand_time*rand;
                      
                      % Default latency for audio;          
                      latency=0.02;


                       % sound sample timing 
                       sound_start=audioTiming(1);
                       if (setup_matrix(stimulus_showing_order(trial),2)==2)
                        sound_start=audioTiming(2);
                       end
                       if (setup_matrix(stimulus_showing_order(trial),2)==3)
                        sound_start=audioTiming(3);
                       end
                       if (setup_matrix(stimulus_showing_order(trial),2)==4)
                        sound_start=audioTiming(4);
                       end
                       if (setup_matrix(stimulus_showing_order(trial),2)==5)
                        sound_start=audioTiming(5);
                       end
                       if (setup_matrix(stimulus_showing_order(trial),2)==6)
                        sound_start=audioTiming(6);
                       end             
                       sound_ok=0; 
                      
                           

                      %% Stimulus positions for trial
                      if (warmup==0)
                           if (setup_matrix(stimulus_showing_order(trial),3) == 1) % Option 1
                              pos_stimu = stimulus_loc(1,:);
                              sound_type=sound_types_down(sound_types_down_nro);
                              sound_types_down_nro=sound_types_down_nro+1;
                           end
                           if (setup_matrix(stimulus_showing_order(trial),3) == 2) % Option 2
                              pos_stimu = stimulus_loc(2,:);
                              sound_type=sound_types_down(sound_types_down_nro);
                              sound_types_down_nro=sound_types_down_nro+1;
                           end   
                           if (setup_matrix(stimulus_showing_order(trial),3) == 3) % Option 3
                              pos_stimu = stimulus_loc(3,:);
                              sound_type=sound_types_up(sound_types_up_nro);
                              sound_types_up_nro=sound_types_up_nro+1;
                           end 
                           if (setup_matrix(stimulus_showing_order(trial),3) == 4) % Option 4
                              pos_stimu = stimulus_loc(4,:);
                              sound_type=sound_types_up(sound_types_up_nro);
                              sound_types_up_nro=sound_types_up_nro+1;
                           end
                           if (setup_matrix(stimulus_showing_order(trial),3) == 5) % Option 5
                              pos_stimu = stimulus_loc(5,:);
                              sound_type=sound_types_down(sound_types_down_nro);
                              sound_types_down_nro=sound_types_down_nro+1;
                           end   
                           if (setup_matrix(stimulus_showing_order(trial),3) == 6) % Option 6
                              pos_stimu = stimulus_loc(6,:);
                              sound_type=sound_types_down(sound_types_down_nro);
                              sound_types_down_nro=sound_types_down_nro+1;
                           end 
                           if (setup_matrix(stimulus_showing_order(trial),3) == 7) % Option 7
                              pos_stimu = stimulus_loc(7,:);
                              sound_type=sound_types_up(sound_types_up_nro);
                              sound_types_up_nro=sound_types_up_nro+1;
                           end
                           if (setup_matrix(stimulus_showing_order(trial),3) == 8) % Option 8
                              pos_stimu = stimulus_loc(8,:);
                              sound_type=sound_types_up(sound_types_up_nro);
                              sound_types_up_nro=sound_types_up_nro+1;
                           end 
                      end
                     

                      %% Stimulus positions for warmup trial
                      if (warmup)
                          ran_num=randperm(size(setup_matrix,1),1);
                          ran_pos=setup_matrix(ran_num,3);
                          if (ran_pos==1)
                              pos_stimu = stimulus_loc(1,:);
                          end
                          if (ran_pos==2)
                              pos_stimu = stimulus_loc(2,:);
                          end
                          if (ran_pos==3)
                              pos_stimu = stimulus_loc(3,:);
                          end
                          if (ran_pos==4)
                              pos_stimu = stimulus_loc(4,:);
                          end
                          if (ran_pos==5)
                              pos_stimu = stimulus_loc(5,:);
                          end
                          if (ran_pos==6)
                              pos_stimu = stimulus_loc(6,:);
                          end
                          if (ran_pos==7)
                              pos_stimu = stimulus_loc(7,:);
                          end
                          if (ran_pos==8)
                              pos_stimu = stimulus_loc(8,:);
                          end
                         
                          % noise position for trial
                          if (ran_pos<5)
                              pos_noise = left;
                          else
                              pos_noise = right;
                          end
                          
                         % RN=floor(ran_num/2);
                         % if (RN==0)
                         %     RN=1;
                         % end
                         % sound_type=sound_types_up(RN);
                          sound_type=randperm(2,1);
                         
                      end  
                        
                % OCTAVE 4 sisältää ongelman lukea äänitiedostoja!!
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                      if (sound_type==1)
                        sound_type=1;
                        if (audioOff == 0)
                            PsychPortAudio('Close');
                        
                            try
                              % Try with the frequency we wanted:
                              pahandle_high = PsychPortAudio('Open', [], 1, [], freq_high, nrchannels_high, [], 0.015);
                            catch
                              % Failed. Retry with default frequency as suggested by device:
                              fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', freq);
                              fprintf('Sound may sound a bit out of tune, ...\n\n');
                              psychlasterror('reset');
                              pahandle_high = PsychPortAudio('Open', [], 1, [], [], nrchannels_high, [], 0.015);
                            end
                            
                            PsychPortAudio('FillBuffer', pahandle_high, wavedata_high);
                            PsychPortAudio('Volume', pahandle_high,0);
                            t1=PsychPortAudio('Start', pahandle_high, 1, 0, 1);
                        end
                      end

                      if (sound_type==2)
                        sound_type=2;
                        if (audioOff == 0)
                            PsychPortAudio('Close'); % suljetaan varmuuden vuoksi aiempi audioportti
                              
                            try
                              % Try with the frequency we wanted:
                              pahandle_low = PsychPortAudio('Open', [], 1, [], freq_low, nrchannels_low, [], 0.015);
                            catch
                              % Failed. Retry with default frequency as suggested by device:
                              fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', freq);
                              fprintf('Sound may sound a bit out of tune, ...\n\n');
                              psychlasterror('reset');
                              pahandle_low = PsychPortAudio('Open', [], 1, [], [], nrchannels_low, [], 0.015);
                            end
                            
                            PsychPortAudio('FillBuffer', pahandle_low, wavedata_low);
                            PsychPortAudio('Volume', pahandle_low,0);
                            t1=PsychPortAudio('Start', pahandle_low, 1, 0, 1);
                        end
                      end
                      
                      
        
                      len = length(noise_textures);
                      tic
                      while(1)
                          noise = noise_textures{randi(len-1)}; % start at a random noise image
                          % draw the noise image and the borders
                          Screen('DrawTexture',stimulus_window,noise,[],pos_noise,[],[],1.0);
                          Screen('DrawTexture',stimulus_window,brd,[],brd_pos_l,[],[],1.0);
                          Screen('DrawTexture',stimulus_window,brd,[],brd_pos_r,[],[],1.0);
                          
                         
                          if(toc > noise_start+sound_start-latency && sound_ok==0)
                            
                            if (sound_type==1) % sound type 1 for trial 
                              if (audioOff == 0)
                                PsychPortAudio('FillBuffer', pahandle_high, wavedata_high);
                                % Start audio playback for 'repetitions' repetitions of the sound data,
                                % start it immediately (0) and wait for the playback to start, return onset
                                % timestamp.       
                                PsychPortAudio('Volume', pahandle_high,1);
                                t1 = PsychPortAudio('Start', pahandle_high, 1, 0, 0);
                              end
                            end
                              
                            if (sound_type==2) % sound type 2 for trial
                              if (audioOff == 0)     
                                PsychPortAudio('FillBuffer', pahandle_low, wavedata_low);
                                % Start audio playback for 'repetitions' repetitions of the sound data,
                                % start it immediately (0) and wait for the playback to start, return onset
                                % timestamp.
                                PsychPortAudio('Volume', pahandle_low,1);
                                t1 = PsychPortAudio('Start', pahandle_low, 1, 0, 0);
                              end     
                            end 
                              sound_ok=1;
                          end
                          

                          % draw the stimulus image (and the borders on top of it) if
                          % it's the time to start fading in it in
                          if(guard == 0 || toc > noise_start)
                              Screen('DrawTexture',stimulus_window,tex,[],pos_stimu,[],[],fade);
                              Screen('DrawTexture',stimulus_window,brd,[],brd_pos_l,[],[],1.0);
                              Screen('DrawTexture',stimulus_window,brd,[],brd_pos_r,[],[],1.0);

                              fade = fade + fade_rate; % the rate at which to fade in the image
                              guard = 0; % set the guard to 0 if we can start fading in the image
                          end

                          
                          % draw the fixation cross
                          drawFixation(stimulus_window, disparity, fixation_cross_color);
                          % display the images in the window
                          Screen('Flip', stimulus_window, refresh_rate); 
                          %% wait for an answer (up or down key)
                          [keyIsDown, secs, keyCode] = KbCheck;
                          %keyIsDown = 1;
                          if((guard == 0 && keyIsDown) || (guard == 0 && toc-noise_start > TimeOut))
                              %pause(0.1);
                              %if(1)
                              if(sum(keyCode) < 2)
                                  if (toc-noise_start < TimeOut) 
                                      answer = KbName(keyCode); % save the answer (up or down key pressed)
                                  else
                                      answer = 'TimeOut';
                                  end 
                                  %if(strcmp(answer,'up') == 1 || strcmp(answer,'down') == 1 || toc-noise_start > TimeOut) % WIN
                                  %if(strcmp(answer,'Up') == 1 || strcmp(answer,'Down') == 1 || toc-noise_start > TimeOut) % OCTAVE
                                  if(strcmp(answer,answerKeys{1}) == 1 || strcmp(answer,answerKeys{2}) == 1 || toc-noise_start > TimeOut) % OCTAVE                                   
                                      disp('----');
                                      ansdur = toc-noise_start; % record the answer time
                                      if(warmup)
                                          disp(['WARM UP: ' num2str(trial)]);
                                      else
                                          % save the answers with given parameters
                                          answers = saveAnswer(answers, answer, ansdur, setup_matrix(:,3), stimulus_showing_order, trial, noise_start, sound_start, sound_type, setup_matrix(:,5));
                                          disp(['TRIAL: ' num2str(trial)]);
                                      end
                                      %disp(['Answer duration: ' num2str(ansdur)]);
                                      %disp(['Location: ' num2str(stimulus_positions(stimulus_showing_order(trial)))]);
                                      %sprintf('\r\n');
                                      break
                                  elseif(strcmp(KbName(keyCode),'Escape') == 1) % WIN    
                                  %elseif(strcmp(KbName(keyCode),'Escape') == 1) % OCTAVE
                                      guard = 2;
                                      break
                                  end
                              end
                          end
                      end
                      % skip the warm up by pressing 'esc'
                      if (guard == 2 && warmup) || (trial == length(stimulus_targets_warmup) && warmup) 
                          info_2 = Screen('MakeTexture',stimulus_window,imread(strcat(current_director,'/Borders_and_info/intro_2.png')));
                          Screen('DrawTexture',stimulus_window,info_brd,[],info_pos_brd_l,[],[],1.0);
                          Screen('DrawTexture',stimulus_window,info_brd,[],info_pos_brd_r,[],[],1.0);
                          Screen('DrawTexture',stimulus_window,info_2,[],info_left,[],[],1.0);
                          Screen('DrawTexture',stimulus_window,info_2,[],info_right,[],[],1.0);
                          Screen('Flip', stimulus_window, refresh_rate);
                          waitForSpace();
                          break;
                      % otherwise jump into the next set (or if this was the last set
                      % then quit the program)
                      elseif guard == 2
                          break;
                      end
                  end
                  % if we had a warmup, set warmup to 0
                  if(warmup)
                      warmup = 0;
                  else
                      break;
                  end
              end
    
  if (audioOff == 0)
    % closing audioport
    PsychPortAudio('Close');
  end
  
end

