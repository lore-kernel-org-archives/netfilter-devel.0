From: "Ethan Dameron" <efd@duke.edu>
Subject: Raw Sockets and Netfiter
Date: Tue, 25 Mar 2003 02:06:59 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0018_01C2F273.37D9D9E0"
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

------=_NextPart_000_0018_01C2F273.37D9D9E0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 7bit

If I have a an IP datagram in userspace and I send it via a raw socket
created with socket(PF_INET, SOCK_RAW, IPPROTO_RAW) using the send()
system call, will this packet traverse the netfilter chains?  If it does
not traverse the firewall, how can I make it do so?

 

Thanks,

 

Ethan Dameron


---
Outgoing mail is certified Virus Free.
Checked by AVG anti-virus system (http://www.grisoft.com).
Version: 6.0.463 / Virus Database: 262 - Release Date: 03/17/2003
 

------=_NextPart_000_0018_01C2F273.37D9D9E0
Content-Type: text/html;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3DWindows-1252">


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
font-family:Arial'>If I have a an IP datagram in userspace and I send it =
via a
raw socket created with socket(PF_INET, SOCK_RAW, IPPROTO_RAW) using the =
send()
system call, will this packet traverse the netfilter chains?=A0 If it =
does not
traverse the firewall, how can I make it do so?</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks,</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Ethan Dameron</span></font></p>

</div>

</body>

</html>
<BR>

<P><FONT SIZE=3D2>---<BR>
Outgoing mail is certified Virus Free.<BR>
Checked by AVG anti-virus system (http://www.grisoft.com).<BR>
Version: 6.0.463 / Virus Database: 262 - Release Date: 03/17/2003<BR>
</FONT> </P>

------=_NextPart_000_0018_01C2F273.37D9D9E0--
