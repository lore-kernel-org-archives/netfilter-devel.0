Return-Path: <SRS0=+/pN=A3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2812C433E4
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 965962071B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgGPRnR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 13:43:17 -0400
Received: from correo.us.es ([193.147.175.20]:39072 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgGPRnQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 13:43:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4D05AEF420
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CDA7DA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3277BDA72F; Thu, 16 Jul 2020 19:43:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB580DA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jul 2020 19:43:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B64754265A2F
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] src: allow to use variables in flowtable and chain devices
Date:   Thu, 16 Jul 2020 19:43:03 +0200
Message-Id: <20200716174305.4114-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200716174305.4114-1-pablo@netfilter.org>
References: <20200716174305.4114-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds support for using variables for devices in the chain and
flowtable definitions, eg.

 define if_main = lo

 table netdev filter1 {
    chain Main_Ingress1 {
        type filter hook ingress device $if_main priority -500; policy accept;
    }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                | 69 +++++++++++++++++++
 src/parser_bison.y                            | 16 +++++
 .../testcases/chains/0042chain_variable_0     | 37 ++++++++++
 .../chains/dumps/0042chain_variable_0.nft     | 15 ++++
 .../flowtable/0012flowtable_variable_0        | 29 ++++++++
 .../dumps/0012flowtable_variable_0.nft        | 14 ++++
 6 files changed, 180 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0042chain_variable_0
 create mode 100644 tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
 create mode 100755 tests/shell/testcases/flowtable/0012flowtable_variable_0
 create mode 100644 tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index 67eb5d6014fb..c9601f175cc4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3719,6 +3719,69 @@ static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
 	return true;
 }
 
+static bool evaluate_expr_variable(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr;
+
+	if (expr_evaluate(ctx, exprp) < 0)
+		return false;
+
+	expr = *exprp;
+	if (expr->etype != EXPR_VALUE &&
+	    expr->etype != EXPR_SET) {
+		expr_error(ctx->msgs, expr, "%s is not a valid "
+			   "variable expression", expr_name(expr));
+		return false;
+	}
+
+	return true;
+}
+
+static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
+{
+	struct expr *expr, *next, *key;
+	LIST_HEAD(tmp);
+
+	if ((*dev_expr)->etype == EXPR_VARIABLE) {
+		expr_set_context(&ctx->ectx, &ifname_type,
+				 IFNAMSIZ * BITS_PER_BYTE);
+		if (!evaluate_expr_variable(ctx, dev_expr))
+			return false;
+	}
+
+	if ((*dev_expr)->etype != EXPR_SET &&
+	    (*dev_expr)->etype != EXPR_LIST)
+		return true;
+
+	list_for_each_entry_safe(expr, next, &(*dev_expr)->expressions, list) {
+		list_del(&expr->list);
+
+		switch (expr->etype) {
+		case EXPR_VARIABLE:
+			expr_set_context(&ctx->ectx, &ifname_type,
+					 IFNAMSIZ * BITS_PER_BYTE);
+			if (!evaluate_expr_variable(ctx, &expr))
+				return false;
+			break;
+		case EXPR_SET_ELEM:
+			key = expr_clone(expr->key);
+			expr_free(expr);
+			expr = key;
+			break;
+		case EXPR_VALUE:
+			break;
+		default:
+			BUG("invalid expresion type %s\n", expr_name(expr));
+			break;
+		}
+
+		list_add(&expr->list, &tmp);
+	}
+	list_splice_init(&tmp, &(*dev_expr)->expressions);
+
+	return true;
+}
+
 static uint32_t str2hooknum(uint32_t family, const char *hook);
 
 static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
@@ -3740,6 +3803,9 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 						   expr_name(ft->priority.expr));
 	}
 
+	if (ft->dev_expr && !evaluate_device_expr(ctx, &ft->dev_expr))
+		return -1;
+
 	return 0;
 }
 
@@ -3965,6 +4031,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 			if (!chain->dev_expr)
 				return __stmt_binary_error(ctx, &chain->loc, NULL,
 							   "Missing `device' in this chain definition");
+
+			if (!evaluate_device_expr(ctx, &chain->dev_expr))
+				return -1;
 		} else if (chain->dev_expr) {
 			return __stmt_binary_error(ctx, &chain->dev_expr->location, NULL,
 						   "This chain type cannot be bound to device");
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 572e584cfbe4..d2d7694ae170 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1945,6 +1945,11 @@ flowtable_expr		:	'{'	flowtable_list_expr	'}'
 				$2->location = @$;
 				$$ = $2;
 			}
+			|	variable_expr
+			{
+				$1->location = @$;
+				$$ = $1;
+			}
 			;
 
 flowtable_list_expr	:	flowtable_expr_member
@@ -1967,6 +1972,11 @@ flowtable_expr_member	:	STRING
 							 strlen($1) * BITS_PER_BYTE, $1);
 				xfree($1);
 			}
+			|	variable_expr
+			{
+				datatype_set($1->sym->expr, &ifname_type);
+				$$ = $1;
+			}
 			;
 
 data_type_atom_expr	:	type_identifier
@@ -2206,6 +2216,12 @@ dev_spec		:	DEVICE	string
 				compound_expr_add($$, expr);
 
 			}
+			|	DEVICE	variable_expr
+			{
+				datatype_set($2->sym->expr, &ifname_type);
+				$$ = compound_expr_alloc(&@$, EXPR_LIST);
+				compound_expr_add($$, $2);
+			}
 			|	DEVICES		'='	flowtable_expr
 			{
 				$$ = $3;
diff --git a/tests/shell/testcases/chains/0042chain_variable_0 b/tests/shell/testcases/chains/0042chain_variable_0
new file mode 100755
index 000000000000..58535f76cc32
--- /dev/null
+++ b/tests/shell/testcases/chains/0042chain_variable_0
@@ -0,0 +1,37 @@
+#!/bin/bash
+
+set -e
+
+ip link add name dummy0 type dummy
+
+EXPECTED="define if_main = \"lo\"
+
+table netdev filter1 {
+	chain Main_Ingress1 {
+		type filter hook ingress device \$if_main priority -500; policy accept;
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+
+EXPECTED="define if_main = \"lo\"
+
+table netdev filter2 {
+	chain Main_Ingress2 {
+		type filter hook ingress devices = { \$if_main, dummy0 } priority -500; policy accept;
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+
+EXPECTED="define if_main = { lo, dummy0 }
+
+table netdev filter3 {
+	chain Main_Ingress3 {
+		type filter hook ingress devices = \$if_main priority -500; policy accept;
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+
+
diff --git a/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft b/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
new file mode 100644
index 000000000000..12931aadb39f
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
@@ -0,0 +1,15 @@
+table netdev filter1 {
+	chain Main_Ingress1 {
+		type filter hook ingress device "lo" priority -500; policy accept;
+	}
+}
+table netdev filter2 {
+	chain Main_Ingress2 {
+		type filter hook ingress devices = { dummy0, lo } priority -500; policy accept;
+	}
+}
+table netdev filter3 {
+	chain Main_Ingress3 {
+		type filter hook ingress devices = { dummy0, lo } priority -500; policy accept;
+	}
+}
diff --git a/tests/shell/testcases/flowtable/0012flowtable_variable_0 b/tests/shell/testcases/flowtable/0012flowtable_variable_0
new file mode 100755
index 000000000000..8e334224ac66
--- /dev/null
+++ b/tests/shell/testcases/flowtable/0012flowtable_variable_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+set -e
+
+ip link add name dummy1 type dummy
+
+EXPECTED="define if_main = { lo, dummy1 }
+
+table filter1 {
+	flowtable Main_ft1 {
+		hook ingress priority filter
+		counter
+		devices = \$if_main
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+
+EXPECTED="define if_main = \"lo\"
+
+table filter2 {
+	flowtable Main_ft2 {
+		hook ingress priority filter
+		counter
+		devices = { \$if_main, dummy1 }
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
diff --git a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
new file mode 100644
index 000000000000..1cbb2f1103f0
--- /dev/null
+++ b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
@@ -0,0 +1,14 @@
+table ip filter1 {
+	flowtable Main_ft1 {
+		hook ingress priority filter
+		devices = { dummy1, lo }
+		counter
+	}
+}
+table ip filter2 {
+	flowtable Main_ft2 {
+		hook ingress priority filter
+		devices = { dummy1, lo }
+		counter
+	}
+}
-- 
2.20.1

