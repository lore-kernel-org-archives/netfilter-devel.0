From: pablo@netfilter.org
Subject: [stable-3.7 09/14] netfilter: xt_hashlimit: fix namespace destroy path
Date: Mon, 28 Jan 2013 20:31:28 +0100
Message-ID: <1359401493-6196-10-git-send-email-pablo@netfilter.org>
References: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50495 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab3A1TcA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:32:00 -0500
In-Reply-To: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Vitaly E. Lavrov" <lve@guap.ru>

recent_net_exit() is called before recent_mt_destroy() in the
destroy path of network namespaces. Make sure there are no entries
in the parent proc entry xt_recent before removing it.

Signed-off-by: Vitaly E. Lavrov <lve@guap.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 26a668a..30ad0b62 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -318,7 +318,10 @@ static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 		parent = hashlimit_net->ipt_hashlimit;
 	else
 		parent = hashlimit_net->ip6t_hashlimit;
-	remove_proc_entry(hinfo->pde->name, parent);
+
+	if(parent != NULL)
+		remove_proc_entry(hinfo->pde->name, parent);
+
 	htable_selective_cleanup(hinfo, select_all);
 	vfree(hinfo);
 }
@@ -856,6 +859,27 @@ static int __net_init hashlimit_proc_net_init(struct net *net)
 
 static void __net_exit hashlimit_proc_net_exit(struct net *net)
 {
+	struct xt_hashlimit_htable *hinfo;
+	struct hlist_node *pos;
+	struct proc_dir_entry *pde;
+	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
+
+	/* recent_net_exit() is called before recent_mt_destroy(). Make sure
+	 * that the parent xt_recent proc entry is is empty before trying to
+	 * remove it.
+	 */
+	mutex_lock(&hashlimit_mutex);
+	pde = hashlimit_net->ipt_hashlimit;
+	if (pde == NULL)
+		pde = hashlimit_net->ip6t_hashlimit;
+
+	hlist_for_each_entry(hinfo, pos, &hashlimit_net->htables, node)
+		remove_proc_entry(hinfo->pde->name, pde);
+
+	hashlimit_net->ipt_hashlimit = NULL;
+	hashlimit_net->ip6t_hashlimit = NULL;
+	mutex_unlock(&hashlimit_mutex);
+
 	proc_net_remove(net, "ipt_hashlimit");
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	proc_net_remove(net, "ip6t_hashlimit");
@@ -872,9 +896,6 @@ static int __net_init hashlimit_net_init(struct net *net)
 
 static void __net_exit hashlimit_net_exit(struct net *net)
 {
-	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
-
-	BUG_ON(!hlist_empty(&hashlimit_net->htables));
 	hashlimit_proc_net_exit(net);
 }
 
-- 
1.7.10.4

