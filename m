From: "Grace Li" <zheyinli@hotmail.com>
Subject: How does iptables redirect a packet that is not addressed to its local machine
Date: Wed, 7 Apr 2004 18:16:07 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY7-DAV19wEsGmjm0800027007@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0033_01C41CCC.655E6E10"
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

------=_NextPart_000_0033_01C41CCC.655E6E10
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

I am just wondering if anybody could explain what happened in the =
following experiments:

Client (192.168.1.134) tries to connect to port 1888 of Server
(192.168.1.115) through Gateway (192.168.1.1).  In the Gateway, the =
iptables
has been instructed to redirect traffic on port 1888 to 2000 (iptables =
-t
nat -A PREROUTING -i eth0 -p tcp --dport 1888 -j REDIRECT -to-port 2000 =
).

The results of my experiments is that the application on Gateway who =
listens
to port 2000 could not get anything, while Server receives everything
expected on its port 1888. So my question is that did iptables do =
anything
here?

Many thanks,

Grace


------=_NextPart_000_0033_01C41CCC.655E6E10
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
<DIV><FONT face=3DArial size=3D2>Hi,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I am just wondering if anybody could =
explain what=20
happened in the following experiments:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV>Client (192.168.1.134) tries to connect to port 1888 of=20
Server<BR>(192.168.1.115) through Gateway (192.168.1.1).&nbsp; In the =
Gateway,=20
the iptables<BR>has been instructed to redirect traffic on port 1888 to =
2000=20
(iptables -t<BR>nat -A PREROUTING -i eth0 -p tcp --dport 1888 -j =
REDIRECT=20
-to-port 2000 ).<BR><BR>The results of my experiments is that the =
application on=20
Gateway who listens<BR>to port 2000 could not get anything, while Server =

receives everything<BR>expected on its port 1888. So my question is that =
did=20
iptables do anything<BR>here?</DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Many thanks,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Grace</FONT></DIV>
<DIV><BR></DIV></BODY></HTML>

------=_NextPart_000_0033_01C41CCC.655E6E10--
