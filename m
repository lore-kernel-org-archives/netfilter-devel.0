From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] really fix ipt_state/ipt_conntrack refcounting
Date: Tue, 3 Feb 2004 09:32:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040203083231.GR24449@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3sseE1tnmEs+TkKq"
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


--3sseE1tnmEs+TkKq
Content-Type: multipart/mixed; boundary="PY8tzLeNxmyMVNR3"
Content-Disposition: inline


--PY8tzLeNxmyMVNR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Unfortunately the last patch on that issue did not address the full problem,
and rather introduced a new bug when ip_conntrack is statically linked
in the kernel.

Further investigation led to the discovery that explicit manual
refcounting is not needed anymore and is rather a historic relict.

The attached patch removes all manual explicit refcounting.

Please apply (on top of the previous one).

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PY8tzLeNxmyMVNR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.4.24-refcnt1-refcnt.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru linux-2.4.24-refcnt1/include/linux/netfilter_ipv4/ip_conntrack.h =
linux-2.4.24-refcnt/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.24-refcnt1/include/linux/netfilter_ipv4/ip_conntrack.h	2003-0=
6-13 16:51:38.000000000 +0200
+++ linux-2.4.24-refcnt/include/linux/netfilter_ipv4/ip_conntrack.h	2004-02=
-03 09:28:40.844977920 +0100
@@ -237,8 +237,6 @@
 /* decrement reference count on an expectation */
 void ip_conntrack_expect_put(struct ip_conntrack_expect *exp);
=20
-extern struct module *ip_conntrack_module;
-
 extern int invert_tuplepr(struct ip_conntrack_tuple *inverse,
 			  const struct ip_conntrack_tuple *orig);
=20
diff -Nru linux-2.4.24-refcnt1/net/ipv4/netfilter/ip_conntrack_standalone.c=
 linux-2.4.24-refcnt/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.4.24-refcnt1/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-=
11-28 19:26:21.000000000 +0100
+++ linux-2.4.24-refcnt/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-0=
2-03 09:25:47.797285168 +0100
@@ -37,7 +37,6 @@
 #define DEBUGP(format, args...)
 #endif
=20
-struct module *ip_conntrack_module =3D THIS_MODULE;
 MODULE_LICENSE("GPL");
=20
 static int kill_proto(const struct ip_conntrack *i, void *data)
@@ -461,7 +460,6 @@
 EXPORT_SYMBOL(ip_conntrack_alter_reply);
 EXPORT_SYMBOL(ip_conntrack_destroyed);
 EXPORT_SYMBOL(ip_conntrack_get);
-EXPORT_SYMBOL(ip_conntrack_module);
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
 EXPORT_SYMBOL(ip_ct_selective_cleanup);
diff -Nru linux-2.4.24-refcnt1/net/ipv4/netfilter/ip_nat_standalone.c linux=
-2.4.24-refcnt/net/ipv4/netfilter/ip_nat_standalone.c
--- linux-2.4.24-refcnt1/net/ipv4/netfilter/ip_nat_standalone.c	2003-11-28 =
19:26:21.000000000 +0100
+++ linux-2.4.24-refcnt/net/ipv4/netfilter/ip_nat_standalone.c	2004-02-03 0=
9:25:58.181706496 +0100
@@ -309,13 +309,9 @@
 		goto cleanup_localoutops;
 	}
 #endif
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
 	return ret;
=20
  cleanup:
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
 #ifdef CONFIG_IP_NF_NAT_LOCAL
 	nf_unregister_hook(&ip_nat_local_in_ops);
  cleanup_localoutops:
diff -Nru linux-2.4.24-refcnt1/net/ipv4/netfilter/ipt_conntrack.c linux-2.4=
=2E24-refcnt/net/ipv4/netfilter/ipt_conntrack.c
--- linux-2.4.24-refcnt1/net/ipv4/netfilter/ipt_conntrack.c	2004-02-03 09:2=
9:14.016935016 +0100
+++ linux-2.4.24-refcnt/net/ipv4/netfilter/ipt_conntrack.c	2004-02-03 09:26=
:15.251111552 +0100
@@ -109,22 +109,12 @@
=20
 static int __init init(void)
 {
-	int ret;
-
-	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
-	ret =3D ipt_register_match(&conntrack_match);
-	if (ret)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
-	return ret;
+	return ipt_register_match(&conntrack_match);
 }
=20
 static void __exit fini(void)
 {
 	ipt_unregister_match(&conntrack_match);
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
 }
=20
 module_init(init);
diff -Nru linux-2.4.24-refcnt1/net/ipv4/netfilter/ipt_helper.c linux-2.4.24=
-refcnt/net/ipv4/netfilter/ipt_helper.c
--- linux-2.4.24-refcnt1/net/ipv4/netfilter/ipt_helper.c	2003-08-25 13:44:4=
4.000000000 +0200
+++ linux-2.4.24-refcnt/net/ipv4/netfilter/ipt_helper.c	2004-02-03 09:26:26=
=2E078465544 +0100
@@ -100,17 +100,12 @@
=20
 static int __init init(void)
 {
-	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
 	return ipt_register_match(&helper_match);
 }
=20
 static void __exit fini(void)
 {
 	ipt_unregister_match(&helper_match);
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
 }
=20
 module_init(init);
diff -Nru linux-2.4.24-refcnt1/net/ipv4/netfilter/ipt_state.c linux-2.4.24-=
refcnt/net/ipv4/netfilter/ipt_state.c
--- linux-2.4.24-refcnt1/net/ipv4/netfilter/ipt_state.c	2004-02-03 09:29:14=
=2E017934864 +0100
+++ linux-2.4.24-refcnt/net/ipv4/netfilter/ipt_state.c	2004-02-03 09:26:46.=
029432536 +0100
@@ -46,22 +46,12 @@
=20
 static int __init init(void)
 {
-	int ret;
-
-	/* NULL if ip_conntrack not a module */
-	if (ip_conntrack_module)
-		__MOD_INC_USE_COUNT(ip_conntrack_module);
-	ret =3D ipt_register_match(&state_match);
-	if (ret)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
-	return ret;
+	return ipt_register_match(&state_match);
 }
=20
 static void __exit fini(void)
 {
 	ipt_unregister_match(&state_match);
-	if (ip_conntrack_module)
-		__MOD_DEC_USE_COUNT(ip_conntrack_module);
 }
=20
 module_init(init);

--PY8tzLeNxmyMVNR3--

--3sseE1tnmEs+TkKq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAH1yfXaXGVTD0i/8RAoaEAJ4/KKRbNXn5IXTyq4VnwB52MxrECwCfbK2l
y9YoKYyX0BfOnAX9Z5GFzhk=
=B8wh
-----END PGP SIGNATURE-----

--3sseE1tnmEs+TkKq--
