From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] ip_conntrack_netlink : fix expectation notifier
	unregistration
Date: Sun, 26 Mar 2006 16:19:50 +0200
Message-ID: <1143382791.4015.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-w2hssUZNH4PMDfSXOXYR"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
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


--=-w2hssUZNH4PMDfSXOXYR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Same fix as for the notifier unregistration bug in nf_conntrack_netlink.

This patch fixes expectation notifier unregistration on module unload to
use ip_conntrack_expect_unregister_notifier(). This bug causes a soft
lockup at the first expectation created after a rmmod ; insmod of this
module.

Should go into -stable as well.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>


--- linux-2.6.16.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-03-20 =
06:53:29.000000000 +0100
+++ linux-2.6.16/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-03-26 16:13=
:58.000000000 +0200
@@ -1619,7 +1619,7 @@ static void __exit ctnetlink_exit(void)
 	printk("ctnetlink: unregistering from nfnetlink.\n");
=20
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-	ip_conntrack_unregister_notifier(&ctnl_notifier_exp);
+	ip_conntrack_expect_unregister_notifier(&ctnl_notifier_exp);
 	ip_conntrack_unregister_notifier(&ctnl_notifier);
 #endif
=20

--=20
/Martin

--=-w2hssUZNH4PMDfSXOXYR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEJqMGWm2vlfa207ERAq5IAJ0Tj7elH9UGZcLv8pLnjKQdkdt+sgCfWbsq
1hfArU7/X0haHVM3wy8L5/E=
=AT6i
-----END PGP SIGNATURE-----

--=-w2hssUZNH4PMDfSXOXYR--
