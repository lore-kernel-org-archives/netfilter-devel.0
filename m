From: Eric Leblond <eric@regit.org>
Subject: [PATCH] conntrack: add /proc entry to disable helper by default
Date: Tue, 27 Mar 2012 00:05:02 +0200
Message-ID: <1332799502-11623-2-git-send-email-eric@regit.org>
References: <1332799502-11623-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45397 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2CZWqI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:46:08 -0400
In-Reply-To: <1332799502-11623-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch give the user different methods to disable
the attachment of helper to all connections on a given
port. The idea is to allow the user to choose with the CT target
the helper assignement he wants to have.

First method it to use the 'no_helper_assign' option on the
nf_conntrack module. As this is a constraint to do this at the time
of the loading, a /proc entry is also available.
Setting sys/net/netfilter/nf_conntrack_no_helper_assign to 1 will
disable the automatic assignement of the helper. The user will
---
 include/net/netfilter/nf_conntrack_helper.h |    3 +
 include/net/netns/conntrack.h               |    2 +
 net/netfilter/nf_conntrack_core.c           |    6 ++
 net/netfilter/nf_conntrack_helper.c         |   79 ++++++++++++++++++++++++++-
 4 files changed, 88 insertions(+), 2 deletions(-)

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
index 7a911ec..2395288 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -26,11 +26,13 @@ struct netns_ct {
 	int			sysctl_tstamp;
 	int			sysctl_checksum;
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
+	int			sysctl_no_helper_assign;
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
index bbe23ba..9663494 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -34,6 +34,67 @@ static struct hlist_head *nf_ct_helper_hash __read_mostly;
 static unsigned int nf_ct_helper_hsize __read_mostly;
 static unsigned int nf_ct_helper_count __read_mostly;
 
+static bool nf_ct_no_helper_assign __read_mostly;
+module_param_named(no_helper_assign, nf_ct_no_helper_assign, bool, 0644);
+MODULE_PARM_DESC(no_helper_assign, "Do not assign helper to connection based on port.");
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table helper_sysctl_table[] = {
+	{
+		.procname	= "nf_conntrack_no_helper_assign",
+		.data		= &init_net.ct.sysctl_no_helper_assign,
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
+	table[0].data = &net->ct.sysctl_no_helper_assign;
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
+	if ((helper == NULL) && !net->ct.sysctl_no_helper_assign)
 		helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+
 	if (helper == NULL) {
 		if (help)
 			RCU_INIT_POINTER(help->helper, NULL);
@@ -273,7 +337,6 @@ int nf_conntrack_helper_init(void)
 	err = nf_ct_extend_register(&helper_extend);
 	if (err < 0)
 		goto err1;
-
 	return 0;
 
 err1:
@@ -281,8 +344,20 @@ err1:
 	return err;
 }
 
+int nf_conntrack_helper_init_net(struct net *net)
+{
+	net->ct.sysctl_no_helper_assign = nf_ct_no_helper_assign;
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

