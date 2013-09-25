From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next 3/6] ipt_CLUSTERIP: make clusterip_lock per net namespace
Date: Wed, 25 Sep 2013 15:38:46 +0800
Message-ID: <1380094729-30674-4-git-send-email-gaofeng@cn.fujitsu.com>
References: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab3IYHhs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:37:48 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8P7bepq004287
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2013 15:37:42 +0800
In-Reply-To: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

this lock is used for protecting clusterip_configs of per
net namespace, it should be per net namespace too.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 8ef3e6f..1bf5aa30 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -58,9 +58,6 @@ struct clusterip_config {
 	struct rcu_head rcu;
 };
 
-/* clusterip_lock protects the clusterip_configs list */
-static DEFINE_SPINLOCK(clusterip_lock);
-
 #ifdef CONFIG_PROC_FS
 static const struct file_operations clusterip_proc_fops;
 #endif
@@ -69,6 +66,9 @@ static int clusterip_net_id __read_mostly;
 
 struct clusterip_net {
 	struct list_head configs;
+	/* lock protects the configs list */
+	spinlock_t lock;
+
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *procdir;
 #endif
@@ -99,10 +99,12 @@ clusterip_config_put(struct clusterip_config *c)
 static inline void
 clusterip_config_entry_put(struct clusterip_config *c)
 {
+	struct clusterip_net *cn = net_generic(&init_net, clusterip_net_id);
+
 	local_bh_disable();
-	if (atomic_dec_and_lock(&c->entries, &clusterip_lock)) {
+	if (atomic_dec_and_lock(&c->entries, &cn->lock)) {
 		list_del_rcu(&c->list);
-		spin_unlock(&clusterip_lock);
+		spin_unlock(&cn->lock);
 		local_bh_enable();
 
 		dev_mc_del(c->dev, c->clustermac);
@@ -198,9 +200,9 @@ clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 	}
 #endif
 
-	spin_lock_bh(&clusterip_lock);
+	spin_lock_bh(&cn->lock);
 	list_add_rcu(&c->list, &cn->configs);
-	spin_unlock_bh(&clusterip_lock);
+	spin_unlock_bh(&cn->lock);
 
 	return c;
 }
@@ -713,6 +715,8 @@ static int clusterip_net_init(struct net *net)
 
 	INIT_LIST_HEAD(&cn->configs);
 
+	spin_lock_init(&cn->lock);
+
 #ifdef CONFIG_PROC_FS
 	cn->procdir = proc_mkdir("ipt_CLUSTERIP", net->proc_net);
 	if (!cn->procdir) {
-- 
1.8.3.1

