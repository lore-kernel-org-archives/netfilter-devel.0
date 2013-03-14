From: pablo@netfilter.org
Subject: [PATCH 1/2] netfilter: nfnetlink_queue: use xor hash function to distribute instances
Date: Thu, 14 Mar 2013 17:03:17 +0100
Message-ID: <1363276999-30144-1-git-send-email-pablo@netfilter.org>
Cc: eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48509 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab3CNQDb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:03:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks to Eric Dumazet for suggesting this during the NFWS.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 3158d87..4512658 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -73,7 +73,7 @@ static struct hlist_head instance_table[INSTANCE_BUCKETS] __read_mostly;
 
 static inline u_int8_t instance_hashfn(u_int16_t queue_num)
 {
-	return ((queue_num >> 8) | queue_num) % INSTANCE_BUCKETS;
+	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
 }
 
 static struct nfqnl_instance *
-- 
1.7.10.4

