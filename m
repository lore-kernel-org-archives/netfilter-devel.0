From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] netfilter ipt_helper locking fix
Date: Fri, 25 Jul 2003 22:52:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725205226.GC3244@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aO2SyuDEANnesPMC"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
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


--aO2SyuDEANnesPMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the 4th of my 2.6 merge of recent bugfixes (all tested against
2.4.22-pre7).  You might need to apply them incrementally (didn't test
it in a different order).=20

Author: Patrick McHardy <kaber@trash.net>

Fix locking of ipt_helper.

Please apply,

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.0-test1-nftest3/net/ipv4/=
netfilter/ipt_helper.c linux-2.6.0-test1-nftest4/net/ipv4/netfilter/ipt_hel=
per.c
--- linux-2.6.0-test1-nftest3/net/ipv4/netfilter/ipt_helper.c	2003-07-14 05=
:36:42.000000000 +0200
+++ linux-2.6.0-test1-nftest4/net/ipv4/netfilter/ipt_helper.c	2003-07-19 16=
:32:30.000000000 +0200
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_helper.h>
@@ -34,6 +35,7 @@
 	struct ip_conntrack_expect *exp;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
+	int ret =3D 0;
 =09
 	ct =3D ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
 	if (!ct) {
@@ -47,23 +49,27 @@
 	}
=20
 	exp =3D ct->master;
+	READ_LOCK(&ip_conntrack_lock);
 	if (!exp->expectant) {
 		DEBUGP("ipt_helper: expectation %p without expectant !?!\n",=20
 			exp);
-		return 0;
+		goto out_unlock;
 	}
=20
 	if (!exp->expectant->helper) {
 		DEBUGP("ipt_helper: master ct %p has no helper\n",=20
 			exp->expectant);
-		return 0;
+		goto out_unlock;
 	}
=20
 	DEBUGP("master's name =3D %s , info->name =3D %s\n",=20
 		exp->expectant->helper->name, info->name);
=20
-	return !strncmp(exp->expectant->helper->name, info->name,=20
-			strlen(exp->expectant->helper->name)) ^ info->invert;
+	ret =3D !strncmp(exp->expectant->helper->name, info->name,=20
+	               strlen(exp->expectant->helper->name)) ^ info->invert;
+out_unlock:
+	READ_UNLOCK(&ip_conntrack_lock);
+	return ret;
 }
=20
 static int check(const char *tablename,
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--aO2SyuDEANnesPMC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IZiKXaXGVTD0i/8RAjtBAJ0WIqAK5xDIEKAREzElGr426h9vcgCfVJ0v
UYNkQU4STpgCJwExWofwUFg=
=a/z8
-----END PGP SIGNATURE-----

--aO2SyuDEANnesPMC--
