%% Putting CLFDM library in the MATLAB Path
if isempty(regexp(path,['CLFDM_lib' pathsep], 'once'))
    addpath([pwd, '/CLFDM_lib']);    % add SEDS dir to path
end
%%%%%%%%%%demo
%load('models/recorded_motions/JShape_2','demos');
%load('models/recorded_motions/CShape','demos');
load('models/recorded_motions/nao_20151027','demos');

% Pre-processing
dt = 0.1; %The time step of the demonstrations
tol_cutting = 1; % A threshold on velocity that will be used for trimming demos

%%%%%%%%%%%%%%%%train
options.energy='off';
options.suf='off';

start_time_train=cputime;
[x0 , xT, Data, index] = preprocess_demos(demos,dt,tol_cutting); %preprocessing datas
[net,accuracy]=mlp_hu(Data,50,'sinh',options);
%[net,accuracy]=mlp_hu(Data,150,'sinh');
end_time_train=cputime;
end_time_train=end_time_train-start_time_train;

d = size(Data,1)/2; %dimension of data
%%%%%%%%estimate error
dx_es=mlpfwd(net,Data(1:d,:));
error_comp=estimate_accuracy(dx_es,Data(d+1:end,:),0.6,0.4,10^-6);


opt_sim.dt = 0.1;
opt_sim.i_max = 3000;
opt_sim.tol = 0.1;
x0_all = Data(1:d,index(1:end-1)); %finding initial points of all demonstrations
%x0_all=[-180,-160,-140,-120;-250,-200,-150,-120;-250,-220,-200,-150];
%x0_all=[x0_all,-x0_all];
%x0_all=[x0_all,Data(1:d,index(1:end-1))];
fn_handle = @(x) mlpfwd(net,x);
[x xd]=Simulation(x0_all,[],fn_handle,opt_sim); %running the simulator

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%simulation
%% Simulation
%%
% plotting the result
figure('name','Results from Simulation','position',[265   200   520   720])
sp(1)=subplot(3,1,1);
hold on; box on
plot(Data(1,:),Data(2,:),'r.')
xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',25);
ylabel('$\xi_2 (mm)$','interpreter','latex','fontsize',25);
title('Simulation Results')

sp(2)=subplot(3,1,2);
hold on; box on
plot(Data(1,:),Data(3,:),'r.')
xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',25);
ylabel('$\dot{\xi}_1 (mm/s)$','interpreter','latex','fontsize',25);

sp(3)=subplot(3,1,3);
hold on; box on
plot(Data(2,:),Data(4,:),'r.')
xlabel('$\xi_2 (mm)$','interpreter','latex','fontsize',25);
ylabel('$\dot{\xi}_2 (mm/s)$','interpreter','latex','fontsize',15);

for i=1:size(x,3)
    plot(sp(1),x(1,:,i),x(2,:,i),'linewidth',2)
    plot(sp(2),x(1,:,i),xd(1,:,i),'linewidth',2)
    plot(sp(3),x(2,:,i),xd(2,:,i),'linewidth',2)
    plot(sp(1),x(1,1,i),x(2,1,i),'ok','markersize',5,'linewidth',5)
    plot(sp(2),x(1,1,i),xd(1,1,i),'ok','markersize',5,'linewidth',5)
    plot(sp(3),x(2,1,i),xd(2,1,i),'ok','markersize',5,'linewidth',5)
end

for i=1:3
    axis(sp(i),'tight')
    ax=get(sp(i));
    axis(sp(i),...
        [ax.XLim(1)-(ax.XLim(2)-ax.XLim(1))/10 ax.XLim(2)+(ax.XLim(2)-ax.XLim(1))/10 ...
        ax.YLim(1)-(ax.YLim(2)-ax.YLim(1))/10 ax.YLim(2)+(ax.YLim(2)-ax.YLim(1))/10]);
    plot(sp(i),0,0,'k*','markersize',15,'linewidth',3)
    if i==1
        D = axis(sp(i));
    end
end

% plotting streamlines
%figure('name','Streamlines','position',[800   90   560   320])
figure('name','Streamlines')
plotStreamLines(net,D)
hold on
plot(Data(1,:),Data(2,:),'r.')
plot(0,0,'k*','markersize',15,'linewidth',3)
%xlabel('$\xi_1 (mm)$','interpreter','latex','fontsize',25);
%ylabel('$\xi_2 (mm)$','interpreter','latex','fontsize',25);
%title('Streamlines of the model')
%set(gca,'position',[0.1300    0.1444    0.7750    0.7619])
