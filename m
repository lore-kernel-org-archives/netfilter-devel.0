From: "Tsachi Sharfman" <Tsachi_Sharfman@etagon.com>
Subject: Deleting Connection Tracking information
Date: Mon, 8 Jul 2002 14:31:26 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <AE696B0F5B44A348B8D18E40F976D9571BA92E@mailsrv.etagon.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C2267B.609B96BC"
Return-path: <netfilter-devel-admin@lists.samba.org>
content-class: urn:content-classes:message
To: <netfilter@lists.samba.org>, <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C2267B.609B96BC
Content-Type: text/plain;
	charset="WINDOWS-1255"
Content-Transfer-Encoding: quoted-printable

Hi,

=20

I would like to add a NAT rule on a gateway while connections are =
passing through it, and have the rule apply to existing connections. I =
understand this is not the behavior when the rule is simply added to the =
NAT table, since netfilter consults the NAT table only for the first =
packet of the connection. I assume that if I can delete connection =
tracking information on the gateway, once a packet belonging to an =
existing connection passes through the gateway netfilter will regard it =
as a new connection (since there is no connection tracking information =
for it), and apply the new NAT rules that existing connection. My =
questions are:

=20

1.	Is my assumption correct?
2.	Is the answer to the first question is yes, how can I delete =
connection tracking information?

=20

Thanks,

Tsachi Sharfman.


------_=_NextPart_001_01C2267B.609B96BC
Content-Type: text/html;
	charset="WINDOWS-1255"
Content-Transfer-Encoding: quoted-printable

<html>

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dwindows-1255">
<meta name=3DGenerator content=3D"Microsoft Word 10 (filtered)">

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
	{font-family:Arial;
	color:windowtext;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Hi,</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I would like to add a NAT rule on a gateway while
connections are passing through it, and have the rule apply to existing
connections. I understand this is not the behavior when the rule is =
simply
added to the NAT table, since netfilter consults the NAT table only for =
the
first packet of the connection. I assume that if I can delete connection
tracking information on the gateway, once a packet belonging to an =
existing
connection passes through the gateway netfilter will regard it as a new
connection (since there is no connection tracking information for it), =
and apply
the new NAT rules that existing connection. My questions =
are:</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<ol start=3D1 type=3D1>
 <li class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
     font-family:Arial'>Is my assumption correct?</span></font></li>
 <li class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
     font-family:Arial'>Is the answer to the first question is yes, how =
can I
     delete connection tracking information?</span></font></li>
</ol>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks,</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Tsachi Sharfman.</span></font></p>

</div>

</body>

</html>
=00
------_=_NextPart_001_01C2267B.609B96BC--
