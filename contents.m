% Automated tree structure extraction 
%
%--------------------------------------------------------------------------
% Cihan Bilge Kayasandik last edited: 2016-07-13


% adjestedPos.m 
%   It takes the direction of neurite and segmented image, and 
%   adjusts the direction of neurite by finding the principal component of 
%   neurite at the initial point.  

% connComp.m
%   It takes a binary solid and returns struct containing indices
%   of the components

% createRectangles.m
%   It creates rectangular filters at each integer angle: 360 filters in total.
%   Filters are created with varying lengths to use in different steps of the
%   algorithm.

% densityEstimate.m
%   It collects intensity measurements with subtracting estimated background
%   intensity. This file is used for intensity feature extraction from neruites.

% eliminate_extra_seeding.m
%   It eliminates extra seeds in 8-neighborhood of each seed.

% findClosestPoint.m
%   It finds the point from an array which is closest to a given point.

% findfurthestPoint.m
%   It finds the point from an array which is furthest to a given point.

% findNeuriteComponents.m
%   This code is run as an initialization step, it detects the neurites of 
%   each soma with the direction of nerutes and the starting point of trace. 

% findNeuritePath.m
%   starting from the starting point and the initial direction of neurite, it
%   traces through neurite.

% generateCenterLine.m
%   It generates the centerline tracing for each neurite of each soma. This
%   code sets the parameters and calls traceNeurite.m for each soma.

% genseed.m
%   It takes the binary segmented image and generates seed points.

% getLine.m
%   It creates a line with given thickness, length, direction and starting point.

% getLinearNeighborhood.m
%   It gets the coordinates of points in neighborhood of a point with given radius.

% getLinearNeighborhood_p.m
%   It gets the indices of points in neighborhood of a point with given radius.

% getNextSeed.m
%   It selects the next seed to connect the path during the trace. 

% getPCA.m
%   

% getQuadrant.m
%   It returns the quadrant of point in coordinate system.

% getRectangle_alt.m
%   It creates rectangle with given length,slope,width and location.

% joinSeedToPath.m
%   It connects the selected seed to the generated path.

% long_line.m
%   IT creates a line with desired length in the direction of line 
%   connecting two given points. 

% princomp.m


% rotateAroundPoint.m
%   It rotates the given image around given point with given angle. 

% runCenterLineParallel.m 
%   It is main function for tree structure extraction. It calls all
%   necessary functions and set the parameters. 

% Script.m
%   It loads the test data and calls runCenterLineParallel.m to extract
%   tree structure of test data. 

% secondRoundSeeding.m
%   It is run after the seed generation. It detects large areas 
%   where no seed is generated for. And generate seeds for those areas.

% secondRoundTraceNeurites.m
%   This function is called only if manual intervention is included in
%   options (for that set option.manual=1). If the trace is not correct, 
%   this function runs the whole tracing process through involving the selected 
%   point in trace. It calls secondRoundtracing.m.

% secondRoundtracing.m
%   This function is called only if manual intervention is included in
%   options (for that set option.manual=1). If the trace is not correct, 
%   this function runs the whole tracing process through involving the selected 
%   point in trace.

% traceNeurites.m
%   This is one of the main functions. It is run for each soma and calls
%   the necessary functions to generate trace for each of the neruites
%   connected to the soma.












