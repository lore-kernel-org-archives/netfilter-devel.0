From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] LOCAL_OUT Nat fix #1
Date: Thu, 2 Oct 2003 18:15:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002161528.GQ5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cIqm4GXEn7jz7ytp"
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


--cIqm4GXEn7jz7ytp
Content-Type: multipart/mixed; boundary="yeSrnKhSbw+McYe1"
Content-Disposition: inline


--yeSrnKhSbw+McYe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.6 tree, thanks


Author: Harald Welte <laforge@netfilter.org>
Status: Pending for kernel inclusion

D: the 25_natcore-nohelper.patch (incorporated in 2.4.22) did actually make
D: things not better.  If a NAT rule was matched, num_manips can still be 0.
D: However, some helpers (like PPTP) need to _always mangle the packets,
D: even if there is no NAT mapping for a particular connection.
D: On the other hand, as soon as CONFIG_IP_NF_LOCAL_NAT was disabled,
D: we did end up half-mangling local (non-NAT'ed) connections.  This patch
D: removes the LOCAL_OUT hook from the NAT core unless CONFIG_IP_NF_NAT_LOC=
AL
D: is enabled.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yeSrnKhSbw+McYe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="83_nolocalout.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-ctsysctl/net/ipv4=
/netfilter/ip_nat_core.c linux-2.6.0-test6-localnat/net/ipv4/netfilter/ip_n=
at_core.c
--- linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/ip_nat_core.c	2003-09-28 =
02:50:10.000000000 +0200
+++ linux-2.6.0-test6-localnat/net/ipv4/netfilter/ip_nat_core.c	2003-10-02 =
18:24:44.000000000 +0200
@@ -761,11 +761,6 @@
 	enum ip_conntrack_dir dir =3D CTINFO2DIR(ctinfo);
 	int proto =3D (*pskb)->nh.iph->protocol;
=20
-	/* Skip everything and don't call helpers if there are no
-	 * manips for this connection */
-	if (info->num_manips =3D=3D 0)
-		return NF_ACCEPT;
-
 	/* Need nat lock to protect against modification, but neither
 	   conntrack (referenced) and helper (deleted with
 	   synchronize_bh()) can vanish. */
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test6-ctsysctl/net/ipv4=
/netfilter/ip_nat_standalone.c linux-2.6.0-test6-localnat/net/ipv4/netfilte=
r/ip_nat_standalone.c
--- linux-2.6.0-test6-ctsysctl/net/ipv4/netfilter/ip_nat_standalone.c	2003-=
09-28 02:50:39.000000000 +0200
+++ linux-2.6.0-test6-localnat/net/ipv4/netfilter/ip_nat_standalone.c	2003-=
10-02 18:26:02.000000000 +0200
@@ -199,6 +199,7 @@
 	return ip_nat_fn(hooknum, pskb, in, out, okfn);
 }
=20
+#ifdef CONFIG_IP_NF_NAT_LOCAL
 static unsigned int
 ip_nat_local_fn(unsigned int hooknum,
 		struct sk_buff **pskb,
@@ -224,6 +225,7 @@
 		return ip_route_me_harder(pskb) =3D=3D 0 ? ret : NF_DROP;
 	return ret;
 }
+#endif
=20
 /* We must be after connection tracking and before packet filtering. */
=20
@@ -245,6 +247,7 @@
 	.priority	=3D NF_IP_PRI_NAT_SRC,
 };
=20
+#ifdef CONFIG_IP_NF_NAT_LOCAL
 /* Before packet filtering, change destination */
 static struct nf_hook_ops ip_nat_local_out_ops =3D {
 	.hook		=3D ip_nat_local_fn,
@@ -254,7 +257,7 @@
 	.priority	=3D NF_IP_PRI_NAT_DST,
 };
=20
-#ifdef CONFIG_IP_NF_NAT_LOCAL
+/* After packet filtering, change source for reply packets of LOCAL_OUT DN=
AT */
 static struct nf_hook_ops ip_nat_local_in_ops =3D {
 	.hook		=3D ip_nat_fn,
 	.owner		=3D THIS_MODULE,
@@ -324,12 +327,12 @@
 		printk("ip_nat_init: can't register out hook.\n");
 		goto cleanup_inops;
 	}
+#ifdef CONFIG_IP_NF_NAT_LOCAL
 	ret =3D nf_register_hook(&ip_nat_local_out_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register local out hook.\n");
 		goto cleanup_outops;
 	}
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 	ret =3D nf_register_hook(&ip_nat_local_in_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register local in hook.\n");
@@ -342,9 +345,9 @@
 #ifdef CONFIG_IP_NF_NAT_LOCAL
 	nf_unregister_hook(&ip_nat_local_in_ops);
  cleanup_localoutops:
-#endif
 	nf_unregister_hook(&ip_nat_local_out_ops);
  cleanup_outops:
+#endif
 	nf_unregister_hook(&ip_nat_out_ops);
  cleanup_inops:
 	nf_unregister_hook(&ip_nat_in_ops);

--yeSrnKhSbw+McYe1--

--cIqm4GXEn7jz7ytp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fE8gXaXGVTD0i/8RAhkbAKCnv4ZVBjacG0HxsTZi9DN+aR43lgCgjYwe
Cw5PKu813DKyxoQrpkIxMGE=
=Clz+
-----END PGP SIGNATURE-----

--cIqm4GXEn7jz7ytp--
