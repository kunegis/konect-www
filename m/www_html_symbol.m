%
% Create the HTML symbol file for one statistic.
%
% PARAMETERS
%	$statistic
%
% OUTPUT FILES
%	dat-www/html-symbol.$statistic
%

statistic = getenv('statistic');

OUT = fopen(sprintf('dat-www/html-symbol.%s', statistic), 'w');
if OUT < 0,  error('fopen');  end;

symbol = konect_label_statistic(statistic, 'html-short'); 

fprintf(OUT, '%s\n', symbol); 

if fclose(OUT) < 0,  error('fclose');  end;
