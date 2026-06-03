Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779933176E0
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514973; cv=none; b=l8f88gBoBOoPDnvkrCQbrC8lsu8aH9/sHHKlUKaWtoR3cpApZVhKn2BG5k+q7upLmb7/3F+GAoL3lASC2ITuWZAVkrd9WpD42GdaDp7XEgV3/F5+jsICHKfaqcugpxMO6OqRRmidjcnQCBDkclW9MBQ3NfRzFK90YyuZFQOluTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514973; c=relaxed/simple;
	bh=VmFe/c5Sz8TI+enjZ/xBKQU1bvP2dKL1HPxmFT5LPPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VD4VDwPnIQaXVP/hUdPnvkXHacgm8OOeYBXRRurvxpmqblpnhWNekCTE9bMIDyaGFtAeJKoC95NDZHDMpWHf4zORmcfa1tO1jCLICBJXzMrlcaSDFITTH9UWvkNd9U0LPUO0gClLvZEVcJJ+rcwPac/LMDH66mCpUDOlzOIr1/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WkGNKvxj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WkGNKvxj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KnNkaAvtWYvOS4PhhNxtRAIIJQJ4ekuMEMNwT/yvMEw=; b=WkGNKvxj49Knt6VvCdfYk+2WN+
	q9nHDorlbCyy8jMGwJbgB6TXUrCCfjDGtPQjVDyF55to1Ut8vc3QBqxvev68FVkUiV3L2h0iQgKLy
	nrPSCsJAnsHNmBYzaAGkUYoo3riQsDRg6irlHFYF6kFLCBhnLWcSAZ0OHlYfOehpHq/bVtFg8MEVy
	gFsTNJl8Uj295FyCztTl/pDm7C8Jq+eL9iBYJHIJcU9Nbipj7eTxF0yrSDHgEm9jWVC2APv6HJlA5
	d6TzL8ZRC254jh8ZEtqoJzqEL2JLimC8wMtzgcWRrPeFZWAD4mDPvWqgH53Tb2E6L9wpq8NkGjXyW
	T5fNZ0XQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wUrHM-0000000033g-3jNE;
	Wed, 03 Jun 2026 21:29:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/6] parser_json: Introduce json_parse_tunnel()
Date: Wed,  3 Jun 2026 21:29:19 +0200
Message-ID: <20260603192923.1378815-3-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260603192923.1378815-1-phil@nwl.cc>
References: <20260603192923.1378815-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move 'add tunnel' command argument parsing into its own function to
reduce size of json_parse_cmd_add_object().

While at it, move the misc variable declarations on top of the function.
Older compilers complain about the declaration inside a switch-case.

Fixes: 3a957f8f1ff1e ("tunnel: add tunnel object and statement json support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 144 ++++++++++++++++++++++++----------------------
 1 file changed, 76 insertions(+), 68 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index f04772a022a0b..bff077d27e6d5 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3703,6 +3703,81 @@ static int json_parse_tunnel_src_and_dst(struct json_ctx *ctx,
 	return 0;
 }
 
+static int json_parse_tunnel(struct json_ctx *ctx,
+			     json_t *root, struct obj *obj)
+{
+	struct tunnel_geneve *geneve;
+	json_t *tmp_json;
+	const char *tmp;
+	json_t *value;
+	size_t index;
+	int i, j;
+
+	if (json_parse_tunnel_src_and_dst(ctx, root, obj))
+		return 1;
+
+	json_unpack(root, "{s:i}", "id", &obj->tunnel.id);
+	json_unpack(root, "{s:i}", "sport", &i);
+	obj->tunnel.sport = i;
+	json_unpack(root, "{s:i}", "dport", &i);
+	obj->tunnel.sport = i;
+	json_unpack(root, "{s:i}", "ttl", &i);
+	obj->tunnel.ttl = i;
+	json_unpack(root, "{s:i}", "tos", &i);
+	obj->tunnel.tos = i;
+	json_unpack(root, "{s:s}", "type", &tmp);
+
+	obj->tunnel.type = json_parse_tunnel_type(ctx, tmp);
+	switch (obj->tunnel.type) {
+	case TUNNEL_UNSPEC:
+		break;
+	case TUNNEL_ERSPAN:
+		return json_parse_tunnel_erspan(ctx, root, obj);
+	case TUNNEL_VXLAN:
+		if (json_unpack_err(ctx, root,
+				    "{s:o}", "tunnel", &tmp_json))
+			return 1;
+
+		json_unpack(tmp_json, "{s:i}",
+			    "gbp", &obj->tunnel.vxlan.gbp);
+		break;
+	case TUNNEL_GENEVE:
+		if (json_unpack_err(ctx, root,
+				    "{s:o}", "tunnel", &tmp_json))
+			return 1;
+
+		json_array_foreach(tmp_json, index, value) {
+			geneve = xmalloc(sizeof(struct tunnel_geneve));
+			if (!geneve)
+				memory_allocation_error();
+
+			if (json_unpack_err(ctx, value, "{s:i, s:i, s:s}",
+					    "class", &i,
+					    "opt-type", &j,
+					    "data", &tmp)) {
+				free(geneve);
+				return 1;
+			}
+			geneve->geneve_class = i;
+			geneve->type = j;
+
+			if (tunnel_geneve_data_str2array(tmp,
+							 geneve->data,
+							 &geneve->data_len)) {
+				free(geneve);
+				return 1;
+			}
+
+			if (index == 0)
+				init_list_head(&obj->tunnel.geneve_opts);
+
+			list_add_tail(&geneve->list, &obj->tunnel.geneve_opts);
+		}
+		break;
+	}
+	return 0;
+}
+
 static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 					     json_t *root, enum cmd_ops op,
 					     enum cmd_obj cmd_obj)
@@ -3711,7 +3786,6 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	uint32_t l3proto = NFPROTO_UNSPEC;
 	int inv = 0, flags = 0, i, j;
 	struct handle h = { 0 };
-	json_t *tmp_json;
 	struct obj *obj;
 
 	if (json_unpack_err(ctx, root, "{s:s, s:s}",
@@ -3902,74 +3976,8 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 	case NFT_OBJECT_TUNNEL:
 		cmd_obj = CMD_OBJ_TUNNEL;
 		obj->type = NFT_OBJECT_TUNNEL;
-
-		if (json_parse_tunnel_src_and_dst(ctx, root, obj))
+		if (json_parse_tunnel(ctx, root, obj))
 			goto err_free_obj;
-
-		json_unpack(root, "{s:i}", "id", &obj->tunnel.id);
-		json_unpack(root, "{s:i}", "sport", &i);
-		obj->tunnel.sport = i;
-		json_unpack(root, "{s:i}", "dport", &i);
-		obj->tunnel.sport = i;
-		json_unpack(root, "{s:i}", "ttl", &i);
-		obj->tunnel.ttl = i;
-		json_unpack(root, "{s:i}", "tos", &i);
-		obj->tunnel.tos = i;
-		json_unpack(root, "{s:s}", "type", &tmp);
-
-		obj->tunnel.type = json_parse_tunnel_type(ctx, tmp);
-		switch (obj->tunnel.type) {
-		case TUNNEL_UNSPEC:
-			break;
-		case TUNNEL_ERSPAN:
-			if (json_parse_tunnel_erspan(ctx, root, obj))
-				goto err_free_obj;
-			break;
-		case TUNNEL_VXLAN:
-			if (json_unpack_err(ctx, root,
-					    "{s:o}", "tunnel", &tmp_json))
-				goto err_free_obj;
-
-			json_unpack(tmp_json, "{s:i}",
-				    "gbp", &obj->tunnel.vxlan.gbp);
-			break;
-		case TUNNEL_GENEVE:
-			json_t *value;
-			size_t index;
-
-			if (json_unpack_err(ctx, root,
-					    "{s:o}", "tunnel", &tmp_json))
-				goto err_free_obj;
-
-			json_array_foreach(tmp_json, index, value) {
-				struct tunnel_geneve *geneve = xmalloc(sizeof(struct tunnel_geneve));
-				if (!geneve)
-					memory_allocation_error();
-
-				if (json_unpack_err(ctx, value, "{s:i, s:i, s:s}",
-						    "class", &i,
-						    "opt-type", &j,
-						    "data", &tmp)) {
-					free(geneve);
-					goto err_free_obj;
-				}
-				geneve->geneve_class = i;
-				geneve->type = j;
-
-				if (tunnel_geneve_data_str2array(tmp,
-								 geneve->data,
-								 &geneve->data_len)) {
-					free(geneve);
-					goto err_free_obj;
-				}
-
-				if (index == 0)
-					init_list_head(&obj->tunnel.geneve_opts);
-
-				list_add_tail(&geneve->list, &obj->tunnel.geneve_opts);
-			}
-			break;
-		}
 		break;
 	default:
 		BUG("Invalid CMD '%d'", cmd_obj);
-- 
2.54.0

