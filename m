Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A446C47247
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D211206FA
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgEESk2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 14:40:28 -0400
Received: from correo.us.es ([193.147.175.20]:39212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728885AbgEESk1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 14:40:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C27BA1C4388
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 20:40:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B45494EA8F
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 20:40:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9EC7DA7B2; Tue,  5 May 2020 20:40:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A70D2115412;
        Tue,  5 May 2020 20:40:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 20:40:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 88D2342EE38E;
        Tue,  5 May 2020 20:40:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     michael-dev@fami-braun.de
Subject: [PATCH nft 2/2] src: add rule_stmt_append() and use it
Date:   Tue,  5 May 2020 20:40:18 +0200
Message-Id: <20200505184018.12626-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200505184018.12626-1-pablo@netfilter.org>
References: <20200505184018.12626-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This helper function adds a statement at the end of the rule statement
list and it updates the rule statement counter.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h            | 1 +
 src/netlink_delinearize.c | 7 +++----
 src/parser_json.c         | 6 ++----
 src/rule.c                | 6 ++++++
 src/xt.c                  | 4 ++--
 5 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 5311b5630165..1a4ec3d8bc37 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -280,6 +280,7 @@ extern void rule_print(const struct rule *rule, struct output_ctx *octx);
 extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
 extern struct rule *rule_lookup_by_index(const struct chain *chain,
 					 uint64_t index);
+void rule_stmt_append(struct rule *rule, struct stmt *stmt);
 void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
 			 struct stmt *stmt);
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f721d15c330f..7f7ad2626e14 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -563,8 +563,7 @@ static void netlink_parse_payload_stmt(struct netlink_parse_ctx *ctx,
 	payload_init_raw(expr, base, offset, len);
 
 	stmt = payload_stmt_alloc(loc, expr, val);
-
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	rule_stmt_append(ctx->rule, stmt);
 }
 
 static void netlink_parse_payload(struct netlink_parse_ctx *ctx,
@@ -615,7 +614,7 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 		expr_set_type(val, expr->dtype, expr->byteorder);
 
 		stmt = exthdr_stmt_alloc(loc, expr, val);
-		list_add_tail(&stmt->list, &ctx->rule->stmts);
+		rule_stmt_append(ctx->rule, stmt);
 	}
 }
 
@@ -1672,7 +1671,7 @@ static int netlink_parse_rule_expr(struct nftnl_expr *nle, void *arg)
 	if (err < 0)
 		return err;
 	if (ctx->stmt != NULL) {
-		list_add_tail(&ctx->stmt->list, &ctx->rule->stmts);
+		rule_stmt_append(ctx->rule, ctx->stmt);
 		ctx->stmt = NULL;
 	}
 	return 0;
diff --git a/src/parser_json.c b/src/parser_json.c
index a1765027fdf3..4468407b0ecd 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2731,8 +2731,7 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 			return NULL;
 		}
 
-		rule->num_stmts++;
-		list_add_tail(&stmt->list, &rule->stmts);
+		rule_stmt_append(rule, stmt);
 	}
 
 	if (op == CMD_ADD)
@@ -3404,8 +3403,7 @@ static struct cmd *json_parse_cmd_replace(struct json_ctx *ctx,
 			return NULL;
 		}
 
-		rule->num_stmts++;
-		list_add_tail(&stmt->list, &rule->stmts);
+		rule_stmt_append(rule, stmt);
 	}
 
 	if (op == CMD_REPLACE)
diff --git a/src/rule.c b/src/rule.c
index 0759bec5f1a0..c58aa359259e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -686,6 +686,12 @@ struct rule *rule_lookup_by_index(const struct chain *chain, uint64_t index)
 	return NULL;
 }
 
+void rule_stmt_append(struct rule *rule, struct stmt *stmt)
+{
+	list_add_tail(&stmt->list, &rule->stmts);
+	rule->num_stmts++;
+}
+
 void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
 			 struct stmt *stmt)
 {
diff --git a/src/xt.c b/src/xt.c
index b0f5a30c46b5..f39acf30275a 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -238,7 +238,7 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_MATCH;
 #endif
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	rule_stmt_append(ctx->rule, stmt);
 }
 
 void netlink_parse_target(struct netlink_parse_ctx *ctx,
@@ -283,7 +283,7 @@ void netlink_parse_target(struct netlink_parse_ctx *ctx,
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_TARGET;
 #endif
-	list_add_tail(&stmt->list, &ctx->rule->stmts);
+	rule_stmt_append(ctx->rule, stmt);
 }
 
 #ifdef HAVE_LIBXTABLES
-- 
2.20.1

