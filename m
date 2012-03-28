From: Eric Leblond <eric@regit.org>
Subject: [PATCH v2] conntrack: add /proc entry to disable helper by default
Date: Wed, 28 Mar 2012 08:57:04 +0200
Message-ID: <1332917824-4839-1-git-send-email-eric@regit.org>
References: <20120327153609.GA18768@1984>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47510 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2C1G6M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:58:12 -0400
In-Reply-To: <20120327153609.GA18768@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch gives the user different methods to disable
the attachment of helper to all connections on a given
port. The idea is to allow the user to choose with the CT target
the helper assignement he wants to have.

First method it to use the 'nf_conntrack_helper' option on the
nf_conntrack module and set it to 0. As this is a constraint to do
this at the time of the loading, a /proc entry is also available.
Setting sys/net/netfilter/nf_conntrack_auto_assign_helper to 0 will
disable the automatic assignement of the helper.
---
 include/net/netfilter/nf_conntrack_helper.h |    3 +
 include/net/netns/conntrack.h               |    2 +
 net/netfilter/nf_conntrack_core.c           |    6 ++
 net/netfilter/nf_conntrack_helper.c         |   82 ++++++++++++++++++++++++++-
 4 files changed, 92 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index f1c1311..abd2fc83 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -63,6 +63,9 @@ static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 extern int nf_conntrack_helper_init(void);
 extern void nf_conntrack_helper_fini(void);
 
+extern int nf_conntrack_helper_init_net(struct net *net);
+extern void nf_conntrack_helper_fini_net(struct net *net);
+
 extern int nf_conntrack_broadcast_help(struct sk_buff *skb,
 				       unsigned int protoff,
 				       struct nf_conn *ct,
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 7a911ec..7e21aec 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -26,11 +26,13 @@ struct netns_ct {
 	int			sysctl_tstamp;
 	int			sysctl_checksum;
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
+	int			sysctl_auto_assign_helper;
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_header;
 	struct ctl_table_header	*acct_sysctl_header;
 	struct ctl_table_header	*tstamp_sysctl_header;
 	struct ctl_table_header	*event_sysctl_header;
+	struct ctl_table_header	*helper_sysctl_header;
 #endif
 	char			*slabname;
 };
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 76613f5..5faeb75 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1301,6 +1301,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 	nf_conntrack_tstamp_fini(net);
 	nf_conntrack_acct_fini(net);
 	nf_conntrack_expect_fini(net);
+	nf_conntrack_helper_fini_net(net);
 	kmem_cache_destroy(net->ct.nf_conntrack_cachep);
 	kfree(net->ct.slabname);
 	free_percpu(net->ct.stat);
@@ -1528,9 +1529,14 @@ static int nf_conntrack_init_net(struct net *net)
 	ret = nf_conntrack_ecache_init(net);
 	if (ret < 0)
 		goto err_ecache;
+	ret = nf_conntrack_helper_init_net(net);
+	if (ret < 0)
+		goto err_helper;
 
 	return 0;
 
+err_helper:
+	nf_conntrack_helper_fini_net(net);
 err_ecache:
 	nf_conntrack_tstamp_fini(net);
 err_tstamp:
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index bbe23ba..f84ab44 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -34,6 +34,67 @@ static struct hlist_head *nf_ct_helper_hash __read_mostly;
 static unsigned int nf_ct_helper_hsize __read_mostly;
 static unsigned int nf_ct_helper_count __read_mostly;
 
+static bool nf_ct_auto_assign_helper __read_mostly = 1;
+module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
+MODULE_PARM_DESC(nf_conntrack_helper, "Assign helper to connection based on port (default 1)");
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table helper_sysctl_table[] = {
+	{
+		.procname	= "nf_conntrack_auto_assign_helper",
+		.data		= &init_net.ct.sysctl_auto_assign_helper,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{}
+};
+
+static int nf_conntrack_helper_init_sysctl(struct net *net)
+{
+	struct ctl_table *table;
+
+	table = kmemdup(helper_sysctl_table, sizeof(helper_sysctl_table),
+			GFP_KERNEL);
+	if (!table)
+		goto out;
+
+	table[0].data = &net->ct.sysctl_auto_assign_helper;
+
+	net->ct.helper_sysctl_header = register_net_sysctl_table(net,
+			nf_net_netfilter_sysctl_path, table);
+	if (!net->ct.helper_sysctl_header) {
+		printk(KERN_ERR "nf_conntrack_helper: can't register to sysctl.\n");
+		goto out_register;
+	}
+	return 0;
+
+out_register:
+	kfree(table);
+out:
+	return -ENOMEM;
+}
+
+static void nf_conntrack_helper_fini_sysctl(struct net *net)
+{
+	struct ctl_table *table;
+
+	table = net->ct.helper_sysctl_header->ctl_table_arg;
+	unregister_net_sysctl_table(net->ct.helper_sysctl_header);
+	kfree(table);
+}
+#else
+static int nf_conntrack_helper_init_sysctl(struct net *net)
+{
+	return 0;
+}
+
+static void nf_conntrack_helper_fini_sysctl(struct net *net)
+{
+}
+#endif /* CONFIG_SYSCTL */
+
+
 
 /* Stupid hash, but collision free for the default registrations of the
  * helpers currently in the kernel. */
@@ -118,6 +179,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 {
 	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conn_help *help;
+	struct net *net = nf_ct_net(ct);
 	int ret = 0;
 
 	if (tmpl != NULL) {
@@ -127,8 +189,10 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	}
 
 	help = nfct_help(ct);
-	if (helper == NULL)
+
+	if (net->ct.sysctl_auto_assign_helper && helper == NULL)
 		helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
 	if (helper == NULL) {
 		if (help)
 			RCU_INIT_POINTER(help->helper, NULL);
@@ -270,6 +334,10 @@ int nf_conntrack_helper_init(void)
 	if (!nf_ct_helper_hash)
 		return -ENOMEM;
 
+	printk(KERN_INFO "nf_conntrack: automatic assignation of helper to"
+	       " connection will be disabled soon. Set nf_conntrack_helper"
+	       " option to 1 to keep old behavior.\n");
+
 	err = nf_ct_extend_register(&helper_extend);
 	if (err < 0)
 		goto err1;
@@ -281,8 +349,20 @@ err1:
 	return err;
 }
 
+int nf_conntrack_helper_init_net(struct net *net)
+{
+	net->ct.sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
+
+	return nf_conntrack_helper_init_sysctl(net);
+}
+
 void nf_conntrack_helper_fini(void)
 {
 	nf_ct_extend_unregister(&helper_extend);
 	nf_ct_free_hashtable(nf_ct_helper_hash, nf_ct_helper_hsize);
 }
+
+void nf_conntrack_helper_fini_net(struct net *net)
+{
+	nf_conntrack_helper_fini_sysctl(net);
+}
-- 
1.7.9.1

