From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER (3/X): fix mutex declaration
Date: Sat, 24 Jul 2004 10:28:20 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724142820.GM2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yUmmepPgoWmUqRhm"
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


--yUmmepPgoWmUqRhm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

On Sun, Jun 20, 2004 at 01:23:28PM +0200, Christoph Hellwig wrote:
> okay, the gunk we had in arp_tables is in ip6_tables and ip6_tables,
> too. =20

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Harald Welte <laforge@netfilter.org>


=3D=3D=3D=3D=3D include/linux/netfilter_ipv4/ip_tables.h 1.7 vs edited =3D=
=3D=3D=3D=3D
--- 1.8/include/linux/netfilter_ipv4/ip_tables.h	2004-06-19 20:55:10 +02:00
+++ edited/include/linux/netfilter_ipv4/ip_tables.h	2004-06-20 10:25:40 +02=
:00
@@ -338,7 +336,6 @@
  *	Main firewall chains definitions and global var's definitions.
  */
 #ifdef __KERNEL__
-static DECLARE_MUTEX(ipt_mutex);
=20
 #include <linux/init.h>
 extern void ipt_init(void) __init;
=3D=3D=3D=3D=3D include/linux/netfilter_ipv6/ip6_tables.h 1.7 vs edited =3D=
=3D=3D=3D=3D
--- 1.7/include/linux/netfilter_ipv6/ip6_tables.h	2004-06-19 20:55:10 +02:00
+++ edited/include/linux/netfilter_ipv6/ip6_tables.h	2004-06-20 10:26:32 +0=
2:00
@@ -107,10 +107,6 @@
 	u_int64_t pcnt, bcnt;			/* Packet and byte counters */
 };
=20
-#ifdef __KERNEL__
-static DECLARE_MUTEX(ip6t_mutex);
-#endif
-
 /* Values for "flag" field in struct ip6t_ip6 (general ip6 structure). */
 #define IP6T_F_PROTO		0x01	/* Set if rule cares about upper=20
 					   protocols */
=3D=3D=3D=3D=3D net/ipv4/netfilter/ip_tables.c 1.24 vs edited =3D=3D=3D=3D=
=3D
--- 1.24/net/ipv4/netfilter/ip_tables.c	2004-06-07 05:15:04 +02:00
+++ edited/net/ipv4/netfilter/ip_tables.c	2004-06-20 12:29:17 +02:00
@@ -61,6 +61,8 @@
 #endif
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
=20
+static DECLARE_MUTEX(ipt_mutex);
+
 /* Must have mutex */
 #define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) !=3D 0)
 #define ASSERT_WRITE_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) !=3D 0)
=3D=3D=3D=3D=3D net/ipv6/netfilter/ip6_tables.c 1.29 vs edited =3D=3D=3D=3D=
=3D
--- 1.29/net/ipv6/netfilter/ip6_tables.c	2004-06-07 05:15:04 +02:00
+++ edited/net/ipv6/netfilter/ip6_tables.c	2004-06-20 12:29:29 +02:00
@@ -66,6 +66,7 @@
 #endif
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
=20
+static DECLARE_MUTEX(ip6t_mutex);
=20
 /* Must have mutex */
 #define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ip6t_mutex) !=3D 0)


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yUmmepPgoWmUqRhm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAnIEXaXGVTD0i/8RAqnTAKCDSZo3RRmg/VqDS5uZ8JOLrLP26ACeOCuC
2qJ5BNwgVLgdgZ9uPQ6MSgI=
=K4jZ
-----END PGP SIGNATURE-----

--yUmmepPgoWmUqRhm--
