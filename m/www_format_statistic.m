function text = www_format_statistic(statistic, value)

text = sprintf('%g', value);

% Remove leading zeroes in the exponent
text = regexprep(text, '(e[+-])0+', '$1'); 

% Insert commas
text = regexprep(text, '^([^.]*[0-9])([0-9]{27}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{24}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{21}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{18}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{15}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{12}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{9}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{6}(\.|$))', '$1,$2'); 
text = regexprep(text, '^([^.]*[0-9])([0-9]{3}(\.|$))', '$1,$2'); 

% Remove all plus signs
text = regexprep(text, '\+', '');

% Format minus signs
text = regexprep(text, '-', '−');

% Format exponential 
if sum(find(text == 'e'))
  text = regexprep(text, 'e', ' × 10<SUP>');
  text = [text '</SUP>']; 
end
