clc;
clear all;
tic;
load data1use;
N=99; %x=rand(N,2); % Create N, 2-D data points  
x=data1use(1:N,2:5);
M=N*N-N; s=zeros(M,3); % Make ALL N^2-N similarities  
j=1;
for i=1:N  
  for k=[1:i-1,i+1:N]  
    s(j,1)=i; s(j,2)=k; s(j,3)=-sum((x(i,:)-x(k,:)).^2);  
    j=j+1;  
  end;  
end;
p=median(s(:,3)); % Set preference to median similarity  
[idx,netsim,dpsim,expref]=apcluster(s,p,'plot');  
fprintf('Number of clusters: %d\n',length(unique(idx)));  
fprintf('Fitness (net similarity): %f\n',netsim);  
figure; % Make a figures showing the data and the clusters  
for i=unique(idx)'  
  ii=find(idx==i); h=plot(x(ii,1),x(ii,2),'o'); hold on;  
  col=rand(1,3); set(h,'Color',col,'MarkerFaceColor',col);  
  xi1=x(i,1)*ones(size(ii)); xi2=x(i,2)*ones(size(ii));   
  line([x(ii,1),xi1]',[x(ii,2),xi2]','Color',col); 
end;
toc;