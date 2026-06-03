Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FAB3822AA
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 19:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514974; cv=none; b=cOHUYStXSSmhLXIjBjl+eQuFH4XXKrM3gwwPTS0xtLsi7PiDA6k3dPnaNZMVudYiT+/NEPG7lBSJo60dcp1jbSAvPp5qvm5rfkWe+pOjMlohHkYFwBRY14EjXVtUaDuQ8RRXv1tgdbwboL9e9wxoeNevfzVcBp/45W0HlVtbs5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514974; c=relaxed/simple;
	bh=qoXbNjkQEmGbB0Eb3VjvqHPWjrxQALVEbYfH+Wy2TwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXMGbJw1Z3gEKf0WT1iCt5tyMpmrNJu6/NWKiz7zp4BaMC5YC+K5fHjKkTN8M75iq0bRtAxjBFZklFdtXvygKcTopIsstWNxePZ/2rWh3Sj0VGcoWL2V9s5LGYLEobZFUxYXJa2T5j2cWe1dW5tAnQ+C7lV4SJKpg5SVnFwRM4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MLrTWcYx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MLrTWcYx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=97jpTPQFXyGMTJC7uoii9BCe00RfZu6NjR+LE1g7fxM=; b=MLrTWcYxIorGqeLMEzxIxWLq26
	bg3xLDXZjpXj8J/FNZuCqls5JhVQrPw0vBbPcry0tzNeaUqmsM9kBg0Etsf4FYsaYa0rXiRLMnBPd
	zd4fs54B3Vw6Lcs1dz0UhgZLYNkfempbUXMs0ZbnY+8IfZwoRcrkhytu7ObstvhLCLE4rmgA4iqzk
	3RMASXeO3wEPJvHdfgr/izSWBU1iLUd5teUgkUHqkoGd9XO/ftavt9Lq1favnHU/YVIZ2A1nYvYzd
	kwps4/txp7NJr32qzwWCjl539lAvREpm4MT3vOdUo6E1xhb72PtarbjdPBvzmQCPcxp806Zornd1c
	4T3yLSKA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wUrHP-0000000034A-1Tk0;
	Wed, 03 Jun 2026 21:29:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/6] json: Introduce tunnel_obj_print_json()
Date: Wed,  3 Jun 2026 21:29:18 +0200
Message-ID: <20260603192923.1378815-2-phil@nwl.cc>
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

Move tunnel object-specific printing into its own function to reduce
indenting and obj_print_json() function size.

While at it, move declaration of 'geneve' variable on top of the
function. Older compilers complain about the declaration inside a
switch-case.

Fixes: 3a957f8f1ff1e ("tunnel: add tunnel object and statement json support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c | 115 +++++++++++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 53 deletions(-)

diff --git a/src/json.c b/src/json.c
index 7312215dede45..a4927c1ae05c9 100644
--- a/src/json.c
+++ b/src/json.c
@@ -400,6 +400,67 @@ static json_t *tunnel_erspan_print_json(const struct obj *obj)
 	return tunnel;
 }
 
+static json_t *tunnel_obj_print_json(struct output_ctx *octx,
+				     const struct obj *obj)
+{
+	struct tunnel_geneve *geneve;
+	json_t *tmp, *opts;
+
+	tmp = json_pack("{s:i, s:o, s:o, s:i, s:i, s:i, s:i}",
+			"id", obj->tunnel.id,
+			obj->tunnel.src->dtype->type == TYPE_IPADDR ? "src-ipv4" : "src-ipv6",
+			expr_print_json(obj->tunnel.src, octx),
+			obj->tunnel.dst->dtype->type == TYPE_IPADDR ? "dst-ipv4" : "dst-ipv6",
+			expr_print_json(obj->tunnel.dst, octx),
+			"sport", obj->tunnel.sport,
+			"dport", obj->tunnel.dport,
+			"tos", obj->tunnel.tos,
+			"ttl", obj->tunnel.ttl);
+
+	switch (obj->tunnel.type) {
+	case TUNNEL_UNSPEC:
+		break;
+	case TUNNEL_ERSPAN:
+		json_object_set_new(tmp, "type", json_string("erspan"));
+		json_object_set_new(tmp, "tunnel",
+				    tunnel_erspan_print_json(obj));
+		break;
+	case TUNNEL_VXLAN:
+		json_object_set_new(tmp, "type", json_string("vxlan"));
+		json_object_set_new(tmp, "tunnel",
+				    json_pack("{s:i}",
+					      "gbp",
+					      obj->tunnel.vxlan.gbp));
+		break;
+	case TUNNEL_GENEVE:
+		opts = json_array();
+
+		list_for_each_entry(geneve, &obj->tunnel.geneve_opts, list) {
+			char data_str[256];
+			json_t *opt;
+			int offset;
+
+			data_str[0] = '0';
+			data_str[1] = 'x';
+			offset = 2;
+			for (uint32_t i = 0; i < geneve->data_len; i++)
+				offset += snprintf(data_str + offset,
+						   3, "%x", geneve->data[i]);
+
+			opt = json_pack("{s:i, s:i, s:s}",
+					"class", geneve->geneve_class,
+					"opt-type", geneve->type,
+					"data", data_str);
+			json_array_append_new(opts, opt);
+		}
+
+		json_object_set_new(tmp, "type", json_string("geneve"));
+		json_object_set_new(tmp, "tunnel", opts);
+		break;
+	}
+	return tmp;
+}
+
 static json_t *obj_print_json(struct output_ctx *octx, const struct obj *obj,
 			      bool delete)
 {
@@ -519,59 +580,7 @@ static json_t *obj_print_json(struct output_ctx *octx, const struct obj *obj,
 		json_decref(tmp);
 		break;
 	case NFT_OBJECT_TUNNEL:
-		tmp = json_pack("{s:i, s:o, s:o, s:i, s:i, s:i, s:i}",
-				"id", obj->tunnel.id,
-				obj->tunnel.src->dtype->type == TYPE_IPADDR ? "src-ipv4" : "src-ipv6",
-				expr_print_json(obj->tunnel.src, octx),
-				obj->tunnel.dst->dtype->type == TYPE_IPADDR ? "dst-ipv4" : "dst-ipv6",
-				expr_print_json(obj->tunnel.dst, octx),
-				"sport", obj->tunnel.sport,
-				"dport", obj->tunnel.dport,
-				"tos", obj->tunnel.tos,
-				"ttl", obj->tunnel.ttl);
-
-		switch (obj->tunnel.type) {
-		case TUNNEL_UNSPEC:
-			break;
-		case TUNNEL_ERSPAN:
-			json_object_set_new(tmp, "type", json_string("erspan"));
-			json_object_set_new(tmp, "tunnel",
-					    tunnel_erspan_print_json(obj));
-			break;
-		case TUNNEL_VXLAN:
-			json_object_set_new(tmp, "type", json_string("vxlan"));
-			json_object_set_new(tmp, "tunnel",
-					    json_pack("{s:i}",
-						      "gbp",
-						      obj->tunnel.vxlan.gbp));
-			break;
-		case TUNNEL_GENEVE:
-			struct tunnel_geneve *geneve;
-			json_t *opts = json_array();
-
-			list_for_each_entry(geneve, &obj->tunnel.geneve_opts, list) {
-				char data_str[256];
-				json_t *opt;
-				int offset;
-
-				data_str[0] = '0';
-				data_str[1] = 'x';
-				offset = 2;
-				for (uint32_t i = 0; i < geneve->data_len; i++)
-					offset += snprintf(data_str + offset,
-							   3, "%x", geneve->data[i]);
-
-				opt = json_pack("{s:i, s:i, s:s}",
-						"class", geneve->geneve_class,
-						"opt-type", geneve->type,
-						"data", data_str);
-				json_array_append_new(opts, opt);
-			}
-
-			json_object_set_new(tmp, "type", json_string("geneve"));
-			json_object_set_new(tmp, "tunnel", opts);
-			break;
-		}
+		tmp = tunnel_obj_print_json(octx, obj);
 		json_object_update(root, tmp);
 		json_decref(tmp);
 		break;
-- 
2.54.0

