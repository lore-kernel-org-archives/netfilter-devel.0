From: "Amit Kumar Gupta" <amitkumar.gupta@wipro.com>
Subject: Reg Connection Tracking
Date: Thu, 16 Jan 2003 15:09:05 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4223A04BF7D1B941A25246ADD0462FF5683958@blr-m3-msg.wipro.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-f0f2290d-d503-4290-9f02-d13c9badb672"
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

------=_NextPartTM-000-f0f2290d-d503-4290-9f02-d13c9badb672
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C2BD43.1C0ABD26"

------_=_NextPart_001_01C2BD43.1C0ABD26
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Hi List,
=20
I am new to this list and Getting some problem in connection tracking.=20
However, I have put it on Netfilter users list but it is not solved so I
am putting it here for your suggestions.
=20
Well The setup is like this : -
=20
I am having a RG(Residential Gateway) and inhome client. RG is using
Embedix kernel with 2.4.3 sources.
The /proc/sys is not present as CONFIG_SYSCTL is not enabled due to some
reasons. It means there is none of the ip_conntrack_max file present.=20
RG is having IPFILTER as firewall and having iptables rules to allow the
traffic in and outside. RG is having 2 interfaces.
One is internal to connect the RG to inhome.
And Other is external for the internet.=20
=20
When I tries to ping from inhome to RG's external , I don't get reply.
The reason is : - There is a rule on RG's side=20
-m state -state INVALID -j DROP
=20
The ip_conntrack contains 1016 entries and it keeps printing the message
:-=20
ip_conntrack: Maximum limit of 1016 entries exceeded.
=20
Even increasing the value of ip_conntrack_max in the code doesn't help.
The ip_conntrack file consists of all unreplied packets b/w inhome and
RG with icmp request type=3D8 code =3D0 and reply(inverse tuple) =
type=3D0
code=3D0
=20
Similarly the http b/w inhome and RG makes this file full .
=20
I am attaching the conversation which I had it on Netfilter users list.
=20
Please Help.
=20
Thanks & Regards,
Amit Kr. Gupta.
=20
----------------------------------------------------------------------Co
nversation on Netfilter users
list----------------------------------------------------------------
=20
Amit,
=20
This looks like a bug, so I guess you had better take this report to
netfilter-devel with as much info as possible.
=20
Could you also cat a full ip_conntrack to a temp file
and put it somewhere online to accompany your bugreport.
=20
Reporting this to netfilter-devel doesn't guarantee that
you will get a quick solution to your problem
(your setup is quite different from most people's...),
but at least it could be put in the KNOWN-BUGS section
so someone could eventually get around to fixing this...
=20
Regards,
Filip
=20
On Tue, 2003-01-14 at 13:56, Amit Kumar Gupta wrote:
>=20
> Hi List,
>=20
> Again Posting the same question ON the list As I have tried many ways=20
> and didn't get any clues.
>=20
> As soon as I ping from inhome to the RG's internal, It just keep=20
> filling the ip_conntrack file and it goes beyond ip_conntrack_max=20
> entries. I don't know why Internal address is not replying.
>=20
> If Any clues, Please Help.
>=20
> Thanks & Regards,
> Amit
>=20
> -----Original Message-----
> From: Amit Kumar Gupta
> Sent: Saturday, January 11, 2003 10:37 AM
> To: Athan
> Cc: netfilter@lists.netfilter.org
> Subject: RE: Reg iptables Connection tracking
>=20
> Hi,
>=20
> I am using Embedix platform in which If I enable CONFIG_SYSCTL, the=20
> image doesn't come up on the H/w. So I have to disable this.( There=20
> has been some changes in the Kernel to suit this which works fine).=20
> Now in conntrack module I don't have this option so my conntrack=20
> ctl_table will not be registered woth ipv4 table. So I was hardcoding=20
> the value of ip_conntrack_max? Whether it will help?
>=20
> Another issue is I don't have enough memory on the board to have=20
> sysctl command.
>=20
> Can you suggest something which I can do?
>=20
> Regards,
> Amit
>=20
>=20
On Fri, Jan 10, 2003 at 04:04:54PM +0530, Amit Kumar Gupta wrote:
> On Friday 10 January 2003 12:37 am, you wrote:
> > Well I am able to see upto this point. I went through the code flow=20
> > also. But I don't know why it prints the message(Even if increasing=20
> > the value from 1016 to 4096 by hardcoding it in the kernel). Another

> > issue is I don't know how it is taking 1016. As There is no
/proc/sys=20
> > , and by default it shoud take 0.
=20
   I missed this before, sorry.  Is this due to specifically disabling
/proc and/or specifically not mounting it for security reasons?  If not,
just enable it and mount it already.
=20
> Not that this helps much.  The real problem is WHAT is the conntrack
> table filling with.  And I suspect it may be nothing, that you have a=20
> problem because it is trying to use /proc/net/conntrack and there IS
no=20
> /proc/net/conntrack.  The message may be triggering incorrectly,=20
> presuming that since it cannot write another entry to=20
> /proc/net/conntrack that the table is full.
=20
   Er, no.  That's not what /proc/net/ip_conntrack is.  It doesn't EXIST
as such until you try to read from it.  All of /proc is virtual.  Just
because you have no /proc and can't get at 'files' in it doesn't mean
the SOURCE of their data doesn't exist.
=20
> /proc in order to work.  If I think of something else I'll email you
> again.  Sorry.
=20
   I'd certainly recommend having /proc around as well.  There's the
sysctl() interface for querying/changing some values too.  Aha! You can
set net/ipv4/ip_conntrack_max from this too *8-):
=20
      sysctl -w net/ipv4/ip_conntrack_max=3D32768
=20
If your kernel doesn't have the sysctl support then, er, you're kind of
shooting yourself in the foot for tuning things at ALL, including things
like turning IP forwarding on and off, global TCP ECN support, SYN
cookies etc....
=20
HTH,
=20
-Ath
=20
=20
=20
=20
=20
=20
=20

------_=_NextPart_001_01C2BD43.1C0ABD26
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">


<meta name=3DProgId content=3DWord.Document>
<meta name=3DGenerator content=3D"Microsoft Word 10">
<meta name=3DOriginator content=3D"Microsoft Word 10">
<link rel=3DFile-List href=3D"cid:filelist.xml@01C2BD71.3593ADA0">
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"PersonName"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"date"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"time"/>
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
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
  </w:Compatibility>
  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>
 </w:WordDocument>
</xml><![endif]--><!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
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
font-family:Arial'>Hi List,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I am new to this list and <span =
class=3DGramE>Getting</span>
some problem in connection tracking. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>However, I have put it on Netfilter users list but it =
is not
solved so I am putting it here for your =
suggestions.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Well The setup is like <span class=3DGramE>this =
:</span> -<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I am having a <span =
class=3DGramE>RG(</span>Residential
Gateway) and <span class=3DSpellE>inhome</span> client. RG is using =
<span
class=3DSpellE>Embedix</span> kernel with 2.4.3 =
sources.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>The /proc/sys is not present as CONFIG_SYSCTL is not =
enabled
due to some reasons. It means there is none of the <span =
class=3DSpellE>ip_conntrack_max</span>
file present. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>RG is having IPFILTER as firewall and having <span
class=3DSpellE>iptables</span> rules to allow the traffic in and =
outside. RG is
having 2 interfaces.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>One is internal to connect the RG to <span =
class=3DSpellE>inhome</span>.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>And <span class=3DGramE>Other</span> is external for =
the
internet. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>When I tries to ping from <span =
class=3DSpellE>inhome</span>
to <span class=3DSpellE>RG&#8217;s</span> <span class=3DGramE>external =
,</span> I
don&#8217;t get reply.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>The reason <span class=3DGramE>is :</span> - There is =
a rule
on <span class=3DSpellE>RG&#8217;s</span> side =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>-<span class=3DGramE>m</span> state &#8211;state =
INVALID &#8211;j
DROP<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>The <span class=3DSpellE>ip_conntrack</span> contains =
1016
entries and it keeps printing the <span class=3DGramE>message :</span>- =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><span class=3DSpellE><font size=3D2 =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial'>ip_conntrack</span></font></=
span><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'>: Maximum limit
of 1016 entries exceeded.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Even increasing the value of <span =
class=3DSpellE>ip_conntrack_max</span>
in the code doesn&#8217;t help. The <span =
class=3DSpellE>ip_conntrack</span> file
consists of all <span class=3DSpellE>unreplied</span> packets b/w <span
class=3DSpellE>inhome</span> and RG with <span =
class=3DSpellE>icmp</span> request
type=3D8 code =3D0 and <span class=3DGramE>reply(</span>inverse <span =
class=3DSpellE>tuple</span>)
type=3D0 code=3D0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Similarly the http b/w <span =
class=3DSpellE>inhome</span> and
RG makes this file <span class=3DGramE>full =
.</span><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I am attaching the conversation which I had it on =
Netfilter users
list.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Please Help.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Thanks &amp; Regards,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Amit Kr. Gupta.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>------------------------------------------------------=
----------------Conversation
on Netfilter <span class=3DGramE>users</span>
list----------------------------------------------------------------<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Amit,<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>This
looks like a bug, so I guess you had better take this report to <span
class=3DSpellE>netfilter-devel</span> with as much info as =
possible.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Could
you also cat a full <span class=3DSpellE>ip_conntrack</span> to a temp =
<span
class=3DGramE>file</span><o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>and</span></font></span><font size=3D2
face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>
put it somewhere online to accompany your <span =
class=3DSpellE>bugreport</span>.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Reporting
this to <span class=3DSpellE>netfilter-devel</span> doesn't guarantee =
that<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>you</span></font></span><font size=3D2
face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>
will get a quick solution to your problem<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>(<span
class=3DGramE>your</span> setup is quite different from most =
people's...),<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>but</span></font></span><font size=3D2
face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'> at
least it could be put in the KNOWN-BUGS =
section<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>so</span></font></span><font size=3D2
face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>
someone could eventually get around to fixing =
this...<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Regards,<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Filip<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>On
Tue, 2003-01-14 at </span></font><st1:time Hour=3D"13" =
Minute=3D"56"><font size=3D2
 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>13:56</span></font></st1:time><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>,
</span></font><st1:PersonName><font size=3D2 face=3D"Courier New"><span
 style=3D'font-size:10.0pt;font-family:"Courier New"'>Amit Kumar =
Gupta</span></font></st1:PersonName><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>
wrote:<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Hi List,<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Again <span class=3DGramE>Posting</span> the same question ON the list =
As I have
tried many ways <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<span class=3DGramE>and</span> didn't get any =
clues.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
As soon as I ping from <span class=3DSpellE>inhome</span> to the <span
class=3DSpellE>RG's</span> internal, <span class=3DGramE>It</span> just =
keep <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
filling the <span class=3DSpellE>ip_conntrack</span> file and it goes =
beyond <span
class=3DSpellE>ip_conntrack_max</span> <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<span class=3DGramE>entries</span>. I don't know why <span =
class=3DGramE>Internal</span>
address is not replying.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
If <span class=3DGramE>Any</span> clues, Please =
Help.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Thanks &amp; Regards,<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Amit<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
-----Original Message-----<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
From: </span></font><st1:PersonName><font size=3D2 face=3D"Courier =
New"><span
 style=3D'font-size:10.0pt;font-family:"Courier New"'>Amit Kumar =
Gupta</span></font></st1:PersonName><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Sent: </span></font><st1:date Month=3D"1" Day=3D"11" Year=3D"2003"><font =
size=3D2
 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Saturday,
 January 11, 2003</span></font></st1:date><font size=3D2 face=3D"Courier =
New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'> =
</span></font><st1:time
Hour=3D"10" Minute=3D"37"><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
 10.0pt;font-family:"Courier New"'>10:37 =
AM</span></font></st1:time><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
To: </span></font><st1:PersonName><font size=3D2 face=3D"Courier =
New"><span
 style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Athan</span></font></st1:PersonName><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Cc: </span></font><st1:PersonName><font size=3D2 face=3D"Courier =
New"><span
 style=3D'font-size:10.0pt;font-family:"Courier =
New"'>netfilter@lists.netfilter.org</span></font></st1:PersonName><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Subject: RE: <span class=3DSpellE>Reg</span> <span =
class=3DSpellE>iptables</span>
Connection tracking<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
I am using <span class=3DSpellE>Embedix</span> platform in which If I =
enable
CONFIG_SYSCTL, the <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<span class=3DGramE>image</span> doesn't come up on the H/w. So I have =
to disable
this<span class=3DGramE>.(</span> There <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
has been some changes in the Kernel to suit this which works fine). =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Now in <span class=3DSpellE>conntrack</span> module I don't have this =
option so
my <span class=3DSpellE>conntrack</span> <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<span class=3DSpellE><span class=3DGramE>ctl_table</span></span> will =
not be
registered <span class=3DSpellE>woth</span> ipv4 table. So I was <span
class=3DSpellE>hardcoding</span> <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<span class=3DGramE>the</span> value of <span =
class=3DSpellE>ip_conntrack_max</span>?
Whether it will help?<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Another issue is I don't have enough memory on the board to have =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<span class=3DSpellE><span class=3DGramE>sysctl</span></span> =
command.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Can you suggest something which I can do?<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Regards,<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Amit<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>On
</span></font><st1:date Month=3D"1" Day=3D"10" Year=3D"2003"><font =
size=3D2
 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Fri,
 Jan 10, 2003</span></font></st1:date><font size=3D2 face=3D"Courier =
New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'> at =
</span></font><st1:time
Hour=3D"16" Minute=3D"4"><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
 10.0pt;font-family:"Courier =
New"'>04:04:54PM</span></font></st1:time><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>
+0530, </span></font><st1:PersonName><font size=3D2 face=3D"Courier =
New"><span
 style=3D'font-size:10.0pt;font-family:"Courier New"'>Amit Kumar =
Gupta</span></font></st1:PersonName><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>
wrote:<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
On </span></font><st1:date Month=3D"1" Day=3D"10" Year=3D"2003"><font =
size=3D2
 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>Friday
 10 January 2003</span></font></st1:date><font size=3D2 face=3D"Courier =
New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'> =
</span></font><st1:time
Hour=3D"0" Minute=3D"37"><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:
 10.0pt;font-family:"Courier New"'>12:37 =
am</span></font></st1:time><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>,
you wrote:<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
&gt; Well I am able to see <span class=3DSpellE>upto</span> this point. =
I went
through the code flow <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&gt; &gt; also.</span></font></span><font =
size=3D2
face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>
But I don't know why it prints the <span =
class=3DGramE>message(</span>Even if
increasing <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&gt; &gt; the value from 1016 to 4096 by =
<span
class=3DSpellE>hardcoding</span> it in the =
kernel).</span></font></span><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>
Another <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
&gt; issue is I don't know how it is taking 1016. As <span =
class=3DGramE>There</span>
is no /proc/sys <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
&gt; , and by default it <span class=3DSpellE>shoud</span> take =
0.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'><span
style=3D'mso-spacerun:yes'>&nbsp;&nbsp; </span>I missed this before, =
sorry.<span
style=3D'mso-spacerun:yes'>&nbsp; </span>Is this due to specifically =
disabling
/proc and/or specifically not mounting it for security reasons?<span
style=3D'mso-spacerun:yes'>&nbsp; </span>If not, just enable it and =
mount it
already.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
Not that this helps much.<span style=3D'mso-spacerun:yes'>&nbsp; =
</span>The real
problem is WHAT <span class=3DGramE>is the <span =
class=3DSpellE>conntrack</span></span><o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<span class=3DGramE>table</span> filling with.<span
style=3D'mso-spacerun:yes'>&nbsp; </span>And I suspect it may be =
nothing, that
you have a <o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<span class=3DGramE>problem</span> because it is trying to use =
/proc/net/<span
class=3DSpellE>conntrack</span> and there IS no =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&gt; /proc/net/<span =
class=3DSpellE>conntrack</span>.</span></font></span><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'><span
style=3D'mso-spacerun:yes'>&nbsp; </span>The message may be triggering =
incorrectly,
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
presuming that since it cannot write another entry to =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&gt; /proc/net/<span =
class=3DSpellE>conntrack</span>
that the table is full.</span></font></span><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'><span
style=3D'mso-spacerun:yes'>&nbsp;&nbsp; </span><span =
class=3DSpellE>Er</span>,
no.<span style=3D'mso-spacerun:yes'>&nbsp; </span>That's not what =
/proc/net/<span
class=3DSpellE>ip_conntrack</span> is.<span =
style=3D'mso-spacerun:yes'>&nbsp;
</span>It doesn't EXIST as such until you try to read from it.<span
style=3D'mso-spacerun:yes'>&nbsp; </span>All of /proc is virtual.<span
style=3D'mso-spacerun:yes'>&nbsp; </span>Just because you have no /proc =
and can't
get at 'files' in it doesn't mean the SOURCE of their data doesn't =
exist.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&gt; /proc in order to =
work.</span></font></span><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'><span
style=3D'mso-spacerun:yes'>&nbsp; </span>If I think of something else =
I'll email
you<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>&gt;
<span class=3DGramE>again</span>.<span style=3D'mso-spacerun:yes'>&nbsp;
</span>Sorry.<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'><span
style=3D'mso-spacerun:yes'>&nbsp;&nbsp; </span>I'd certainly recommend =
having
/proc around as well.<span style=3D'mso-spacerun:yes'>&nbsp; =
</span>There's the<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><span
class=3DSpellE><span class=3DGramE><font size=3D2 face=3D"Courier =
New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>sysctl</span></font></span></span><span
class=3DGramE><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>(</span></font></span><font size=3D2 =
face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>) interface for
querying/changing some values too.<span =
style=3D'mso-spacerun:yes'>&nbsp;
</span>Aha! You can set net/ipv4/ip_conntrack_max from this too *8<span
class=3DGramE>-)</span>:<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'><span
style=3D'mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span
class=3DSpellE><span class=3DGramE>sysctl</span></span> -w
net/ipv4/ip_conntrack_max=3D32768<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>If
your kernel doesn't have the <span class=3DSpellE>sysctl</span> support =
then, <span
class=3DSpellE>er</span>, you're kind of shooting yourself in the foot =
for tuning
things at ALL, including things like turning IP forwarding on and off, =
global
TCP ECN support, SYN cookies etc....<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>HTH,<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'mso-layout-grid-align:none;text-autospace:none'><font
size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>-<span
class=3DSpellE>Ath</span><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C2BD43.1C0ABD26--


------=_NextPartTM-000-f0f2290d-d503-4290-9f02-d13c9badb672
Content-Type: text/plain;
	name="Wipro_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="Wipro_Disclaimer.txt"

**************************Disclaimer************************************************

Information contained in this E-MAIL being proprietary to Wipro Limited is 
'privileged' and 'confidential' and intended for use only by the individual
 or entity to which it is addressed. You are notified that any use, copying 
or dissemination of the information contained in the E-MAIL in any manner 
whatsoever is strictly prohibited.

***************************************************************************************

------=_NextPartTM-000-f0f2290d-d503-4290-9f02-d13c9badb672--
