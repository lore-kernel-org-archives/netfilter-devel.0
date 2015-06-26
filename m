From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nf] netfilter: nft_queue: restrict queueing to supported families
Date: Fri, 26 Jun 2015 10:01:39 +0200
Message-ID: <1435305700-8768-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44473 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbbFZH4V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 03:56:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We only support IPv4 and IPv6 at this moment.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_queue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 96805d2..45b9f7f 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -129,4 +129,5 @@ module_exit(nft_queue_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Eric Leblond <eric@regit.org>");
-MODULE_ALIAS_NFT_EXPR("queue");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "queue");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "queue");
-- 
1.7.10.4

