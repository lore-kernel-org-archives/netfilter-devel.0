From: "Glover George" <dime@gulfsales.com>
Subject: RE: MSN v/s Iptables !
Date: Mon, 24 Jun 2002 08:17:17 -0500
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <002901c21b81$796cf4b0$7200a8c0@blue>
References: <A5EBA754022DD411928400D0B774BB520133BCCC@email.masconit.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_002A_01C21B57.9096ECB0"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "'Rajeev Jain'" <rajeevj@EMAIL.masconit.com>,
	<netfilter-devel@lists.samba.org>
In-Reply-To: <A5EBA754022DD411928400D0B774BB520133BCCC@email.masconit.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_002A_01C21B57.9096ECB0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

I haven't seen this, but also don't know how it would work.  MSN
encapsulates the local ip of the machine behind the firewall in the data
packet.  And especially if this ip address is in the private ip range,
iptables isn't going to be able to handle it with out a packet mangling
module.  Because the machine outside the firewall is going to try to
connect to the ip address that was in the packet, not the source ip of
the packet it came in on.  What you need is
http://linux-igd.sourceforge.net <http://linux-igd.sourceforge.net/> .
Give that a try, don't mean to plug other software on this list, but it
is related, and as of yet this is the only clean way to do it.
 
Glover George
Systems/Networks Administrator
Gulf Sales & Supply, Inc.
dime@gulfsales.com
(228)-762-0268
 
-----Original Message-----
From: netfilter-devel-admin@lists.samba.org
[mailto:netfilter-devel-admin@lists.samba.org] On Behalf Of Rajeev Jain
Sent: Friday, June 21, 2002 5:26 PM
To: 'netfilter-devel@lists.samba.org'
Subject: MSN v/s Iptables !
 
Hi, 
I read some document about allowing MSN voice using Iptables and setup
the following commented ruleset in my firewall rules startup file. I did
it manually too but didn't help.
Could you please take a look at the ruleset below and advice me the
correct order OR ruleset to allow MSN voice chat ? 
I would really appreciate your reply. 
Thanks 
Rajeev 
 
$EXTIF=eth0=12.12.12.12 (Public IP) 
$INTIF=eth1=192.168.1.1 (Private IP of Router) 
# 
echo "   clearing any existing rules and setting default policy.." 
$IPTABLES -P INPUT ACCEPT 
$IPTABLES -F INPUT 
$IPTABLES -P OUTPUT ACCEPT 
$IPTABLES -F OUTPUT 
$IPTABLES -P FORWARD DROP 
$IPTABLES -F FORWARD 
$IPTABLES -t nat -F 
echo "   FWD: Allow all connections OUT and only existing and related
ones IN" 
$IPTABLES -A FORWARD -i $EXTIF -o $INTIF -m state --state
ESTABLISHED,RELATED -j ACCEPT 
$IPTABLES -A FORWARD -i $INTIF -o $EXTIF -j ACCEPT 
$IPTABLES -A FORWARD -j LOG 
#echo " Allow MSN Messenger connection " 
#$IPTABLES -A FORWARD -p TCP --dport 1863 -j ACCEPT 
#$IPTABLES -A FORWARD -p TCP --dport 7801:7825 -j ACCEPT 
#$IPTABLES -A FORWARD -p TCP --dport 6891:6900 -j ACCEPT 
#$IPTABLES -A FORWARD -d 64.4.13.0/24 -j ACCEPT 
echo "   Enabling SNAT (MASQUERADE) functionality on $EXTIF" 
$IPTABLES -t nat -A POSTROUTING -o $EXTIF -j MASQUERADE 
echo -e "\nrc.firewall-2.4 v$FWVER done.\n" 

------=_NextPart_000_002A_01C21B57.9096ECB0
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
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
<link rel=3DFile-List href=3D"cid:filelist.xml@01C21B57.89627130">
<title>MSN v/s Iptables !</title>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"PersonName"/>
<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:DoNotRelyOnCSS/>
 </o:OfficeDocumentSettings>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:DocumentKind>DocumentEmail</w:DocumentKind>
  <w:EnvelopeVis/>
  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>
 </w:WordDocument>
</xml><![endif]--><!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:553679495 -2147483648 8 0 66047 0;}
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
p.MsoAutoSig, li.MsoAutoSig, div.MsoAutoSig
	{margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
p
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
span.EmailStyle18
	{mso-style-type:personal-reply;
	mso-style-noshow:yes;
	mso-ansi-font-size:10.0pt;
	mso-bidi-font-size:10.0pt;
	font-family:Arial;
	mso-ascii-font-family:Arial;
	mso-hansi-font-family:Arial;
	mso-bidi-font-family:Arial;
	color:navy;}
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

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'>I haven&#8217;t seen this, but also =
don&#8217;t
know how it would work.<span style=3D'mso-spacerun:yes'>&nbsp; =
</span>MSN encapsulates
the local ip of the machine behind the firewall in the data packet. =
<span
style=3D'mso-spacerun:yes'>&nbsp;</span>And especially if this ip =
address is in the
private ip range, iptables isn&#8217;t going to be able to handle it =
with out a
packet mangling module.<span style=3D'mso-spacerun:yes'>&nbsp; =
</span>Because the
machine outside the firewall is going to try to connect to the ip =
address that
was in the packet, not the source ip of the packet it came in on. <span
style=3D'mso-spacerun:yes'>&nbsp;</span>What you need is <a
href=3D"http://linux-igd.sourceforge.net/">http://linux-igd.sourceforge.n=
et</a>. <span
style=3D'mso-spacerun:yes'>&nbsp;&nbsp;</span>Give that a try, =
don&#8217;t mean to plug
other software on this list, but it is related, and as of yet this is =
the only
clean way to do it.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoAutoSig><font size=3D3 color=3Dnavy face=3D"Times New =
Roman"><span
style=3D'font-size:12.0pt;color:navy;mso-no-proof:yes'>Glover =
George<o:p></o:p></span></font></p>

<p class=3DMsoAutoSig><font size=3D3 color=3Dnavy face=3D"Times New =
Roman"><span
style=3D'font-size:12.0pt;color:navy;mso-no-proof:yes'>Systems/Networks
Administrator<o:p></o:p></span></font></p>

<p class=3DMsoAutoSig><font size=3D3 color=3Dnavy face=3D"Times New =
Roman"><span
style=3D'font-size:12.0pt;color:navy;mso-no-proof:yes'>Gulf Sales &amp; =
Supply,
Inc.<o:p></o:p></span></font></p>

<p class=3DMsoAutoSig><st1:PersonName><font size=3D3 color=3Dnavy
 face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt;color:navy;mso-no-proof:
 yes'>dime@gulfsales.com</span></font></st1:PersonName><font =
color=3Dnavy><span
style=3D'color:navy;mso-no-proof:yes'><o:p></o:p></span></font></p>

<p class=3DMsoAutoSig><font size=3D3 color=3Dnavy face=3D"Times New =
Roman"><span
style=3D'font-size:12.0pt;color:navy;mso-no-proof:yes'>(228)-762-0268<o:p=
></o:p></span></font></p>

</div>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D2 =
face=3DTahoma><span
style=3D'font-size:10.0pt;font-family:Tahoma'>-----Original =
Message-----<br>
<b><span style=3D'font-weight:bold'>From:</span></b> =
netfilter-devel-admin@lists.samba.org
[mailto:netfilter-devel-admin@lists.samba.org] <b><span =
style=3D'font-weight:
bold'>On Behalf Of </span></b>Rajeev Jain<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Friday, June 21, =
2002 5:26
PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b>
'netfilter-devel@lists.samba.org'<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> MSN v/s Iptables =
!</span></font></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D3 =
face=3D"Times New Roman"><span
style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>Hi,</span></font> =
<o:p></o:p></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>I read some =
document about
allowing MSN voice using Iptables and setup the following commented =
ruleset in
my firewall rules startup file. I did it manually too but didn't =
help.</span></font><o:p></o:p></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>Could you please =
take a look
at the ruleset below and advice me the correct order OR ruleset to allow =
MSN
voice chat ?</span></font> <o:p></o:p></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>I would really =
appreciate
your reply.</span></font> <o:p></o:p></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Thanks</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>Rajeev</span></font>
<o:p></o:p></p>

<p class=3DMsoNormal style=3D'margin-left:.5in'><font size=3D3 =
face=3D"Times New Roman"><span
style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>$EXTIF=3Deth0=3D12.12.12.12
(Public IP)</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier =
New"'>$INTIF=3Deth1=3D192.168.1.1
(Private IP of Router)</span></font> <o:p></o:p></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>#</span></font> =
<br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>echo
&quot;&nbsp;&nbsp; clearing any existing rules and setting default
policy..&quot;</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-P INPUT ACCEPT</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-F INPUT </span></font><br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-P OUTPUT ACCEPT</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-F OUTPUT </span></font><br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-P FORWARD DROP</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-F FORWARD </span></font><br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-t nat -F</span></font> <o:p></o:p></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>echo =
&quot;&nbsp;&nbsp; FWD:
Allow all connections OUT and only existing and related ones =
IN&quot;</span></font>
<br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-A FORWARD -i $EXTIF -o $INTIF -m state --state ESTABLISHED,RELATED -j =
ACCEPT</span></font>
<br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-A FORWARD -i $INTIF -o $EXTIF -j ACCEPT</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-A FORWARD -j LOG</span></font> <o:p></o:p></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>#echo &quot; Allow =
MSN
Messenger connection &quot;</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>#$IPTABLES
-A FORWARD -p TCP --dport 1863 -j ACCEPT</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>#$IPTABLES
-A FORWARD -p TCP --dport 7801:7825 -j ACCEPT</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>#$IPTABLES
-A FORWARD -p TCP --dport 6891:6900 -j ACCEPT</span></font> <br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>#$IPTABLES
-A FORWARD -d 64.4.13.0/24 -j ACCEPT</span></font> <o:p></o:p></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>echo =
&quot;&nbsp;&nbsp;
Enabling SNAT (MASQUERADE) functionality on $EXTIF&quot;</span></font> =
<br>
<font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;font-family:"Courier New"'>$IPTABLES
-t nat -A POSTROUTING -o $EXTIF -j MASQUERADE</span></font> =
<o:p></o:p></p>

<p style=3D'margin-left:.5in'><font size=3D2 face=3D"Courier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>echo -e
&quot;\nrc.firewall-2.4 v$FWVER done.\n&quot;</span></font> =
<o:p></o:p></p>

</div>

</body>

</html>

------=_NextPart_000_002A_01C21B57.9096ECB0--
