From: "Grace Li" <zheyinli@hotmail.com>
Subject: Does iptable save original destination address so that application could retrieve it?
Date: Mon, 5 Apr 2004 16:02:25 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY7-DAV39pFcgRqaxA00021e1b@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_00B5_01C41B27.62EFE560"
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

------=_NextPart_000_00B5_01C41B27.62EFE560
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi, folks,

Iptables could be instructed to intercept packets arrived on specified =
network interface, change the destination port to a specified local port =
so that the traffic is directed to appropriate application. For example =
Squid asks iptables to intercept traffic for port 80, frox asks iptable =
to intercept traffic for port 21, ASSP asks iptable to intercept traffic =
for port 80. My question is how could those application know the source =
and destination IP address of the packet in order to forward them on? =
Does iptable save original source/destination address somewhere so that =
application could retrieve it?

The answer of this question is very important to me. Thanks in advance =
for any tip!

Grace
------=_NextPart_000_00B5_01C41B27.62EFE560
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1106" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Hi, folks,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Iptables could be instructed to =
intercept packets=20
arrived on specified network interface, change the destination port to a =

specified local port so that the traffic is directed to appropriate =
application.=20
For example Squid asks iptables to intercept traffic for port 80, frox =
asks=20
iptable to intercept traffic for port 21, ASSP asks iptable to intercept =
traffic=20
for port 80. My question is how could those application know the source =
and=20
destination IP address of the packet in order to forward them on? <FONT=20
size=3D2>Does iptable save original source/destination address somewhere =
so that=20
application could retrieve it?</FONT></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>The answer of this question is very =
important to=20
me. Thanks in advance for any tip!</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Grace</FONT></DIV></BODY></HTML>

------=_NextPart_000_00B5_01C41B27.62EFE560--
