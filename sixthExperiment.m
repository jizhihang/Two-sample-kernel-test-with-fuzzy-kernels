function [STAT1,STAT2]=sixthExperiment(alph,m,shuff,nTest,nroEpoch,X,test)
% two smaple kernel hipothesis testing
% only the the fuzzy variables has its own kernel, it is considered a
% linear kernel for the other dimensions
% input :
% 
% %test level
% alph=0.5;
% 
% %number of samples
% m=25;
% 
% %number of shuffles for boostrap
% shuff=300;
% 
% %number of tests
% nTest=100;
%
% %number of epochs
% nroEpoch=30;
%
% %fuzzy dataset
% X

result=zeros(nTest,1);

%number of epochs for statistics


addpath ./kernels

%variables with final statistics
STAT1=zeros(nroEpoch,1);
STAT2=zeros(nroEpoch,1);

% kernel on fuzzy sets
%----------------------
for epoch= 1:nroEpoch
    for i=1:nTest        
        
        % Testing samples from two different distributions
        if test==1
            %randomly choose 100 pairs of m samples class 1 and m samples class -1
            %chose the indices
            ind1=randsample(201,m);
            ind2=randsample(202:286,m);
        
        % Testing samples from the same  distribution
        else
            idClass=randi(2,1);
            if idClass==2
                %randomly choose 100 pairs of m samples class 1
                ind1=randsample(201,m);
                % and again another 100 pairs of m samples class 1
                ind2=randsample(201,m);
                
            else
                %randomly choose 100 pairs of m samples class -1
                ind1=randsample(202:286,m);
                % and again another 100 pairs of m samples class -1
                ind2=randsample(202:286,m);
            end            
        end
        
        %MMD for fuzzy kernels
        
        % testing the null hipotehsis that both samples were generated by the same
        % distribution
        
        
        
        %XX
        %---------------------------------------------
        k_2=intersectionKernel(cell2mat(X(ind1,2)),cell2mat(X(ind1,2)),1);
        k_3=intersectionKernel(cell2mat(X(ind1,3)),cell2mat(X(ind1,3)),1);
        k_4=intersectionKernel(cell2mat(X(ind1,4)),cell2mat(X(ind1,4)),1);
        k_5=intersectionKernel(cell2mat(X(ind1,5)),cell2mat(X(ind1,5)),1);
        k_lin=linearKernel(cell2mat(X(ind1,6:10)),cell2mat(X(ind1,6:10)));
        K= k_2+k_3+k_4+k_5+k_lin;
        
        %YY
        %---------------------------------------------
        k_2=intersectionKernel(cell2mat(X(ind2,2)),cell2mat(X(ind2,2)),1);
        k_3=intersectionKernel(cell2mat(X(ind2,3)),cell2mat(X(ind2,3)),1);
        k_4=intersectionKernel(cell2mat(X(ind2,4)),cell2mat(X(ind2,4)),1);
        k_5=intersectionKernel(cell2mat(X(ind2,5)),cell2mat(X(ind2,5)),1);
        k_lin=linearKernel(cell2mat(X(ind2,6:10)),cell2mat(X(ind2,6:10)));
        L=k_2+k_3+k_4+k_5+k_lin;
        
        %XY
        %---------------------------------------------
        k_2=intersectionKernel(cell2mat(X(ind1,2)),cell2mat(X(ind2,2)),1);
        k_3=intersectionKernel(cell2mat(X(ind1,3)),cell2mat(X(ind2,3)),1);
        k_4=intersectionKernel(cell2mat(X(ind1,4)),cell2mat(X(ind2,4)),1);
        k_5=intersectionKernel(cell2mat(X(ind1,5)),cell2mat(X(ind2,5)),1);
        k_lin=linearKernel(cell2mat(X(ind1,6:10)),cell2mat(X(ind2,6:10)));
        KL=k_2+k_3+k_4+k_5+k_lin;
        
        %MMD statistic. Here we use biased
        %v-statistic. NOTE: this is m * MMD_b
        %testStat1(i) = 1/(m*(m-1)) * sum(sum(K + L - KL - KL'));
        %or
        testStat(i) = 1/m * sum(sum(K + L - KL - KL'));
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        result(i)=testMMD(K, L, KL,shuff, alph,testStat(i));
        
        
        
end
%     disp('mean test statistic 1');
%     mean(testStat);
%    disp('rate accepted p=q');
    STAT1(epoch)=length(result(find(result==1)));
%    disp('rate rejected p~= q');
    STAT2(epoch)=length(result(find(result==0)));
    result=zeros(nTest,1);
    
end
% disp('final results')
% disp('mean rate accepted')
% STAT1=mean(STAT1)
% disp('mean rate rejected')
% STAT2=mean(STAT2)
