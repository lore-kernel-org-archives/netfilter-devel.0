From: "pevee" <clkuan@greenpacket.com>
Subject: Pattern Matching of Postrouting Chain
Date: Tue, 1 Oct 2002 16:54:37 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <009501c26928$2dbe26c0$60faa8c0@gpcalvin>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0092_01C2696B.39B84530"
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

------=_NextPart_000_0092_01C2696B.39B84530
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,=20

   Hope that this will be post to the mailing list. My task is to=20

(1) Read a set of IPs from a configuration file
(2) Match this set of IPs with all the entry in POSTROUTING chain
(3) IF any entry that matches criterias (pkts > 10000 AND bytes > 30M), =
output the entries into a file.
(4) All in all:-

    INPUT:- Host IPs
    OUTPUT:- pkts and bytes of that Host

Example:-

Chain POSTROUTING (policy ACCEPT 16M packets, 15G bytes)
 pkts bytes target     prot opt in     out     source               =
destination
93643   33M MARK       tcp  --  *      eth1    0.0.0.0/0            =
192.168.8.250      MARK set 0x2
    0     0 MARK       all  --  *      eth1    0.0.0.0/0            =
192.168.250.75     MARK set 0x3
    0     0 MARK       all  --  *      eth1    0.0.0.0/0            =
192.168.250.75     MARK set 0x3
    0     0 MARK       all  --  *      eth1    0.0.0.0/0            =
192.168.250.75     MARK set 0x3
    0     0 MARK       all  --  *      eth1    0.0.0.0/0            =
192.168.250.75     MARK set 0x3


My questions are:-

(1) Can I do this with current iptables?
(2) If not? Should I start writting extension for iptables? Which =
documentation can get me get started?

Hope to hear from you soon :)
Thank you

Warm regards,=20

Calvin

------=_NextPart_000_0092_01C2696B.39B84530
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2719.2200" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>
<DIV><FONT face=3DArial size=3D2>Hi, </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;&nbsp; Hope that this will be =
post to the=20
mailing list. My task is to </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>(1)&nbsp;Read a set of IPs from a =
configuration=20
file</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>(2) Match this set of IPs with all the =
entry in=20
POSTROUTING chain</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>(3) IF any entry that matches criterias =
(pkts &gt;=20
10000 AND bytes &gt; 30M), output the entries into a file.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>(4) All in all:-</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;&nbsp;&nbsp; INPUT:- Host =
IPs</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;&nbsp;&nbsp;&nbsp;OUTPUT:- pkts =
and bytes of=20
that Host</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial =
size=3D2><STRONG><EM>Example:-</EM></STRONG></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Chain POSTROUTING (policy ACCEPT 16M =
packets, 15G=20
bytes)<BR>&nbsp;pkts bytes target&nbsp;&nbsp;&nbsp;&nbsp; prot opt=20
in&nbsp;&nbsp;&nbsp;&nbsp; out&nbsp;&nbsp;&nbsp;&nbsp;=20
source&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;=20
destination<BR>93643&nbsp;&nbsp; 33M =
MARK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
tcp&nbsp; --&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
eth1&nbsp;&nbsp;&nbsp;=20
0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
192.168.8.250&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MARK set =
0x2<BR>&nbsp;&nbsp;&nbsp;=20
0&nbsp;&nbsp;&nbsp;&nbsp; 0 MARK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
all&nbsp;=20
--&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; eth1&nbsp;&nbsp;&nbsp;=20
0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
192.168.250.75&nbsp;&nbsp;&nbsp;&nbsp; MARK set =
0x3<BR>&nbsp;&nbsp;&nbsp;=20
0&nbsp;&nbsp;&nbsp;&nbsp; 0 MARK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
all&nbsp;=20
--&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; eth1&nbsp;&nbsp;&nbsp;=20
0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
192.168.250.75&nbsp;&nbsp;&nbsp;&nbsp; MARK set =
0x3<BR>&nbsp;&nbsp;&nbsp;=20
0&nbsp;&nbsp;&nbsp;&nbsp; 0 MARK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
all&nbsp;=20
--&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; eth1&nbsp;&nbsp;&nbsp;=20
0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
192.168.250.75&nbsp;&nbsp;&nbsp;&nbsp; MARK set =
0x3<BR>&nbsp;&nbsp;&nbsp;=20
0&nbsp;&nbsp;&nbsp;&nbsp; 0 MARK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
all&nbsp;=20
--&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; eth1&nbsp;&nbsp;&nbsp;=20
0.0.0.0/0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
192.168.250.75&nbsp;&nbsp;&nbsp;&nbsp; MARK set 0x3<BR></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>My questions are:-</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>(1) Can I do this with current=20
iptables?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>(2) If not? Should I start writting =
extension for=20
iptables? Which documentation can get me get started?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Hope to hear from you soon =
:)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Thank you</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Warm regards, </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial =
size=3D2>Calvin</FONT></DIV></FONT></DIV></BODY></HTML>

------=_NextPart_000_0092_01C2696B.39B84530--
