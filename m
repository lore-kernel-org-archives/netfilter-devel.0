From: "Giovanni Costagliola" <giovanni.costagliola@nexusat.it>
Subject: Iptables acting as a load balancer
Date: Wed, 4 Aug 2004 17:58:22 +0200
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <200408041619.SAA09183@mail.nexusat.it>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_01BA_01C47A4C.A222A860"
Return-path: <netfilter-admin@lists.netfilter.org>
To: "'Netfilter Mailinglist'" <netfilter@lists.netfilter.org>,
        "'Netfilter Development Mailinglist'" <netfilter-devel@lists.netfilter.org>
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

------=_NextPart_000_01BA_01C47A4C.A222A860
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello folks,

            I'm investigating on the possibility to adopt an
iptables-enabled box to balance the incoming traffic toward a server farm.

 

The fundamental question is:

 

Q1: Does iptables allow a state-balancing? Or it simple span the packets on
the range of IPs? (I further guess: Has it any reasonable sense?)

 

Q2: What happens in the case a target IPs doesn't respond yet? In other
words Is iptables able to recognize an host failure?

 

Q3: Provided my needs, and supposing I'll receive negative answers, does
exists some free/gpled solution feasible to me

 

Q4: Provided iptables fit positively to Q1 and Q2, does anyone experimented
the solution? Any feedback to the regard?

 

I would thanks in advance all the repliers.

 

k.r.

*g

  :\ Giovanni Costagliola
_______________________
Here I am
A young man
A crashing computer program
  -- Orchestra by Servant

 


------=_NextPart_000_01BA_01C47A4C.A222A860
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"PersonName"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
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
	{mso-margin-top-alt:auto;
	margin-right:0cm;
	mso-margin-bottom-alt:auto;
	margin-left:0cm;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.StileMessaggioDiPostaElettronica17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:70.85pt 2.0cm 2.0cm 2.0cm;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DIT link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Hello folks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; I&#8217;m
investigating on the possibility to adopt an iptables-enabled box to =
balance
the incoming traffic toward a server farm.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>The fundamental question =
is:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Q1: <i><span style=3D'font-style:italic'>Does =
iptables
allow a state-balancing? Or it simple span the packets on the range of =
IPs? (I
further guess: Has it any reasonable =
sense?)<o:p></o:p></span></i></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Q2: <i><span style=3D'font-style:italic'>What =
happens
in the case a target IPs doesn&#8217;t respond yet? In other words Is =
iptables
able to recognize an host =
failure?<o:p></o:p></span></i></span></font></p>

<p class=3DMsoNormal><i><font size=3D2 face=3DArial><span lang=3DEN-GB
style=3D'font-size:10.0pt;font-family:Arial;font-style:italic'><o:p>&nbsp=
;</o:p></span></font></i></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Q3: <i><span =
style=3D'font-style:italic'>Provided my
needs, and supposing I&#8217;ll receive negative answers, does exists =
some
free/gpled solution feasible to =
me<o:p></o:p></span></i></span></font></p>

<p class=3DMsoNormal><i><font size=3D2 face=3DArial><span lang=3DEN-GB
style=3D'font-size:10.0pt;font-family:Arial;font-style:italic'><o:p>&nbsp=
;</o:p></span></font></i></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Q4: <i><span =
style=3D'font-style:italic'>Provided
iptables fit positively to Q1 and Q2, does anyone experimented the =
solution? Any
feedback to the regard?</span></i><o:p></o:p></span></font></p>

<p class=3DMsoNormal><i><font size=3D2 face=3DArial><span lang=3DEN-GB
style=3D'font-size:10.0pt;font-family:Arial;font-style:italic'><o:p>&nbsp=
;</o:p></span></font></i></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>I would thanks in advance all the =
repliers.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>k.r.<o:p></o:p></span></font></p>

<p><font size=3D2 face=3DVerdana><span lang=3DEN-GB =
style=3D'font-size:10.0pt;
font-family:Verdana'>*g<br>
<br>
&nbsp;&nbsp;<strong><b><font color=3D"#ff8040" face=3DVerdana><span
style=3D'font-family:Verdana;color:#FF8040'>:\</span></font></b></strong>=
<font
color=3D"#ff8040"><span style=3D'color:#FF8040'> =
</span></font><st1:PersonName
ProductID=3D"Giovanni Costagliola" w:st=3D"on"><strong><b><font =
face=3DVerdana><span
 style=3D'font-family:Verdana'>Giovanni =
Costagliola</span></font></b></strong></st1:PersonName><br>
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
&nbsp; --&nbsp;Orchestra by Servant</span></font><span =
lang=3DEN-GB><o:p></o:p></span></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
lang=3DEN-GB
style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------=_NextPart_000_01BA_01C47A4C.A222A860--
