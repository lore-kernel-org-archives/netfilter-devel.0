Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62754C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 13:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E9AC20868
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 13:07:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Phj/3P2q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403794AbfEXNHm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 09:07:42 -0400
Received: from mx1.riseup.net ([198.252.153.129]:54684 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391357AbfEXNHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 09:07:42 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id C4D8A1A4450
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 06:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558703261; bh=ndDLH8k4dVign5GbvaBkqlFOLsUbhw5at8PkgZ733vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Phj/3P2q1YUol3ey3f7BT+AJgpjHscbUnC/S5sKStw5jxuSQukwPcuxAX/62l5jNo
         XPIx8lZou7SI2KQvctaZhaci9IKCHhZWRsmJt21ePorqZcY+Rsn3o/slrwastTWH5y
         N55qggtBS7NKxLeXGvqS4URXvFAea/+uUNK8UvFM=
X-Riseup-User-ID: 1DAED2631A11A9B42442D113146ED4E2F132473AB6D46D41AF0E60E49218425E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 0215C2241B7;
        Fri, 24 May 2019 06:07:40 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v4 2/2] jump: Allow goto and jump to a variable using nft input files
Date:   Fri, 24 May 2019 15:06:50 +0200
Message-Id: <20190524130648.21520-2-ffmancera@riseup.net>
In-Reply-To: <20190524130648.21520-1-ffmancera@riseup.net>
References: <20190524130648.21520-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces the use of nft input files variables in 'jump' and 'goto'
statements, e.g.

define dest = ber

add table ip foo
add chain ip foo bar {type filter hook input priority 0;}
add chain ip foo ber
add rule ip foo ber counter
add rule ip foo bar jump $dest

table ip foo {
        chain bar {
                type filter hook input priority filter; policy accept;
                jump ber
        }

        chain ber {
                counter packets 71 bytes 6664
        }
}

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: fixes parser
v3: add rare usecases tests
v4: nothing new in this patch
---
 src/datatype.c                                | 11 ++++++++++
 src/evaluate.c                                |  7 +++++++
 src/parser_bison.y                            |  3 ++-
 .../shell/testcases/nft-f/0018jump_variable_0 | 19 ++++++++++++++++++
 .../shell/testcases/nft-f/0019jump_variable_1 | 20 +++++++++++++++++++
 .../shell/testcases/nft-f/0020jump_variable_1 | 20 +++++++++++++++++++
 .../nft-f/dumps/0018jump_variable_0.nft       |  8 ++++++++
 7 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/nft-f/0018jump_variable_0
 create mode 100755 tests/shell/testcases/nft-f/0019jump_variable_1
 create mode 100755 tests/shell/testcases/nft-f/0020jump_variable_1
 create mode 100644 tests/shell/testcases/nft-f/dumps/0018jump_variable_0.nft

diff --git a/src/datatype.c b/src/datatype.c
index 10f185b..1d5ed6f 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -309,11 +309,22 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 	}
 }
 
+static struct error_record *verdict_type_parse(const struct expr *sym,
+					       struct expr **res)
+{
+	*res = constant_expr_alloc(&sym->location, &string_type,
+				   BYTEORDER_HOST_ENDIAN,
+				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
+				   sym->identifier);
+	return NULL;
+}
+
 const struct datatype verdict_type = {
 	.type		= TYPE_VERDICT,
 	.name		= "verdict",
 	.desc		= "netfilter verdict",
 	.print		= verdict_type_print,
+	.parse		= verdict_type_parse,
 };
 
 static const struct symbol_table nfproto_tbl = {
diff --git a/src/evaluate.c b/src/evaluate.c
index 8394037..55fb3b6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1950,6 +1950,13 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 		if (stmt->expr->chain != NULL) {
 			if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
 				return -1;
+			if ((stmt->expr->chain->etype != EXPR_SYMBOL &&
+			    stmt->expr->chain->etype != EXPR_VALUE) ||
+			    stmt->expr->chain->symtype != SYMBOL_VALUE) {
+				return stmt_error(ctx, stmt,
+						  "invalid verdict chain expression %s\n",
+						  expr_name(stmt->expr->chain));
+			}
 		}
 		break;
 	case EXPR_MAP:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index b1e29a8..0fea3c6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3841,7 +3841,8 @@ verdict_expr		:	ACCEPT
 			}
 			;
 
-chain_expr		:	identifier
+chain_expr		:	variable_expr
+			|	identifier
 			{
 				$$ = constant_expr_alloc(&@$, &string_type,
 							 BYTEORDER_HOST_ENDIAN,
diff --git a/tests/shell/testcases/nft-f/0018jump_variable_0 b/tests/shell/testcases/nft-f/0018jump_variable_0
new file mode 100755
index 0000000..003a1bd
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0018jump_variable_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+# Tests use of variables in jump statements
+
+set -e
+
+RULESET="
+define dest = ber
+
+table ip foo {
+	chain bar {
+		jump \$dest
+	}
+
+	chain ber {
+	}
+}"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/nft-f/0019jump_variable_1 b/tests/shell/testcases/nft-f/0019jump_variable_1
new file mode 100755
index 0000000..bda861c
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0019jump_variable_1
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+# Tests use of variables in jump statements
+
+set -e
+
+RULESET="
+define dest = { 1024 }
+
+table ip foo {
+	chain bar {
+		jump \$dest
+	}
+
+	chain ber {
+	}
+}"
+
+$NFT -f - <<< "$RULESET" && exit 1
+exit 0
diff --git a/tests/shell/testcases/nft-f/0020jump_variable_1 b/tests/shell/testcases/nft-f/0020jump_variable_1
new file mode 100755
index 0000000..f753058
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0020jump_variable_1
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+# Tests use of variables in jump statements
+
+set -e
+
+RULESET="
+define dest = *
+
+table ip foo {
+	chain bar {
+		jump \$dest
+	}
+
+	chain ber {
+	}
+}"
+
+$NFT -f - <<< "$RULESET" && exit 1
+exit 0
diff --git a/tests/shell/testcases/nft-f/dumps/0018jump_variable_0.nft b/tests/shell/testcases/nft-f/dumps/0018jump_variable_0.nft
new file mode 100644
index 0000000..0ddaf07
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0018jump_variable_0.nft
@@ -0,0 +1,8 @@
+table ip foo {
+	chain bar {
+		jump ber
+	}
+
+	chain ber {
+	}
+}
-- 
2.20.1

