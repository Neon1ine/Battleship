unit Game;
interface
var
  shipLength, alliedShips, enemyShips, shotResult, score, alliedcells, playerShot, enemyShot, n, a, b, c, d, ex, ey, et: integer;
  horizontPosition: boolean;
  AField: array [1..10, 1..10] of integer;
  EField: array [1..10, 1..10] of integer;

procedure drawPlayField();
procedure drawAlliedField();
procedure drawEnemyField();
procedure rotateShip(key: integer);
procedure setShip(x, y, mousebutton: integer);
procedure playerSetShips();
procedure enemyShipSet(shipX, shipY, enemyShipPositon: integer);
procedure enemySetShips();
procedure enemyTurn();
procedure playerTurn(x, y, mousebutton: integer);
implementation
Uses GraphABC, Menu;
    //прорисовка игрового поля
procedure drawPlayField;
var
  i1, j1, i2, j2, j3: integer;
begin
  SetBrushColor(clwhite);
  clearwindow;
  SetWindowWidth(600);
  SetWindowHeight(450);
  TextOut(83, 0, 'Ваше поле');
  for i1 := 1 to 11 do
  begin
    line(40, i1 * 15 + 20, 190, i1 * 15 + 20);  
  end;
  for i1 := 1 to 11 do
  begin
    line(i1 * 15 + 25, 36, i1 * 15 + 25, 11 * 15 + 20);
  end;
  TextOut(277, 0, 'Поле противнка');
  SetBrushColor(clwhite);
  for j1 := 1 to 11 do
  begin
    line(250, j1 * 15 + 20, 400, j1 * 15 + 20);
  end;
  for j1 := 1 to 11 do
  begin
    line(j1 * 15 + 235, 36, j1 * 15 + 235, 11 * 15 + 20);
  end;
  for i2 := 0 to 1 do
  begin
    TextOut(44 + i2 * 209, 19, 'A');
    TextOut(59 + i2 * 209, 18, 'B');
    TextOut(74 + i2 * 209, 18, 'C');
    TextOut(89 + i2 * 209, 18, 'D');
    TextOut(104 + i2 * 209, 18, 'E');
    TextOut(120 + i2 * 209, 18, 'F');
    TextOut(133 + i2 * 209, 18, 'G');
    TextOut(149 + i2 * 209, 18, 'H');
    TextOut(167 + i2 * 209, 18, 'I');
    TextOut(179 + i2 * 209, 18, 'J');
  end;
  for j3 := 0 to 1 do
  begin
    for j2 := 1 to 9 do
    begin
      TextOut(30 + j3 * 209, 20 + 15 * j2, j2);
    end;  
    TextOut(25 + j3 * 209, 170, '10');
  end;
end;
//поле игрока в цвете
procedure drawAlliedField;
var
  a, b: integer;
begin
  for a := 1 to 10 do
  begin
    for b := 1 to 10 do  
    begin
      if AField[a, b] < 2 then SetBrushColor(clskyblue)
      else if (AField[a, b] div 10) = 2 then SetBrushColor(clsilver)
      else if AField[a, b] = 3 then SetBrushColor(clblue)
      else if AField[a, b] = 4 then SetBrushColor(clred);
      FillRectangle(a * 15 + 26, b * 15 + 21, a * 15 + 40, b * 15 + 35);
      SetBrushColor(clwhite);
    end;
  end;
end;
//поле противника в цвете
procedure drawEnemyField;
var
  a, b: integer;
begin
  for a := 1 to 10 do
  begin
    for b := 1 to 10 do  
    begin
      if EField[a, b] = 3 then SetBrushColor(clskyblue)
      else if EField[a, b] = 4 then SetBrushColor(clred);
      //корабли противника видны при игре(закомментировать)
      //if (EField[a, b] div 10) = 2 then SetBrushColor(clSilver); 
      FillRectangle(a * 15 + 236, b * 15 + 21, a * 15 + 250, b * 15 + 35);
      SetBrushColor(clwhite);
    end;
  end;
end;
//поворот корабля для установки игроком
procedure rotateShip(key: integer);
var
  e: integer;
begin
  case key of
    82:
      begin
        SetBrushColor(clwhite);
        FillRectangle(40, 220, 42 + shipLength * 15, 220 + shipLength * 15);
        if horizontPosition = true then
        begin
          horizontPosition := false;
          SetBrushColor(clsilver);
          FillRectangle(40, 220, 55, 220 + shipLength * 15);
          DrawRectangle(40, 220, 55, 220 + shipLength * 15);
          for e := 1 to (shipLength - 1) do
          begin
            line(40, 220 + 15 * e, 54, 220 + 15 * e);
          end;
          SetBrushColor(clwhite);
        end
        else 
        begin
          horizontPosition := true;
          SetBrushColor(clsilver);
          FillRectangle(40, 220, 40 + shipLength * 15, 235);
          DrawRectangle(40, 220, 40 + shipLength * 15, 235);
          for e := 1 to (shipLength - 1) do
          begin
            line(40 + e * 15, 220, 40 + e * 15, 234);
          end;
          SetBrushColor(clwhite);
        end;
      end;
  end;
end;
// процедура для установки кораблей игроком
procedure setShip(x, y, mousebutton: integer);
var
  shipX, shipY, c: integer;
begin
  if mousebutton = 1 then
  begin
    SetBrushColor(clwhite);
    FillRectangle(30, 310, 640, 330);
    shipX := (x - 40) div 15 + 1;
    shipY := (y - 35) div 15 + 1;
    // горизонтальное положение корабля
    if horizontPosition then
    begin
      //две проверки
      if (shipY < 1) or (shipY > 10) or (shipX < 1) or ((shipX + (shipLength - 1)) > 10) then
      begin
        SetFontColor(clred);
        TextOut(30, 310, 'Невозможно поставить корабль: корабль должен быть расположен на поле');
        SetFontColor(clblack);
        exit;
      end;
      for c := 0 to (shipLength - 1) do 
      begin
        if shipX + c > 10 then break;
        if AField[shipX + c, ShipY] <> 0 then
        begin
          SetFontColor(clred);
          TextOut(30, 310, 'Невозможно поставить корабль: недостаточно места');
          SetFontColor(clblack);
          exit;
        end;
      end;
      //установка корабля и воды вокруг него
      if shipX > 1 then 
      begin
        if (shipY > 1) then AField[shipX - 1, shipY - 1] := 1;
        AField[shipX - 1, shipY] := 1;
        if (shipY < 10) then AField[shipX - 1, shipY + 1] := 1;
      end;
      if (shipX + shipLength - 1 < 10) then 
      begin
        if (shipY > 1) then AField[shipX + shipLength, shipY - 1] := 1;
        AField[shipX + shipLength, shipY] := 1;
        if (shipY < 10) then AField[shipX + shipLength, shipY + 1] := 1;
      end;
      for c := 0 to (shipLength - 1) do 
      begin
        if shipLength = 4 then AField[shipX + c, ShipY] := 24;
        if shipLength = 3 then AField[shipX + c, ShipY] := 23;
        if shipLength = 2 then AField[shipX + c, ShipY] := 22;
        if shipLength = 1 then AField[shipX + c, ShipY] := 21;
        if (shipY > 1) then AField[shipX + c, shipY - 1] := 1;
        if (shipY < 10) then AField[shipX + c, shipY + 1] := 1;
      end;
    end;
    // вертикальное положение корабля
    if (horizontPosition = false) then
    begin
      //две проверки
      if (shipX < 1) or (shipX > 10) or (shipY < 1) or ((shipY + shipLength - 1) > 10) then
      begin
        SetFontColor(clred);
        TextOut(30, 310, 'Невозможно поставить корабль: корабль должен быть расположен на поле');
        SetFontColor(clblack);
        exit;
      end;
      for c := 0 to (shipLength - 1) do 
      begin
        if AField[shipX, shipY + c] <> 0 then
        begin
          SetFontColor(clred);
          TextOut(30, 310, 'Невозможно поставить корабль: недостаточно места');
          SetFontColor(clblack);
          exit;
        end;
      end;
      //установка корабля и воды вокруг него
      if shipY > 1 then 
      begin
        if (shipX > 1) then AField[shipX - 1, shipY - 1] := 1;
        AField[shipX, shipY - 1] := 1;
        if (shipX < 10) then AField[shipX + 1, shipY - 1] := 1;
      end;
      if (shipY + shipLength - 1 < 10) then 
      begin
        if (shipX > 1) then AField[shipX - 1, shipY + shipLength] := 1;
        AField[shipX, shipY + shipLength] := 1;
        if (shipX < 10) then AField[shipX + 1, shipY + shipLength] := 1;
      end;
      for c := 0 to (shipLength - 1) do 
      begin
        if shipLength = 4 then AField[shipX, ShipY + c] := 24;
        if shipLength = 3 then AField[shipX, ShipY + c] := 23;
        if shipLength = 2 then AField[shipX, ShipY + c] := 22;
        if shipLength = 1 then AField[shipX, ShipY] := 21;
        if (shipX > 1) then AField[shipX - 1, shipY + c] := 1;
        if (shipX < 10) then AField[shipX + 1, shipY + c] := 1;
      end;
    end;
    drawAlliedField;
    alliedShips := alliedShips - 1;
  end;
end;
//игрок ставит корабли
procedure playerSetShips;
begin
  SetBrushColor(clsilver);
  FillRectangle(40, 220, 100, 235);
  DrawRectangle(40, 220, 100, 235);
  line(55, 220, 55, 234);
  line(70, 220, 70, 234);
  line(85, 220, 85, 234);
  SetBrushColor(clwhite);
  horizontPosition := true;
  while alliedShips > 9 do  
  begin
    SetBrushColor(clwhite);
    TextOut(30, 200, 'Нажмите на клетку на своём поле, чтобы разместить авианосец (4-палубный корабль).');
    TextOut(30, 290, 'Если нужно, нажмите "R" для поворота корабля');
    shipLength := 4;
    OnKeyDown := rotateShip;
    OnMouseDown := setShip;
    sleep(100);
  end;
  horizontPosition := true;
  SetBrushColor(clwhite);
  FillRectangle(30, 200, 1000, 2000);
  SetBrushColor(clsilver);
  FillRectangle(40, 220, 85, 235);
  DrawRectangle(40, 220, 86, 235);
  line(55, 220, 55, 234);
  line(70, 220, 70, 234);
  SetBrushColor(clwhite);
  while alliedShips > 7 do
  begin
    TextOut(30, 200, 'Разместите 2 подводные лодки (3-палубный корабль)');
    TextOut(30, 290, 'Если нужно, нажмите "R" для поворота корабля');
    shipLength := 3;
    OnKeyDown := rotateShip;
    OnMouseDown := setShip;
    sleep(100);
  end;
  horizontPosition := true;
  SetBrushColor(clwhite);
  FillRectangle(30, 200, 1000, 2000);
  SetBrushColor(clsilver);
  FillRectangle(40, 220, 70, 235);
  DrawRectangle(40, 220, 71, 235);
  line(55, 220, 55, 234);
  SetBrushColor(clwhite);
  while alliedShips > 4 do
  begin
    TextOut(30, 200, 'Разместите 3 эсминца (2-палубный корабль)');
    TextOut(30, 290, 'Если нужно, нажмите "R" для поворота корабля');
    shipLength := 2;
    OnKeyDown := rotateShip;
    OnMouseDown := setShip;
    sleep(100);
  end;
  horizontPosition := true;
  SetBrushColor(clwhite);
  FillRectangle(30, 200, 1000, 2000);
  SetBrushColor(clsilver);
  FillRectangle(40, 220, 55, 235);
  DrawRectangle(40, 220, 56, 235);
  SetBrushColor(clwhite);
  while alliedShips > 0 do
  begin
    TextOut(30, 200, 'Разместите 4 катера (1-палубный корабль)');
    shipLength := 1;
    OnMouseDown := setShip;
    sleep(100);
  end;
  SetBrushColor(clwhite);
  FillRectangle(30, 200, 1000, 2000);
end;
// проверка кораблей противника
procedure enemyShipSet(shipX, shipY, enemyShipPositon: integer);
var
  f: integer;
begin
  //проверка
  for f := 0 to (shipLength - 1) do 
  begin
    if enemyShipPositon = 1 then
    begin
      if shipX + f > 10 then exit;
      if EField[shipX + f, shipY] <> 0 then exit;
    end
    else
    begin
      if shipY + f > 10 then exit;
      if EField[shipX, shipY + f] <> 0 then exit;
    end;
  end;
  if (enemyShipPositon = 1) and ((shipX + shipLength - 1) > 10) then exit;
  if (enemyShipPositon > 1) and ((shipY + shipLength - 1) > 10) then exit;
  if (EField[shipX, shipY]  > 1) or (EField[shipX, shipY] = 1) then exit;
  //установка вражеского корабля и воды вокруг него
  if enemyShipPositon = 1 then
  begin
    if shipX > 1 then 
    begin
      if (shipY > 1) then EField[shipX - 1, shipY - 1] := 1;
      EField[shipX - 1, shipY] := 1;
      if (shipY < 10) then EField[shipX - 1, shipY + 1] := 1;
    end;
    if (shipX + shipLength - 1 < 10) then 
    begin
      if (shipY > 1) then EField[shipX + shipLength, shipY - 1] := 1;
      EField[shipX + shipLength, shipY] := 1;
      if (shipY < 10) then EField[shipX + shipLength, shipY + 1] := 1;
    end;
    for f := 0 to (shipLength - 1) do 
    begin
      if shipLength = 4 then EField[shipX + f, ShipY] := 24;
      if shipLength = 3 then EField[shipX + f, ShipY] := 23;
      if shipLength = 2 then EField[shipX + f, ShipY] := 22;
      if shipLength = 1 then EField[shipX, ShipY] := 21;
      if (shipY > 1) then EField[shipX + f, shipY - 1] := 1;
      if (shipY < 10) then EField[shipX + f, shipY + 1] := 1;
    end;
    enemyShips := enemyShips - 1;
  end;
  if enemyShipPositon = 2 then
  begin
    if shipY > 1 then 
    begin
      if (shipX > 1) then EField[shipX - 1, shipY - 1] := 1;
      EField[shipX, shipY - 1] := 1;
      if (shipX < 10) then EField[shipX + 1, shipY - 1] := 1;
    end;
    if (shipY + shipLength - 1 < 10) then 
    begin
      if (shipX > 1) then EField[shipX - 1, shipY + shipLength] := 1;
      EField[shipX, shipY + shipLength] := 1;
      if (shipX < 10) then EField[shipX + 1, shipY + shipLength] := 1;
    end;
    for f := 0 to (shipLength - 1) do 
    begin
      if shipLength = 4 then EField[shipX, ShipY + f] := 24;
      if shipLength = 3 then EField[shipX, ShipY + f] := 23;
      if shipLength = 2 then EField[shipX, ShipY + f] := 22;
      if shipLength = 1 then EField[shipX, ShipY] := 21;
      if (shipX > 1) then EField[shipX - 1, shipY + f] := 1;
      if (shipX < 10) then EField[shipX + 1, shipY + f] := 1;
    end;
    enemyShips := enemyShips - 1;
  end;
end;
//компьютер ставит корабли
procedure enemySetShips;
begin
  while enemyShips > 9 do
  begin
    randomize;
    ex := random(10) + 1;
    ey := random(10) + 1;
    et := random(2) + 1;
    shipLength := 4;
    enemyShipSet(ex, ey, et);
  end;
  while enemyShips > 7 do
  begin
    ex := random(10) + 1;
    ey := random(10) + 1;
    et := random(2) + 1;
    shipLength := 3;
    enemyShipSet(ex, ey, et);
  end;
  while enemyShips > 4 do
  begin
    ex := random(10) + 1;
    ey := random(10) + 1;
    et := random(2) + 1;
    shipLength := 2;
    enemyShipSet(ex, ey, et);
  end;
  while enemyShips > 0 do
  begin
    ex := random(10) + 1;
    ey := random(10) + 1;
    et := random(2) + 1;
    shipLength := 1;
    enemyShipSet(ex, ey, et);
  end;
end;
//ход компьютера
procedure enemyTurn;
var
  r, a, b, shotX, shotY: integer;
begin
  r := random(100);
  if r < 10 then  
  begin
    for a := 1 to 10 do
    begin
      for b := 1 to 10 do  
      begin
        if (AField[a, b] div 10) = 2 then
        begin
          shotX := a;
          shotY := b;
        end;
      end;
    end;
  end
  else
  begin
    repeat
      shotX := random(10) + 1;
      shotY := random(10) + 1;
    until (AField[shotX, shotY] <> 4) and (AField[shotX, shotY] <> 3);
  end;
  if (AField[shotX, shotY] div 10) <> 2 then shotResult := -1;
  if (AField[shotX, shotY] div 10) = 2 then shotResult := 1;
  if shotResult = -1 then 
  begin
    AField[shotX, shotY] := 3;
    enemyShot := 0;
  end
   else 
  begin
    AField[shotX, shotY] := 4;
    alliedcells := alliedcells - 1;
    enemyShot := 1;
  end;
  drawAlliedField;
end;
//ход игрока
procedure playerTurn(x, y, mousebutton: integer);
var
  shotX, shotY: integer;
begin
  if mousebutton = 1 then 
  begin
    shotX := (x - 250) div 15 + 1;
    shotY := (y - 35) div 15 + 1;
    if (shotX < 1) or (shotX > 10) or (shotY < 1) or ((shotY + shipLength - 1) > 10) then
      //две проверки
    begin
      SetBrushColor(clWhite);
      SetFontColor(clred);
      TextOut(30, 265, 'Стрельба невозможна за пределами поля противника!');
      SetFontColor(clblack);
      exit;
    end; 
    if (EField[shotX, shotY] = 4) or (EField[shotX, shotY] = 3) then
    begin
      SetBrushColor(clWhite);
      SetFontColor(clred);
      TextOut(30, 265, 'Вы уже среляли по этой клетке!');
      SetFontColor(clblack);
      exit;
    end;
    //проверка попал или убил
    if (EField[shotX, shotY] div 10) <> 2 then shotResult := -1
    else
    begin
      shotResult := 0;
      if EField[shotX, shotY] = 21 then shotResult := 1;
      if EField[shotX, shotY] = 22 then 
      begin
        if (shotX < 10) and (EField[shotX + 1, shotY] = 4) then shotResult := 2;
        if (shotX > 1) and (EField[shotX - 1, shotY] = 4) then shotResult := 2;
        if (shotY < 10) and (EField[shotX, shotY + 1] = 4) then shotResult := 2;
        if (shotY > 1) and (EField[shotX, shotY - 1] = 4) then shotResult := 2;
      end;
      if EField[shotX, shotY] = 23 then
      begin
        if (shotX < 10) and (shotX > 1) and (EField[shotX + 1, shotY] = 4) and (EField[shotX - 1, shotY] = 4) then shotResult := 3;
        if (shotX < 9) and (EField[shotX + 1, shotY] = 4) and (EField[shotX + 2, shotY] = 4) then shotResult := 3;
        if (shotX > 2) and (EField[shotX - 2, shotY] = 4) and (EField[shotX - 1, shotY] = 4) then shotResult := 3;
        if (shotY < 9) and (EField[shotX, shotY + 1] = 4) and (EField[shotX, shotY + 2] = 4) then shotResult := 3;
        if (shotY < 10) and (shotY > 1) and (EField[shotX, shotY + 1] = 4) and (EField[shotX, shotY - 1] = 4) then shotResult := 3;
        if (shotY > 2) and (EField[shotX, shotY - 2] = 4) and (EField[shotX, shotY - 1] = 4) then shotResult := 3;
      end;
      if EField[shotX, shotY] = 24 then
      begin
        if (shotX < 10) and (EField[shotX + 1, shotY] = 4) then 
        begin
          if (shotX > 2) and (EField[shotX - 2, shotY] = 4) and (EField[shotX - 1, shotY] = 4) then shotResult := 4;
          if (shotX < 9) and (shotX > 1) and (EField[shotX - 1, shotY] = 4) and (EField[shotX + 2, shotY] = 4) then shotResult := 4;
          if (shotX < 8) and (EField[shotX + 2, shotY] = 4) and (EField[shotX + 3, shotY] = 4) then shotResult := 4;
        end;
        if (shotX > 1) and (EField[shotX - 1, shotY] = 4) then
        begin
          if (shotX > 3) and (EField[shotX - 3, shotY] = 4) and (EField[shotX - 2, shotY] = 4) then shotResult := 4;
          if (shotX > 2) and (shotX < 10) and (EField[shotX - 2, shotY] = 4) and (EField[shotX + 1, shotY] = 4) then shotResult := 4;
          if (shotX < 9) and (EField[shotX + 1, shotY] = 4) and (EField[shotX + 2, shotY] = 4) then shotResult := 4;
        end;
        if (shotY < 10) and (EField[shotX, shotY + 1] = 4) then 
        begin
          if (shotY > 2) and (EField[shotX, shotY - 2] = 4) and (EField[shotX, shotY - 1] = 4) then shotResult := 4;
          if (shotY < 9) and (shotY > 1) and (EField[shotX, shotY - 1] = 4) and (EField[shotX, shotY + 2] = 4) then shotResult := 4;
          if (shotY < 8) and (EField[shotX, shotY + 2] = 4) and (EField[shotX, shotY + 3] = 4) then shotResult := 4;
        end;
        if (shotY > 1) and (EField[shotX, shotY - 1] = 4) then
        begin
          if (shotY > 3) and (EField[shotX, shotY - 3] = 4) and (EField[shotX, shotY - 2] = 4) then shotResult := 4;
          if (shotY > 2) and (shotY < 10) and (EField[shotX, shotY - 2] = 4) and (EField[shotX, shotY + 1] = 4) then shotResult := 4;
          if (shotY < 9) and (EField[shotX, shotY + 1] = 4) and (EField[shotX, shotY + 2] = 4) then shotResult := 4;
        end;
      end;
    end;
    SetBrushColor(clwhite);
    FillRectangle(30, 220, 400, 280);
    playerShot := 1;
    if shotResult = -1 then
    begin
      TextOut(30, 220, 'Мимо!');
      score := score - 5;
      EField[shotX, shotY] := 3;
      playerShot := 0;
    end;
    if shotResult > 0 then 
    begin
      score := score + shotResult * 10 + 20;
      TextOut(30, 220, 'Убил! Вы можете сделать ещё выстрел.');
      enemyShips := enemyShips - 1;
      EField[shotX, shotY] := 4;
    end;
    if shotResult = 0 then 
    begin
      score := score + shotResult * 10 + 20;
      TextOut(30, 220, 'Попал! Вы можете сделать ещё выстрел.');
      EField[shotX, shotY] := 4;
    end;
    if (enemyShips = 0) then playerShot := 0;
    drawEnemyField;
    TextOut(30, 240, 'очки:');
    TextOut(65, 240, score);
  end;
end;
end.