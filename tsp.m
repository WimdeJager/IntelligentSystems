  function anneal = tsp(n,temp,met)
% tsp(n,ms,temp,method) tries to find the shortest path 
% that connects n randomly placed cities
% method=1 (2) corresponds to Metropolis (threshold) algorithm
% ms*100 is the total number of performed steps
% temp is the initial temperature, after each 100 steps it
% is decreased by 1%.

  if (nargin<4)
    met = 1;      % default: Metropolis algorithm
  end
  if (nargin<3) 
    temp = 0.1;   % default: T=0.1
  end
  temps = temp;   % intial temperature 
  
  maxsteps = 100; % set the number of steps to 100

  lt = zeros(1,ceil(maxsteps));   
  tt = 1:ceil(maxsteps);
  
  l_sum    = 0;
  l_sum_sq = 0;

  close all;
% initialize random number generator and draw coordinates 
  rand('state',0); cities = rand(n,2); 
  ord = [1:n];  op = path(ord,cities);

  for jstep=1:ceil(maxsteps);
% lowif (jstep >= (ceil(maxsteps) - 50))
      l_sum    = l_sum + op;
      l_sum_sq = l_sum_sq + op^2;er temperature by 0.1 percent 
    % temp = temp*0.999;
    for ins = 1:100 
      j = ceil(rand*n); len = ceil(rand*(n/2));
      cand = reverse(ord,j,len);
% evaluate change of path length 
      diff = delta(ord,cities,j,j+len);
      np   = op + diff;
% met=1: threshold, met=2: metropolis
      if ( (met==1 && (rand<exp(-diff/temp))||(diff<0)) || ...
           (met==2 && diff<temp))
         ord = cand;
         op = np; 
      end
    end
    
    if (jstep > (ceil(maxsteps) - 50))
      l_sum    = l_sum + op;
      l_sum_sq = l_sum_sq + op^2;
    end
      

% rescale length of path by sqrt(n) for output purposes
    lt(jstep) =  op/sqrt(n);
    curlen = path(ord,cities)/sqrt(n);
% plot map, cities and path 
    figure(1); plotcities(ord,cities);
    title(['n =',num2str(n,'%3.0f'),       ...
           '   t =',num2str(jstep*100,'%8.0f'),  ... 
           '   l =',num2str(curlen,'%4.4f'),  ... 
           '   T =',num2str(temp,'%6.6f')],   ...
           'fontsize',16);
    if (met==1) 
      xlabel(['Metropolis algorithm, annealing'],'fontsize',16);
    else 
      xlabel(['Threshold algorithm', ...
                '    T(0)=',num2str(temps,'%4.4f')], ...
                'fontsize',16);
    end
    pause(0.1);
  end
  
% compute <l> and var(l)
  mean_l = l_sum / 50;
  var_l  = l_sum_sq / 50 - mean_l^2;
  
% plot evolution of length versus iteration step
  figure(2); plot(0,0); hold on; 
  plot(tt,lt,'k.'); 
  title(['n=',num2str(n,'%3.0f'), ...
         ', l=',num2str(curlen,'%4.4f'), ... 
         ', <l>=',num2str(mean_l,'%4.4f'), ...
         ', var(l)=',num2str(var_l,'%4.4f'), ...
         ', T=',num2str(temps,'%4.4f')], ... 
         'fontsize',16);
  if (met==1) 
     xlabel(['Metropolis steps / 100'],'fontsize',16);
  else 
     xlabel(['Threshold steps /100'],'fontsize',16);
  end
  ylabel(['l'],'fontsize',16);

  mean_l_vec = [21.0012 15.3226 10.0266 6.9226 6.2226 6.0793];
  temp_vec = [0.5 0.2 0.1 0.05 0.02 0.01];
  var_vec = [1.8269, 2.8591, 0.3501, 0.1167, 0.0010, 0.0010];
  xy = plot(temp_vec, mean_l_vec, 'ko-');
  errorbar(temp_vec,mean_l_vec,var_vec);
  set(gca, 'XDir', 'reverse');
  title('Mean Path Length vs Temperature');
  xlabel('T');
  ylabel('<l>');
  