From: "Juan Torres" <islero77@telefonica.net>
Subject: How to change a match options
Date: Tue, 8 Apr 2003 13:42:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000001c2fdc3$fd33ddc0$0300000a@juan>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0001_01C2FDD4.C0BCADC0"
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

------=_NextPart_000_0001_01C2FDD4.C0BCADC0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit


Hi, I want to make my own match, but before, to understand how it works,
I'm modifying an existing match, ipt_multiport to be precise, so, I have
changed the ipt_multiport.c file. But now I want to change the match
writing options (for example, to add a new option similar than -dport,
or to make that it wouldn't be necessary to write any option) So I need
to know which file I have to modify to change the "writing options" of a
match.

Thanks a lot.

	Juan



------=_NextPart_000_0001_01C2FDD4.C0BCADC0
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.0.4630.0">
<TITLE>How to change a match options</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->
<BR>

<P ALIGN=3DJUSTIFY><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">Hi,</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 FACE=3D"Arial">I =
want to make my own match, but before, to understand how it =
works,</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">I</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">&#8217;</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial">m =
modifying</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">an existing</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> =
match,</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">ipt_multiport to be precise</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">,</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">s</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial">o, =
I have changed</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">the ipt_multiport.c file. But now I want to =
change</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">the match writing options (for =
example,</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">to add a new option similar than</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT =
SIZE=3D2 FACE=3D"Arial">&#8211;</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">dport</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">, or to make that it wouldn</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">&#8217;</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">t be nece</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">s</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">sary to write any option</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">) So I need to know which file I have to =
modify</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> =
to change the</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">&#8220;</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">writing</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">options</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">&#8221;</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> =
of a match</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">.</FONT></SPAN></P>

<P ALIGN=3DJUSTIFY><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">Thanks a lot.</FONT></SPAN></P>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">Juan</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>
<BR>

</BODY>
</HTML>
------=_NextPart_000_0001_01C2FDD4.C0BCADC0--
