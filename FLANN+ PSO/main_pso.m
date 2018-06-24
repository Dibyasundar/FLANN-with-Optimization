clear;
clc;
close all;
ps=input('Enter the population size :');
k=input('maximum number of itertation :');
ph1=input('Enter the acceleration coeffecient :');
ph2=input('Enter the acceleration coeffecient :');
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

for j=1:ps
vel{j}=rand((N*(2*ex_k+1)),size(train_output,2))'*0.01;
end

for i=1:ps
    obj_val(i,:)=obj( pop{i},train_input,train_output,test_input,test_output,ex_k,0 );
end
p=pop;
iter=1;
while iter<=k
    g_best=1;
    for i=1:ps
        if(obj_val(i,1)<obj_val(g_best,1))
            g_best=i;
        end
    end
    for i=1:ps
        if(i~=g_best)
            vel{i}=vel{i}+(ph1.*rand().*(p{i}-pop{i}))+(ph2.*rand().*(pop{g_best}-pop{i}));
            pop{i}=pop{i}+vel{i};
            old_obj=obj_val(i,:);
            obj_val(i,:)=obj( pop{i},train_input,train_output,test_input,test_output,ex_k,0 );
            if(obj_val(i,:)<old_obj)
                p{i}=pop{i};
            end
        end
    end
    plot_var(iter)=obj_val(g_best,:);
    iter=iter+1;
end
g_best=1;
    for i=1:ps
        if(obj_val(i,1)<obj_val(g_best,1))
            g_best=i;
        end
    end
val=obj( pop{i},train_input,train_output,test_input,test_output,ex_k,1 );
figure;plot(plot_var);