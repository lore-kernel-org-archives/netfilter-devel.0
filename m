From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] netfilter: nfnetlink_queue: remove pointless conditional
 before kfree_skb()
Date: Tue, 28 Aug 2012 21:14:15 +0800
Message-ID: <CAPgLHd_dNe3ZLzkAZC7p6V7oQLohmFQxfPjVtK-SBhXG1yYxWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org
To: pablo@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51663 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2H1NOQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:14:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove pointless conditional before kfree_skb().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/netfilter/nfnetlink_queue_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index c0496a5..5c2d78d 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -406,8 +406,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 	return skb;
 
 nla_put_failure:
-	if (skb)
-		kfree_skb(skb);
+	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 	return NULL;
 }


