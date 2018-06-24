clear;
clc;
close all;
ps=input('Enter the population size :');
k=input('maximum number of itertation :');
ex_k=input('input the size of expansion :');
[data,label]=xlsread('ddata.xlsx');
input=data(:,1:size(data,2)-1);
output=data(:,size(data,2));
clear data label;
input(:,size(input,2)+1)=1;
train_input=input(1:uint32(size(input,1)/2),:);
train_output=output(1:uint32(size(output,1)/2),:);
test_input=input(uint32(size(input,1)/2)+1:size(input,1),:);
test_output=output(uint32(size(output,1)/2)+1:size(output,1),:);
N=size(train_input,2);
m=size(train_input,1);

for j=1:ps
pop{j}=rand((N*(2*ex_k+1)),size(train_output,2))'*0.01;
end
for i=1:ps
    obj_val(i,:)=obj( pop{i},train_input,train_output,test_input,test_output,ex_k,0 );
end
iter=1;
while iter<=k
    g_best=1;
    for i=1:ps
        if(obj_val(i,1)<obj_val(g_best,1))
            g_best=i;
        end
    end
    M=pop{1};
    for j=2:ps
        M=M+pop{j};
    end
    M=M./ps;
    diff_mean=(pop{g_best}-(round(1+rand())*M));
    for i=1:ps
        npop=pop{i}+diff_mean;
        val=obj( npop,train_input,train_output,test_input,test_output,ex_k,0);
        if val<obj_val(i,:)
            pop{i}=npop;
            obj_val(i,:)=val;
        end
        
    end
    for i=1:ps
        n_l=randperm(ps,1);
        if obj_val(n_l,:)~=obj_val(i,:)
            if obj_val(n_l,:)>obj_val(i,:)
                npop=pop{i}+(rand()*(pop{i}-pop{n_l}));
            elseif obj_val(n_l,:)>obj_val(i,:)
                npop=pop{i}+(rand()*(pop{n_l}-pop{i}));
            end
            val=obj( npop,train_input,train_output,test_input,test_output,ex_k,0);
            if val<obj_val(i,:)
                pop{i}=npop;
                obj_val(i,:)=val;
            end
        end
    end
    for i=1:ps
        for j=1:ps
            if i~=j
                if isequal(pop{i},pop{j})
                    pop{j}=rand(size(pop{j})).*pop{j};
                    obj_val(j,:)=obj( pop{j},train_input,train_output,test_input,test_output,ex_k,0);
                end
            end
        end
    end
    plot_var(iter)=obj_val(g_best,:);
%     pop
    iter=iter+1;
end
g_best=1;
    for i=1:ps
        if(obj_val(i,1)<obj_val(g_best,1))
            g_best=i;
        end
    end
val=obj( pop{g_best},train_input,train_output,test_input,test_output,ex_k,1);
figure;plot(plot_var);