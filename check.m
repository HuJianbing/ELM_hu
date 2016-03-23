nhidden=size(net.w1,2);
for i=1:nhidden
    if net.w2(i,:)*net.w1(:,i)>=0
        disp(['one mismarch ' num2str(net.w2(i,:)*net.w1(:,i))]);
    end
end