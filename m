From: "Sneppe Filip" <Filip.Sneppe@cronos.be>
Subject: RE: strange effects of DNAT in connection with policy routing
Date: Mon, 24 Jun 2002 16:32:49 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <E131E9F1848D0148813EAF06A846608F615DD1@w2ks-e2k.iconos.be>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C21B8C.03F12640"
Return-path: <netfilter-devel-admin@lists.samba.org>
content-class: urn:content-classes:message
To: "Martin Sperl" <martin.sperl@ucpag.com>,
	<netfilter-devel@lists.samba.org>
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

------_=_NextPart_001_01C21B8C.03F12640
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Martin Sperl [mailto:martin.sperl@ucpag.com] wrote:
>
>We are currently experiencing strange problems with DNAT in conjunction
>with policy routing and think that we have found a bug somewhere!
>
...
>
>ip tables -t nat -I PREROUTING 1 -d B.B.B.2/32 -j DNAT --to-destination
>A.A.A.2
>
>And now the routing is as follows:
>
>using A.A.A.2 the FW routes packets to GW.A
>using B.B.B.2 the FW routes packets to GW.A
>
>SO it seems that the NAT-ed adresses are not passed to the routing core
>of Linux and thus the original adresses
>are used for the routing policy...
>
>Did we do something wrong, or is it a bug?
>
Hi Martin,

AFAIK, if I understand your setup, this is not a bug, but just an
example of how the system works.

netfilter/iptables works independently from the routing code, hence=20
the routing code does not know about any netfilter manipulations
like NAT.

If you look at a part of the netfilter diagram:


  packet in -----> PREROUTING ----> (policy) routing ----> FORWARD --...
                                            |
                                            V
                                          INPUT

You DNAT B.B.B.2 to A.A.A.2 in PREROUTING, hence to the routing code,
it will appear as if the packet comes from A.A.A.2. Your policy
routing rules/tables will make the reply go out via the A.A.A.2
address, as per your request.

So it's a feature or whatever you want to call it :-), but not=20
really a bug. If you want to achieve something special, maybe this
discussion should be taken to the netfilter list, or lartc.

Regards,
Filip

ps. The routing code has NAT too, it's little trickiet to get to
grips with than netfilter NAT, but maybe it can solve your problem.






------_=_NextPart_001_01C21B8C.03F12640
Content-Type: text/html;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3DWindows-1252">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.0.5762.3">
<TITLE>RE: strange effects of DNAT in connection with policy =
routing</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>Martin Sperl [<A =
HREF=3D"mailto:martin.sperl@ucpag.com">mailto:martin.sperl@ucpag.com</A>]=
 wrote:<BR>
&gt;<BR>
&gt;We are currently experiencing strange problems with DNAT in =
conjunction<BR>
&gt;with policy routing and think that we have found a bug =
somewhere!<BR>
&gt;<BR>
...<BR>
&gt;<BR>
&gt;ip tables -t nat -I PREROUTING 1 -d B.B.B.2/32 -j DNAT =
--to-destination<BR>
&gt;A.A.A.2<BR>
&gt;<BR>
&gt;And now the routing is as follows:<BR>
&gt;<BR>
&gt;using A.A.A.2 the FW routes packets to GW.A<BR>
&gt;using B.B.B.2 the FW routes packets to GW.A<BR>
&gt;<BR>
&gt;SO it seems that the NAT-ed adresses are not passed to the routing =
core<BR>
&gt;of Linux and thus the original adresses<BR>
&gt;are used for the routing policy...<BR>
&gt;<BR>
&gt;Did we do something wrong, or is it a bug?<BR>
&gt;<BR>
Hi Martin,<BR>
<BR>
AFAIK, if I understand your setup, this is not a bug, but just an<BR>
example of how the system works.<BR>
<BR>
netfilter/iptables works independently from the routing code, hence<BR>
the routing code does not know about any netfilter manipulations<BR>
like NAT.<BR>
<BR>
If you look at a part of the netfilter diagram:<BR>
<BR>
<BR>
&nbsp; packet in -----&gt; PREROUTING ----&gt; (policy) routing ----&gt; =
FORWARD --...<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; V<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; INPUT<BR>
<BR>
You DNAT B.B.B.2 to A.A.A.2 in PREROUTING, hence to the routing =
code,<BR>
it will appear as if the packet comes from A.A.A.2. Your policy<BR>
routing rules/tables will make the reply go out via the A.A.A.2<BR>
address, as per your request.<BR>
<BR>
So it's a feature or whatever you want to call it :-), but not<BR>
really a bug. If you want to achieve something special, maybe this<BR>
discussion should be taken to the netfilter list, or lartc.<BR>
<BR>
Regards,<BR>
Filip<BR>
<BR>
ps. The routing code has NAT too, it's little trickiet to get to<BR>
grips with than netfilter NAT, but maybe it can solve your problem.<BR>
<BR>
<BR>
<BR>
<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C21B8C.03F12640--
