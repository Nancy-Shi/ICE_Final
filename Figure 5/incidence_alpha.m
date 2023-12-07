clear
clc
%Vec=["0.00","0.25","0.50","0.75","1.00",...
%     "1.25","1.50","1.75","2.00",...
%     "2.25","2.50","2.75","3.00",...
%     "3.25","3.50","3.75","4.00",...
%     "4.25","4.50","4.75","5.00"];

Vec=["0.00","0.05","0.10","0.15","0.20",...
     "0.25","0.30","0.35","0.40","0.45","0.50"];

for jj=1:length(Vec)
    Alp=Vec(jj);
    Data=csvread('Test_alpha/results_alpha_'+string(Alp)+'.csv',1);
    for kk=1:50
        idx=max(find(Data(2*(kk-1)+1,:)>0));
        Data(2*(kk-1)+1,idx:end)=Data(2*(kk-1)+1,idx);
        Data(2*kk,idx:end)=Data(2*kk,idx);
    end
    for kk=1:50
        for ii=1:150
            idx1=find(Data(2*(kk-1)+1,:)<ii);
            idx=find(Data(2*(kk-1)+1,:)<=ii+1);
            if (length(idx1)>0 & length(idx)>0)
               Inc(ii)=Data(2*kk,max(idx))-Data(2*kk,max(idx1));
               else
               Inc(ii)=0;
            end
            Inc=[Inc,zeros(1,150-length(Inc))];
        end
        YY(kk,:)=Inc;
    end
    ZZ(jj,:)=mean(YY);
end
% plot(Inc)
% length(Inc)
% Total_Recovered=sum(Inc)
Rend=cumsum(ZZ');
%plot(1:length(Vec),Rend(end,:),'o')
figure;
plot(str2double(Vec), Rend(end, :), 'o', 'MarkerFaceColor', 'm', 'MarkerEdgeColor', 'm');
xlabel('Information stifling rate (\alpha)', 'FontSize', 16);
ylabel('Recovered (end)', 'FontSize', 16);

csvwrite('inc_mean_alpha.csv', ZZ);
csvwrite('R_end_alpha.csv', Rend(end,:));
saveas(gcf, 'alpha_0_to_0_5.pdf');
