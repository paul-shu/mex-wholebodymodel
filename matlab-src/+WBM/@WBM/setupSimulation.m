function setupSimulation(sim_config)
    % check if sim_config is an instance from a derived class of "wbmSimConfig" ...
    if ~isa(sim_config, 'wbmSimConfig')
        error('WBM::setupSimulation: %s', wbmErrorMsg.WRONG_DATA_TYPE);
    end

    figure; clf;

    % init the main figure window for the simulation:
    sim_config.hFigure_main = figure('Name', sim_config.main_title, 'Position', sim_config.main_pos);
    set(sim_config.hFigure_main, 'NumberTitle', 'off', 'MenuBar', 'none', 'BackingStore', 'off');
    % setup the rendering method of the current figure handle:
    d = opengl('data');
    if ~d.Software
        % use the hardware-accelerated OpenGL renderer and not the slow software variant.
        % Note: the axes DrawMode property is ignored in OpenGL.
        set(gcf, 'Renderer', 'opengl');
    else
        % set the renderer property to "painters" to benefit from the DrawMode
        % or the new property SortMethod ...
        set(gcf, 'Renderer', 'painters');
    end

    bSort = true;
    if verLessThan('matlab', '8.4.0') % Matlab version check ...
        bSort = false;
    end
    % split up the main figure into a 2x2 grid, create and setup the axes for each subplot
    % in 3D and draw a solid patch on the bottom of the axes:
    for i = 1:4
        sim_config.hAxes(i)     = subplot('Position', sim_config.axes_pos(i,1:4));
        sim_config.plot_objs{i} = plot3(0, 0, 0, '-');
        %sim_config.plot_objs{i} = plot3(0, 0, 0, '.');

        axis(sim_config.axis_limits);
        hold on;
        patch(sim_config.patch_shape(1,1:4), sim_config.patch_shape(2,1:4), ...
              sim_config.patch_shape(3,1:4), sim_config.patch_color);
        if bSort
            % for Matlab R2014b and later ...
            set(gca, 'SortMethod', 'childorder');
        else
            % for older Matlab versions (<= R2014a) ...
            set(gca, 'DrawMode', 'fast');
        end
        set(gca, 'XDir', 'reverse', ...
                 'Color', sim_config.axes_colors(1,1:3), ...
                 'XColor', sim_config.axes_colors(2,1:3), ...
                 'YColor', sim_config.axes_colors(3,1:3), ...
                 'ZColor', sim_config.axes_colors(4,1:3));

        %params.draw_init = 1;
        rotate3d(gca, 'on');

        figure(sim_config.hFigure_main); % check if it is possible to put it outside of the loop!!
    end
    %axes(sim_config.axes(1)); % try to avoid using axes() - slower ...
    set(sim_config.hFigure_main, 'CurrentAxes', sim_config.hAxes(1)); % much faster ...
end