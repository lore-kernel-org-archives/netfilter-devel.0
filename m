From: "zze-Proxy_Corveller ball001 exterieur FTRD" <proxycorveller.ball001@rd.francetelecom.com>
Subject: Problem of NAT with VLAN
Date: Wed, 9 Apr 2003 11:44:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <8C19E3FBB6467846AFF97E366D34CB600189A4A3@lanmhs20.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C2FE7C.9DE427C2"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
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

------_=_NextPart_001_01C2FE7C.9DE427C2
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello,

I've got n VLANs that arrive on a Linux machine. I'm using vconfig to
receive packets from those VLANs.

I want to perform DNAT on packets between my physical interface (eth2) =
and the virtuals devices
created by vconfig (vlan00xx, where xx is the VLAN ID of the associated =
VLAN).
I've place some rules at the PREROUTING chain in the nat table to =
perform the address
translation.

My problem is that netfilter seems don't see packets between eth2 and =
vlan00xx.=20

I've tried some rules such as '-A PREROUTING -i eth2' or '-A PREROUTING =
-i vlan0010' but
the packet counters stay equal to 0.

Any idea ?


------_=_NextPart_001_01C2FE7C.9DE427C2
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.0.6389.0">
<TITLE>Problem of NAT with VLAN</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier =
New">Hello,</FONT></SPAN>
</P>

<P><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier New">I've got n =
VLANs that arrive on a Linux machine. I'm using vconfig to</FONT></SPAN>

<BR><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier New">receive =
packets from those VLANs.</FONT></SPAN>
</P>

<P><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier New">I want to =
perform DNAT on packets between my physical interface (eth2) and the =
virtuals devices</FONT></SPAN>

<BR><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier New">created by =
vconfig (vlan00xx, where xx is the VLAN ID of the associated =
VLAN).</FONT></SPAN>

<BR><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier New">I've place =
some rules at the PREROUTING chain in the nat table to perform the =
address</FONT></SPAN>

<BR><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier =
New">translation.</FONT></SPAN>
</P>

<P><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier New">My problem is =
that netfilter seems don't see packets between eth2 and vlan00xx. =
</FONT></SPAN>
</P>

<P><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier New">I've tried some =
rules such as '-A PREROUTING -i eth2' or '-A PREROUTING -i vlan0010' =
but</FONT></SPAN>

<BR><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier New">the packet =
counters stay equal to 0.</FONT></SPAN>
</P>

<P><SPAN LANG=3D"fr"><FONT SIZE=3D2 FACE=3D"Courier New">Any idea =
?</FONT></SPAN>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C2FE7C.9DE427C2--
