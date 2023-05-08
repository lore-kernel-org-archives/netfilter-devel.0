Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1719C77B73
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 06:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjEHGHc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 May 2023 02:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjEHGHa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2023 02:07:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50D1413875
        for <netfilter-devel@vger.kernel.org>; Sun,  7 May 2023 23:07:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] evaluate: skip optimization if anonymous set uses stateful statement
Date:   Mon,  8 May 2023 08:07:19 +0200
Message-Id: <20230508060720.2296-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230508060720.2296-1-pablo@netfilter.org>
References: <20230508060720.2296-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

fee6bda06403 ("evaluate: remove anon sets with exactly one element")
introduces an optimization to remove use of sets with single element.
Skip this optimization if set element contains stateful statements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                                 | 2 +-
 tests/shell/testcases/optimizations/dumps/single_anon_set.nft  | 1 +
 .../testcases/optimizations/dumps/single_anon_set.nft.input    | 3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index bc8f437ee7ea..08243220f159 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1802,7 +1802,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			set->set_flags |= NFT_SET_CONCAT;
 	} else if (set->size == 1) {
 		i = list_first_entry(&set->expressions, struct expr, list);
-		if (i->etype == EXPR_SET_ELEM) {
+		if (i->etype == EXPR_SET_ELEM && list_empty(&i->stmt_list)) {
 			switch (i->key->etype) {
 			case EXPR_PREFIX:
 			case EXPR_RANGE:
diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
index 35e3f36e1a54..3f703034d80f 100644
--- a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
@@ -11,5 +11,6 @@ table ip test {
 		ip daddr . tcp dport { 192.168.0.1 . 22 } accept
 		meta mark set ip daddr map { 192.168.0.1 : 0x00000001 }
 		ct state { established, related } accept
+		meta mark { 0x0000000a counter packets 0 bytes 0 }
 	}
 }
diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
index 35b93832420f..ecc5691ba581 100644
--- a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
@@ -31,5 +31,8 @@ table ip test {
 		# ct state cannot be both established and related
 		# at the same time, but this needs extra work.
 		ct state { established, related } accept
+
+		# with stateful statement
+		meta mark { 0x0000000a counter }
 	}
 }
-- 
2.30.2

