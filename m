From: "Kashyap Ashwin" <Ashwin.Kashyap@thomson.net>
Subject: ESP spi/sequence tracking and nat
Date: Mon, 9 Aug 2004 17:28:07 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <8FC831532CEE564AB88AC1D999C29DEBD9F148@prinsmail01.am.thmulti.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C47E57.C3302200"
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

------_=_NextPart_001_01C47E57.C3302200
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Folks,

I want to implement a connection tracking / nat module that will track
the SPI and SEQ parts in the ESP header. I need this functionality
because, nat will fail for ESP if the destination IP address (the VPN
server address) is the same for two clients. I did a packet dump for a
popular VPN client and also noticed that the SPI can be same for two
clients (say client -> server direction). The idea is to remember the
last SEQ the server responded for a particular tuple and when we get the
next tuple, we try to do a closest match, as opposed to doing an exact
match:

=20

1. If pkt is traversing in original direction, just do IP nat and no
more. Do it even if there we cannot generate a unique tuple.

2, If pkt is traversing in reply direction: try to do regular nat, if it
fails, match the seq and spi with dst_seq and dst_spi for all
connections we know of. Then demultiplex it.

=20

I know, this will have problems, but I feel that the probability of
these (for example SEQ collision between two clients) is pretty low and
may be I can think of some way to solve these some time in the future.

=20

I have read the netfilter-hacking-HOWTO. I have looked at the nat pptp
patches, and I sort of understand what is happening. I still cannot
figure out a few things:

=20

1. How can I figure out the direction of the packet in pkt_tuple(). The
idea is to store the SEQ/SPI values from the packet either into
tuple->src or tuple->dst. I noticed that packet() has a
ip_conntrack_info, but pkt_tuple() does not. I am not sure if I can mess
ip_conntrack in packet() instead...

2. I got totally confused by the pptp patches, do I need to implement a
exp_matches_pkt() for this? As far as I understand, this is needed for
things like ftp, where a connection happens in reverse direction.

=20

I currently have ip_conntrack_proto_esp.c and ip_nat_proto_esp.c, the
corresponding changes to the header files and the build system.=20

=20

I would really appreciate any input from you!=20

=20

Thanks,

Ashwin

=20

=20

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            \|/ ____ \|/=20
Ashwin Kashyap                                   @~/ ,. \~@=20
Member Technical Staff                          /_( \__/ )_\=20
Thomson - Corporate Research                       \__U_/=20
                                                Don't Panic!

=20


------_=_NextPart_001_01C47E57.C3302200
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
pre
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Folks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I want to implement a connection tracking / nat =
module that
will track the SPI and SEQ parts in the ESP header. I need this =
functionality because,
nat will fail for ESP if the destination IP address (the VPN server =
address) is
the same for two clients. I did a packet dump for a popular VPN client =
and also
noticed that the SPI can be same for two clients (say client -&gt; =
server
direction). The idea is to remember the last SEQ the server responded =
for a
particular tuple and when we get the next tuple, we try to do a closest =
match,
as opposed to doing an exact match:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>1. If pkt is traversing in original direction, just =
do IP
nat and no more. Do it even if there we cannot generate a unique =
tuple.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>2, If pkt is traversing in reply direction: try to do =
regular
nat, if it fails, match the seq and spi with dst_seq and dst_spi for all
connections we know of. Then demultiplex =
it.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I know, this will have problems, but I feel that the
probability of these (for example SEQ collision between two clients) is =
pretty
low and may be I can think of some way to solve these some time in the =
future.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I have read the netfilter-hacking-HOWTO. I have =
looked at
the nat pptp patches, and I sort of understand what is happening. I =
still
cannot figure out a few things:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>1. How can I figure out the direction of the packet =
in pkt_tuple().
The idea is to store the SEQ/SPI values from the packet either into
tuple-&gt;src or tuple-&gt;dst. I noticed that packet() has a =
ip_conntrack_info,
but pkt_tuple() does not. I am not sure if I can mess ip_conntrack in =
packet()
instead&#8230;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>2. I got totally confused by the pptp patches, do I =
need to
implement a exp_matches_pkt() for this? As far as I understand, this is =
needed
for things like ftp, where a connection happens in reverse =
direction.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I currently have ip_conntrack_proto_esp.c and
ip_nat_proto_esp.c, the corresponding changes to the header files and =
the build
system. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I would really appreciate any input from you! =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Ashwin<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<pre><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \|/ ____ \|/ =
<o:p></o:p></span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>Ashwin =
Kashyap&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; @~/ ,. =
\~@ <o:p></o:p></span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>Member =
Technical =
Staff&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; /_( \__/ )_\ <o:p></o:p></span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>Thomson - =
Corporate =
Research&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
\__U_/ <o:p></o:p></span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; Don't Panic!</span><o:p></o:p></font></pre>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C47E57.C3302200--
