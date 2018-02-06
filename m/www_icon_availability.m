%
% The HTML for the "availability" icon.
%
% ARGUMENTS
%	network		Internal name of network 
%
% RETURN VALUES
%	html		HTML code of <IMG> element
%
% INPUT FILES
%	dat-www/availability.[network]
%

function [availability_icon availability_text] = www_icon_availability(network)

  filename = sprintf('dat-www/availability.%s', network);
  a = load(filename);

  if (a == 0)
    availability_icon = '<IMG class="icon" src="${root}/ic/icon-availability-analysis.png" title="Dataset is not available for download">';
    availability_text = 'Dataset is not available for download'; 
  elseif (a == 1)
    availability_icon = '<IMG class="icon" src="${root}/ic/icon-availability-matrix.png" title="Dataset is available for download">';
    availability_text = 'Dataset is available for download'; 
  else
    error(); 
  end
