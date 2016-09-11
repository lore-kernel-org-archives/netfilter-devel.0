From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl 2/3] tests: queue: add missing NFTNL_EXPR_QUEUE_FLAGS compare test
Date: Sun, 11 Sep 2016 22:11:23 +0800
Message-ID: <1473603084-33964-3-git-send-email-zlpnobody@163.com>
References: <1473603084-33964-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:50490 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755728AbcIKOMV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Sep 2016 10:12:21 -0400
In-Reply-To: <1473603084-33964-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

We forgot to compare NFTNL_EXPR_QUEUE_FLAGS between two exprs,
now add it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 tests/nft-expr_queue-test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index 1cc39aa..81d7dd2 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -39,6 +39,9 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_QUEUE_TOTAL) !=
 	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_QUEUE_TOTAL))
 		print_err("Expr NFTNL_EXPR_QUEUE_TOTAL mismatches");
+	if (nftnl_expr_get_u16(rule_a, NFTNL_EXPR_QUEUE_FLAGS) !=
+	    nftnl_expr_get_u16(rule_b, NFTNL_EXPR_QUEUE_FLAGS))
+		print_err("Expr NFTNL_EXPR_QUEUE_FLAGS mismatches");
 }
 
 int main(int argc, char *argv[])
-- 
2.5.5


