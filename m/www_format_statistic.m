function text = www_format_statistic(statistic, value)

[logarithmic integer percent negative] = konect_data_statistic();

statistic_dataname = regexprep(statistic, '\+', '__'); 

loga = logarithmic.(statistic_dataname);
inte = integer.(statistic_dataname);
perc = percent.(statistic_dataname); 
nega = negative.(statistic_dataname); 

if inte
  if nega
    text = sprintf('%+d', value); 
  else
    text = sprintf('%d', value);
  end
else
  if nega
    text = sprintf('%+#g', value);
  else
    text = sprintf('%#g', value);
  end
end
  
% Remove leading zeroes in the exponent
text = regexprep(text, '(e[+-])0+', '$1'); 

% Insert commas (integral part)
text = regexprep(text, '^([^.]*[0-9])([0-9]{27}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{24}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{21}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{18}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{15}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{12}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{9}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{6}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{3}(\.|$))', '$1,$2'); 

% Insert spaces (fractional part)
text = regexprep(text, '(\.[0-9]{27})([0-9].*)$', '$1 $2'); 
text = regexprep(text, '(\.[0-9]{24})([0-9].*)$', '$1 $2'); 
text = regexprep(text, '(\.[0-9]{21})([0-9].*)$', '$1 $2'); 
text = regexprep(text, '(\.[0-9]{18})([0-9].*)$', '$1 $2'); 
text = regexprep(text, '(\.[0-9]{15})([0-9].*)$', '$1 $2'); 
text = regexprep(text, '(\.[0-9]{12})([0-9].*)$', '$1 $2'); 
text = regexprep(text, '(\.[0-9]{9})([0-9].*)$', '$1 $2'); 
text = regexprep(text, '(\.[0-9]{6})([0-9].*)$', '$1 $2'); 
text = regexprep(text, '(\.[0-9]{3})([0-9].*)$', '$1 $2'); 

% Remove the plus sign in the exponent
text = regexprep(text, 'e\+', 'e');

% Format minus signs
text = regexprep(text, '-', '−');

% Format exponential 
if sum(find(text == 'e'))
  text = regexprep(text, 'e', ' × 10<SUP>');
  text = [text '</SUP>']; 
end

% Remove trailing decimal point (which may be left due to the '#' in the
% '%#g' format
text = regexprep(text, '\.$', '');
