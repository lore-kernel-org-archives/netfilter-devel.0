From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/3] netfilter: add ruleid extension
Date: Thu, 20 Jan 2011 23:47:05 +0100
Message-ID: <1295563629-14996-2-git-send-email-richard@nod.at>
References: <1295563629-14996-1-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:39945 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab1ATWr3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:47:29 -0500
In-Reply-To: <1295563629-14996-1-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The ruleid extension makes it possible to store rule ids into
connection tracking entries.
Each connection tracking entry can up to four rule ids.
For ESTABLISHED, RELATED, NEW and REPLY.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/net/netfilter/nf_conntrack_extend.h |    2 +
 include/net/netfilter/nf_conntrack_ruleid.h |   25 +++++++++++++++
 net/netfilter/Makefile                      |    2 +-
 net/netfilter/nf_conntrack_core.c           |    6 ++++
 net/netfilter/nf_conntrack_ruleid.c         |   44 +++++++++++++++++++++++++++
 5 files changed, 78 insertions(+), 1 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_ruleid.h
 create mode 100644 net/netfilter/nf_conntrack_ruleid.c

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 0772d29..12053c2 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -11,6 +11,7 @@ enum nf_ct_ext_id {
 	NF_CT_EXT_ACCT,
 	NF_CT_EXT_ECACHE,
 	NF_CT_EXT_ZONE,
+	NF_CT_EXT_RULEID,
 	NF_CT_EXT_NUM,
 };
 
@@ -19,6 +20,7 @@ enum nf_ct_ext_id {
 #define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
 #define NF_CT_EXT_ECACHE_TYPE struct nf_conntrack_ecache
 #define NF_CT_EXT_ZONE_TYPE struct nf_conntrack_zone
+#define NF_CT_EXT_RULEID_TYPE struct nf_conn_ruleid
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/include/net/netfilter/nf_conntrack_ruleid.h b/include/net/netfilter/nf_conntrack_ruleid.h
new file mode 100644
index 0000000..98f7d0a
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_ruleid.h
@@ -0,0 +1,25 @@
+/*
+ * (C) 2011 Richard Weinberger <richard@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _NF_CONNTRACK_RULEID_H
+#define _NF_CONNTRACK_RULEID_H
+
+#include <net/net_namespace.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+
+struct nf_conn_ruleid {
+	u_int16_t rule[IP_CT_NUMBER - 1];
+};
+
+extern int nf_conntrack_ruleid_init(struct net *net);
+extern void nf_conntrack_ruleid_fini(struct net *net);
+
+#endif /* _NF_CONNTRACK_RULEID_H */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 441050f..f5bff47 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,6 +1,6 @@
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
 
-nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_ruleid.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 27a5ea6..818126a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -42,6 +42,7 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_ruleid.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
@@ -1502,9 +1503,14 @@ static int nf_conntrack_init_net(struct net *net)
 	ret = nf_conntrack_ecache_init(net);
 	if (ret < 0)
 		goto err_ecache;
+	ret = nf_conntrack_ruleid_init(net);
+	if (ret < 0)
+		goto err_ruleid;
 
 	return 0;
 
+err_ruleid:
+	nf_conntrack_ecache_fini(net);
 err_ecache:
 	nf_conntrack_acct_fini(net);
 err_acct:
diff --git a/net/netfilter/nf_conntrack_ruleid.c b/net/netfilter/nf_conntrack_ruleid.c
new file mode 100644
index 0000000..887f4cd
--- /dev/null
+++ b/net/netfilter/nf_conntrack_ruleid.c
@@ -0,0 +1,44 @@
+/*
+ * (C) 2011 Richard Weinberger <richard@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/netfilter.h>
+#include <linux/kernel.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_ruleid.h>
+
+static struct nf_ct_ext_type ruleid_extend __read_mostly = {
+	.len	= sizeof(struct nf_conn_ruleid),
+	.align	= __alignof__(struct nf_conn_ruleid),
+	.id	= NF_CT_EXT_RULEID,
+};
+
+int nf_conntrack_ruleid_init(struct net *net)
+{
+	int ret = 0;
+
+	if (net_eq(net, &init_net)) {
+		ret = nf_ct_extend_register(&ruleid_extend);
+		if (ret < 0) {
+			printk(KERN_ERR "nf_conntrack_ruleid: Unable to register extension\n");
+			goto out;
+		}
+	}
+
+	return 0;
+
+out:
+	return ret;
+}
+
+void nf_conntrack_ruleid_fini(struct net *net)
+{
+	if (net_eq(net, &init_net))
+		nf_ct_extend_unregister(&ruleid_extend);
+}
-- 
1.6.6.1

