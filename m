From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] nftables: make pointers in string arrays constant
Date: Fri,  6 Oct 2017 20:17:54 +0530
Message-ID: <20171006144754.17362-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33811 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdJFOuZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 10:50:25 -0400
Received: by mail-pg0-f65.google.com with SMTP id u27so18429054pgn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Oct 2017 07:50:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Static const char * array should be static const char *
const array as per linux-kernel coding style

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v2:e
 -rebase against current tree and solve merge confilcts
 -Change log message

 src/erec.c      | 2 +-
 src/evaluate.c  | 4 ++--
 src/rule.c      | 6 +++---
 src/statement.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/erec.c b/src/erec.c
index 76fdeb8..80806ff 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -27,7 +27,7 @@ const struct location internal_location = {
 	.indesc	= &internal_indesc,
 };
 
-static const char *error_record_names[] = {
+static const char * const error_record_names[] = {
 	[EREC_INFORMATIONAL]	= NULL,
 	[EREC_WARNING]		= "Warning",
 	[EREC_ERROR]		= "Error"
diff --git a/src/evaluate.c b/src/evaluate.c
index 193ea1c..618e188 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -32,7 +32,7 @@
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
 
-static const char *byteorder_names[] = {
+static const char * const byteorder_names[] = {
 	[BYTEORDER_INVALID]		= "invalid",
 	[BYTEORDER_HOST_ENDIAN]		= "host endian",
 	[BYTEORDER_BIG_ENDIAN]		= "big endian",
@@ -3423,7 +3423,7 @@ static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 			    ctx->debug_mask & DEBUG_NETLINK, ctx->octx);
 }
 
-static const char *cmd_op_name[] = {
+static const char * const cmd_op_name[] = {
 	[CMD_INVALID]	= "invalid",
 	[CMD_ADD]	= "add",
 	[CMD_REPLACE]	= "replace",
diff --git a/src/rule.c b/src/rule.c
index 67a828f..d744cf6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -496,7 +496,7 @@ struct symbol *symbol_lookup(const struct scope *scope, const char *identifier)
 	return NULL;
 }
 
-static const char *chain_type_str_array[] = {
+static const char * const chain_type_str_array[] = {
 	"filter",
 	"nat",
 	"route",
@@ -515,7 +515,7 @@ const char *chain_type_name_lookup(const char *name)
 	return NULL;
 }
 
-static const char *chain_hookname_str_array[] = {
+static const char * const chain_hookname_str_array[] = {
 	"prerouting",
 	"input",
 	"forward",
@@ -1345,7 +1345,7 @@ static void obj_print_data(const struct obj *obj,
 	}
 }
 
-static const char *obj_type_name_array[] = {
+static const char * const obj_type_name_array[] = {
 	[NFT_OBJECT_COUNTER]	= "counter",
 	[NFT_OBJECT_QUOTA]	= "quota",
 	[NFT_OBJECT_CT_HELPER]	= "",
diff --git a/src/statement.c b/src/statement.c
index 6166863..11d067f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -302,7 +302,7 @@ const char *get_unit(uint64_t u)
 	return "error";
 }
 
-static const char *data_unit[] = {
+static const char * const data_unit[] = {
 	"bytes",
 	"kbytes",
 	"mbytes",
@@ -496,7 +496,7 @@ static void print_nf_nat_flags(uint32_t flags, struct output_ctx *octx)
 
 static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	static const char *nat_types[] = {
+	static const char * const nat_types[] = {
 		[NFT_NAT_SNAT]	= "snat",
 		[NFT_NAT_DNAT]	= "dnat",
 	};
-- 
2.11.0

