From: "Arthur Niu" <arthur.niu@neighbourhoodlink.ca>
Subject: (no subject)
Date: Wed, 21 Jan 2004 10:39:43 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <EOEIJIEEJODPHJKGJHMBCEJJCBAA.arthur.niu@neighbourhoodlink.ca>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0007_01C3E00A.E177DE90"
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

------=_NextPart_000_0007_01C3E00A.E177DE90
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi there,
I got problems to upgrade iptables, please help.
Environment: RedHat 9.0 Kernel 2.4.20-8

Now, I removed iptables-1.2.7a with Redhat, and want to install iptables
1.2.9, have downloaded the source code,
1) run the following commands:
make KERNEL_DIR=/usr/src/linux-2.4
make install KERNEL_DIR=/usr/src/linux-2.4

2) compile kernel

3) reboot

but, iptables service wasn't started, I run service iptables start and
system told me: iptables: unrecognized service

so I checked /etc/xinetd.d, iptables not there,

I think I did wrong, can anyone give me some ideas?


Can I compile the iptables 1.2.9 into rpm and then install it


Thx


------=_NextPart_000_0007_01C3E00A.E177DE90
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<meta name=3DProgId content=3DWord.Document>
<meta name=3DGenerator content=3D"Microsoft Word 9">
<meta name=3DOriginator content=3D"Microsoft Word 9">
<link rel=3DFile-List href=3D"cid:filelist.xml@01C3E00A.E140F010">
<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:DoNotRelyOnCSS/>
 </o:OfficeDocumentSettings>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Normal</w:View>
  <w:Zoom>0</w:Zoom>
  <w:DocumentKind>DocumentEmail</w:DocumentKind>
  <w:EnvelopeVis/>
 </w:WordDocument>
</xml><![endif]-->
<style>
<!--
 /* Font Definitions */
@font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:536871559 0 0 0 415 0;}
 /* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:Arial;
	mso-fareast-font-family:"Times New Roman";
	color:navy;}
p.MsoAutoSig, li.MsoAutoSig, div.MsoAutoSig
	{margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:Arial;
	mso-fareast-font-family:"Times New Roman";
	color:navy;}
p
	{margin-right:0in;
	mso-margin-top-alt:auto;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";
	color:black;}
span.EmailStyle15
	{mso-style-type:personal-compose;
	mso-ansi-font-size:12.0pt;
	mso-ascii-font-family:Arial;
	mso-hansi-font-family:Arial;
	mso-bidi-font-family:Arial;
	color:black;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
-->
</style>
</head>

<body lang=3DEN-US style=3D'tab-interval:.5in'>

<div class=3DSection1>

<p><font size=3D2 color=3Dblack face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>Hi there,<o:p></o:p></span></font></p>

<p><font size=3D2 color=3Dblack face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>I got problems to upgrade iptables, please =
help.<o:p></o:p></span></font></p>

<p><font size=3D2 color=3Dblack face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>Environment: RedHat 9.0 Kernel 2.4.20-8<br>
<br>
Now, I removed iptables-1.2.7a with Redhat, and want to install iptables =
1.2.9,
have downloaded the source code, <br>
1) run the following commands:<br>
make KERNEL_DIR=3D/usr/src/linux-2.4<br>
make install KERNEL_DIR=3D/usr/src/linux-2.4<br>
<br>
2) compile kernel<br>
<br>
3) reboot<br>
<br>
but, iptables service wasn't started, I run service iptables start and =
system
told me: iptables: unrecognized service<br>
<br>
so I checked /etc/xinetd.d, iptables not there,<br>
<br>
I think I did wrong, can anyone give me some ideas?<br =
style=3D'mso-special-character:
line-break'>
<![if !supportLineBreakNewLine]><br =
style=3D'mso-special-character:line-break'>
<![endif]><o:p></o:p></span></font></p>

<p><font size=3D2 color=3Dblack face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>Can I compile the iptables 1.2.9 into rpm and then =
install
it<br style=3D'mso-special-character:line-break'>
<![if !supportLineBreakNewLine]><br =
style=3D'mso-special-character:line-break'>
<![endif]><o:p></o:p></span></font></p>

<p><font size=3D2 color=3Dblack face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>Thx</span></font><o:p></o:p></p>

<p class=3DMsoNormal><span class=3DEmailStyle15><font size=3D3 =
color=3Dblack
face=3DArial><span style=3D'font-size:12.0pt'><![if =
!supportEmptyParas]>&nbsp;<![endif]><o:p></o:p></span></font></span></p>

</div>

</body>

</html>

------=_NextPart_000_0007_01C3E00A.E177DE90--
