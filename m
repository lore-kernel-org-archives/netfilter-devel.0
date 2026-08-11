Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B953B4499A4
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786455786; cv=none; b=SgGJN0vSQmo53iQbDllCqww43kDkv2VdldxSLMnkptIv390xba/GxsuGVOae7Ft6fbAvu9x8uAu1V/1njvM3YOXqmroGGX0y9yzMZJui/YlNIykiQtSoz+PlYh6m3XL/jJs6XWsZlbSy2E6JGF83a3Ma/y6YgY9oRHQmcNv+Y7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786455786; c=relaxed/simple;
	bh=llPx3cypXX7ah/dLtPveDgfYxJJ+3zoRvKL7d6BCynY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLa185tmy0r0ULvkwAnGrWif9ooB3R5h6ExImew68jDCCcYtvephYPbTCRaOLYqPYlkCDtzP4qgQlgrkOT/duem21mcK7BsWDVmimd/QAH5uyBcI7UIz/+oz+Uu1pTQeb/8SjW2EWPt3lBJWtDWexpnKJJPEwrH+9qdrLNe3mgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=boLneXeo; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="boLneXeo"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47f703a9e5dso426725f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 06:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786455773; x=1787060573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cNlm5JWf5Gei4gF1YndDyWw03fbPwXMOf3tbs8aGpQs=;
        b=boLneXeoAXNq0jkhWLs5RWmPae+UtRXxvJT4yZTDgedCbyaiSI3JQf3jfNCtgymk3x
         rY+rtldl8NcXT/2MTVDkOqwc3ilQ+IY55nOd5+zQvAvIznAY99EMimJGWYIa5QzUgvCA
         vBEAjTVMLtLVi+/GM935H9vp8vL4FOexLU9oIg2C0PxS53z2z2NnQQn7fXX7dflM5soR
         GuCQI/WkNWaEU3kaTUP2gKaYDUwV1/WwBgbXF1iwpBwWjvKTvb80XZ1S880XQfSuuszA
         w3v3iwQtEyXGJodn/orPaxRbSnhVBhLTxHc1BIYFLXARw7fx13MgqEi8Xjpg3oiESOsj
         IVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786455773; x=1787060573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cNlm5JWf5Gei4gF1YndDyWw03fbPwXMOf3tbs8aGpQs=;
        b=sZdyAe+AIoWSWRimrzWi4wVTKokAizoJFbsFGkt5XItDbwpnAMY2H4E7kFYyL5Azef
         FmvnPp/npYq1Z0LfvV5Jt2z/Ot/a7BoJ+GHh3yk53gjoVxcUDkTIQgPYhKK1Uluy++JO
         inwxqflHbzFpe+Er60lBjf/fOQFJSFVYl3BpGQoTGmAKBSsLW5zqteBTmggBb6UZUBHH
         N3glWKs3wuB8VAaorvCJ0+ppPh/f9IRDoraMCKrckimT9nqoslGUJeKetdJTOLA+Xq8Y
         59wIXAZfIcdrSorJqsem4ABulcKuby4QOpzJYYOvUpdyDU9R7XoPYbgTg4ixziiOl8s/
         Np3g==
X-Gm-Message-State: AOJu0YzfPT/nXpFZ6LpgI95IA/8+tVomHvSbBVJQvUi9lE9PBoY0fuZD
	I57aD/VhQLBn0MQLT6Xz97Xf/7Ac2aIjwFjzG2YB10Gl7UNcOud4cVQxTg7vruqk
X-Gm-Gg: AR+sD135b03BpCR3mYRnFtNpj/wFL5RL9X7Ib0lzQYZXpgIT+S/LbCckD/qITuhrgY4
	fWOSwpvOIWMwKEqkmIBhmAU60H48GQUuvczJx470TGgQoebawI4kDlcginXv16LTOicQLgZ2cx0
	X6H/UwQBN7sHThaYPHGQRMBPw0JB3D6FabR+0QqrLv3b8QbU7Kh1Zd0ldJiY76UeicVOUDxvmyA
	yREuoIER5Lr11kU7V81gZO7p8CbKWa73Kh8zfE8Af2XowFgHxmXn/Hhp4XAwAVcdK/mXTc77fk9
	RAWrVAs4g9ERQc+CGi23KCfB1ZOaBA7jpZVumD1paZZM8DzdTh698s8xKvJtS0GnEUN5tjbFwv/
	xYsnP9pm+KxG2z+kadDXkJAcQZmadb05bSVEUow/hrvRMLk1cNzKyIUj2OvmbkKUyAjwEUgiZy3
	lb2Fc19N95oM7fnMY8ZPzSH/j/DOqEZ1GHVvEeOXVjdQzIPblzlUIm0jT/lIXvtBGKePiqz0CoE
	8EkFxk49X6YCQ==
X-Received: by 2002:a05:600c:4f88:b0:499:726a:117c with SMTP id 5b1f17b1804b1-4997a62dc6emr2549885e9.19.1786455773361;
        Tue, 11 Aug 2026 06:42:53 -0700 (PDT)
Received: from DINA5CG53728ZV.evosoft.com ([136.226.199.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49974146933sm80558755e9.10.2026.08.11.06.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 06:42:52 -0700 (PDT)
From: Gergely Palotas <palotasgergely@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Gergely Palotas <palotasgergely@gmail.com>
Subject: [nft PATCH 1/2] parser_json: fix CMD_OBJ/NFT_OBJECT mismatch in delete path
Date: Tue, 11 Aug 2026 15:43:25 +0200
Message-ID: <20260811134326.300827-2-palotasgergely@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811134326.300827-1-palotasgergely@gmail.com>
References: <20260811134326.300827-1-palotasgergely@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dispatch tables in json_parse_cmd_add() and json_parse_cmd_list()
pass NFT_OBJECT_CT_TIMEOUT, NFT_OBJECT_CT_EXPECT and NFT_OBJECT_TUNNEL
(kernel constants from <linux/netfilter/nf_tables.h>) as the cmd_obj
argument to json_parse_cmd_add_object(), which declares its parameter
as enum cmd_obj.

On the delete/list/destroy early-return path, cmd_obj is forwarded
directly to cmd_alloc(), which expects enum cmd_obj values. For ct
timeout, NFT_OBJECT_CT_TIMEOUT=7 aliases to CMD_OBJ_CHAIN=7, so a
JSON delete of a ct timeout is sent to the kernel as a delete chain
netlink message, returning EINVAL. The same mismatch affects ct
expectation and tunnel objects.

The add path was unaffected because the switch/case blocks inside the
function also used NFT_OBJECT_* constants and contained explicit
cmd_obj = CMD_OBJ_* assignments before falling through to cmd_alloc().
Those assignments are never reached on the delete path due to the
early return.

Fix this by using CMD_OBJ_* constants consistently in the dispatch
tables, matching the declared type of the parameter. Update the
switch cases and the CT_HELPER identity checks in the function
prologue to use CMD_OBJ_* as well, and drop the now-unnecessary
cmd_obj reassignments inside each case.

Signed-off-by: Gergely Palotas <palotasgergely@gmail.com>
---
 src/parser_json.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index e0144b9b..6f40f8d8 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3792,11 +3792,11 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			    "table", &h.table.name))
 		return NULL;
 	if ((op != CMD_DELETE ||
-	     cmd_obj == NFT_OBJECT_CT_HELPER) &&
+	     cmd_obj == CMD_OBJ_CT_HELPER) &&
 	    json_unpack_err(ctx, root, "{s:s}", "name", &h.obj.name)) {
 		return NULL;
 	} else if ((op == CMD_DELETE || op == CMD_DESTROY) &&
-		   cmd_obj != NFT_OBJECT_CT_HELPER &&
+		   cmd_obj != CMD_OBJ_CT_HELPER &&
 		   json_unpack(root, "{s:s}", "name", &h.obj.name) &&
 		   json_unpack(root, "{s:I}", "handle", &h.handle.id)) {
 		json_error(ctx, "Either name or handle required to delete an object.");
@@ -3812,7 +3812,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		h.obj.name = xstrdup(h.obj.name);
 
 	if (op == CMD_DELETE || op == CMD_LIST || op == CMD_DESTROY) {
-		if (cmd_obj == NFT_OBJECT_CT_HELPER)
+		if (cmd_obj == CMD_OBJ_CT_HELPER)
 			return cmd_alloc_obj_ct(op, NFT_OBJECT_CT_HELPER,
 						&h, int_loc, obj_alloc(int_loc));
 		return cmd_alloc(op, cmd_obj, &h, int_loc, NULL);
@@ -3849,8 +3849,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			}
 		}
 		break;
-	case NFT_OBJECT_CT_HELPER:
-		cmd_obj = CMD_OBJ_CT_HELPER;
+	case CMD_OBJ_CT_HELPER:
 		obj->type = NFT_OBJECT_CT_HELPER;
 		if (!json_unpack(root, "{s:s}", "type", &tmp)) {
 			int ret;
@@ -3881,8 +3880,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		}
 		obj->ct_helper.l3proto = l3proto;
 		break;
-	case NFT_OBJECT_CT_TIMEOUT:
-		cmd_obj = CMD_OBJ_CT_TIMEOUT;
+	case CMD_OBJ_CT_TIMEOUT:
 		init_list_head(&obj->ct_timeout.timeout_list);
 		obj->type = NFT_OBJECT_CT_TIMEOUT;
 		if (!json_unpack(root, "{s:s}", "protocol", &tmp)) {
@@ -3905,8 +3903,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		if (json_parse_ct_timeout_policy(ctx, root, obj))
 			goto err_free_obj;
 		break;
-	case NFT_OBJECT_CT_EXPECT:
-		cmd_obj = CMD_OBJ_CT_EXPECT;
+	case CMD_OBJ_CT_EXPECT:
 		obj->type = NFT_OBJECT_CT_EXPECT;
 		if (!json_unpack(root, "{s:s}", "l3proto", &tmp) &&
 		    parse_family(tmp, &l3proto)) {
@@ -3972,8 +3969,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 
 		obj->synproxy.flags |= flags;
 		break;
-	case NFT_OBJECT_TUNNEL:
-		cmd_obj = CMD_OBJ_TUNNEL;
+	case CMD_OBJ_TUNNEL:
 		obj->type = NFT_OBJECT_TUNNEL;
 		if (json_parse_tunnel(ctx, root, obj))
 			goto err_free_obj;
@@ -4011,10 +4007,10 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 		{ "flowtable", CMD_OBJ_FLOWTABLE, json_parse_cmd_add_flowtable },
 		{ "counter", CMD_OBJ_COUNTER, json_parse_cmd_add_object },
 		{ "quota", CMD_OBJ_QUOTA, json_parse_cmd_add_object },
-		{ "ct helper", NFT_OBJECT_CT_HELPER, json_parse_cmd_add_object },
-		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
-		{ "ct expectation", NFT_OBJECT_CT_EXPECT, json_parse_cmd_add_object },
-		{ "tunnel", NFT_OBJECT_TUNNEL, json_parse_cmd_add_object },
+		{ "ct helper", CMD_OBJ_CT_HELPER, json_parse_cmd_add_object },
+		{ "ct timeout", CMD_OBJ_CT_TIMEOUT, json_parse_cmd_add_object },
+		{ "ct expectation", CMD_OBJ_CT_EXPECT, json_parse_cmd_add_object },
+		{ "tunnel", CMD_OBJ_TUNNEL, json_parse_cmd_add_object },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "secmark", CMD_OBJ_SECMARK, json_parse_cmd_add_object },
 		{ "synproxy", CMD_OBJ_SYNPROXY, json_parse_cmd_add_object }
@@ -4186,11 +4182,11 @@ static struct cmd *json_parse_cmd_list(struct json_ctx *ctx,
 		{ "counters", CMD_OBJ_COUNTERS, json_parse_cmd_list_multiple },
 		{ "quota", CMD_OBJ_QUOTA, json_parse_cmd_add_object },
 		{ "quotas", CMD_OBJ_QUOTAS, json_parse_cmd_list_multiple },
-		{ "ct helper", NFT_OBJECT_CT_HELPER, json_parse_cmd_add_object },
+		{ "ct helper", CMD_OBJ_CT_HELPER, json_parse_cmd_add_object },
 		{ "ct helpers", CMD_OBJ_CT_HELPERS, json_parse_cmd_list_multiple },
-		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
-		{ "ct expectation", NFT_OBJECT_CT_EXPECT, json_parse_cmd_add_object },
-		{ "tunnel", NFT_OBJECT_TUNNEL, json_parse_cmd_add_object },
+		{ "ct timeout", CMD_OBJ_CT_TIMEOUT, json_parse_cmd_add_object },
+		{ "ct expectation", CMD_OBJ_CT_EXPECT, json_parse_cmd_add_object },
+		{ "tunnel", CMD_OBJ_TUNNEL, json_parse_cmd_add_object },
 		{ "tunnels", CMD_OBJ_TUNNELS, json_parse_cmd_list_multiple },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "limits", CMD_OBJ_LIMIT, json_parse_cmd_list_multiple },
-- 
2.47.3

