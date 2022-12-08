Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89747C4708E
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 01:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiLHBcW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 20:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLHBcV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 20:32:21 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D41A78DFDF
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 17:32:20 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: do not crash on runaway number of concatenation components
Date:   Thu,  8 Dec 2022 02:32:16 +0100
Message-Id: <20221208013217.483019-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Display error message in case user specifies more data components than
those defined by the concatenation of selectors.

 # cat example.nft
 table ip x {
        chain y {
                type filter hook prerouting priority 0; policy drop;
                ip saddr . meta mark { 1.2.3.4 . 0x00000100 . 1.2.3.6-1.2.3.8 } accept
        }
 }
 # nft -f example.nft
 example.nft:4:3-22: Error: too many concatenation components
                ip saddr . meta mark { 1.2.3.4 . 0x00000100 . 1.2.3.6-1.2.3.8 } accept
                ^^^^^^^^^^^^^^^^^^^^   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Without this patch, nft crashes:

==464771==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x60d000000418 at pc 0x7fbc17513aa5 bp 0x7ffc73d33c90 sp 0x7ffc73d33c88
READ of size 8 at 0x60d000000418 thread T0
    #0 0x7fbc17513aa4 in expr_evaluate_concat /home/pablo/devel/scm/git-netfilter/nftables/src/evaluate.c:1348
    #1 0x7fbc1752a9da in expr_evaluate /home/pablo/devel/scm/git-netfilter/nftables/src/evaluate.c:2476
    #2 0x7fbc175175e2 in expr_evaluate_set_elem /home/pablo/devel/scm/git-netfilter/nftables/src/evaluate.c:1504
    #3 0x7fbc1752aa22 in expr_evaluate /home/pablo/devel/scm/git-netfilter/nftables/src/evaluate.c:2482
    #4 0x7fbc17512cb5 in list_member_evaluate /home/pablo/devel/scm/git-netfilter/nftables/src/evaluate.c:1310
    #5 0x7fbc17518ca0 in expr_evaluate_set /home/pablo/devel/scm/git-netfilter/nftables/src/evaluate.c:1590
    [...]

Fixes: 64bb3f43bb96 ("src: allow to use typeof of raw expressions in set declaration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 991de1d7e977..0a77031341fd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1318,20 +1318,28 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	uint32_t type = dtype ? dtype->type : 0, ntype = 0;
 	int off = dtype ? dtype->subtypes : 0;
 	unsigned int flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
+	const struct list_head *expressions;
 	struct expr *i, *next, *key = NULL;
 	const struct expr *key_ctx = NULL;
+	bool runaway = false;
 	uint32_t size = 0;
 
 	if (ctx->ectx.key && ctx->ectx.key->etype == EXPR_CONCAT) {
 		key_ctx = ctx->ectx.key;
 		assert(!list_empty(&ctx->ectx.key->expressions));
 		key = list_first_entry(&ctx->ectx.key->expressions, struct expr, list);
+		expressions = &ctx->ectx.key->expressions;
 	}
 
 	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
 		enum byteorder bo = BYTEORDER_INVALID;
 		unsigned dsize_bytes, dsize = 0;
 
+		if (runaway) {
+			return expr_binary_error(ctx->msgs, key_ctx, *expr,
+						 "too many concatenation components");
+		}
+
 		if (i->etype == EXPR_CT &&
 		    (i->ct.key == NFT_CT_SRC ||
 		     i->ct.key == NFT_CT_DST))
@@ -1387,8 +1395,12 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		dsize_bytes = div_round_up(dsize, BITS_PER_BYTE);
 		(*expr)->field_len[(*expr)->field_count++] = dsize_bytes;
 		size += netlink_padded_len(dsize);
-		if (key)
+		if (key) {
+			if (list_is_last(&key->list, expressions))
+				runaway = true;
+
 			key = list_next_entry(key, list);
+		}
 	}
 
 	(*expr)->flags |= flags;
-- 
2.30.2

