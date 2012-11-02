From: Jan Engelhardt <jengelh@inai.de>
Subject: =?UTF-8?q?=5BPATCH=2001/11=5D=20netfilter=3A=20xtables2=3A=20initial=20table=20skeletal=20functions?=
Date: Fri,  2 Nov 2012 04:38:33 +0100
Message-ID: <1351827523-10629-2-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42666 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762645Ab2KBDkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:06 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the xt2 table functions. Of course this does not do
anything useful yet, chain and rule support directly follow.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h |   15 +++++++
 net/netfilter/Kconfig           |    8 +++-
 net/netfilter/Makefile          |    1 +
 net/netfilter/xt_core.c         |   85 +++++++++++++++++++++++++++++++=
++++++++
 4 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100644 include/net/netfilter/xt_core.h
 create mode 100644 net/netfilter/xt_core.c

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt=
_core.h
new file mode 100644
index 0000000..4ddaaae
--- /dev/null
+++ b/include/net/netfilter/xt_core.h
@@ -0,0 +1,15 @@
+#ifndef _NETFILTER_XTCORE_H
+#define _NETFILTER_XTCORE_H 1
+
+/**
+ * @master:	the master table
+ */
+struct xt2_pernet_data {
+	struct xt2_table __rcu *master;
+};
+
+struct xt2_table {
+	int _dummy;
+};
+
+#endif /* _NETFILTER_XTCORE_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index fefa514..56b19a1 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -429,7 +429,13 @@ config NETFILTER_XTABLES
 	  This is required if you intend to use any of ip_tables,
 	  ip6_tables or arp_tables.
=20
-if NETFILTER_XTABLES
+config NETFILTER_XTABLES2
+	tristate "Netfilter Xtables2 packet filtering"
+	---help---
+	Xtables2 is a rework of the internal architecture of Xtables.
+	It supersedes iptables, ip6tables, arptables and ebtables.
+
+if NETFILTER_XTABLES || NETFILTER_XTABLES2
=20
 comment "Xtables combined modules"
=20
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3259697..00eab5c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_NETFILTER_TPROXY) +=3D nf_tproxy_core.o
=20
 # generic X tables=20
 obj-$(CONFIG_NETFILTER_XTABLES) +=3D x_tables.o xt_tcpudp.o
+obj-$(CONFIG_NETFILTER_XTABLES2) +=3D xt_core.o
=20
 # combos
 obj-$(CONFIG_NETFILTER_XT_MARK) +=3D xt_mark.o
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
new file mode 100644
index 0000000..89dd0a0
--- /dev/null
+++ b/net/netfilter/xt_core.c
@@ -0,0 +1,85 @@
+/*
+ *	Xtables2 core
+ *	Copyright =C2=A9 Jan Engelhardt, 2009-2012
+ *
+ *	This program is free software: you can redistribute it and/or modif=
y
+ *	it under the terms of the GNU General Public License as published b=
y
+ *	the Free Software Foundation, either version 2 of the License, or
+ *	(at your option) any later version.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+#include <net/netfilter/xt_core.h>
+
+MODULE_DESCRIPTION("Netfilter Xtables2 packet filtering");
+MODULE_AUTHOR("Jan Engelhardt");
+MODULE_LICENSE("GPL");
+
+static int xtables2_net_id __read_mostly;
+
+static inline struct xt2_pernet_data *xtables2_pernet(struct net *net)
+{
+	return net_generic(net, xtables2_net_id);
+}
+
+/**
+ * Create a new table with no chains and no rules.
+ */
+static struct xt2_table *xt2_table_new(void)
+{
+	struct xt2_table *table;
+
+	table =3D kzalloc(sizeof(*table), GFP_KERNEL);
+	if (table =3D=3D NULL)
+		return NULL;
+
+	return table;
+}
+
+static void xt2_table_free(struct xt2_table *table)
+{
+	kfree(table);
+}
+
+static int __net_init xtables2_net_init(struct net *net)
+{
+	struct xt2_pernet_data *pnet =3D xtables2_pernet(net);
+
+	pnet->master =3D xt2_table_new();
+	if (IS_ERR(pnet->master))
+		return PTR_ERR(pnet->master);
+	return 0;
+}
+
+static void __net_exit xtables2_net_exit(struct net *net)
+{
+	struct xt2_pernet_data *pnet =3D xtables2_pernet(net);
+
+	xt2_table_free(pnet->master);
+}
+
+static struct pernet_operations xtables2_pernet_ops =3D {
+	.init =3D xtables2_net_init,
+	.exit =3D xtables2_net_exit,
+	.id   =3D &xtables2_net_id,
+	.size =3D sizeof(struct xt2_pernet_data),
+};
+
+static int __init xtables2_init(void)
+{
+	pr_info("Xtables2, (C) 2009-2012, J.Engelhardt\n");
+	return register_pernet_subsys(&xtables2_pernet_ops);
+}
+
+static void __exit xtables2_exit(void)
+{
+	unregister_pernet_subsys(&xtables2_pernet_ops);
+}
+
+module_init(xtables2_init);
+module_exit(xtables2_exit);
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
