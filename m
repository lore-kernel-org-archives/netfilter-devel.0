From: "Juan Torres" <islero77@telefonica.net>
Subject: RV: Problems installing Netfilter extensions
Date: Fri, 20 Jun 2003 06:52:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000901c336e7$bb9b5390$0300000a@juan>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_000A_01C336F8.7F242390"
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

------=_NextPart_000_000A_01C336F8.7F242390
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit


	Hi!!

	I'm trying to install a Netfilter extension, mport, but it
doesn't work

	I make all the steps that comes on the Netfilter Extensions
HOWTO, but, when I try to use the new match, it appears an error saying
that it doesn't exists the libipt_mport.so file, I have observed that
there are the ipt_mport.c and ipt_mport.h files, but no this other file.

	I think that the problem is because I can't make the last step
explained in the documentation, where is written:

		Once your new kernel is installed, you can go ahead and
compile and install the "iptables" package, from the "userspace/"
directory as follows:
			# make all install

	This last step doesn't work!! When I execute this command in the
userspace/ subdirectory inside the patch-o-matic directory, It appears
an error saying that It can't find the "all" option (or something
similar), I have proved to do "make all" and "make install", but it
doesn't work anyway


	What I'm not doing properly??


Maybe this is not the best list to send this message, but in the
Netfilter-users list nobody could help me...


	Than you very much



------=_NextPart_000_000A_01C336F8.7F242390
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
<TITLE>RV: Problems installing Netfilter extensions</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->
<BR>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"es">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT =
SIZE=3D2 FACE=3D"Arial">Hi</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"><FONT SIZE=3D2 =
FACE=3D"Arial">!!</FONT></SPAN></P>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"es">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT =
SIZE=3D2 FACE=3D"Arial">I&#8217;m trying to install a Netfilter =
extension, mport, but it doesn&#8217;t work</FONT></SPAN></P>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">I make all the steps that comes on the Netfilter =
Extensions HOWTO, but, when I try to use the new match, it appears an =
error saying that it doesn&#8217;t exists the libipt_mport.so file, I =
have observed that there are the ipt_mport.c and ipt_mport.h files, but =
no this other file.</FONT></SPAN></P>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">I think that the problem is because I can&#8217;t make =
the last step explained in the documentation, where is =
written:</FONT></SPAN></P>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">Once your new kernel is installed, you can go ahead and =
compile and install the &#8220;iptables&#8221; package, from the =
&#8220;userspace/&#8221; directory as follows:</FONT></SPAN></P>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial"># make all install</FONT></SPAN></P>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT =
SIZE=3D2 FACE=3D"Arial">This last step doesn&#8217;t work!! When I =
execute this command in the userspace/ subdirectory inside the =
patch-o-matic directory, It appears an error saying that It can&#8217;t =
find the &#8220;all&#8221; option (or something similar), I have =
proved</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">to do</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"> <FONT SIZE=3D2 =
FACE=3D"Arial">&#8220;</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">make all</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">&#8221;</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 FACE=3D"Arial"> =
and</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"en-gb"> <FONT SIZE=3D2 FACE=3D"Arial">&#8220;</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">make install</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">&#8221;</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">, but it doesn</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">&#8217;</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"en-gb"><FONT =
SIZE=3D2 FACE=3D"Arial">t work anyway</FONT></SPAN><SPAN =
LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>
<BR>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">What I&#8217;m not doing properly??</FONT></SPAN></P>
<BR>

<P ALIGN=3DJUSTIFY><SPAN LANG=3D"en-gb"><FONT SIZE=3D2 =
FACE=3D"Arial">Maybe this is not the best list to send this message, but =
in</FONT></SPAN><SPAN LANG=3D"es"></SPAN><SPAN LANG=3D"es"></SPAN><SPAN =
LANG=3D"en-gb"> <FONT SIZE=3D2 FACE=3D"Arial">the Netfilter-users list =
nobody could help me...</FONT></SPAN></P>
<BR>

<P ALIGN=3DJUSTIFY><SPAN =
LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">Than you very much</FONT></SPAN></P>
<BR>

</BODY>
</HTML>
------=_NextPart_000_000A_01C336F8.7F242390--
