function [f_c, tau_gen] = contactForcesEF(obj, tau, fe_c, ac, Jc, djcdq, M, c_qv, dq_j)
    switch nargin
        % fe_c ... external forces affecting on the contact links (in contact space)
        % ac   ... mixed generalized contact accelerations
        case 9
            % generalized forces with friction:
            tau_fr  = frictionForces(obj, dq_j); % friction torques (negated torque values)
            tau_gen = tau + tau_fr;              % generalized forces tau_gen = S_j*(tau + (-tau_fr)),
                                                 % S_j = [0_(6xn); I_(nxn)] ... joint selection matrix.
        case 8
            % general case:
            tau_gen = tau;
        otherwise
            error('WBM::contactForcesEF: %s', WBM.wbmErrorMsg.WRONG_NARGIN);
    end
    if (size(tau,1) < size(c_qv,1))
        tau_gen = vertcat(zeros(6,1), tau_gen);
    end
    % Calculation of the contact (constraint) force vector:
    % For further details about the formula see,
    %   [1] Control Strategies for Robots in Contact, J. Park, PhD-Thesis, Artificial Intelligence Laboratory, Stanford University, 2006,
    %       <http://cs.stanford.edu/group/manips/publications/pdfs/Park_2006_thesis.pdf>, Chapter 5, pp. 106-110, eq. (5.5)-(5.14).
    %   [2] A Mathematical Introduction to Robotic Manipulation, Murray & Li & Sastry, CRC Press, 1994, pp. 269-270, eq. (6.5) & (6.6).
    Jc_t      = Jc.';
    JcMinv    = Jc / M; % = Jc * M^(-1)
    Upsilon_c = JcMinv * Jc_t; % inverse mass matrix Upsilon_c = Lambda^(-1) = Jc * M^(-1) * Jc^T in contact space {c},
                               % Lambda^(-1) ... inverse pseudo-kinetic energy matrix.
    % contact constraint forces f_c (generated by the environment):
    f_c = (Upsilon_c \ (ac + JcMinv*(c_qv - tau_gen) - djcdq)) - fe_c;
end