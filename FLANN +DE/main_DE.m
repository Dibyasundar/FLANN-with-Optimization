clear;
clc;
close all;
ps=input('Enter the population size :');
k=input('maximum number of itertation :');
pa=input('Enter the forward probability :');
alpha=input('Enter the forward coeffecient :');
beta=input('Enter the backward coeffecient :');
pm=input('Enter the genetic mutation probality :');
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
iter=1;
while iter<=k
    for i=1:ps
        obj_val(i,:)=obj( pop{i},train_input,train_output,test_input,test_output,ex_k,0 );
    end
    min_pos=1;
    for i=1:ps
        if(obj_val(i,1)<obj_val(min_pos,1))
            min_pos=i;
        end
    end
    for j=1:ps
        if j~=min_pos
                if rand()<pa
                    x=pop{j}+(1+alpha)*(pop{min_pos}-pop{j});
                    pop{j}=pop{j}+(rand()*(x-pop{j}));
                else
                    x=pop{j}-(beta*(pop{min_pos}-pop{j}));
                    pop{j}=pop{j}+(rand()*(x-pop{j}));
                end
                if rand()<pm
                    pop{j}=rand((N*(2*ex_k+1)),size(train_output,2))'*0.01;
                end
        end
    end
    plot_var(iter)=obj_val(min_pos,:);
    iter=iter+1;
end
min_pos=1;
    for i=1:ps
        if(obj_val(i,1)<obj_val(min_pos,1))
            min_pos=i;
        end
    end
val=obj( pop{i},train_input,train_output,test_input,test_output,ex_k,1 );
figure;plot(plot_var);