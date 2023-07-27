function [data_tfidf] = calcTFIDFUpdated(data)
% an updated version of the original calcTFIDF.
% the only modification here is the addition of the third line from the end
% which converts all the Inf values in idf to 0. 
%
% Original description is as follows:
%
% TF-IDF normalization of raster data
% INPUT:
%     data: N-by-T raster matrix
% OUTPUT:
%     data_tfidf: N-by-T normalized matrix
% Shuting Han, 2018
%

dims = size(data);

tf = data./(ones(dims(1),1)*sum(data,1));
idf = dims(2)./(sum(data,2)*ones(1,dims(2)));
idf(isnan(idf)) = 0;
idf = log(idf);
idf(isinf(idf)) = 0;% custom addition
data_tfidf = tf.*idf;

end