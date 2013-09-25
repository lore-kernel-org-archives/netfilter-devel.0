From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next 6/6] ipt_CLUSTERIP: use proper net namespace to operate CLUSTERIP
Date: Wed, 25 Sep 2013 15:38:49 +0800
Message-ID: <1380094729-30674-7-git-send-email-gaofeng@cn.fujitsu.com>
References: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab3IYHht (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:37:49 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8P7bfDY004295
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2013 15:37:42 +0800
In-Reply-To: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

we can allow users in uninit net namespace to operate ipt_CLUSTERIP
now.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index c93dfd2..ecd808a 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -99,7 +99,8 @@ clusterip_config_put(struct clusterip_config *c)
 static inline void
 clusterip_config_entry_put(struct clusterip_config *c)
 {
-	struct clusterip_net *cn = net_generic(&init_net, clusterip_net_id);
+	struct net *net = dev_net(c->dev);
+	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
 
 	local_bh_disable();
 	if (atomic_dec_and_lock(&c->entries, &cn->lock)) {
@@ -381,7 +382,7 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 
 	/* FIXME: further sanity checks */
 
-	config = clusterip_config_find_get(&init_net, e->ip.dst.s_addr, 1);
+	config = clusterip_config_find_get(par->net, e->ip.dst.s_addr, 1);
 	if (!config) {
 		if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
 			pr_info("no config found for %pI4, need 'new'\n",
@@ -395,7 +396,7 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 				return -EINVAL;
 			}
 
-			dev = dev_get_by_name(&init_net, e->ip.iniface);
+			dev = dev_get_by_name(par->net, e->ip.iniface);
 			if (!dev) {
 				pr_info("no such interface %s\n",
 					e->ip.iniface);
@@ -503,6 +504,7 @@ arp_mangle(unsigned int hook,
 	struct arphdr *arp = arp_hdr(skb);
 	struct arp_payload *payload;
 	struct clusterip_config *c;
+	struct net *net = dev_net(in ? in : out);
 
 	/* we don't care about non-ethernet and non-ipv4 ARP */
 	if (arp->ar_hrd != htons(ARPHRD_ETHER) ||
@@ -519,7 +521,7 @@ arp_mangle(unsigned int hook,
 
 	/* if there is no clusterip configuration for the arp reply's
 	 * source ip, we don't want to mangle it */
-	c = clusterip_config_find_get(&init_net, payload->src_ip, 0);
+	c = clusterip_config_find_get(net, payload->src_ip, 0);
 	if (!c)
 		return NF_ACCEPT;
 
-- 
1.8.3.1

