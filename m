From: "Nikolai Dahlem" <listuser@epygi.de>
Subject: NAT changing src-port
Date: Mon, 1 Mar 2004 13:16:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <DAELKAPIKOFAFFKELNHOEEDBCAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0006_01C3FF8F.6CBDCC50"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

------=_NextPart_000_0006_01C3FF8F.6CBDCC50
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

I'm working on a pair of connection tracking / nat helper modules; when NAT
sees the first outgoing packet of the connection it changes the src port to
some free port (1024 in the example), but the remote side is responding to
the port listed in the packet payload (5022), thus the answer to the request
is not recognized. How can I get the port the new (changed) port from
netfilter, to change the payload accordingly in my NAT-helper ?

udp      17 25 src=172.30.8.100 dst=10.20.10.198 sport=5022 dport=5014
[UNREPLIED] src=10.20.10.198 dst=10.20.10.213 sport=5014 dport=1024 use=3
udp      17 25 src=10.20.10.198 dst=10.20.10.213 sport=5014 dport=5022
[UNREPLIED] src=10.20.10.213 dst=10.20.10.198 sport=5022 dport=5014 use=1

And is there a way to tie the timeouts of related connections together ? My
related connections are UDP and one rarely sees data while there is a
constant flow of data on the other related connection, it's undesired that
one related connection gets a timeout, while the other one is still active.


regards

Nikolai Dahlem

------=_NextPart_000_0006_01C3FF8F.6CBDCC50
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1400" name=3DGENERATOR></HEAD>
<BODY>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D293200612-01032004>Hi,</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D293200612-01032004></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D293200612-01032004>I'm =
working on a=20
pair of connection tracking / nat helper modules; when NAT sees the =
first=20
outgoing packet of the connection it changes the src port to some free =
port=20
(1024 in the example),&nbsp;but the remote side is responding to the =
port listed=20
in the packet payload (5022), thus the answer to the request is not =
recognized.=20
How can I get the port the new (changed) port from netfilter, to change =
the=20
payload accordingly in my NAT-helper ?</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>udp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17 25 =

src=3D172.30.8.100 dst=3D10.20.10.198 sport=3D5022 dport=3D5014=20
[UNREPLIED]&nbsp;src=3D10.20.10.198 dst=3D10.20.10.213 sport=3D5014 =
dport=3D1024<SPAN=20
class=3D293200612-01032004> </SPAN>use=3D3</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>udp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17 25 =

src=3D10.20.10.198 dst=3D10.20.10.213 sport=3D5014 dport=3D5022 =
[UNREPLIED]<SPAN=20
class=3D293200612-01032004> </SPAN>src=3D10.20.10.213 dst=3D10.20.10.198 =
sport=3D5022=20
dport=3D5014<SPAN class=3D293200612-01032004> =
</SPAN>use=3D1<BR></FONT></DIV>
<DIV><FONT><SPAN class=3D293200612-01032004><FONT face=3DArial =
size=3D2>And is there a=20
way to tie the timeouts of related connections together ? My related =
connections=20
are UDP and&nbsp;one rarely sees data while&nbsp;there is a constant =
flow of=20
data on the other related connection, it's&nbsp;undesired that one =
related=20
connection&nbsp;gets a timeout, while the other one is still=20
active.&nbsp;</FONT></SPAN></FONT></DIV>
<DIV><FONT><SPAN class=3D293200612-01032004><FONT face=3DArial=20
size=3D2></FONT></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT><SPAN class=3D293200612-01032004><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV></FONT>
<DIV><FONT><SPAN class=3D293200612-01032004><FONT face=3DArial=20
size=3D2>regards</FONT></SPAN></FONT></DIV>
<DIV><FONT><SPAN class=3D293200612-01032004><FONT face=3DArial=20
size=3D2></FONT></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT><SPAN class=3D293200612-01032004><FONT face=3DArial =
size=3D2>Nikolai=20
Dahlem</FONT></SPAN></DIV></FONT></BODY></HTML>

------=_NextPart_000_0006_01C3FF8F.6CBDCC50--
