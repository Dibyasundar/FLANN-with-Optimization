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
    g_worst=1;
    for i=1:ps
        if(obj_val(i,1)>obj_val(g_worst,1))
            g_worst=i;
        end
    end
    p_best=pop{g_best};
    p_worst=pop{g_worst};
    for i=1:ps
        npop=pop{i}+(rand(size(pop{i})).*(p_best-abs(pop{i})))-(rand(size(pop{i})).*(p_worst-abs(pop{i})));
        val=obj( npop,train_input,train_output,test_input,test_output,ex_k,0 );
        if val<obj_val(i,:)
            pop{i}=npop;
            obj_val(i,:)=val;
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
val=obj( pop{i},train_input,train_output,test_input,test_output,ex_k,1);
figure;plot(plot_var);