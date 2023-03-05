Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A8AC61DA4
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjCEKaN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjCEKaH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:30:07 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A28DD323
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZUOeA0J8ve970CSDrGYaACpHyYnHr/ot6BW1mLkKrYM=; b=FWrlT5WSZm70QJ1r0efi7HUYU/
        b22+cn6pcMe4/ULtfSH5+2QwyKA/W29E6KOCyIrILbXMhoFCRO4OCxDFyjsIW0CUtRI5FIdFpa2zc
        HS4AjhxaKtjqC4lSEuZ66O/3ZqqM44B9wInTQHTzBF0fk8WoNAi/VsjYjhpzspwxjFjY2lxbtVW/5
        Geb6f+0hwIQ0cpA9BDYI/4vNQ5PZosWg7O/6spG3eqGCxs1ww7cprbY2pZqF+P+wtNJ9E4ezR9ONC
        tdY/stRErbgZnuDrYPIBsWoyDQ2JQRZtNJpG8zqmXV5qmDDtWRVxloxPafS8Qh3uQk9c93u001Rft
        2hkC4F3w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlcv-00DzC0-5t
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:30:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 4/8] json: formatting fixes
Date:   Sun,  5 Mar 2023 10:14:14 +0000
Message-Id: <20230305101418.2233910-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305101418.2233910-1-jeremy@azazel.net>
References: <20230305101418.2233910-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A few indentation tweaks for the JSON parser.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/parser_json.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index ec0c02a044e2..d8d4f1b79e6e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -610,7 +610,7 @@ static struct expr *json_parse_tcp_option_expr(struct json_ctx *ctx,
 	struct expr *expr;
 
 	if (!json_unpack(root, "{s:i, s:i, s:i}",
-			"base", &kind, "offset", &offset, "len", &len)) {
+			 "base", &kind, "offset", &offset, "len", &len)) {
 		uint32_t flag = 0;
 
 		if (kind < 0 || kind > 255)
@@ -681,7 +681,7 @@ static int json_parse_ip_option_field(int type, const char *name, int *val)
 }
 
 static struct expr *json_parse_ip_option_expr(struct json_ctx *ctx,
-					       const char *type, json_t *root)
+					      const char *type, json_t *root)
 {
 	const char *desc, *field;
 	int descval, fieldval;
@@ -697,7 +697,7 @@ static struct expr *json_parse_ip_option_expr(struct json_ctx *ctx,
 
 	if (json_unpack(root, "{s:s}", "field", &field)) {
 		expr = ipopt_expr_alloc(int_loc, descval,
-					 IPOPT_FIELD_TYPE);
+					IPOPT_FIELD_TYPE);
 		expr->exthdr.flags = NFT_EXTHDR_F_PRESENT;
 
 		return expr;
@@ -1084,13 +1084,13 @@ static struct expr *json_parse_fib_expr(struct json_ctx *ctx,
 	}
 
 	if ((flagval & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) ==
-			(NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) {
+	    (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) {
 		json_error(ctx, "fib: saddr and daddr are mutually exclusive");
 		return NULL;
 	}
 
 	if ((flagval & (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) ==
-			(NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) {
+	    (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) {
 		json_error(ctx, "fib: iif and oif are mutually exclusive");
 		return NULL;
 	}
@@ -1686,7 +1686,7 @@ static struct stmt *json_parse_match_stmt(struct json_ctx *ctx,
 }
 
 static struct stmt *json_parse_counter_stmt(struct json_ctx *ctx,
-					  const char *key, json_t *value)
+					    const char *key, json_t *value)
 {
 	uint64_t packets, bytes;
 	struct stmt *stmt;
@@ -1695,8 +1695,8 @@ static struct stmt *json_parse_counter_stmt(struct json_ctx *ctx,
 		return counter_stmt_alloc(int_loc);
 
 	if (!json_unpack(value, "{s:I, s:I}",
-			    "packets", &packets,
-			    "bytes", &bytes)) {
+			 "packets", &packets,
+			 "bytes", &bytes)) {
 		stmt = counter_stmt_alloc(int_loc);
 		stmt->counter.packets = packets;
 		stmt->counter.bytes = bytes;
@@ -1727,14 +1727,14 @@ static struct stmt *json_parse_verdict_stmt(struct json_ctx *ctx,
 }
 
 static struct stmt *json_parse_mangle_stmt(struct json_ctx *ctx,
-					const char *type, json_t *root)
+					   const char *type, json_t *root)
 {
 	json_t *jkey, *jvalue;
 	struct expr *key, *value;
 	struct stmt *stmt;
 
 	if (json_unpack_err(ctx, root, "{s:o, s:o}",
-			   "key", &jkey, "value", &jvalue))
+			    "key", &jkey, "value", &jvalue))
 		return NULL;
 
 	key = json_parse_mangle_lhs_expr(ctx, jkey);
@@ -1787,7 +1787,7 @@ static uint64_t rate_to_bytes(uint64_t val, const char *unit)
 }
 
 static struct stmt *json_parse_quota_stmt(struct json_ctx *ctx,
-					const char *key, json_t *value)
+					  const char *key, json_t *value)
 {
 	struct stmt *stmt;
 	int inv = 0;
@@ -1937,7 +1937,7 @@ static struct stmt *json_parse_flow_offload_stmt(struct json_ctx *ctx,
 }
 
 static struct stmt *json_parse_notrack_stmt(struct json_ctx *ctx,
-					const char *key, json_t *value)
+					    const char *key, json_t *value)
 {
 	return notrack_stmt_alloc(int_loc);
 }
@@ -1975,7 +1975,7 @@ static struct stmt *json_parse_dup_stmt(struct json_ctx *ctx,
 }
 
 static struct stmt *json_parse_secmark_stmt(struct json_ctx *ctx,
-					     const char *key, json_t *value)
+					    const char *key, json_t *value)
 {
 	struct stmt *stmt;
 
@@ -2047,7 +2047,7 @@ static int json_parse_nat_flags(struct json_ctx *ctx, json_t *root)
 }
 
 static int json_parse_nat_type_flag(struct json_ctx *ctx,
-			       json_t *root, int *flags)
+				    json_t *root, int *flags)
 {
 	const struct {
 		const char *flag;
@@ -2162,7 +2162,6 @@ static struct stmt *json_parse_nat_stmt(struct json_ctx *ctx,
 		}
 		stmt->nat.flags = flags;
 	}
-
 	if (!json_unpack(value, "{s:o}", "type_flags", &tmp)) {
 		int flags = json_parse_nat_type_flags(ctx, tmp);
 
@@ -2177,7 +2176,7 @@ static struct stmt *json_parse_nat_stmt(struct json_ctx *ctx,
 }
 
 static struct stmt *json_parse_tproxy_stmt(struct json_ctx *ctx,
-					const char *key, json_t *value)
+					   const char *key, json_t *value)
 {
 	json_t *jaddr, *tmp;
 	struct stmt *stmt;
@@ -2213,7 +2212,7 @@ out_free:
 }
 
 static struct stmt *json_parse_reject_stmt(struct json_ctx *ctx,
-					  const char *key, json_t *value)
+					   const char *key, json_t *value)
 {
 	struct stmt *stmt = reject_stmt_alloc(int_loc);
 	const struct datatype *dtype = NULL;
@@ -2256,8 +2255,8 @@ static struct stmt *json_parse_reject_stmt(struct json_ctx *ctx,
 }
 
 static void json_parse_set_stmt_list(struct json_ctx *ctx,
-				      struct list_head *stmt_list,
-				      json_t *stmt_json)
+				     struct list_head *stmt_list,
+				     json_t *stmt_json)
 {
 	struct list_head *head;
 	struct stmt *tmp;
@@ -2279,7 +2278,7 @@ static void json_parse_set_stmt_list(struct json_ctx *ctx,
 }
 
 static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
-					  const char *key, json_t *value)
+					const char *key, json_t *value)
 {
 	const char *opstr, *set;
 	struct expr *expr, *expr2;
@@ -2562,7 +2561,7 @@ static struct stmt *json_parse_cthelper_stmt(struct json_ctx *ctx,
 }
 
 static struct stmt *json_parse_cttimeout_stmt(struct json_ctx *ctx,
-					     const char *key, json_t *value)
+					      const char *key, json_t *value)
 {
 	struct stmt *stmt = objref_stmt_alloc(int_loc);
 
-- 
2.39.2

