Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FBE2066CE
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 21:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746740853; cv=none; b=HYNrXeY6bLfWZWnNY4fpGp4GxOwmhWxeA0Gs8B1qjakUeZuo661fB9rSyj2tlBYTFN8rS8s8jUyoQR7Cu/XX3kD9AtKZoHoK9LjRWgqfed6BwDQPfp88oCOvlKANOxCEhprNcLZm3moE23lGD4ZQ+wnQJbA9UteboRPA4RqsoqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746740853; c=relaxed/simple;
	bh=VHlHZ6Gn7LG6Gna3gQyEjj6oI+NyU62nDLDnC5WYC3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nhu9l99QHbXrddjQAak4EOr16rurl8kg2CcGqXzgdT6jbwQRX+Dg3Y/IupHz6i3tSq6IJVw7ciyAWuiL8MMbtM5FCbHKwQAux9emgSFHIq+6jwmqv96BUZdHXCuG2zNKwiltS7IN4emaxgfnRLEjPWSyiO0iWnlErSpT7u7CwKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=coYo1lrH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="coYo1lrH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=a+a4aXM2Gx56W0ncRkemENOQ/NuaSb8tArk1WsljE7I=; b=coYo1lrHHvdwFqacFL5EQz+l+P
	vxD+GCJnBJRNHoDu3DyhouuJSVxlfgeDTdeWIX/KOssl5ZZN5XJBOnDHpvTxT7oKOlG/ag9qOFWeN
	pHwhNeD35skmWfsunAWeuw/ny4pbxVV+M3SHNY/aN7Q+j6Wc6aWCpuerDNZj8WAdEz7bgNf59+f5C
	loEBopCKn5qw7WuW1PZbUHcbRr+rC3g98ZhXqzekxQruIPBm80zX8cP96WR9pG7pmoXeyT/a6Y8Zp
	sxHiw0mGWxCoSE9bRl+5BN/3IYO5TMhG51vrZ6ipVCBzMXhEl9bJX4lgQJAfHIvggaeDB+NNopkjY
	f4rbnFFg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uD95U-000000000mt-3o3F;
	Thu, 08 May 2025 23:47:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/6] json: Introduce json_add_array_new()
Date: Thu,  8 May 2025 23:47:21 +0200
Message-ID: <20250508214722.20808-6-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250508214722.20808-1-phil@nwl.cc>
References: <20250507222830.22525-1-phil@nwl.cc>
 <20250508214722.20808-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Propagate nat_stmt_add_array() to a generic helper for use in all spots
adding an array property which may reduce to a single item or even not
exist at all.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c | 99 +++++++++++++-----------------------------------------
 1 file changed, 24 insertions(+), 75 deletions(-)

diff --git a/src/json.c b/src/json.c
index 0034c02f678ff..cbed9ce9ccb73 100644
--- a/src/json.c
+++ b/src/json.c
@@ -51,6 +51,18 @@ static int json_array_extend_new(json_t *array, json_t *other_array)
 	return ret;
 }
 
+static void json_add_array_new(json_t *obj, const char *name, json_t *array)
+{
+	if (json_array_size(array) > 1) {
+		json_object_set_new(obj, name, array);
+	} else {
+		if (json_array_size(array))
+			json_object_set(obj, name,
+					json_array_get(array, 0));
+		json_decref(array);
+	}
+}
+
 static json_t *expr_print_json(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct expr_ops *ops;
@@ -198,14 +210,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 		json_array_append_new(tmp, json_pack("s", "timeout"));
 	if (set->flags & NFT_SET_EVAL)
 		json_array_append_new(tmp, json_pack("s", "dynamic"));
-
-	if (json_array_size(tmp) > 1) {
-		json_object_set_new(root, "flags", tmp);
-	} else {
-		if (json_array_size(tmp))
-			json_object_set(root, "flags", json_array_get(tmp, 0));
-		json_decref(tmp);
-	}
+	json_add_array_new(root, "flags", tmp);
 
 	if (set->timeout) {
 		tmp = json_integer(set->timeout / 1000);
@@ -449,19 +454,16 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_SYNPROXY:
-		flags = json_array();
 		tmp = json_pack("{s:i, s:i}",
 				"mss", obj->synproxy.mss,
 				"wscale", obj->synproxy.wscale);
+
+		flags = json_array();
 		if (obj->synproxy.flags & NF_SYNPROXY_OPT_TIMESTAMP)
 			json_array_append_new(flags, json_string("timestamp"));
 		if (obj->synproxy.flags & NF_SYNPROXY_OPT_SACK_PERM)
 			json_array_append_new(flags, json_string("sack-perm"));
-
-		if (json_array_size(flags) > 0)
-			json_object_set_new(tmp, "flags", flags);
-		else
-			json_decref(flags);
+		json_add_array_new(tmp, "flags", flags);
 
 		json_object_update(root, tmp);
 		json_decref(tmp);
@@ -515,31 +517,18 @@ static json_t *table_flags_json(const struct table *table)
 		flags >>= 1;
 		i++;
 	}
-	switch (json_array_size(root)) {
-	case 0:
-		json_decref(root);
-		return NULL;
-	case 1:
-		json_unpack(root, "[O]", &tmp);
-		json_decref(root);
-		root = tmp;
-		break;
-	}
 	return root;
 }
 
 static json_t *table_print_json(const struct table *table)
 {
-	json_t *root, *tmp;
+	json_t *root;
 
 	root = json_pack("{s:s, s:s, s:I}",
 			 "family", family2str(table->handle.family),
 			 "name", table->handle.table.name,
 			 "handle", table->handle.handle.id);
-
-	tmp = table_flags_json(table);
-	if (tmp)
-		json_object_set_new(root, "flags", tmp);
+	json_add_array_new(root, "flags", table_flags_json(table));
 
 	if (table->comment)
 		json_object_set_new(root, "comment", json_string(table->comment));
@@ -940,14 +929,7 @@ json_t *fib_expr_json(const struct expr *expr, struct output_ctx *octx)
 		if (flags)
 			json_array_append_new(tmp, json_integer(flags));
 
-		if (json_array_size(tmp) > 1) {
-			json_object_set_new(root, "flags", tmp);
-		} else {
-			if (json_array_size(tmp))
-				json_object_set(root, "flags",
-						json_array_get(tmp, 0));
-			json_decref(tmp);
-		}
+		json_add_array_new(root, "flags", tmp);
 	}
 	return json_pack("{s:o}", "fib", root);
 }
@@ -1384,14 +1366,7 @@ json_t *log_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		if (stmt->log.logflags & NF_LOG_MACDECODE)
 			json_array_append_new(flags, json_string("ether"));
 	}
-	if (json_array_size(flags) > 1) {
-		json_object_set_new(root, "flags", flags);
-	} else {
-		if (json_array_size(flags))
-			json_object_set(root, "flags",
-					json_array_get(flags, 0));
-		json_decref(flags);
-	}
+	json_add_array_new(root, "flags", flags);
 
 	if (!json_object_size(root)) {
 		json_decref(root);
@@ -1426,18 +1401,6 @@ static json_t *nat_type_flags_json(uint32_t type_flags)
 	return array;
 }
 
-static void nat_stmt_add_array(json_t *root, const char *name, json_t *array)
-{
-	if (json_array_size(array) > 1) {
-		json_object_set_new(root, name, array);
-	} else {
-		if (json_array_size(array))
-			json_object_set(root, name,
-					json_array_get(array, 0));
-		json_decref(array);
-	}
-}
-
 json_t *nat_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	json_t *root = json_object();
@@ -1459,12 +1422,12 @@ json_t *nat_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		json_object_set_new(root, "port",
 				    expr_print_json(stmt->nat.proto, octx));
 
-	nat_stmt_add_array(root, "flags", array);
+	json_add_array_new(root, "flags", array);
 
 	if (stmt->nat.type_flags) {
 		array = nat_type_flags_json(stmt->nat.type_flags);
 
-		nat_stmt_add_array(root, "type_flags", array);
+		json_add_array_new(root, "type_flags", array);
 	}
 
 	if (!json_object_size(root)) {
@@ -1616,14 +1579,7 @@ json_t *queue_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		json_array_append_new(flags, json_string("bypass"));
 	if (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT)
 		json_array_append_new(flags, json_string("fanout"));
-	if (json_array_size(flags) > 1) {
-		json_object_set_new(root, "flags", flags);
-	} else {
-		if (json_array_size(flags))
-			json_object_set(root, "flags",
-					json_array_get(flags, 0));
-		json_decref(flags);
-	}
+	json_add_array_new(root, "flags", flags);
 
 	if (!json_object_size(root)) {
 		json_decref(root);
@@ -1686,14 +1642,7 @@ json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	if (stmt->synproxy.flags & NF_SYNPROXY_OPT_SACK_PERM)
 		json_array_append_new(flags, json_string("sack-perm"));
 
-	if (json_array_size(flags) > 1) {
-		json_object_set_new(root, "flags", flags);
-	} else {
-		if (json_array_size(flags))
-			json_object_set(root, "flags",
-					json_array_get(flags, 0));
-		json_decref(flags);
-	}
+	json_add_array_new(root, "flags", flags);
 
 	if (!json_object_size(root)) {
 		json_decref(root);
-- 
2.49.0

