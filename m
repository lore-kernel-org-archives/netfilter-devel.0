From: "Piszcz, Justin Michael" <justin.piszcz@mitretek.org>
Subject: RE: NAT for IPv6 FINISHED!!!!!
Date: Wed, 26 May 2004 08:26:38 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5D3C2276FD64424297729EB733ED1F76061006FA@email1.mitretek.org>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C4431C.BEEA138F"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Natty McButterpants" <ipv6natlover@yahoo.com>,
        <netfilter-devel@lists.netfilter.org>
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

------_=_NextPart_001_01C4431C.BEEA138F
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Very nice!

Will this be merged into 2.4 / 2.6 after testing/etc?

=20

________________________________

From: netfilter-devel-admin@lists.netfilter.org
[mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf Of Natty
McButterpants
Sent: Monday, May 24, 2004 5:19 PM
To: netfilter-devel@lists.netfilter.org
Subject: NAT for IPv6 FINISHED!!!!!

=20

Gentlemen,

     We have finished the NAT development for IPv6.  It properly
translates ICMPv6, UDP, and TCP packets.  We still need to clean up the
code, perform a few more tests and what not.  We used ping6,
traceroute6, and rlogin along with Ethereal and staring at a lot of
tcpdump hex output in order to test the NAT.  We have not yet ported
over support for application level stuff like TFTP, FTP, etc, but it
does not appear to be too difficult and we may get that out at some
point.  Additionally, we need to compile in DNAT support into the
ip6tables user-space tool, as right now SNAT is all that is compiled in.
The code is rough, but it works, and as soon as we get it annotated and
cleaned up into a tarball, we'll send it out to whomever wants it. =20

=20

In response to Jozsef Kadlecsik's question:

>     I hope this work is based on Yasuyuki Kozakai's nf_conntrack
>generalization...
>
>Best regards,
>Jozsef

     Yes, we used USAGI's 2.6.5 kernel with their included connection
tracking suite to develop and test our NAT.  We only had to make a few
minor modifications.

=20

=20

=20

________________________________

Do you Yahoo!?
Friends. Fun. Try the all-new Yahoo! Messenger
<http://messenger.yahoo.com/>=20


------_=_NextPart_001_01C4431C.BEEA138F
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]-->
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
	{color:blue;
	text-decoration:underline;}
p
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dblue>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Very =
nice!<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Will this be merged into 2.4 / 2.6 =
after
testing/etc?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font =
size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font =
size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
netfilter-devel-admin@lists.netfilter.org =
[mailto:netfilter-devel-admin@lists.netfilter.org]
<b><span style=3D'font-weight:bold'>On Behalf Of </span></b>Natty =
McButterpants<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Monday, May 24, =
2004 5:19 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b>
netfilter-devel@lists.netfilter.org<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> NAT for IPv6
FINISHED!!!!!</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>Gentlemen,<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;&nbsp;&nbsp;&nbsp; We have finished the NAT development =
for
IPv6.&nbsp; It properly translates ICMPv6, UDP, and TCP packets.&nbsp; =
We still
need to clean up the code, perform a few more tests and what not.&nbsp; =
We used
ping6, traceroute6, and rlogin along with Ethereal and staring at a lot =
of
tcpdump hex output in order to test the NAT.&nbsp; We have not yet =
ported over
support for application level stuff like TFTP, FTP, etc, but it does not =
appear
to be too difficult and we may get that out at some point.&nbsp; =
Additionally,
we need to compile in DNAT support into the ip6tables user-space tool, =
as right
now SNAT is all that is compiled in.&nbsp; The code is rough, but it =
works, and
as soon as we get it annotated and cleaned up into a tarball, we'll send =
it out
to whomever wants it.&nbsp; <o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>In response to Jozsef Kadlecsik's =
question:<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&gt;&nbsp;&nbsp;&nbsp;&nbsp; I hope this work is based on =
Yasuyuki
Kozakai's nf_conntrack<br>
&gt;generalization...<br>
&gt;<br>
&gt;Best regards,<br>
&gt;Jozsef<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;&nbsp;&nbsp;&nbsp; Yes, we used USAGI's 2.6.5 kernel with =
their
included connection tracking suite to develop and test our NAT.&nbsp; We =
only
had to make a few minor modifications.<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font =
size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D1 width=3D"100%" align=3Dcenter>

</span></font></div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Do you Yahoo!?<br>
Friends. Fun. <a href=3D"http://messenger.yahoo.com/">Try the all-new =
Yahoo!
Messenger</a></span></font><o:p></o:p></p>

</div>

</body>

</html>

------_=_NextPart_001_01C4431C.BEEA138F--
