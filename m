From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] locking optimization in ip_conntrack_core
Date: Mon, 29 Mar 2004 12:36:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329103651.GD1528@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O98KdSgI27dgYlM5"
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


--O98KdSgI27dgYlM5
Content-Type: multipart/mixed; boundary="qFgkTsE6LiHkLPZw"
Content-Disposition: inline


--qFgkTsE6LiHkLPZw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the first in a set of 2.6.x optimization patches.  Obviosly,
they are meant for 2.6.6, not 2.6.5.  Please apply to your tree, thanks.

A: Pablo Neira
D: This patch puts tightens up a lock protected section in
D: ip_ct_refresh()

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qFgkTsE6LiHkLPZw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-03-02 01:02=
:41.000000000 +0100
+++ linux-2.6.3-patched/net/ipv4/netfilter/ip_conntrack_core.c	2004-03-02 2=
3:06:40.000000000 +0100
@@ -1158,18 +1158,18 @@
 {
 	IP_NF_ASSERT(ct->timeout.data =3D=3D (unsigned long)ct);
=20
-	WRITE_LOCK(&ip_conntrack_lock);
 	/* If not in hash table, timer will not be active yet */
 	if (!is_confirmed(ct))
 		ct->timeout.expires =3D extra_jiffies;
 	else {
+		WRITE_LOCK(&ip_conntrack_lock);
 		/* Need del_timer for race avoidance (may already be dying). */
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires =3D jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
 		}
+		WRITE_UNLOCK(&ip_conntrack_lock);
 	}
-	WRITE_UNLOCK(&ip_conntrack_lock);
 }
=20
 /* Returns new sk_buff, or NULL */

--qFgkTsE6LiHkLPZw--

--O98KdSgI27dgYlM5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZ/xDXaXGVTD0i/8RAjQtAKCNhGiTxf97cHqh71jLAgRfQc5wswCfdIU3
cmrsrFU0merY5cTmPYbx4Z0=
=iskV
-----END PGP SIGNATURE-----

--O98KdSgI27dgYlM5--
