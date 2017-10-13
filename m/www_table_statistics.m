%
% Create the table of all statistics.
%
% INPUT FILES
%	dat-www/STATISTICS_MAIN		List of statistics to show; one per line
%
% OUTPUT FILES 
% 	skeleton/statistics/table.html	The HTML for the table, in UTF-8
%

OUT = fopen('skeleton/statistics/table.html', 'w');
if OUT < 0,  error('fopen'); end;
STATISTICS = fopen('dat-www/STATISTICS_MAIN', 'r');
if STATISTICS < 0,  error('fopen');  end;

fprintf(OUT, '<TABLE>\n'); 

while ~((statistic = fgetl(STATISTICS)) == -1)
  text_symbol = konect_label_statistic(statistic, 'html-short'); 
  text_statistic = konect_label_statistic(statistic, 'html-name');
  fprintf(OUT, '<TR><TD align="right">%s =<TD><A HREF="%s/">%s</A>\n', ...
	 text_symbol, statistic, text_statistic);
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(STATISTICS) < 0,  error('fclose');  end;
if fclose(OUT) < 0,  error('fclose');  end;
