From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] LOCAL_OUT Nat fix
Date: Thu, 2 Oct 2003 16:48:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002144817.GJ5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIh0bEfVBykExQEj"
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


--MIh0bEfVBykExQEj
Content-Type: multipart/mixed; boundary="v9GM59ztqFZSwQjD"
Content-Disposition: inline


--v9GM59ztqFZSwQjD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.4 tree and push it to Marcelo.
Thanks.


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

--v9GM59ztqFZSwQjD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="67_nolocalout.patch"
Content-Transfer-Encoding: quoted-printable

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

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.22-plain/net/ipv4/netfilt=
er/ip_nat_core.c linux-2.4.22-pptp_new/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.4.22-plain/net/ipv4/netfilter/ip_nat_core.c	2003-08-25 13:44:44=
=2E000000000 +0200
+++ linux-2.4.22-pptp_new/net/ipv4/netfilter/ip_nat_core.c	2003-09-21 19:00=
:47.000000000 +0200
@@ -756,11 +766,6 @@
 	enum ip_conntrack_dir dir =3D CTINFO2DIR(ctinfo);
 	int is_tcp =3D (*pskb)->nh.iph->protocol =3D=3D IPPROTO_TCP;
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
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.4.22-plain/net/ipv4/netfilt=
er/ip_nat_standalone.c linux-2.4.22-pptp_new/net/ipv4/netfilter/ip_nat_stan=
dalone.c
--- linux-2.4.22-plain/net/ipv4/netfilter/ip_nat_standalone.c	2003-06-13 16=
:51:39.000000000 +0200
+++ linux-2.4.22-pptp_new/net/ipv4/netfilter/ip_nat_standalone.c	2003-09-22=
 10:54:48.000000000 +0200
@@ -195,6 +188,7 @@
 	return ip_nat_fn(hooknum, pskb, in, out, okfn);
 }
=20
+#ifdef CONFIG_IP_NF_NAT_LOCAL
 static unsigned int
 ip_nat_local_fn(unsigned int hooknum,
 		struct sk_buff **pskb,
@@ -220,6 +214,7 @@
 		return ip_route_me_harder(pskb) =3D=3D 0 ? ret : NF_DROP;
 	return ret;
 }
+#endif
=20
 /* We must be after connection tracking and before packet filtering. */
=20
@@ -229,11 +224,12 @@
 /* After packet filtering, change source */
 static struct nf_hook_ops ip_nat_out_ops
 =3D { { NULL, NULL }, ip_nat_out, PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_N=
AT_SRC};
+
+#ifdef CONFIG_IP_NF_NAT_LOCAL
 /* Before packet filtering, change destination */
 static struct nf_hook_ops ip_nat_local_out_ops
 =3D { { NULL, NULL }, ip_nat_local_fn, PF_INET, NF_IP_LOCAL_OUT, NF_IP_PRI=
_NAT_DST };
-
-#ifdef CONFIG_IP_NF_NAT_LOCAL
+/* After packet filtering, change source for reply packets of LOCAL_OUT DN=
AT */
 static struct nf_hook_ops ip_nat_local_in_ops
 =3D { { NULL, NULL }, ip_nat_fn, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_NAT_SR=
C };
 #endif
@@ -301,12 +297,12 @@
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
@@ -323,10 +319,10 @@
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
  cleanup_nat:

--v9GM59ztqFZSwQjD--

--MIh0bEfVBykExQEj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDqxXaXGVTD0i/8RAsBsAKCe1qNUJ/x5KHxxzXqxykhZ55ik9gCdEhbn
CJZzzGtFzFWhpgqA1xuD8Yk=
=U4BV
-----END PGP SIGNATURE-----

--MIh0bEfVBykExQEj--
