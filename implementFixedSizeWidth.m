function output = implementFixedSizeWidth(input_samples,threshold,resolution,decimal_width)
  %{
    Implements fixed point binary math
  %}
  
  for el = 1:length(input_samples)
    value = input_samples(el);
    dec = 0; % decimal starts out as 0
    
    % saturation check
    if value >= threshold
      %if true then saturate value
      value = (threshold - 1);   % max integer value
      
      for n = 1:length(decimal_width)
        dec = dec + 2**(-1*n);  %calculates max decimal value
      endfor
      value = value + dec; %largest number possible 
      input_samples(el) = value;  % set new value
      continue   %go to next iteration of loop
    else 
      value = value;   %keep value if below 512 
    endif
    
    integer_value = floor(value);
    decimal = value - integer_value;  %use floor rounding to get decimal part
    
    dec = decimal;
    max_num_of_divisions = 2**(decimal_width);
    for i = 0:max_num_of_divisions
      if dec <= 0
        break %smallest fractional value was found
      endif
      dec = dec - resolution;
    endfor
    
    %use the last value of "i" to approximate the decimal value
    decimal = i* resolution;
    value = integer_value + decimal ;
    
    input_samples(el) = value;  % set new value
  endfor
  
  output = input_samples; %copy to output variable