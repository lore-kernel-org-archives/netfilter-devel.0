From: "Martin Sperl" <martin.sperl@ucpag.com>
Subject: RE: strange effects of DNAT in connection with policy routing
Date: Tue, 25 Jun 2002 08:46:40 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <8FD16F6B8AC4B6499BE151D339AEEFD690EC9E@vie-dc1.vienna.ucpag.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.samba.org>
content-class: urn:content-classes:message
To: "Sneppe Filip" <Filip.Sneppe@cronos.be>,
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

Dear Filip!
=20
Of all the possibilities you have described using iptables non will not
work with the policy routing code for a simple reason:
=20
If I would do it the way you have described with SNAT rules for the
return path - there is still the same problem:
SNAT is only allowed in POSTROUTING - so no way around the problem
either...
=20
The only other possibility is fastnat - as you have described-, but this
would not help when both IP's (A.A.A.2 and B.B.B.2)=20
should be accessible with the mentioned setup... (which is just for a
week of transision)
=20
So I maintain that iptable-NAT and policy routing (based on
source-adress) with the current setup is not feasable as the automatic
reverse rule
for DNAT is applied after ROUTING (it seems to happen at the beginning
of POSTROUTING). Simmilar SNAT can only be applied in POSTROUTING which
makes policy routing (again based on source) for a SNAT-ed frame
impossible...
=20
Is there a way to change this behaviour for DNAT? - I did have a brief
look at the code and could not find where the automatic reverse rule
takes effect!
As for SNAT I think it should be also possible to apply SNAT in
PREROUTING...
=20
Ideas?
               Martin

-----Original Message-----
From: Sneppe Filip [mailto:Filip.Sneppe@cronos.be]
Sent: Montag, 24. Juni 2002 17:55
To: Martin Sperl; netfilter-devel@lists.samba.org
Subject: RE: strange effects of DNAT in connection with policy routing



Martin Sperl [ mailto:martin.sperl@ucpag.com
<mailto:martin.sperl@ucpag.com> ] wrote:
>
>BUT the flow with NAT for a request to B.B.B.2 is like this:
>
>Machine        SRCIP      DESTIP      =20
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
>
>So for incoming packets of a flow DNAT is first, but for return packets
>in the flow routing is first.
>This is where our problem lies...
>
>I hope you now understand our problem!
>

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
basically two approaches to implementing NAT:
 - either you do it by maintaining state, and try to take into
   account all kinds of weird stuff like NAT protocol helpers for
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
