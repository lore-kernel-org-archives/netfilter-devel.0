Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E792FEDD
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984137; cv=none; b=KMVdX3/SI+4SkI9xRd2ASHXTvpxq7hTCpYOqYL2IgZhPgmNysX0agB8XlQTqANH0scRDJ7p5Opk7WUX+EI47W7YPCYEk9EzhG9a9z4qwXooHXciRqm6FfOUARq13sNtUpQyh1X2R2sPSDilVYrXcULDtAS/Nbt2DAQTOdpuPDuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984137; c=relaxed/simple;
	bh=Ev1mzNidUkI+oEiYi0GtWLXUFWnmVxAUz3qn3MlLajk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsNmisU/dU45c9tq2to2v8WbbCAc26K2ox/BdPUCQsXyDWgCvLpdYQtxJfndWUXpIFMv1LZeRgOaYsF2vgqPE3nm1jp0/qVzhBkShND3cgR2QQQiZUIsxBTo+XIgxXp6Snafwb3+gkHk7KVp92O5PiQxw4pfImU3kP99/aiiS1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qNm5y8Do; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qNm5y8Do"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4PRCPI8pluOOcXw+JlsLS4iq1gM48Jjr/j9hMqLTlbI=; b=qNm5y8DorUTzmIXkWdOPzUdS0H
	PEfIk+Vk+DztfN6R7uU4oox5Y06u0YiDrWLGgHkJikce34553FbqrJwrTsrZOVEDM7Ifrg+329c3m
	5g7p+A44We4B8kt6z89itHe+bBmjgryltppuqf9aMpNRaeYv8zEGRtzVbV9RKgXhSC7aqgHkFtwZu
	b8efQrp88a0CoRszxnfYd4aZXvBSpq3REM3n3IZxagwtjFXPib9UgjD8QiX+j6ZKLHx4iC4QTfxIM
	n6oVTRLslipa7lt2d448F2BihiSx30aNCsOiB5uU1hnVgNZfG0xIHariV+wwaSfsok2YKNXhLTXYt
	8Urr4F8A==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riuzD-000000003h0-23xt;
	Sat, 09 Mar 2024 12:35:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 5/7] json: Support maps with concatenated data
Date: Sat,  9 Mar 2024 12:35:25 +0100
Message-ID: <20240309113527.8723-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240309113527.8723-1-phil@nwl.cc>
References: <20240309113527.8723-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dump such maps with an array of types in "map" property, make the parser
aware of this.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c        | 10 +++++-----
 src/parser_json.c | 18 +++++++++---------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/src/json.c b/src/json.c
index bb515164d2587..29fbd0cfdba28 100644
--- a/src/json.c
+++ b/src/json.c
@@ -130,15 +130,15 @@ static json_t *set_stmt_list_json(const struct list_head *stmt_list,
 
 static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 {
-	json_t *root, *tmp;
-	const char *type, *datatype_ext = NULL;
+	json_t *root, *tmp, *datatype_ext = NULL;
+	const char *type;
 
 	if (set_is_datamap(set->flags)) {
 		type = "map";
-		datatype_ext = set->data->dtype->name;
+		datatype_ext = set_dtype_json(set->data);
 	} else if (set_is_objmap(set->flags)) {
 		type = "map";
-		datatype_ext = obj_type_name(set->objtype);
+		datatype_ext = json_string(obj_type_name(set->objtype));
 	} else if (set_is_meter(set->flags)) {
 		type = "meter";
 	} else {
@@ -155,7 +155,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 	if (set->comment)
 		json_object_set_new(root, "comment", json_string(set->comment));
 	if (datatype_ext)
-		json_object_set_new(root, "map", json_string(datatype_ext));
+		json_object_set_new(root, "map", datatype_ext);
 
 	if (!(set->flags & (NFT_SET_CONSTANT))) {
 		if (set->policy != NFT_SET_POL_PERFORMANCE) {
diff --git a/src/parser_json.c b/src/parser_json.c
index ff52423af4d7f..bb027448319c5 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3255,7 +3255,7 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 					  enum cmd_ops op, enum cmd_obj obj)
 {
 	struct handle h = { 0 };
-	const char *family = "", *policy, *dtype_ext = NULL;
+	const char *family = "", *policy;
 	json_t *tmp, *stmt_json;
 	struct set *set;
 
@@ -3308,19 +3308,19 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 		return NULL;
 	}
 
-	if (!json_unpack(root, "{s:s}", "map", &dtype_ext)) {
-		const struct datatype *dtype;
+	if (!json_unpack(root, "{s:o}", "map", &tmp)) {
+		if (json_is_string(tmp)) {
+			const char *s = json_string_value(tmp);
 
-		set->objtype = string_to_nft_object(dtype_ext);
+			set->objtype = string_to_nft_object(s);
+		}
 		if (set->objtype) {
 			set->flags |= NFT_SET_OBJECT;
-		} else if ((dtype = datatype_lookup_byname(dtype_ext))) {
-			set->data = constant_expr_alloc(&netlink_location,
-							dtype, dtype->byteorder,
-							dtype->size, NULL);
+		} else if ((set->data = json_parse_dtype_expr(ctx, tmp))) {
 			set->flags |= NFT_SET_MAP;
 		} else {
-			json_error(ctx, "Invalid map type '%s'.", dtype_ext);
+			json_error(ctx, "Invalid map type '%s'.",
+				   json_dumps(tmp, 0));
 			set_free(set);
 			handle_free(&h);
 			return NULL;
-- 
2.43.0

