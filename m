From: "Martin Sperl" <martin.sperl@ucpag.com>
Subject: RE: strange effects of DNAT in connection with policy routing
Date: Mon, 24 Jun 2002 17:18:13 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <8FD16F6B8AC4B6499BE151D339AEEFD690EC9C@vie-dc1.vienna.ucpag.net>
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

Hi Filip!
=20
Still the strange thing is that my DNAT rule is in the nat PREROUTING
table
and so the packets should be natted BEFORE being passed to the routing
functions of the kernel.
=20
This works that way for an incoming connection, but the return path of
these connections is not NAT'ed back to the original IP's in PREROUTING
but (as it looks) in POSTROUTING
=20
So the flow without NAT for a request to A.A.A.2 is like this:
=20
Machine        SRCIP      DESTIP       =20
GW.A           a.b.c.d    A.A.A.2
FW-eth0        a.b.c.d    A.A.A.2
  routing occures here
FW-eth2        a.b.c.d    A.A.A.2
HOST           a.b.c.d    A.A.A.2
and the reply packet:
HOST           A.A.A.2    a.b.c.d
FW-eth2        A.A.A.2    a.b.c.d
  routing occures here
FW-eth0        A.A.A.2    a.b.c.d
GW.A           A.A.A.2    a.b.c.d
=20
 =20
And the flow without NAT for a request to B.B.B.2 is like this:
=20
Machine        SRCIP      DESTIP       =20
GW.B           a.b.c.d    B.B.B.2
FW-eth1        a.b.c.d    B.B.B.2
  routing occures here
FW-eth2        a.b.c.d    B.B.B.2
HOST           a.b.c.d    B.B.B.2
and the reply packet:
HOST           B.B.B.2    a.b.c.d
FW-eth2        B.B.B.2    a.b.c.d
  routing occures here
FW-eth1        B.B.B.2    a.b.c.d
GW.A           B.B.B.2    a.b.c.d
=20
BUT the flow with NAT for a request to B.B.B.2 is like this:
=20
Machine        SRCIP      DESTIP       =20
GW.B           a.b.c.d    B.B.B.2
FW-eth1        a.b.c.d    B.B.B.2
  DNAT occures here
  routing occures here
FW-eth2        a.b.c.d    A.A.A.2
HOST           a.b.c.d    A.A.A.2
and the reply packet:
HOST           A.A.A.2    a.b.c.d
FW-eth2        A.A.A.2    a.b.c.d
  routing occures here
  DNAT occures here (reverse)
FW-eth0        B.B.B.2    a.b.c.d
GW.A           B.B.B.2    a.b.c.d
   AND THIS SHOULD NOT HAPPEN...
=20
So for incoming packets of a flow DNAT is first, but for return packets
in the flow routing is first.
This is where our problem lies...
=20
I hope you now understand our problem!
=20
Ciao,
        Martin
=20

-----Original Message-----
From: Sneppe Filip [mailto:Filip.Sneppe@cronos.be]
Sent: Montag, 24. Juni 2002 16:33
To: Martin Sperl; netfilter-devel@lists.samba.org
Subject: RE: strange effects of DNAT in connection with policy routing



Martin Sperl [ mailto:martin.sperl@ucpag.com
<mailto:martin.sperl@ucpag.com> ] wrote:
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

netfilter/iptables works independently from the routing code, hence
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

So it's a feature or whatever you want to call it :-), but not
really a bug. If you want to achieve something special, maybe this
discussion should be taken to the netfilter list, or lartc.

Regards,
Filip

ps. The routing code has NAT too, it's little trickiet to get to
grips with than netfilter NAT, but maybe it can solve your problem.
