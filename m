From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter ipt_conntrack/ipt_state moduse count
Date: Tue, 27 Jan 2004 22:48:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127214857.GE11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zBZpvCNcoXwafAjP"
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


--zBZpvCNcoXwafAjP
Content-Type: multipart/mixed; boundary="a6YTfLRor63AaheO"
Content-Disposition: inline


--a6YTfLRor63AaheO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave!

Please apply the following fix to your 2.4.x tree.  A 2.6.x fix is not
needed, because of it's different reference counting.

Thanks.

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--a6YTfLRor63AaheO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.4.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.4.24/net/ipv4/netfilter/ipt_conntrack.c linux-2.4.=
24-usecount/net/ipv4/netfilter/ipt_conntrack.c
--- linux-2.4.24/net/ipv4/netfilter/ipt_conntrack.c	2003-06-13 10:51:39.000=
000000 -0400
+++ linux-2.4.24-usecount/net/ipv4/netfilter/ipt_conntrack.c	2004-01-21 08:=
50:59.232369344 -0500
@@ -109,10 +109,15 @@
=20
 static int __init init(void)
 {
+	int ret;
+
 	/* NULL if ip_conntrack not a module */
 	if (ip_conntrack_module)
 		__MOD_INC_USE_COUNT(ip_conntrack_module);
-	return ipt_register_match(&conntrack_match);
+	ret =3D ipt_register_match(&conntrack_match);
+	if (ret)
+		__MOD_DEC_USE_COUNT(ip_conntrack_module);
+	return ret;
 }
=20
 static void __exit fini(void)
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.4.24/net/ipv4/netfilter/ipt_state.c linux-2.4.24-u=
secount/net/ipv4/netfilter/ipt_state.c
--- linux-2.4.24/net/ipv4/netfilter/ipt_state.c	2001-09-30 15:26:08.0000000=
00 -0400
+++ linux-2.4.24-usecount/net/ipv4/netfilter/ipt_state.c	2004-01-21 08:49:3=
6.054014376 -0500
@@ -46,10 +46,15 @@
=20
 static int __init init(void)
 {
+	int ret;
+
 	/* NULL if ip_conntrack not a module */
 	if (ip_conntrack_module)
 		__MOD_INC_USE_COUNT(ip_conntrack_module);
-	return ipt_register_match(&state_match);
+	ret =3D ipt_register_match(&state_match);
+	if (ret)
+		__MOD_DEC_USE_COUNT(ip_conntrack_module);
+	return ret;
 }
=20
 static void __exit fini(void)

--a6YTfLRor63AaheO--

--zBZpvCNcoXwafAjP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFtzJXaXGVTD0i/8RAgYtAJsE19gywErlW+BzH3jDpNOghxm3GwCaApjK
tkW/oocD2pMRiQoiWVoWcjM=
=dRJD
-----END PGP SIGNATURE-----

--zBZpvCNcoXwafAjP--
