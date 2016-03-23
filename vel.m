%plot velocity for 3-D situation
figure(2)
plot3(Data(4,:),Data(5,:),Data(6,:),'r.')
xlabel('$\dot{\xi}_1 (mm/s)$','interpreter','latex','fontsize',15);
ylabel('$\dot{\xi}_2 (mm/s)$','interpreter','latex','fontsize',15);
zlabel('$\dot{\xi}_3 (mm/s)$','interpreter','latex','fontsize',15);
hold on;
for i=1:size(x,3)
    plot3(xd(1,:,i),xd(2,:,i),xd(3,:,i),'linewidth',2);
     plot3(xd(1,1,i),xd(2,1,i),xd(3,1,i),'ok','markersize',5,'linewidth',5);
end

