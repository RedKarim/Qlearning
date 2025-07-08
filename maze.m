%load("Qfile.mat");
Results=[];
qtable=zeros(100,4);
  Ep=2.0;

for e=1:2000%エピソード
    x=0;y=0;%初期座標
    for I=1:300 %試す回数
        s=10*x+y+1;%状態
        R=-0.1;%報酬
        if(rand()*10<Ep)
          action=randperm(4,1);%行動を選ぶ
        else
            [U,action]=max(qtable(s,:));
        end
        switch(action)
            case 1 %右
                 x=x+1;
                 if(x>9)x=4; R=-10;end
            case 2%左
                x=x-1;
                if(x<0)x=0; R=-10; end
            case 3%上
                 y=y+1;
                 if(y>9)y=4; R=-10;end
            case 4%下
                y=y-1;
                if(y<0)y=0; R=-10; end
        end
            sn=10*x+y+1;%次の状態
            if(sn==100)
                R=10;
            end

           % Update Q

           qtable(s,action)=0.9*qtable(s,action)+0.1*(R+0.9*max(qtable(sn,:)));
%Qテーブルの更新
             if(x==9 && y==9)
                break;
            end
    end
    Ep=Ep*0.99;
    Results(end+1,:)=[e, I, Ep];
end
%save("Qfile.mat",'qtable')

% Plot the results
figure('Position', [100, 100, 1200, 400]);

% Plot 1: Number of steps per episode
subplot(1,3,1);
plot(Results(:,1), Results(:,2), 'b-');
title('Steps per Episode');
xlabel('Episode');
ylabel('Number of Steps');
grid on;

% Plot 2: Epsilon decay
subplot(1,3,2);
plot(Results(:,1), Results(:,3), 'r-');
title('Epsilon Decay');
xlabel('Episode');
ylabel('Epsilon Value');
grid on;

% Plot 3: Moving average of steps
subplot(1,3,3);
window = 50; % Window size for moving average
movingAvg = movmean(Results(:,2), window);
plot(Results(:,1), movingAvg, 'g-');
title(['Moving Average of Steps (Window = ' num2str(window) ')']);
xlabel('Episode');
ylabel('Average Steps');
grid on;

sgtitle('Q-Learning Training Progress');
