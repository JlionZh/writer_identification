%% TR_CWTcoef_main.m
% MATLAB code for the article
%  TITLE = ��A Joint Model of Complex Wavelet Coefficients for Texture Retrieval��
% AUTHOR = {Roland Kwitt and Andreas Uhl},
%	DATE = {nov,2009},
% BOOKTITLE = {Proceedings of the IEEE International Conference on Image Processing, ICIP '09},

% ��ͼ�ķָ�
% TR_CWTcoef_splitting.m
tic
% clear all
clc
clear
% cd('D:\2_26\scatter_gamma\a joint model\my proc');
% addpath(genpath(pwd));
  
% ��ͼ���ݵ���
% %%%%%%% ͼ��ָ�Ϊ16����ͼ
% splittingimgs_path = 'H:\scattering\Brodatz�ָ�\';
% data = texload('Brodatz',splittingimgs_path ,16,1,2);


%%%%%%% ͼ��ָ�Ϊ64����ͼ
%%Jmax=7;  %%%%%%%%%%%%%%% ÿ�μǵ��޸�sizeb
maxclasses=3;
% data=brodatz_data(Jmax,maxclasses);
number=16;
t0=clock;
%filenames = retrieve_writing_Ltrain(maxclasses);
%data=vistex_data(Jmax,maxclasses);
% data=stex_data(Jmax,maxclasses);
%  path_to_db = 'D:\2_26\dataset\tmp';
%  path_to_db='E:\Jay\cvpr2013\umd dataset';
path_to_db='D:\2_26\dataset\normal';
src = kthtips_src(path_to_db);
c_t0=etime(clock,t0);
t1=clock;

% Ϊÿ����ͼ����һ��model
models = icip09(src,'stage','genmodel','copula','Gaussian','samples',100,'debug',true);   
% model = icip09(data,'stage','genmodel','copula','t','samples',500,'debug',true); 
% ����ÿ����ͼ��������ͼ�ľ���
c_t1=etime(clock,t1);
t2=clock;
div = icip09(src,'stage','runsim','models',models,'samples',100,'debug',true);
c_t2=etime(clock,t2);

% save div;
% �õ�ƽ�����  kld �Գƾ���
t3=clock;
div = div + div';

% �õ����յļ�����(ȡ40����ƥ���)
[r, rs,or]=evalir(generic_rrate(div,24,'ascend'))
c_t3=etime(clock,t3);

 
toc







