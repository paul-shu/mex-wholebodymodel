function tform = frame2tform(vqT)
    % get the translation and the orientation of the frame ...
    [p, R] = WBM.utilities.frame2posRotm(vqT);

    % create the homogeneous transformation matrix:
    tform = zeros(4,4);
    tform(1:3,1:3) = R; % rotation
    tform(1:3,4)   = p; % translation
    tform(4,1:3)   = zeros(1,3);
    tform(4,4)     = 1;
end
