function [noiseIm] = create_noise_basic(type,block_size,range,filter)
    
    %% creating the noise images (pepper, grayscale or color) with the
    % given block size and filtering (filtering not possible for color
    % noise image)
    remm = rem(500,block_size);
    
    I = zeros(500,500);
    
    %% pepper noise image
    if(strcmp(type,'pepper') == 1 && nargin == 4)
        for row = 1:block_size:500-remm
            for col = 1:block_size:500-remm
                colors = [0 255];
                color = colors(randi(2));
                 for width = 1:block_size
                    for height = 1:block_size
                       I(width+(col-1),height+(row-1)) = color;
                    end
                 end
            end
        end
        for row = 500-remm:500
             for col = 1:block_size:500-remm
                 colors = [0 255];
                 color = colors(randi(2));
                 for width = 1:block_size
                    for height = 1:block_size
                       I(width+(col-1),height+row) = color;
                    end
                 end
             end
        end
            
    end
    
    %% grayscale noise image
    if(strcmp(type,'grayscale') == 1 && nargin == 4)
        for row = 1:block_size:500-remm
            for col = 1:block_size:500-remm
                color = randi(range);
                if(row ~= 500-remm)
                     for width = 1:block_size
                        for height = 1:block_size
                           I(width+(col-1),height+(row-1)) = color;
                        end
                     end
                end
            end
        end
        for row = 500-remm:500
             for col = 1:block_size:500-remm
                 color = randi(range);
                 I(col,row) = color;
             end
        end
    end
    
    %% color noise image
    if(strcmp(type,'color') == 1 && nargin == 4)
        for col = 1:block_size:500-remm
            for row = 1:block_size:500-remm
                colors = [randi(range)-1 randi(range)-1 randi(range)-1];
                 for width = 1:block_size
                    for height = 1:block_size
                        for channel = 1:3
                           I(height+(row-1),width+(col-1),channel) = colors(channel);
                        end
                    end
                 end
            end
        end
    end
    
    %% if the image dimension (resolution) is not divisble by the block
    %  size, we have to fiddle aroung with the noise image a bit to fill in
    %  the left over pixels (noiseImageCorrection does not provide a 100%
    %  perfect solution but is still very close to it and hence applicable
    if(remm > 0 || remm > 0)
        %% does its best to fill in the left over (indivisble) pixels 
        channels = 1;

        if(strcmp(type,'color') == 1)
           channels = 3;
        end
    
        for row = 500-remm
             for col = 1:block_size:500-remm
                 if(channels == 3)
                    colors = [randi(256)-1 randi(256)-1 randi(256)-1];
                 elseif(strcmp(type,'grayscale') == 1)
                     colors = randi(256);
                 else
                     black_white = [0 255];
                     colors = black_white(randi(2));
                 end
                 for width = 1:block_size
                    for height = 1:remm
                        for channel = 1:channels
                            I(height+row,width+(col-1),channel) = colors(channel);
                        end
                    end
                 end
             end
        end
        for col = 500-remm
             for row = 1:block_size:500-remm
                 if(channels == 3)
                    colors = [randi(256)-1 randi(256)-1 randi(256)-1];
                 elseif(strcmp(type,'grayscale') == 1)
                     colors = randi(256);
                 else
                     black_white = [0 255];
                     colors = black_white(randi(2));
                 end
                 for width = 1:remm
                    for height = 1:block_size
                        for channel = 1:channels
                            I(height+(row-1),width+(col-1),channel) = colors(channel);
                        end
                    end
                 end
             end
        end

   end


    %% convert the image to uint8 format and add filtering (medfilt2)
    noiseIm = uint8(I);
    dims = size(noiseIm);
    if(length(dims) == 2)
        noiseIm = medfilt2(noiseIm, filter);
    end
    
end

