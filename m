From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] LOCAL_OUT Nat fix, part 2
Date: Thu, 2 Oct 2003 18:18:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002161836.GR5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rMTo2AP+XrZXQCI6"
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


--rMTo2AP+XrZXQCI6
Content-Type: multipart/mixed; boundary="XAxdu+gdzyY/jMFv"
Content-Disposition: inline


--XAxdu+gdzyY/jMFv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.6 tree, thanks.


Author: Rusty Russell / Harald Welte
Status: Pending for kernel inclusion

D: Balazs Scheidler pointed out that we can fail to call ip_nat_setup_info
D: for local NAT, which causes the connection to be added twice. Boom.
D: Also move the hash table insertion into ip_nat_setup_info.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XAxdu+gdzyY/jMFv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="84_local-nullbinding.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-localnat/include/=
linux/netfilter_ipv4/ip_nat_rule.h linux-2.6.0-test6-localnat2/include/linu=
x/netfilter_ipv4/ip_nat_rule.h
--- linux-2.6.0-test6-localnat/include/linux/netfilter_ipv4/ip_nat_rule.h	2=
003-09-28 02:51:00.000000000 +0200
+++ linux-2.6.0-test6-localnat2/include/linux/netfilter_ipv4/ip_nat_rule.h	=
2003-10-02 18:29:05.000000000 +0200
@@ -14,5 +14,10 @@
 			    const struct net_device *out,
 			    struct ip_conntrack *ct,
 			    struct ip_nat_info *info);
+
+extern unsigned int
+alloc_null_binding(struct ip_conntrack *conntrack,
+		   struct ip_nat_info *info,
+		   unsigned int hooknum);
 #endif
 #endif /* _IP_NAT_RULE_H */
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-localnat/net/ipv4=
/netfilter/ip_nat_core.c linux-2.6.0-test6-localnat2/net/ipv4/netfilter/ip_=
nat_core.c
--- linux-2.6.0-test6-localnat/net/ipv4/netfilter/ip_nat_core.c	2003-10-02 =
18:24:44.000000000 +0200
+++ linux-2.6.0-test6-localnat2/net/ipv4/netfilter/ip_nat_core.c	2003-10-02=
 18:29:05.000000000 +0200
@@ -516,12 +516,14 @@
 	struct ip_conntrack_tuple new_tuple, inv_tuple, reply;
 	struct ip_conntrack_tuple orig_tp;
 	struct ip_nat_info *info =3D &conntrack->nat.info;
+	int in_hashes =3D info->initialized;
=20
 	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
 	IP_NF_ASSERT(hooknum =3D=3D NF_IP_PRE_ROUTING
 		     || hooknum =3D=3D NF_IP_POST_ROUTING
 		     || hooknum =3D=3D NF_IP_LOCAL_OUT);
 	IP_NF_ASSERT(info->num_manips < IP_NAT_MAX_MANIPS);
+	IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
=20
 	/* What we've got will look like inverse of reply. Normally
 	   this is what is in the conntrack, except for prior
@@ -638,6 +640,14 @@
=20
 	/* It's done. */
 	info->initialized |=3D (1 << HOOK2MANIP(hooknum));
+
+	if (in_hashes) {
+		IP_NF_ASSERT(info->bysource.conntrack);
+		replace_in_hashes(conntrack, info);
+	} else {
+		place_in_hashes(conntrack, info);
+	}
+
 	return NF_ACCEPT;
 }
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-localnat/net/ipv4=
/netfilter/ip_nat_rule.c linux-2.6.0-test6-localnat2/net/ipv4/netfilter/ip_=
nat_rule.c
--- linux-2.6.0-test6-localnat/net/ipv4/netfilter/ip_nat_rule.c	2003-09-28 =
02:50:16.000000000 +0200
+++ linux-2.6.0-test6-localnat2/net/ipv4/netfilter/ip_nat_rule.c	2003-10-02=
 18:29:05.000000000 +0200
@@ -233,7 +233,7 @@
 	return 1;
 }
=20
-static inline unsigned int
+inline unsigned int
 alloc_null_binding(struct ip_conntrack *conntrack,
 		   struct ip_nat_info *info,
 		   unsigned int hooknum)
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-localnat/net/ipv4=
/netfilter/ip_nat_standalone.c linux-2.6.0-test6-localnat2/net/ipv4/netfilt=
er/ip_nat_standalone.c
--- linux-2.6.0-test6-localnat/net/ipv4/netfilter/ip_nat_standalone.c	2003-=
10-02 18:26:02.000000000 +0200
+++ linux-2.6.0-test6-localnat2/net/ipv4/netfilter/ip_nat_standalone.c	2003=
-10-02 18:29:05.000000000 +0200
@@ -119,7 +119,6 @@
 		/* Seen it before?  This can happen for loopback, retrans,
 		   or local packets.. */
 		if (!(info->initialized & (1 << maniptype))) {
-			int in_hashes =3D info->initialized;
 			unsigned int ret;
=20
 			if (ct->master
@@ -130,9 +129,10 @@
 			} else {
 #ifdef CONFIG_IP_NF_NAT_LOCAL
 				/* LOCAL_IN hook doesn't have a chain!  */
-				if (hooknum =3D=3D NF_IP_LOCAL_IN) {
-					ret =3D NF_ACCEPT;
-				} else
+				if (hooknum =3D=3D NF_IP_LOCAL_IN)
+					ret =3D alloc_null_binding(ct, info,
+								 hooknum);
+				else
 #endif
 				ret =3D ip_nat_rule_find(pskb, hooknum, in, out,
 						       ct, info);
@@ -142,13 +142,6 @@
 				WRITE_UNLOCK(&ip_nat_lock);
 				return ret;
 			}
-
-			if (in_hashes) {
-				IP_NF_ASSERT(info->bysource.conntrack);
-				replace_in_hashes(ct, info);
-			} else {
-				place_in_hashes(ct, info);
-			}
 		} else
 			DEBUGP("Already setup manip %s for ct %p\n",
 			       maniptype =3D=3D IP_NAT_MANIP_SRC ? "SRC" : "DST",

--XAxdu+gdzyY/jMFv--

--rMTo2AP+XrZXQCI6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fE/cXaXGVTD0i/8RAk4yAJ98FKXJc6MiptqjPRGqJNE0LLULhACeKDNn
m9uZPoFKEsGzUr5M+oVuMNw=
=5bSb
-----END PGP SIGNATURE-----

--rMTo2AP+XrZXQCI6--
