%load("Qfile3d.mat");
Results=[];
qtable=zeros(1000,6); % 10x10x10 states, 6 possible actions
Ep=2.0;

for e=1:2000%エピソード
    x=0;y=0;z=0;%初期座標(3D)
    for I=1:500 %試す回数(増やす because 3D is more complex)
        s=100*z + 10*x + y + 1;%状態(3D)
        R=-0.1;%報酬
        if(rand()*10<Ep)
          action=randperm(6,1);%行動を選ぶ(6方向)
        else
            [U,action]=max(qtable(s,:));
        end
        switch(action)
            case 1 %右
                 x=x+1;
                 if(x>9)x=4; R=-10;end
            case 2 %左
                x=x-1;
                if(x<0)x=0; R=-10; end
            case 3 %前
                 y=y+1;
                 if(y>9)y=4; R=-10;end
            case 4 %後
                y=y-1;
                if(y<0)y=0; R=-10; end
            case 5 %上
                z=z+1;
                if(z>9)z=4; R=-10;end
            case 6 %下
                z=z-1;
                if(z<0)z=0; R=-10; end
        end
        sn=100*z + 10*x + y + 1;%次の状態(3D)
        if(sn==1000) % Goal at (9,9,9)
            R=10;
        end

        % Update Q
        qtable(s,action)=0.9*qtable(s,action)+0.1*(R+0.9*max(qtable(sn,:)));
        %Qテーブルの更新
        if(x==9 && y==9 && z==9)
            break;
        end
    end
    Ep=Ep*0.99;
    Results(end+1,:)=[e, I, Ep];
end
%save("Qfile3d.mat",'qtable')

% Plot the results
figure('Position', [100, 100, 1200, 800]);

% Plot 1: Number of steps per episode
subplot(2,2,1);
plot(Results(:,1), Results(:,2), 'b-');
title('Steps per Episode');
xlabel('Episode');
ylabel('Number of Steps');
grid on;

% Plot 2: Epsilon decay
subplot(2,2,2);
plot(Results(:,1), Results(:,3), 'r-');
title('Epsilon Decay');
xlabel('Episode');
ylabel('Epsilon Value');
grid on;

% Plot 3: Moving average of steps
subplot(2,2,3);
window = 50; % Window size for moving average
movingAvg = movmean(Results(:,2), window);
plot(Results(:,1), movingAvg, 'g-');
title(['Moving Average of Steps (Window = ' num2str(window) ')']);
xlabel('Episode');
ylabel('Average Steps');
grid on;


