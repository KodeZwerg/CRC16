unit uCRC16;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Function CalcCRC16(const Buffer: array of byte; inCRC16: Word) : Word;
const
  Mask: Word = $A001;
var
  N, I: Integer;
  B: Byte;
begin
  for I := Low(Buffer) to High(Buffer) do
  begin
    B := Buffer[I];
    inCRC16 := inCRC16 xor B;
    for N := 1 to 8 do
     if (inCRC16 and 1) > 0 then
      inCRC16 := (inCRC16 shr 1) xor Mask
     else
      inCRC16 := (inCRC16 shr 1);
  end;
  Result := inCRC16;
end;

function FileCRC16(const FileName: string; var CRC16: Word; StartPos: Int64 = 0;
  Len: Int64 = 0): Boolean;
const
  csBuff_Size = 4096;
type
  TBuff = array[0..csBuff_Size - 1] of Byte;
var
  Handle: THandle;
  ReadCount: Integer;
  Size: Int64;
  Count: Int64;
  Buff: TBuff;
begin
  //CRC16 := Word($0000);
  Handle := CreateFile(PChar(FileName), GENERIC_READ,
    FILE_SHARE_READ, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  Result := Handle <> INVALID_HANDLE_VALUE;
  if Result then
  try
    Int64Rec(Size).Lo := GetFileSize(Handle, @Int64Rec(Size).Hi);
    if Size < StartPos + Len then
    begin
      Result := False;
      Exit;
    end;
    if Len > 0 then
      Count := Len
    else
      Count := Size - StartPos;
    CRC16 := not CRC16;
    SetFilePointer(Handle, Int64Rec(StartPos).Lo, @Int64Rec(StartPos).Hi, FILE_BEGIN);
    while Count > 0 do
    begin
      if Count > SizeOf(Buff) then
        ReadCount := SizeOf(Buff)
      else
        ReadCount := Count;
      ReadFile(Handle, Buff, ReadCount, LongWord(ReadCount), nil);
      CRC16 := CalcCRC16(Buff, CRC16);
      Dec(Count, ReadCount);
    end;
    CRC16 := not CRC16;
  finally
    CloseHandle(Handle);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  CRC16: Word;
begin
  CRC16 := Word($0000);
  if OpenDialog1.Execute then
   begin
    if FileCRC16(OpenDialog1.FileName, CRC16) then
    LabeledEdit2.Text := (IntToHex(CRC16, 4));
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  buff: packed array of byte;
  i: Integer;
begin
  LabeledEdit2.Text := ('0000');
  if Length(LabeledEdit1.Text) > 0 then
  case RadioGroup1.ItemIndex of
   0: begin // String nach CRC16, bei non-visual Strings könnte man theoretisch alles als Eingabe übermitteln, auch Binär Daten
            // (Beispiel: 020D000A413068656C6C6F sollte A3DA ergeben)
            // Diese Methode wandelt jedes Zeichen in seinen Hex-Wert (00-FF) um
       SetLength(buff, Length(LabeledEdit1.Text));
       for i := 0 to (Length(LabeledEdit1.Text))-1 do buff[i] := Byte(Ord(LabeledEdit1.Text[i+1]));
      end;
   1: begin // Hex-String-Kette nach CRC16
            // (Beispiel: 020D000A413068656C6C6F sollte FD9C ergeben)
            // Diese Methode verlangt fließende Hex-Werte (00-FF), wie im Beispiel
       SetLength(buff, Length(LabeledEdit1.Text) div 2);
       for i := 0 to (Length(LabeledEdit1.Text) div 2)-1 do
        try
         buff[i] := Byte(StrToInt('$'+LabeledEdit1.Text[i*2+1]+LabeledEdit1.Text[i*2+2]));
        except
         buff[i] := Byte(Ord(LabeledEdit1.Text[i+1])); // Diese Zeile erzwingt eine "Zeichen-CRC16" kalkulation bei Fehlerhaften Hex-Werten, gilt nur für's erste Zeichen vom Paar
         // Beispiel Eingabe = 0A3x, das 0A paar wird korrekt übermittelt, aus 3x wird eine umgewandelte Hex 3 und das x wird ignoriert
         // Beispiel Eingabe = 0Ax3, das 0A paar wird korrekt übermittelt, aus x3 wird ein umgewandeltes Hex x und die 3 wird ignoriert
         // Wenn hinter defekten Paar wieder gute folgen werden die auch korrekt eingebunden
         // Alternativ an dieser Stelle abbrechen und den buff Nullen
         // Alternativ anstelle eines Zeichen-CRC16, einfach eine 0 übermitteln, also "buff[i] := Byte(0);"
         // Alternativ das fehlerhafte Paar zerlegen und Prüfen was ausserhalb von 0-9/A-F liegt und Nullen
         // Alternativ vom except auf ein finally wechseln und mit Fehlermeldungen leben
        end;
      end;
  end; // case
  if Length(LabeledEdit1.Text) > 0 then
  LabeledEdit2.Text := (IntToHex(CalcCRC16(buff, Word($0000)), 4));
end;


end.
