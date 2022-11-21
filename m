Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA111C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 11:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiKULYw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiKULYQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 06:24:16 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B34BEAC5
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:19:48 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ox4q3-0002Pk-0b; Mon, 21 Nov 2022 12:19:47 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables-nft RFC 1/5] nft-shared: dump errors on stdout to garble output
Date:   Mon, 21 Nov 2022 12:19:28 +0100
Message-Id: <20221121111932.18222-2-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221121111932.18222-1-fw@strlen.de>
References: <20221121111932.18222-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Intentionally garble iptables-nft output if we cannot dissect
an expression that we've just encountered, rather than dump an
error message on stderr.

The idea here is that
iptables-save | iptables-restore

will fail, rather than restore an incomplete ruleset.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-shared.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 97512e3f43ff..d1f891740c02 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -1169,6 +1169,8 @@ static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
 {
 	if (ctx->h->ops->parse_lookup)
 		ctx->h->ops->parse_lookup(ctx, e);
+	else
+		ctx->errmsg = "cannot handle lookup";
 }
 
 static void nft_parse_range(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -1245,9 +1247,11 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 			nft_parse_log(&ctx, expr);
 		else if (strcmp(name, "range") == 0)
 			nft_parse_range(&ctx, expr);
+		else
+			printf("unknown expression %s", name);
 
 		if (ctx.errmsg) {
-			fprintf(stderr, "%s", ctx.errmsg);
+			printf("[%s]", ctx.errmsg);
 			ctx.errmsg = NULL;
 		}
 
-- 
2.37.4

