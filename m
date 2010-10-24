From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: remove modulo operations
Date: Sun, 24 Oct 2010 11:40:35 +0800
Message-ID: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37447 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0JXDl1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 23:41:27 -0400
Received: by pvb32 with SMTP id 32so393178pvb.19
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Oct 2010 20:41:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 net/netfilter/xt_NFQUEUE.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 039cce1..3962770 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -72,10 +72,12 @@ nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
 
 	if (info->queues_total > 1) {
 		if (par->family == NFPROTO_IPV4)
-			queue = hash_v4(skb) % info->queues_total + queue;
+			queue = (((u64) hash_v4(skb) * info->queues_total) >>
+				 32) + queue;
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 		else if (par->family == NFPROTO_IPV6)
-			queue = hash_v6(skb) % info->queues_total + queue;
+			queue = (((u64) hash_v6(skb) * info->queues_total) >>
+				 32) + queue;
 #endif
 	}
 	return NF_QUEUE_NR(queue);
