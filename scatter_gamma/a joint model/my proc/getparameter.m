function varargout = getparameter(data,filenames,varargin)
    p = inputParser;   % inputParser:Construct input parser object 构造输入解析器对象
    % p: 调用输入构造器类(inputParser)创造此类的一个实例(instance),或者曰对象(object)，是一个空的输入解析器对象
    % 目的：可以存取/访问(access)此类的所有方法和属性，来解析、验证函数的输入参数
    p.addRequired('data',@iscell); % returns logical 1 (true)if data is a cell array 
    % p.addRequired('filenames',@iscell);
    % p.addRequired(argname, validator) argname:必须的参数   validator：验证器（matlab解析验证的时候使用的句柄）
    % 作用：为解析器对象p增加一个"required argument" 
    % If the validator function returns false or errors,the parsing fails and MATLAB throws an error. 
    % MATLAB parses  required arguments before optional or parameter-value arguments.
    % MATLAB parses  parameter-value arguments after required arguments and optional arguments.
    
    % model = icip09(data,'stage','genmodel','debug',true)
    p.addParamValue('models',{},@iscell); 
    % Add parameter-value pair argument to inputParser schema
    p.addParamValue('stage','genmodel',@(x)any(strcmpi(x,{'genmodel','runsim'}))); % strcmpi比较结果相同则1，any不全0则1，这个验证器为真则通过验证，否则抛出错误
                                                                                   % 默认选项‘genmodel’，x是输入参数，要和后面的选项进行匹配
    % p.addParamValue('margin', 'Weibull', @(x)any(strcmpi(x,{'Weibull','Gamma'})));
    p.addParamValue('margin', 'Gamma', @(x)any(strcmpi(x,{'Weibull','Gamma'})));
    p.addParamValue('copula', 'Gaussian', @(x)any(strcmpi(x,{'Gaussian','t'})));
    p.addParamValue('level',3,@(x)x>=1);
    p.addParamValue('samples',100,@(x)x>=100);
    p.addParamValue('debug',false,@islogical);
   
    p.parse(data,varargin{:});
    p.parse(filenames,varargin{:});
    %%p.parse(filenames,varargin{:});
    
    debug = p.Results.debug;
    models = p.Results.models;
    level = p.Results.level;
    samples = p.Results.samples;
    stage = p.Results.stage;
    margintype = p.Results.margin
    copulatype = p.Results.copula;

    progname ='icip09';
    options=struct;
    options.J=level;
    options.M=2;
    options.Q=1;
    M=getoptions(options,'M',2);

    if (debug)
        fprintf('[%s]: running %s for %s margins and %s copula (level %d)\n', ...
            progname, stage, margintype, copulatype, level);
    end
    switch stage                 % 步骤
        case 'genmodel'          % 产生模型
            if (~isempty(models))
                error('model parameter given although stage is genmodel');
            end
            k=1;%%%%%%% k=i*j,记录所有图像数。
            length1=size(filenames,2)
            for i=1:size(filenames,2)
                
                for j=1:size(filenames{i},2)
                        %%in=double(data{i}{j});
                        filename=filenames{i}{j};
                        %%X=ownscat(filename,options);
                        X=newscat(filename,options);
                        %%X=double(X);
                        %%fun = @(Sx)(mean(mean((remove_margin(format_scat(Sx),1)),2),3));
                        %%X=fun(X_all);
                        %%X=double(X);
                    %%  X=scatt_copula(in,options);
     %                         if k==3
     %                             k;
     %                              model{k} = ctbfit(abs(X{M+1}),'margin', margintype, 'copula',copulatype,'debug',debug); 
     %                         end
     %                        
            %            X = abs(scatt(in,options));
            %            X = ctbgen(data{i}{j},'margin',margintype,...
            %            'levels',level,'debug',debug);%%彩色copula
               %%      model{k} = ctbfit(abs(X{M}),'margin', margintype, 'copula',copulatype,'debug',debug); 
                     varmodel{k} = ctbfit(abs(X{M+1}),'margin', margintype, 'copula',copulatype,'debug',debug); 
                     clear X;
                     clear in;
                   k=k+1;
                end
                
            end

            varargout(1) = {varmodel};             % 输出参数的个数（变长）
    end
end