Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E08C432BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 20:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25F4060F9C
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 20:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhG0Uu2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:50:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36294 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbhG0Uu2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 16:50:28 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id B321E642AD;
        Tue, 27 Jul 2021 22:49:57 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     tom.ty89@gmail.com
Subject: [PATCH nft 2/2] netlink_delinearize: skip flags / mask notation for singleton bitmask
Date:   Tue, 27 Jul 2021 22:50:14 +0200
Message-Id: <20210727205014.17281-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210727205014.17281-1-pablo@netfilter.org>
References: <20210727205014.17281-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of 'syn / syn', just print the most simple form 'syn'.

Fixes: c3d57114f119 ("parser_bison: add shortcut syntax for matching flags without binary operations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c   | 9 ++++++---
 tests/py/inet/tcp.t         | 1 +
 tests/py/inet/tcp.t.payload | 8 ++++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index c7dae26684cd..89c6a069c6b0 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2258,13 +2258,16 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 					 struct expr **exprp)
 {
 	struct expr *expr = *exprp, *binop = expr->left, *value = expr->right;
+	struct expr *list;
 
 	if (binop->op == OP_AND && (expr->op == OP_NEQ || expr->op == OP_EQ) &&
 	    value->dtype->basetype &&
 	    value->dtype->basetype->type == TYPE_BITMASK) {
+		list = binop_tree_to_list(NULL, binop->right);
+
 		switch (value->etype) {
 		case EXPR_VALUE:
-			if (!mpz_cmp_ui(value->value, 0)) {
+			if (!mpz_cmp_ui(value->value, 0) && list->size <= 1) {
 				/* Flag comparison: data & flags != 0
 				 *
 				 * Split the flags into a list of flag values and convert the
@@ -2273,7 +2276,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 				expr_free(value);
 
 				expr->left  = expr_get(binop->left);
-				expr->right = binop_tree_to_list(NULL, binop->right);
+				expr->right = list;
 				switch (expr->op) {
 				case OP_NEQ:
 					expr->op = OP_IMPLICIT;
@@ -2288,7 +2291,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 			} else {
 				*exprp = flagcmp_expr_alloc(&expr->location, expr->op,
 							    expr_get(binop->left),
-							    binop_tree_to_list(NULL, binop->right),
+							    list,
 							    expr_get(value));
 				expr_free(expr);
 			}
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 5e2830b679a8..576e72b54ab1 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -70,6 +70,7 @@ tcp flags == syn;ok
 tcp flags fin,syn / fin,syn;ok
 tcp flags != syn / fin,syn;ok
 tcp flags & syn != 0;ok;tcp flags syn
+tcp flags & syn == syn;ok;tcp flags syn
 tcp flags & (fin | syn | rst | ack) syn;ok;tcp flags syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | ack) != syn;ok;tcp flags != syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 6b8b4ecdb4ac..77b301883a15 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -378,6 +378,14 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
+# tcp flags & syn == syn
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
 # tcp flags & (fin | syn | rst | ack) syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-- 
2.20.1

