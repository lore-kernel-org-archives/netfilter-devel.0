Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DBFC433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 10:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8BFD206A3
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 10:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="rxdfaaAl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389168AbfHBKMr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 06:12:47 -0400
Received: from mx1.riseup.net ([198.252.153.129]:41852 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388922AbfHBKMr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 06:12:47 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 2A3DC1A0AC1
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Aug 2019 03:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1564740766; bh=MLbti7n3Uw6+l3dI02m6tIB1GM/9fHehZROsAOAg8mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxdfaaAlklfCXRddmfnCZDoqJ8QtKIkpt0krhtqIOgQjJgydhMogfrrjfou1X9qdO
         P018Wn6vyozuk2anEj0yYDU4k833WIaZPrvocIhLnvMA1TxgJjEK72DWSzcNomUF37
         uhJrgTGXsJ9buqQnwkLRrBx/dj35u3KiMTwtI+ac=
X-Riseup-User-ID: CAB14648712C4E2B62EAD8513FBAAC0CB2145D7EF2405F4E8580F047A5DB1271
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4CF3C223297;
        Fri,  2 Aug 2019 03:12:44 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 nft v4] src: allow variables in the chain priority specification
Date:   Fri,  2 Aug 2019 12:12:08 +0200
Message-Id: <20190802101207.27719-2-ffmancera@riseup.net>
In-Reply-To: <20190802101207.27719-1-ffmancera@riseup.net>
References: <20190802101207.27719-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces the use of nft input files variables in chain priority
specification. e.g.

define pri = filter
define prinum = 10
define priplusnum = "filter - 150"

add table ip foo
add chain ip foo bar {type filter hook input priority $pri;}
add chain ip foo ber {type filter hook input priority $prinum;}
add chain ip foo bor {type filter hook input priority $priplusnum;}

table ip foo {
	chain bar {
		type filter hook input priority filter; policy accept;
	}

	chain ber {
		type filter hook input priority filter + 10; policy accept;
	}

	chain bor {
		type filter hook input priority mangle; policy accept;
	}
}

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/datatype.h                            |  1 +
 include/rule.h                                |  7 +--
 src/datatype.c                                | 36 +++++++++++
 src/evaluate.c                                | 63 ++++++++++++++-----
 src/json.c                                    | 11 +++-
 src/mnl.c                                     | 13 ++--
 src/netlink.c                                 | 22 +++++--
 src/parser_bison.y                            | 35 +++++++++--
 src/parser_json.c                             | 11 +++-
 src/rule.c                                    | 15 ++---
 .../testcases/nft-f/0021priority_variable_0   | 17 +++++
 .../testcases/nft-f/0022priority_variable_0   | 17 +++++
 .../testcases/nft-f/0023priority_variable_1   | 18 ++++++
 .../testcases/nft-f/0024priority_variable_1   | 18 ++++++
 .../nft-f/dumps/0021priority_variable_0.nft   |  5 ++
 .../nft-f/dumps/0022priority_variable_0.nft   |  5 ++
 16 files changed, 248 insertions(+), 46 deletions(-)
 mode change 100644 => 100755 src/evaluate.c
 create mode 100755 tests/shell/testcases/nft-f/0021priority_variable_0
 create mode 100755 tests/shell/testcases/nft-f/0022priority_variable_0
 create mode 100755 tests/shell/testcases/nft-f/0023priority_variable_1
 create mode 100755 tests/shell/testcases/nft-f/0024priority_variable_1
 create mode 100644 tests/shell/testcases/nft-f/dumps/0021priority_variable_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0022priority_variable_0.nft

diff --git a/include/datatype.h b/include/datatype.h
index 63617eb..1b012d5 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -256,6 +256,7 @@ extern const struct datatype icmpx_code_type;
 extern const struct datatype igmp_type_type;
 extern const struct datatype time_type;
 extern const struct datatype boolean_type;
+extern const struct datatype priority_type;
 
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx);
 
diff --git a/include/rule.h b/include/rule.h
index ee881b9..a071531 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -174,13 +174,10 @@ enum chain_flags {
  * struct prio_spec - extendend priority specification for mixed
  *                    textual/numerical parsing.
  *
- * @str:  name of the standard priority value
- * @num:  Numerical value. This MUST contain the parsed value of str after
- *        evaluation.
+ * @expr:  expr of the standard priority value
  */
 struct prio_spec {
-	const char  *str;
-	int          num;
+	struct expr	*expr;
 	struct location loc;
 };
 
diff --git a/src/datatype.c b/src/datatype.c
index 6d6826e..5dac70e 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1246,3 +1246,39 @@ const struct datatype boolean_type = {
 	.sym_tbl	= &boolean_tbl,
 	.json		= boolean_type_json,
 };
+
+static struct error_record *priority_type_parse(const struct expr *sym,
+						struct expr **res)
+{
+	struct error_record *erec;
+	int num;
+
+	erec = integer_type_parse(sym, res);
+	if (!erec) {
+		num = atoi(sym->identifier);
+		expr_free(*res);
+		*res = constant_expr_alloc(&sym->location, &integer_type,
+					   BYTEORDER_HOST_ENDIAN,
+					   sizeof(int) *
+					   BITS_PER_BYTE, &num);
+	} else {
+		erec_destroy(erec);
+		*res = constant_expr_alloc(&sym->location, &string_type,
+					   BYTEORDER_HOST_ENDIAN,
+					   strlen(sym->identifier) *
+					   BITS_PER_BYTE, sym->identifier);
+	}
+
+	return NULL;
+}
+
+/* This datatype is not registered via datatype_register()
+ * since this datatype should not ever be used from either
+ * rules or elements.
+ */
+const struct datatype priority_type = {
+	.type		= TYPE_STRING,
+	.name		= "priority",
+	.desc		= "priority type",
+	.parse		= priority_type_parse,
+};
diff --git a/src/evaluate.c b/src/evaluate.c
old mode 100644
new mode 100755
index 48c65cd..0ea8090
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3241,19 +3241,54 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	return 0;
 }
 
-static bool evaluate_priority(struct prio_spec *prio, int family, int hook)
+static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
+			      int family, int hook)
 {
+	char prio_str[NFT_NAME_MAXLEN];
+	char prio_fst[NFT_NAME_MAXLEN];
+	struct location loc;
 	int priority;
+	int prio_snd;
+	char op;
 
-	/* A numeric value has been used to specify priority. */
-	if (prio->str == NULL)
+	ctx->ectx.dtype = &priority_type;
+	ctx->ectx.len = NFT_NAME_MAXLEN * BITS_PER_BYTE;
+	if (expr_evaluate(ctx, &prio->expr) < 0)
+		return false;
+	if (prio->expr->etype != EXPR_VALUE) {
+		expr_error(ctx->msgs, prio->expr, "%s is not a valid "
+			   "priority expression", expr_name(prio->expr));
+		return false;
+	}
+	if (prio->expr->dtype->type == TYPE_INTEGER)
 		return true;
 
-	priority = std_prio_lookup(prio->str, family, hook);
-	if (priority == NF_IP_PRI_LAST)
-		return false;
-	prio->num += priority;
+	mpz_export_data(prio_str, prio->expr->value,
+			BYTEORDER_HOST_ENDIAN,
+			NFT_NAME_MAXLEN);
+	loc = prio->expr->location;
+	expr_free(prio->expr);
 
+	if (sscanf(prio_str, "%s %c %d", prio_fst, &op, &prio_snd) < 3) {
+		priority = std_prio_lookup(prio_str, family, hook);
+		if (priority == NF_IP_PRI_LAST)
+			return false;
+	} else {
+		priority = std_prio_lookup(prio_fst, family, hook);
+		if (priority == NF_IP_PRI_LAST)
+			return false;
+		if (op == '+')
+			priority += prio_snd;
+		else if (op == '-')
+			priority -= prio_snd;
+		else
+			return false;
+	}
+	prio->expr = constant_expr_alloc(&loc, &integer_type,
+					 BYTEORDER_HOST_ENDIAN,
+					 sizeof(int) *
+					 BITS_PER_BYTE,
+					 &priority);
 	return true;
 }
 
@@ -3271,10 +3306,10 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 	if (ft->hooknum == NF_INET_NUMHOOKS)
 		return chain_error(ctx, ft, "invalid hook %s", ft->hookstr);
 
-	if (!evaluate_priority(&ft->priority, NFPROTO_NETDEV, ft->hooknum))
+	if (!evaluate_priority(ctx, &ft->priority, NFPROTO_NETDEV, ft->hooknum))
 		return __stmt_binary_error(ctx, &ft->priority.loc, NULL,
-					   "'%s' is invalid priority.",
-					   ft->priority.str);
+					   "invalid priority expression %s.",
+					   expr_name(ft->priority.expr));
 
 	if (!ft->dev_expr)
 		return chain_error(ctx, ft, "Unbound flowtable not allowed (must specify devices)");
@@ -3469,11 +3504,11 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 			return chain_error(ctx, chain, "invalid hook %s",
 					   chain->hookstr);
 
-		if (!evaluate_priority(&chain->priority, chain->handle.family,
-				       chain->hooknum))
+		if (!evaluate_priority(ctx, &chain->priority,
+				       chain->handle.family, chain->hooknum))
 			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
-						   "'%s' is invalid priority in this context.",
-						   chain->priority.str);
+						   "invalid priority expression %s in this context.",
+						   expr_name(chain->priority.expr));
 	}
 
 	list_for_each_entry(rule, &chain->rules, list) {
diff --git a/src/json.c b/src/json.c
index 33e0ec1..05f089e 100644
--- a/src/json.c
+++ b/src/json.c
@@ -223,6 +223,7 @@ static json_t *rule_print_json(struct output_ctx *octx,
 static json_t *chain_print_json(const struct chain *chain)
 {
 	json_t *root, *tmp;
+	int priority;
 
 	root = json_pack("{s:s, s:s, s:s, s:I}",
 			 "family", family2str(chain->handle.family),
@@ -231,11 +232,13 @@ static json_t *chain_print_json(const struct chain *chain)
 			 "handle", chain->handle.handle.id);
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
+		mpz_export_data(&priority, chain->priority.expr->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
 		tmp = json_pack("{s:s, s:s, s:i, s:s}",
 				"type", chain->type,
 				"hook", hooknum2str(chain->handle.family,
 						    chain->hooknum),
-				"prio", chain->priority.num,
+				"prio", priority,
 				"policy", chain_policy2str(chain->policy));
 		if (chain->dev)
 			json_object_set_new(tmp, "dev", json_string(chain->dev));
@@ -373,14 +376,16 @@ static json_t *obj_print_json(const struct obj *obj)
 static json_t *flowtable_print_json(const struct flowtable *ftable)
 {
 	json_t *root, *devs = NULL;
-	int i;
+	int i, priority;
 
+	mpz_export_data(&priority, ftable->priority.expr->value,
+			BYTEORDER_HOST_ENDIAN, sizeof(int));
 	root = json_pack("{s:s, s:s, s:s, s:s, s:i}",
 			"family", family2str(ftable->handle.family),
 			"name", ftable->handle.flowtable,
 			"table", ftable->handle.table.name,
 			"hook", hooknum2str(NFPROTO_NETDEV, ftable->hooknum),
-			"prio", ftable->priority.num);
+			"prio", priority);
 
 	for (i = 0; i < ftable->dev_array_len; i++) {
 		const char *dev = ftable->dev_array[i];
diff --git a/src/mnl.c b/src/mnl.c
index eab8d54..8921ccf 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -518,6 +518,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 {
 	struct nftnl_chain *nlc;
 	struct nlmsghdr *nlh;
+	int priority;
 
 	nlc = nftnl_chain_alloc();
 	if (nlc == NULL)
@@ -531,8 +532,10 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		if (cmd->chain->flags & CHAIN_F_BASECHAIN) {
 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_HOOKNUM,
 					    cmd->chain->hooknum);
-			nftnl_chain_set_s32(nlc, NFTNL_CHAIN_PRIO,
-					    cmd->chain->priority.num);
+			mpz_export_data(&priority,
+					cmd->chain->priority.expr->value,
+					BYTEORDER_HOST_ENDIAN, sizeof(int));
+			nftnl_chain_set_s32(nlc, NFTNL_CHAIN_PRIO, priority);
 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_TYPE,
 					    cmd->chain->type);
 		}
@@ -1371,6 +1374,7 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	const char *dev_array[8];
 	struct nlmsghdr *nlh;
 	struct expr *expr;
+	int priority;
 	int i = 0;
 
 	flo = nftnl_flowtable_alloc();
@@ -1385,8 +1389,9 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 				cmd->handle.flowtable);
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM,
 				cmd->flowtable->hooknum);
-	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO,
-				cmd->flowtable->priority.num);
+	mpz_export_data(&priority, cmd->flowtable->priority.expr->value,
+			BYTEORDER_HOST_ENDIAN, sizeof(int));
+	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, priority);
 
 	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list)
 		dev_array[i++] = expr->identifier;
diff --git a/src/netlink.c b/src/netlink.c
index 14b0df4..a0e4d63 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -369,6 +369,7 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 					const struct nftnl_chain *nlc)
 {
 	struct chain *chain;
+	int priority;
 
 	chain = chain_alloc(nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
 	chain->handle.family =
@@ -386,8 +387,13 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 			nftnl_chain_get_u32(nlc, NFTNL_CHAIN_HOOKNUM);
 		chain->hookstr       =
 			hooknum2str(chain->handle.family, chain->hooknum);
-		chain->priority.num  =
-			nftnl_chain_get_s32(nlc, NFTNL_CHAIN_PRIO);
+		priority = nftnl_chain_get_s32(nlc, NFTNL_CHAIN_PRIO);
+		chain->priority.expr =
+				constant_expr_alloc(&netlink_location,
+						    &integer_type,
+						    BYTEORDER_HOST_ENDIAN,
+						    sizeof(int) *
+						    BITS_PER_BYTE, &priority);
 		chain->type          =
 			xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE));
 		chain->policy          =
@@ -1080,7 +1086,7 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 {
 	struct flowtable *flowtable;
 	const char * const *dev_array;
-	int len = 0, i;
+	int len = 0, i, priority;
 
 	flowtable = flowtable_alloc(&netlink_location);
 	flowtable->handle.family =
@@ -1099,8 +1105,14 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 
 	flowtable->dev_array_len = len;
 
-	flowtable->priority.num =
-		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_PRIO);
+	priority = nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_PRIO);
+	flowtable->priority.expr =
+				constant_expr_alloc(&netlink_location,
+						    &integer_type,
+						    BYTEORDER_HOST_ENDIAN,
+						    sizeof(int) *
+						    BITS_PER_BYTE,
+						    &priority);
 	flowtable->hooknum =
 		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_HOOKNUM);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b463a14..3f763f0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1972,27 +1972,50 @@ extended_prio_name	:	OUT
 extended_prio_spec	:	int_num
 			{
 				struct prio_spec spec = {0};
-				spec.num = $1;
+				spec.expr = constant_expr_alloc(&@$, &integer_type,
+								BYTEORDER_HOST_ENDIAN,
+								sizeof(int) *
+								BITS_PER_BYTE, &$1);
+				$$ = spec;
+			}
+			|	variable_expr
+			{
+				struct prio_spec spec = {0};
+				datatype_set($1->sym->expr, &priority_type);
+				spec.expr = $1;
 				$$ = spec;
 			}
 			|	extended_prio_name
 			{
 				struct prio_spec spec = {0};
-				spec.str = $1;
+				spec.expr = constant_expr_alloc(&@$, &string_type,
+								BYTEORDER_HOST_ENDIAN,
+								strlen($1) *
+								BITS_PER_BYTE, $1);
+				xfree($1);
 				$$ = spec;
 			}
 			|	extended_prio_name PLUS NUM
 			{
 				struct prio_spec spec = {0};
-				spec.num = $3;
-				spec.str = $1;
+				char str[NFT_NAME_MAXLEN];
+				snprintf(str, sizeof(str), "%s + %" PRIu64, $1, $3);
+				spec.expr = constant_expr_alloc(&@$, &string_type,
+								BYTEORDER_HOST_ENDIAN,
+								strlen(str) *
+								BITS_PER_BYTE, str);
+				xfree($1);
 				$$ = spec;
 			}
 			|	extended_prio_name DASH NUM
 			{
 				struct prio_spec spec = {0};
-				spec.num = -$3;
-				spec.str = $1;
+				char str[NFT_NAME_MAXLEN];
+				snprintf(str, sizeof(str), "%s - %" PRIu64, $1, $3);
+				spec.expr = constant_expr_alloc(&@$, &string_type,
+								BYTEORDER_HOST_ENDIAN,
+								strlen(str) *
+								BITS_PER_BYTE, str);
 				$$ = spec;
 			}
 			;
diff --git a/src/parser_json.c b/src/parser_json.c
index 76c0a5c..0e2fd6b 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2580,7 +2580,11 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 	chain = chain_alloc(NULL);
 	chain->flags |= CHAIN_F_BASECHAIN;
 	chain->type = xstrdup(type);
-	chain->priority.num = prio;
+	chain->priority.expr = constant_expr_alloc(int_loc, &integer_type,
+						   BYTEORDER_HOST_ENDIAN,
+						   sizeof(int) *
+						   BITS_PER_BYTE,
+						   &prio);
 	chain->hookstr = chain_hookname_lookup(hookstr);
 	if (!chain->hookstr) {
 		json_error(ctx, "Invalid chain hook '%s'.", hookstr);
@@ -2947,7 +2951,10 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 
 	flowtable = flowtable_alloc(int_loc);
 	flowtable->hookstr = hookstr;
-	flowtable->priority.num = prio;
+	flowtable->priority.expr = constant_expr_alloc(int_loc, &integer_type,
+						       BYTEORDER_HOST_ENDIAN,
+						       sizeof(int) *
+						       BITS_PER_BYTE, &prio);
 
 	flowtable->dev_expr = json_parse_flowtable_devs(ctx, devs);
 	if (!flowtable->dev_expr) {
diff --git a/src/rule.c b/src/rule.c
index 2936065..2aca8af 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -821,7 +821,7 @@ void chain_free(struct chain *chain)
 	xfree(chain->type);
 	if (chain->dev != NULL)
 		xfree(chain->dev);
-	xfree(chain->priority.str);
+	expr_free(chain->priority.expr);
 	xfree(chain);
 }
 
@@ -1051,14 +1051,15 @@ int std_prio_lookup(const char *std_prio_name, int family, int hook)
 
 static const char *prio2str(const struct output_ctx *octx,
 			    char *buf, size_t bufsize, int family, int hook,
-			    int prio)
+			    const struct expr *expr)
 {
 	const struct prio_tag *prio_arr;
+	int std_prio, offset, prio;
 	const char *std_prio_str;
 	const int reach = 10;
-	int std_prio, offset;
 	size_t i, arr_size;
 
+	mpz_export_data(&prio, expr->value, BYTEORDER_HOST_ENDIAN, sizeof(int));
 	if (family == NFPROTO_BRIDGE) {
 		prio_arr = bridge_std_prios;
 		arr_size = array_size(bridge_std_prios);
@@ -1110,7 +1111,7 @@ static void chain_print_declaration(const struct chain *chain,
 		nft_print(octx, " priority %s; policy %s;\n",
 			  prio2str(octx, priobuf, sizeof(priobuf),
 				   chain->handle.family, chain->hooknum,
-				   chain->priority.num),
+				   chain->priority.expr),
 			  chain_policy2str(chain->policy));
 	}
 }
@@ -1141,7 +1142,7 @@ void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
 			  chain->type, chain->hookstr,
 			  prio2str(octx, priobuf, sizeof(priobuf),
 				   chain->handle.family, chain->hooknum,
-				   chain->priority.num),
+				   chain->priority.expr),
 			  chain_policy2str(chain->policy));
 	}
 	if (nft_output_handle(octx))
@@ -2047,7 +2048,7 @@ void flowtable_free(struct flowtable *flowtable)
 	if (--flowtable->refcnt > 0)
 		return;
 	handle_free(&flowtable->handle);
-	xfree(flowtable->priority.str);
+	expr_free(flowtable->priority.expr);
 	xfree(flowtable);
 }
 
@@ -2077,7 +2078,7 @@ static void flowtable_print_declaration(const struct flowtable *flowtable,
 		  opts->tab, opts->tab,
 		  hooknum2str(NFPROTO_NETDEV, flowtable->hooknum),
 		  prio2str(octx, priobuf, sizeof(priobuf), NFPROTO_NETDEV,
-			   flowtable->hooknum, flowtable->priority.num),
+			   flowtable->hooknum, flowtable->priority.expr),
 		  opts->stmt_separator);
 
 	nft_print(octx, "%s%sdevices = { ", opts->tab, opts->tab);
diff --git a/tests/shell/testcases/nft-f/0021priority_variable_0 b/tests/shell/testcases/nft-f/0021priority_variable_0
new file mode 100755
index 0000000..2b143db
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0021priority_variable_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+# Tests use of variables in priority specification
+
+set -e
+
+RULESET="
+define pri = filter
+
+table inet global {
+    chain prerouting {
+        type filter hook prerouting priority \$pri
+        policy accept
+    }
+}"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/nft-f/0022priority_variable_0 b/tests/shell/testcases/nft-f/0022priority_variable_0
new file mode 100755
index 0000000..51bc5eb
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0022priority_variable_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+# Tests use of variables in priority specification
+
+set -e
+
+RULESET="
+define pri = 10
+
+table inet global {
+    chain prerouting {
+        type filter hook prerouting priority \$pri
+        policy accept
+    }
+}"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/nft-f/0023priority_variable_1 b/tests/shell/testcases/nft-f/0023priority_variable_1
new file mode 100755
index 0000000..eddaf5b
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0023priority_variable_1
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+# Tests use of variables in priority specification
+
+set -e
+
+RULESET="
+define pri = *
+
+table inet global {
+    chain prerouting {
+        type filter hook prerouting priority \$pri
+        policy accept
+    }
+}"
+
+$NFT -f - <<< "$RULESET" && exit 1
+exit 0
diff --git a/tests/shell/testcases/nft-f/0024priority_variable_1 b/tests/shell/testcases/nft-f/0024priority_variable_1
new file mode 100755
index 0000000..592cb56
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0024priority_variable_1
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+# Tests use of variables in priority specification
+
+set -e
+
+RULESET="
+define pri = { 127.0.0.1 }
+
+table inet global {
+    chain prerouting {
+        type filter hook prerouting priority \$pri
+        policy accept
+    }
+}"
+
+$NFT -f - <<< "$RULESET" && exit 1
+exit 0
diff --git a/tests/shell/testcases/nft-f/dumps/0021priority_variable_0.nft b/tests/shell/testcases/nft-f/dumps/0021priority_variable_0.nft
new file mode 100644
index 0000000..f409309
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0021priority_variable_0.nft
@@ -0,0 +1,5 @@
+table inet global {
+	chain prerouting {
+		type filter hook prerouting priority filter; policy accept;
+	}
+}
diff --git a/tests/shell/testcases/nft-f/dumps/0022priority_variable_0.nft b/tests/shell/testcases/nft-f/dumps/0022priority_variable_0.nft
new file mode 100644
index 0000000..2e94459
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0022priority_variable_0.nft
@@ -0,0 +1,5 @@
+table inet global {
+	chain prerouting {
+		type filter hook prerouting priority filter + 10; policy accept;
+	}
+}
-- 
2.20.1

