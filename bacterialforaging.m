%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   E. coli Bacterial Swarm Foraging for Optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Krishna Kumar yadav Nukala
%   M.E in E&C
%   delhi Engineering College
% This program simulates the minimization of a simple function with
% chemotaxis, swarming, reproduction, and elimination/dispersal of a 
% E. coli bacterial population.
%
% To change the nutrientsfunc search on it.  For
% example, change it to nutrientsfunc1 to study another type of swarm behavior.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all            % Initialize memory
clc
close all
delete test.mat;
t=clock;

p=4;                 % Dimension of the search space

S=12;	% The number of bacteria in the population (for convenience, require this to be an
        % an even number)

Nc=10; % Number of chemotactic steps per bacteria lifetime (between reproduction steps), assumed
        % for convenience to be the same for every bacteria in the population
Ns=10;   % Limits the length of a swim when it is on a gradient


Nre=1;	 % The number of reproduction steps (right now the plotting is designed for Nre=4)
Sr=S/2;	 % The number of bacteria reproductions (splits) per generation (this
		 % choice keeps the number of bacteria constant)
		 

Ned=6; % The number of elimination-dispersal events (Nre reproduction steps in between each event)

ped=0.25; % The probabilty that each bacteria will be eliminated/dispersed (assume that 
          % elimination/dipersal events occur at a frequency such that there can be 
		  % several generations of bacteria before an elimination/dispersal event but
		  % for convenience make the elimination/dispersal events occur immediately after
		  % reproduction)

flag=2; % If flag=0 indicates that will have nutrients and cell-cell attraction
        % If flag=1 indicates that will have no (zero) nutrients and only cell-cell attraction
		% If flag=2 indicates that will have nutrients and no cell-cell attraction
		
% Initial population
Jfinal=1000;

P(:,:,:,:,:)=0*ones(p,S,Nc,Nre,Ned);  % First, allocate needed memory

% Initialize locations of bacteria all at the center (for studying one swarming case - when nutrientsfunc1 is used)
%for m=1:S
%	P(:,m,1,1,1)=[15;15];
%end


% Another initialization possibility: Randomly place on domain:
for m=1:S
	P(:,m,1,1,1)=([5;.5;10;.5].*((2*round(rand(p,1))-1).*rand(p,1))+[5;.5;84.3;2]);
end

% Next, initialize the parameters of the bacteria that govern
% part of the chemotactic behavior 

C=0*ones(S,Nre); % Allocate memory

% Set the basic run length step (one step is taken of this size if it does not go up a gradient
% but if it does go up then it can take as many as Ns such steps).  C(i,k) is the step size for
% the ith bacteria at the kth reproduction step.  For now, the step size is assumed to be constant since 
% we assume that perfect copies of bacteria are made, but later you can add evolutionary effects to modify 
% this and perhaps Ns and Nc.

runlengthunit=0.1;
C(:,1)=runlengthunit*ones(S,1);


% Allocate memory for cost function:

J=0*ones(S,Nc,Nre,Ned);
Jhealth=0*ones(S,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------------------
% Elimination-dispersal loop: 
%---------------------------------

for ell=1:Ned

%---------------------------------
% Reproduction loop: 
%---------------------------------

for k=1:Nre

%---------------------------------
% Swim/tumble (chemotaxis) loop:
%---------------------------------

for j=1:Nc

	for i=1:S 
           iteration=i*j*k*ell;
        % For each bacterium
		
		% Compute the nutrient concentration at the current location of each bacterium
		
		J(i,j,k,ell)=nutrientsfunc(P(:,i,j,k,ell),flag,iteration);
%		J(i,j,k,ell)=nutrientsfunc1(P(:,i,j,k,ell),flag);

		% Next, add on cell-cell attraction effect:
		
		J(i,j,k,ell)=J(i,j,k,ell)+bact_cellcell_attract_func(P(:,i,j,k,ell),P(:,:,j,k,ell),S,flag);
      BACTERIA=i
        chemotactic_STEP=j
		reproduction_STEP=k
        elimination_STEP=ell
     
        %-----------
		% Tumble:
		%-----------
		
		Jlast=J(i,j,k,ell); % Initialize the nutrient concentration to be the one at the tumble
							% (to be used below when test if going up gradient so a run should take place)

		% First, generate a random direction

		Delta(:,i)=(2*round(rand(p,1))-1).*rand(p,1);

		% Next, move all the bacteria by a small amount in the direction that the tumble resulted in
		% (this implements the "searching" behavior in a homogeneous medium)
		
		P(:,i,j+1,k,ell)=P(:,i,j,k,ell)+C(i,k)*Delta(:,i)/sqrt(Delta(:,i)'*Delta(:,i));
										% This adds a unit vector in the random direction, scaled
										% by the step size C(i,k)

       
		%---------------------------------------------------------------------
		% Swim (for bacteria that seem to be headed in the right direction):
		%---------------------------------------------------------------------

		J(i,j+1,k,ell)=nutrientsfunc(P(:,i,j+1,k,ell),flag,iteration); % Nutrient concentration for each bacterium after
%		J(i,j+1,k,ell)=nutrientsfunc1(P(:,i,j+1,k,ell),flag); % Nutrient concentration for each bacterium after
															% a small step (used by the bacterium to
															% decide if it should keep swimming)
		% Next, add on cell-cell attraction effect:
		
		J(i,j+1,k,ell)=J(i,j+1,k,ell)+bact_cellcell_attract_func(P(:,i,j+1,k,ell),P(:,:,j+1,k,ell),S,flag);
															
		m=0; % Initialize counter for swim length 
		
		while m<Ns  % While climbing a gradient but have not swam too long...
			
			m=m+1;
			
			if J(i,j+1,k,ell)<Jlast  % Test if moving up a nutrient gradient.  If it is then move further in
				                     % same direction
				Jlast=J(i,j+1,k,ell); % First, save the nutrient concentration at current location
								  % to later use to see if moves up gradient at next step
									  
				% Next, extend the run in the same direction since it climbed at the last step
				
				P(:,i,j+1,k,ell)=P(:,i,j+1,k,ell)+C(i,k)*Delta(:,i)/sqrt(Delta(:,i)'*Delta(:,i));
				
				J(i,j+1,k,ell)=nutrientsfunc(P(:,i,j+1,k,ell),flag,iteration); % Find concentration at where
%				J(i,j+1,k,ell)=nutrientsfunc1(P(:,i,j+1,k,ell),flag); % Find concentration at where
																	% it swam to and give it new cost value
				% Next, add on cell-cell attraction effect:
		
				J(i,j+1,k,ell)=J(i,j+1,k,ell)+bact_cellcell_attract_func(P(:,i,j+1,k,ell),P(:,:,j+1,k,ell),S,flag);
																	
			else  % It did not move up the gradient so stop the run for this bacterium
				m=Ns;
            end
            if J(i,j+1,k,ell)< Jfinal
                Jfinal=J(i,j+1,k,ell);
                I=i;J1=j+1;K=k;Ell=ell;      
            end
            
		end	% Test if should end run for bacterium
        
    end  % Go to next bacterium

	
%---------------------------------
end  % j=1:Nc
%---------------------------------

	% Reproduction
	
	Jhealth=sum(J(:,:,k,ell),2);  % Set the health of each of the S bacteria.
	                                     % There are many ways to define this; here, we sum
										 % the nutrient concentrations over the lifetime of the
										 % bacterium.

	% Sort cost and population to determine who can reproduce (ones that were in best nutrient
	% concentrations over their life-time reproduce)
	
	[Jhealth,sortind]=sort(Jhealth); % Sorts the nutrient concentration in order 
									% of ascending cost in the first dimension (bacteria number)
									% sortind are the indices in the new order
		
	P(:,:,1,k+1,ell)=P(:,sortind,Nc+1,k,ell); % Sorts the population in order of ascending Jhealth (the
											% ones that got the most nutrients were the ones with 
											% the lowest Jhealth values)
	
	C(:,k+1)=C(sortind,k); % And keeps the chemotaxis parameters with each bacterium at the next generation
		
	% Split the bacteria (reproduction)
	
	for i=1:Sr
		P(:,i+Sr,1,k+1,ell)=P(:,i,1,k+1,ell); % The least fit do not reproduce, the most 
		 									% fit ones split into two identical copies 
		C(i+Sr,k+1)=C(i,k+1); 	% and they get the same parameters as for their mother
	end

	% Evolution can be added here (can add random modifications to C(i,k), Ns, Nc, etc)
	

%---------------------------------
end  % k=1:Nre
%---------------------------------
	
	% Eliminate and disperse (on domain for our function) - keep same parameters C
	
	for m=1:S
		if ped>rand  % Generate random number and if ped bigger than it then eliminate/disperse
			P(:,m,1,1,ell+1)=([5;.5;10;.5].*((2*round(rand(p,1))-1).*rand(p,1))+[5;.5;84.3;2]);
		else
			P(:,m,1,1,ell+1)=P(:,m,1,Nre+1,ell);  % Bacteria that are not dispersed
		end
	end

%---------------------------------
end  % ell=1:Ned
%---------------------------------

e1=etime(clock,t);
hrs=0;min=0; sec=0;
e2=e1/(3600);
hrs=floor(e2);
e3=(e2-hrs)*60;
min=floor(e3);
sec=(e3-min)*60;
disp('elapsed time hrs  min     seconds');
optimum_value=Jfinal
P(1,I,J1,K,Ell)=[5+2*sin(P(2,I,J1,K,Ell))];
P(2,I,J1,K,Ell)=[0.5+0.1*sin(P(2,I,J1,K,Ell))];
P(4,I,J1,K,Ell)=2+[sin(P(2,I,J1,K,Ell)).^2];
parameters=P(:,I,J1,K,Ell)
hrs
min
sec