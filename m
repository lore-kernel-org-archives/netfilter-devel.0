From: "Maarten Wijnants" <maarten.wijnants@luc.ac.be>
Subject: Issuing a verdict for a packet more than once in userspace
Date: Thu, 22 Jul 2004 13:25:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003e01c46fde$a4e59a30$061012ac@in.edm.luc.ac.be>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_003B_01C46FEF.680F0C20"
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

------=_NextPart_000_003B_01C46FEF.680F0C20
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all,

I'll begin by explaining my goal/network architecture. The idea is that =
clients connect to a server through a proxy device. This proxy device =
checks the network streams that the server sends to the client, and only =
forwards a (small) part of this data to the client based on some set of =
"rules". These rules can be enforced by the client. I hope this is clear =
enough, if not, say so and I will elaborate :-)

To implement the proxy, I've used netfilter in combination with libipq. =
I use iptables to queue all packets on the FORWARD chain to a user space =
application (iptables -A FORWARD -j QUEUE). In this app, I then check =
the rules and set a verdict for the packets. This all works very well =
for unicast network traffic.

The problem however is that I also want the proxy to change multicast =
traffic into unicast traffic. Therefor I thought I would change the =
destination IP of MC packets (this is a multicast IP address) to the IP =
address of the interested client(s) in the userspace app. However, if =
more than one client is interested in the MC packet, I need to create =
and send 2 or more unicast packets. Some testing revealed that mangling =
a received packet and issuing a verdict for it more than once results in =
libipq errors (e.g. I receive a MC packet, change the destination =
address and issue NF_ACCEPT, I change the destination address again and =
again issue NF_ACCEPT). Is there something I am doing wrong, or is it =
just not possible what I am trying to do? And if it is not possible, is =
there any other way I can achieve my goal?

Many thanks in advance,
Maarten

--

Maarten Wijnants
Expertisecentrum voor Digitale Media
Limburgs Universitair Centrum
Wetenschapspark 2 - 3590 Diepenbeek
Tel: +32 (0)11 268419 - Mobile: +32 (0)497 341848
E-mail: maarten.wijnants@luc.ac.be
URL: http://edm.luc.ac.be
------=_NextPart_000_003B_01C46FEF.680F0C20
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1400" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hi all,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I'll begin by explaining my =
goal/network=20
architecture. The idea is that clients connect to a server through a =
proxy=20
device. This proxy device checks the network streams that the server =
sends to=20
the client, and only forwards a (small) part of this data to the client =
based on=20
some set of "rules". These rules can be enforced by the client. I hope =
this is=20
clear enough, if not, say so and I will elaborate :-)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>To implement the proxy, I've used =
netfilter in=20
combination with libipq. I use iptables to queue all packets on the =
FORWARD=20
chain to a user space application (iptables -A FORWARD -j QUEUE). In =
this app, I=20
then check the rules and set a verdict for the packets. This all works =
very well=20
for unicast network traffic.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial><FONT size=3D2>The problem however is that I =
also want the=20
proxy to change multicast traffic into unicast traffic. Therefor I =
thought I=20
would change the destination IP of&nbsp;MC packets (this is a multicast =
IP=20
address) to the IP address of the interested client(s) in the userspace =
app.=20
However, if more than one client is interested in the MC packet, I need =
to=20
create and send&nbsp;2 or more unicast packets. Some testing revealed =
that=20
mangling a received packet and issuing a verdict for it more than=20
once&nbsp;results in libipq errors (e.g. I receive a MC packet, change =
the=20
destination address and issue NF_ACCEPT, I change the destination =
address again=20
and again issue NF_ACCEPT). </FONT></FONT><FONT face=3DArial><FONT =
size=3D2>Is there=20
something I am doing wrong, or is it just not possible what I am trying =
to do?=20
And if it is not possible, is there any other way I can achieve my=20
goal?</FONT></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Many thanks in advance,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Maarten</FONT></DIV>
<DIV><FONT face=3DArial><FONT size=3D2></FONT></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>--</DIV>
<DIV>&nbsp;</DIV>
<DIV>Maarten Wijnants<BR>Expertisecentrum voor Digitale =
Media<BR>Limburgs=20
Universitair Centrum<BR>Wetenschapspark 2 - 3590 Diepenbeek<BR>Tel: +32 =
(0)11=20
268419 - Mobile: +32 (0)497 341848<BR>E-mail: <A=20
href=3D"mailto:maarten.wijnants@luc.ac.be">maarten.wijnants@luc.ac.be</A>=
<BR>URL:=20
<A=20
href=3D"http://edm.luc.ac.be">http://edm.luc.ac.be</A></FONT></DIV></BODY=
></HTML>

------=_NextPart_000_003B_01C46FEF.680F0C20--
