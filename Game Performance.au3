#include <ScreenCapture.au3>
#include <file.au3>
#RequireAdmin
;avoid the program be run more times
$version = 'test'
If WinExists($version) Then
   MsgBox(64,'Info','The programe has been running.'&@CRLF&' Please close the APP before Run again.'&@CRLF&'Will Exit within 3 senonds.',3)
   Exit 0
EndIf
AutoItWinSetTitle($version)
Sleep(1000)
Global $ex = False
;delete old Log
If FileExists('My log.log') Then
   FileDelete('My log.log')
EndIf

Func openSteam()
   $steam = IniRead(@ScriptDir&'\config.ini','path','steam','Not Found')
   Opt('WinTitleMatchMode',3)
   Global $pid = 0
    _FileWriteLog(@ScriptDir&'\My log.log','Open Steam APP.')
   If Not WinExists('Steam') Then
	  If $steam <> 'Not Found' Then
		 $pid = Run($steam)
		 Sleep(2000)
		 If WinExists('Steam') Then
			$st = WinGetPos('Steam')
			MouseMove($st[0]+168,$st[1]+333)
			Sleep(2000)
			MouseClick('left',$st[0]+168,$st[1]+333)
		 EndIf
	  Else
		 MsgBox(16,'Error','Can not find the steam path from config file. Please check it.')
	  EndIf
	  ;Run('C:\Users\1\Desktop\rise\Steam.exe')
	  $i=0
	  While Not WinExists('Steam 登录') Or Not WinExists('Steam Login')
		 If WinExists('Steam 服务出错') Then
			;$steam_x = WinGetPos('Steam 服务出错')
			$steam_xy = WinGetPos('Steam 服务出错')
			MouseClick('left',$steam_xy[0]+202,$steam_xy[1]+106)
			;ControlClick('Steam 服务出错','','vguiPopupWindow','left',1,202,106)
			ExitLoop
		 EndIf
		 If $i >15 Or WinExists('Steam 登录') Or WinExists('Steam Login') Then ExitLoop
		 Sleep(1000)
		 $i+=1
	  WEnd
	  Sleep(2000)
	  login()
   Else
	  WinSetState('Steam','',@SW_RESTORE)
	  $pid = ProcessExists('Steam.exe')
	  ConsoleWrite('pid: '&$pid&@CR)
	  $ex = True
   EndIf

EndFunc

Func login()
   ;ConsoleWrite('Login: '&@CR)
   ;WinActivate('Steam 登录')
   ;WinWaitActive('Steam 登录')

   ;ConsoleWrite('a')
   ;$win_login = WinGetPos('Steam 登录')
   Opt('WinTitleMatchMode',3)
   Global $user = IniRead(@ScriptDir&'\config.ini','login','user','cleve_zhang')
   $pwd = IniRead(@ScriptDir&'\config.ini','login','password','compal@123')
   $i=0
   While Not WinActive('Steam 登录') Or Not WinActive('Steam Login')
	  If WinExists('Steam 登录') Then
		 WinActivate('Steam 登录')
		 ExitLoop
	  ElseIf WinExists('Steam Login') Then
		 WinActivate('Steam Login')
		 ExitLoop
	  EndIf
	  Sleep(1000)
   WEnd
   If WinExists('Steam 登录') Then
	  $win_login = WinGetPos('Steam 登录')
   ElseIf WinExists('Steam Login') Then
	  $win_login = WinGetPos('Steam Login')
   EndIf
   _FileWriteLog(@ScriptDir&'\My log.log','Login Steam.')
   MouseClick('left',$win_login[0]+130,$win_login[1]+100,2);input username
   Sleep(1000)
   Send('{BS}')
   Sleep(1000)
   Send($user)
   Sleep(2000)
   MouseClick('left',$win_login[0]+130,$win_login[1]+130,2);input password
   Send('{BS}')
   Sleep(1000)
   Send($pwd)
   Sleep(2000)
   Send('{enter}')

EndFunc

Func closeNews()
   Opt('WinTitleMatchMode',1)
   If WinExists('Steam - News') Then
	  WinClose('Steam - News')
   EndIf
   If WinExists('Steam - 新闻') Then
	  WinClose('Steam - 新闻')
   EndIf

EndFunc

Func selectLib()

   WinActivate('Steam')
   WinWaitActive('Steam')
   _FileWriteLog(@ScriptDir&'\My log.log','Select Library from Steam Menu.')
   Opt('WinTitleMatchMode',3)
   $win_main = WinGetPos('Steam')
   BlockInput(1)
   If $ex Then
	  Sleep(1500)
	  If @DesktopHeight = 864 Then
		 $x_lib = $win_main[0]+210
		 $y_lib = $win_main[1]+53
	  Else
		 $x_lib = $win_main[0]+210
		 $y_lib = $win_main[1]+53
	  EndIf
	  MouseMove($x_lib,$y_lib)
	  Sleep(2000)
	  MouseClick('left',$x_lib,$y_lib,2)  ;library location
	  Sleep(2000)
   Else
	  Sleep(5000)
	  While 1
		 closeNews()
		 Sleep(2000)
		 Opt('WinTitleMatchMode',3)
		 If WinExists('好友列表') Then
			WinSetState('好友列表','',@SW_MINIMIZE)
		 ElseIf WinExists('Friends List') Then
			WinSetState('Friends List','',@SW_MINIMIZE)
		 EndIf
		 $st_main = picReg(cap('Steam'))
		 If StringInStr($st_main,'zhangbei') Or StringInStr($st_main,'lib') Then
			;ConsoleWrite('2: '&WinExists('Intermediate D3D Window1'))
			Sleep(6000)
			closeNews()
			While Not WinActive('Steam')
			   WinActivate('Steam')
			WEnd
			Sleep(1500)
			$win_main = WinGetPos('Steam')
			If @DesktopHeight = 864 Then
			   $x_lib = $win_main[0] + 210
			   $y_lib = $win_main[1]+53
			Else
			   $x_lib = $win_main[0]+210
			   $y_lib = $win_main[1]+53
			EndIf

			Sleep(2000)
			MouseMove($x_lib,$y_lib)
			Sleep(5000)
			While WinExists('Friends List') Or WinExists('好友列表')
			   If WinExists('好友列表') Then
				  WinSetState('好友列表','',@SW_MINIMIZE)
				  WinClose('好友列表')
			   ElseIf WinExists('Friends List') Then
				  WinSetState('Friends List','',@SW_MINIMIZE)
				  WinClose('Friends List')
			   EndIf
			   ExitLoop
			WEnd
			MouseClick('left',$x_lib,$y_lib,2)  ;library
			BlockInput(0)
			Sleep(2000)
			ExitLoop
		 EndIf

	  WEnd
   EndIf
EndFunc

Func openGame()
   Opt('WinTitleMatchMode',3)
   $win_main = WinGetPos('Steam')
   _FileWriteLog(@ScriptDir&'\My log.log','Search test game.')
   MouseMove($win_main[0]+41,$win_main[1]+86)
   Sleep(2000)
   MouseClick('left',$win_main[0]+41,$win_main[1]+86)  ;search location
   Sleep(2000)
   ;$game = IniRead(@ScriptDir&'\config.ini','game','name1','not found')
   $cycle = IniRead(@ScriptDir&'\config.ini','cycle','cycle',2)
   $game = IniReadSection(@ScriptDir&'\config.ini','game')
   If @error Then
	  MsgBox(16,'Error','Cannot found game. Please check the File(config.ini) ',3)
	  Exit 0
   Else
	  For $cy=1 To $cycle
		 _FileWriteLog(@ScriptDir&'\My log.log','Current Run Cycle: '&$cy)
		 For $i = 1 To $game[0][0]
		 Switch $game[$i][1]
		 Case 'Rise of the Tomb Raider'
			   Global $list_q[3] = ['Very High','High','Medium']
			   For $j = 0 To UBound($list_q)-1
				  Opt('WinTitleMatchMode',3)
				  WinSetState('Steam','',@SW_RESTORE)
				  Sleep(3000)
				  Send($game[$i][1]&'{ENTER}')
				  Sleep(3000)
				  WinSetState('Steam','',@SW_MINIMIZE)
				  Sleep(3000)
				  ;While WinExists()
				  ;runTomb($list_q[$j])
				  While 1
					 If WinExists('Rise of the Tomb Raider') Then
						TombSetting($list_q[$j])
						ExitLoop
					 EndIf
					 Sleep(1000)
					 _FileWriteLog(@ScriptDir&'\My log.log','Waitting Game appear.')
				  WEnd
				  ;ConsoleWrite($list_q[$j]&@CR)
				  _FileWriteLog(@ScriptDir&'\My log.log','launch the game: '&$game[$i][1])
				  statusOfTomb($list_q[$j])
				  ;runJudge($list_q[$j])
			   Next

			Case 'Middle-earth: Shadow of War Demo'
			   Opt('WinTitleMatchMode',3)
			   WinSetState('Steam','',@SW_RESTORE)
			   Sleep(3000)
			   Send('Shadow of War'&'{ENTER}')
			   Sleep(3000)
			   WinSetState('Steam','',@SW_MINIMIZE)
			   Global $list[3] = ['Ultra','Very High','High']
			   _FileWriteLog(@ScriptDir&'\My log.log','Launch the game: '&$game[$i][1])
			   For $j = 0 To UBound($list)-1
				  runShadow($list[$j])
			   Next
		 Case Else
			MsgBox(0,'info','Error')
		 EndSwitch
		 Next
	  Next
   EndIf
  ; Sleep(2000)
   ;Send($game[2][1]&'{enter}')
   ;Sleep(2000)



EndFunc

Func runTomb($quality)

   Opt('WinTitleMatchMode',3)
   Sleep(2000)
   WinActivate('Rise of the Tomb Raider')
   WinWaitActive('Rise of the Tomb Raider')
   ;WinActivate('Rise of the Tomb Raider')
   $game_raider = WinGetPos('Rise of the Tomb Raider')
   MouseMove($game_raider[0]+735,$game_raider[1]+98)
   _FileWriteLog(@ScriptDir&'\My log.log','gameing setting.')
   MouseClick('left',$game_raider[0]+735,$game_raider[1]+98)  ;game option item location
   Opt('WinTitleMatchMode',1)
   Sleep(2000)
   WinWaitActive('Rise of the Tomb Raider：安装程序')

   If Not ControlCommand('Rise of the Tomb Raider：','启用 DirectX 12','Button5','IsChecked','') Then
	  ControlCommand('Rise of the Tomb Raider：','启用 DirectX 12','Button5','Check','')
	  Sleep(3000)
	  Send('{enter}')
   EndIf
   Sleep(1000)
   ControlCommand('Rise of the Tomb Raider：','','ComboBox5','SetCurrentSelection','0')
   Sleep(1000)

   ControlCommand('Rise of the Tomb Raider：','启用 DirectX 12','SysTabControl321','TabRight','')
   Sleep(1000)
   $sel = ControlCommand('Rise of the Tomb Raider：','','ComboBox7','GetCurrentSelection','')
   If $sel <> $quality Then
	  If $quality ='非常高' Or $quality='Very High' Then
		 $pos_opt = WinGetPos('Rise of the Tomb Raider：安装程序')
		 ControlCommand('Rise of the Tomb Raider：','','ComboBox7','ShowDropDown','')
		 Sleep(2000)
		 Opt("MouseCoordMode",2)
		 MouseClick('left',$pos_opt[0]+266,$pos_opt[1]+202)
		 Sleep(1000)
		 While 1
			If WinExists('','4GB') Then
			   ControlClick('','OK','Button1')
			   ExitLoop
			EndIf
			Sleep(1000)
		 WEnd
		 Sleep(2000)
	  ElseIf $quality = '高' Then
		 ControlCommand('Rise of the Tomb Raider：','','ComboBox7','SetCurrentSelection','3')
		 Sleep(2000)
	  ElseIf $quality = '中' Or $quality = 'Medium' Then
		 ControlCommand('Rise of the Tomb Raider：','','ComboBox7','SetCurrentSelection','2')
		 Sleep(2000)

	  EndIf
   EndIf
   Sleep(2000)
   ;ConsoleWrite('game running!'&@CR)
   Send('{ENTER}')
   MouseMove($game_raider[0]+735,$game_raider[1]+73)
   Sleep(1000)
   MouseClick('left',$game_raider[0]+735,$game_raider[1]+73)  ;start game item location
   ConsoleWrite('running'&@CR)

EndFunc

Func TombSetting($quality)
   _FileWriteLog(@ScriptDir&'\My log.log','Game Setting.')
   Opt('WinTitleMatchMode',3)
   Sleep(2000)
   WinActivate('Rise of the Tomb Raider')
   WinWaitActive('Rise of the Tomb Raider')
   ;WinActivate('Rise of the Tomb Raider')
   $game_raider = WinGetPos('Rise of the Tomb Raider')
   MouseMove($game_raider[0]+735,$game_raider[1]+98)
   _FileWriteLog(@ScriptDir&'\My log.log','gameing setting.')
   MouseClick('left',$game_raider[0]+735,$game_raider[1]+98)  ;game option item location
   Opt('WinTitleMatchMode',1)
   Sleep(2000)
   WinWaitActive('Rise of the Tomb Raider - Setup')

   If Not ControlCommand('Rise of the Tomb Raider - Setup','Enable DirectX 12','Button5','IsChecked','') Then
	  ControlCommand('Rise of the Tomb Raider - Setup','Enable DirectX 12','Button5','Check','')
	  Sleep(3000)
	  Send('{enter}')
   EndIf
   Sleep(1000)
   ControlCommand('Rise of the Tomb Raider - Setup','','ComboBox5','SetCurrentSelection','0')
   Sleep(1000)

   ControlCommand('Rise of the Tomb Raider - Setup','Enable DirectX 12','SysTabControl321','TabRight','')
   Sleep(1000)
   $sel = ControlCommand('Rise of the Tomb Raider - Setup','','ComboBox7','GetCurrentSelection','')
   If $sel <> $quality Then
	  If $quality='Very High' Then
		 $pos_opt = WinGetPos('Rise of the Tomb Raider - Setup')
		 ;ControlCommand('Rise of the Tomb Raider','','ComboBox7','ShowDropDown','')
		 ControlClick('Rise of the Tomb Raider - Setup','','ComboBox7')
		 Sleep(2000)
		 ;MouseClick('left',$pos_opt[0]+266,$pos_opt[1]+202)
		 MouseMove($pos_opt[0]+266,$pos_opt[1]+198)
		 Sleep(2000)
		 MouseClick('left',$pos_opt[0]+266,$pos_opt[1]+198)

		 Sleep(1000)
		 While 1
			If WinExists('','4GB') Then
			   ControlClick('','OK','Button1')
			   ExitLoop
			EndIf
			Sleep(1000)
		 WEnd
		 Sleep(2000)
	  ElseIf $quality='High' Then
		 ControlCommand('Rise of the Tomb Raider - Setup','','ComboBox7','SetCurrentSelection','3')
		 Sleep(2000)
	  ElseIf $quality = 'Medium' Then
		 ControlCommand('Rise of the Tomb Raider - Setup','','ComboBox7','SetCurrentSelection','2')
		 Sleep(2000)

	  EndIf
   EndIf
   Sleep(2000)
   ;ConsoleWrite('game running!'&@CR)
   Send('{ENTER}')
   MouseMove($game_raider[0]+735,$game_raider[1]+73)
   Sleep(1000)
   MouseClick('left',$game_raider[0]+735,$game_raider[1]+73)  ;start game item location
  ; ConsoleWrite('running'&@CR)

EndFunc

Func statusOfTomb($quality)
   Opt('WinTitleMatchMode',1)
   While 1
	  $pic = cap('Rise of the Tomb Raider',$quality)
	  $txt_game = picReg($pic)
	  If StringInStr($txt_game,'zhang') Or StringInStr($txt_game,'start') Then
		 _FileWriteLog(@ScriptDir&'\My log.log','will start run the gaming.')
		 ;FileCopy(@ScriptDir&'\Result.txt',@ScriptDir&'\Result_'&@HOUR&@MIN&@SEC&'.txt')
		 $game = WinGetPos('Rise of the Tomb Raider')
		 Sleep(2000)
		 If @DesktopHeight = 864 Then
			$x_st = $game[0]+242
			$y_st = $game[1]+435
		 Else
			$x_st = $game[0]+275
			$y_st = $game[1]+542
		 EndIf
		 BlockInput(1)
		 MouseMove($x_st,$y_st)
		 Sleep(4000)
		 WinActivate('Rise of the Tomb Raider')
		 _FileWriteLog(@ScriptDir&'\My log.log','starting the game.')
		 MouseClick('left',$x_st,$y_st,2)
		 Sleep(2000)
		 Send('{ENTER}')
		 While 1
			$txt_st = picReg(cap('Rise of the Tomb Raider',$quality))
			;FileWrite(@MON&@MDAY&'_'&@HOUR&@MIN&@SEC&'_start.txt',$txt_st)
			If StringInStr($txt_st,'start') Or StringInStr($txt_st,'quit') Or StringInStr($txt_st,'zhang') Then
			   WinActivate('Rise of the Tomb Raider')
			   MouseClick('left',$x_st,$y_st,2)
			   _FileWriteLog(@ScriptDir&'\My log.log','reclick to start run the gaming.')
			   Sleep(2000)
			   Send('{ENTER}')
			   Sleep(2000)
			Else
			   _FileWriteLog(@ScriptDir&'\My log.log','Gaming success running and exit the loop.')
			   ExitLoop
			EndIf
		 WEnd
		 #cs
		 While StringInStr(,'start') or StringInStr(picReg(cap('Rise of the Tomb Raider',$quality)),'zhang') Or
			WinActivate('Rise of the Tomb Raider')
			MouseClick('left',$x_st,$y_st,2)
			_FileWriteLog(@ScriptDir&'\My log.log','reclick to start run the gaming.')
			Sleep(2000)
			Send('{ENTER}')
		 WEnd
		 #ce
		 ;Send('{ENTER}')
		 Sleep(3000)
		 _FileWriteLog(@ScriptDir&'\My log.log','gaming running until score occurred.')
		 BlockInput(0)
		 While 1
			$txt = picReg(cap('Rise of the Tomb Raider',$quality))
			If StringInStr($txt,'score') Or StringInStr($txt,',min') Then
			   _FileWriteLog(@ScriptDir&'\My log.log','The gaming end and Capture the result.')
			   ;FileWrite(@MON&@MDAY&'_'&@HOUR&@MIN&@SEC&'_result.txt',$txt)
			   cap('Rise of the Tomb Raider',$quality)
			   Sleep(3000)
			   _FileWriteLog(@ScriptDir&'\My log.log','Result captured, will exit the gaming')
			   Sleep(1000)
			   While ProcessExists('ROTTR.exe')
				  _FileWriteLog(@ScriptDir&'\My log.log','Exiting gaming.')
				  ProcessClose('ROTTR.exe')
				  Sleep(2000)
			   WEnd
			   ExitLoop
			EndIf
			Sleep(2000)
		 WEnd
		 ExitLoop
	  EndIf
	  Sleep(2000)
   WEnd
EndFunc

Func statusJudge($status,$quality)
   Opt('WinTitleMatchMode',1)
   while 1
	  $game = WinGetPos('Rise of the Tomb Raider')
	  ;ConsoleWrite($txt)
	  If $status = 'start' Then
		 _FileWriteLog(@ScriptDir&'\My log.log','start run the gaming.')
		 $txt = picReg(cap('Rise of the Tomb Raider'))
		 If StringInStr($txt,'Raider') Or StringInStr($txt,'zhangbeijing') Then
			Sleep(2000)
			MouseMove($game[0]+275,$game[1]+542)
			Sleep(4000)
			MouseClick('left',$game[0]+275,$game[1]+542,2)
			Sleep(5000)
			Return 'start'
			ExitLoop
		 EndIf
	  ElseIf $status = 'end' Then
		 ;ConsoleWrite('end:---'&@CR)
		 _FileWriteLog(@ScriptDir&'\My log.log','End the gaming.')
		 $txt = picReg(cap('Rise of the Tomb Raider',$quality))
		 If StringInStr($txt,'max') or StringInStr($txt,'min') Then
			cap('Rise of the Tomb Raider',$quality&'_')
			Sleep(3000)
			MouseMove($game[0]+783,$game[1]+594)
			Sleep(5000)
			MouseClick('left',$game[0]+783,$game[1]+594,2)
			Sleep(5000)
			While StringInStr(picReg(cap('Rise of the Tomb Raider')),'FPS') Or StringInStr(picReg(cap('Rise of the Tomb Raider')),'max')
			   MouseClick('left',$game[0]+783,$game[1]+594,2)
			   Sleep(1000)
			WEnd
			;
			While ProcessExists('ROTTR.exe')
			   ProcessClose('ROTTR.exe')
			WEnd
			Return 'end'
			ExitLoop
		 EndIf

	#cs
	  ElseIf $status = 'exit' Then
		 $txt = picReg(cap('Rise of the Tomb Raider'))
		 If StringInStr($txt,'Raider') Or StringInStr($txt,'zhangbeijing') Then
			Sleep(4000)
			#cs
			MouseMove($game[0]+250,$game[1]+447)
			Sleep(3000)
			MouseClick('left',$game[0]+250,$game[1]+447,2)
			#ce
			;use winclose to replace MouseClick to exit game
			While Not WinClose('Rise of the Tomb Raider')
			   WinClose('Rise of the Tomb Raider')
			WEnd
			Sleep(5000)
			MouseMove($game[0]+780,$game[1]+596)
			Sleep(3000)
			MouseClick('left',$game[0]+780,$game[1]+596,2)
			Sleep(2000)
			ConsoleWrite('exit'&@CR)
			While WinExists('Rise of the Tomb Raider')
			   MouseClick('left',$game[0]+780,$game[1]+596,2)
			   Sleep(2000)
			WEnd
			Return 'exit'
			ExitLoop
		 EndIf
	  #ce
	  EndIf
	  Sleep(1000)
   WEnd


EndFunc

Func runJudge($quality)
   Opt('WinTitleMatchMode',1)

   While 1

	  $txt_game = picReg(cap('Rise of the Tomb Raider',$quality))
	  If StringInStr($txt_game,'Raider') Or StringInStr($txt_game,'zhangbeijing') Then
		 _FileWriteLog(@ScriptDir&'\My log.log','start run the gaming.')
		 $game = WinGetPos('Rise of the Tomb Raider')
		 Sleep(2000)
		 MouseMove($game[0]+275,$game[1]+542)
		 Sleep(4000)
		 MouseClick('left',$game[0]+275,$game[1]+542,2)
		 Sleep(5000)
		 While 1
			$txt = picReg(cap('Rise of the Tomb Raider',$quality))
			If StringInStr($txt,'FPS') Or StringInStr($txt,'max') Or StringInStr($txt,',min') Then
			   _FileWriteLog(@ScriptDir&'\My log.log','The gaming end and Capture the result.')
			   cap('Rise of the Tomb Raider',$quality)
			   Sleep(2000)
			   MouseMove($game[0]+783,$game[1]+594)
			   Sleep(3000)
			   MouseClick('left',$game[0]+783,$game[1]+594,2)
			   Sleep(5000)
			   _FileWriteLog(@ScriptDir&'\My log.log','Result captured, will exit the gaming')
			   Sleep(1000)
			   While ProcessExists('ROTTR.exe')
				  _FileWriteLog(@ScriptDir&'\My log.log','Exiting gaming.')
				  ProcessClose('ROTTR.exe')
				  Sleep(2000)
			   WEnd
			   ExitLoop
			EndIf
			Sleep(2000)
		 WEnd
		 ExitLoop
	  EndIf
	  Sleep(2000)
   WEnd
EndFunc

Func picReg($pic,$delete=True)
   If FileExists(@ScriptDir&'\Result.txt') Then
	  FileDelete(@ScriptDir&'\Result.txt')
   EndIf
   $ResultTextPath = @ScriptDir & "\Result"
   $OutPutPath = $ResultTextPath & ".txt"
   $TesseractExePath = @ScriptDir&'\tesseract.exe'
   ;ShellExecuteWait($TesseractExePath, $name & ' '&$ResultTextPath, "", "", @SW_HIDE)
   ShellExecuteWait($TesseractExePath, '"' & $pic & '" "' & $ResultTextPath & '"', "", "", @SW_HIDE)
   If FileExists(@ScriptDir&'\Result.txt') Then
	  $txt = FileRead(@ScriptDir&'\Result.txt')
	  If $delete Then
		 FileDelete($pic)
		 FileDelete($OutPutPath)
	  EndIf
	  Return $txt
   Else
	  Return Null
   EndIf

EndFunc

Func cap($title,$quality='')

   If Not FileExists(@ScriptDir&'\Result') Then
	  DirCreate(@ScriptDir&'\Result')
   EndIf
   $name = @ScriptDir&'\Result\'&@MON&@MDAY&'_'&@HOUR&@MIN&@SEC&'_'&$quality&'.bmp'
   $handle_st = WinGetHandle($title)
   ;ConsoleWrite('1: '&WinExists('Intermediate D3D Window1'))
   _ScreenCapture_CaptureWnd($name,$handle_st)
   Return $name
EndFunc

Func runShadow($quality)
   ;openGame()
   ;open game and wait enter to main

   If $quality = 'Ultra' Then
	  WinWaitActive('[CLASS:Shadow of War Demo]')
	  Sleep(5000)
	  $i=0
	  While 1
		 $i+=1
		 $txt_sh = picReg(cap('[CLASS:Shadow of War Demo]'))
		 If StringInStr($txt_sh,'spacebar') Then
			;ConsoleWrite('esc'&@CR
			If StringInStr($txt_sh,'play') Or StringInStr($txt_sh,'Game') Then
			   Send('{ESC}')
			   ;ConsoleWrite($txt_sh&@CR)
			Else
			   Send('{SPACE}')
			EndIf
		 EndIf
		 If StringInStr($txt_sh,'start') Then
			Sleep(3000)
			_FileWriteLog(@ScriptDir&'\My log.log','Close steam community.')
			;Send('+{TAB}')
			Sleep(2000)
			ExitLoop
		 EndIf
		 Sleep(1000)
		; If $i > 12 Then
		;	Send('{SPACE}')
		 ;EndIf
		 ;ConsoleWrite($txt_sh&@CR)
	  WEnd
   EndIf
   ;locate to Option menu and click option menu
   _FileWriteLog(@ScriptDir&'\My log.log','Locate to Option item.')
   ;Opt('MouseCoordMode',2)
   $pos_sh = WinGetPos('[CLASS:Shadow of War Demo]')
   If @DesktopHeight = 864 Then
	  _FileWriteLog(@ScriptDir&'\My log.log','4K panel.')
	  MouseMove($pos_sh[0]+72,$pos_sh[1]+136)
	  Sleep(3000)
	  MouseClick('left',$pos_sh[0]+72,$pos_sh[1]+136,2)
	  Sleep(3000)
	  ;_FileWriteLog(@ScriptDir&'\My log.log','Locate to Advance Item.')
	  ;locate Advance menu in option menu
	  _FileWriteLog(@ScriptDir&'\My log.log','Locate to Advanced item.')
	  MouseMove($pos_sh[0]+204,$pos_sh[1]+104)
	  Sleep(3000)
   Else
	  MouseMove($pos_sh[0]+160,$pos_sh[1]+170)
	  Sleep(3000)
	  MouseClick('left',$pos_sh[0]+160,$pos_sh[1]+170,2)
	  Sleep(3000)
	  ;locate Advance menu in option menu
	  _FileWriteLog(@ScriptDir&'\My log.log','Locate to Advanced item.')
	  MouseMove($pos_sh[0]+255,$pos_sh[1]+130)
	  Sleep(3000)
   EndIf
   ;locate to Graphical Quality menu
   _FileWriteLog(@ScriptDir&'\My log.log','Locate to Graphical Quality item.')
   If @DesktopHeight = 864 Then
	  $x= $pos_sh[0]+90
	  $y = $pos_sh[1]+282
   Else
	  $x= $pos_sh[0]+127
	  $y = $pos_sh[1]+353
   EndIf
   MouseMove($x,$y)
   Sleep(2000)
   MouseClick('left',$x,$y)
   Sleep(2000)
   ;select graphical Quality
   If $quality = 'Ultra' Then
	  _FileWriteLog(@ScriptDir&'\My log.log','Setting Gaming Graphical Quality: '&$quality)
	  If @DesktopHeight = 864 Then
		 $x = $pos_sh[0]+ 180
		 $y = $pos_sh[1]+ 462
	  Else
		 $x = $pos_sh[0]+193
		 $y = $pos_sh[1]+579
	  EndIf
   ElseIf $quality = 'Very High' Then
	  _FileWriteLog(@ScriptDir&'\My log.log','Setting Gaming Graphical Quality: '&$quality)
	  If @DesktopHeight = 864 Then
		 $x = $pos_sh[0]+ 120
		 $y = $pos_sh[1]+ 438
	  Else
		 $x = $pos_sh[0]+193
		 $y = $pos_sh[1]+549
	  EndIf
   ElseIf $quality = 'High' Then
	  _FileWriteLog(@ScriptDir&'\My log.log','Setting Gaming Graphical Quality: '&$quality)
	  If @DesktopHeight = 864 Then
		 $x = $pos_sh[0]+ 100
		 $y = $pos_sh[1]+ 411
	  Else
		 $x = $pos_sh[0]+200
		 $y = $pos_sh[1]+520
	  EndIf
   EndIf
   MouseMove($x,$y)
   Sleep(2000)
   MouseClick('left',$x,$y)
   Sleep(2000)
   ;apply the setting

   ;ConsoleWrite($txt_setting)
   $i=0
   While 1
	  $txt_setting = picReg(cap('[CLASS:Shadow of War Demo]'))
	  If StringInStr($txt_setting,'Apply') Or StringInStr($txt_setting,'App') Then
		 ;use shortkey to replace MouseClick
		 ;MouseMove($pos_sh[0]+368,$pos_sh[1]+977)
		 ;Sleep(2000)
		 ;MouseClick('left',$pos_sh[0]+368,$pos_sh[1]+977)
		 ;Sleep(3000)
		 ;MouseMove($pos_sh[0]+870,$pos_sh[1]+583)
		 ;Sleep(2000)
		 ;MouseClick('left',$pos_sh[0]+870,$pos_sh[1]+583,2)
		 Send('2')
		 Sleep(3000)
		 Send('{SPACE}')
		 Sleep(5000)
		 _FileWriteLog(@ScriptDir&'\My log.log','Apply the Graphical Setting.')
		 while 1
			_FileWriteLog(@ScriptDir&'\My log.log','Apply button No action, Retry click to apply again.')
			$txt = picReg(cap('[CLASS:Shadow of War Demo]'))
			If StringInStr($txt,'apply') Or StringInStr($txt,'Yes') Or StringInStr($txt,'may') Then
			   ;MouseClick('left',$pos_sh[0]+870,$pos_sh[1]+583)
			   Send('2')
			   Send('{SPACE}')
			   Sleep(2000)
			ElseIf StringInStr($txt,'start') Then
			   _FileWriteLog(@ScriptDir&'\My log.log','Has been finished the setting.')
			   ;_FileWriteLog(@ScriptDir&'\My log.log',$txt)
			   ExitLoop
			EndIf
			Sleep(2000)
		 WEnd
		 ExitLoop
	  EndIf
	  If $i >5 Then
		 _FileWriteLog(@ScriptDir&'\My log.log','Confirm ' &$i&' times,current setting can meet requirement.')
		 Sleep(1500)
		 WinActivate('[CLASS:Shadow of War Demo]')
		 Send('{ESC}')
		 Sleep(3000)
		 ExitLoop
	  EndIf
	  $i+=1
	  Sleep(1000)
   WEnd
   ;run benchmark
   While 1
	  $txt = picReg(cap('[CLASS:Shadow of War Demo]'))
	  If StringInStr($txt,'start') Or StringInStr($txt,'run') Then
		 _FileWriteLog(@ScriptDir&'\My log.log','Gaming seting done,Return to Main Menu.')
		 If @DesktopHeight = 864 Then
			$x = $pos_sh[0]+94
			$y = $pos_sh[0]+180
		 Else
			$x = $pos_sh[0]+150
			$y = $pos_sh[0]+224
		 EndIf
		 _FileWriteLog(@ScriptDir&'\My log.log','Run Benchmark.')
		 MouseMove($x,$y)
		 Sleep(2000)
		 MouseClick('left',$x,$y)
		 Sleep(3000)
		 ExitLoop
	  EndIf
	  Sleep(1000)
   WEnd
   ;test until comeout result
   ;EndIf ;FHD
   While 1
	  $txt_res = picReg(cap('[CLASS:Shadow of War Demo]',$quality))
	  If StringInStr($txt_res,'Log File') Or StringInStr($txt_res,'Log') Then
		 _FileWriteLog(@ScriptDir&'\My log.log','Gaming End.')
		 cap('[CLASS:Shadow of War Demo]',$quality)
		 Sleep(2000)
		 ExitLoop
	  EndIf
	  Sleep(2000)
	  ;ConsoleWrite($txt_res&@CR)
   WEnd
   ;back to main menu
   While 1
	  _FileWriteLog(@ScriptDir&'\My log.log','Gaming end Fail,retry to Return to Main Menu to run next cycle.')
	  Send('{SPACE}')
	  Sleep(3000)
	  $txt_res = picReg(cap('[CLASS:Shadow of War Demo]',$quality))
	  If StringInStr($txt_res,'start') Or StringInStr($txt_res,'run') Then ExitLoop
	  ;Sleep(1000)
   WEnd

   ;test finished and exit the game
   If $quality = 'High' Then
	  #cs
	  MouseMove($pos_sh[0]+138,$pos_sh[1]+282)
	  Sleep(3000)
	  MouseClick('left',$pos_sh[0]+138,$pos_sh[1]+282)
	  Sleep(5000)
	  Send('{SPACE}')
	  Sleep(2000)
	  #ce
	  If ProcessExists('ShadowOfWar.exe') Then
		 _FileWriteLog(@ScriptDir&'\My log.log','Close the gaming.')
		 ProcessClose('ShadowOfWar.exe')
		 Sleep(2000)
	  EndIf
   EndIf
   ;ConsoleWrite('cycle end!'&@CR)
EndFunc

Func main()
   TrayTip('Information','Programe is Running',4,1)
   WinMinimizeAll()
   Sleep(3000)
   openSteam()
   ;login()
   Sleep(2000)
   closeNews()
   selectLib()
   openGame()
   Sleep(3000)
   ProcessClose($pid)
   If Not WinExists('Steam') Then
	  MsgBox(64,'Test status: finished.','The test has been finished')
   EndIf

   ;Exit 0

EndFunc

main()

