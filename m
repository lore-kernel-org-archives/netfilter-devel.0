From: "Moshe Ashkenazi" <moshea@checkpoint.com>
Subject: libipq question
Date: Thu, 22 Apr 2004 11:04:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002b01c42848$de0914f0$9b281dc2@luli>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_002C_01C42859.A191E4F0"
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

------=_NextPart_000_002C_01C42859.A191E4F0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, List -
 
I'm using QUEUE target in order to send TCP packets to user space, using
"IPQ_COPY_PACKET" I'm telling the kernel that I want the entire packet.
 
I know that the kernel send to user space the following structure
"ipq_packet_msg_t", and this structure include the payload member which
include the optional packet data.
 
When I'm examining the content of the payload array I see that it
include the following:
20 bytes IP header -> 20 bytes TCP header, and 20 bytes????
 
My questions are:
1.	What should the payload include?
2.	What are the last 20 bytes in the payload?
 
Example of payload array:
----- Optional packet data -----
45 10  0 3c f8 f8 40  0 3f  6 6f 64 c2 1d 28 90
c0 a8 27 f9 82 e7  4 d2 cf 1f 40 f5  0  0  0  0
a0  2 16 d0 f7 eb  0  0  2  4  5 b4  4  2  8  a
16 20 b8  d  0  0  0  0  1  3  3  0

------=_NextPart_000_002C_01C42859.A191E4F0
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">


<meta name=3DProgId content=3DWord.Document>
<meta name=3DGenerator content=3D"Microsoft Word 10">
<meta name=3DOriginator content=3D"Microsoft Word 10">
<link rel=3DFile-List href=3D"cid:filelist.xml@01C42859.A0E85E80">
<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:DoNotRelyOnCSS/>
 </o:OfficeDocumentSettings>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:SpellingState>Clean</w:SpellingState>
  <w:GrammarState>Clean</w:GrammarState>
  <w:DocumentKind>DocumentEmail</w:DocumentKind>
  <w:EnvelopeVis/>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:ApplyBreakingRules/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
  </w:Compatibility>
  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>
 </w:WordDocument>
</xml><![endif]-->
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;
	text-underline:single;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;
	text-underline:single;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	mso-style-noshow:yes;
	mso-ansi-font-size:10.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:Arial;
	mso-ascii-font-family:Arial;
	mso-hansi-font-family:Arial;
	mso-bidi-font-family:Arial;
	color:windowtext;}
span.SpellE
	{mso-style-name:"";
	mso-spl-e:yes;}
span.GramE
	{mso-style-name:"";
	mso-gram-e:yes;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:545415424;
	mso-list-type:hybrid;
	mso-list-template-ids:2002321388 67698703 67698713 67698715 67698703 =
67698713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
-->
</style>
<!--[if gte mso 10]>
<style>
 /* Style Definitions */=20
 table.MsoNormalTable
	{mso-style-name:"Table Normal";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-parent:"";
	mso-padding-alt:0in 5.4pt 0in 5.4pt;
	mso-para-margin:0in;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:"Times New Roman";}
</style>
<![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple =
style=3D'tab-interval:.5in'>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Hi, List &#8211;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>I&#8217;m using QUEUE target in order to send TCP packets to =
user space,
using &#8220;IPQ_COPY_PACKET&#8221; I&#8217;m telling the kernel that I =
want
the entire packet.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>I know that the kernel send to user space the following =
structure &#8220;<span
class=3DSpellE>ipq_packet_msg_t</span>&#8221;, and this structure =
include the
payload member which include the optional packet =
data.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>When I&#8217;m examining the content of the payload array I see =
that it
include the following:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><span class=3DGramE><font size=3D3 face=3D"Times =
New Roman"><span
style=3D'font-size:12.0pt'>20 bytes IP header -&gt; 20 bytes TCP header, =
and 20 bytes????</span></font></span><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>My questions are:<o:p></o:p></span></font></p>

<ol style=3D'mso-margin-top-alt:0in' start=3D1 type=3D1>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1;tab-stops:list =
.5in'><font
     size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>What should
     the payload include?<o:p></o:p></span></font></li>
 <li class=3DMsoNormal style=3D'mso-list:l0 level1 lfo1;tab-stops:list =
.5in'><font
     size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt'>What are the last
     20 bytes in the payload?<o:p></o:p></span></font></li>
</ol>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>Example of payload array:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>----- Optional packet data -----<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>45 <span class=3DGramE>10<span style=3D'mso-spacerun:yes'>&nbsp; =
</span>0</span>
3c f8 <span class=3DSpellE>f8</span> 40<span =
style=3D'mso-spacerun:yes'>&nbsp;
</span>0 3f<span style=3D'mso-spacerun:yes'>&nbsp; </span>6 6f 64 c2 1d =
28 90<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>c0 a8 27 f9 82 <span class=3DGramE>e7<span
style=3D'mso-spacerun:yes'>&nbsp; </span>4</span> d2 <span =
class=3DSpellE>cf</span>
1f 40 f5<span style=3D'mso-spacerun:yes'>&nbsp; </span>0<span
style=3D'mso-spacerun:yes'>&nbsp; </span><span =
class=3DSpellE>0</span><span
style=3D'mso-spacerun:yes'>&nbsp; </span><span =
class=3DSpellE>0</span><span
style=3D'mso-spacerun:yes'>&nbsp; </span><span =
class=3DSpellE>0</span><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>a0<span style=3D'mso-spacerun:yes'>&nbsp; </span>2 16 d0 f7 =
<span
class=3DSpellE>eb</span><span style=3D'mso-spacerun:yes'>&nbsp; =
</span>0<span
style=3D'mso-spacerun:yes'>&nbsp; </span><span =
class=3DSpellE>0</span><span
style=3D'mso-spacerun:yes'>&nbsp; </span>2<span =
style=3D'mso-spacerun:yes'>&nbsp;
</span>4<span style=3D'mso-spacerun:yes'>&nbsp; </span>5 b4<span
style=3D'mso-spacerun:yes'>&nbsp; </span>4<span =
style=3D'mso-spacerun:yes'>&nbsp;
</span>2<span style=3D'mso-spacerun:yes'>&nbsp; </span>8<span
style=3D'mso-spacerun:yes'>&nbsp; </span>a<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>16 20 <span class=3DGramE>b8<span =
style=3D'mso-spacerun:yes'>&nbsp; </span>d</span><span
style=3D'mso-spacerun:yes'>&nbsp; </span>0<span =
style=3D'mso-spacerun:yes'>&nbsp;
</span><span class=3DSpellE>0</span><span =
style=3D'mso-spacerun:yes'>&nbsp; </span><span
class=3DSpellE>0</span><span style=3D'mso-spacerun:yes'>&nbsp; =
</span><span
class=3DSpellE>0</span><span style=3D'mso-spacerun:yes'>&nbsp; =
</span>1<span
style=3D'mso-spacerun:yes'>&nbsp; </span>3<span =
style=3D'mso-spacerun:yes'>&nbsp;
</span><span class=3DSpellE>3</span><span =
style=3D'mso-spacerun:yes'>&nbsp;
</span>0<o:p></o:p></span></font></p>

</div>

</body>

</html>

------=_NextPart_000_002C_01C42859.A191E4F0--
