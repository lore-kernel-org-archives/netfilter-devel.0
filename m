From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next 2/6] ipt_CLUSTERIP: make clusterip_list per net namespace
Date: Wed, 25 Sep 2013 15:38:45 +0800
Message-ID: <1380094729-30674-3-git-send-email-gaofeng@cn.fujitsu.com>
References: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65305 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab3IYHhs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:37:48 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8P7bepp004287
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2013 15:37:41 +0800
In-Reply-To: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

clusterip_configs should be per net namespace, so operate
cluster in one net namespace won't affect other net
namespace. right now, only allow to operate the clusterip_configs
of init net namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index e66b91b..8ef3e6f 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -58,8 +58,6 @@ struct clusterip_config {
 	struct rcu_head rcu;
 };
 
-static LIST_HEAD(clusterip_configs);
-
 /* clusterip_lock protects the clusterip_configs list */
 static DEFINE_SPINLOCK(clusterip_lock);
 
@@ -70,6 +68,7 @@ static const struct file_operations clusterip_proc_fops;
 static int clusterip_net_id __read_mostly;
 
 struct clusterip_net {
+	struct list_head configs;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *procdir;
 #endif
@@ -124,8 +123,9 @@ static struct clusterip_config *
 __clusterip_config_find(__be32 clusterip)
 {
 	struct clusterip_config *c;
+	struct clusterip_net *cn = net_generic(&init_net, clusterip_net_id);
 
-	list_for_each_entry_rcu(c, &clusterip_configs, list) {
+	list_for_each_entry_rcu(c, &cn->configs, list) {
 		if (c->clusterip == clusterip)
 			return c;
 	}
@@ -199,7 +199,7 @@ clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 #endif
 
 	spin_lock_bh(&clusterip_lock);
-	list_add_rcu(&c->list, &clusterip_configs);
+	list_add_rcu(&c->list, &cn->configs);
 	spin_unlock_bh(&clusterip_lock);
 
 	return c;
@@ -709,9 +709,11 @@ static const struct file_operations clusterip_proc_fops = {
 
 static int clusterip_net_init(struct net *net)
 {
-#ifdef CONFIG_PROC_FS
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
 
+	INIT_LIST_HEAD(&cn->configs);
+
+#ifdef CONFIG_PROC_FS
 	cn->procdir = proc_mkdir("ipt_CLUSTERIP", net->proc_net);
 	if (!cn->procdir) {
 		pr_err("Unable to proc dir entry\n");
-- 
1.8.3.1

