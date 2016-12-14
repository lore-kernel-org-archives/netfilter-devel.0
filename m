From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink_linearize: fix IPv6 layer 4 checksum mangling
Date: Wed, 14 Dec 2016 01:19:26 +0100
Message-ID: <1481674767-24986-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34112 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbcLNATz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Dec 2016 19:19:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAA86C2B00
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 01:19:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B86EDA851
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 01:19:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 584C6DA853
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2016 01:19:47 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In IPv6 there is no checksum field, so we have to trigger layer 4
checksum mangling when layer 3 pseudoheader fields are updated
inconditionally.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Kernel patch is following up soon for nf.

 src/netlink_linearize.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 4a0001a4ce17..0915038fecae 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -806,12 +806,11 @@ static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 				   NFT_PAYLOAD_CSUM_INET);
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_CSUM_OFFSET,
 				   csum_off / BITS_PER_BYTE);
-
-		if (expr->payload.base == PROTO_BASE_NETWORK_HDR &&
-		    payload_needs_l4csum_update_pseudohdr(expr, desc))
-			nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_FLAGS,
-					   NFT_PAYLOAD_L4CSUM_PSEUDOHDR);
 	}
+	if (expr->payload.base == PROTO_BASE_NETWORK_HDR &&
+	    payload_needs_l4csum_update_pseudohdr(expr, desc))
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_FLAGS,
+				   NFT_PAYLOAD_L4CSUM_PSEUDOHDR);
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
-- 
2.1.4

