%{
  Programmer: Chris Blanks
  Purpose: This script attempts to simulate fixed point binary math.
  
  Notes:
    > 16 bits with 7 bits reserved for the decimal places allows integers 0 to
    511 (-1+2^9) to be represented with a resolution of 1/(2^7)
%}

disp("") %adds an offset to displayed lines
BIT_WIDTH = 16  % 16 bit math
FIXED_POINT_WIDTH = 7  % 7 decimal points

LIMIT = 2**(BIT_WIDTH-FIXED_POINT_WIDTH) %Values cannot exceed the limit value
% range is from 0 to 2^(bit_width - decimal_point_width ) -1

DECIMAL_RESOLUTION = 2**(-1*FIXED_POINT_WIDTH) 
% can have fration multiples of 1/2^(decimal_point_width)


% user picked values for moving average:
N_SAMPLES_SQRT = input("\nEnter your sqrt(sample size) value:\n");
FILTER_SIZE = input("\nEnter your filter size (Note: pick multiples of 2):\n");



%Start of fixed point math :
random_matrix = rand(N_SAMPLES_SQRT); % sqaure matrix of normally distributed random values
SIZE_OF_FILTER = FILTER_SIZE; %will take the average of values (1/SIZE_OF_FILTER)

samples_before_approx = 100* reshape(random_matrix,1,length(random_matrix)**2);
copy = samples_before_approx;
%reshape matrix to a 1D vectorize

% changes randomize values to fit fixed point binary math
samples = implementFixedSizeWidth(samples_before_approx,LIMIT,DECIMAL_RESOLUTION,FIXED_POINT_WIDTH);

subplot(2,1,1)
plot(samples)
title('Original')

%Moving Average Filter Operation
y = zeros(1,length(samples)); %allocate space for output sample values 


for n = 1:length(samples)
  movAvg = 0;
  
  if n >= SIZE_OF_FILTER  %need to wait in order to generate output
    for i = 0:SIZE_OF_FILTER-1 
      movAvg = movAvg + samples(n-i);
    endfor
 
    if movAvg > LIMIT
      movAvg = LIMIT; %sum cannot exceed max representable number
    endif
    
    result = movAvg/SIZE_OF_FILTER; %calculate average value
    
    %find the fixed point size equivalent of result
    integer_value = floor(result);
    decimal = result - integer_value;  %use floor rounding to get decimal part
    
    dec = decimal;
    max_num_of_divisions = 2**(FIXED_POINT_WIDTH);
    for i = 0:max_num_of_divisions
      if dec <= 0
        break %smallest fractional value was found
      endif
      dec = dec - DECIMAL_RESOLUTION;
    endfor
    
    %use the last value of "i" to approximate the decimal value
    decimal = i* DECIMAL_RESOLUTION;
    result = integer_value + decimal ;
    
    y( n - (SIZE_OF_FILTER - 1) ) = result ; %starts at 1st value of output
  endif
  
endfor


subplot(2,1,2)
plot(y)
title('Moving Average Filter Effect')