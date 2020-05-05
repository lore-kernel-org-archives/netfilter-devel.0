Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994E0C47254
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 853C4206FA
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgEESk0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 14:40:26 -0400
Received: from correo.us.es ([193.147.175.20]:39202 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgEESkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 14:40:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7FF291C4387
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 20:40:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70EBE115416
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 20:40:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 668B4115410; Tue,  5 May 2020 20:40:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45A632067D;
        Tue,  5 May 2020 20:40:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 20:40:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2622942EE38E;
        Tue,  5 May 2020 20:40:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     michael-dev@fami-braun.de
Subject: [PATCH nft 1/2] src: add rule_stmt_insert_at() and use it
Date:   Tue,  5 May 2020 20:40:17 +0200
Message-Id: <20200505184018.12626-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This helper function adds a statement at a given position and it updates
the rule statement counter.

This patch fixes this:

flush table bridge test-bridge
add rule bridge test-bridge input vlan id 1 ip saddr 10.0.0.1
rule.c:2870:5: runtime error: index 2 out of bounds for type 'stmt *[*]'
=================================================================
==1043==ERROR: AddressSanitizer: dynamic-stack-buffer-overflow on address 0x7ffdd69c1350 at pc 0x7f1036f53330 bp 0x7ffdd69c1300 sp 0x7ffdd69c12f8
WRITE of size 8 at 0x7ffdd69c1350 thread T0
    #0 0x7f1036f5332f in payload_try_merge /home/mbr/nftables/src/rule.c:2870
    #1 0x7f1036f534b7 in rule_postprocess /home/mbr/nftables/src/rule.c:2885
    #2 0x7f1036fb2785 in rule_evaluate /home/mbr/nftables/src/evaluate.c:3744
    #3 0x7f1036fb627b in cmd_evaluate_add /home/mbr/nftables/src/evaluate.c:3982
    #4 0x7f1036fbb9e9 in cmd_evaluate /home/mbr/nftables/src/evaluate.c:4462
    #5 0x7f10370652d2 in nft_evaluate /home/mbr/nftables/src/libnftables.c:414
    #6 0x7f1037065ba1 in nft_run_cmd_from_buffer /home/mbr/nftables/src/libnftables.c:447

Reported-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h | 3 +++
 src/evaluate.c | 9 +++++----
 src/rule.c     | 7 +++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index ac69b30673e8..5311b5630165 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -280,6 +280,9 @@ extern void rule_print(const struct rule *rule, struct output_ctx *octx);
 extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
 extern struct rule *rule_lookup_by_index(const struct chain *chain,
 					 uint64_t index);
+void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
+			 struct stmt *stmt);
+
 
 /**
  * struct set - nftables set
diff --git a/src/evaluate.c b/src/evaluate.c
index 597141317000..4cf28987049b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -659,7 +659,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 		if (err < 0)
 			return err;
 
-		list_add_tail(&nstmt->list, &ctx->stmt->list);
+		rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 	}
 
 	assert(base <= PROTO_BASE_MAX);
@@ -673,7 +673,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 		return 1;
 
 	payload->payload.offset += ctx->pctx.protocol[base].offset;
-	list_add_tail(&nstmt->list, &ctx->stmt->list);
+	rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 
 	return 0;
 }
@@ -698,7 +698,8 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 	if (desc == NULL) {
 		if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 			return -1;
-		list_add_tail(&nstmt->list, &ctx->stmt->list);
+
+		rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 	} else {
 		/* No conflict: Same payload protocol as context, adjust offset
 		 * if needed.
@@ -840,8 +841,8 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
 	relational_expr_pctx_update(&ctx->pctx, dep);
 
 	nstmt = expr_stmt_alloc(&dep->location, dep);
+	rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 
-	list_add_tail(&nstmt->list, &ctx->stmt->list);
 	return 0;
 }
 
diff --git a/src/rule.c b/src/rule.c
index 23b1cbfc8fb2..0759bec5f1a0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -686,6 +686,13 @@ struct rule *rule_lookup_by_index(const struct chain *chain, uint64_t index)
 	return NULL;
 }
 
+void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
+			 struct stmt *stmt)
+{
+	list_add_tail(&nstmt->list, &stmt->list);
+	rule->num_stmts++;
+}
+
 struct scope *scope_alloc(void)
 {
 	struct scope *scope = xzalloc(sizeof(struct scope));
-- 
2.20.1

