From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 13/14]: realm match
Date: Mon, 21 Jun 2004 21:45:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194540.GS24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sNTM2e4Famet7VLS"
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


--sNTM2e4Famet7VLS
Content-Type: multipart/mixed; boundary="A7r2ZSzTc5uUoZ5x"
Content-Disposition: inline


--A7r2ZSzTc5uUoZ5x
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 adds the realm match.

Author: Sampsa Ranta <sampsa@netsonic.fi>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--A7r2ZSzTc5uUoZ5x
Content-Type: text/plain; charset=us-ascii; name="13.diff"
Content-Disposition: inline; filename="13.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:48:47+02:00 kaber@trash.net=20
#   [NETFILTER]: Add realm match
#=20
# net/ipv4/netfilter/ipt_realm.c
#   2004/06/20 22:48:37+02:00 kaber@trash.net +76 -0
#=20
# include/linux/netfilter_ipv4/ipt_realm.h
#   2004/06/20 22:48:37+02:00 kaber@trash.net +10 -0
#=20
# net/sched/Kconfig
#   2004/06/20 22:48:37+02:00 kaber@trash.net +2 -2
#   [NETFILTER]: Add realm match
#=20
# net/ipv4/netfilter/ipt_realm.c
#   2004/06/20 22:48:37+02:00 kaber@trash.net +0 -0
#   BitKeeper file /home/kaber/src/nf/pending/linux-2.6/net/ipv4/netfilter/=
ipt_realm.c
#=20
# net/ipv4/netfilter/Makefile
#   2004/06/20 22:48:37+02:00 kaber@trash.net +1 -0
#   [NETFILTER]: Add realm match
#=20
# net/ipv4/netfilter/Kconfig
#   2004/06/20 22:48:37+02:00 kaber@trash.net +14 -0
#   [NETFILTER]: Add realm match
#=20
# include/linux/netfilter_ipv4/ipt_realm.h
#   2004/06/20 22:48:37+02:00 kaber@trash.net +0 -0
#   BitKeeper file /home/kaber/src/nf/pending/linux-2.6/include/linux/netfi=
lter_ipv4/ipt_realm.h
#=20
diff -Nru a/include/linux/netfilter_ipv4/ipt_realm.h b/include/linux/netfil=
ter_ipv4/ipt_realm.h
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/include/linux/netfilter_ipv4/ipt_realm.h	2004-06-20 23:01:23 +02:00
@@ -0,0 +1,10 @@
+#ifndef _IPT_REALM_H
+#define _IPT_REALM_H
+
+struct ipt_realm_info {
+	u_int32_t id;
+	u_int32_t mask;
+	u_int8_t invert;
+};
+
+#endif /* _IPT_REALM_H */
diff -Nru a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig	2004-06-20 23:01:23 +02:00
+++ b/net/ipv4/netfilter/Kconfig	2004-06-20 23:01:23 +02:00
@@ -613,5 +613,19 @@
 	  If you want to compile it as a module, say M here and read
 	  Documentation/modules.txt.  If unsure, say `N'.
=20
+config IP_NF_MATCH_REALM
+	tristate  'realm match support'
+	depends on IP_NF_IPTABLES
+	select NET_CLS_ROUTE
+	help
+	  This option adds a `realm' match, which allows you to use the realm
+	  key from the routing subsytem inside iptables.
+=09
+	  This match pretty much resembles the CONFIG_NET_CLS_ROUTE4 option=20
+	  in tc world.
+=09
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
+
 endmenu
=20
diff -Nru a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile	2004-06-20 23:01:23 +02:00
+++ b/net/ipv4/netfilter/Makefile	2004-06-20 23:01:23 +02:00
@@ -64,6 +64,7 @@
 obj-$(CONFIG_IP_NF_MATCH_STATE) +=3D ipt_state.o
 obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) +=3D ipt_conntrack.o
 obj-$(CONFIG_IP_NF_MATCH_TCPMSS) +=3D ipt_tcpmss.o
+obj-$(CONFIG_IP_NF_MATCH_REALM) +=3D ipt_realm.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) +=3D ipt_addrtype.o
=20
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) +=3D ipt_physdev.o
diff -Nru a/net/ipv4/netfilter/ipt_realm.c b/net/ipv4/netfilter/ipt_realm.c
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/net/ipv4/netfilter/ipt_realm.c	2004-06-20 23:01:23 +02:00
@@ -0,0 +1,76 @@
+/* IP tables module for matching the routing realm
+ *
+ * $Id: ipt_realm.c,v 1.3 2004/03/05 13:25:40 laforge Exp $
+ *
+ * (C) 2003 by Sampsa Ranta <sampsa@netsonic.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <net/route.h>
+
+#include <linux/netfilter_ipv4/ipt_realm.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+MODULE_AUTHOR("Sampsa Ranta <sampsa@netsonic.fi>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("iptables realm match");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_realm_info *info =3D matchinfo;
+	struct dst_entry *dst =3D skb->dst;
+   =20
+	return (info->id =3D=3D (dst->tclassid & info->mask)) ^ info->invert;
+}
+
+static int check(const char *tablename,
+                 const struct ipt_ip *ip,
+                 void *matchinfo,
+                 unsigned int matchsize,
+                 unsigned int hook_mask)
+{
+	if (hook_mask
+	    & ~((1 << NF_IP_POST_ROUTING) | (1 << NF_IP_FORWARD) |
+	        (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_LOCAL_IN))) {
+		printk("ipt_realm: only valid for POST_ROUTING, LOCAL_OUT, "
+		       "LOCAL_IN or FORWARD.\n");
+		return 0;
+	}
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_realm_info))) {
+		printk("ipt_realm: invalid matchsize.\n");
+		return 0;
+	}
+	return 1;
+}
+
+static struct ipt_match realm_match =3D {
+	.name		=3D "realm",
+	.match		=3D match,=20
+	.checkentry	=3D check,
+	.me		=3D THIS_MODULE
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&realm_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&realm_match);
+}
+
+module_init(init);
+module_exit(fini);
diff -Nru a/net/sched/Kconfig b/net/sched/Kconfig
--- a/net/sched/Kconfig	2004-06-20 23:01:23 +02:00
+++ b/net/sched/Kconfig	2004-06-20 23:01:23 +02:00
@@ -242,6 +242,7 @@
 config NET_CLS_ROUTE4
 	tristate "Routing table based classifier"
 	depends on NET_CLS
+	select NET_CLS_ROUTE
 	help
 	  If you say Y here, you will be able to classify outgoing packets
 	  according to the route table entry they matched. If unsure, say Y.
@@ -251,8 +252,7 @@
=20
 config NET_CLS_ROUTE
 	bool
-	depends on NET_CLS_ROUTE4
-	default y
+	default n
=20
 config NET_CLS_FW
 	tristate "Firewall based classifier"


--A7r2ZSzTc5uUoZ5x--

--sNTM2e4Famet7VLS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zrkXaXGVTD0i/8RAg4lAJ9VhtD8N5K3wjqh3ifcw5NhBBDGRACeJ2wh
hn6QbH1lp7RU82TjPCY2dzM=
=Bk9r
-----END PGP SIGNATURE-----

--sNTM2e4Famet7VLS--
