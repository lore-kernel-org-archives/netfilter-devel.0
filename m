From: "Davide Guerri" <tatonet@tiscali.it>
Subject: Re: NAT for IPv6 FINISHED!!!!!
Date: Wed, 26 May 2004 19:28:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <011301c44346$e0e7dd00$0400000a@majinbu>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_010E_01C44357.A439BE80"
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

------=_NextPart_000_010E_01C44357.A439BE80
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Yasuyuki,
how do you handle ipv6 fragment? It is possible to know original =
fragments
size?

BTW, some time ago I have finished my first version of NA(P)T-PT but I =
wrote
my own connection tracking code (I had expires and I could not wait for =
an
IPv6 conntrack that could handle fragmentation).

However my connection tracking code isn't that different from yours so, =
with
minimal effort, I can remove it and use your code when (and if) it will =
meet
my requirements.

My NA(P)T-PT supports fragmentation (on IPv4 and IPv6 side), preserves =
the
DF(IPv4) and Fragment Header(IPv6) semantics (it is possible to do path =
MTU
discovery throught it and it can handle fragments correctly with DF flag
set) and, for now, it works like the masquerade: it's unidiretional, in =
the
sense that connections may start only from IPv6 side, and IPv4 source
address (for IPv6 to IPv4 translations) is calculated dinamically.
Unfortunately to handle fragments correctly, I have had to re-write =
parts of
kernel fragmentation/defragmentation code, so I'm not that proud of my =
code
;)

Best regards,
Davide Guerri.

----- Original Message -----=20
From: "Yasuyuki Kozakai" <yasuyuki.kozakai@toshiba.co.jp>
To: <ipv6natlover@yahoo.com>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Wednesday, May 26, 2004 4:01 PM
Subject: Re: NAT for IPv6 FINISHED!!!!!

> [...]
> I think your work is useful when someone writes NAT-PT with conntrack
> because we can see how generalization is needed.
> [...]
> I revised nf_conntrack to able to handle fragmented IPv6 packets and
> I'm debugging now. After committing and more testing it, I'll delete
> ip6_conntrack from USAGI tree.
> [...]
> P.S. By the way, what situation do you want to use NAT with IPv6 ?

------=_NextPart_000_010E_01C44357.A439BE80
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2800.1400" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2><FONT face=3D"Times New Roman" =
size=3D3>Hi=20
Yasuyuki,<BR>how do you handle ipv6 fragment? It is possible to know =
original=20
fragments<BR>size?<BR><BR>BTW, some time ago I have finished my first =
version of=20
NA(P)T-PT but I wrote<BR>my own connection tracking code (I had expires =
and I=20
could not wait for an<BR>IPv6 conntrack that could handle=20
fragmentation).<BR><BR>However my connection tracking code isn't that =
different=20
from yours so, with<BR>minimal effort, I can remove it and use your code =
when=20
(and if) it will meet<BR>my requirements.<BR><BR>My NA(P)T-PT supports=20
fragmentation (on IPv4 and IPv6 side), preserves the<BR>DF(IPv4) and =
Fragment=20
Header(IPv6) semantics (it is possible to do path MTU<BR>discovery =
throught it=20
and it can handle fragments correctly with DF flag<BR>set) and, for now, =
it=20
works like the masquerade: it's unidiretional, in the<BR>sense that =
connections=20
may start only from IPv6 side, and IPv4 source<BR>address (for IPv6 to =
IPv4=20
translations) is calculated dinamically.<BR>Unfortunately to handle =
fragments=20
correctly, I have had to re-write parts of<BR>kernel=20
fragmentation/defragmentation code, so I'm not that proud of my=20
code<BR>;)<BR><BR>Best regards,<BR>Davide Guerri.<BR><BR>----- Original =
Message=20
----- <BR>From: "Yasuyuki Kozakai" &lt;</FONT><A=20
href=3D"mailto:yasuyuki.kozakai@toshiba.co.jp"><FONT face=3D"Times New =
Roman"=20
size=3D3>yasuyuki.kozakai@toshiba.co.jp</FONT></A><FONT face=3D"Times =
New Roman"=20
size=3D3>&gt;<BR>To: &lt;</FONT><A =
href=3D"mailto:ipv6natlover@yahoo.com"><FONT=20
face=3D"Times New Roman" size=3D3>ipv6natlover@yahoo.com</FONT></A><FONT =

face=3D"Times New Roman" size=3D3>&gt;<BR>Cc: &lt;</FONT><A=20
href=3D"mailto:netfilter-devel@lists.netfilter.org"><FONT face=3D"Times =
New Roman"=20
size=3D3>netfilter-devel@lists.netfilter.org</FONT></A><FONT=20
face=3D"Times New Roman" size=3D3>&gt;<BR>Sent: Wednesday, May 26, 2004 =
4:01=20
PM<BR>Subject: Re: NAT for IPv6 FINISHED!!!!!<BR><BR>&gt; [...]<BR>&gt; =
I think=20
your work is useful when someone writes NAT-PT with conntrack<BR>&gt; =
because we=20
can see how generalization is needed.<BR>&gt; [...]<BR>&gt; I revised=20
nf_conntrack to able to handle fragmented IPv6 packets and<BR>&gt; I'm =
debugging=20
now. After committing and more testing it, I'll delete<BR>&gt; =
ip6_conntrack=20
from USAGI tree.<BR>&gt; [...]<BR>&gt; P.S. By the way, what situation =
do you=20
want to use NAT with IPv6 ?</FONT><BR></FONT></DIV></BODY></HTML>

------=_NextPart_000_010E_01C44357.A439BE80--
