From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/05]: nf_conntrack: automatic sysctl registation for
	conntrack protocols
Date: Sun, 26 Nov 2006 15:44:50 +0100 (MET)
Message-ID: <20061126144450.4215.9710.sendpatchset@localhost.localdomain>
References: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: automatic sysctl registation for conntrack protocols

Add helper functions for sysctl registration with optional instantiating
of common path elements (like net/netfilter) and use it for support for
automatic registation of conntrack protocol sysctls.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8393250806afefb7cece0a4a9309b02477e6bef1
tree 71a6789b78f5f674096d4be091f4d02c9af83e99
parent 45df81e6d97daa98b77ef71b2488c167af1f6c80
author Patrick McHardy <kaber@trash.net> Sat, 25 Nov 2006 19:03:40 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 25 Nov 2006 19:03:40 +0100

 include/linux/netfilter.h                    |    8 ++
 include/net/netfilter/nf_conntrack_l3proto.h |    6 +
 include/net/netfilter/nf_conntrack_l4proto.h |    6 +
 net/netfilter/Makefile                       |    1 
 net/netfilter/nf_conntrack_proto.c           |  101 ++++++++++++++++++++
 net/netfilter/nf_conntrack_standalone.c      |    4 -
 net/netfilter/nf_sysctl.c                    |  132 ++++++++++++++++++++++++++
 7 files changed, 254 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 6ab5e2d..4e8a03d 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -117,6 +117,14 @@ void nf_unregister_hooks(struct nf_hook_
 int nf_register_sockopt(struct nf_sockopt_ops *reg);
 void nf_unregister_sockopt(struct nf_sockopt_ops *reg);
 
+/* Sysctl registration */
+struct ctl_table_header *nf_register_sysctl_table(struct ctl_table *path,
+						  struct ctl_table *table);
+void nf_unregister_sysctl_table(struct ctl_table_header *header,
+				struct ctl_table *table);
+extern struct ctl_table nf_net_netfilter_sysctl_path[];
+extern struct ctl_table nf_net_ipv4_netfilter_sysctl_path[];
+
 extern struct list_head nf_hooks[NPROTO][NF_MAX_HOOKS];
 
 /* those NF_LOG_* defines and struct nf_loginfo are legacy definitios that will
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 6364df0..664ddcf 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -75,6 +75,12 @@ struct nf_conntrack_l3proto
 	int (*nfattr_to_tuple)(struct nfattr *tb[],
 			       struct nf_conntrack_tuple *t);
 
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header	*ctl_table_header;
+	struct ctl_table	*ctl_table_path;
+	struct ctl_table	*ctl_table;
+#endif /* CONFIG_SYSCTL */
+
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index c22804a..fe1e8fa 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -76,6 +76,12 @@ struct nf_conntrack_l4proto
 	int (*nfattr_to_tuple)(struct nfattr *tb[],
 			       struct nf_conntrack_tuple *t);
 
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header	**ctl_table_header;
+	struct ctl_table	*ctl_table;
+	unsigned int		*ctl_table_users;
+#endif /* CONFIG_SYSCTL */
+
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 32c0e3b..7f0089c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -4,6 +4,7 @@ nf_conntrack-y	:= nf_conntrack_core.o nf
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
+obj-$(CONFIG_SYSCTL) += nf_sysctl.o
 
 obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index a6a3b1d..0afc298 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/skbuff.h>
 #include <linux/vmalloc.h>
 #include <linux/stddef.h>
@@ -30,6 +31,34 @@ #include <net/netfilter/nf_conntrack_cor
 struct nf_conntrack_l4proto **nf_ct_protos[PF_MAX] __read_mostly;
 struct nf_conntrack_l3proto *nf_ct_l3protos[AF_MAX] __read_mostly;
 
+#ifdef CONFIG_SYSCTL
+static DEFINE_MUTEX(nf_ct_proto_sysctl_mutex);
+
+static int
+nf_ct_register_sysctl(struct ctl_table_header **header, struct ctl_table *path,
+		      struct ctl_table *table, unsigned int *users)
+{
+	if (*header == NULL) {
+		*header = nf_register_sysctl_table(path, table);
+		if (*header == NULL)
+			return -ENOMEM;
+	}
+	if (users != NULL)
+		(*users)++;
+	return 0;
+}
+
+static void
+nf_ct_unregister_sysctl(struct ctl_table_header **header,
+			struct ctl_table *table, unsigned int *users)
+{
+	if (users != NULL && --*users > 0)
+		return;
+	nf_unregister_sysctl_table(*header, table);
+	*header = NULL;
+}
+#endif
+
 struct nf_conntrack_l4proto *
 __nf_ct_l4proto_find(u_int16_t l3proto, u_int8_t l4proto)
 {
@@ -124,6 +153,33 @@ static int kill_l4proto(struct nf_conn *
 			l4proto->l3proto);
 }
 
+static int nf_ct_l3proto_register_sysctl(struct nf_conntrack_l3proto *l3proto)
+{
+	int err = 0;
+
+#ifdef CONFIG_SYSCTL
+	mutex_lock(&nf_ct_proto_sysctl_mutex);
+	if (l3proto->ctl_table != NULL) {
+		err = nf_ct_register_sysctl(&l3proto->ctl_table_header,
+					    l3proto->ctl_table_path,
+					    l3proto->ctl_table, NULL);
+	}
+	mutex_unlock(&nf_ct_proto_sysctl_mutex);
+#endif
+	return err;
+}
+
+static void nf_ct_l3proto_unregister_sysctl(struct nf_conntrack_l3proto *l3proto)
+{
+#ifdef CONFIG_SYSCTL
+	mutex_lock(&nf_ct_proto_sysctl_mutex);
+	if (l3proto->ctl_table != NULL)
+		nf_ct_unregister_sysctl(&l3proto->ctl_table_header,
+					l3proto->ctl_table, NULL);
+	mutex_unlock(&nf_ct_proto_sysctl_mutex);
+#endif
+}
+
 int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto)
 {
 	int ret = 0;
@@ -139,6 +195,12 @@ int nf_conntrack_l3proto_register(struct
 		goto out_unlock;
 	}
 	nf_ct_l3protos[proto->l3proto] = proto;
+	write_unlock_bh(&nf_conntrack_lock);
+
+	ret = nf_ct_l3proto_register_sysctl(proto);
+	if (ret < 0)
+		nf_conntrack_l3proto_unregister(proto);
+	return ret;
 
 out_unlock:
 	write_unlock_bh(&nf_conntrack_lock);
@@ -165,6 +227,8 @@ int nf_conntrack_l3proto_unregister(stru
 	nf_ct_l3protos[proto->l3proto] = &nf_conntrack_l3proto_generic;
 	write_unlock_bh(&nf_conntrack_lock);
 
+	nf_ct_l3proto_unregister_sysctl(proto);
+
 	/* Somebody could be still looking at the proto in bh. */
 	synchronize_net();
 
@@ -175,6 +239,35 @@ out:
 	return ret;
 }
 
+static int nf_ct_l4proto_register_sysctl(struct nf_conntrack_l4proto *l4proto)
+{
+	int err = 0;
+
+#ifdef CONFIG_SYSCTL
+	mutex_lock(&nf_ct_proto_sysctl_mutex);
+	if (l4proto->ctl_table != NULL) {
+		err = nf_ct_register_sysctl(l4proto->ctl_table_header,
+					    nf_net_netfilter_sysctl_path,
+					    l4proto->ctl_table,
+					    l4proto->ctl_table_users);
+	}
+	mutex_unlock(&nf_ct_proto_sysctl_mutex);
+#endif
+	return err;
+}
+
+static void nf_ct_l4proto_unregister_sysctl(struct nf_conntrack_l4proto *l4proto)
+{
+#ifdef CONFIG_SYSCTL
+	mutex_lock(&nf_ct_proto_sysctl_mutex);
+	if (l4proto->ctl_table != NULL)
+		nf_ct_unregister_sysctl(l4proto->ctl_table_header,
+					l4proto->ctl_table,
+					l4proto->ctl_table_users);
+	mutex_unlock(&nf_ct_proto_sysctl_mutex);
+#endif
+}
+
 /* FIXME: Allow NULL functions and sub in pointers to generic for
    them. --RR */
 int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *l4proto)
@@ -230,6 +323,12 @@ retry:
 	}
 
 	nf_ct_protos[l4proto->l3proto][l4proto->l4proto] = l4proto;
+	write_unlock_bh(&nf_conntrack_lock);
+
+	ret = nf_ct_l4proto_register_sysctl(l4proto);
+	if (ret < 0)
+		nf_conntrack_l4proto_unregister(l4proto);
+	return ret;
 
 out_unlock:
 	write_unlock_bh(&nf_conntrack_lock);
@@ -257,6 +356,8 @@ int nf_conntrack_l4proto_unregister(stru
 		= &nf_conntrack_l4proto_generic;
 	write_unlock_bh(&nf_conntrack_lock);
 
+	nf_ct_l4proto_unregister_sysctl(l4proto);
+
 	/* Somebody could be still looking at the proto in bh. */
 	synchronize_net();
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 6ab95b0..2283a26 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -331,10 +331,6 @@ int nf_conntrack_checksum __read_mostly 
 
 #ifdef CONFIG_SYSCTL
 
-/* From nf_conntrack_core.c */
-extern int nf_conntrack_max;
-extern unsigned int nf_conntrack_htable_size;
-
 /* From nf_conntrack_proto_tcp.c */
 extern unsigned int nf_ct_tcp_timeout_syn_sent;
 extern unsigned int nf_ct_tcp_timeout_syn_recv;
diff --git a/net/netfilter/nf_sysctl.c b/net/netfilter/nf_sysctl.c
new file mode 100644
index 0000000..18e0186
--- /dev/null
+++ b/net/netfilter/nf_sysctl.c
@@ -0,0 +1,132 @@
+/* nf_sysctl.c	netfilter sysctl registration/unregistation
+ *
+ * Copyright (c) 2006 Patrick McHardy <kaber@trash.net>
+ */
+#include <linux/module.h>
+#include <linux/sysctl.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+static void
+path_free(struct ctl_table *path, struct ctl_table *table)
+{
+	struct ctl_table *t, *next;
+
+	for (t = path; t != NULL && t != table; t = next) {
+		next = t->child;
+		kfree(t);
+	}
+}
+
+static struct ctl_table *
+path_dup(struct ctl_table *path, struct ctl_table *table)
+{
+	struct ctl_table *t, *last = NULL, *tmp;
+
+	for (t = path; t != NULL; t = t->child) {
+		tmp = kmemdup(t, 2 * sizeof(*t), GFP_KERNEL);
+		if (tmp == NULL) {
+			if (last != NULL)
+				path_free(path, table);
+			return NULL;
+		}
+
+		if (last != NULL)
+			last->child = tmp;
+		else
+			path = tmp;
+		last = tmp;
+	}
+
+	if (last != NULL)
+		last->child = table;
+	else
+		path = table;
+
+	return path;
+}
+
+struct ctl_table_header *
+nf_register_sysctl_table(struct ctl_table *path, struct ctl_table *table)
+{
+	struct ctl_table_header *header;
+
+	path = path_dup(path, table);
+	if (path == NULL)
+		return NULL;
+	header = register_sysctl_table(path, 0);
+	if (header == NULL)
+		path_free(path, table);
+	return header;
+}
+EXPORT_SYMBOL_GPL(nf_register_sysctl_table);
+
+void
+nf_unregister_sysctl_table(struct ctl_table_header *header,
+			   struct ctl_table *table)
+{
+	struct ctl_table *path = header->ctl_table;
+
+	unregister_sysctl_table(header);
+	path_free(path, table);
+}
+EXPORT_SYMBOL_GPL(nf_unregister_sysctl_table);
+
+/* net/netfilter */
+static struct ctl_table nf_net_netfilter_table[] = {
+	{
+		.ctl_name	= NET_NETFILTER,
+		.procname	= "netfilter",
+		.mode		= 0555,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+struct ctl_table nf_net_netfilter_sysctl_path[] = {
+	{
+		.ctl_name	= CTL_NET,
+		.procname	= "net",
+		.mode		= 0555,
+		.child		= nf_net_netfilter_table,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+EXPORT_SYMBOL_GPL(nf_net_netfilter_sysctl_path);
+
+/* net/ipv4/netfilter */
+static struct ctl_table nf_net_ipv4_netfilter_table[] = {
+	{
+		.ctl_name	= NET_IPV4_NETFILTER,
+		.procname	= "netfilter",
+		.mode		= 0555,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+static struct ctl_table nf_net_ipv4_table[] = {
+	{
+		.ctl_name	= NET_IPV4,
+		.procname	= "ipv4",
+		.mode		= 0555,
+		.child		= nf_net_ipv4_netfilter_table,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+struct ctl_table nf_net_ipv4_netfilter_sysctl_path[] = {
+	{
+		.ctl_name	= CTL_NET,
+		.procname	= "net",
+		.mode		= 0555,
+		.child		= nf_net_ipv4_table,
+	},
+	{
+		.ctl_name	= 0
+	}
+};
+EXPORT_SYMBOL_GPL(nf_net_ipv4_netfilter_sysctl_path);
