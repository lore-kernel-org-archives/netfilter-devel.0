From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH resend] netfilter: remove modulo operations
Date: Fri, 12 Nov 2010 23:59:14 +0800
Message-ID: <1289577554-6329-1-git-send-email-xiaosuo@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59897 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab0KLP74 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:59:56 -0500
Received: by yxn35 with SMTP id 35so80840yxn.19
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Nov 2010 07:59:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
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
