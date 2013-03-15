function [depthMap]=SingleDimensionCaustic(img)
	% Boil the image down to a grayscale, 1xn matrix by choosing the first row.
	% This is solely for the 1D case
    %img = rgb2gray(img(length(img(:,1))/2,:,:));
    % img = img(length(img(:,1))/2,:);

    %% Variables
    % Count the number of light values required by the image.
    % This will describe how many rays need to be considered in the formation of the image.
    bins = sum(img);
    
    % Distance from the caustic where the image will form (AU.1)
    % Width of image at formation point (AU.1)
    % Width of caustic (AU.1)
    imDist = 24;
    imWidth = 6;
    caustWidth = 3;

    % Resolution of depth map (px/bin)
    res = 3;

    %% Create a n_bins-long array to hold angle data.
    angles = zeros(1,bins);
    
    %% Assign each ray location a corresponding bin.
    currentBin = uint64(1);
    for i=1:length(img)
        % Assign the next {pixel bin count} number of bins to the pixel.
        angles(currentBin:currentBin+uint64(img(i)-1)) = i-1;
        currentBin = currentBin+uint64(img(i));
    end
    % You now have a transfer function between input rays and output rays
    
    %% Find angles required to steer rays to corresponding locations.
    for i=1:length(angles)
        % Physical position along caustic, centered in the image
        caustPos = caustWidth/length(angles)*(i-1);
        caustPos = caustPos + imWidth/2-caustWidth/2;

        % Physical position along projected image
        imPos = imWidth/length(img)*(angles(i)-1);

        theta = atan((imPos - caustPos)/imDist);
        % invert a polynomial that fits to the trig function for angle
        angles(i) = 43.44870551035318./(28.19574435974337.*sqrt(7.155e7.*theta.^2 + 4.173281e6)...
         - 238500.*theta).^(1/3) - 0.029131437992753285.*(28.19574435974337.*...
         sqrt(7.155e7.*theta.^2 + 4.173281e6) - 238500.*theta).^(1/3);
    end
    
    figure(3)
    plot(angles)
    
    %% Generate matrix describing depth of cuts [0:1]
    depthMap = [0];
    for i=1:length(angles)
        i/length(angles)
        lens = (1:res)*tan(angles(i))+depthMap(end);
        depthMap = [depthMap lens];
    end

    %% ~Properly transform and scale cut depths to gs value for laser
    % Define transformation on [0:1] data that will output laser-safe values
%     function [depthTransformed] = transformDepth(depthRaw)
%         % For now, simple transformation that just chooses the "linear" range of the laser
%         laserLinearRange = [49,95];
%         depthTransformed = depthRaw-min(depthRaw);
%         depthTransformed = depthTransformed/max(depthTransformed);
%         depthTransformed = depthTransformed.*(laserLinearRange(2)-laserLinearRange(1))+laserLinearRange(1);
%         depthTransformed = uint8(depthTransformed);
%     end

    %depthMap = transformDepth(depthMap);

    %% Form depth map image and save.
    %imshow(imresize(depthMap,[length(depthMap) length(depthMap)])); imsave;

end