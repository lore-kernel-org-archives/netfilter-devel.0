From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4 8/10]: Fix truncated fragment check in ipt_unclean
Date: Mon, 21 Jun 2004 21:54:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621195433.GA24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xRyWJh9hklcBVNcB"
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


--xRyWJh9hklcBVNcB
Content-Type: multipart/mixed; boundary="Wj6ursgR4TQyKGvE"
Content-Disposition: inline


--Wj6ursgR4TQyKGvE
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.4 fixes the truncated fragment check in ipt_unclean.
The check for length % 8 == 0 is performed on the total length of
the packet instead of the data length.

Author: Patrick McHardy <kaber@trash.net>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Wj6ursgR4TQyKGvE
Content-Type: text/plain; charset=us-ascii; name="08.diff"
Content-Disposition: inline; filename="08.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:49:42+02:00 kaber@trash.net=20
#   [NETFILTER]: Fix truncated fragment check in ipt_unclean
#=20
# net/ipv4/netfilter/ipt_unclean.c
#   2004/06/20 22:49:39+02:00 kaber@trash.net +2 -3
#   [NETFILTER]: Fix truncated fragment check in ipt_unclean
#=20
diff -Nru a/net/ipv4/netfilter/ipt_unclean.c b/net/ipv4/netfilter/ipt_uncle=
an.c
--- a/net/ipv4/netfilter/ipt_unclean.c	2004-06-20 23:02:57 +02:00
+++ b/net/ipv4/netfilter/ipt_unclean.c	2004-06-20 23:02:57 +02:00
@@ -467,9 +467,8 @@
 	/* Fragment checks. */
=20
 	/* CHECK: More fragments, but doesn't fill 8-byte boundary. */
-	if ((ntohs(iph->frag_off) & IP_MF)
-	    && (ntohs(iph->tot_len) % 8) !=3D 0) {
-		limpk("Truncated fragment %u long.\n", ntohs(iph->tot_len));
+	if ((ntohs(iph->frag_off) & IP_MF) && datalen % 8 !=3D 0) {
+		limpk("Truncated fragment %u long.\n", datalen);
 		return 0;
 	}
=20


--Wj6ursgR4TQyKGvE--

--xRyWJh9hklcBVNcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zz5XaXGVTD0i/8RAnw0AJ432vX7uRM6h6Jhyu92GUB664GM7QCeKbcD
4ySgSpZGHHtZgqpzytEBhoY=
=YT1t
-----END PGP SIGNATURE-----

--xRyWJh9hklcBVNcB--
