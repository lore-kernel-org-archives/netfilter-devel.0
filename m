From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 2.6] ipt_hashlimit: use | instead of & for correct hash key
Date: Sun, 13 Mar 2005 17:38:10 +0100
Message-ID: <20050313163810.GJ28014@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bg2esWel0ueIH/G/"
Cc: netfilter-devel@lists.netfilter.org
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--Bg2esWel0ueIH/G/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the followign trivial fix, Thanks

Signed-off-by: Harald Welte <laforge@netfilter.org>

--- linux-2.6-old/net/ipv4/netfilter/ipt_hashlimit.c	(revision 3678)
+++ linux-2.6/net/ipv4/netfilter/ipt_hashlimit.c	(working copy)
@@ -112,7 +112,7 @@
 static inline u_int32_t
 hash_dst(const struct ipt_hashlimit_htable *ht, const struct dsthash_dst *=
dst)
 {
-	return (jhash_3words(dst->dst_ip, (dst->dst_port<<16 & dst->src_port),=20
+	return (jhash_3words(dst->dst_ip, (dst->dst_port<<16 | dst->src_port),=20
 			     dst->src_ip, ht->rnd) % ht->cfg.size);
 }
=20
--=20
- Harald Welte <laforge@gnumonks.org>          	        http://gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--Bg2esWel0ueIH/G/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCNGxyXaXGVTD0i/8RAmxBAJ49ZxfziCS5n6nARp2QGRjWl9JeVACfetGZ
6M0e1PIcgM6DB4E4M7EtyGw=
=SRJh
-----END PGP SIGNATURE-----

--Bg2esWel0ueIH/G/--
