Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5223E1E893
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2024 11:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712748738; cv=none; b=hRKSysytwLbUfGQgjConORPq6Hb6YhyXFuLFaknK0EjR3fo5pk8peIgDXy98qdG3dQa/F5H6FYZl/+xBcEut0tNjNjJVHyQ5ImLHgEjaAZs83zrDciGM+BBk0C85lWMvhzVgkq6Cg/u0zdWRcgnnhv7i0xEiZ7V9WdENcjHnQDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712748738; c=relaxed/simple;
	bh=INSUlLhf8lsiXb/LySNcEz7hFazXQvJV/BdN3RU/YoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tn/0K2kFq9Qb7oJwJPZHDYglUuNmgnbfkvUcTui03JyjNF+n2Sfw7RYW9mZyzYAKdqEQvcGe+Ek5sJmKnd8glfklT8IwiHp65F9eMBf//Z3ZBoWLvTPyY7poxCrNMKo/jgLAxe6WUwbFpjFZUT6GksIlpK/ekLAjqUEFjZz6SsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aB8lP7FS; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aB8lP7FS"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2a475bdd4a6so3424199a91.2
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Apr 2024 04:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712748735; x=1713353535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZbJqeXuU7qqJ5+BgAhk+LsvuaZtMId/FHER8Vc6PuiA=;
        b=aB8lP7FSfCQQzf9XPfgzO01+Cr1eDb5tkX3OPNbpGLjQlfP67jYtlitfZ8EuRFhe5W
         UKcpAAXyOv92QOdBJslya6P69EKUAURZo3LYLDZJGNWNOYUg6ge0x17LWDtJzS0Q8O9H
         GkfelohO6XhrH51tnp8Mc1HNRPbS1gCNECCgbTYY+8thRcBfKXnky1Ck89qDj9t61fAD
         +UfrDYaBeo20dwh32kBReBy7c76ELkSHQKG/IGgTCIqo+rJ9LFGqTbMShuf6ItsRIZ7O
         OWZ1kToZwSUdI4JR9/XLJau7hA0z6Q1jw6RVdQYqo+xSadUGxUMy9caGUmmXfXVPK/rY
         G0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712748735; x=1713353535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZbJqeXuU7qqJ5+BgAhk+LsvuaZtMId/FHER8Vc6PuiA=;
        b=U046AsB0IY+lvvrCx+9UP4OEknttDgr7ksMSs4cTECJsZXCA1Jd1aZDhmJ0GcrbIgR
         Cpf+gFh8aIVV49wAcmPEB6+GKepIeb5FIqy7GQf2LclHEDVWT93VkJsJopx3UNf/FImv
         4/PnnBOgdCYL6X/Ucmu610otz5x18R6r6sMsekNwW7ZVX91ymRAd9AcfnFn0HQ20xtWY
         oNFPpQunof8iou3bTjHoyrC9AuiNBCrhtrsWPXaj1NHKcqQ4EgnGlHcUZwIyorps9PoN
         a60qb/BU6E8yc7ye8QAV12UJ73oi0yXDilN7r0+TZaFSzv31xPB0OpeNAoiv0ex0Gfu0
         sqYA==
X-Gm-Message-State: AOJu0YyfqgRL2mL4grIUGMU60q8N2gpB/o8pg7dbGFX6mXXv431AAAmD
	PJDKDL7dlTqir3O8Slu2ebHGV6vYr+s+prHs4WXQsDojPN6NHvMGcGuh6GUGMPQ=
X-Google-Smtp-Source: AGHT+IGJdJ7aqjUXd+ID54oMykWvMEY0pShAmxgAVz+U4rYcd5ddHmD3YQ8DLiw4t8Vj6ZzRli/uzw==
X-Received: by 2002:a17:90a:a8f:b0:2a2:6a2d:994f with SMTP id 15-20020a17090a0a8f00b002a26a2d994fmr2321942pjw.8.1712748734885;
        Wed, 10 Apr 2024 04:32:14 -0700 (PDT)
Received: from localhost.localdomain (122-151-81-38.sta.wbroadband.net.au. [122.151.81.38])
        by smtp.gmail.com with ESMTPSA id cp11-20020a17090afb8b00b002a5b1113be7sm1164320pjb.19.2024.04.10.04.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 04:32:14 -0700 (PDT)
From: Son Dinh <dinhtrason@gmail.com>
To: netfilter-devel@vger.kernel.org,
	fw@netfilter.org
Cc: pablo@netfilter.org,
	Son Dinh <dinhtrason@gmail.com>
Subject: [nft PATCH v2] expr: make map lookup expression as an argument in vmap statement
Date: Wed, 10 Apr 2024 21:31:54 +1000
Message-ID: <20240410113154.4273-1-dinhtrason@gmail.com>
X-Mailer: git-send-email 2.44.0.windows.1
In-Reply-To: <CA+Xkr6jMNpXTuFBJ+yWHsZdezkVkjsLKHH8-6FwAtS1Sxqu6bg@mail.gmail.com>
References: <CA+Xkr6jMNpXTuFBJ+yWHsZdezkVkjsLKHH8-6FwAtS1Sxqu6bg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Support nested map lookups combined with vmap lookup as shown
in the example below. This syntax enables flexibility to use the
values of a map as keys for looking up vmap when users have two
distinct maps for different purposes and do not want to alter any
packet-related objects (e.g., packet mark, ct mark, ip fields)
to store the value returned from the first map lookup for the
final vmap lookup.

Command:
   add rule ip table-a ip saddr map @map1 vmap @map2

Output:

   chain table-a {
           ip saddr map @map1 vmap @map2
   }

It also supports multiple map lookups prior to vmap if users need
to use multiple maps for the same query, such as

   chain table-a {
           ip saddr map @map1 map @map2 vmap @map3
   }

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1736

Signed-off-by: Son Dinh <dinhtrason@gmail.com>
---
 src/evaluate.c                                |   2 +-
 src/netlink_delinearize.c                     |  12 +-
 src/parser_bison.y                            |   8 +
 src/parser_json.c                             |  10 +-
 tests/py/ip/sets.t                            |   5 +
 tests/py/ip/sets.t.json                       |  24 +++
 tests/py/ip/sets.t.payload.inet               |   9 +
 tests/py/ip/sets.t.payload.ip                 |   6 +
 tests/py/ip/sets.t.payload.netdev             |   8 +
 tests/py/ip6/sets.t                           |   6 +
 tests/py/ip6/sets.t.json                      |  24 +++
 tests/py/ip6/sets.t.payload.inet              |   9 +
 tests/py/ip6/sets.t.payload.ip6               |   6 +
 tests/py/ip6/sets.t.payload.netdev            |   8 +
 .../dumps/map_to_vmap_lookups.json-nft        | 192 ++++++++++++++++++
 .../packetpath/dumps/map_to_vmap_lookups.nft  |  25 +++
 .../testcases/packetpath/map_to_vmap_lookups  |  35 ++++
 17 files changed, 381 insertions(+), 8 deletions(-)
 create mode 100644 tests/shell/testcases/packetpath/dumps/map_to_vmap_lookups.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/map_to_vmap_lookups.nft
 create mode 100755 tests/shell/testcases/packetpath/map_to_vmap_lookups

diff --git a/src/evaluate.c b/src/evaluate.c
index 1682ba58..07c26d16 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2052,7 +2052,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &map->map) < 0)
 		return -1;
-	if (expr_is_constant(map->map))
+	if (map->map->etype != EXPR_MAP && expr_is_constant(map->map))
 		return expr_error(ctx->msgs, map->map,
 				  "Map expression can not be constant");
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index da9f7a91..f8968a25 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -428,11 +428,13 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 		return netlink_error(ctx, loc,
 				     "Lookup expression has no left hand side");
 
-	if (left->len < set->key->len) {
-		expr_free(left);
-		left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
-		if (left == NULL)
-			return;
+	if (left->etype != EXPR_MAP) {
+		if (left->len < set->key->len) {
+			expr_free(left);
+			left = netlink_parse_concat_expr(ctx, loc, sreg, set->key->len);
+			if (left == NULL)
+				return;
+		}
 	}
 
 	right = set_ref_expr_alloc(loc, set);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 61bed761..ab2d5a57 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3254,6 +3254,10 @@ verdict_stmt		:	verdict_expr
 			;
 
 verdict_map_stmt	:	concat_expr	VMAP	verdict_map_expr
+			{
+				$$ = map_expr_alloc(&@$, $1, $3);
+			}
+			|	map_expr	VMAP	verdict_map_expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
@@ -4579,6 +4583,10 @@ multiton_rhs_expr	:	prefix_rhs_expr
 			;
 
 map_expr		:	concat_expr	MAP	rhs_expr
+			{
+				$$ = map_expr_alloc(&@$, $1, $3);
+			}
+			|	map_expr MAP rhs_expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
diff --git a/src/parser_json.c b/src/parser_json.c
index efe49494..58492d97 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1417,13 +1417,19 @@ static struct expr *json_parse_map_expr(struct json_ctx *ctx,
 			    "key", &jkey, "data", &jdata))
 		return NULL;
 
-	key = json_parse_map_lhs_expr(ctx, jkey);
+	if (json_typeof(jkey) == JSON_OBJECT)
+		key = json_parse_expr(ctx, jkey);
+	else
+		key = json_parse_map_lhs_expr(ctx, jkey);
 	if (!key) {
 		json_error(ctx, "Illegal map expression key.");
 		return NULL;
 	}
 
-	data = json_parse_rhs_expr(ctx, jdata);
+	if (json_typeof(jdata) == JSON_STRING)
+		data = json_parse_expr(ctx, jdata);
+	else
+		data = json_parse_rhs_expr(ctx, jdata);
 	if (!data) {
 		json_error(ctx, "Illegal map expression data.");
 		expr_free(key);
diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index 46d9686b..3ec1460f 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -66,3 +66,8 @@ ip saddr @set6 drop;ok
 ip saddr vmap { 1.1.1.1 : drop, * : accept };ok
 meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 };ok
 
+# test nested map lookups combined with vmap lookup
+!map2 type ipv4_addr : ipv4_addr;ok
+!map3 type ipv4_addr : inet_service;ok
+!map4 type inet_service : verdict;ok
+ip saddr map @map2 map @map3 vmap @map4;ok
\ No newline at end of file
diff --git a/tests/py/ip/sets.t.json b/tests/py/ip/sets.t.json
index 44ca1528..00d81a11 100644
--- a/tests/py/ip/sets.t.json
+++ b/tests/py/ip/sets.t.json
@@ -303,3 +303,27 @@
     }
 ]
 
+# ip saddr map @map2 map @map3 vmap @map4
+[
+    {
+        "vmap": {
+            "data": "@map4",
+            "key": {
+                "map": {
+                    "data": "@map3",
+                    "key": {
+                        "map": {
+                            "data": "@map2",
+                            "key": {
+                                "payload": {
+                                    "field": "saddr",
+                                    "protocol": "ip"
+                                }
+                            }
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
diff --git a/tests/py/ip/sets.t.payload.inet b/tests/py/ip/sets.t.payload.inet
index fd6517a5..7c498e85 100644
--- a/tests/py/ip/sets.t.payload.inet
+++ b/tests/py/ip/sets.t.payload.inet
@@ -104,3 +104,12 @@ inet
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
+
+# ip saddr map @map2 map @map3 vmap @map4
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set map2 dreg 1 ]
+  [ lookup reg 1 set map3 dreg 1 ]
+  [ lookup reg 1 set map4 dreg 0 ]
diff --git a/tests/py/ip/sets.t.payload.ip b/tests/py/ip/sets.t.payload.ip
index d9cc32b6..8a9cf72c 100644
--- a/tests/py/ip/sets.t.payload.ip
+++ b/tests/py/ip/sets.t.payload.ip
@@ -81,3 +81,9 @@ ip test-ip4 input
   [ meta load mark => reg 10 ]
   [ dynset add reg_key 1 set map1 sreg_data 10 ]
 
+# ip saddr map @map2 map @map3 vmap @map4
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set map2 dreg 1 ]
+  [ lookup reg 1 set map3 dreg 1 ]
+  [ lookup reg 1 set map4 dreg 0 ]
diff --git a/tests/py/ip/sets.t.payload.netdev b/tests/py/ip/sets.t.payload.netdev
index d41b9e8b..295de8d0 100644
--- a/tests/py/ip/sets.t.payload.netdev
+++ b/tests/py/ip/sets.t.payload.netdev
@@ -105,3 +105,11 @@ netdev test-netdev ingress
   [ meta load mark => reg 10 ]
   [ dynset add reg_key 1 set map1 sreg_data 10 ]
 
+# ip saddr map @map2 map @map3 vmap @map4
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set map2 dreg 1 ]
+  [ lookup reg 1 set map3 dreg 1 ]
+  [ lookup reg 1 set map4 dreg 0 ]
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index 17fd62f5..b038594c 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -46,3 +46,9 @@ add @set5 { ip6 saddr . ip6 daddr };ok
 add @map1 { ip6 saddr . ip6 daddr : meta mark };ok
 
 delete @set5 { ip6 saddr . ip6 daddr };ok
+
+# test nested map lookups combined with vmap lookup
+!map2 type ipv6_addr : ipv6_addr;ok
+!map3 type ipv6_addr : inet_service;ok
+!map4 type inet_service : verdict;ok
+ip6 saddr map @map2 map @map3 vmap @map4;ok
\ No newline at end of file
diff --git a/tests/py/ip6/sets.t.json b/tests/py/ip6/sets.t.json
index 2029d2b5..ee4bf74d 100644
--- a/tests/py/ip6/sets.t.json
+++ b/tests/py/ip6/sets.t.json
@@ -148,3 +148,27 @@
     }
 ]
 
+# ip6 saddr map @map2 map @map3 vmap @map4
+[
+    {
+        "vmap": {
+            "data": "@map4",
+            "key": {
+                "map": {
+                    "data": "@map3",
+                    "key": {
+                        "map": {
+                            "data": "@map2",
+                            "key": {
+                                "payload": {
+                                    "field": "saddr",
+                                    "protocol": "ip6"
+                                }
+                            }
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
diff --git a/tests/py/ip6/sets.t.payload.inet b/tests/py/ip6/sets.t.payload.inet
index 2bbd5573..025fc4b0 100644
--- a/tests/py/ip6/sets.t.payload.inet
+++ b/tests/py/ip6/sets.t.payload.inet
@@ -47,3 +47,12 @@ inet test-inet input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset delete reg_key 1 set set5 ]
+
+# ip6 saddr map @map2 map @map3 vmap @map4
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map2 dreg 1 ]
+  [ lookup reg 1 set map3 dreg 1 ]
+  [ lookup reg 1 set map4 dreg 0 ]
diff --git a/tests/py/ip6/sets.t.payload.ip6 b/tests/py/ip6/sets.t.payload.ip6
index c59f7b5c..c1a92c8c 100644
--- a/tests/py/ip6/sets.t.payload.ip6
+++ b/tests/py/ip6/sets.t.payload.ip6
@@ -36,3 +36,9 @@ ip6 test-ip6 input
   [ meta load mark => reg 3 ]
   [ dynset add reg_key 1 set map1 sreg_data 3 ]
 
+# ip6 saddr map @map2 map @map3 vmap @map4
+ip6 test-ip6 input
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map2 dreg 1 ]
+  [ lookup reg 1 set map3 dreg 1 ]
+  [ lookup reg 1 set map4 dreg 0 ]
diff --git a/tests/py/ip6/sets.t.payload.netdev b/tests/py/ip6/sets.t.payload.netdev
index 1866d26b..dd232c40 100644
--- a/tests/py/ip6/sets.t.payload.netdev
+++ b/tests/py/ip6/sets.t.payload.netdev
@@ -48,3 +48,11 @@ netdev test-netdev ingress
   [ meta load mark => reg 3 ]
   [ dynset add reg_key 1 set map1 sreg_data 3 ]
 
+# ip6 saddr map @map2 map @map3 vmap @map4
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map2 dreg 1 ]
+  [ lookup reg 1 set map3 dreg 1 ]
+  [ lookup reg 1 set map4 dreg 0 ]
diff --git a/tests/shell/testcases/packetpath/dumps/map_to_vmap_lookups.json-nft b/tests/shell/testcases/packetpath/dumps/map_to_vmap_lookups.json-nft
new file mode 100644
index 00000000..eb911501
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/map_to_vmap_lookups.json-nft
@@ -0,0 +1,192 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c1",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c2",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "s1",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "ipv4_addr",
+        "elem": [
+          [
+            "127.0.0.1",
+            "10.0.0.1"
+          ],
+          [
+            "127.0.0.2",
+            "10.0.0.2"
+          ]
+        ]
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "s2",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "verdict",
+        "elem": [
+          [
+            "10.0.0.1",
+            {
+              "goto": {
+                "target": "c1"
+              }
+            }
+          ],
+          [
+            "10.0.0.2",
+            {
+              "goto": {
+                "target": "c2"
+              }
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c1",
+        "handle": 0,
+        "expr": [
+          {
+            "counter": {
+              "packets": 1,
+              "bytes": 84
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c2",
+        "handle": 0,
+        "expr": [
+          {
+            "counter": {
+              "packets": 2,
+              "bytes": 168
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "icmp",
+                  "field": "type"
+                }
+              },
+              "right": "echo-request"
+            }
+          },
+          {
+            "vmap": {
+              "key": {
+                "map": {
+                  "key": {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "daddr"
+                    }
+                  },
+                  "data": "@s1"
+                }
+              },
+              "data": "@s2"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "icmp",
+                  "field": "type"
+                }
+              },
+              "right": "echo-request"
+            }
+          },
+          {
+            "counter": {
+              "packets": 0,
+              "bytes": 0
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/packetpath/dumps/map_to_vmap_lookups.nft b/tests/shell/testcases/packetpath/dumps/map_to_vmap_lookups.nft
new file mode 100644
index 00000000..362d9570
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/map_to_vmap_lookups.nft
@@ -0,0 +1,25 @@
+table ip t {
+	map s1 {
+		type ipv4_addr : ipv4_addr
+		elements = { 127.0.0.1 : 10.0.0.1, 127.0.0.2 : 10.0.0.2 }
+	}
+
+	map s2 {
+		type ipv4_addr : verdict
+		elements = { 10.0.0.1 : goto c1, 10.0.0.2 : goto c2 }
+	}
+
+	chain c1 {
+		counter packets 1 bytes 84
+	}
+
+	chain c2 {
+		counter packets 2 bytes 168
+	}
+
+	chain c {
+		type filter hook input priority filter; policy accept;
+		icmp type echo-request ip daddr map @s1 vmap @s2
+		icmp type echo-request counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/packetpath/map_to_vmap_lookups b/tests/shell/testcases/packetpath/map_to_vmap_lookups
new file mode 100755
index 00000000..2264a3e4
--- /dev/null
+++ b/tests/shell/testcases/packetpath/map_to_vmap_lookups
@@ -0,0 +1,35 @@
+#!/bin/bash
+
+set -e
+
+$NFT -f /dev/stdin <<"EOF"
+table ip t {
+	map s1 {
+		type ipv4_addr : ipv4_addr
+		elements = { 127.0.0.1 : 10.0.0.1,  127.0.0.2 : 10.0.0.2 }
+	}
+
+	map s2 {
+		type ipv4_addr : verdict
+		elements = { 10.0.0.1 : goto c1, 10.0.0.2 : goto c2 }
+	}
+
+	chain c1 {
+		counter
+	}
+
+	chain c2 {
+		counter
+	}
+
+	chain c {
+		type filter hook input priority filter;
+		icmp type echo-request ip daddr map @s1 vmap @s2
+		icmp type echo-request counter
+	}
+}
+EOF
+
+ip link set lo up
+ping -q -c 1 127.0.0.1 > /dev/null
+ping -q -c 2 127.0.0.2 > /dev/null
-- 
2.44.0.windows.1

