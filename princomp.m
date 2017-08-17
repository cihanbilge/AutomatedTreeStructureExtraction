function [largest_coeff,score,latent]=princomp(A)
%performs principal components analysis 
 %    (PCA) on the n-by-p data matrix A
 %    Rows of A correspond to observations, columns to variables. 

 %Returns :  
  %coeff :
   % is a p-by-p matrix, each column containing coefficients 
   % for one principal component.
  %score : 
  %  the principal component scores; that is, the representation 
   % of A in the principal component space. Rows of SCORE 
   % correspond to observations, columns to components.
  %latent : 
  %  a vector containing the eigenvalues 
  %  of the covariance matrix of A.

% computing eigenvalues and eigenvectors of covariance matrix
 M = (A-repmat(mean(A,2),[1 size(A,2)]))'; M(M==inf)=max(M(:)); M(isnan(M))=max(M(:));
 % subtract the mean (along columns)
 try 
     [coeff,latent] = eig(cov(M)); %coeff=diag(coeff);%# attention:not always sorted
    latent=diag(latent); [l_sorted,ind]=sort(latent,'descend');
    largest_coeff=coeff(:,ind(1));
catch 
     coeff=ones(2,2);
     latent=eye(2);
 end

 
 score = coeff'*M'; % projection of the data in the new space
end

% Created by Cihan Kayasandik and Pooran Negi
%August 2017

