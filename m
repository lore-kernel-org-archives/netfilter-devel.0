Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24784C433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFBBB205F4
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Z4MnClim"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbfHBJOU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 05:14:20 -0400
Received: from mx1.riseup.net ([198.252.153.129]:52766 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfHBJOU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 05:14:20 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id B94701A301B
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Aug 2019 02:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1564737259; bh=moxBJhnePqbT78ScfQvmLf/sCAqRCd6f1Yy6EEsG5rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4MnClim2KIxNKvMkCNhKSd9tuGslgQZsrXZN7iLpVztUkgNS8Vv7B9dOhrvJ8Snc
         jucyDOmBGBpVgz9he8CxqIzlNGPGaV0lf03yx1hI44wXsW9gRaBExC4fH+AHy1mvlK
         uD/57/Qonsqx3y/5zzmfMGk6OKKc2QziWMGeUgi8=
X-Riseup-User-ID: F33EBFBB48176727696660B96C3817B43835A851E3B5FD3759371F45649A46AC
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 7D67B22324F;
        Fri,  2 Aug 2019 02:14:18 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 2/2 nft v3] src: allow variable in chain policy
Date:   Fri,  2 Aug 2019 11:13:37 +0200
Message-Id: <20190802091335.10778-3-ffmancera@riseup.net>
In-Reply-To: <20190802091335.10778-1-ffmancera@riseup.net>
References: <20190802091335.10778-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces the use of nft input files variables in chain policy.
e.g.

define default_policy = "accept"

add table ip foo
add chain ip foo bar {type filter hook input priority filter; policy $default_policy}

table ip foo {
	chain bar {
		type filter hook input priority filter; policy accept;
	}
}

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/datatype.h                            |  1 +
 include/rule.h                                |  2 +-
 src/datatype.c                                | 29 +++++++++++++++++++
 src/evaluate.c                                | 22 ++++++++++++++
 src/json.c                                    |  5 +++-
 src/mnl.c                                     |  9 ++++--
 src/netlink.c                                 |  8 ++++-
 src/parser_bison.y                            | 23 ++++++++++++---
 src/parser_json.c                             | 17 +++++++----
 src/rule.c                                    | 13 +++++++--
 .../testcases/nft-f/0025policy_variable_0     | 17 +++++++++++
 .../testcases/nft-f/0026policy_variable_0     | 17 +++++++++++
 .../testcases/nft-f/0027policy_variable_1     | 18 ++++++++++++
 .../testcases/nft-f/0028policy_variable_1     | 18 ++++++++++++
 .../nft-f/dumps/0025policy_variable_0.nft     |  5 ++++
 .../nft-f/dumps/0026policy_variable_0.nft     |  5 ++++
 16 files changed, 191 insertions(+), 18 deletions(-)
 create mode 100755 tests/shell/testcases/nft-f/0025policy_variable_0
 create mode 100755 tests/shell/testcases/nft-f/0026policy_variable_0
 create mode 100755 tests/shell/testcases/nft-f/0027policy_variable_1
 create mode 100755 tests/shell/testcases/nft-f/0028policy_variable_1
 create mode 100644 tests/shell/testcases/nft-f/dumps/0025policy_variable_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft

diff --git a/include/datatype.h b/include/datatype.h
index 1b012d5..b8941af 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -257,6 +257,7 @@ extern const struct datatype igmp_type_type;
 extern const struct datatype time_type;
 extern const struct datatype boolean_type;
 extern const struct datatype priority_type;
+extern const struct datatype policy_type;
 
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx);
 
diff --git a/include/rule.h b/include/rule.h
index a071531..5099fa9 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -206,7 +206,7 @@ struct chain {
 	const char		*hookstr;
 	unsigned int		hooknum;
 	struct prio_spec	priority;
-	int			policy;
+	struct expr		*policy;
 	const char		*type;
 	const char		*dev;
 	struct scope		scope;
diff --git a/src/datatype.c b/src/datatype.c
index b7418e7..11a1b11 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1272,3 +1272,32 @@ const struct datatype priority_type = {
 	.desc		= "priority type",
 	.parse		= priority_type_parse,
 };
+
+static struct error_record *policy_type_parse(const struct expr *sym,
+					      struct expr **res)
+{
+	int policy;
+	if (!strcmp(sym->identifier, "accept"))
+		policy = NF_ACCEPT;
+	else if (!strcmp(sym->identifier, "drop"))
+		policy = NF_DROP;
+	else
+		return error(&sym->location, "wrong policy");
+
+	*res = constant_expr_alloc(&sym->location, &integer_type,
+				   BYTEORDER_HOST_ENDIAN, sizeof(int) *
+				   BITS_PER_BYTE, &policy);
+
+	return NULL;
+}
+
+/* This datatype is not registered via datatype_register()
+ * since this datatype should not ever be used from either
+ * rules or elements.
+ */
+const struct datatype policy_type = {
+	.type		= TYPE_STRING,
+	.name		= "policy",
+	.desc		= "policy type",
+	.parse		= policy_type_parse,
+};
diff --git a/src/evaluate.c b/src/evaluate.c
index 0ea8090..5fe1a32 100755
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3476,6 +3476,23 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 	return NF_INET_NUMHOOKS;
 }
 
+static bool evaluate_policy(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr;
+	ctx->ectx.dtype = &policy_type;
+	ctx->ectx.len = NFT_NAME_MAXLEN * BITS_PER_BYTE;
+	if (expr_evaluate(ctx, exprp) < 0)
+		return false;
+	expr = *exprp;
+	if (expr->etype != EXPR_VALUE) {
+		expr_error(ctx->msgs, expr, "%s is not a valid "
+			   "policy expression", expr_name(expr));
+		return false;
+	}
+
+	return true;
+}
+
 static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 {
 	struct table *table;
@@ -3509,6 +3526,11 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
 						   "invalid priority expression %s in this context.",
 						   expr_name(chain->priority.expr));
+		if (chain->policy) {
+			if (!evaluate_policy(ctx, &chain->policy))
+				return chain_error(ctx, chain, "invalid policy expression %s",
+						   expr_name(chain->policy));
+		}
 	}
 
 	list_for_each_entry(rule, &chain->rules, list) {
diff --git a/src/json.c b/src/json.c
index 05f089e..0871ea4 100644
--- a/src/json.c
+++ b/src/json.c
@@ -224,6 +224,7 @@ static json_t *chain_print_json(const struct chain *chain)
 {
 	json_t *root, *tmp;
 	int priority;
+	int policy;
 
 	root = json_pack("{s:s, s:s, s:s, s:I}",
 			 "family", family2str(chain->handle.family),
@@ -234,12 +235,14 @@ static json_t *chain_print_json(const struct chain *chain)
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		mpz_export_data(&priority, chain->priority.expr->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
+		mpz_export_data(&policy, chain->policy->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
 		tmp = json_pack("{s:s, s:s, s:i, s:s}",
 				"type", chain->type,
 				"hook", hooknum2str(chain->handle.family,
 						    chain->hooknum),
 				"prio", priority,
-				"policy", chain_policy2str(chain->policy));
+				"policy", chain_policy2str(policy));
 		if (chain->dev)
 			json_object_set_new(tmp, "dev", json_string(chain->dev));
 		json_object_update(root, tmp);
diff --git a/src/mnl.c b/src/mnl.c
index 8921ccf..f24d2ce 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -519,6 +519,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	struct nftnl_chain *nlc;
 	struct nlmsghdr *nlh;
 	int priority;
+	int policy;
 
 	nlc = nftnl_chain_alloc();
 	if (nlc == NULL)
@@ -539,9 +540,11 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_TYPE,
 					    cmd->chain->type);
 		}
-		if (cmd->chain->policy != -1)
-			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_POLICY,
-					    cmd->chain->policy);
+		if (cmd->chain->policy) {
+			mpz_export_data(&policy, cmd->chain->policy->value,
+					BYTEORDER_HOST_ENDIAN, sizeof(int));
+			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_POLICY, policy);
+		}
 		if (cmd->chain->dev != NULL)
 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_DEV,
 					    cmd->chain->dev);
diff --git a/src/netlink.c b/src/netlink.c
index a0e4d63..8350e43 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -370,6 +370,7 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 {
 	struct chain *chain;
 	int priority;
+	int policy;
 
 	chain = chain_alloc(nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
 	chain->handle.family =
@@ -396,7 +397,12 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 						    BITS_PER_BYTE, &priority);
 		chain->type          =
 			xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE));
-		chain->policy          =
+		policy = nftnl_chain_get_u32(nlc, NFTNL_CHAIN_POLICY);
+		chain->policy = constant_expr_alloc(&netlink_location,
+						    &string_type,
+						    BYTEORDER_HOST_ENDIAN,
+						    sizeof(int) * BITS_PER_BYTE,
+						    &policy);
 			nftnl_chain_get_u32(nlc, NFTNL_CHAIN_POLICY);
 		if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_DEV)) {
 			chain->dev	=
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3f763f0..252d511 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -636,8 +636,8 @@ int nft_lex(void *, void *, void *);
 %type <stmt>			meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 %destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 
-%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr
-%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr
+%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
+%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
 %type <expr>			primary_expr shift_expr and_expr
 %destructor { expr_free($$); }	primary_expr shift_expr and_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
@@ -2028,17 +2028,32 @@ dev_spec		:	DEVICE	string		{ $$ = $2; }
 			|	/* empty */		{ $$ = NULL; }
 			;
 
-policy_spec		:	POLICY		chain_policy
+policy_spec		:	POLICY		policy_expr
 			{
-				if ($<chain>0->policy != -1) {
+				if ($<chain>0->policy) {
 					erec_queue(error(&@$, "you cannot set chain policy twice"),
 						   state->msgs);
+					expr_free($2);
 					YYERROR;
 				}
 				$<chain>0->policy	= $2;
 			}
 			;
 
+policy_expr		:	variable_expr
+			{
+				datatype_set($1->sym->expr, &policy_type);
+				$$ = $1;
+			}
+			|	chain_policy
+			{
+				$$ = constant_expr_alloc(&@$, &integer_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(int) *
+							 BITS_PER_BYTE, &$1);
+			}
+			;
+
 chain_policy		:	ACCEPT		{ $$ = NF_ACCEPT; }
 			|	DROP		{ $$ = NF_DROP;   }
 			;
diff --git a/src/parser_json.c b/src/parser_json.c
index 0e2fd6b..c9a8440 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2530,13 +2530,20 @@ static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 	return cmd_alloc(op, obj, &h, int_loc, NULL);
 }
 
-static int parse_policy(const char *policy)
+static struct expr *parse_policy(const char *policy)
 {
+	int policy_num;
+
 	if (!strcmp(policy, "accept"))
-		return NF_ACCEPT;
-	if (!strcmp(policy, "drop"))
-		return NF_DROP;
-	return -1;
+		policy_num = NF_ACCEPT;
+	else if (!strcmp(policy, "drop"))
+		policy_num = NF_DROP;
+	else
+		return NULL;
+
+	return constant_expr_alloc(int_loc, &integer_type,
+				   BYTEORDER_HOST_ENDIAN, sizeof(int)
+				   * BITS_PER_BYTE, &policy_num);
 }
 
 static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
diff --git a/src/rule.c b/src/rule.c
index 2aca8af..27eca2e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -798,7 +798,7 @@ struct chain *chain_alloc(const char *name)
 	if (name != NULL)
 		chain->handle.chain.name = xstrdup(name);
 
-	chain->policy = -1;
+	chain->policy = NULL;
 	return chain;
 }
 
@@ -822,6 +822,7 @@ void chain_free(struct chain *chain)
 	if (chain->dev != NULL)
 		xfree(chain->dev);
 	expr_free(chain->priority.expr);
+	expr_free(chain->policy);
 	xfree(chain);
 }
 
@@ -1098,12 +1099,15 @@ static void chain_print_declaration(const struct chain *chain,
 				    struct output_ctx *octx)
 {
 	char priobuf[STD_PRIO_BUFSIZE];
+	int policy;
 
 	nft_print(octx, "\tchain %s {", chain->handle.chain.name);
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, chain->handle.handle.id);
 	nft_print(octx, "\n");
 	if (chain->flags & CHAIN_F_BASECHAIN) {
+		mpz_export_data(&policy, chain->policy->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
 		nft_print(octx, "\t\ttype %s hook %s", chain->type,
 			  hooknum2str(chain->handle.family, chain->hooknum));
 		if (chain->dev != NULL)
@@ -1112,7 +1116,7 @@ static void chain_print_declaration(const struct chain *chain,
 			  prio2str(octx, priobuf, sizeof(priobuf),
 				   chain->handle.family, chain->hooknum,
 				   chain->priority.expr),
-			  chain_policy2str(chain->policy));
+			  chain_policy2str(policy));
 	}
 }
 
@@ -1133,17 +1137,20 @@ static void chain_print(const struct chain *chain, struct output_ctx *octx)
 void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
 {
 	char priobuf[STD_PRIO_BUFSIZE];
+	int policy;
 
 	nft_print(octx, "chain %s %s %s", family2str(chain->handle.family),
 		  chain->handle.table.name, chain->handle.chain.name);
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
+		mpz_export_data(&policy, chain->policy->value,
+				BYTEORDER_HOST_ENDIAN, 4);
 		nft_print(octx, " { type %s hook %s priority %s; policy %s; }",
 			  chain->type, chain->hookstr,
 			  prio2str(octx, priobuf, sizeof(priobuf),
 				   chain->handle.family, chain->hooknum,
 				   chain->priority.expr),
-			  chain_policy2str(chain->policy));
+			  chain_policy2str(policy));
 	}
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, chain->handle.handle.id);
diff --git a/tests/shell/testcases/nft-f/0025policy_variable_0 b/tests/shell/testcases/nft-f/0025policy_variable_0
new file mode 100755
index 0000000..b88e968
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0025policy_variable_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+# Tests use of variables in chain policy
+
+set -e
+
+RULESET="
+define default_policy = \"accept\"
+
+table inet global {
+    chain prerouting {
+        type filter hook prerouting priority filter
+        policy \$default_policy
+    }
+}"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/nft-f/0026policy_variable_0 b/tests/shell/testcases/nft-f/0026policy_variable_0
new file mode 100755
index 0000000..d4d98ed
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0026policy_variable_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+# Tests use of variables in chain policy
+
+set -e
+
+RULESET="
+define default_policy = \"drop\"
+
+table inet global {
+    chain prerouting {
+        type filter hook prerouting priority filter
+        policy \$default_policy
+    }
+}"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/nft-f/0027policy_variable_1 b/tests/shell/testcases/nft-f/0027policy_variable_1
new file mode 100755
index 0000000..ae35516
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0027policy_variable_1
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+# Tests use of variables in chain policy
+
+set -e
+
+RULESET="
+define default_policy = { 127.0.0.1 }
+
+table inet global {
+    chain prerouting {
+        type filter hook prerouting priority filter
+        policy \$default_policy
+    }
+}"
+
+$NFT -f - <<< "$RULESET" && exit 1
+exit 0
diff --git a/tests/shell/testcases/nft-f/0028policy_variable_1 b/tests/shell/testcases/nft-f/0028policy_variable_1
new file mode 100755
index 0000000..027eb01
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0028policy_variable_1
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+# Tests use of variables in priority specification
+
+set -e
+
+RULESET="
+define default_policy = *
+
+table inet global {
+    chain prerouting {
+        type filter hook prerouting priority filter
+        policy \$default_policy
+    }
+}"
+
+$NFT -f - <<< "$RULESET" && exit 1
+exit 0
diff --git a/tests/shell/testcases/nft-f/dumps/0025policy_variable_0.nft b/tests/shell/testcases/nft-f/dumps/0025policy_variable_0.nft
new file mode 100644
index 0000000..f409309
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0025policy_variable_0.nft
@@ -0,0 +1,5 @@
+table inet global {
+	chain prerouting {
+		type filter hook prerouting priority filter; policy accept;
+	}
+}
diff --git a/tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft b/tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft
new file mode 100644
index 0000000..d729e1e
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft
@@ -0,0 +1,5 @@
+table inet global {
+	chain prerouting {
+		type filter hook prerouting priority filter; policy drop;
+	}
+}
-- 
2.20.1

