From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER (9/x): make 'helper' list of ip_nat_core static
Date: Sat, 24 Jul 2004 10:55:24 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724145524.GR2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KqBSqvdnnccM6+Kg"
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


--KqBSqvdnnccM6+Kg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch makes the 'helper' symbol static to not pollute the namespace

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Harald Welte <laforge@netfilter.org>

diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.7-newmodparam/include/linux/netfilter_ipv4/ip_na=
t_helper.h linux-2.6.7-newmodparam-nathelper/include/linux/netfilter_ipv4/i=
p_nat_helper.h
--- linux-2.6.7-newmodparam/include/linux/netfilter_ipv4/ip_nat_helper.h	20=
04-07-20 11:26:37.277081608 -0400
+++ linux-2.6.7-newmodparam-nathelper/include/linux/netfilter_ipv4/ip_nat_h=
elper.h	2004-07-20 11:26:55.726276904 -0400
@@ -38,11 +38,12 @@
 			       struct ip_nat_info *info);
 };
=20
-extern struct list_head helpers;
-
 extern int ip_nat_helper_register(struct ip_nat_helper *me);
 extern void ip_nat_helper_unregister(struct ip_nat_helper *me);
=20
+extern struct ip_nat_helper *
+ip_nat_find_helper(const struct ip_conntrack_tuple *tuple);
+
 /* These return true or false. */
 extern int ip_nat_mangle_tcp_packet(struct sk_buff **skb,
 				struct ip_conntrack *ct,
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.7-newmodparam/net/ipv4/netfilter/ip_nat_core.c l=
inux-2.6.7-newmodparam-nathelper/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.6.7-newmodparam/net/ipv4/netfilter/ip_nat_core.c	2004-07-20 11:=
26:37.279081304 -0400
+++ linux-2.6.7-newmodparam-nathelper/net/ipv4/netfilter/ip_nat_core.c	2004=
-07-20 11:26:55.729276448 -0400
@@ -49,7 +49,6 @@
 static struct list_head *bysource;
 static struct list_head *byipsproto;
 LIST_HEAD(protos);
-LIST_HEAD(helpers);
=20
 extern struct ip_nat_protocol unknown_nat_protocol;
=20
@@ -498,13 +497,6 @@
 	return ret;
 }
=20
-static inline int
-helper_cmp(const struct ip_nat_helper *helper,
-	   const struct ip_conntrack_tuple *tuple)
-{
-	return ip_ct_tuple_mask_cmp(tuple, &helper->tuple, &helper->mask);
-}
-
 /* Where to manip the reply packets (will be reverse manip). */
 static unsigned int opposite_hook[NF_IP_NUMHOOKS]
 =3D { [NF_IP_PRE_ROUTING] =3D NF_IP_POST_ROUTING,
@@ -642,8 +634,7 @@
=20
 	/* If there's a helper, assign it; based on new tuple. */
 	if (!conntrack->master)
-		info->helper =3D LIST_FIND(&helpers, helper_cmp, struct ip_nat_helper *,
-					 &reply);
+		info->helper =3D ip_nat_find_helper(&reply);
=20
 	/* It's done. */
 	info->initialized |=3D (1 << HOOK2MANIP(hooknum));
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.7-newmodparam/net/ipv4/netfilter/ip_nat_helper.c=
 linux-2.6.7-newmodparam-nathelper/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.6.7-newmodparam/net/ipv4/netfilter/ip_nat_helper.c	2004-07-20 1=
1:26:37.281081000 -0400
+++ linux-2.6.7-newmodparam-nathelper/net/ipv4/netfilter/ip_nat_helper.c	20=
04-07-20 15:16:53.672014608 -0400
@@ -47,6 +47,7 @@
 #define DUMP_OFFSET(x)
 #endif
=20
+static LIST_HEAD(helpers);
 DECLARE_LOCK(ip_nat_seqofs_lock);
=20
 /* Setup TCP sequence correction given this change at this sequence */
@@ -419,6 +420,18 @@
 	return ret;
 }
=20
+struct ip_nat_helper *
+ip_nat_find_helper(const struct ip_conntrack_tuple *tuple)
+{
+	struct ip_nat_helper *h;
+
+	READ_LOCK(&ip_nat_lock);
+	h =3D LIST_FIND(&helpers, helper_cmp, struct ip_nat_helper *, tuple);
+	READ_UNLOCK(&ip_nat_lock);
+
+	return h;
+}
+
 static int
 kill_helper(const struct ip_conntrack *i, void *helper)
 {
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KqBSqvdnnccM6+Kg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAnhbXaXGVTD0i/8RAviqAKCG3ViY0DTnDuA1HAgNxA2Wr+Ei7ACeNNCb
DwryZA0UK0j6N/Occv4QbSA=
=cCto
-----END PGP SIGNATURE-----

--KqBSqvdnnccM6+Kg--
