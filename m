From: "Nikolai Dahlem" <listuser@epygi.de>
Subject: can't change expectation: change_expect returns -1 (resend packet)
Date: Thu, 20 Nov 2003 12:11:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <DAELKAPIKOFAFFKELNHOAEALCAAA.listuser@epygi.de>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0004_01C3AF5F.76B9AE20"
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

------=_NextPart_000_0004_01C3AF5F.76B9AE20
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

I'm raising an expectation in conntrack and im trying to change it in nat to
the ip of the firewall + getting a free port, but in (almost) all cases
change_expect returns -1 (resend packet without the same port). the odd
thing is, in some cases it works ...
I suppose I'm basically doing something plain wrong/stupid, because it
shouldn't be treated as a resend packet.
I attached some snippets from my syslog, how the expectation is risen in
conntrack, and how it try to change it in nat.

conntrack:
ip_conntrack_sip.c:help:expect_related 172.30.8.100:5022-0.0.0.0:0
ip_conntrack_expect_related c280d4a0
tuple: tuple c01fdc00: 17 0.0.0.0:0x0000 0000 -> 172.30.8.100:0xc03fd840
mask:  tuple c01fdc20: 65535 255.255.255.255:0xffff0000 ->
255.255.255.255:0x00000000
new expectation c2b8f370 of conntrack c280d4a0

nat:
starting with port: 5022

change_expect:
exp tuple: tuple c2b8f3c8: 17 0.0.0.0:0x00000000 -> 172.30.8.100:0xc03fd840
exp mask:  tuple c2b8f3e8: 65535 255.255.255.255:0xffff0000 ->
255.255.255.255:0x00000000
newtuple:  tuple c01fdb58: 17 0.0.0.0:0x00000000 -> 10.20.10.213:0xc03fd840
change expect: resent packet
....
<happens for all port>
....
no free port found

Can anybody please shed some light on this

regards

Nikolai Dahlem

------=_NextPart_000_0004_01C3AF5F.76B9AE20
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1264" name=3DGENERATOR></HEAD>
<BODY>
<DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D075565910-20112003>Hi,</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D075565910-20112003></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D075565910-20112003>I'm =
raising an=20
expectation in conntrack and im trying to change it in nat to the ip of =
the=20
firewall + getting a free port, but in (almost) all cases change_expect =
returns=20
-1 (resend packet without the same port). the odd thing is, in some =
cases it=20
works ...</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D075565910-20112003>I =
suppose I'm=20
basically doing something plain wrong/stupid, because it shouldn't be =
treated as=20
a resend packet.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D075565910-20112003>I =
attached some=20
snippets from my syslog, how the expectation is risen in conntrack, and =
how it=20
try to change it in nat.</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D075565910-20112003></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D075565910-20112003>conntrack:</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2>ip_conntrack_sip.c:help:expect_related=20
172.30.8.100:5022-0.0.0.0:0<BR>ip_conntrack_expect_related =
c280d4a0<BR>tuple:=20
tuple c01fdc00: 17 0.0.0.0:0x0000 0000 -&gt;=20
172.30.8.100:0xc03fd840<BR>mask:&nbsp; tuple c01fdc20: 65535=20
255.255.255.255:0xffff0000 -&gt; 255.255.255.255:0x00000000<BR>new =
expectation=20
c2b8f370 of conntrack c280d4a0<BR></FONT><FONT face=3DArial =
size=3D2></FONT></DIV>
<DIV><SPAN class=3D075565910-20112003><FONT face=3DArial=20
size=3D2>nat:</FONT></SPAN></DIV>
<DIV><FONT face=3DArial><FONT size=3D2>starting with port: =
5022</FONT></FONT></DIV>
<DIV><FONT face=3DArial><FONT size=3D2><BR>change_expect:<BR>exp tuple: =
tuple=20
c2b8f3c8: 17 0.0.0.0:0x00000000 -&gt; 172.30.8.100:0xc03fd840<BR>exp =
mask:&nbsp;=20
tuple c2b8f3e8: 65535 255.255.255.255:0xffff0000 -&gt;=20
255.255.255.255:0x00000000<BR>newtuple:&nbsp; tuple c01fdb58: 17=20
0.0.0.0:0x00000000 -&gt; 10.20.10.213:0xc03fd840<BR>change expect: =
resent=20
packet<BR><SPAN =
class=3D075565910-20112003>....</SPAN></FONT></FONT></DIV>
<DIV><FONT face=3DArial><FONT size=3D2><SPAN =
class=3D075565910-20112003>&lt;happens=20
for all port&gt;</SPAN></FONT></FONT></DIV>
<DIV><FONT face=3DArial><FONT size=3D2><SPAN=20
class=3D075565910-20112003>....</SPAN></FONT></FONT></DIV>
<DIV><FONT face=3DArial><FONT size=3D2><SPAN =
class=3D075565910-20112003>no free port=20
found</SPAN></FONT></FONT></DIV>
<DIV><FONT face=3DArial><FONT size=3D2><SPAN=20
class=3D075565910-20112003></SPAN></FONT></FONT>&nbsp;</DIV>
<DIV>
<DIV><FONT face=3DArial size=3D2><SPAN class=3D075565910-20112003>Can =
anybody please=20
shed some light on this</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D075565910-20112003></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D075565910-20112003>regards</SPAN></FONT></DIV>
<DIV><FONT face=3DArial size=3D2><SPAN=20
class=3D075565910-20112003></SPAN></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2><SPAN =
class=3D075565910-20112003>Nikolai=20
Dahlem</SPAN></FONT></DIV></DIV></DIV></BODY></HTML>

------=_NextPart_000_0004_01C3AF5F.76B9AE20--
