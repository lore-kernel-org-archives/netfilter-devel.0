From: "Martin Sperl" <martin.sperl@ucpag.com>
Subject: strange effects of DNAT in connection with policy routing
Date: Mon, 24 Jun 2002 15:08:01 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <8FD16F6B8AC4B6499BE151D339AEEFD690EC9A@vie-dc1.vienna.ucpag.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.samba.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

We are currently experiencing strange problems with DNAT in conjunction
with policy routing and think that we have found a bug somewhere!

The setup is as follows:

2 Uplink gws (GW.A,GW.B) with 2 ip ranges (say A.A.A.0/24 anf
B.B.B.0/24)

One firewall setup like this:
policy routing is set up like this:
ip route add default via GW.A table 100
ip rule add from A.A.A.0/24 to default prio 100 table 100
ip route add default via GW.B table 200
ip rule add from B.B.B.0/24 to default prio 200 table 200

got one host behind with 2 Addresses assigned for A.A.A.2 and B.B.B.2

Now connecting from the outside works fine for both IP adresses.
(Forwarding works)

using A.A.A.2 the FW routes return-packets to GW.A
using B.B.B.2 the FW routes return-packets to GW.B

NOW we activate DESTINATION NAT
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

ip tables -t nat -I PREROUTING 1 -d B.B.B.2/32 -j DNAT --to-destination
A.A.A.2

And now the routing is as follows:

using A.A.A.2 the FW routes packets to GW.A
using B.B.B.2 the FW routes packets to GW.A

SO it seems that the NAT-ed adresses are not passed to the routing core
of Linux and thus the original adresses
are used for the routing policy...

Did we do something wrong, or is it a bug?

Any Ideas?

Ciao,
	Martin

P.s: This behaviour shows up on linux 2.4.9 and 2.4.17 (stock)
