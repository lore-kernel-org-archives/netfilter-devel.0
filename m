From: "Colin Cyrille" <engp2437@nus.edu.sg>
Subject: libipq / packet size
Date: Wed, 7 May 2003 18:54:10 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <6330DC96389A924A804F52FA3848930E888E33@MBXSRV26.stu.nus.edu.sg>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C31486.FD650191"
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

------_=_NextPart_001_01C31486.FD650191
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi everybody
=20
=20
sorry for the newbies question.
=20
I use libipq to implement a udp tunnel.  (since SCTP cannot go through
:-)
=20
so basically the packet I get from QUEUE has to be modified / increased
in=20
size.
=20
i create a new buffer for this. Everything works fine exept that when I=20
return the packet with ipq_set_verdict I obtain a packet with the
modified data=20
but WITH ORIGINAL SIZE. I cant make it having the correct increased
size..=20
so i have a truncated version of what i expect. And weirdly the missing
chunk appears in the linux cooked capture trailer and is sent as
Ethernet trailer...
It's weird since in the return ipq_set_verdict function, i specify the
new size and the location of my new buffer where the modified packet is.

=20
anybody has an idea ?? Is it that the returned packet MUST have the same
size ? Is it that I have to work directly (how ?) on the existing
buffer, increase it size and return it ?
=20
thanks a lot... please help !!
=20
Cyrille

=20


------_=_NextPart_001_01C31486.FD650191
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

<div class=3DSection1><pre><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt'>Hi everybody</span></font></pre><pre><font =
size=3D2
face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>sorry for =
the newbies question.</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>I use =
libipq to implement a udp tunnel.&nbsp; (since SCTP cannot go through =
:-)</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>so =
basically the packet I get from QUEUE has to be modified / increased in =
</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>size.</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>i create =
a new buffer for this. Everything works fine exept that when I =
</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>return =
the packet with ipq_set_verdict I obtain a packet with the modified data =
</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>but WITH =
ORIGINAL SIZE. I cant make it having the correct increased size.. =
</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>so i have =
a truncated version of what i expect. And weirdly the missing chunk =
appears in the linux cooked capture trailer and is sent as Ethernet =
trailer&#8230;</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>It's =
weird since in the return ipq_set_verdict function, i specify the new =
size and the location of my new buffer where the modified packet is. =
</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>anybody =
has an idea ?? Is it that the returned packet MUST have the same size ? =
Is it that I have to work directly (how ?) on the existing buffer, =
increase it size and return it ?</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span style=3D'font-size:10.0pt'>thanks a =
lot&#8230; please help !!</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>&nbsp;</span></font></pre><pre><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt'>Cyrille</span></font></pre>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>&nbsp;</span></font></p>

</div>

</body>

</html>
=00
------_=_NextPart_001_01C31486.FD650191--
