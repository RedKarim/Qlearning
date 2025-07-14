%load("Qfile.mat");
Results=[];
qtable=zeros(120,4);
Ep=2.0;

% Define obstacles at specific coordinates
obstacles = [3, 4; 7, 8]; % Example: obstacles at (3,4) and (7,8)

% Create figure for animation
figure('Position', [100, 100, 800, 600]);
subplot(2,2,1); % Animation will be in top-left

for e=1:2000%エピソード
    x=0;y=0;%初期座標
    
    % Animation setup for this episode
    if mod(e, 100) == 1 % Show animation every 100 episodes
        clf; % Clear figure
        subplot(2,2,1);
        hold on;
        grid on;
        axis([0 11 0 9]);
        title(['Episode ' num2str(e) ' - Agent Path']);
        xlabel('X Position');
        ylabel('Y Position');
        
        % Plot obstacles
        for i = 1:size(obstacles, 1)
            rectangle('Position', [obstacles(i,1)-0.4, obstacles(i,2)-0.4, 0.8, 0.8], ...
                     'FaceColor', 'red', 'EdgeColor', 'black');
        end
        
        % Plot goal
        rectangle('Position', [9-0.4, 9-0.4, 0.8, 0.8], ...
                 'FaceColor', 'green', 'EdgeColor', 'black');
        
        % Plot start position
        plot(0, 0, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'blue');
        
        path_x = [0];
        path_y = [0];
    end
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
        
        % Check if new position hits an obstacle
        for i = 1:size(obstacles, 1)
            if x == obstacles(i,1) && y == obstacles(i,2)
                R = -10; % Penalty for hitting obstacle
                % Reset to previous position (you can modify this behavior)
                switch(action)
                    case 1, x = x-1; % Undo right move
                    case 2, x = x+1; % Undo left move
                    case 3, y = y-1; % Undo up move
                    case 4, y = y+1; % Undo down move
                end
                break;
            end
        end
        
        % Update path for animation
        if mod(e, 100) == 1
            path_x = [path_x, x];
            path_y = [path_y, y];
            
            % Update agent position on plot
            subplot(2,2,1);
            plot(path_x, path_y, 'b-', 'LineWidth', 1);
            plot(x, y, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'cyan');
            drawnow;
            pause(0.01); % Small delay for animation
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

% Plot the results in remaining subplots
% Plot 1: Number of steps per episode
subplot(2,2,2);
plot(Results(:,1), Results(:,2), 'b-');
title('Steps per Episode');
xlabel('Episode');
ylabel('Number of Steps');
grid on;

% Plot 2: Epsilon decay
subplot(2,2,3);
plot(Results(:,1), Results(:,3), 'r-');
title('Epsilon Decay');
xlabel('Episode');
ylabel('Epsilon Value');
grid on;

% Plot 3: Moving average of steps
subplot(2,2,4);
window = 50; % Window size for moving average
movingAvg = movmean(Results(:,2), window);
plot(Results(:,1), movingAvg, 'g-');
title(['Moving Average of Steps (Window = ' num2str(window) ')']);
xlabel('Episode');
ylabel('Average Steps');
grid on;

sgtitle('Q-Learning Training Progress with Maze Animation');
