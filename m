Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14AB140369
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 18:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709749855; cv=none; b=P3TvtA7lQBW3QY/+FjpS/JEt2fFbBXiUkirq9bBYuZAyxdZkEyQzIKI6xp25q465NIo0pod3YpzrssLMarhPqgqUVoiIpR5fCZ8A9d1kxferVtVF+W+ktR8ExVRWA4pNLLQdxaahuUi2OXZJCFq2SRjn1DfIBECB8oALbTGlR3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709749855; c=relaxed/simple;
	bh=8GsmDVUY1cAnPKyaBJIkiVX+k5Lqn/Wzo4SDroSk6hw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J4ESsuHucRDjAhT05A7BZ8D4dk3vZa3/uIO6ss3xjzBdX95srndLBtbvDg/GtzM1Ye4gqHlV6RyHEthVRlSoIDpEA0Zfs3Lf2rvHxbUYG/KIqvxk8P5tXmUGw6y12PZAd9ksguMc/ysQBkk6GUS8OYnuSS04D1I+0/fcY75wIOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] evaluate: translate meter into dynamic set
Date: Wed,  6 Mar 2024 19:30:39 +0100
Message-Id: <20240306183039.177011-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ See note below ]

129f9d153279 ("nft: migrate man page examples with `meter` directive to
sets") already replaced meters by dynamic sets.

This patch removes NFT_SET_ANONYMOUS flag from the implicit set that is
instantiated via meter, so the listing shows a dynamic set instead which
is the recommended approach these days.

Therefore, a batch like this:

 add table t
 add chain t c
 add rule t c tcp dport 80 meter m size 128 { ip saddr timeout 1s limit rate 10/second }

gets translated to a dynamic set:

 table ip t {
        set m {
                type ipv4_addr
                size 128
                flags dynamic,timeout
        }

        chain c {
                tcp dport 80 update @m { ip saddr timeout 1s limit rate 10/second burst 5 packets }
        }
 }

Check for NFT_SET_ANONYMOUS flag is also relaxed for list and flush
meter commands:

 # nft list meter ip t m
 table ip t {
        set m {
                type ipv4_addr
                size 128
                flags dynamic,timeout
        }
 }
 # nft flush meter ip t m

this also allows to flush the dynamic set that was declared as a meter
to retain backward compatibility.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
tests/shell still shows FAILED, I am looking at the folder that the tool
says but I don't see an explaination of why they fail. I have accordingly
updated dump files for .json-nft and .nft.

 include/rule.h                                |  5 +++
 src/evaluate.c                                | 23 +++++++-----
 src/rule.c                                    |  2 +-
 .../dumps/0022type_selective_flush_0.json-nft | 35 +++++++++++++------
 .../sets/dumps/0022type_selective_flush_0.nft |  8 ++++-
 .../sets/dumps/0038meter_list_0.json-nft      | 35 +++++++++++++------
 .../testcases/sets/dumps/0038meter_list_0.nft |  8 ++++-
 7 files changed, 84 insertions(+), 32 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 6835fe069165..56a9495d46b0 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -409,6 +409,11 @@ static inline bool set_is_meter(uint32_t set_flags)
 	return set_is_anonymous(set_flags) && (set_flags & NFT_SET_EVAL);
 }
 
+static inline bool set_is_meter_compat(uint32_t set_flags)
+{
+	return set_flags & NFT_SET_EVAL;
+}
+
 static inline bool set_is_interval(uint32_t set_flags)
 {
 	return set_flags & NFT_SET_INTERVAL;
diff --git a/src/evaluate.c b/src/evaluate.c
index f8b8530c4b32..bc8ddc040a58 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -116,7 +116,8 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 					     const char *name,
 					     struct expr *key,
 					     struct expr *data,
-					     struct expr *expr)
+					     struct expr *expr,
+					     uint32_t flags)
 {
 	struct cmd *cmd;
 	struct set *set;
@@ -126,13 +127,15 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 		key_fix_dtype_byteorder(key);
 
 	set = set_alloc(&expr->location);
-	set->flags	= NFT_SET_ANONYMOUS | expr->set_flags;
+	set->flags	= expr->set_flags | flags;
 	set->handle.set.name = xstrdup(name);
 	set->key	= key;
 	set->data	= data;
 	set->init	= expr;
 	set->automerge	= set->flags & NFT_SET_INTERVAL;
 
+	handle_merge(&set->handle, &ctx->cmd->handle);
+
 	if (set_evaluate(ctx, set) < 0) {
 		if (set->flags & NFT_SET_MAP)
 			set->init = NULL;
@@ -143,7 +146,6 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	if (ctx->table != NULL)
 		list_add_tail(&set->list, &ctx->table->sets);
 	else {
-		handle_merge(&set->handle, &ctx->cmd->handle);
 		memset(&h, 0, sizeof(h));
 		handle_merge(&h, &set->handle);
 		h.set.location = expr->location;
@@ -2088,7 +2090,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key, data,
-						    mappings);
+						    mappings,
+						    NFT_SET_ANONYMOUS);
 		if (!mappings)
 			return -1;
 
@@ -2661,7 +2664,8 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 			right = rel->right =
 				implicit_set_declaration(ctx, "__set%d",
 							 expr_get(left), NULL,
-							 right);
+							 right,
+							 NFT_SET_ANONYMOUS);
 			if (!right)
 				return -1;
 
@@ -3311,7 +3315,7 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 		set->set_flags |= NFT_SET_TIMEOUT;
 
 	setref = implicit_set_declaration(ctx, stmt->meter.name,
-					  expr_get(key), NULL, set);
+					  expr_get(key), NULL, set, 0);
 	if (!setref)
 		return -1;
 
@@ -4579,7 +4583,8 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 					  ctx->ectx.len, NULL);
 
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
-						    key, NULL, mappings);
+						    key, NULL, mappings,
+						    NFT_SET_ANONYMOUS);
 		if (!mappings)
 			return -1;
 		mappings->set->objtype  = stmt->objref.type;
@@ -5707,7 +5712,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 					     ctx->cmd->handle.set.name);
 		if ((cmd->obj == CMD_OBJ_SET && !set_is_literal(set->flags)) ||
 		    (cmd->obj == CMD_OBJ_MAP && !map_is_literal(set->flags)) ||
-		    (cmd->obj == CMD_OBJ_METER && !set_is_meter(set->flags)))
+		    (cmd->obj == CMD_OBJ_METER && !set_is_meter_compat(set->flags)))
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
@@ -5886,7 +5891,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
-		else if (!set_is_meter(set->flags))
+		else if (!set_is_meter_compat(set->flags))
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
diff --git a/src/rule.c b/src/rule.c
index adab584e9a79..9e418d8c2f2f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1613,7 +1613,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			    !set_is_literal(set->flags))
 				continue;
 			if (cmd->obj == CMD_OBJ_METERS &&
-			    !set_is_meter(set->flags))
+			    !set_is_meter_compat(set->flags))
 				continue;
 			if (cmd->obj == CMD_OBJ_MAPS &&
 			    !map_is_literal(set->flags))
diff --git a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
index c82c12a171a5..c6281ae86c39 100644
--- a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
@@ -33,6 +33,19 @@
         "map": "inet_service"
       }
     },
+    {
+      "set": {
+        "family": "ip",
+        "name": "f",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "size": 1024,
+        "flags": [
+          "dynamic"
+        ]
+      }
+    },
     {
       "chain": {
         "family": "ip",
@@ -61,22 +74,24 @@
             }
           },
           {
-            "meter": {
-              "key": {
+            "set": {
+              "op": "add",
+              "elem": {
                 "payload": {
                   "protocol": "ip",
                   "field": "saddr"
                 }
               },
-              "stmt": {
-                "limit": {
-                  "rate": 10,
-                  "burst": 5,
-                  "per": "second"
+              "set": "@f",
+              "stmt": [
+                {
+                  "limit": {
+                    "rate": 10,
+                    "burst": 5,
+                    "per": "second"
+                  }
                 }
-              },
-              "size": 1024,
-              "name": "f"
+              ]
             }
           }
         ]
diff --git a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
index 0a4cb0a54d73..38987ded39e0 100644
--- a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
+++ b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
@@ -7,7 +7,13 @@ table ip t {
 		type ipv4_addr : inet_service
 	}
 
+	set f {
+		type ipv4_addr
+		size 1024
+		flags dynamic
+	}
+
 	chain c {
-		tcp dport 80 meter f size 1024 { ip saddr limit rate 10/second burst 5 packets }
+		tcp dport 80 add @f { ip saddr limit rate 10/second burst 5 packets }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft b/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
index be24687c96d7..853fb5e35a14 100644
--- a/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
@@ -28,6 +28,19 @@
         ]
       }
     },
+    {
+      "set": {
+        "family": "ip",
+        "name": "m",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "size": 128,
+        "flags": [
+          "dynamic"
+        ]
+      }
+    },
     {
       "chain": {
         "family": "ip",
@@ -56,22 +69,24 @@
             }
           },
           {
-            "meter": {
-              "key": {
+            "set": {
+              "op": "add",
+              "elem": {
                 "payload": {
                   "protocol": "ip",
                   "field": "saddr"
                 }
               },
-              "stmt": {
-                "limit": {
-                  "rate": 10,
-                  "burst": 5,
-                  "per": "second"
+              "set": "@m",
+              "stmt": [
+                {
+                  "limit": {
+                    "rate": 10,
+                    "burst": 5,
+                    "per": "second"
+                  }
                 }
-              },
-              "size": 128,
-              "name": "m"
+              ]
             }
           }
         ]
diff --git a/tests/shell/testcases/sets/dumps/0038meter_list_0.nft b/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
index f274086b5285..8037dfa502b4 100644
--- a/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
+++ b/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
@@ -5,7 +5,13 @@ table ip t {
 		flags dynamic,timeout
 	}
 
+	set m {
+		type ipv4_addr
+		size 128
+		flags dynamic
+	}
+
 	chain c {
-		tcp dport 80 meter m size 128 { ip saddr limit rate 10/second burst 5 packets }
+		tcp dport 80 add @m { ip saddr limit rate 10/second burst 5 packets }
 	}
 }
-- 
2.30.2

