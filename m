From: "Wojciech Maj" <wojtektm@poczta.fm>
Subject: How to match CLOSE or TIME_WAIT state
Date: Fri, 3 Jan 2003 22:01:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000801c2b36b$53036840$060110ac@localdomain>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0005_01C2B373.B3A2D840"
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

------=_NextPart_000_0005_01C2B373.B3A2D840
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable

Hi all

I would like to know, how to match packets which have TIME_WAIT (etc..) =
state (I need to match packets which are related with already closed =
connection - which "close" connection).
It is impossible to do with state or conntrack module, but I think It =
would be easy to do after few changes in these modules.=20
I don't know netfilter code enough, so I can't do that.
Would anybody help me?  PLEASE HELP !

Thanks in advance

Wojtek=20

(Forgive me my English please)







------=_NextPart_000_0005_01C2B373.B3A2D840
Content-Type: text/html;
	charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Diso-8859-2" =
http-equiv=3DContent-Type>
<META content=3D"MSHTML 5.00.2614.3500" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3D"Arial CE" size=3D2>Hi all</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3D"Arial CE" size=3D2>I would like to know, how to match =
packets=20
which have TIME_WAIT (etc..) state (I need to</FONT><FONT face=3D"Arial =
CE"=20
size=3D2> match packets which are related with already closed connection =
- which=20
"close" connection).</FONT></DIV>
<DIV><FONT face=3D"Arial CE" size=3D2>It is impossible to do with state =
or conntrack=20
module, but I think It would be easy to do after few changes in these =
modules.=20
</FONT></DIV>
<DIV><FONT face=3D"Arial CE" size=3D2>I don't know netfilter code =
enough, so I can't=20
do that.</FONT></DIV>
<DIV><FONT face=3D"Arial CE" size=3D2>Would anybody help me?</FONT><FONT =

face=3D"Arial CE" size=3D2>&nbsp; PLEASE HELP !</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3D"Arial CE" size=3D2>Thanks in advance</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3D"Arial CE" size=3D2>Wojtek </FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT face=3D"Arial CE" size=3D2>(Forgive me my English =
please)</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV></BODY></HTML>


<TABLE cellPadding=3D"3" bgColor=3D"#ffffff"><TBODY><TR><TD style=3D"font: 12px Courier New, Courier, monotype.com; padding: 3px; background: #ffffff; color: #000000">----------------------------------------------------------------------
<BR>
Oficjalny serwis Polskiej Reprezentacji Skoczkow Narciarskich!
<BR>
&gt;&gt;&gt; <A href=3D"http://link.interia.pl/f16b1">http://link.interia.pl/f16b1</a></TD></TR></TBODY></TABLE>

------=_NextPart_000_0005_01C2B373.B3A2D840--
