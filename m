From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] fix compilation of ip_nat_snmp_basic.c
Date: Sun, 1 Aug 2004 19:29:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801172915.GF14539@sunbeam2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RE3pQJLXZi4fr8Xo"
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


--RE3pQJLXZi4fr8Xo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please sumbit before 2.6.8-final, this just moves some code in order to
make gcc happy.

Thanks!

Signed-off-by: Adrian Bunk <bunk@fs.tum.de>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--- linux-2.6.7-mm6-full-gcc3.4/net/ipv4/netfilter/ip_nat_snmp_basic.c.old	=
2004-07-09 02:18:23.000000000 +0200
+++ linux-2.6.7-mm6-full-gcc3.4/net/ipv4/netfilter/ip_nat_snmp_basic.c	2004=
-07-09 02:21:00.000000000 +0200
@@ -862,6 +862,77 @@
 	return 1;
 }
=20
+/*=20
+ * Fast checksum update for possibly oddly-aligned UDP byte, from the
+ * code example in the draft.
+ */
+static void fast_csum(unsigned char *csum,
+                      const unsigned char *optr,
+                      const unsigned char *nptr,
+                      int odd)
+{
+	long x, old, new;
+=09
+	x =3D csum[0] * 256 + csum[1];
+=09
+	x =3D~ x & 0xFFFF;
+=09
+	if (odd) old =3D optr[0] * 256;
+	else old =3D optr[0];
+=09
+	x -=3D old & 0xFFFF;
+	if (x <=3D 0) {
+		x--;
+		x &=3D 0xFFFF;
+	}
+=09
+	if (odd) new =3D nptr[0] * 256;
+	else new =3D nptr[0];
+=09
+	x +=3D new & 0xFFFF;
+	if (x & 0x10000) {
+		x++;
+		x &=3D 0xFFFF;
+	}
+=09
+	x =3D~ x & 0xFFFF;
+	csum[0] =3D x / 256;
+	csum[1] =3D x & 0xFF;
+}
+
+/*=20
+ * Mangle IP address.
+ * 	- begin points to the start of the snmp messgae
+ *      - addr points to the start of the address
+ */
+static inline void mangle_address(unsigned char *begin,
+                                  unsigned char *addr,
+                                  const struct oct1_map *map,
+                                  u_int16_t *check)
+{
+	if (map->from =3D=3D NOCT1(*addr)) {
+		u_int32_t old;
+	=09
+		if (debug)
+			memcpy(&old, (unsigned char *)addr, sizeof(old));
+		=09
+		*addr =3D map->to;
+	=09
+		/* Update UDP checksum if being used */
+		if (*check) {
+			unsigned char odd =3D !((addr - begin) % 2);
+		=09
+			fast_csum((unsigned char *)check,
+			          &map->from, &map->to, odd);
+			         =20
+		}
+	=09
+		if (debug)
+			printk(KERN_DEBUG "bsalg: mapped %u.%u.%u.%u to "
+			       "%u.%u.%u.%u\n", NIPQUAD(old), NIPQUAD(*addr));
+	}
+}
+
 static unsigned char snmp_trap_decode(struct asn1_ctx *ctx,
                                       struct snmp_v1_trap *trap,
                                       const struct oct1_map *map,
@@ -952,77 +1023,6 @@
 	printk("\n");
 }
=20
-/*=20
- * Fast checksum update for possibly oddly-aligned UDP byte, from the
- * code example in the draft.
- */
-static void fast_csum(unsigned char *csum,
-                      const unsigned char *optr,
-                      const unsigned char *nptr,
-                      int odd)
-{
-	long x, old, new;
-=09
-	x =3D csum[0] * 256 + csum[1];
-=09
-	x =3D~ x & 0xFFFF;
-=09
-	if (odd) old =3D optr[0] * 256;
-	else old =3D optr[0];
-=09
-	x -=3D old & 0xFFFF;
-	if (x <=3D 0) {
-		x--;
-		x &=3D 0xFFFF;
-	}
-=09
-	if (odd) new =3D nptr[0] * 256;
-	else new =3D nptr[0];
-=09
-	x +=3D new & 0xFFFF;
-	if (x & 0x10000) {
-		x++;
-		x &=3D 0xFFFF;
-	}
-=09
-	x =3D~ x & 0xFFFF;
-	csum[0] =3D x / 256;
-	csum[1] =3D x & 0xFF;
-}
-
-/*=20
- * Mangle IP address.
- * 	- begin points to the start of the snmp messgae
- *      - addr points to the start of the address
- */
-static inline void mangle_address(unsigned char *begin,
-                                  unsigned char *addr,
-                                  const struct oct1_map *map,
-                                  u_int16_t *check)
-{
-	if (map->from =3D=3D NOCT1(*addr)) {
-		u_int32_t old;
-	=09
-		if (debug)
-			memcpy(&old, (unsigned char *)addr, sizeof(old));
-		=09
-		*addr =3D map->to;
-	=09
-		/* Update UDP checksum if being used */
-		if (*check) {
-			unsigned char odd =3D !((addr - begin) % 2);
-		=09
-			fast_csum((unsigned char *)check,
-			          &map->from, &map->to, odd);
-			         =20
-		}
-	=09
-		if (debug)
-			printk(KERN_DEBUG "bsalg: mapped %u.%u.%u.%u to "
-			       "%u.%u.%u.%u\n", NIPQUAD(old), NIPQUAD(*addr));
-	}
-}
-
 /*
  * Parse and mangle SNMP message according to mapping.
  * (And this is the fucking 'basic' method).


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RE3pQJLXZi4fr8Xo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDShrXaXGVTD0i/8RAvh9AJ48RNOdbDf4DEzfTKmymiljD8xS1QCePXQF
76Z/8WaqwBWc+D7KTJxFy6o=
=ww6E
-----END PGP SIGNATURE-----

--RE3pQJLXZi4fr8Xo--
