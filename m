Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47410C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Dec 2022 09:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiLLJWq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Dec 2022 04:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiLLJVy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2022 04:21:54 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BB4BB62
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Dec 2022 01:20:45 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: fix compilation warning
Date:   Mon, 12 Dec 2022 10:20:42 +0100
Message-Id: <20221212092042.4955-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set pointer to list of expression to NULL and check that it is set on
before using it.

In function ‘expr_evaluate_concat’,
    inlined from ‘expr_evaluate’ at evaluate.c:2488:10:
evaluate.c:1338:20: warning: ‘expressions’ may be used uninitialized [-Wmaybe-uninitialized]
 1338 |                 if (runaway) {
      |                    ^
evaluate.c: In function ‘expr_evaluate’:
evaluate.c:1321:33: note: ‘expressions’ was declared here
 1321 |         const struct list_head *expressions;
      |                                 ^~~~~~~~~~~

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: 508f3a270531 ("netlink: swap byteorder of value component in concatenation of intervals")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 3a524aab0e12..d0279e335a4e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1318,7 +1318,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	uint32_t type = dtype ? dtype->type : 0, ntype = 0;
 	int off = dtype ? dtype->subtypes : 0;
 	unsigned int flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
-	const struct list_head *expressions;
+	const struct list_head *expressions = NULL;
 	struct expr *i, *next, *key = NULL;
 	const struct expr *key_ctx = NULL;
 	bool runaway = false;
@@ -1395,7 +1395,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		dsize_bytes = div_round_up(dsize, BITS_PER_BYTE);
 		(*expr)->field_len[(*expr)->field_count++] = dsize_bytes;
 		size += netlink_padded_len(dsize);
-		if (key) {
+		if (key && expressions) {
 			if (list_is_last(&key->list, expressions))
 				runaway = true;
 
-- 
2.30.2

