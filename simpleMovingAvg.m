function simpleMovingAvg(N_SAMPLES_SQRT,FILTER_SIZE)
  %{
    The first arg will be the square root of the number of samples used.
    The second arg will set how many samples will be averaged together.
    
    Gaussian random values matrix will be generated and will be scaled to be
    within the 0 to 100 range.
    
    The samples will be plotted before and after the moving average filter
    is applied.
  %}
  
  
  random_matrix = rand(N_SAMPLES_SQRT); % sqaure matrix of normally distributed random values
  SIZE_OF_FILTER = FILTER_SIZE; %will take the average of values (1/SIZE_OF_FILTER)
  
  samples = 100* reshape(random_matrix,1,length(random_matrix)**2);
  %reshape matrix to a 1D vectorize

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
      y( n - (SIZE_OF_FILTER - 1) ) = movAvg/SIZE_OF_FILTER; %starts at 1st value of output
    endif
    
  endfor


  subplot(2,1,2)
  plot(y)
  title('Moving Average Filter Effect')