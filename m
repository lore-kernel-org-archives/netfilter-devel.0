From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 2/2] Fix compile errors without NAT
Date: Sat, 22 Jan 2005 15:02:51 +0100
Message-ID: <1106402571.20995.19.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-e1KwDCmx6PURpsyppzFz"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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


--=-e1KwDCmx6PURpsyppzFz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Patrick

This patch fixes some compile errors with NAT that has appeared after
all the recent patches.

Move struct ip_conntrack_expect after the definition of struct
ip_conntrack.
Add #ifdef CONFIG_IP_NF_NAT_NEEDED around ip_nat_initialized()
Add lockhelp.h to ipt_CLUSTERIP.c

Please submit this patch to davem for inclusion in 2.6.11 (-rc2 was just
released)

diff -X /home/gandalf/dontdiff.ny -urNp linux-2.6.11-rc2.orig/include/linux=
/netfilter_ipv4/ip_conntrack.h linux-2.6.11-rc2/include/linux/netfilter_ipv=
4/ip_conntrack.h
--- linux-2.6.11-rc2.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-=
01-22 12:17:39.000000000 +0100
+++ linux-2.6.11-rc2/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-22=
 13:55:25.000000000 +0100
@@ -122,33 +122,6 @@ do {									\
 #define IP_NF_ASSERT(x)
 #endif
=20
-struct ip_conntrack_expect
-{
-	/* Internal linked list (global expectation list) */
-	struct list_head list;
-
-	/* We expect this tuple, with the following mask */
-	struct ip_conntrack_tuple tuple, mask;
-=20
-	/* Function to call after setup and insertion */
-	void (*expectfn)(struct ip_conntrack *new,
-			 struct ip_conntrack_expect *this);
-
-	/* The conntrack of the master connection */
-	struct ip_conntrack *master;
-
-	/* Timer function; deletes the expectation. */
-	struct timer_list timeout;
-
-#ifdef CONFIG_IP_NF_NAT_NEEDED
-	/* This is the original per-proto part, used to map the
-	 * expected connection the way the recipient expects. */
-	union ip_conntrack_manip_proto saved_proto;
-	/* Direction relative to the master connection. */
-	enum ip_conntrack_dir dir;
-#endif
-};
-
 struct ip_conntrack_counter
 {
 	u_int64_t packets;
@@ -206,6 +179,33 @@ struct ip_conntrack
 	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
 };
=20
+struct ip_conntrack_expect
+{
+	/* Internal linked list (global expectation list) */
+	struct list_head list;
+
+	/* We expect this tuple, with the following mask */
+	struct ip_conntrack_tuple tuple, mask;
+=20
+	/* Function to call after setup and insertion */
+	void (*expectfn)(struct ip_conntrack *new,
+			 struct ip_conntrack_expect *this);
+
+	/* The conntrack of the master connection */
+	struct ip_conntrack *master;
+
+	/* Timer function; deletes the expectation. */
+	struct timer_list timeout;
+
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+	/* This is the original per-proto part, used to map the
+	 * expected connection the way the recipient expects. */
+	union ip_conntrack_manip_proto saved_proto;
+	/* Direction relative to the master connection. */
+	enum ip_conntrack_dir dir;
+#endif
+};
+
 static inline struct ip_conntrack *
 tuplehash_to_ctrack(const struct ip_conntrack_tuple_hash *hash)
 {
@@ -301,6 +301,7 @@ struct ip_conntrack_stat
=20
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count+=
+)
=20
+#ifdef CONFIG_IP_NF_NAT_NEEDED
 static inline int ip_nat_initialized(struct ip_conntrack *conntrack,
 				     enum ip_nat_manip_type manip)
 {
@@ -308,5 +309,7 @@ static inline int ip_nat_initialized(str
 		return test_bit(IPS_SRC_NAT_DONE_BIT, &conntrack->status);
 	return test_bit(IPS_DST_NAT_DONE_BIT, &conntrack->status);
 }
+#endif /* CONFIG_IP_NF_NAT_NEEDED */
+
 #endif /* __KERNEL__ */
 #endif /* _IP_CONNTRACK_H */
diff -X /home/gandalf/dontdiff.ny -urNp linux-2.6.11-rc2.orig/net/ipv4/netf=
ilter/ipt_CLUSTERIP.c linux-2.6.11-rc2/net/ipv4/netfilter/ipt_CLUSTERIP.c
--- linux-2.6.11-rc2.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-01-22 12:=
17:40.000000000 +0100
+++ linux-2.6.11-rc2/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-01-22 13:55:49=
.000000000 +0100
@@ -29,6 +29,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/lockhelp.h>
=20
 #define CLUSTERIP_VERSION "0.6"
=20

--=20
/Martin

--=-e1KwDCmx6PURpsyppzFz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBB8l0LWm2vlfa207ERAkOHAJ9p82BM5V1fDOG+ByeD//Mpn021wACfdv/J
Ox/vePtT7hAynml1BAF0yMI=
=+ys4
-----END PGP SIGNATURE-----

--=-e1KwDCmx6PURpsyppzFz--
