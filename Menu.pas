unit Menu;

interface

var
  nameLength: integer;
  nameEntered, startGame: boolean;
  records, rules: text;
  x0, y0: word;
  s, playerName: string;

procedure writeName(key: integer);
procedure win();
procedure recordTable();
procedure info();
procedure menuField(x, y, mousebutton: integer);
procedure drawMenuField();
implementation

Uses GraphABC, Game;
//запись имени
procedure writeName(key: integer);
begin
  case key of 
    VK_Enter:
      begin
        if nameLength > 0 then
        begin
          TextOut(200, 70, playerName);
          nameEntered := true;
        end;
      end;
    VK_Back:
      begin
        if nameLength > 0 then
        begin
          SetBrushColor(clWhite);
          FillRectangle(200, 70, 1000, 90);
          delete(playerName, nameLength, 1);
          TextOut(200, 70, playerName);
          nameLength := nameLength - 1;
        end;
      end;
    48..57, 65..90, 97..122:
      begin
        nameLength := nameLength + 1;
        playerName := playerName + chr(key);
        TextOut(200, 70, playerName);
      end;
  end;
end;
//победа в игре
procedure win;
begin
  SetWindowWidth(400);
  SetWindowHeight(300);
  clearwindow;
  SetFontStyle(FsBoldItalic);
  DrawTextCentered(200, 30, 'Вы победили!');
  SetFontStyle(FsNormal);
  TextOut(30, 50, 'Количество набранных очков:');
  TextOut(250, 50, score);
  TextOut(30, 70, 'Введите своё имя:');
  playerName := '';
  nameLength := 0;
  repeat
    OnKeyDown := writeName;
  until nameEntered;
  assign(records, 'records.txt');
  append(records);
  writeln(records, playerName, ' - ', score);
  close(records);
  halt;
end;
//таблица рекордов
procedure recordTable;
begin
  SetWindowWidth(500);
  SetWindowHeight(300);
  clearwindow;
  DrawTextCentered(250, 10, 'Таблица рекордов');
  assign(records, 'records.txt');
  reset(records);
  repeat
    readln(records, s);
    TextOut(x0+40, y0, s);
    y0 := y0 + 15;
    sleep(1500);
  until Eof(records);
  close(records);
  sleep(1500);
  halt;
end;
//правила
procedure info;
begin
  SetWindowWidth(550);
  SetWindowHeight(300);
  clearwindow;
  DrawTextCentered(275, 7, 'Правила');
  assign(rules, 'rules.txt');
  reset(rules);
  repeat
    readln(rules, s);
    TextOut(x0+40, y0, s);
    y0 := y0 + 15;
    sleep(1500);
  until Eof(rules);
  close(rules);
  sleep(1500);
  halt;
end;
  //гланое меню
procedure menuField(x, y, mousebutton: integer);
begin
  if mousebutton = 1 then
  begin
    if (x > 130) and (x < 270) and (y > 50) and (y < 70) then 
    begin
      startGame:=true;
      exit;
    end;
    if (x > 130) and (x < 270) and (y > 85) and (y < 105) then 
    begin
      recordTable;
    end;
    if (x > 130) and (x < 270) and (y > 120) and (y < 140) then 
    begin
      info;
    end;
    if (x > 130) and (x < 270) and (y > 155) and (y < 175) then 
    begin
      halt;
    end;
  end;
end;
  //прорисовка главного меню
procedure drawMenuField;
var
  l: integer;
begin
  clearwindow;
  SetWindowWidth(400);
  SetWindowHeight(300);
  SetFontStyle(FsBoldItalic);
  DrawTextCentered(200, 30, 'Морской бой');
  SetFontStyle(FsNormal);
  DrawTextCentered(200, 60, 'Новая игра');
  DrawTextCentered(200, 95, 'Таблица рекордов');
  DrawTextCentered(200, 130, 'Справка');
  DrawTextCentered(200, 165, 'Выход');
  for l := 0 to 3 do
  begin
    line(130,  50 + l * 35, 270,  50 + l * 35);
    line(130,  70 + l * 35, 270,  70 + l * 35);
    line(130,  50 + l * 35, 130,  70 + l * 35);
    line(270,  50 + l * 35, 270,  70 + l * 35);
  end;
  SetFontStyle(FsItalic);
  DrawTextCentered(300, 280, 'Автор: Александр Зимин');
  SetFontStyle(FsNormal);
  while (startGame = false) do 
  begin
    OnMouseDown := menuField;
  end;
end;
end.