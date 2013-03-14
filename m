From: pablo@netfilter.org
Subject: [PATCH 2/2] netfilter: nfnetlink_queue: fix incorrect initialization of copy range field
Date: Thu, 14 Mar 2013 17:03:18 +0100
Message-ID: <1363276999-30144-2-git-send-email-pablo@netfilter.org>
References: <1363276999-30144-1-git-send-email-pablo@netfilter.org>
Cc: eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48510 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933603Ab3CNQDc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:03:32 -0400
In-Reply-To: <1363276999-30144-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

2^16 = 0xffff, not 0xfffff (note the extra 'f').

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 4512658..e81dad6 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -113,7 +113,7 @@ instance_create(u_int16_t queue_num, int portid)
 	inst->queue_num = queue_num;
 	inst->peer_portid = portid;
 	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
-	inst->copy_range = 0xfffff;
+	inst->copy_range = 0xffff;
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
-- 
1.7.10.4

