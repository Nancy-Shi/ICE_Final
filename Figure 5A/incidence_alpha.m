clear
clc
rng(10);
C0=[0.75 0.75 0.75];
C1=[0 0.45 0.74];
C2=[0.9 0.65 0.13];
C3=[0.49 0.18 0.56];
C4=[0.47 0.67 0.19];
% C4=[255 215 0]/255;
C5=[0.64 0.08 0.18];
C8=[0.85 0.33 0.1];
C6=[200 0 100]/255;
C7=[0.3 0.5 0];
clr={C0,C1,C2,C3,C4,C5,C6};

subplot(1,2,1)

Vec=["0.00","0.05","0.10","0.15","0.20",...
     "0.25","0.30","0.35","0.40","0.45","0.50"];

for jj=1:length(Vec)
    Alp=Vec(jj);
    %Data=csvread('results_alpha_'+string(Alp)+'.csv',1);
    Data=csvread('Test_alpha_new_2/results_alpha_'+string(Alp)+'.csv',1);
    for kk=1:100
        idx=max(find(Data(2*(kk-1)+1,:)>0));
        Data(2*(kk-1)+1,idx:end)=Data(2*(kk-1)+1,idx);
        Data(2*kk,idx:end)=Data(2*kk,idx);
    end
    for kk=1:100
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
        YY(kk,:)=sum(movmean(Inc,7))/500;
    end
    ZZ(jj,:)=YY;
end

for r=1:length(Vec)
    BNV1=bootstrp(500,'mean',ZZ(r,:));
    NV95min1(r)=min(prctile(BNV1,[2.5 97.5]));
    NV95max1(r)=max(prctile(BNV1,[2.5 97.5]));
    NVminR1(r)=min(prctile(BNV1,[25 75]))-1.5*iqr(BNV1);
    NVmaxR1(r)=max(prctile(BNV1,[25 75]))+1.5*iqr(BNV1);
    mm1(r)=mean(BNV1);
end

hold on
curve1 = (NV95min1);
curve2 = (NV95max1);
xx1=0:length(Vec)-1;
hh1=fill([xx1 fliplr(xx1)], [curve2 fliplr(curve1)]',C1);
set(hh1,'facealpha',0.2);
set(hh1,'edgecolor','none');
curve1 = (NVminR1);
curve2 = (NVmaxR1);
xx1=0:length(Vec)-1;
hh1=fill([xx1 fliplr(xx1)], [curve2 fliplr(curve1)]',C1);
set(hh1,'facealpha',0.1);
set(hh1,'edgecolor','none');

pp1=plot(xx1, mm1, '-o', 'color', C1,'linewidth', 2,'MarkerFaceColor', C1, 'MarkerEdgeColor', C1);

set(gca,'ygrid', 'on','fontsize',14,'tickdir','out')
set(gca,'XTick',0:2:10,'XTickLabel',0:0.1:0.5)
%set(gca,'YTick',0:0.1:0.8,'YTickLabel',0:10:80)
set(gca,'YTick',0.15:0.05:0.35,'YTickLabel',15:5:35)
%ylim([0 0.8])
ylim([0.15 0.35])
xlabel('Correction rate of misinformation (\alpha)')
ylabel('Attack rate (%)')
H=gca;
H.LineWidth=1;
TT=title('\rmA','Position',[0.2, 0.81])
set(TT,'fontsize',20)
s =  [200 200 1000 440];
set(gcf,'Position',s)

exportgraphics(gcf, 'Fig5A.pdf');