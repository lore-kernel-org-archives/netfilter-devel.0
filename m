Return-Path: <SRS0=FJFf=5X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898E9C2BA1A
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 18:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4485B20768
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Apr 2020 18:01:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FENWRjAE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgDGSBt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Apr 2020 14:01:49 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34565 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgDGSBs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 14:01:48 -0400
Received: by mail-ot1-f65.google.com with SMTP id m2so4108897otr.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2020 11:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=krSFrM2rn6yIeERZnwPDBQz2Vv1eUV4I06gqO7th6cY=;
        b=FENWRjAE5f4MDgWheoUDW7r4+od23mztohtenyuYBa0DQUFlDiajoEEBm15hAj/VKU
         wnivisKDWdzY/neN8I0BRfl7LI6vwgUJRLevxuSe69APrAwr5id5BOcxciJYa3DJmtkJ
         tiFhAiIjIUkkjb3kVzJm+ycwG0U2tRdFC9IlGanvwSjq493dy9xy5QJhyGFDWpSITm8T
         OJF6A1/kkjBaNz05Ks/NNuozM/K52/Dh9iHmq/ypHR3Erul0wnwddURVjDE7NkVhZix8
         eZzs+yP7XOz2N8t3FETShYGozQy0WAwkpkz71t9INizJn64cDWD4aCbPWNiz2hQe/u9L
         aeHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=krSFrM2rn6yIeERZnwPDBQz2Vv1eUV4I06gqO7th6cY=;
        b=UrR7eRoKmtuj9j7NWxr1Un7zwt/IYH5RduUgQ7+zWHyC3CDtX/n7C1ljYbQpJD2515
         U7XkXI1jNPSd+ZYPcnwJIWHv9Qz4MUMaYiv6Z4gpSEYdmt00Dyh/TMayilnAN0fIMhsQ
         AXSr+4fRd9mrqQmqp1zyQrvuPay98FAigi7aftcNH8Xoy0gEAr6ynErIIaWKe7R5SXaB
         UeLIbmWgmtEQxrlAwKSQ5XoFCVc8bR8zgWEpEgxYU0C2BUhrETbkG3NX6cauRnqQMv1S
         vcLWUzuZgrmxMCAuoKG2lmPPVibRs6S2w5QjYaU1JhYqAx/DcMUy6KZBdAM8nwDErBZI
         RkWQ==
X-Gm-Message-State: AGi0PubiiBEetTtcHj8UZokTI8aAvTCHk0QxMwtprC+GZwjYI4k31F4k
        aOfTfP+m51RPL7N8Se7td6UT+P9o
X-Google-Smtp-Source: APiQypKw2n2Xflq4Iit6NAhesE2YI9BKOMlzG8HUUi9SPO6uBeJAthQMqLgLOkUTwlJll6+x7OJdXA==
X-Received: by 2002:a05:6830:3151:: with SMTP id c17mr2767449ots.310.1586282491846;
        Tue, 07 Apr 2020 11:01:31 -0700 (PDT)
Received: from localhost.localdomain (CableLink-187-161-107-10.PCs.InterCable.net. [187.161.107.10])
        by smtp.gmail.com with ESMTPSA id p25sm4382747oth.49.2020.04.07.11.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 11:01:31 -0700 (PDT)
From:   Alberto Leiva Popper <ydahhrk@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Alberto Leiva Popper <ydahhrk@gmail.com>
Subject: [nft PATCH 2/2] expr: add jool expressions
Date:   Tue,  7 Apr 2020 13:01:24 -0500
Message-Id: <20200407180124.19169-1-ydahhrk@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jool statements are used to send packets to the Jool kernel module,
which is an IP/ICMP translator: www.jool.mx

Sample usage:

        modprobe jool
        jool instance add "name" --iptables -6 64:ff9b::/96
        sudo nft add rule inet table1 chain1 jool nat64 "name"

This feature was requested in Jool's bug tracker:
https://github.com/NICMx/Jool/issues/285

Signed-off-by: Alberto Leiva Popper <ydahhrk@gmail.com>
---
 include/statement.h       | 15 +++++++++++++++
 src/evaluate.c            |  1 +
 src/netlink_delinearize.c | 15 +++++++++++++++
 src/netlink_linearize.c   | 15 +++++++++++++++
 src/parser_bison.y        | 31 +++++++++++++++++++++++++++++++
 src/scanner.l             |  2 ++
 src/statement.c           | 33 +++++++++++++++++++++++++++++++++
 7 files changed, 112 insertions(+)

diff --git a/include/statement.h b/include/statement.h
index 8fb459ca..8f4cb0fd 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -253,6 +253,18 @@ struct xt_stmt {
 
 extern struct stmt *xt_stmt_alloc(const struct location *loc);
 
+enum nft_jool_type {
+	NFT_JOOL_SIIT = (1 << 0),
+	NFT_JOOL_NAT64 = (1 << 1),
+};
+
+struct jool_stmt {
+	enum nft_jool_type	type;
+	const char		*instance;
+};
+
+extern struct stmt *jool_stmt_alloc(const struct location *loc);
+
 /**
  * enum stmt_types - statement types
  *
@@ -281,6 +293,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
  * @STMT_CONNLIMIT:	connection limit statement
  * @STMT_MAP:		map statement
  * @STMT_SYNPROXY:	synproxy statement
+ * @STMT_JOOL:		Jool statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -309,6 +322,7 @@ enum stmt_types {
 	STMT_CONNLIMIT,
 	STMT_MAP,
 	STMT_SYNPROXY,
+	STMT_JOOL,
 };
 
 /**
@@ -374,6 +388,7 @@ struct stmt {
 		struct flow_stmt	flow;
 		struct map_stmt		map;
 		struct synproxy_stmt	synproxy;
+		struct jool_stmt	jool;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index fcc79386..592a3cc8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3353,6 +3353,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	case STMT_QUOTA:
 	case STMT_NOTRACK:
 	case STMT_FLOW_OFFLOAD:
+	case STMT_JOOL:
 		return 0;
 	case STMT_EXPRESSION:
 		return stmt_evaluate_expr(ctx, stmt);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 79efda12..58a802f8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1106,6 +1106,20 @@ out_err:
 	xfree(stmt);
 }
 
+static void netlink_parse_jool(struct netlink_parse_ctx *ctx,
+			       const struct location *loc,
+			       const struct nftnl_expr *nle)
+{
+	struct stmt *stmt;
+
+	stmt = jool_stmt_alloc(loc);
+	stmt->jool.type = nftnl_expr_get_u8(nle, NFTNL_EXPR_JOOL_TYPE);
+	stmt->jool.instance = xstrdup(nftnl_expr_get_str(nle,
+						     NFTNL_EXPR_JOOL_INSTANCE));
+
+	ctx->stmt = stmt;
+}
+
 static void netlink_parse_synproxy(struct netlink_parse_ctx *ctx,
 				   const struct location *loc,
 				   const struct nftnl_expr *nle)
@@ -1594,6 +1608,7 @@ static const struct {
 	{ .name = "flow_offload", .parse = netlink_parse_flow_offload },
 	{ .name = "xfrm",	.parse = netlink_parse_xfrm },
 	{ .name = "synproxy",	.parse = netlink_parse_synproxy },
+	{ .name = "jool",	.parse = netlink_parse_jool },
 };
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e70e63b3..c0597f39 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1434,6 +1434,19 @@ static void netlink_gen_meter_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_jool_stmt(struct netlink_linearize_ctx *ctx,
+				  const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("jool");
+
+	nftnl_expr_set_u8(nle, NFTNL_EXPR_JOOL_TYPE, stmt->jool.type);
+	nftnl_expr_set_str(nle, NFTNL_EXPR_JOOL_INSTANCE, stmt->jool.instance);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -1487,6 +1500,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_objref_stmt(ctx, stmt);
 	case STMT_MAP:
 		return netlink_gen_map_stmt(ctx, stmt);
+	case STMT_JOOL:
+		return netlink_gen_jool_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3e8d6bd6..0999172c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -523,6 +523,8 @@ int nft_lex(void *, void *, void *);
 %token FULLY_RANDOM		"fully-random"
 %token PERSISTENT		"persistent"
 
+%token JOOL			"jool"
+
 %token QUEUE			"queue"
 %token QUEUENUM			"num"
 %token BYPASS			"bypass"
@@ -642,6 +644,8 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	tproxy_stmt
 %type <stmt>			synproxy_stmt synproxy_stmt_alloc
 %destructor { stmt_free($$); }	synproxy_stmt synproxy_stmt_alloc
+%type <stmt>			jool_stmt jool_stmt_alloc
+%destructor { stmt_free($$); }	jool_stmt jool_stmt_alloc
 
 
 %type <stmt>			queue_stmt queue_stmt_alloc
@@ -2492,6 +2496,7 @@ stmt			:	verdict_stmt
 			|	set_stmt
 			|	map_stmt
 			|	synproxy_stmt
+			|	jool_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -3014,6 +3019,32 @@ synproxy_sack		:	/* empty */	{ $$ = 0; }
 			}
 			;
 
+jool_stmt		:	jool_stmt_alloc	jool_opts
+			;
+
+jool_stmt_alloc		:	JOOL
+			{
+				$$ = jool_stmt_alloc(&@$);
+			}
+			;
+
+jool_opts		:	string	string
+			{
+				if (!strcmp("siit", $1))
+					$<stmt>0->jool.type = NFT_JOOL_SIIT;
+				else if (!strcmp("nat64", $1))
+					$<stmt>0->jool.type = NFT_JOOL_NAT64;
+				else {
+					erec_queue(error(&@1, "invalid jool type (expected siit or nat64)"),
+						   state->msgs);
+					xfree($1);
+					YYERROR;
+				}
+				xfree($1);
+				$<stmt>0->jool.instance = $2;
+			}
+			;
+
 primary_stmt_expr	:	symbol_expr			{ $$ = $1; }
 			|	integer_expr			{ $$ = $1; }
 			|	boolean_expr			{ $$ = $1; }
diff --git a/src/scanner.l b/src/scanner.l
index 45699c85..9e8d637c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -375,6 +375,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "fully-random"		{ return FULLY_RANDOM; }
 "persistent"		{ return PERSISTENT; }
 
+"jool"			{ return JOOL; }
+
 "ll"			{ return LL_HDR; }
 "nh"			{ return NETWORK_HDR; }
 "th"			{ return TRANSPORT_HDR; }
diff --git a/src/statement.c b/src/statement.c
index 182edac8..4ec27658 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -942,3 +942,36 @@ struct stmt *synproxy_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &synproxy_stmt_ops);
 }
+
+static void jool_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
+{
+	const char *type = "<unknown>";
+
+	switch (stmt->jool.type) {
+	case NFT_JOOL_SIIT:
+		type = "siit";
+		break;
+	case NFT_JOOL_NAT64:
+		type = "nat64";
+		break;
+	}
+
+	nft_print(octx, "jool \"%s\" \"%s\"", type, stmt->jool.instance);
+}
+
+static void jool_stmt_destroy(struct stmt *stmt)
+{
+	xfree(stmt->jool.instance);
+}
+
+static const struct stmt_ops jool_stmt_ops = {
+	.type		= STMT_JOOL,
+	.name		= "jool",
+	.print		= jool_stmt_print,
+	.destroy	= jool_stmt_destroy,
+};
+
+struct stmt *jool_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &jool_stmt_ops);
+}
-- 
2.17.1

