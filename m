Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBA9C7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B215F218EA
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 16:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="mqPA+hdi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbfGVQDP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:03:15 -0400
Received: from mx1.riseup.net ([198.252.153.129]:47874 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbfGVQDP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 12:03:15 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id B98171A4B97
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2019 09:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563811394; bh=igPcftJq/89v/4djHYg+lZWpqx5sDH8Y+Zxmn8c+0/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqPA+hdih4529aCmo6m7x8dlyyKDQKbYfrVvDia7CzQ2LUPY0pe2I9IItGA2SIZ1k
         EDuAWjXIUgZre4mCewi7McpqFvsEv/EqLR+iaSeAzIcMUAMPFKKZ2Dj8Flq7ogC+I1
         MMRmAjfASEFhhYdm+HpuWzPTWtmTBDOzs5AoHVPI=
X-Riseup-User-ID: 58D4B5F5D15D5E9B2DDE407FDCC6249486F0283BA5A13531A415CB3E27A31107
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id C6CB01209B7;
        Mon, 22 Jul 2019 09:03:13 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 nft] src: allow variables in the chain priority specification
Date:   Mon, 22 Jul 2019 18:02:37 +0200
Message-Id: <20190722160236.12516-2-ffmancera@riseup.net>
In-Reply-To: <20190722160236.12516-1-ffmancera@riseup.net>
References: <20190722160236.12516-1-ffmancera@riseup.net>
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

add table ip foo
add chain ip foo bar {type filter hook input priority $pri;}
add chain ip foo ber {type filter hook input priority $prinum;}
add chain ip foo bor {type filter hook input priority $pri + 10;}

table ip foo {
	chain bar {
		type filter hook input priority filter; policy accept;
	}

	chain ber {
		type filter hook input priority filter + 10; policy accept;
	}

	chain bor {
		type filter hook input priority filter + 10; policy accept;
	}
}

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/datatype.h                            |  1 +
 include/rule.h                                |  8 ++--
 src/datatype.c                                | 26 ++++++++++++
 src/evaluate.c                                | 41 ++++++++++++++-----
 src/parser_bison.y                            | 30 ++++++++++----
 src/rule.c                                    |  4 +-
 .../testcases/nft-f/0021priority_variable_0   | 17 ++++++++
 .../testcases/nft-f/0022priority_variable_0   | 17 ++++++++
 .../testcases/nft-f/0023priority_variable_1   | 18 ++++++++
 .../testcases/nft-f/0024priority_variable_1   | 18 ++++++++
 .../nft-f/dumps/0021priority_variable_0.nft   |  5 +++
 .../nft-f/dumps/0022priority_variable_0.nft   |  5 +++
 12 files changed, 166 insertions(+), 24 deletions(-)
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
index 67c3d33..c6e8716 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -174,13 +174,13 @@ enum chain_flags {
  * struct prio_spec - extendend priority specification for mixed
  *                    textual/numerical parsing.
  *
- * @str:  name of the standard priority value
- * @num:  Numerical value. This MUST contain the parsed value of str after
+ * @expr:  expr of the standard priority value
+ * @num:  Numerical value. This MUST contain the parsed value of expr after
  *        evaluation.
  */
 struct prio_spec {
-	const char  *str;
-	int          num;
+	struct expr	*expr;
+	int		num;
 	struct location loc;
 };
 
diff --git a/src/datatype.c b/src/datatype.c
index 6d6826e..b7418e7 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1246,3 +1246,29 @@ const struct datatype boolean_type = {
 	.sym_tbl	= &boolean_tbl,
 	.json		= boolean_type_json,
 };
+
+static struct error_record *priority_type_parse(const struct expr *sym,
+						struct expr **res)
+{
+	int num;
+
+	if (isdigit(sym->identifier[0])) {
+		num = atoi(sym->identifier);
+		*res = constant_expr_alloc(&sym->location, &integer_type,
+					   BYTEORDER_HOST_ENDIAN,
+					   sizeof(int) * BITS_PER_BYTE,
+					   &num);
+	} else
+		*res = constant_expr_alloc(&sym->location, &string_type,
+					   BYTEORDER_HOST_ENDIAN,
+					   strlen(sym->identifier) *
+					   BITS_PER_BYTE, sym->identifier);
+	return NULL;
+}
+
+const struct datatype priority_type = {
+	.type		= TYPE_STRING,
+	.name		= "priority",
+	.desc		= "priority type",
+	.parse		= priority_type_parse,
+};
diff --git a/src/evaluate.c b/src/evaluate.c
old mode 100644
new mode 100755
index 69b853f..d2faee8
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3193,15 +3193,36 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	return 0;
 }
 
-static bool evaluate_priority(struct prio_spec *prio, int family, int hook)
+static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
+			      int family, int hook)
 {
 	int priority;
+	char prio_str[NFT_NAME_MAXLEN];
 
 	/* A numeric value has been used to specify priority. */
-	if (prio->str == NULL)
+	if (prio->expr == NULL)
 		return true;
 
-	priority = std_prio_lookup(prio->str, family, hook);
+	ctx->ectx.dtype = &priority_type;
+	ctx->ectx.len = NFT_NAME_MAXLEN * BITS_PER_BYTE;
+	if (expr_evaluate(ctx, &prio->expr) < 0)
+		return false;
+	if (prio->expr->etype != EXPR_VALUE) {
+		expr_error(ctx->msgs, prio->expr, "%s is not a valid "
+			   "priority expression", expr_name(prio->expr));
+		return false;
+	}
+
+	if (prio->expr->dtype->type == TYPE_INTEGER) {
+		mpz_export_data(&prio->num, prio->expr->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
+		return true;
+	}
+	mpz_export_data(prio_str, prio->expr->value,
+			BYTEORDER_HOST_ENDIAN,
+			NFT_NAME_MAXLEN);
+
+	priority = std_prio_lookup(prio_str, family, hook);
 	if (priority == NF_IP_PRI_LAST)
 		return false;
 	prio->num += priority;
@@ -3223,10 +3244,10 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
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
@@ -3422,11 +3443,11 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
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
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 53e6695..ed7bd89 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -636,8 +636,8 @@ int nft_lex(void *, void *, void *);
 %type <stmt>			meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 %destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 
-%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr
-%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr
+%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr prio_expr
+%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr prio_expr
 %type <expr>			primary_expr shift_expr and_expr
 %destructor { expr_free($$); }	primary_expr shift_expr and_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
@@ -1969,30 +1969,44 @@ extended_prio_name	:	OUT
 			|	STRING
 			;
 
+prio_expr		:	variable_expr
+			{
+				datatype_set($1->sym->expr, &priority_type);
+				$$ = $1;
+			}
+			|	extended_prio_name
+			{
+				$$ = constant_expr_alloc(&@$, &string_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 strlen($1) *
+							 BITS_PER_BYTE, $1);
+			}
+			;
+
 extended_prio_spec	:	int_num
 			{
 				struct prio_spec spec = {0};
 				spec.num = $1;
 				$$ = spec;
 			}
-			|	extended_prio_name
+			|	prio_expr
 			{
 				struct prio_spec spec = {0};
-				spec.str = $1;
+				spec.expr = $1;
 				$$ = spec;
 			}
-			|	extended_prio_name PLUS NUM
+			|	prio_expr PLUS NUM
 			{
 				struct prio_spec spec = {0};
 				spec.num = $3;
-				spec.str = $1;
+				spec.expr = $1;
 				$$ = spec;
 			}
-			|	extended_prio_name DASH NUM
+			|	prio_expr DASH NUM
 			{
 				struct prio_spec spec = {0};
 				spec.num = -$3;
-				spec.str = $1;
+				spec.expr = $1;
 				$$ = spec;
 			}
 			;
diff --git a/src/rule.c b/src/rule.c
index b957b45..23011d9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -823,7 +823,7 @@ void chain_free(struct chain *chain)
 	xfree(chain->type);
 	if (chain->dev != NULL)
 		xfree(chain->dev);
-	xfree(chain->priority.str);
+	expr_free(chain->priority.expr);
 	xfree(chain);
 }
 
@@ -2049,7 +2049,7 @@ void flowtable_free(struct flowtable *flowtable)
 	if (--flowtable->refcnt > 0)
 		return;
 	handle_free(&flowtable->handle);
-	xfree(flowtable->priority.str);
+	expr_free(flowtable->priority.expr);
 	xfree(flowtable);
 }
 
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

