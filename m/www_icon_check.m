%
% The HTML for the "check" icon.
%
% ARGUMENTS
%	network		Internal name of network 
%
% RETURN VALUES
%	check_icon	HTML code of <IMG> element
%	check_text	Explanatory text
%
% INPUT FILES
% 	dat/check.$network
% 	dat/check_error.$network	(Only read if check failed)
%

function [check_icon check_text] = www_icon_check(network)
  
  if exist(sprintf('dat/check.%s', network), 'file') == 2
    check_value = load(sprintf('dat/check.%s', network));
    if check_value
      check_icon = '<IMG class="icon" src="${root}/ic/icon-check-success.png" title="Dataset passed all tests">';
      check_text = 'Dataset passed all tests'; 
    else
      check_icon = '<IMG class="icon" src="${root}/ic/icon-check-failure.png" title="Dataset failed tests">';
      filename = sprintf('dat/check_error.%s', network); 
      ERR = fopen(filename, 'r');
      if ERR < 0,  error(filename);  end
      msg = fgetl(ERR); 
      if fclose(ERR) < 0,  error(filename);  end; 
      check_text = sprintf('Dataset failed tests: %s', msg);
    end
  else
    check_icon = '<IMG class="icon" src="${root}/ic/icon-unknown.png" title="Check was not executed">';
    check_text = 'Check was not executed';
  end
