From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nftables 5/7] payload: insert implicit meta tcp dependency when matching tcp options
Date: Tue,  7 Feb 2017 03:14:13 +0100
Message-ID: <20170207021415.22460-6-mm@skelett.io>
References: <20170207021415.22460-1-mm@skelett.io>
Cc: Florian Westphal <fw@strlen.de>, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:48019 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751654AbdBGCTx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:53 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id 30963B012D
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:14:34 -0500 (EST)
In-Reply-To: <20170207021415.22460-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

nft add rule inet filter input tcp option sack 4 left 1
<cmdline>:1:28-49: Error: Cannot generate dependency: no network layer protocol specified

Users can avoid this via 'meta l4proto tcp', this enables implicit
dependency injection for the inet/bridge/netdev families.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Manuel Messner <mm@skelett.io>
Signed-off-by: Manuel Messner <mm@skelett.io>
---
 src/payload.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index efd1960..0207296 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -323,12 +323,26 @@ int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 	const struct proto_desc *desc;
 
 	desc = ctx->pctx.protocol[pb].desc;
-	if (desc == NULL)
+	if (desc == NULL) {
+		if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
+			switch (ctx->pctx.family) {
+			case NFPROTO_NETDEV:
+			case NFPROTO_BRIDGE:
+			case NFPROTO_INET:
+				desc = &proto_inet_service;
+				goto found;
+			default:
+				break;
+			}
+		}
+
 		return expr_error(ctx->msgs, expr,
 				  "Cannot generate dependency: "
 				  "no %s protocol specified",
 				  proto_base_names[pb]);
+	}
 
+ found:
 	return payload_add_dependency(ctx, desc, dependency, expr, res);
 }
 
-- 
2.11.1

