From: "Fabiano Reis" <silos.reis@ig.com.br>
Subject: differences between win and unix tcp clients.
Date: Tue, 16 Mar 2004 09:12:01 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <024b01c40b4f$e3341620$3f32a8c0@ds.ig.com.br>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0248_01C40B36.BDCE7420"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0248_01C40B36.BDCE7420
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi list,

I was doing tests with iptables on redhat 7.3 , iptables version 1.2.5 =
and I observed that windows tcp client (telnet) doesn=B4t answer in the =
same time that unix tcp client (telnet) is doing.

(This test is so simple to do)

For example: I have a telnet daemon listening on port 23 of a Redhat 7.3 =
(192.168.0.1) and two more machines that will work as client of this =
daemon on this example. One of them Windows 2000 (192.168.0.2) and the =
another Solaris 2.6 (192.168.0.3). I have my lan connection OK, so the =
clients can achieve the server using a telnet client normally.

To start the test I added a rule to block the connections that came from =
the two clients I have.

iptables -A INPUT -p tcp --source 192.168.0.2 --dport 23 -j REJECT
iptables -A INPUT -p tcp --source 192.168.0.3 --dport 23 -j REJECT

On the client side I do a "telnet 192.168.0.1" and what I got:

On the Solaris machine: a very fast response that the connection was =
refused.

On the Windows 2000 machine: after for about 20 seconds I got the =
message that the connect failed (I thing this is the same as connection =
refused).

Doing another test on the Windows2000 machine. That time I used telnet =
to connect on a port that doesn=B4t exists on my RedHat server.=20

c:> telnet 192.168.0.1 30
Connecting To 192.168.0.1...Could not open a connection to host on port =
30: Connect failed

This is the same error I got when I use the port that is blocked with =
"reject" by iptables on server side, BUT the difference is that I get =
the error after 1 or 2 seconds after executing the command.

Conclusion: I think this was because the Windows implementation of TCP =
detects something different on this connection, maybe it detects in some =
way that there is a filter on the server side and this is why the time =
for the error message take so long to appear.

Am I right? Is there a workaround for this problem? I need to make =
windows think that the server is really "down" and that is why i=B4m =
writting to you people.

I will appreciate any help.

Thanks in advance,

Fabiano
------=_NextPart_000_0248_01C40B36.BDCE7420
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1226" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hi list,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I was doing tests with iptables on =
redhat 7.3 ,=20
iptables version 1.2.5 and I observed that windows tcp client (telnet) =
doesn=B4t=20
answer in the same time that unix tcp client (telnet) is =
doing.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>(This test is so simple to =
do)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>For example: I have a telnet daemon =
listening on=20
port 23 of a Redhat 7.3 (192.168.0.1) and two more machines that will =
work as=20
client of this daemon on this example. One of them Windows 2000 =
(192.168.0.2)=20
and the another Solaris 2.6 (192.168.0.3). I have my lan connection OK, =
so the=20
clients can achieve the server using a telnet client =
normally.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>To start the test I added a rule to =
block the=20
connections that came from the two clients I have.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>iptables -A INPUT -p tcp --source =
192.168.0.2=20
--dport&nbsp;23 -j REJECT</FONT></DIV>
<DIV>
<DIV><FONT face=3DArial size=3D2>iptables -A INPUT -p tcp --source =
192.168.0.3=20
--dport&nbsp;23 -j REJECT</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>On the client side I do a "telnet =
192.168.0.1" and=20
what I got:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>On the Solaris machine: a very fast =
response that=20
the connection was refused.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>On the Windows 2000 machine: =
after&nbsp;for=20
about&nbsp;20 seconds I got the message that the connect failed (I thing =
this is=20
the same as connection refused).</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Doing another test on the Windows2000 =
machine. That=20
time I used telnet to connect on a port that doesn=B4t exists on my =
RedHat server.=20
</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>c:&gt; telnet 192.168.0.1 =
30</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Connecting To 192.168.0.1...Could not =
open a=20
connection to host on port 30: Connect failed</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>This is the same error I got when I use =
the port=20
that is blocked with "reject" by iptables on server side, BUT the =
difference is=20
that I get the error after 1 or 2 seconds after executing the=20
command.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Conclusion: <FONT face=3DArial =
size=3D2>I think this=20
was because the Windows implementation of TCP detects something =
different on=20
this connection, maybe it detects in some way that there is a filter on =
the=20
server side and this is why&nbsp;the time for the error message take so =
long to=20
appear.</FONT></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Am I right? Is there a workaround for =
this problem?=20
I need to make windows think that the server is really "down" and that =
is why=20
i=B4m writting to you people.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I will appreciate any =
help.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Thanks in advance,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial =
size=3D2>Fabiano</FONT></DIV></DIV></BODY></HTML>

------=_NextPart_000_0248_01C40B36.BDCE7420--
