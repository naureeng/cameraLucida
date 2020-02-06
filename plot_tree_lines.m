% PLOT_TREE   Plots a tree.
% (trees package)
%
% HP = plot_tree (intree, color, DD, ipart, res, options)
% -------------------------------------------------------
%
% Plots a directed graph contained in intree. Many settings allow to play
% with the output results. Colour handling is different on line plots than
% on patchy '-b' or '-p'. Even if metrics are nonexistent plot_tree will
% plot its best guess for a reasonable tree (see "xdend_tree"). Line plots
% are always slower than any patch display.
%
% Input
% -----
% - intree   ::integer:      index of tree in trees or structured tree
% - color    ::RGB 3-tupel:  RGB values
%     if vector then values are treated in colormap (must contain one value
%     per node then!).
%     if matrix (N x 3) then individual colors are mapped to each
%     element, works only on line-plots
%     {DEFAULT [0 0 0]}
% - DD       :: 1x3 vector:  coordinates offset
%     {DEFAULT no offset [0,0,0]}
% - ipart    ::index:        index to the subpart to be plotted
%     {DEFAULT: all nodes}
% - res      ::integer>1:    resolution for cylinders. Does not affect line
%     and quiver or blatt.
%     {DEFAULT: 8}
% - options  ::string: has to be one of the following:
%     '-b'   : 2D pieces are displayed on a 3D grid (-b stands for -blatt)
%     showing the diameter but not as real cylinders. Output is a
%     series of patches. Fastest representation.
%       '-b1': patches are mapped on x y 
%       '-b2': patches are mapped on x z
%       '-b3': patches are mapped on y z
%     '-p'   : correct cylinder representation but not yet flawless and a
%             bit slower than "blatt" representation.
%     '-2l'  : 2D (using only X and Y). forces line output (2D), no diameter
%             (slower), color is mapped independently of matlab, always
%             min to max.
%     '-3l'  : 3D. forces line output (2D), no diameter (slower, as '-2l')
%     '-2q'  : 2D (using only X and Y). edges are represented as arrows
%             (using quiver) . Color vectors do not work.
%     '-3q'  : 3D. edges are represented as arrows (using quiver, as '-q')
%   additional options:
%     '-thin'  : all diameters   1um, for line and quiver linewidth 0.25
%     '-thick' : all diameters + 3um, for line and quiver linewidth 3
%     {DEFAULT '-p'}
%
% Output
% ------
% - HP       ::handles:      links to the graphical objects.
%
% Example
% -------
% plot_tree    (sample_tree)
%
% See also   vtext_tree xplore_tree
% Uses       cyl_tree ver_tree
%
% directly adapted for TREES toolbox, code for correct cylinders from:
% Friedrich Forstner
%
% the TREES toolbox: edit, generate, visualise and analyse neuronal trees
% Copyright (C) 2009 - 2017  Hermann Cuntz

function HP  = plot_tree (intree, color, DD, ipart, res, options, crange, cmap)

% trees : contains the tree structures in the trees package
global       trees

if (nargin < 1) || isempty (intree)
    % {DEFAULT tree: last tree in trees cell array}
    intree   = length (trees);
end

ver_tree     (intree); % verify that input is a tree structure

% use full tree for this function
if ~isstruct (intree)
    tree     = trees{intree};
else
    tree     = intree;
end

if (~isfield (tree, 'X')) || (~isfield (tree, 'Y'))
    % if metrics are missing replace by equivalent tree:
    [~, tree] = xdend_tree (intree);
end

N            = size (tree.X, 1); % number of nodes in tree

if (nargin < 4) || isempty (ipart)
    % {DEFAULT index: select all nodes/points}
    ipart    = (1 : N)';
end

if (nargin < 2) || isempty (color)
    % {DEFAULT color: black}
    color    = [0 0 0];
end

if (size (color, 1) == N) && (size (ipart, 1) ~= N)
    color    = color  (ipart);
end
color        = double (color);

if (nargin < 3) || isempty (DD)
    % {DEFAULT 3-tupel: no spatial displacement from the root}
    DD       = [0 0 0];
end
if length (DD) < 3
    % append 3-tupel with zeros:
    DD       = [DD (zeros (1, 3 - length (DD)))];
end

if (nargin < 5) || isempty (res)
    % {DEFAULT: 8 points around cylinder}
    res      = 8;
end

if (nargin < 6) || isempty (options)
    % {DEFAULT: full cylinder representation}
    options  = '-p';
end

if (nargin < 8) || isempty (options)
    cmap = 'hsv';
end

if ~isempty      ([ ...
        (strfind (options, '-2')) ...
        (strfind (options, '-3'))])
    % if color values are mapped:
    if size (color, 1) > 1
        if size (color, 2) ~= 3
            if islogical (color)
                color  = double (color);
            end
            if nargin < 7 || isempty(crange)
            crange     = [(min (color)) (max (color))];
            end
            % scaling of the vector
            if diff (crange) == 0
                color  = ones (size (color, 1), 1);
            else
                color  = floor ( ...
                    (color - crange (1)) ./ ...
                    ((crange (2) - crange (1)) ./ 64));
                color (color <  1) =  1;
                color (color > 64) = 64;
            end
            map        = colormap(cmap);
            map = cat(1, map, [0 0 0]);
            blackIdx = isnan(color);
            color(blackIdx)= 65;
            color     = map (color, :);
        end
    end
    if ~isempty  ([ ...
            (strfind (options, '-2l')) ...
            (strfind (options, '-3l'))])
        if   strfind (options, '-2l')
            [X1, X2, Y1, Y2] = cyl_tree (intree, '-2d');
            HP         = line ( ...
                [(X1 (ipart)) (X2 (ipart))]' + DD (1), ...
                [(Y1 (ipart)) (Y2 (ipart))]' + DD (2));
        end
        if   strfind (options, '-3l')
            [X1, X2, Y1, Y2, Z1, Z2] = cyl_tree (intree);
            HP         = line ( ...
                [(X1 (ipart)) (X2 (ipart))]' + DD (1), ...
                [(Y1 (ipart)) (Y2 (ipart))]' + DD (2),...
                [(Z1 (ipart)) (Z2 (ipart))]' + DD (3));
        end
        if size (color, 1) > 1
            for counter   = 1 : length (ipart)
                set    (HP (counter), ...
                    'color',   color (counter, :), 'LineWidth', 3);
            end
        else
            set        (HP, ...
                'color',       color, 'LineWidth', 3);
        end
    end
  
end


if ~(sum (get (gca, 'DataAspectRatio') == [1 1 1]) == 3)
    axis         equal
end



