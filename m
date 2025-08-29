Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3132E32143F
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 14:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477524; cv=none; b=tCFu0YmELJ4qZAY2LcDVWTCc+Wu0seMF3OGL5nDFhC4rtO/TUNgt5SrZ8SdAII8sRqgr6eIKJGBF/jkXlCCLU1xenasZT5mNJI7qWdPoy8FHAgDWuXxwDyUJ7LUrsU/Jcu3kI0sh+ninpMOeMqLg1Tr1/M5JHr1bHL/3n7VKt8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477524; c=relaxed/simple;
	bh=PYR+UH8BPdyq0OgXVigpWNyjyS+2a9CJubHfvhck0G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfN86lghfbo2pMluRrjGD7MgJuIvcOcHGwQxdW4NwUL73G2aBq41OjAqg3GqneCYzR/jVSehzJFBz4Zc2gqGlx0NVcG1pxC0bt2wYRV3qBmsCYxjp3KlinlvqfDczJLCc4dH6c0PKZ/QlhVf9p86dqUf/Dh6/mkTLLd+aq2XY40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Njc8YvWg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Njc8YvWg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bb/Un90K/7wwDUoMMwpSR0bkrGBuBAjcHuaEsjf/o6w=; b=Njc8YvWgruHhd88mSq2iRt3Gcx
	sgSvJYI21wXAliHKeTS4E+LYfbM/AyKHGpnUrQg6ZU0qpeWN5f/6cle/BNbLWV8Np2eV3ym66Ux7Q
	klsEPIBQS6thm2CRTGr5zl4KRLFmPlvp2+Lkrig3VkCu3usnTqSxY1LXwmS54GDe9hcmgqahiDoAI
	G7QRtVhLjoYuVTQJPqCgzTIyf+FTd0FOIfBzslQh1vl+GuGX8ZUoV6OpQlOxQ/oQobypStIRxGWtr
	y8wFIhNK//e9r4KmavaL4oI0Gl+pauS2mo6y+pq3pndp+fyhW/bGzB+yd+ohTdtMSLfW8EQY9jYpZ
	YJM8ClDw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us02Y-0000000072u-2pR1;
	Fri, 29 Aug 2025 16:25:18 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/5] monitor: Inform JSON printer when reporting an object delete event
Date: Fri, 29 Aug 2025 16:25:12 +0200
Message-ID: <20250829142513.4608-5-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829142513.4608-1-phil@nwl.cc>
References: <20250829142513.4608-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since kernel commit a1050dd07168 ("netfilter: nf_tables: Reintroduce
shortened deletion notifications"), type-specific data is no longer
dumped when notifying for a deleted object. JSON output was not aware of
this and tried to print bogus data.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/json.h                   |  5 +++--
 src/json.c                       | 18 ++++++++++++------
 src/monitor.c                    |  2 +-
 tests/monitor/testcases/object.t | 10 +++++-----
 4 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/include/json.h b/include/json.h
index 42e1c8616c975..3b8d045f87bbc 100644
--- a/include/json.h
+++ b/include/json.h
@@ -113,7 +113,7 @@ void monitor_print_set_json(struct netlink_mon_handler *monh,
 void monitor_print_element_json(struct netlink_mon_handler *monh,
 				const char *cmd, struct set *s);
 void monitor_print_obj_json(struct netlink_mon_handler *monh,
-			    const char *cmd, struct obj *o);
+			    const char *cmd, struct obj *o, bool delete);
 void monitor_print_flowtable_json(struct netlink_mon_handler *monh,
 				  const char *cmd, struct flowtable *ft);
 void monitor_print_rule_json(struct netlink_mon_handler *monh,
@@ -252,7 +252,8 @@ static inline void monitor_print_element_json(struct netlink_mon_handler *monh,
 }
 
 static inline void monitor_print_obj_json(struct netlink_mon_handler *monh,
-					  const char *cmd, struct obj *o)
+					  const char *cmd, struct obj *o,
+					  bool delete)
 {
 	/* empty */
 }
diff --git a/src/json.c b/src/json.c
index d06fd04027140..0afce5415f541 100644
--- a/src/json.c
+++ b/src/json.c
@@ -397,7 +397,8 @@ static json_t *tunnel_erspan_print_json(const struct obj *obj)
 	return tunnel;
 }
 
-static json_t *obj_print_json(struct output_ctx *octx, const struct obj *obj)
+static json_t *obj_print_json(struct output_ctx *octx, const struct obj *obj,
+			      bool delete)
 {
 	const char *rate_unit = NULL, *burst_unit = NULL;
 	const char *type = obj_type_name(obj->type);
@@ -410,6 +411,9 @@ static json_t *obj_print_json(struct output_ctx *octx, const struct obj *obj)
 			"table", obj->handle.table.name,
 			"handle", obj->handle.handle.id);
 
+	if (delete)
+		goto out;
+
 	if (obj->comment) {
 		tmp = nft_json_pack("{s:s}", "comment", obj->comment);
 		json_object_update(root, tmp);
@@ -570,6 +574,7 @@ static json_t *obj_print_json(struct output_ctx *octx, const struct obj *obj)
 		break;
 	}
 
+out:
 	return nft_json_pack("{s:o}", type, root);
 }
 
@@ -1815,7 +1820,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		json_array_append_new(root, tmp);
 	}
 	list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
-		tmp = obj_print_json(&ctx->nft->output, obj);
+		tmp = obj_print_json(&ctx->nft->output, obj, false);
 		json_array_append_new(root, tmp);
 	}
 	list_for_each_entry(set, &table->set_cache.list, cache.list) {
@@ -1971,7 +1976,7 @@ static json_t *do_list_sets_json(struct netlink_ctx *ctx, struct cmd *cmd)
 static json_t *do_list_obj_json(struct netlink_ctx *ctx,
 				struct cmd *cmd, uint32_t type)
 {
-	json_t *root = json_array();
+	json_t *root = json_array(), *tmp;
 	struct table *table;
 	struct obj *obj;
 
@@ -1990,7 +1995,8 @@ static json_t *do_list_obj_json(struct netlink_ctx *ctx,
 			     strcmp(cmd->handle.obj.name, obj->handle.obj.name)))
 				continue;
 
-			json_array_append_new(root, obj_print_json(&ctx->nft->output, obj));
+			tmp = obj_print_json(&ctx->nft->output, obj, false);
+			json_array_append_new(root, tmp);
 		}
 	}
 
@@ -2207,11 +2213,11 @@ void monitor_print_element_json(struct netlink_mon_handler *monh,
 }
 
 void monitor_print_obj_json(struct netlink_mon_handler *monh,
-			    const char *cmd, struct obj *o)
+			    const char *cmd, struct obj *o, bool delete)
 {
 	struct output_ctx *octx = &monh->ctx->nft->output;
 
-	monitor_print_json(monh, cmd, obj_print_json(octx, o));
+	monitor_print_json(monh, cmd, obj_print_json(octx, o, delete));
 }
 
 void monitor_print_flowtable_json(struct netlink_mon_handler *monh,
diff --git a/src/monitor.c b/src/monitor.c
index e58f62252ca2d..fafeeebe914b8 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -549,7 +549,7 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
-		monitor_print_obj_json(monh, cmd, obj);
+		monitor_print_obj_json(monh, cmd, obj, type == NFT_MSG_DELOBJ);
 		if (!nft_output_echo(&monh->ctx->nft->output))
 			nft_mon_print(monh, "\n");
 		break;
diff --git a/tests/monitor/testcases/object.t b/tests/monitor/testcases/object.t
index 53a9f8c59836b..b60dc9899ab2a 100644
--- a/tests/monitor/testcases/object.t
+++ b/tests/monitor/testcases/object.t
@@ -9,7 +9,7 @@ J {"add": {"counter": {"family": "ip", "name": "c", "table": "t", "handle": 0, "
 
 I delete counter ip t c
 O -
-J {"delete": {"counter": {"family": "ip", "name": "c", "table": "t", "handle": 0, "packets": 0, "bytes": 0}}}
+J {"delete": {"counter": {"family": "ip", "name": "c", "table": "t", "handle": 0}}}
 
 # FIXME: input/output shouldn't be asynchronous here
 I add quota ip t q 25 mbytes
@@ -18,7 +18,7 @@ J {"add": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "by
 
 I delete quota ip t q
 O -
-J {"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0, "bytes": 26214400, "used": 0, "inv": false}}}
+J {"delete": {"quota": {"family": "ip", "name": "q", "table": "t", "handle": 0}}}
 
 # FIXME: input/output shouldn't be asynchronous here
 I add limit ip t l rate 1/second
@@ -27,7 +27,7 @@ J {"add": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "ra
 
 I delete limit ip t l
 O -
-J {"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0, "rate": 1, "per": "second", "burst": 5}}}
+J {"delete": {"limit": {"family": "ip", "name": "l", "table": "t", "handle": 0}}}
 
 I add ct helper ip t cth { type "sip" protocol tcp; l3proto ip; }
 O -
@@ -35,7 +35,7 @@ J {"add": {"ct helper": {"family": "ip", "name": "cth", "table": "t", "handle":
 
 I delete ct helper ip t cth
 O -
-J {"delete": {"ct helper": {"family": "ip", "name": "cth", "table": "t", "handle": 0, "type": "sip", "protocol": "tcp", "l3proto": "ip"}}}
+J {"delete": {"ct helper": {"family": "ip", "name": "cth", "table": "t", "handle": 0}}}
 
 I add ct timeout ip t ctt { protocol udp; l3proto ip; policy = { unreplied : 15s, replied : 12s }; }
 O -
@@ -43,4 +43,4 @@ J {"add": {"ct timeout": {"family": "ip", "name": "ctt", "table": "t", "handle":
 
 I delete ct timeout ip t ctt
 O -
-J {"delete": {"ct timeout": {"family": "ip", "name": "ctt", "table": "t", "handle": 0, "protocol": "udp", "l3proto": "ip", "policy": {"unreplied": 15, "replied": 12}}}}
+J {"delete": {"ct timeout": {"family": "ip", "name": "ctt", "table": "t", "handle": 0}}}
-- 
2.51.0

