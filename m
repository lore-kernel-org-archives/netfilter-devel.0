From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] Fix RST handling in ip_conntrack_proto_tcp.c
Date: Fri, 31 Dec 2004 17:38:56 +0100
Message-ID: <1104511137.3821.20.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-za61lQIpis9ZOrPhoEg3"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-za61lQIpis9ZOrPhoEg3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Jozsef

Your latest patch contained a change to the RST handling.
The change was that an RST is ignored if the previous packet was an ACK.
This is happens all the time. I know it was intended as a fix for the
SYN - ACK probe - RST sequence but it breaks normal usage. The problem
is that connections that end with RST never get their state changed and
are left in ESTABLISHED state with a large timeout.

The patch below adds a check for
!test_bit(IPS_ASSURED_BIT, &conntrack->status) so your change will only
be active for unassured connections. Maybe you have a better idea for
how to fix both cases.

This patch has been tested by a user that reported the problem on irc
and it fixes the problem for him. I'm also running it on a machine with
lots of traffic and it fixes the problem for me as well.

Please make sure something that fixes the problem is submitted fairly
quickly.

<hint> A tcp-state/windowtracking testcase for nfsim would be great
</hint> :)

--- linux-2.6.10-rc3-bk14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c.orig	=
2004-12-30 19:48:33.000000000 +0100
+++ linux-2.6.10-rc3-bk14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-=
12-30 19:49:46.000000000 +0100
@@ -906,7 +906,8 @@ static int tcp_packet(struct ip_conntrac
 		if (index =3D=3D TCP_RST_SET
 		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
 		         && conntrack->proto.tcp.last_index <=3D TCP_SYNACK_SET)
-		        || conntrack->proto.tcp.last_index =3D=3D TCP_ACK_SET)
+		        || (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
+			 && conntrack->proto.tcp.last_index =3D=3D TCP_ACK_SET))
 		    && after(ntohl(th->ack_seq),
 		    	     conntrack->proto.tcp.last_seq)) {
 			/* Ignore RST closing down invalid SYN or ACK

--=20
/Martin

--=-za61lQIpis9ZOrPhoEg3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBB1YCgWm2vlfa207ERApW+AJ440mTRehN7kZ4qY1FsXGi2cL3YZQCeI018
eEZiu3RRJtgi5Ro0FAz2C5o=
=fBpd
-----END PGP SIGNATURE-----

--=-za61lQIpis9ZOrPhoEg3--
