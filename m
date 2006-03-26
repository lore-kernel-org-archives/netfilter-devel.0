From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] nf_conntrack_netlink : fix expectation notifier
	unregistration
Date: Sun, 26 Mar 2006 12:08:47 +0200
Message-ID: <1143367727.4015.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-eGhoMyybpBbRGOHwqx13"
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


--=-eGhoMyybpBbRGOHwqx13
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch fixes expectation notifier unregistration on module unload to
use nf_conntrack_expect_unregister_notifier(). This bug causes a soft
lockup at the first expectation created after a rmmod ; insmod of this
module.

Should go into -stable as well.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>


diff -X /home/gandalf/dontdiff.ny -urNp linux-2.6.16.orig/net/netfilter/nf_=
conntrack_netlink.c linux-2.6.16/net/netfilter/nf_conntrack_netlink.c
--- linux-2.6.16.orig/net/netfilter/nf_conntrack_netlink.c	2006-03-20 06:53=
:29.000000000 +0100
+++ linux-2.6.16/net/netfilter/nf_conntrack_netlink.c	2006-03-26 11:46:30.0=
00000000 +0200
@@ -1641,7 +1641,7 @@ static void __exit ctnetlink_exit(void)
 	printk("ctnetlink: unregistering from nfnetlink.\n");
=20
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	nf_conntrack_unregister_notifier(&ctnl_notifier_exp);
+	nf_conntrack_expect_unregister_notifier(&ctnl_notifier_exp);
 	nf_conntrack_unregister_notifier(&ctnl_notifier);
 #endif
=20

--=20
/Martin

--=-eGhoMyybpBbRGOHwqx13
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEJmgvWm2vlfa207ERArqzAKCh45n/VrzWm7zND7ksKk0bK+aaeQCeNibe
JwdNUUYJo8qBSLceXBkFRbA=
=WdZB
-----END PGP SIGNATURE-----

--=-eGhoMyybpBbRGOHwqx13--
