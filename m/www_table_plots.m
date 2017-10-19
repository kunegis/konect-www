%
% Generate the list of plots. 
%
% OUTPUT FILES
%	skeleton/plots/table.html
%
% INPUT FILES
%	dat/PLOTS
%

[labels_plot] = konect_data_plot(); 

filename_out = 'skeleton/plots/table.html'; 
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(sprintf('fopen(%s)', filename_out));  end;

filename_plots = 'dat/PLOTS';
PLOTS = fopen(filename_plots, 'r');
if PLOTS < 0,  error(sprintf('fopen(%s)', filename_plots));  end;

fprintf(OUT, '<UL>\n');

while ~((plot = fgetl(PLOTS)) == -1)
  plot
  plot_index = plot;
  plot_index = regexprep(plot_index, '-',   '__' );
  plot_index = regexprep(plot_index, '\.',  '___');
  label_plot = labels_plot.(plot_index); 
  label_plot_uc = label_plot;
  assert(length(label_plot_uc) >= 1); 
  if label_plot_uc(1) >= 'a' && label_plot_uc(1) <= 'z'
    label_plot_uc(1) = label_plot_uc(1) + 'A' - 'a'; 
  end
  fprintf(OUT, '<LI><A href="%s/">%s</A>\n', ...
	  plot, label_plot_uc); 
end

fprintf(OUT, '</UL>\n');

if fclose(OUT) < 0,  error(sprintf('fclose(%s)', filename_out));  end;
if fclose(PLOTS) < 0,  error(sprintf('fclose(%s)', filename_plots));  end;
