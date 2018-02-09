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
    availability_text = sprintf('<A href="../../files/download.tsv.%s.tar.bz2"">Dataset is available for download</A>', network); 
  else
    error(); 
  end
