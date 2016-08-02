function gainsInit = gains(CONFIG)
%GAINS generates the initial gains matrices for both the
%      momentum task (primary task in SoT controller) and the postural task. 
%
%     gains = GAINS(config) takes as an input the structure CONFIG, which
%     contains all the utility parameters, and the structure DYNAMICS 
%     which contains the robot dynamics. The output is the structure 
%     GAINSINIT, which contains the initial gains matrices.
%
% Author : Gabriele Nava (gabriele.nava@iit.it)
% Genova, May 2016
%

% ------------Initialization----------------
% Config parameters
ndof                    = CONFIG.ndof;

%% Gains for two feet on the ground
if sum(CONFIG.feet_on_ground) == 2
    
    gainsPCoM           = diag([45 50 40]);
    gainsDCoM           = 2*sqrt(gainsPCoM);
    gainsPAngMom        = diag([5 10 5]);
    gainsDAngMom        = 2*sqrt(gainsPAngMom);

% impedances acting in the null space of the desired contact forces  
    impTorso            = [ 30  30  20]; 
    impArms             = [ 10  10  10   5   5];
    impLeftLeg          = [ 35  40  10  30   5  10]; 
    impRightLeg         = [ 35  40  10  30   5  10];  
end

%% Parameters for one foot on the ground
if  sum(CONFIG.feet_on_ground) == 1
 
     gainsPCoM          = diag([40 45 40]);
     gainsDCoM          = 2*sqrt(gainsPCoM);
     gainsPAngMom       = diag([5 10 5]);
     gainsDAngMom       = 2*sqrt(gainsPAngMom);
   
% impedances acting in the null space of the desired contact forces 
     impTorso           = [ 25   20   25]; 
     impArms            = [ 15   10   15   10   15];

if CONFIG.feet_on_ground(1) == 1
    
     impLeftLeg         = [ 70   70  65  30  10  10];  
     impRightLeg        = [ 20   20  20  10  10  10];   
else
     impLeftLeg         = [ 20   20  20  10  10  10];
     impRightLeg        = [ 30   30  25  30  10  10]; 
end
end

%% Definition of the impedances and dampings vectors 
gainsInit.impedances    = [impTorso,impArms,impArms,impLeftLeg,impRightLeg];
gainsInit.dampings      = 2*sqrt(gainsInit.impedances);

if (size(gainsInit.impedances,2) ~= ndof)
    
  error('Dimension mismatch between ndof and dimension of the variable impedences. Check these variables in the file gains.m');    
end

%% MOMENTUM AND POSTURAL GAINS
gainsInit.impedances         = diag(gainsInit.impedances);
gainsInit.dampings           = diag(gainsInit.dampings); 
gainsInit.MomentumGains      = [gainsDCoM zeros(3); zeros(3) gainsDAngMom];
gainsInit.intMomentumGains   = [gainsPCoM zeros(3); zeros(3) gainsPAngMom];

% Gains for feet correction to avoid numerical errors
gainsInit.CorrPosFeet        = 5;

end
