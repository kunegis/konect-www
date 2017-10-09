%
% Create the statistics table for one network.
%
% PARAMETERS
%	$network
%
% INPUT FILES 
%	dat/STATISTICS
%	dat/statistics.*.$network
%
% OUTPUT FILES
%	skeleton/networks/$network/statistics.html
%

network = getenv('network') 

filename_out= sprintf('skeleton/networks/%s/statistics.html', network); 
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(filename_out);  end;

filename_statistics = 'dat/STATISTICS'; 
STATISTICS = fopen(filename_statistics, 'r');
if STATISTICS < 0,  error(filename_statistics);  end;

fprintf(OUT, '<TABLE>\n'); 

while ~((statistic = fgetl(STATISTICS)) == -1)
  filename_in = sprintf('dat/statistic.%s.%s', statistic, network)
  ret_exist = exist(filename_in, 'file')
  if 2 ~= ret_exist,  continue;  end;
  values = read_statistic(statistic, network); 
  value = values(1); 
%%  IN = fopen(filename_in, 'r');
%%  if IN < 0,  error(filename_in);  end;
%%  text = fgetl(IN);
%%  if text == -1,  error(filename_in);  end; 
%%  value = str2double(text);
%%  if isnan(value),
%%    fprintf(2, 'Statistic %s for network %s is not a number:  %s\n', statistic, network, text); 
%%    exit(1);
%%  end
  statistic_base = regexprep(statistic, '\+.*$', '');
  text_statistic = konect_label_statistic(statistic, 'html-name');
  text_value = www_format_statistic(statistic, value); 
%%  text_value = sprintf('%g', value);
  fprintf(OUT, '<TR><TD><A HREF="../../statistics/%s/">%s</A>\n<TD>%s\n', ...
	  statistic_base, text_statistic, text_value); 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(STATISTICS) < 0,  error(filename_statistics);  end; 
if fclose(OUT) < 0,  error(filename_out);  end;
