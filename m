From: "Juan Torres" <islero77@telefonica.net>
Subject: Easy question: Steps to use my own match
Date: Fri, 20 Jun 2003 03:03:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000201c336c7$bb463c40$0300000a@juan>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0003_01C336D8.7ECF0C40"
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

------=_NextPart_000_0003_01C336D8.7ECF0C40
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit


	Hello:

	I have a question, I'm trying to create my own match for
iptables, now I have made the ipt_mymatch.c, ipt_mymatch.h and
libipt_mymatch.so files, and I want to know if it's going to work only
compiling it (the gcc........ command) or if it's necessary to change
any other file, or to do something different. And, in this case, What
are the steps that I have to do?


	Thank you very much!!



------=_NextPart_000_0003_01C336D8.7ECF0C40
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
<TITLE>Easy question: Steps to use my own match</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->
<BR>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">Hello</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"><FONT SIZE=3D2 =
FACE=3D"Arial">:</FONT></SPAN></P>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"es">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT =
SIZE=3D2 FACE=3D"Arial">I have a question, I</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">&#8217;</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">m trying to</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT =
SIZE=3D2 FACE=3D"Arial">create my own match for =
iptables,</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">now I have</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">made</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> =
the</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> ipt_mymatch.c, =
ipt_mymatch.</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">h</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">and</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> =
libipt_mymatch.so files,</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> =
and</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> I want to know =
if</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> it</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">&#8217;</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">s going to work only</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT =
SIZE=3D2 FACE=3D"Arial">compiling it (the gcc.</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">....... command) or if it</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">&#8217;</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">s necessary to change any other file, =
or</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"en-gb"> <FONT SIZE=3D2 FACE=3D"Arial">to</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT =
SIZE=3D2 FACE=3D"Arial">do something different</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">.</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial"></FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">A</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">nd, in this case, What are the steps that I have to =
do?</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>
<BR>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">Thank you very much!!</FONT></SPAN></P>
<BR>

</BODY>
</HTML>
------=_NextPart_000_0003_01C336D8.7ECF0C40--
