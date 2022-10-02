program Battleship;

Uses Menu in 'Menu.pas';
Uses Game in 'Game.pas';
Uses GraphABC;
//начало игры
begin
  drawMenuField;
  if startGame then 
  begin;
    score := 30;
    enemyShips := 10;
    alliedShips := 10;
    drawPlayField;
    playerSetShips;
    enemySetShips;
    enemyShips := 10;
    alliedcells := 20;
    while (enemyShips > 0) and (alliedcells > 0) do
    begin
      playerShot := 1;
      enemyShot := 1;
      drawAlliedField;
      //ходы
      TextOut(30, 200, 'Нажмите на клетку вражеского поля, чтобы выстрелить по ней');
      while playerShot = 1 do
      begin
        OnMouseDown := playerTurn;
      end;
      if enemyShips = 0 then break;
      while enemyShot = 1 do
      begin
        enemyTurn;
      end;
    end;
    if enemyShips = 0 then win
    else if alliedcells = 0 then
    begin
      clearwindow;
      TextOut(30, 100, 'Поражение');
      sleep(2000);
      halt;
    end;
  end;
end.