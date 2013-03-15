function [ image ] = raytrace( depth )

    imDist = 24;
    imWidth = 6;
    caustWidth = 3;
    
    n = 1.5;
    
    widthPer = caustWidth/length(depth);

    
    for i = 2:length(depth)
        slope = (depth(i) - depth(i-1));
        angle(i-1) = atan(slope);
    end
    
    figure(1)
    plot(angle)
    
    image = zeros(1,length(angle));
    
     for i = 1:length(angle)
         rayTravel(i) = (n) * sin(angle(i)) * 5; % 5 is a hack
%         rayAngle = 0;
%         rayTravel(i) = rayAngle*imDist + (i/(length(angle))) * caustWidth;
%         %image(uint16(rayTravel)) = image(uint16(rayTravel)) + 1;
     end
%     
    figure(4)
    plot(rayTravel)
    rayTravel = rayTravel + ([1:length(angle)]/length(angle))*caustWidth;

    figure(2)
    plot(rayTravel)

end

