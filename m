Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58F2C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 16:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 720E9613C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 16:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244107AbhDFQeg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 12:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhDFQef (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 12:34:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA89C06174A;
        Tue,  6 Apr 2021 09:34:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lToen-0001WT-5j; Tue, 06 Apr 2021 18:34:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     netfilter@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Henning Reich <henning.reich@gmail.com>
Subject: [PATCH nft] evaluate: check if nat statement map specifies a transport header expr
Date:   Tue,  6 Apr 2021 18:34:19 +0200
Message-Id: <20210406163419.13267-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210406153338.GO13699@breakpoint.cc>
References: <20210406153338.GO13699@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Importing the systemd nat table fails:

table ip io.systemd.nat {
 map map_port_ipport {
   type inet_proto . inet_service : ipv4_addr . inet_service
   elements = { tcp . 8088 : 192.168.162.117 . 80 }
 }
 chain prerouting {
   type nat hook prerouting priority dstnat + 1; policy accept;
    fib daddr type local dnat ip addr . port to meta l4proto . th dport map @map_port_ipport
 }
}
ruleset:9:48-59: Error: transport protocol mapping is only valid after transport protocol match

To resolve this (no transport header base specified), check if the
map itself contains a network base protocol expression.

This allows nft to import the ruleset.
Import still fails with same error if 'inet_service' is removed
from the map, as it should.

Reported-by: Henning Reich <henning.reich@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 85cf9e05b641..a6bb1792c58a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2971,12 +2971,48 @@ static int evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 				 expr);
 }
 
+static bool nat_evaluate_addr_has_th_expr(const struct expr *map)
+{
+	const struct expr *i, *concat;
+
+	if (!map || map->etype != EXPR_MAP)
+		return false;
+
+	concat = map->map;
+	if (concat ->etype != EXPR_CONCAT)
+		return false;
+
+	list_for_each_entry(i, &concat->expressions, list) {
+		enum proto_bases base;
+
+		if ((i->flags & EXPR_F_PROTOCOL) == 0)
+			continue;
+
+		switch (i->etype) {
+		case EXPR_META:
+			base = i->meta.base;
+			break;
+		case EXPR_PAYLOAD:
+			base = i->payload.base;
+			break;
+		default:
+			return false;
+		}
+
+		if (base == PROTO_BASE_NETWORK_HDR)
+			return true;
+	}
+
+	return false;
+}
+
 static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 				  struct expr **expr)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
 
-	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
+	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL &&
+	    !nat_evaluate_addr_has_th_expr(stmt->nat.addr))
 		return stmt_binary_error(ctx, *expr, stmt,
 					 "transport protocol mapping is only "
 					 "valid after transport protocol match");
-- 
2.26.3

