Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3A5C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Sep 2022 13:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiI2NBk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Sep 2022 09:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbiI2NBb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Sep 2022 09:01:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375BA146FAB
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Sep 2022 06:01:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1odtAN-00031q-70; Thu, 29 Sep 2022 15:01:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>
Subject: [PATCH nft 2/3] evaluate: add ethernet header size offset for implicit vlan dependency
Date:   Thu, 29 Sep 2022 15:01:12 +0200
Message-Id: <20220929130113.22289-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220929130113.22289-1-fw@strlen.de>
References: <20220929130113.22289-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

'vlan id 1'

must also add a ethernet header dep, else nft fetches the payload from
header offset 0 instead of 14.

Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ca6e5883a1f9..a52867b33be0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -723,7 +723,25 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 
 		rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 		desc = ctx->pctx.protocol[base].desc;
-		goto check_icmp;
+
+		if (desc == expr->payload.desc)
+			goto check_icmp;
+
+		if (base == PROTO_BASE_LL_HDR) {
+			int link;
+
+			link = proto_find_num(desc, payload->payload.desc);
+			if (link < 0 ||
+			    conflict_resolution_gen_dependency(ctx, link, payload, &nstmt) < 0)
+				return expr_error(ctx->msgs, payload,
+						  "conflicting protocols specified: %s vs. %s",
+						  desc->name,
+						  payload->payload.desc->name);
+
+			payload->payload.offset += ctx->pctx.stacked_ll[0]->length;
+			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
+			return 1;
+		}
 	}
 
 	if (payload->payload.base == desc->base &&
-- 
2.35.1

