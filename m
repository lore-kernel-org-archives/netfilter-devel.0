From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4 1/10]: Fix non-existant config option CONFIG_NF_DEBUG
Date: Mon, 21 Jun 2004 21:50:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621195010.GU24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="frrXvU3mT8dlRds5"
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


--frrXvU3mT8dlRds5
Content-Type: multipart/mixed; boundary="HanPD1JKBS04/nMk"
Content-Disposition: inline


--HanPD1JKBS04/nMk
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is part 1 of a 10 patch set that adds all fixes (no new features)
to 2.4.x kernel and thus syncs with the recent patchset for 2.6.x.

None of them fixes important or even security relevant issues, so=20
all can be post 2.4.27.

Please apply to your tree and push to Marcelo, thanks.

This patch for 2.4 fixes a non-existant config option (CONFIG_NF_DEBUG)
for IP_NF_ASSERT and fixes a couple of broken assertions.

Author: Patrick McHardy <kaber@trash.net>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HanPD1JKBS04/nMk
Content-Type: text/plain; charset=us-ascii; name="01.diff"
Content-Disposition: inline; filename="01.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:26:18+02:00 kaber@trash.net=20
#   [NETFILTER]: Fix non-existant config option for IP_NF_ASSERT, fix some =
broken assertions
#=20
# net/ipv4/netfilter/ip_nat_core.c
#   2004/06/20 22:26:15+02:00 kaber@trash.net +5 -2
#   [NETFILTER]: Fix non-existant config option for IP_NF_ASSERT, fix some =
broken assertions
#=20
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/06/20 22:26:15+02:00 kaber@trash.net +2 -5
#   [NETFILTER]: Fix non-existant config option for IP_NF_ASSERT, fix some =
broken assertions
#=20
# include/linux/netfilter_ipv4/ip_conntrack.h
#   2004/06/20 22:26:15+02:00 kaber@trash.net +1 -1
#   [NETFILTER]: Fix non-existant config option for IP_NF_ASSERT, fix some =
broken assertions
#=20
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/net=
filter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	2004-06-20 23:02:33 +02:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	2004-06-20 23:02:33 +02:00
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
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-20 23:02:33 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-20 23:02:33 +02:00
@@ -175,13 +175,12 @@
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
@@ -504,7 +503,7 @@
 		 enum ip_conntrack_info *ctinfo,
 		 unsigned int hooknum)
 {
-	const struct iphdr *iph;
+	const struct iphdr *iph =3D skb->nh.iph;
 	struct icmphdr *hdr;
 	struct ip_conntrack_tuple innertuple, origtuple;
 	struct iphdr *inner;
@@ -515,7 +514,6 @@
 	IP_NF_ASSERT(iph->protocol =3D=3D IPPROTO_ICMP);
 	IP_NF_ASSERT(skb->nfct =3D=3D NULL);
=20
-	iph =3D skb->nh.iph;
 	hdr =3D (struct icmphdr *)((u_int32_t *)iph + iph->ihl);
 	inner =3D (struct iphdr *)(hdr + 1);
 	datalen =3D skb->len - iph->ihl*4 - sizeof(*hdr);
@@ -731,7 +729,6 @@
 		DEBUGP("conntrack: expectation arrives ct=3D%p exp=3D%p\n",
 			conntrack, expected);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
-		IP_NF_ASSERT(master_ct(conntrack));
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master =3D expected;
 		expected->sibling =3D conntrack;
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_co=
re.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-06-20 23:02:33 +02:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-06-20 23:02:33 +02:00
@@ -520,6 +520,7 @@
 	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
 	IP_NF_ASSERT(hooknum =3D=3D NF_IP_PRE_ROUTING
 		     || hooknum =3D=3D NF_IP_POST_ROUTING
+		     || hooknum =3D=3D NF_IP_LOCAL_IN
 		     || hooknum =3D=3D NF_IP_LOCAL_OUT);
 	IP_NF_ASSERT(info->num_manips < IP_NAT_MAX_MANIPS);
 	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
@@ -882,9 +883,11 @@
=20
 	IP_NF_ASSERT(skb->len >=3D iph->ihl*4 + sizeof(struct icmphdr));
 	/* Must be RELATED */
-	IP_NF_ASSERT(skb->nfct - (struct ip_conntrack *)skb->nfct->master
+	IP_NF_ASSERT(skb->nfct
+		     - ((struct ip_conntrack *)skb->nfct->master)->infos
 		     =3D=3D IP_CT_RELATED
-		     || skb->nfct - (struct ip_conntrack *)skb->nfct->master
+		     || skb->nfct
+		     - ((struct ip_conntrack *)skb->nfct->master)->infos
 		     =3D=3D IP_CT_RELATED+IP_CT_IS_REPLY);
=20
 	/* Redirects on non-null nats must be dropped, else they'll


--HanPD1JKBS04/nMk--

--frrXvU3mT8dlRds5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zvyXaXGVTD0i/8RAiqtAJwKxi8NtD5oC9Sy2IFUFdW/Sf0y2wCffCPU
yYehZF3kLbHY9HX0xvCn5ZQ=
=dbvH
-----END PGP SIGNATURE-----

--frrXvU3mT8dlRds5--
