Return-Path: <SRS0=D3ak=AT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8647C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 09:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A75BA2065C
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 09:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGHJ1V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 05:27:21 -0400
Received: from correo.us.es ([193.147.175.20]:42772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgGHJ1V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 05:27:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B40B9EB462
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 11:27:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4CF6DA3A1
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 11:27:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 99094DA72F; Wed,  8 Jul 2020 11:27:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30E36DA73F
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 11:27:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 11:27:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0F01942EF42D
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 11:27:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] src: use expression to store the log prefix
Date:   Wed,  8 Jul 2020 11:27:06 +0200
Message-Id: <20200708092707.21405-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Intsead of using an array of char.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h             |  2 ++
 include/linux/netfilter/nf_log.h |  3 +++
 include/statement.h              |  2 +-
 src/expression.c                 |  9 +++++++++
 src/json.c                       |  9 ++++++---
 src/netlink_delinearize.c        |  6 +++++-
 src/netlink_linearize.c          |  7 +++++--
 src/parser_bison.y               |  7 ++++++-
 src/parser_json.c                |  4 +++-
 src/statement.c                  | 11 ++++++++---
 10 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 8135a516cf3a..87937a5040b3 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -381,6 +381,8 @@ extern const struct datatype *expr_basetype(const struct expr *expr);
 extern void expr_set_type(struct expr *expr, const struct datatype *dtype,
 			  enum byteorder byteorder);
 
+void expr_to_string(const struct expr *expr, char *string);
+
 struct eval_ctx;
 extern int expr_binary_error(struct list_head *msgs,
 			     const struct expr *e1, const struct expr *e2,
diff --git a/include/linux/netfilter/nf_log.h b/include/linux/netfilter/nf_log.h
index 8be21e02387d..2ae00932d3d2 100644
--- a/include/linux/netfilter/nf_log.h
+++ b/include/linux/netfilter/nf_log.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _NETFILTER_NF_LOG_H
 #define _NETFILTER_NF_LOG_H
 
@@ -9,4 +10,6 @@
 #define NF_LOG_MACDECODE	0x20	/* Decode MAC header */
 #define NF_LOG_MASK		0x2f
 
+#define NF_LOG_PREFIXLEN	128
+
 #endif /* _NETFILTER_NF_LOG_H */
diff --git a/include/statement.h b/include/statement.h
index 7d96b3947dfc..061bc6194915 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -75,7 +75,7 @@ enum {
 };
 
 struct log_stmt {
-	const char		*prefix;
+	struct expr		*prefix;
 	unsigned int		snaplen;
 	uint16_t		group;
 	uint16_t		qthreshold;
diff --git a/src/expression.c b/src/expression.c
index a6bde70f508e..fe529f98de7b 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -175,6 +175,15 @@ void expr_describe(const struct expr *expr, struct output_ctx *octx)
 	}
 }
 
+void expr_to_string(const struct expr *expr, char *string)
+{
+	int len = expr->len / BITS_PER_BYTE;
+
+	assert(expr->dtype == &string_type);
+
+	mpz_export_data(string, expr->value, BYTEORDER_HOST_ENDIAN, len);
+}
+
 void expr_set_type(struct expr *expr, const struct datatype *dtype,
 		   enum byteorder byteorder)
 {
diff --git a/src/json.c b/src/json.c
index ed7131816d7d..24583060e68e 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1224,9 +1224,12 @@ json_t *log_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	json_t *root = json_object(), *flags;
 
-	if (stmt->log.flags & STMT_LOG_PREFIX)
-		json_object_set_new(root, "prefix",
-				    json_string(stmt->log.prefix));
+	if (stmt->log.flags & STMT_LOG_PREFIX) {
+		char prefix[NF_LOG_PREFIXLEN] = {};
+
+		expr_to_string(stmt->log.prefix, prefix);
+		json_object_set_new(root, "prefix", json_string(prefix));
+	}
 	if (stmt->log.flags & STMT_LOG_GROUP)
 		json_object_set_new(root, "group",
 				    json_integer(stmt->log.group));
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8de4830c4f80..7d7e07cf89ce 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -901,7 +901,11 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
 	stmt = log_stmt_alloc(loc);
 	prefix = nftnl_expr_get_str(nle, NFTNL_EXPR_LOG_PREFIX);
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOG_PREFIX)) {
-		stmt->log.prefix = xstrdup(prefix);
+		stmt->log.prefix = constant_expr_alloc(&internal_location,
+						       &string_type,
+						       BYTEORDER_HOST_ENDIAN,
+						       (strlen(prefix) + 1) * BITS_PER_BYTE,
+						       prefix);
 		stmt->log.flags |= STMT_LOG_PREFIX;
 	}
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOG_GROUP)) {
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 08f7f89f1066..528f1e5cd0fe 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_log.h>
 
 #include <string.h>
 #include <rule.h>
@@ -1006,8 +1007,10 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("log");
 	if (stmt->log.prefix != NULL) {
-		nftnl_expr_set_str(nle, NFTNL_EXPR_LOG_PREFIX,
-				      stmt->log.prefix);
+		char prefix[NF_LOG_PREFIXLEN] = {};
+
+		expr_to_string(stmt->log.prefix, prefix);
+		nftnl_expr_set_str(nle, NFTNL_EXPR_LOG_PREFIX, prefix);
 	}
 	if (stmt->log.flags & STMT_LOG_GROUP) {
 		nftnl_expr_set_u16(nle, NFTNL_EXPR_LOG_GROUP, stmt->log.group);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 72e67186c913..2fecc3472fba 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2636,7 +2636,12 @@ log_args		:	log_arg
 
 log_arg			:	PREFIX			string
 			{
-				$<stmt>0->log.prefix	 = $2;
+				struct expr *expr;
+
+				expr = constant_expr_alloc(&@$, &string_type,
+							   BYTEORDER_HOST_ENDIAN,
+							   strlen($2) * BITS_PER_BYTE, $2);
+				$<stmt>0->log.prefix	 = expr;
 				$<stmt>0->log.flags 	|= STMT_LOG_PREFIX;
 			}
 			|	GROUP			NUM
diff --git a/src/parser_json.c b/src/parser_json.c
index 9fdef6913ad5..59347168cdc8 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2159,7 +2159,9 @@ static struct stmt *json_parse_log_stmt(struct json_ctx *ctx,
 	stmt = log_stmt_alloc(int_loc);
 
 	if (!json_unpack(value, "{s:s}", "prefix", &tmpstr)) {
-		stmt->log.prefix = xstrdup(tmpstr);
+		stmt->log.prefix = constant_expr_alloc(int_loc, &string_type,
+						       BYTEORDER_HOST_ENDIAN,
+						       (strlen(tmpstr) + 1) * BITS_PER_BYTE, tmpstr);
 		stmt->log.flags |= STMT_LOG_PREFIX;
 	}
 	if (!json_unpack(value, "{s:i}", "group", &tmp)) {
diff --git a/src/statement.c b/src/statement.c
index 21a1bc8d40dd..afedbba21b75 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -18,6 +18,7 @@
 
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter/nf_log.h>
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
 #include <statement.h>
@@ -300,8 +301,12 @@ int log_level_parse(const char *level)
 static void log_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	nft_print(octx, "log");
-	if (stmt->log.flags & STMT_LOG_PREFIX)
-		nft_print(octx, " prefix \"%s\"", stmt->log.prefix);
+	if (stmt->log.flags & STMT_LOG_PREFIX) {
+		char prefix[NF_LOG_PREFIXLEN] = {};
+
+		expr_to_string(stmt->log.prefix, prefix);
+		nft_print(octx, " prefix \"%s\"", prefix);
+	}
 	if (stmt->log.flags & STMT_LOG_GROUP)
 		nft_print(octx, " group %u", stmt->log.group);
 	if (stmt->log.flags & STMT_LOG_SNAPLEN)
@@ -338,7 +343,7 @@ static void log_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 static void log_stmt_destroy(struct stmt *stmt)
 {
-	xfree(stmt->log.prefix);
+	expr_free(stmt->log.prefix);
 }
 
 static const struct stmt_ops log_stmt_ops = {
-- 
2.20.1

