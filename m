From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 12/14]: addrtype match
Date: Mon, 21 Jun 2004 21:45:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194516.GR24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P2Q/RrmTZI8TdTk+"
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


--P2Q/RrmTZI8TdTk+
Content-Type: multipart/mixed; boundary="R6XNva+j4+N/cnqI"
Content-Disposition: inline


--R6XNva+j4+N/cnqI
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 adds the addrtype match.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--R6XNva+j4+N/cnqI
Content-Type: text/plain; charset=us-ascii; name="12.diff"
Content-Disposition: inline; filename="12.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:48:11+02:00 kaber@trash.net=20
#   [NETFILTER]: Add addrtype match
#=20
# net/ipv4/netfilter/ipt_addrtype.c
#   2004/06/20 22:48:01+02:00 kaber@trash.net +77 -0
#=20
# include/linux/netfilter_ipv4/ipt_addrtype.h
#   2004/06/20 22:48:01+02:00 kaber@trash.net +11 -0
#=20
# net/ipv4/netfilter/ipt_addrtype.c
#   2004/06/20 22:48:01+02:00 kaber@trash.net +0 -0
#   BitKeeper file /home/kaber/src/nf/pending/linux-2.6/net/ipv4/netfilter/=
ipt_addrtype.c
#=20
# net/ipv4/netfilter/Makefile
#   2004/06/20 22:48:01+02:00 kaber@trash.net +1 -0
#   [NETFILTER]: Add addrtype match
#=20
# net/ipv4/netfilter/Kconfig
#   2004/06/20 22:48:01+02:00 kaber@trash.net +10 -0
#   [NETFILTER]: Add addrtype match
#=20
# include/linux/netfilter_ipv4/ipt_addrtype.h
#   2004/06/20 22:48:01+02:00 kaber@trash.net +0 -0
#   BitKeeper file /home/kaber/src/nf/pending/linux-2.6/include/linux/netfi=
lter_ipv4/ipt_addrtype.h
#=20
diff -Nru a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/net=
filter_ipv4/ipt_addrtype.h
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/include/linux/netfilter_ipv4/ipt_addrtype.h	2004-06-20 23:01:12 +02:00
@@ -0,0 +1,11 @@
+#ifndef _IPT_ADDRTYPE_H
+#define _IPT_ADDRTYPE_H
+
+struct ipt_addrtype_info {
+	u_int16_t	source;		/* source-type mask */
+	u_int16_t	dest;		/* dest-type mask */
+	u_int32_t	invert_source;
+	u_int32_t	invert_dest;
+};
+
+#endif
diff -Nru a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig	2004-06-20 23:01:12 +02:00
+++ b/net/ipv4/netfilter/Kconfig	2004-06-20 23:01:12 +02:00
@@ -603,5 +603,15 @@
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 	  help
=20
+config IP_NF_MATCH_ADDRTYPE
+	tristate  'address type match support'
+	depends on IP_NF_IPTABLES
+	help
+	  This option allows you to match what routing thinks of an address,
+	  eg. UNICAST, LOCAL, BROADCAST, ...
+=09
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
+
 endmenu
=20
diff -Nru a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile	2004-06-20 23:01:12 +02:00
+++ b/net/ipv4/netfilter/Makefile	2004-06-20 23:01:12 +02:00
@@ -64,6 +64,7 @@
 obj-$(CONFIG_IP_NF_MATCH_STATE) +=3D ipt_state.o
 obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) +=3D ipt_conntrack.o
 obj-$(CONFIG_IP_NF_MATCH_TCPMSS) +=3D ipt_tcpmss.o
+obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) +=3D ipt_addrtype.o
=20
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) +=3D ipt_physdev.o
=20
diff -Nru a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addr=
type.c
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/net/ipv4/netfilter/ipt_addrtype.c	2004-06-20 23:01:12 +02:00
@@ -0,0 +1,77 @@
+/*
+ *  iptables module to match inet_addr_type() of an ip.
+ *
+ *  Copyright (c) 2004 Patrick McHardy <kaber@trash.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/ip.h>
+#include <net/route.h>
+
+#include <linux/netfilter_ipv4/ipt_addrtype.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("iptables addrtype match");
+
+static inline int match_type(u_int32_t addr, u_int16_t mask)
+{
+	return !!(mask & (1 << inet_addr_type(addr)));
+}
+
+static int match(const struct sk_buff *skb, const struct net_device *in,
+		 const struct net_device *out, const void *matchinfo,
+		 int offset, int *hotdrop)
+{
+	const struct ipt_addrtype_info *info =3D matchinfo;
+	const struct iphdr *iph =3D skb->nh.iph;
+	int ret =3D 1;
+
+	if (info->source)
+		ret &=3D match_type(iph->saddr, info->source)^info->invert_source;
+	if (info->dest)
+		ret &=3D match_type(iph->daddr, info->dest)^info->invert_dest;
+=09
+	return ret;
+}
+
+static int checkentry(const char *tablename, const struct ipt_ip *ip,
+		      void *matchinfo, unsigned int matchsize,
+		      unsigned int hook_mask)
+{
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_addrtype_info))) {
+		printk(KERN_ERR "ipt_addrtype: invalid size (%u !=3D %u)\n.",
+		       matchsize, IPT_ALIGN(sizeof(struct ipt_addrtype_info)));
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_match addrtype_match =3D {
+	.name		=3D "addrtype",
+	.match		=3D match,
+	.checkentry	=3D checkentry,
+	.me		=3D THIS_MODULE
+};
+
+static int __init init(void)
+{
+	return ipt_register_match(&addrtype_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&addrtype_match);
+}
+
+module_init(init);
+module_exit(fini);


--R6XNva+j4+N/cnqI--

--P2Q/RrmTZI8TdTk+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1zrMXaXGVTD0i/8RAjj8AJ4k+KX6sCQAmpi3ZUAK3EP0+pN87ACffd3L
f9Kt2IB0BgW0cKdpMnXOG3I=
=XkpG
-----END PGP SIGNATURE-----

--P2Q/RrmTZI8TdTk+--
