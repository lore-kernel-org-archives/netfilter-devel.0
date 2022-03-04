Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6165CC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 10:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbiCDKZQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 05:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiCDKZP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 05:25:15 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA53A6B0BC
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 02:24:26 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7138A601C6
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 11:22:47 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] optimize: do not assume log prefix
Date:   Fri,  4 Mar 2022 11:24:21 +0100
Message-Id: <20220304102421.942240-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

... log prefix might not be present in log statements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c                                    | 15 ++++++++++++---
 .../testcases/optimizations/dumps/merge_vmaps.nft |  1 +
 tests/shell/testcases/optimizations/merge_vmaps   |  1 +
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index f8dd7f8d159f..7a268c452226 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -153,8 +153,16 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 		    stmt_a->log.qthreshold != stmt_b->log.qthreshold ||
 		    stmt_a->log.level != stmt_b->log.level ||
 		    stmt_a->log.logflags != stmt_b->log.logflags ||
-		    stmt_a->log.flags != stmt_b->log.flags ||
-		    stmt_a->log.prefix->etype != EXPR_VALUE ||
+		    stmt_a->log.flags != stmt_b->log.flags)
+			return false;
+
+		if (!!stmt_a->log.prefix ^ !!stmt_b->log.prefix)
+			return false;
+
+		if (!stmt_a->log.prefix)
+			return true;
+
+		if (stmt_a->log.prefix->etype != EXPR_VALUE ||
 		    stmt_b->log.prefix->etype != EXPR_VALUE ||
 		    mpz_cmp(stmt_a->log.prefix->value, stmt_b->log.prefix->value))
 			return false;
@@ -265,7 +273,8 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 			break;
 		case STMT_LOG:
 			memcpy(&clone->log, &stmt->log, sizeof(clone->log));
-			clone->log.prefix = expr_get(stmt->log.prefix);
+			if (stmt->log.prefix)
+				clone->log.prefix = expr_get(stmt->log.prefix);
 			break;
 		default:
 			break;
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft b/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
index c1c9743b9f8c..05b9e575c272 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmaps.nft
@@ -8,5 +8,6 @@ table ip x {
 	chain y {
 		tcp dport vmap { 80 : accept, 81 : accept, 443 : accept, 8000-8100 : accept, 24000-25000 : accept }
 		meta l4proto vmap { tcp : goto filter_in_tcp, udp : goto filter_in_udp }
+		log
 	}
 }
diff --git a/tests/shell/testcases/optimizations/merge_vmaps b/tests/shell/testcases/optimizations/merge_vmaps
index 7b7a2723be4b..0922a221bd6d 100755
--- a/tests/shell/testcases/optimizations/merge_vmaps
+++ b/tests/shell/testcases/optimizations/merge_vmaps
@@ -19,6 +19,7 @@ RULESET="table ip x {
 		}
 		meta l4proto tcp goto filter_in_tcp
 		meta l4proto udp goto filter_in_udp
+		log
 	}
 }"
 
-- 
2.30.2

