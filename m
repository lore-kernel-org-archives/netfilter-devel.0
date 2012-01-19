From: Jan Engelhardt <jengelh@medozas.de>
Subject: =?UTF-8?q?=5BPATCH=201/7=5D=20netfilter=3A=20xtables2=3A=20initial=20table=20skeletal=20functions?=
Date: Thu, 19 Jan 2012 17:26:15 +0100
Message-ID: <1326990381-14534-2-git-send-email-jengelh@medozas.de>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57968 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab2ASQ0Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:26:24 -0500
In-Reply-To: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the xt2 table functions. Of course this does not do
anything useful yet, chain and rule support directly follow.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/net/netfilter/x_tables2.h |   17 +++++++
 net/netfilter/Kconfig             |    8 +++-
 net/netfilter/Makefile            |    1 +
 net/netfilter/xt2_core.c          |   85 +++++++++++++++++++++++++++++=
++++++++
 4 files changed, 110 insertions(+), 1 deletions(-)
 create mode 100644 include/net/netfilter/x_tables2.h
 create mode 100644 net/netfilter/xt2_core.c

diff --git a/include/net/netfilter/x_tables2.h b/include/net/netfilter/=
x_tables2.h
new file mode 100644
index 0000000..a219952
--- /dev/null
+++ b/include/net/netfilter/x_tables2.h
@@ -0,0 +1,17 @@
+#ifndef _NET_NETFILTER_XTABLES2_H
+#define _NET_NETFILTER_XTABLES2_H 1
+
+#define XTABLES2_VTAG "Xtables2 A8"
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
+#endif /* _NET_NETFILTER_XTABLES2_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 32bff6d..5b3d9ca 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -321,7 +321,13 @@ config NETFILTER_XTABLES
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
index 1a02853..8504ebd 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_NETFILTER_TPROXY) +=3D nf_tproxy_core.o
=20
 # generic X tables=20
 obj-$(CONFIG_NETFILTER_XTABLES) +=3D x_tables.o xt_tcpudp.o
+obj-$(CONFIG_NETFILTER_XTABLES2) +=3D xt2_core.o
=20
 # combos
 obj-$(CONFIG_NETFILTER_XT_MARK) +=3D xt_mark.o
diff --git a/net/netfilter/xt2_core.c b/net/netfilter/xt2_core.c
new file mode 100644
index 0000000..ab73c4d
--- /dev/null
+++ b/net/netfilter/xt2_core.c
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
+#include <net/netfilter/x_tables2.h>
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
+	pr_info(XTABLES2_VTAG ", (C) 2009-2012, J.Engelhardt\n");
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
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
