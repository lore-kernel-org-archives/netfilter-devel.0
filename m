From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: optimization of ip_ct_selective_cleanup()
Date: Sun, 30 Nov 2003 21:08:06 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130153806.GH26749@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ed/6oDxOLijJh8b0"
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


--ed/6oDxOLijJh8b0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This mail contains the sixth netfilter patch, please apply.

Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Optimized ip_ct_selective_cleanup in order to avoid
order n^2 lookup time of the whole conntrack hash.


diff -urN --exclude-from=3D/usr/src/diff.exclude linux-2.4.22-locking-refco=
unt/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.22-locking-speedup/net=
/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.22-locking-refcount/net/ipv4/netfilter/ip_conntrack_core.c	20=
03-11-14 11:40:31.000000000 +0100
+++ linux-2.4.22-locking-speedup/net/ipv4/netfilter/ip_conntrack_core.c	200=
3-11-14 14:15:05.000000000 +0100
@@ -1288,14 +1288,13 @@
 /* Bring out ya dead! */
 static struct ip_conntrack_tuple_hash *
 get_next_corpse(int (*kill)(const struct ip_conntrack *i, void *data),
-		void *data)
+		void *data, unsigned int *bucket)
 {
 	struct ip_conntrack_tuple_hash *h =3D NULL;
-	unsigned int i;
=20
 	READ_LOCK(&ip_conntrack_lock);
-	for (i =3D 0; !h && i < ip_conntrack_htable_size; i++) {
-		h =3D LIST_FIND(&ip_conntrack_hash[i], do_kill,
+	for (; !h && *bucket < ip_conntrack_htable_size; (*bucket)++) {
+		h =3D LIST_FIND(&ip_conntrack_hash[*bucket], do_kill,
 			      struct ip_conntrack_tuple_hash *, kill, data);
 	}
 	if (h)
@@ -1310,9 +1309,9 @@
 			void *data)
 {
 	struct ip_conntrack_tuple_hash *h;
+	unsigned int bucket =3D 0;
=20
-	/* This is order n^2, by the way. */
-	while ((h =3D get_next_corpse(kill, data)) !=3D NULL) {
+	while ((h =3D get_next_corpse(kill, data, &bucket)) !=3D NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&h->ctrack->timeout))
 			death_by_timeout((unsigned long)h->ctrack);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ed/6oDxOLijJh8b0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/yg7zXaXGVTD0i/8RAu6TAJ9+GlOBaM1vkV6JJTk4vnbGXWZoewCgkENx
M/yTrq/wJ1CZlJ9rcPZbuPA=
=kNH1
-----END PGP SIGNATURE-----

--ed/6oDxOLijJh8b0--
