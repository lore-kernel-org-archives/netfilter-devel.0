From: "Paul Albert" <palbert@rovingplanet.com>
Subject: connection tracking question
Date: Wed, 12 May 2004 15:20:24 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <6A94CF724B046C4FB3434D14A49A58BF1CB7D3@pluto.rovingplanet.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C43866.F03F7161"
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

------_=_NextPart_001_01C43866.F03F7161
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi -=20

=20

I hope that this is a quick question regarding when connection tracking
happens in relation to iptables chains being traversed.

=20

Specifically, I would like to know when the ESTABLISHED state is set in
the kernel.  I realize that it is when iptables sees an ACK of a SYN
packet, for example, but if I have a firewall rule in the nat/PREROUTING
chain that checks to ensure that the connection is ESTABLISHED, will the
ACK packet cause the rule to be hit?  Does the connection tracking take
place before the mangle/PREROUTING chain?

=20

I tried checking around the kernel code, but it wasn't immediately
obvious to me.  Thanks!

=20

Paul


------_=_NextPart_001_01C43866.F03F7161
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
font-family:Arial'>Hi &#8211; <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I hope that this is a quick question regarding when
connection tracking happens in relation to iptables chains being =
traversed.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Specifically, I would like to know when the =
ESTABLISHED
state is set in the kernel.&nbsp; I realize that it is when iptables =
sees an
ACK of a SYN packet, for example, but if I have a firewall rule in the
nat/PREROUTING chain that checks to ensure that the connection is =
ESTABLISHED,
will the ACK packet cause the rule to be hit?&nbsp; Does the connection
tracking take place before the mangle/PREROUTING =
chain?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I tried checking around the kernel code, but it =
wasn&#8217;t
immediately obvious to me.&nbsp; Thanks!<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Paul<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C43866.F03F7161--
