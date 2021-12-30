function [Jar]=bact_cellcell_attract_func(x,theta,S,flag)  
% Given locations of all bacteria, find Jar for all S bacteria
% Note that theta rows are dimensions of the opt. problem, while the columns are
% the S different bacteria. For now, designed for p=2

if flag==2  % Test to see if main program indicated cell-cell attraction
	Jar=0;
	return
end

depthattractant=0.1;  % Sets magnitude of secretion of attractant by a cell
widthattractant=0.2;  % Sets how the chemical cohesion signal diffuses (smaller makes it diffuse more)

heightrepellant=1*depthattractant; % Sets repellant (tendency to avoid nearby cell)
widthrepellant=10;  % Makes small area where cell is relative to diffusion of chemical signal

Jar=0;

for j=1:S
		
	% Set how the cell attracts other cells via secretions of diffusable attractants

	Ja=-depthattractant*exp(-widthattractant*((x(1,1)-theta(1,j))^2+(x(2,1)-theta(2,j))^2));

	% Set how the cell repells other cells since it eats in its own region (and since an intact
	% cell is apparently not food for another cell)

	Jr=+heightrepellant*exp(-widthrepellant*((x(1,1)-theta(1,j))^2+(x(2,1)-theta(2,j))^2));

	% Next, set the combined effect

	Jar=Jar+Ja+Jr;

end