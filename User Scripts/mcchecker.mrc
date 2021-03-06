; mcchecker.mrc v1.1
; With help from Coyote` and hxck
; irc.geekshed.net #Script-Help

menu nicklist {
  Has Minecraft Premium?:mccheck $$1
}
alias mccheck {
  if ($sock(mcchecker)) sockclose mcchecker
  sockopen -e mcchecker minecraft.net 443
  sockmark mcchecker $1
}
on *:SOCKOPEN:mcchecker:{
  if ($sockerr) { echo -a Socket error: $sock($sockname).wsmsg }
  var %s sockwrite -n $sockname
  %s GET /haspaid.jsp?user= $+ $sock($sockname).mark HTTP/1.1
  %s Host: $sock($sockname).addr
  %s Connection: close
  %s
}
on *:SOCKREAD:mcchecker:{
  if ($sockerr) { echo -a Socket error: $sock($sockname).wsmsg }
  var %mctemp
  sockread %mctemp
  if (Content-Length: isin %mctemp) {
    if ($gettok(%mctemp,2,32) == 4) { echo -a $sock($sockname).mark is a Minecraft Premium user. }
    elseif ($gettok(%mctemp,2,32) == 5) { echo -a $sock($sockname).mark is not a Minecraft Premium user. }
    else { echo -a Error determining Minecraft Premium status for $sock($sockname).mark $+ . }
    sockclose $sockname
  }
}
