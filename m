From: "Steve Wakelin" <steve@wcsl.net>
Subject: RE: Iptables acting as a load balancer
Date: Wed, 4 Aug 2004 20:08:08 +0100
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <267354A234DF4D46AA6AE56E1240BEF004A408@wcsls03.wcslnet.net>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C47A56.60C14F02"
Return-path: <netfilter-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Giovanni Costagliola" <giovanni.costagliola@nexusat.it>,
        "Netfilter Mailinglist" <netfilter@lists.netfilter.org>,
        "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C47A56.60C14F02
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

http://www.linuxvirtualserver.org/index.html

=20

-----Original Message-----
From: netfilter-admin@lists.netfilter.org
[mailto:netfilter-admin@lists.netfilter.org] On Behalf Of Giovanni
Costagliola
Sent: 04 August 2004 16:58
To: 'Netfilter Mailinglist'; 'Netfilter Development Mailinglist'
Subject: Iptables acting as a load balancer

=20

Hello folks,

            I'm investigating on the possibility to adopt an
iptables-enabled box to balance the incoming traffic toward a server
farm.

=20

The fundamental question is:

=20

Q1: Does iptables allow a state-balancing? Or it simple span the packets
on the range of IPs? (I further guess: Has it any reasonable sense?)

=20

Q2: What happens in the case a target IPs doesn't respond yet? In other
words Is iptables able to recognize an host failure?

=20

Q3: Provided my needs, and supposing I'll receive negative answers, does
exists some free/gpled solution feasible to me

=20

Q4: Provided iptables fit positively to Q1 and Q2, does anyone
experimented the solution? Any feedback to the regard?

=20

I would thanks in advance all the repliers.

=20

k.r.

*g

  :\ Giovanni Costagliola
_______________________
Here I am
A young man
A crashing computer program
  -- Orchestra by Servant

=20


------_=_NextPart_001_01C47A56.60C14F02
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html>

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">


<meta name=3DGenerator content=3D"Microsoft Word 10 (filtered)">

<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p
	{margin-right:0cm;
	margin-left:0cm;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle18
	{font-family:Arial;
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
span.EmailStyle20
	{font-family:Arial;
	color:navy;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:70.85pt 2.0cm 2.0cm 2.0cm;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>http://www.linuxvirtualserver.org/in=
dex.html</span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DTahoma><span
style=3D'font-size:10.0pt;font-family:Tahoma'>-----Original =
Message-----<br>
<b><span style=3D'font-weight:bold'>From:</span></b>
netfilter-admin@lists.netfilter.org
[mailto:netfilter-admin@lists.netfilter.org] <b><span =
style=3D'font-weight:bold'>On
Behalf Of </span></b>Giovanni Costagliola<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> </span></font><font =
size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;font-family:Tahoma'>04 August =
2004</span></font><font
size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;font-family:Tahoma'> </span></font><font =
size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;font-family:Tahoma'>16:58</span></font><font
size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;font-family:Tahoma'><br>
<b><span style=3D'font-weight:bold'>To:</span></b> 'Netfilter =
Mailinglist';
'Netfilter Development Mailinglist'<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Iptables acting =
as a load
balancer</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D3
face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>Hello =
folks,</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
I&#8217;m investigating on the possibility to adopt an iptables-enabled =
box to
balance the incoming traffic toward a server farm.</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>The =
fundamental question
is:</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>Q1: <i><span
style=3D'font-style:italic'>Does iptables allow a state-balancing? Or it =
simple
span the packets on the range of IPs? (I further guess: Has it any =
reasonable
sense?)</span></i></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>Q2: <i><span
style=3D'font-style:italic'>What happens in the case a target IPs =
doesn&#8217;t
respond yet? In other words Is iptables able to recognize an host =
failure?</span></i></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><i><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;font-style:italic'>&nbsp;</sp=
an></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>Q3: <i><span
style=3D'font-style:italic'>Provided my needs, and supposing I&#8217;ll =
receive
negative answers, does exists some free/gpled solution feasible to =
me</span></i></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><i><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;font-style:italic'>&nbsp;</sp=
an></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>Q4: <i><span
style=3D'font-style:italic'>Provided iptables fit positively to Q1 and =
Q2, does
anyone experimented the solution? Any feedback to the =
regard?</span></i></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><i><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial;font-style:italic'>&nbsp;</sp=
an></font></i></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>I would thanks =
in advance
all the repliers.</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D2 =
face=3DArial><span
lang=3DIT =
style=3D'font-size:10.0pt;font-family:Arial'>k.r.</span></font></p>

<p style=3D'margin-left:36.0pt'><font size=3D2 face=3DVerdana><span =
lang=3DEN-GB
style=3D'font-size:10.0pt;font-family:Verdana'>*g<br>
<br>
&nbsp;&nbsp;<strong><b><font color=3D"#ff8040" face=3DVerdana><span
style=3D'font-family:Verdana;color:#FF8040'>:\</span></font></b></strong>=
<font
color=3D"#ff8040"><span style=3D'color:#FF8040'> =
</span></font><strong><b><font
face=3DVerdana><span style=3D'font-family:Verdana'>Giovanni =
Costagliola</span></font></b></strong><br>
<strong><b><font color=3D"#ff8040" face=3DVerdana><span =
style=3D'font-family:Verdana;
color:#FF8040'>_______________________</span></font></b></strong><b><font=

color=3D"#ff8040"><span style=3D'color:#FF8040;font-weight:bold'><br>
</span></font></b></span></font><font size=3D1 color=3D"#ff8040" =
face=3DVerdana><span
lang=3DEN-GB =
style=3D'font-size:7.5pt;font-family:Verdana;color:#FF8040'>Here I =
am<br>
A young man<br>
A crashing computer program<br>
&nbsp; --&nbsp;Orchestra by Servant</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:36.0pt'><font size=3D3
face=3D"Times New Roman"><span lang=3DEN-GB =
style=3D'font-size:12.0pt'>&nbsp;</span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C47A56.60C14F02--
