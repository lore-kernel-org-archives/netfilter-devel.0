From: Hazan Shlomi <Shlomi.Hazan@tadirantele.com>
Subject: overall flow
Date: Tue, 11 Feb 2003 10:26:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <B9268ADB5AE6D21196350008C72B66770943520A@aphrodite.ecitele.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C2D1A7.420C2130"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
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

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_001_01C2D1A7.420C2130
Content-Type: text/plain;
	charset="iso-8859-1"

Hi,

I am new to the netfilter/iptables and I'dd like to NAT some.
what exactly is the flow regarding the different tables?

is 'prerouting' always precedes 'input'?
which of the tables is prior? 'prerouting' for "mangle", or 'prerouting' for
"nat"?

I need help getting the full picture, as you can c...

10x.

------_=_NextPart_001_01C2D1A7.420C2130
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
5.5.2652.35">
<TITLE>overall flow</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=3D2 FACE=3D"Arial">Hi,</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">I am new to the netfilter/iptables and =
I'dd like to NAT some.</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Arial">what exactly is the flow regarding =
the different tables?</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">is 'prerouting' always precedes =
'input'?</FONT>
<BR><FONT SIZE=3D2 FACE=3D"Arial">which of the tables is prior? =
'prerouting' for &quot;mangle&quot;, or 'prerouting' for =
&quot;nat&quot;?</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">I need help getting the full picture, =
as you can c...</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">10x.</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C2D1A7.420C2130--
