From: "Juan Torres" <islero77@telefonica.net>
Subject: RV: Problems loading a Patch-O-Matic match
Date: Tue, 18 Mar 2003 11:37:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000101c2ed3a$67cf2530$0300000a@juan>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0002_01C2ED42.C9938D30"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

------=_NextPart_000_0002_01C2ED42.C9938D30
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

 

Hi, I'm trying to load a new match which comes in the Patch-O-Matic
package. I have run Patch-O-Matic and I have selected the match I'm
interested in (mport), then I have compiled the new kernel selecting in
the xconfig the new option. But after all of these steps I can't use the
new match. I have seen in the documentation that I have to go to the
userspace/ directory (I suppose that it is the "userspace" directory
into the Patch-O-Matic package) and execute make all install, but, when
I do that the response is the next:

make: *** No rule to make target 'all'. Stop.

If I try to use the new match (for example, if I write iptables -A INPUT
-p tcp -m mport --ports 20:23,80 -j DROP) 

 

the answer that I receive is:  

 

iptables v1.2.5: Couldn't load match
`mport':/usr/lib/iptables/libipt_mport.so: cannot open shared object
file: No such file or directory 

 

There are two mport files that are created: 

 

   /usr /src/linux-2.4.18.SuSE/include/config/ip/nf/match/mport/module.h


and 

   /lib/modules/2.4.18-64GB-SMP/kernel/net/ipv4/netfilter/ipt_mport.o 

 

but it doesn't exist the libipt_mport.so file.

 

 

Can anybody tell me what it's my problem?

Thank you very much.

        Juan.


------=_NextPart_000_0002_01C2ED42.C9938D30
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<html>

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">


<meta name=3DGenerator content=3D"Microsoft Word 10 (filtered)">
<title>Problems loading a Patch-O-Matic match</title>

<style>
<!--
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
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
p
	{margin-right:0cm;
	margin-left:0cm;
	font-size:12.0pt;
	font-family:"Times New Roman";}
p.CodigoFuente, li.CodigoFuente, div.CodigoFuente
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Courier New";}
span.EstiloCorreo20
	{font-family:Arial;
	color:navy;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:70.85pt 3.0cm 70.85pt 3.0cm;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DES link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

<!-- Converted from text/rtf format -->

<p><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:
Arial'>Hi, I&#8217;m trying to load a new match which comes in the
Patch-O-Matic package. I have run Patch-O-Matic and I have selected the =
match
I&#8217;m interested in (mport), then I have compiled the new kernel =
selecting
in the xconfig the new option. But after all of these steps I =
can&#8217;t use
the new match. I have seen in the documentation that I have to go to the
userspace/ directory (I suppose that it is the &#8220;userspace&#8221;
directory into the Patch-O-Matic package) and execute make all install, =
but,
when I do that the response is the next:</span></font></p>

<p><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:
Arial'>make: *** No rule to make target &#8216;all&#8217;. =
Stop.</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>If I try to =
use the new match
(for example, if I write iptables -A INPUT -p tcp -m mport --ports =
20:23,80 &#8211;j
DROP) </span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>the answer =
that I receive
is:&nbsp; </span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>iptables =
v1.2.5: Couldn't
load match `mport':/usr/lib/iptables/libipt_mport.so: cannot open shared =
object
file: No such file or directory </span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>There are two =
mport files
that are created: </span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;&nbsp; =
/usr
/src/linux-2.4.18.SuSE/include/config/ip/nf/match/mport/module.h =
</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>and =
</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;&nbsp;
/lib/modules/2.4.18-64GB-SMP/kernel/net/ipv4/netfilter/ipt_mport.o =
</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>but it =
doesn&#8217;t
exist the libipt_mport.so file.</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 =
face=3DArial><span
lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:Arial'>&nbsp;</span></font></p>

<p><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:
Arial'>Can anybody tell me what it&#8217;s my problem?</span></font></p>

<p><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:
Arial'>Thank you very much.</span></font></p>

<p><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:10.0pt;font-family:
Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Juan.</span></font></p>

</div>

</body>

</html>

------=_NextPart_000_0002_01C2ED42.C9938D30--
