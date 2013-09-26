From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 2/2] xt_TCPMSS: lookup route in proper net namesapce
Date: Thu, 26 Sep 2013 15:00:31 +0800
Message-ID: <1380178831-20360-2-git-send-email-gaofeng@cn.fujitsu.com>
References: <1380178831-20360-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26068 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab3IZG7Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:59:25 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8Q6xLrm027656
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2013 14:59:21 +0800
In-Reply-To: <1380178831-20360-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise the pmtu will be incorrect.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/xt_TCPMSS.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 62776de..e762de5 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -43,7 +43,8 @@ optlen(const u_int8_t *opt, unsigned int offset)
 		return opt[offset+1];
 }
 
-static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
+static u_int32_t tcpmss_reverse_mtu(struct net *net,
+				    const struct sk_buff *skb,
 				    unsigned int family)
 {
 	struct flowi fl;
@@ -64,7 +65,7 @@ static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
 	rcu_read_lock();
 	ai = nf_get_afinfo(family);
 	if (ai != NULL)
-		ai->route(&init_net, (struct dst_entry **)&rt, &fl, false);
+		ai->route(net, (struct dst_entry **)&rt, &fl, false);
 	rcu_read_unlock();
 
 	if (rt != NULL) {
@@ -107,7 +108,8 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 		return -1;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
-		unsigned int in_mtu = tcpmss_reverse_mtu(skb, family);
+		struct net *net = dev_net(par->in ? par->in : par->out);
+		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
 
 		if (dst_mtu(skb_dst(skb)) <= minlen) {
 			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
-- 
1.8.3.1

