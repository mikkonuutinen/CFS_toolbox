function waitForSpace(bling,Fs)
    while(1)
        pause();
        [keyIsDown, secs, keyCode] = KbCheck;
        if(keyIsDown)
            if(sum(keyCode)<2)
                if(strcmp(KbName(keyCode),'space') == 1)
                    if(nargin == 2)
                        sound(bling,Fs);
                    end
                    break
                end
            end
        end
    end

end

