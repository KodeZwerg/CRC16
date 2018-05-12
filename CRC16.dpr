program CRC16;

uses
  Vcl.Forms,
  uCRC16 in 'uCRC16.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
