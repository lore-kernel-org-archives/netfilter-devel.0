From: =?big5?B?TElHSFQuTFUgp2atUKSk?=
	<LIGHT.LU@delta.com.tw>
Subject: ip_conntrack_pptp control connection direction limitation
Date: Wed, 23 Jun 2004 11:24:35 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E8A43220CB34D811A81D00508BB9C7DF028721D2@TPMS1>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C458D1.9BB7CE20"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_001_01C458D1.9BB7CE20
Content-Type: text/plain;
	charset="big5"

Hello,

 

As the code comment of ip_conntrack_pptp.c Version 1.9 said that the
direction of control connection is limited to PNS->PAC.  Is there any plan
to conquer this limitation?  Or any one can describe the difficulties to
remove it.  Any other information is worthy being noticed?

 

Thank you very much.

 

Light lu

 


------_=_NextPart_001_01C458D1.9BB7CE20
Content-Type: text/html;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dbig5">


<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:=B7s=B2=D3=A9=FA=C5=E9;
	panose-1:2 2 3 0 0 0 0 0 0 0;}
@font-face
	{font-family:"\@=B7s=B2=D3=A9=FA=C5=E9";
	panose-1:2 2 3 0 0 0 0 0 0 0;}
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
 /* Page Definitions */
 @page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;
	layout-grid:18.0pt;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DZH-TW link=3Dblue vlink=3Dpurple =
style=3D'text-justify-trim:punctuation'>

<div class=3DSection1 style=3D'layout-grid:18.0pt'>

<p class=3DMsoNormal style=3D'layout-grid-mode:char'><font size=3D1 =
face=3DArial><span
lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:Arial'>Hello,<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal style=3D'layout-grid-mode:char'><font size=3D1 =
face=3DArial><span
lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></fo=
nt></p>

<p class=3DMsoNormal style=3D'layout-grid-mode:char'><font size=3D1 =
face=3DArial><span
lang=3DEN-US style=3D'font-size:9.0pt;font-family:Arial'>As the code =
comment of
ip_conntrack_pptp.c Version 1.9 said that the direction of control =
connection
is limited to PNS-&gt;<st1:place w:st=3D"on">PAC.</st1:place> &nbsp;Is =
there any
plan to conquer this limitation?&nbsp; Or any one can describe the =
difficulties
to remove it.&nbsp; Any other information is worthy being =
noticed?<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'layout-grid-mode:char'><font size=3D1 =
face=3DArial><span
lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></fo=
nt></p>

<p class=3DMsoNormal style=3D'layout-grid-mode:char'><font size=3D1 =
face=3DArial><span
lang=3DEN-US style=3D'font-size:9.0pt;font-family:Arial'>Thank you very =
much.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'layout-grid-mode:char'><font size=3D1 =
face=3DArial><span
lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></fo=
nt></p>

<p class=3DMsoNormal style=3D'layout-grid-mode:char'><font size=3D1 =
face=3DArial><span
lang=3DEN-US style=3D'font-size:9.0pt;font-family:Arial'>Light =
lu<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D1 face=3DArial><span lang=3DEN-US =
style=3D'font-size:
9.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C458D1.9BB7CE20--
