From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 7/14]: don't reroute no mark change in mangle table without CONFIG_IP_ROUTE_FWMARK
Date: Mon, 21 Jun 2004 21:43:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194325.GM24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtBqmokgY1evbO3C"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vtBqmokgY1evbO3C
Content-Type: multipart/mixed; boundary="RU5vHP6eAM91MAfE"
Content-Disposition: inline


--RU5vHP6eAM91MAfE
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 changes iptable_mangle so it won't reroute on nfmark
change when routing by nfmark is not enabled.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RU5vHP6eAM91MAfE
Content-Type: text/plain; charset=us-ascii; name="07.diff"
Content-Disposition: inline; filename="07.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:40:02+02:00 kaber@trash.net=20
#   [NETFILTER]: Don't reroute on nfmark change in mangle table when routin=
g by nfmark is not enabled
#=20
# net/ipv4/netfilter/iptable_mangle.c
#   2004/06/20 22:39:52+02:00 kaber@trash.net +2 -0
#   [NETFILTER]: Don't reroute on nfmark change in mangle table when routin=
g by nfmark is not enabled
#=20
diff -Nru a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptabl=
e_mangle.c
--- a/net/ipv4/netfilter/iptable_mangle.c	2004-06-20 23:00:21 +02:00
+++ b/net/ipv4/netfilter/iptable_mangle.c	2004-06-20 23:00:21 +02:00
@@ -173,7 +173,9 @@
 	if (ret !=3D NF_DROP && ret !=3D NF_STOLEN && ret !=3D NF_QUEUE
 	    && ((*pskb)->nh.iph->saddr !=3D saddr
 		|| (*pskb)->nh.iph->daddr !=3D daddr
+#ifdef CONFIG_IP_ROUTE_FWMARK
 		|| (*pskb)->nfmark !=3D nfmark
+#endif
 		|| (*pskb)->nh.iph->tos !=3D tos))
 		return ip_route_me_harder(pskb) =3D=3D 0 ? ret : NF_DROP;
=20


--RU5vHP6eAM91MAfE--

--vtBqmokgY1evbO3C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zpdXaXGVTD0i/8RAulfAJwIgn5lbxTzynSDXMtYiyFEqVjV7ACeIBB3
LG/xazCqAuFWklKv8a4y0TE=
=W3F3
-----END PGP SIGNATURE-----

--vtBqmokgY1evbO3C--
