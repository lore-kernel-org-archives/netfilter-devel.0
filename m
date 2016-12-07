From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/50] ipvs: Use IS_ERR_OR_NULL(svc) instead of IS_ERR(svc) || svc == NULL
Date: Wed,  7 Dec 2016 22:52:07 +0100
Message-ID: <1481147576-5690-2-git-send-email-pablo@netfilter.org>
References: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933093AbcLGVxK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2016 16:53:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 213CFD1630
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 22:53:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DC7DDA863
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 22:53:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7FD3DA729
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 22:53:03 +0100 (CET)
In-Reply-To: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

This minor refactoring does not change the logic of function
ip_vs_genl_dump_dests.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 6b85ded4f91d..217e0105b5e0 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3260,7 +3260,7 @@ static int ip_vs_genl_dump_dests(struct sk_buff *skb,
 
 
 	svc = ip_vs_genl_find_service(ipvs, attrs[IPVS_CMD_ATTR_SERVICE]);
-	if (IS_ERR(svc) || svc == NULL)
+	if (IS_ERR_OR_NULL(svc))
 		goto out_err;
 
 	/* Dump the destinations */
-- 
2.1.4

