From: "Sneppe Filip" <Filip.Sneppe@cronos.be>
Subject: RE: strange effects of DNAT in connection with policy routing
Date: Mon, 24 Jun 2002 17:55:01 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <E131E9F1848D0148813EAF06A846608F615DD3@w2ks-e2k.iconos.be>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C21B97.7F5A76E4"
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

------_=_NextPart_001_01C21B97.7F5A76E4
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Martin Sperl [mailto:martin.sperl@ucpag.com] wrote:
>=20
>BUT the flow with NAT for a request to B.B.B.2 is like this:
>=20
>Machine        SRCIP      DESTIP       =20
>GW.B           a.b.c.d    B.B.B.2
>FW-eth1        a.b.c.d    B.B.B.2
>  DNAT occures here
>  routing occures here
>FW-eth2        a.b.c.d    A.A.A.2
>HOST           a.b.c.d    A.A.A.2
>and the reply packet:
>HOST           A.A.A.2    a.b.c.d
>FW-eth2        A.A.A.2    a.b.c.d
>  routing occures here
>  DNAT occures here (reverse)
>FW-eth0        B.B.B.2    a.b.c.d
>GW.A           B.B.B.2    a.b.c.d
>   AND THIS SHOULD NOT HAPPEN...
>=20
>So for incoming packets of a flow DNAT is first, but for return packets
>in the flow routing is first.
>This is where our problem lies...
>=20
>I hope you now understand our problem!
>=20

Oops, I forgot to talk about the NAT'ing of the reply packets
in my previous mail, and that's exactly where your problem lies.

What you've just explained is exactly how NAT in iptables/netfilter
is supposed to work, i.e. by tracking the whole session, and doing
the reverse process for reply packets. Again, it's a feature.

One important consequence of this (there are more) is that the
netfilter box has to see the traffic in both directions and NAT
source/destination address accordingly.

Well, that's just the way netfilter/iptables NAT works. If you look
into all the problems you can run into when doing NAT, there are
basically two approaches to implementing NAT:=20
 - either you do it by maintaining state, and try to take into
   account all kinds of weird stuff like NAT protocol helpers for=20
   IP addresses that are embedded in data payloads (eg. tcp).
   Things like tcp/udp port number overlaps are also something
   to take into account, etc.
   This is how iptables does it.
   Also, if you want to keep NAT separated from packet filtering/
   firewalling, you will find that you need to do the reverse
   operation for reply packets, otherwise your firewalling rules
   can become horribly complex.
 - or you don't care about everything too much and implement a
   quick and dirty static NAT that just NATs a source or
   destination address.

The good news is that this other type of NAT is also possible in
Linux via fast-NAT (I think that's how Alexey called it) which is
available in the routig code (check out "ip rule ... nat ..." etc).

Sorry for the initial confusion, I didn't fully understand where
it went wrong in your setup.

Regards,
Filip






------_=_NextPart_001_01C21B97.7F5A76E4
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
&gt;BUT the flow with NAT for a request to B.B.B.2 is like this:<BR>
&gt;<BR>
&gt;Machine&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
SRCIP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
DESTIP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<BR>
&gt;GW.B&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
a.b.c.d&nbsp;&nbsp;&nbsp; B.B.B.2<BR>
&gt;FW-eth1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
a.b.c.d&nbsp;&nbsp;&nbsp; B.B.B.2<BR>
&gt;&nbsp; DNAT occures here<BR>
&gt;&nbsp; routing occures here<BR>
&gt;FW-eth2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
a.b.c.d&nbsp;&nbsp;&nbsp; A.A.A.2<BR>
&gt;HOST&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
a.b.c.d&nbsp;&nbsp;&nbsp; A.A.A.2<BR>
&gt;and the reply packet:<BR>
&gt;HOST&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
A.A.A.2&nbsp;&nbsp;&nbsp; a.b.c.d<BR>
&gt;FW-eth2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
A.A.A.2&nbsp;&nbsp;&nbsp; a.b.c.d<BR>
&gt;&nbsp; routing occures here<BR>
&gt;&nbsp; DNAT occures here (reverse)<BR>
&gt;FW-eth0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
B.B.B.2&nbsp;&nbsp;&nbsp; a.b.c.d<BR>
&gt;GW.A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
B.B.B.2&nbsp;&nbsp;&nbsp; a.b.c.d<BR>
&gt;&nbsp;&nbsp; AND THIS SHOULD NOT HAPPEN...<BR>
&gt;<BR>
&gt;So for incoming packets of a flow DNAT is first, but for return =
packets<BR>
&gt;in the flow routing is first.<BR>
&gt;This is where our problem lies...<BR>
&gt;<BR>
&gt;I hope you now understand our problem!<BR>
&gt;<BR>
<BR>
Oops, I forgot to talk about the NAT'ing of the reply packets<BR>
in my previous mail, and that's exactly where your problem lies.<BR>
<BR>
What you've just explained is exactly how NAT in iptables/netfilter<BR>
is supposed to work, i.e. by tracking the whole session, and doing<BR>
the reverse process for reply packets. Again, it's a feature.<BR>
<BR>
One important consequence of this (there are more) is that the<BR>
netfilter box has to see the traffic in both directions and NAT<BR>
source/destination address accordingly.<BR>
<BR>
Well, that's just the way netfilter/iptables NAT works. If you look<BR>
into all the problems you can run into when doing NAT, there are<BR>
basically two approaches to implementing NAT:<BR>
&nbsp;- either you do it by maintaining state, and try to take into<BR>
&nbsp;&nbsp; account all kinds of weird stuff like NAT protocol helpers =
for<BR>
&nbsp;&nbsp; IP addresses that are embedded in data payloads (eg. =
tcp).<BR>
&nbsp;&nbsp; Things like tcp/udp port number overlaps are also =
something<BR>
&nbsp;&nbsp; to take into account, etc.<BR>
&nbsp;&nbsp; This is how iptables does it.<BR>
&nbsp;&nbsp; Also, if you want to keep NAT separated from packet =
filtering/<BR>
&nbsp;&nbsp; firewalling, you will find that you need to do the =
reverse<BR>
&nbsp;&nbsp; operation for reply packets, otherwise your firewalling =
rules<BR>
&nbsp;&nbsp; can become horribly complex.<BR>
&nbsp;- or you don't care about everything too much and implement a<BR>
&nbsp;&nbsp; quick and dirty static NAT that just NATs a source or<BR>
&nbsp;&nbsp; destination address.<BR>
<BR>
The good news is that this other type of NAT is also possible in<BR>
Linux via fast-NAT (I think that's how Alexey called it) which is<BR>
available in the routig code (check out &quot;ip rule ... nat ...&quot; =
etc).<BR>
<BR>
Sorry for the initial confusion, I didn't fully understand where<BR>
it went wrong in your setup.<BR>
<BR>
Regards,<BR>
Filip<BR>
<BR>
<BR>
<BR>
<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C21B97.7F5A76E4--
