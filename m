From: "Wojciech Maj" <wojtektm@poczta.onet.pl>
Subject: problem with iplimit
Date: Wed, 23 Oct 2002 22:41:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <03c501c27ad4$9e5ac740$060110ac@localdomain>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_03C2_01C27AE5.61C20580"
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

------=_NextPart_000_03C2_01C27AE5.61C20580
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable


At first, I'd like to thank You for Your reply...

> What kind of machine are you using? Is it a SMP box?=20

It is single processor system based on AMD K6-2 with 128 MB RAM (non =
ECC).There weren't
any problems with this system before.

>Is there any particular circumstance when the problem happens? =20

The problem appears every time I try to use this module.=20
I tried to find a reason (by changing setup etc.), but I didn't manage =
(I think it is not settings matter).=20
Simply, I want to limit number of parallel connections opened by =
specified host on specified port.=20
if I set --limit-above to 2 and try to open third connection, system =
will drop it (ok).=20
But if I try to open this connection again (while previous 2 connections =
are still active), system will accept it (!).=20
Since, almost every connection will be accepted (!).
Note that if I close all connections, and try to make described test =
again, all will happen again.

(the same problem was described by ROMP romp@siil.net on iptables user =
mailinglist )

>Are you sure that connection tracking does really have=20
> a record for all of the already existing connections (try listing
> /proc/net/ip_conntrack)?

I didn't check it yet (in all cases), but I think all connections were =
recognized correctly.

Can You tell me what is wrong?

thanks in advace

             Wojtek

------=_NextPart_000_03C2_01C27AE5.61C20580
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
<DIV><FONT face=3D"Arial CE" size=3D2>
<DIV>
<DIV>&nbsp;</DIV>
<DIV>At first, I'd like to thank You for Your reply...</DIV></DIV>
<DIV>&nbsp;</DIV>
<DIV>&gt; What kind of machine are you using? Is it a SMP box? </DIV>
<DIV><BR>It is single processor system based on AMD K6-2 with 128 MB RAM =
(non=20
ECC).There weren't</DIV>
<DIV>any problems with this system before.</DIV>
<DIV>&nbsp;</DIV>
<DIV>&gt;Is there any particular circumstance when the problem =
happens?&nbsp;=20
</DIV>
<DIV>&nbsp;</DIV>
<DIV>The problem appears every time I try to use this module. <BR>I =
tried to=20
find a reason (by changing setup etc.), but I didn't manage (I think it =
is not=20
settings matter). <BR>Simply, I&nbsp;want to limit number of parallel=20
connections opened by specified host on specified port. <BR>if I set=20
--limit-above to 2 and try to open third connection, system will drop it =
(ok).=20
<BR>But if I try to open this connection again (while previous 2 =
connections are=20
still active), system will accept it (!). <BR>Since, almost every =
connection=20
will be accepted (!).</DIV>
<DIV>Note that if I close all connections, and try to make described =
test again,=20
all will happen again.</DIV>
<DIV>&nbsp;</DIV>
<DIV>(the same problem was described by ROMP <A=20
href=3D"mailto:romp@siil.net">romp@siil.net</A>&nbsp;on iptables user =
mailinglist=20
)</DIV>
<DIV>&nbsp;</DIV>
<DIV>&gt;Are you sure that connection tracking does really have <BR>&gt; =
a=20
record for all of the already existing connections (try listing<BR>&gt;=20
/proc/net/ip_conntrack)?</DIV>
<DIV>&nbsp;</DIV>
<DIV>I didn't check it yet (in all cases), but I think all connections =
were=20
recognized correctly.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Can You tell me what is wrong?</DIV>
<DIV>&nbsp;</DIV>
<DIV>thanks in advace</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;=20
Wojtek</DIV></FONT></DIV></BODY></HTML>

------=_NextPart_000_03C2_01C27AE5.61C20580--
