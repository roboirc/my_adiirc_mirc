;--------------------------------------------------------------------------
; roboirc's AdiIRC/mIRC script
;
; Comments use ;
;--------------------------------------------------------------------------
; Aliases
; Must put alias word before all aliases else they will not run!
;--------------------------------------------------------------------------

alias makeList {

  %parameter1 = $1
  echo -sg The search directory is $+ $chr(32) %parameter1

  %parameter2 = $2
  echo -sg The search criteria is $+ $chr(32) %parameter2
    
  /set %list
  %totalcount =  $findfile(%parameter1, %parameter2, 0, %list = $addtok(%list, $1-, 10))
  echo -sg The total count is $+ $chr(32) $+ %totalcount
  
  ; Create empty text file with search results and info in name
  %filename = $me $+ .txt
  
  ; Writing search results to text file
  ; $crlf or $chr(10) do the same thing
  write -c %filename
  write %filename $me $+ $chr(32) $+ Total count of files is: $+ $chr(32) $+ %totalcount $crlf
  write %filename $crlf  
  write %filename %list

}

;--------------------------------------------------------------------------
; Code will distinguish between AdiIRC or mIRC by path and exe name
; Use version with ~ to supress any warnings
; Use $~version to compare between mirc/adiirc/etc
; If client is AdiIRC or mIRC
; Note: ~adiircexe will not generate a warning if the identifier doesn't exist
;--------------------------------------------------------------------------

alias Client_Id {

  if ($~adiircexe) { 
    return 0,4 Your IRC Client is AdIRC and version is $+ $chr(32) $version  
  }
  else { 
    return 0,4 Your IRC Client is mIRC and version is $+ $chr(32) $version  
  }

}

;--------------------------------------------------------------------------
; Dialog made using Dialog Studio
;--------------------------------------------------------------------------
; Important: The first number after the dialog component 
; represents the ID of the component
;--------------------------------------------------------------------------

dialog main {
  title "[---- roboirc's Script----]"
  size -1 -1 286 131
  option dbu
  check "Announcer On", 1, 8 8 50 10
  text "Announcer Text: ", 2, 8 24 51 9
  edit "", 3, 64 24 209 90, multi
}

;--------------------------------------------------------------------------
; On Dialog Events
;--------------------------------------------------------------------------
; $dname is name of the dialog 
; $devent is name of the event
; $did is id of the control 
; Please refer to the dialog code for each components ID

; Below has been commented out

/* 
on *:DIALOG:main:active:* {

  echo -sg [---- roboirc Main Dialog----] was opened

}

; Only listens if the checkbox id "1" was single clicked
on *:DIALOG:main:sclick:1 {

  ;echo -sg Dialog identifier is $+ $chr(32) $did $+ $chr(32) State is $+ $chr(32) $did($dname,1).state
  /var %state = $did($dname,1).state
  echo -sg %state
  if (%state == 1) { %FTP = On }
  elseif (%state == 0) { %FTP = Off }
  echo -sg %FTP

}

; Event is triggered when text is edited in 3
on *:DIALOG:main:edit:3 {

  echo -sg A change occurred in Edit Box $+ $chr(32) $did
  echo -sg Editbox contents are $+ $chr(32) $did($dname,3).text
}

*/

;--------------------------------------------------------------------------
; Events
;--------------------------------------------------------------------------
; CTCP reply event units updated to seconds from milliseconds
on ^*:ctcpreply:ping *:{
if($2) {
var %ping = $calc(($ticks - $2) / 1000) Seconds
echo -ag 0,22 Ping for $nick is 0,4 %ping    
}
}

;--------------------------------------------------------------------------
; Once the script is loaded
;--------------------------------------------------------------------------

on *:LOAD:{

  ; Will echo the irc client info in status window

  /echo -sg 0,12  ----------------------------------------------------------------------------------------------------------------------------------------------------
  /echo -sg 0,4    Loading Script . . .  $+ $chr(32) $Client_Id                                                                                                                       
  /echo -sg 0,12  ----------------------------------------------------------------------------------------------------------------------------------------------------
  /echo -sg 0,12  Date is: $+ $date                                                                                                                                                             
  /echo -sg 0,12  $asctime(dddd:hh:nn:ss:tt)                                                                                                                                             
  

  ; /var is local, /set is global
  /echo -sg 0,12  ----------------------------------------------------------------------------------------------------------------------------------------------------
  /echo -sg 0,4 Loading Global Variables . . .
  /echo -sg 0,12  ----------------------------------------------------------------------------------------------------------------------------------------------------
  
  ; Initializing all global variables to 0
  /set %test1 0
  /set %test2 0
  /set %test3 0
  /set %FTP Off
  /set %Announcer Off
  /set %ipaddress 0
  /set %username 0
  /set %password 0 
  /set %port 0
  /set %comments 0
  /set %period 0
  /set %total 0
  /set %announcement 0
  
  ;Setting home directory of file storage for searching
  /set %filedir c:\

  /echo -sg 0,12  ----------------------------------------------------------------------------------------------------------------------------------------------------
  /echo -sg 0,4 roboirc's script has been loaded . . .
  /echo -sg 0,12  ----------------------------------------------------------------------------------------------------------------------------------------------------
  
  ;Gets a variable via edit box
  ;//var %variable $input(label,e) | echo -a %variable

  ;Gets a y/n answer
  ;//var %variable $input(label,yn) | echo -a %variable

  ;Simple for loop to display numbers
  ;//var %i 1 | while (%i isnum 1-10) { echo -a %i | inc %i }

  echo -sg 0,12 FTP is $chr(32) $+ %FTP  
  echo -sg 0,12 Announcer is $chr(32) $+ %Announcer  
  echo -sg 0,12 Home Directory for searching is: $chr(32) $+ %filedir  

}



;--------------------------------------------------------------------------
; Upon connection to any network
;--------------------------------------------------------------------------

on 1:CONNECT: {
  echo -ag 0,12 You are currently connected to 0,4 $network with nick $me 

}

;--------------------------------------------------------------------------
; Searching engine
;--------------------------------------------------------------------------

alias find {

  ; This means display everything from 2nd word onwards
  ;%search_string = $1-
  
  ; Starting the search
  ; $findfile(dir,wildcard,N,depth,@window | command)
  ; 10 means new line character

  %empty_list = ""
  %totalcount = $findfile(%homedir, %search_string, 0, $addtok(%empty_list, $1-, 10))
  
  ; Create empty text file with search results and info in name
  ;%filename = $nick $+ $chr(95) $+ $asctime(hh $+ $chr(95) $+ nn $+ $chr(95) $+ ss $+ $chr(95) $+ tt) $+ .txt

  

}

alias setupFind {

}

;--------------------------------------------------------------------------
; Trigger! from any channel's window
;--------------------------------------------------------------------------
; !roboirc trigger and other parameters (& * symbols)

on *:TEXT:!roboirc *:#: {

  echo -a The file item requested is $+ $Chr(32) $2-

}

;--------------------------------------------------------------------------
; Trigger! from any channel's window
;--------------------------------------------------------------------------
; Only !list trigger

;on *:TEXT:!list:#:{

;  msg $nick Thanks for testing list. !list reply is ...

;}


;--------------------------------------------------------------------------
; CTCP event for SiteInfo trigger
;--------------------------------------------------------------------------

; Event is only replied if the user is in the channel
ctcp 1:SiteInfo:*:{

  ; Checks how many channels are common with nick
  ; If atleast one channel is common with nickname then send user FTP info
  ; $comchan(nick,0) returns total number of common channels

  if ($comchan($nick,0) >= 1) {   
    /echo -s $nick sent you a SiteInfo. Common Channels with $nick is $chr(32) $+ $comchan($nick,0)
    /msg $nick FTP Info is...
  }

  ; Another way to check if nickname is in channel list token
  ;/echo -s Serving Channel is $chr(32) $+ %ServingChannel
  ; Checks if nick is in the channel or not. If yes, then send FTP Info

  ;if ($nick ison %ServingChannel) {
  ;}

}

;--------------------------------------------------------------------------
; Once script is unloaded
;--------------------------------------------------------------------------

on *:UNLOAD:{

  /echo -sg 0,12 Unloading all variables 
  /unsetall

  /echo -sg 0,12  ---------------------------------------------------------------------------------------------------------------------------------------------------- 
  /echo -sg 0,4 roboirc's script has been unloaded!  
  /echo -sg 0,12  ---------------------------------------------------------------------------------------------------------------------------------------------------- 
  
  }

;--------------------------------------------------------------------------
; Pinger
;--------------------------------------------------------------------------

on 1:PING: {

  ;echo -sg $fulldate $+ $chr(32) $+ $chr(124) $+ $chr(32) You are being pinged by the server!
  
}

;This ads an extra option to the channel right click menu that makes announcement
; every x seconds
; Random code
; Using piping to combine multiple commands

;//set %x 60 | timer 1 %x echo -a this is a % $+ x seconds interval timer


;--------------------------------------------------------------------------
; Menu Scripts
;--------------------------------------------------------------------------
;Add the items to the channel menu
menu channel {

  -----{ $network }-----: {


  }
  -
;--------------------------------------------------------------------------

   
  ; Say in current channel
  ;--------------------------------------------------------------------------
  
  Say in $chan: {

    /say $$?="Enter message: "


  }

  AdiIRC or mIRC ?: {
    echo $Client_Id
  }

  ;FTP Info Announcer
  FTP Ad
  .Start FTP Ad {

    ;Ask the user and set variables
    set %ipaddress $input(Enter ip:, e)
    set %username $input(Enter username:, e)
    set %password $input(Enter password:, e)
    set %port $input(Enter port:, e)
    set %comments $input(Enter extra comments:,e)
    set %period $input(Enter period between FTP advertisements in seconds:, e)

    ;total string name created using string concatenation
    set %total [FTP Online]=> [IP Address: $+ %ipaddress $+ ] $+ $chr(32) $+ [username: $+ %username $+ ] $+ $chr(32) [password: $+ %password $+ ] $+ $chr(32) [port: $+ %port $+ ] $+ $chr(32) [comments: %comments $+ ]

    ;Echo the inputs to the user
    /echo %total

    ;Include timestamp here
    /echo -a  $chr(35) - FTP Timer Started in channel $chan - $chr(35)

    ;/timer[N/name] [-cdeomhipr] [time] <repetitions> <interval> <command>
    ; $chr(95) is underscore _ and $chr(35) is #
    /timerFTP $+ $chr(95) $+ $chan 0 %period /msg $chan %total

  }

  .Stop FTP Ad {


    /echo -a  $chr(35) - FTP Timer Stopped in channel $chan - $chr(35)

    ;Turn timer off
    /timerFTP $+ $chr(95) $+ $chan off

  }

  ;Channel Announcer is the menu item's name
  Channel Announcer
  .Start Announcer:  {

    ; Length in seconds for announcer via edit box
    ; Input from user is taken
    set %time $?="Please enter period between announcements in seconds"

    ; Create a timer that combines name of channel and Announce for length %time
    ; $$? asks for mandatory user input

    set %announcement $input("Enter announcement: ", e)
    /timerAnnounce $+ $chr(95) $+ $chan 0 %time /msg $chan %announcement

    ; Include timestamp here
    /echo -a  $chr(35) - Announcer Timer Started in channel $chan - $chr(35)

    ; Echo the variable input to the status window
    /echo -a Period between announcements on $chan is %time seconds

    %Announcer = On
  }

  .Stop Announcer: {

    /timerAnnounce $+ $chr(95) $+ $chan off

    ;Include timestamp here
    /echo -a  $chr(35) - Announcer Timer Stopped in channel $chan - $chr(35)

    ;Turn off announcer
    %Announcer = Off
  }


  Run Alias Timer: {

    ; Asks user for both period of timer and name of alias in code 
    ;$$ means mandatory

    /timerAlias 0 $$?="Enter period for timer:" $$?="Enter name of alias"
  }

  Stop Alias Timer: {
    /timerAlias off
  }

  Ping Current Every one in Channel: {
    /echo -ag 0,4 Pinging every one in current channel
    /ping $chan

    
  }

  Leave $chan: {  
  part $chan }
  
  Clone scanner: {
  cscan $chan
  }
  
 
  .Advertise Script: {
   /say 0,4 [I am using roboirc's script]    
  }
  
}


;--------------------------------------------------------------------------
;Adding information to right click query (private message)
;--------------------------------------------------------------------------

menu query {

  .Advertise Script: {
   /say 0,4 [I am using roboirc's script]    
  }

}

;----------------------------------------------------------------------------------
; Adding information to command menu bar on top of mirc/adiirc
;----------------------------------------------------------------------------------

menu menubar {

  ;Will display the roboirc dialog
  [----roboirc Script----]: { dialog -m main main }
  $network: { }

  ;/ison memoserv
  Check memos: {

    /echo -a Checking memos...
    /msg memoserv list
  } 

  Set file home directory and create list: {
      
      %filedir = $input(Current directory is $+ $chr(32) %filedir, e, Please enter your home directory for files)
      %file = $input(Search string (eg *.*), e, Please enter search string)
      makeList %filedir %file

  }
  
  ; Loads server names from official servers.ini format file
  Load info from servers.ini into a variable: {
  
  set %total_servers 166
  set %count 0
  set %servers
  
  while (%count <= %total_servers) {
  
  set %line $readini("D:\Work\servers.ini", servers, n $+ %count)
  tokenize 32 $replace($replace($replace(%line, SERVER:,  $chr(32)), GROUP:, $chr(32)), $chr(58), $chr(32)) | %servers = $addtok(%servers, $3, 32)
 
  ;writeini servers.ini, servers, n $+ %count, $replace($readini("D:\Work\servers.ini", servers, n $+ %count), SERVER:, $chr(32))
    
  inc %count
  
  }

  %servers = $replace(%servers, server, $chr(32))
  echo -ag %servers

  
  }

  
}

alias invite_alias {

;echo -a invite_alias
;echo -a %numnicks
;echo -a %nicks
;echo -a Destination channel is: $+ $chr(32) $+ %destchan

var %counter = 1

; Space is important between all commands and rest of text otherwise 
; it treats it as a custom alias not built in command

while (%counter <= %numnicks) {

    ; Note cannot use 0 in $gettok
    ;invite $gettok(%nicks, %counter, 44) %destchan
    
    ;noop $regex($1-,\b(\d+)\b) 
    ;echo  -ag $calc(1+ $regml(1))
    ;| timer 1 $calc(1+ $regml(1))  invite $gettok(%nicks, %counter, 44) %destchan
   
    
    timer 1 %invite_delay invite $gettok(%nicks, %counter, 44) %destchan
    inc %counter
    
    }
    
}

; This raw event checks for server messages when doing mass invites
raw 707:*message dropped*:{

;echo -ag 12,0  Server Notice: Message is:  $1- 
echo -ag 12,0 Server says to wait: $11 seconds 
%invite_delay = $11
dec %counter

}

alias delayby {

  if ($$1) { timerdelay 1 $$1 } 
}

alias onesecdelay {

var %ticks = $ticks
while (($ticks-%ticks)<10000) {
                                echo -ag 12,0 $calc($ticks-%ticks)
}

}



menu nicklist {

Invite selected to: {

set %numnicks $numtok($snicks, 44)
set %destchan $input(Enter destination channel, ev, Destination Channel)
set %nicks $snicks

; Set initial value that will be automatically adjusted
; Time is in seconds
set %invite_delay $input(Enter invite delay in seconds, ev, Invite Delay Time)

; Calling the alias
invite_alias

}

  Check if on other networks as you: {
  
  echo -a This script will check all your online networks for the selected nicks
  ;/scon -a /whois $nick

  var %counter = 1
  var %total = $numtok(%servers, 32)
  ;echo The list of servers is: $chr(32) $+ %servers

  while (%counter <= %total) {

    ; This command opens a new server window for each server
    ;server -m $gettok(%servers, %counter, 32)
    echo $gettok(%servers, %counter, 32)
    inc %counter
  }

  ; This command runs the command on all connected servers. Great for mass commands / checking
  scon -at1 whois $nick

  }
  
}




; Custom scripts downloaded from internet
;-- Basic clone scanner
;-- by SplitFire
;-- Usage: /cscan <#channel(Optional)>
;===============================================================

alias cscan {
  
  if (!$1) && ($active !ischan) { echo $color(ctcp) -ai2 * /cscan: insufficient parameters | halt }
  var %x 1, %clones, %sets 0, %c $iif($1,$1,#)
  if (%c !ischan) || (%scanchan) halt 
  if (!$chan(%c).ial) { set -u10 %scanchan %c | who %c | halt }
  
  ;%c is channel name
  echo -ag $crlf
  echo -ag 0,4 Clone Scanner Results for $chan is: 
  echo -ag $crlf
  
   
  while ($nick(%c,%x)) {
    if ($ialchan($address($nick(%c,%x),2),%c,0) > 1) && (!$istok(%clones,$address($nick(%c,%x),2),32)) {
      inc %sets
      var %clones %clones $address($nick(%c,%x),2)
      echo -ag Set (12 $+ %sets $+ ) - 0,4Host $+ $chr(58) $+ $chr(32) 4,0 $address($nick(%c,%x),2), 0,4Nicks $+ $chr(58)  12,0 $chr(32) $lclones($address($nick(%c,%x),2),%c)
      
         }
    inc %x
  }
  if (%sets == 0) echo $color(ctcp) -ai2 * /cscan: No clones found in %c
  else { 
    
    echo -ag $crlf
    echo -ag 0,4 Scan complete.  
  }
}

alias lclones {
  ; $1 = address / $2 = chan
  var %h 1, %m
  while ($ialchan($1,$2,%h)) {
    %m = %m $ialchan($1,$2,%h).nick $chr(44)
    inc %h
  }
  return $iif(%m,%m,None)
}

raw 315:*: {
  haltdef
  if (%scanchan == $2) { unset %scanchan | cscan $2 }
}

;===============================================================
