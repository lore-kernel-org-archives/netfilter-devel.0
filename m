From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next 4/6] ipt_CLUSTERIP: add parameter net in clusterip_config_find_get
Date: Wed, 25 Sep 2013 15:38:47 +0800
Message-ID: <1380094729-30674-5-git-send-email-gaofeng@cn.fujitsu.com>
References: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65305 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab3IYHht (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:37:49 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8P7bfDX004295
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2013 15:37:42 +0800
In-Reply-To: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Inorder to find clusterip_config in net namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1bf5aa30..b7fc9d5 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -122,10 +122,10 @@ clusterip_config_entry_put(struct clusterip_config *c)
 }
 
 static struct clusterip_config *
-__clusterip_config_find(__be32 clusterip)
+__clusterip_config_find(struct net *net, __be32 clusterip)
 {
 	struct clusterip_config *c;
-	struct clusterip_net *cn = net_generic(&init_net, clusterip_net_id);
+	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
 
 	list_for_each_entry_rcu(c, &cn->configs, list) {
 		if (c->clusterip == clusterip)
@@ -136,12 +136,12 @@ __clusterip_config_find(__be32 clusterip)
 }
 
 static inline struct clusterip_config *
-clusterip_config_find_get(__be32 clusterip, int entry)
+clusterip_config_find_get(struct net *net, __be32 clusterip, int entry)
 {
 	struct clusterip_config *c;
 
 	rcu_read_lock_bh();
-	c = __clusterip_config_find(clusterip);
+	c = __clusterip_config_find(net, clusterip);
 	if (c) {
 		if (unlikely(!atomic_inc_not_zero(&c->refcount)))
 			c = NULL;
@@ -381,7 +381,7 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 
 	/* FIXME: further sanity checks */
 
-	config = clusterip_config_find_get(e->ip.dst.s_addr, 1);
+	config = clusterip_config_find_get(&init_net, e->ip.dst.s_addr, 1);
 	if (!config) {
 		if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
 			pr_info("no config found for %pI4, need 'new'\n",
@@ -519,7 +519,7 @@ arp_mangle(unsigned int hook,
 
 	/* if there is no clusterip configuration for the arp reply's
 	 * source ip, we don't want to mangle it */
-	c = clusterip_config_find_get(payload->src_ip, 0);
+	c = clusterip_config_find_get(&init_net, payload->src_ip, 0);
 	if (!c)
 		return NF_ACCEPT;
 
-- 
1.8.3.1

