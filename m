Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B31204592
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 14:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518220; cv=none; b=k7yksNfB+QJnmbGfch3g/Pk2SZJBeobT9VpQh/8/kLHLpmNSLj2sddHTWuFVFfCEBACQLMCOaUIel7pZH22LvYaziPQni8/+xEYkuKm+adPlYVQM7zNATyg7qs8VVwQ79NY4Xz9cT5ZyWDSHT9hOG6glLwsH1yAbzDxPXNk4/HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518220; c=relaxed/simple;
	bh=wAiyrD19lQBJmN3v1HWXlbNm4pfUdZVmH71eG4PB3UM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lcj5zKrkpsRgzXppKj6mEFaN1O726k/D1lXYmu+8R1wB6bVfnJwWJe1FLkC1G2ejshq4Ik+JQQ8mtLDLlqIzhJa9HEqZm+C/dCGIwvra5EAWDR6xIujbMEAIbfqjx4aAbLyQ7ZEA90gLX4BbahptlYo13NrXB5R+DIRFkKXeqVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b/yePj/u; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b/yePj/u; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b/yePj/u";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b/yePj/u"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AF37960561; Tue,  1 Apr 2025 16:36:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743518216;
	bh=AEqy4CfaOobgtRZCZjPeW9l97xwINAK4HWiwFxCAXUA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=b/yePj/ufuKwNFwo6svPqj++VcvObNGMz65Ro5zr0JWFqRYqdNpl47ZPdzv63x+nb
	 WZoEdqZ09S8garT6xJsAdjExUgiYACUvUYeBqDalBxrO5q8NDYbmoCC+ZJaso+b9tl
	 Odt296kthARZIKzT3ar3TVMM/XaoEIlK66F4R1O+q1Aj5Mwjjh1QIgbkE1KwlQRPnA
	 Tp3IjEA/LFE9sztJVrAuSxyQjhu9B/BEG5SgiDTssuSzDZLvbCHcb7WK6JpTCEAbqg
	 JL8McMjTvkPHJfdWuJFMbolm678rahEq/t6gI9IBNgCmqQJpvOPCikx2mMPWiMihvD
	 MqKoFgQXj0eFg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 42C30603B8
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 16:36:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743518216;
	bh=AEqy4CfaOobgtRZCZjPeW9l97xwINAK4HWiwFxCAXUA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=b/yePj/ufuKwNFwo6svPqj++VcvObNGMz65Ro5zr0JWFqRYqdNpl47ZPdzv63x+nb
	 WZoEdqZ09S8garT6xJsAdjExUgiYACUvUYeBqDalBxrO5q8NDYbmoCC+ZJaso+b9tl
	 Odt296kthARZIKzT3ar3TVMM/XaoEIlK66F4R1O+q1Aj5Mwjjh1QIgbkE1KwlQRPnA
	 Tp3IjEA/LFE9sztJVrAuSxyQjhu9B/BEG5SgiDTssuSzDZLvbCHcb7WK6JpTCEAbqg
	 JL8McMjTvkPHJfdWuJFMbolm678rahEq/t6gI9IBNgCmqQJpvOPCikx2mMPWiMihvD
	 MqKoFgQXj0eFg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] parser_json: bail out on malformed statement in set
Date: Tue,  1 Apr 2025 16:36:51 +0200
Message-Id: <20250401143651.1313098-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250401143651.1313098-1-pablo@netfilter.org>
References: <20250401143651.1313098-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Propagate error to caller so it bails out on malformed set statements.

Fixes: 07958ec53830 ("json: add set statement list support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_json.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 4c9dc5415445..94d09212314f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2410,9 +2410,9 @@ static struct stmt *json_parse_reject_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
-static void json_parse_set_stmt_list(struct json_ctx *ctx,
-				     struct list_head *stmt_list,
-				     json_t *stmt_json)
+static int json_parse_set_stmt_list(struct json_ctx *ctx,
+				    struct list_head *stmt_list,
+				    json_t *stmt_json)
 {
 	struct list_head *head;
 	struct stmt *stmt;
@@ -2420,10 +2420,12 @@ static void json_parse_set_stmt_list(struct json_ctx *ctx,
 	size_t index;
 
 	if (!stmt_json)
-		return;
+		return 0;
 
-	if (!json_is_array(stmt_json))
+	if (!json_is_array(stmt_json)) {
 		json_error(ctx, "Unexpected object type in stmt");
+		return -1;
+	}
 
 	head = stmt_list;
 	json_array_foreach(stmt_json, index, value) {
@@ -2431,16 +2433,19 @@ static void json_parse_set_stmt_list(struct json_ctx *ctx,
 		if (!stmt) {
 			json_error(ctx, "Parsing set statements array at index %zd failed.", index);
 			stmt_list_free(stmt_list);
-			return;
+			return -1;
 		}
 		if (!(stmt->flags & STMT_F_STATEFUL)) {
 			stmt_free(stmt);
 			json_error(ctx, "Unsupported set statements array at index %zd failed.", index);
 			stmt_list_free(stmt_list);
+			return -1;
 		}
 		list_add(&stmt->list, head);
 		head = &stmt->list;
 	}
+
+	return 0;
 }
 
 static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
@@ -2485,8 +2490,11 @@ static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
 	stmt->set.key = expr;
 	stmt->set.set = expr2;
 
-	if (!json_unpack(value, "{s:o}", "stmt", &stmt_json))
-		json_parse_set_stmt_list(ctx, &stmt->set.stmt_list, stmt_json);
+	if (!json_unpack(value, "{s:o}", "stmt", &stmt_json) &&
+	    json_parse_set_stmt_list(ctx, &stmt->set.stmt_list, stmt_json) < 0) {
+		stmt_free(stmt);
+		return NULL;
+	}
 
 	return stmt;
 }
@@ -2542,8 +2550,11 @@ static struct stmt *json_parse_map_stmt(struct json_ctx *ctx,
 	stmt->map.data = expr_data;
 	stmt->map.set = expr2;
 
-	if (!json_unpack(value, "{s:o}", "stmt", &stmt_json))
-		json_parse_set_stmt_list(ctx, &stmt->set.stmt_list, stmt_json);
+	if (!json_unpack(value, "{s:o}", "stmt", &stmt_json) &&
+	    json_parse_set_stmt_list(ctx, &stmt->set.stmt_list, stmt_json) < 0) {
+		stmt_free(stmt);
+		return NULL;
+	}
 
 	return stmt;
 }
@@ -3490,8 +3501,12 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 	json_unpack(root, "{s:i}", "size", &set->desc.size);
 	json_unpack(root, "{s:b}", "auto-merge", &set->automerge);
 
-	if (!json_unpack(root, "{s:o}", "stmt", &stmt_json))
-		json_parse_set_stmt_list(ctx, &set->stmt_list, stmt_json);
+	if (!json_unpack(root, "{s:o}", "stmt", &stmt_json) &&
+	    json_parse_set_stmt_list(ctx, &set->stmt_list, stmt_json) < 0) {
+		set_free(set);
+		handle_free(&h);
+		return NULL;
+	}
 
 	handle_merge(&set->handle, &h);
 
-- 
2.30.2

