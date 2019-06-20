function [ fovx, fovy ] = zoom2fov(zoom, micID, objID)

%   INPUTS: 

%   zoom:  the query zoom 
%   objID:  the objective used, either 'x16' (default) or 'x20'.
%   micID:  the microscope used, either 'bscope' (default) or 'mom' or ' b2'. 

%   zoom2fov(zoom) returns the width in micrometers of the FOV of the 
%   microscope at a query zoom.
%   zoom2foc(zoom, micID) allows you to specify which microscope you used
%   zoom2foc(zoom, micID, objID) allows you to specify which scope and
%   which objective you used for imaging.

%   OUTPUTS: 
%   fovx:  the size of the FOV along scanning lines
%   fovy:  the size of the FOV across scanning lines

%   At present, calibration data from the mom and b2 scope are still missing. 

%   2016-01-24 function and 2p measurements by L. Federico Rossi

%%
if nargin < 2
    micID = 'bscope';
end

if nargin < 3
    objID = 'x16';
end

%% experimental calibration

zoomCal.bscope.x16 = [1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 2, 2.2, 2.3, 2.5, 3, ...
            3.5, 4, 5, 6.1, 7.1, 9.1];
fovxCal.bscope.x16 = [1014, 918.5, 855, 740, 680, 635, 615.5, 524, 491, 460, 431.5, 371, ...
            318, 287, 237.5, 199, 172.5, 140];
fovyCal.bscope.x16 = [913, 828, 790, 715, 664.5, 615, 593, 503.5, 452.5, 430, 401, 337.5, ...
            284.5, 249, 179.5, 161, 141, 111.5];
%add measurements rrom other microscopes here

%% Evaluate FOV width at query zoom usign linear interpolation

if isfield(zoomCal, micID)
    if isfield(zoomCal.(micID), objID)
        fovx = interp1(zoomCal.(micID).(objID), fovxCal.(micID).(objID), zoom,'linear', 'extrap');
        fovy = interp1(zoomCal.(micID).(objID), fovyCal.(micID).(objID), zoom,'linear', 'extrap');
    else
        warning('The calibration acquired with this objective is missing. FOV size estimtion failed \n');
        fovx = NaN;
        fovy = NaN;
    end
else
    warning('The calibration acquired at this microscope is missing. FOV size estimtion failed \n');
    fovx = NaN;
    fovy = NaN;
end
%% Visualize the linear interpolation fit on the data
%
% availableZooms = 1:0.1:10;
% 
% px = interp1(zoomCal.(micID).(objID), fovxCal.(micID).(objID), availableZooms,'linear', 'extrap');
% py = interp1(zoomCal.(micID).(objID), fovyCal.(micID).(objID), availableZooms,'linear', 'extrap');
% 
% figure; plot(zoomCal.(micID).(objID), fovxCal.(micID).(objID), 'or'); hold on
% plot(zoomCal.(micID).(objID), fovyCal.(micID).(objID), 'og');
% plot(availableZooms, px, '-r'); hold on
% plot(availableZooms, py, '-g');

end

