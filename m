From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 1/14]: Fix non-existant config option CONFIG_NF_DEBUG
Date: Mon, 21 Jun 2004 21:38:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621193851.GF24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zfZAIAilk/YNj2Pr"
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


--zfZAIAilk/YNj2Pr
Content-Type: multipart/mixed; boundary="y1+kC1Q2udlVMFpc"
Content-Disposition: inline


--y1+kC1Q2udlVMFpc
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Hi Dave!

Sorry for the patch-bombing, but we have finally decided that now is the
right time to submit some long-standing fixes and additions to netfilter
in the 2.6.x series.

Please apply to your tree, thanks.


This patch for 2.6 fixes a non-existant config option (CONFIG_NF_DEBUG)
for IP_NF_ASSERT and fixes a couple of broken assertions.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>



--y1+kC1Q2udlVMFpc
Content-Type: text/plain; charset=us-ascii; name="01.diff"
Content-Disposition: inline; filename="01.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:25:24+02:00 kaber@trash.net=20
#   [NETFILTER]: Fix non-existant config option for IP_NF_ASSERT, fix some =
broken assertions
#=20
# net/ipv4/netfilter/ip_nat_core.c
#   2004/06/20 22:25:13+02:00 kaber@trash.net +3 -2
#   [NETFILTER]: Fix non-existant config option for IP_NF_ASSERT, fix some =
broken assertions
#=20
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/06/20 22:25:13+02:00 kaber@trash.net +1 -3
#   [NETFILTER]: Fix non-existant config option for IP_NF_ASSERT, fix some =
broken assertions
#=20
# include/linux/netfilter_ipv4/ip_conntrack.h
#   2004/06/20 22:25:13+02:00 kaber@trash.net +1 -1
#   [NETFILTER]: Fix non-existant config option for IP_NF_ASSERT, fix some =
broken assertions
#=20
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/net=
filter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	2004-06-20 22:59:21 +02:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	2004-06-20 22:59:21 +02:00
@@ -103,7 +103,7 @@
 #include <linux/types.h>
 #include <linux/skbuff.h>
=20
-#ifdef CONFIG_NF_DEBUG
+#ifdef CONFIG_NETFILTER_DEBUG
 #define IP_NF_ASSERT(x)							\
 do {									\
 	if (!(x))							\
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_=
conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-20 22:59:21 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-20 22:59:21 +02:00
@@ -173,13 +173,12 @@
 destroy_expect(struct ip_conntrack_expect *exp)
 {
 	DEBUGP("destroy_expect(%p) use=3D%d\n", exp, atomic_read(&exp->use));
-	IP_NF_ASSERT(atomic_read(&exp->use));
+	IP_NF_ASSERT(atomic_read(&exp->use) =3D=3D 0);
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
=20
 	kfree(exp);
 }
=20
-
 inline void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
 {
 	IP_NF_ASSERT(exp);
@@ -715,7 +714,6 @@
 		DEBUGP("conntrack: expectation arrives ct=3D%p exp=3D%p\n",
 			conntrack, expected);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
-		IP_NF_ASSERT(master_ct(conntrack));
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master =3D expected;
 		expected->sibling =3D conntrack;
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_co=
re.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-06-20 22:59:21 +02:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-06-20 22:59:21 +02:00
@@ -528,6 +528,7 @@
 	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
 	IP_NF_ASSERT(hooknum =3D=3D NF_IP_PRE_ROUTING
 		     || hooknum =3D=3D NF_IP_POST_ROUTING
+		     || hooknum =3D=3D NF_IP_LOCAL_IN
 		     || hooknum =3D=3D NF_IP_LOCAL_OUT);
 	IP_NF_ASSERT(info->num_manips < IP_NAT_MAX_MANIPS);
 	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
@@ -899,10 +900,10 @@
=20
 	/* Must be RELATED */
 	IP_NF_ASSERT((*pskb)->nfct
-		     - (struct ip_conntrack *)(*pskb)->nfct->master
+		     - ((struct ip_conntrack *)(*pskb)->nfct->master)->infos
 		     =3D=3D IP_CT_RELATED
 		     || (*pskb)->nfct
-		     - (struct ip_conntrack *)(*pskb)->nfct->master
+		     - ((struct ip_conntrack *)(*pskb)->nfct->master)->infos
 		     =3D=3D IP_CT_RELATED+IP_CT_IS_REPLY);
=20
 	/* Redirects on non-null nats must be dropped, else they'll


--y1+kC1Q2udlVMFpc--

--zfZAIAilk/YNj2Pr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zlLXaXGVTD0i/8RAsTmAJ962/QCvpWZqbwsjJxGnzZGAXllUwCfQnD5
OBhJELM3P12nmAhbNbmBlmM=
=Im45
-----END PGP SIGNATURE-----

--zfZAIAilk/YNj2Pr--
