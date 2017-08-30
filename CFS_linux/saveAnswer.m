function [ answers ] = saveAnswer(answers, answer, ansdur, stimulus_positions, stimulus_showing_order, trial, noise_start, sound_start, sound_type, stimulus_orientation)
    

    % Recording audio start time and audio file
    answers{1}{trial,1} = sound_start;   % Audio start time
    if (sound_type==1)
        answers{2}{trial,1} = 'auditory_stimulus_1';   % Audio file
    else
        answers{2}{trial,1} = 'auditory_stimulus_2';
    end
    answers{3}{trial,1} = stimulus_showing_order(trial);   % Stimulus presenting order (randomization)

    
    answers{4}{trial,1} = upper(answer);                                                % pressed (UP/DOWN)
    
    if(stimulus_positions(stimulus_showing_order(trial)) == 1)                          % stimulus position
        answers{5}{trial,1} = 'OPTION 1';          
    elseif(stimulus_positions(stimulus_showing_order(trial)) == 2)
        answers{5}{trial,1} = 'OPTION 2';    
    elseif(stimulus_positions(stimulus_showing_order(trial)) == 3)
        answers{5}{trial,1} = 'OPTION 3';
    elseif(stimulus_positions(stimulus_showing_order(trial)) == 4)
        answers{5}{trial,1} = 'OPTION 4'; 
    elseif(stimulus_positions(stimulus_showing_order(trial)) == 5)
        answers{5}{trial,1} = 'OPTION 5'; 
    elseif(stimulus_positions(stimulus_showing_order(trial)) == 6)
        answers{5}{trial,1} = 'OPTION 6';     
    elseif(stimulus_positions(stimulus_showing_order(trial)) == 7)
        answers{5}{trial,1} = 'OPTION 7';  
    else
        answers{5}{trial,1} = 'OPTION 8';    
    end

    
    
    if(findstr(upper(answer),answers{5}{trial,1}))                                      % answer (CORRECT/WRONG)
        answers{6}{trial,1} = 'CORRECT'; 
    else
        answers{6}{trial,1} = 'WRONG'; 
    end
    
    answers{7}{trial,1} = ansdur;                                                       % answer duration
    answers{8}{trial,1} = noise_start;                                                  % noise duration before stimulus
    
   
    if(stimulus_orientation(stimulus_showing_order(trial)) == 1)                          % visual stimulus file
        answers{9}{trial,1} = 'visual_stimulus_1';          
    else
        answers{9}{trial,1} = 'visual_stimulus_2';    
    end
    
end

