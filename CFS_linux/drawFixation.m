function drawFixation(stimulus_window, disparity, fixation_cross_color)
    [w_w, w_h] = WindowSize(stimulus_window);
    margin = w_w/2-disparity;
    fc_w = 8;   % fixation cross stroke width
    fc_l = 30;  % fixation cross length
    fixationcross = zeros(4, 4);
    fixationcross(:,1) = [margin-fc_w/2 w_h/2-fc_l/2 margin+fc_w/2 w_h/2+fc_l/2];
    fixationcross(:,2) = [margin-fc_l/2 w_h/2-fc_w/2 margin+fc_l/2 w_h/2+fc_w/2];
    fixationcross(:,3) = [w_w-margin-fc_w/2 w_h/2-fc_l/2 w_w-margin+fc_w/2 w_h/2+fc_l/2];
    fixationcross(:,4) = [w_w-margin-fc_l/2 w_h/2-fc_w/2 w_w-margin+fc_l/2 w_h/2+fc_w/2];
    Screen('Preference', 'TextAntiAliasing',1); % 0=disable, 1=force AA, 2= hiquality, commented out = system default
    Screen('FillRect', stimulus_window, fixation_cross_color, fixationcross);
    
end

