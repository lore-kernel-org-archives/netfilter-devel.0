From: "Colin Cyrille" <engp2437@nus.edu.sg>
Subject: Re: libipq / packet size
Date: Wed, 7 May 2003 20:40:52 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <6330DC96389A924A804F52FA3848930E88A8BE@MBXSRV26.stu.nus.edu.sg>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C31495.E5612819"
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

------_=_NextPart_001_01C31495.E5612819
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

My mistake... forgot to change the total length field in the IP header.
So obviously was truncated... Everything's fine now.

=20

Sorry for jamming your mailboxes ;-)

=20

Cyrille

=20


------_=_NextPart_001_01C31495.E5612819
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 10 (filtered)">

<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
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
span.emailstyle17
	{font-family:Arial;
	color:windowtext;}
span.EmailStyle19
	{font-family:Arial;
	color:navy;}
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

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DTahoma><span =
style=3D'font-size:
10.0pt;font-family:Tahoma;color:navy'>My mistake&#8230; forgot to change =
the
total length field in the IP header. So obviously was truncated&#8230; =
Everything&#8217;s
fine now.</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DTahoma><span =
style=3D'font-size:
10.0pt;font-family:Tahoma;color:navy'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DTahoma><span =
style=3D'font-size:
10.0pt;font-family:Tahoma;color:navy'>Sorry for jamming your mailboxes =
;-)</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DTahoma><span =
style=3D'font-size:
10.0pt;font-family:Tahoma;color:navy'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DTahoma><span =
style=3D'font-size:
10.0pt;font-family:Tahoma;color:navy'>Cyrille</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>&nbsp;</span></font></p>

</div>

</body>

</html>
=00
------_=_NextPart_001_01C31495.E5612819--
