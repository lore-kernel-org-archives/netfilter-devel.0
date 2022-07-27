Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF51C04A68
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jul 2022 11:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiG0LUq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jul 2022 07:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiG0LUm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jul 2022 07:20:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD1727FF9
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2022 04:20:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oGf5j-0003cl-LB; Wed, 27 Jul 2022 13:20:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 7/7] src: allow anon set concatenation with ether and vlan
Date:   Wed, 27 Jul 2022 13:20:03 +0200
Message-Id: <20220727112003.26022-8-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220727112003.26022-1-fw@strlen.de>
References: <20220727112003.26022-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

vlan id uses integer type (which has a length of 0).

Using it was possible, but listing would assert:
python: mergesort.c:24: concat_expr_msort_value: Assertion `ilen > 0' failed.

There are two reasons for this.
First reason is that the udata/typeof information lacks the 'vlan id'
part, because internally this is 'payload . binop(payload AND mask)'.

binop lacks an udata store.  It makes little sense to store it,
'typeof' keyword expects normal match syntax.

So, when storing udata, store the left hand side of the binary
operation, i.e. the load of the 2-byte key.

With that resolved, delinerization could work, but concat_elem_expr()
would splice 12 bits off the elements value, but it should be 16 (on
a byte boundary).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c                      | 17 +++++++++--
 src/netlink.c                         | 10 +++++--
 tests/py/bridge/vlan.t                |  2 ++
 tests/py/bridge/vlan.t.json           | 41 +++++++++++++++++++++++++++
 tests/py/bridge/vlan.t.payload        | 12 ++++++++
 tests/py/bridge/vlan.t.payload.netdev | 14 +++++++++
 6 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index deb649e1847b..7390089cf57d 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -879,17 +879,30 @@ static void concat_expr_print(const struct expr *expr, struct output_ctx *octx)
 #define NFTNL_UDATA_SET_KEY_CONCAT_SUB_DATA 1
 #define NFTNL_UDATA_SET_KEY_CONCAT_SUB_MAX  2
 
+static struct expr *expr_build_udata_recurse(struct expr *e)
+{
+	switch (e->etype) {
+	case EXPR_BINOP:
+		return e->left;
+	default:
+		break;
+	}
+
+	return e;
+}
+
 static int concat_expr_build_udata(struct nftnl_udata_buf *udbuf,
 				    const struct expr *concat_expr)
 {
 	struct nftnl_udata *nest;
+	struct expr *expr, *tmp;
 	unsigned int i = 0;
-	struct expr *expr;
 
-	list_for_each_entry(expr, &concat_expr->expressions, list) {
+	list_for_each_entry_safe(expr, tmp, &concat_expr->expressions, list) {
 		struct nftnl_udata *nest_expr;
 		int err;
 
+		expr = expr_build_udata_recurse(expr);
 		if (!expr_ops(expr)->build_udata || i >= NFT_REG32_SIZE)
 			return -1;
 
diff --git a/src/netlink.c b/src/netlink.c
index 89d864ed046a..799cf9b8ebef 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1114,17 +1114,21 @@ static struct expr *concat_elem_expr(struct expr *key,
 				     struct expr *data, int *off)
 {
 	const struct datatype *subtype;
+	unsigned int sub_length;
 	struct expr *expr;
 
 	if (key) {
 		(*off)--;
-		expr = constant_expr_splice(data, key->len);
+		sub_length = round_up(key->len, BITS_PER_BYTE);
+
+		expr = constant_expr_splice(data, sub_length);
 		expr->dtype = datatype_get(key->dtype);
 		expr->byteorder = key->byteorder;
 		expr->len = key->len;
 	} else {
 		subtype = concat_subtype_lookup(dtype->type, --(*off));
-		expr = constant_expr_splice(data, subtype->size);
+		sub_length = round_up(subtype->size, BITS_PER_BYTE);
+		expr = constant_expr_splice(data, sub_length);
 		expr->dtype = subtype;
 		expr->byteorder = subtype->byteorder;
 	}
@@ -1136,7 +1140,7 @@ static struct expr *concat_elem_expr(struct expr *key,
 	    expr->dtype->basetype->type == TYPE_BITMASK)
 		expr = bitmask_expr_to_binops(expr);
 
-	data->len -= netlink_padding_len(expr->len);
+	data->len -= netlink_padding_len(sub_length);
 
 	return expr;
 }
diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index 49206017fff2..95bdff4f1b75 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -50,3 +50,5 @@ vlan id 1 vlan id set 2;ok
 
 ether saddr 00:01:02:03:04:05 vlan id 1;ok
 vlan id 2 ether saddr 0:1:2:3:4:6;ok;ether saddr 00:01:02:03:04:06 vlan id 2
+
+ether saddr . vlan id { 0a:0b:0c:0d:0e:0f . 42, 0a:0b:0c:0d:0e:0f . 4095 };ok
diff --git a/tests/py/bridge/vlan.t.json b/tests/py/bridge/vlan.t.json
index 58d4a40f5baf..f77756f5080a 100644
--- a/tests/py/bridge/vlan.t.json
+++ b/tests/py/bridge/vlan.t.json
@@ -817,3 +817,44 @@
         }
     }
 ]
+
+# ether saddr . vlan id { 0a:0b:0c:0d:0e:0f . 42, 0a:0b:0c:0d:0e:0f . 4095 }
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ether"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "id",
+                            "protocol": "vlan"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "0a:0b:0c:0d:0e:0f",
+                            42
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "0a:0b:0c:0d:0e:0f",
+                            4095
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index 713670e9e721..62e4b89bd0b2 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -292,3 +292,15 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000200 ]
+
+# ether saddr . vlan id { 0a:0b:0c:0d:0e:0f . 42, 0a:0b:0c:0d:0e:0f . 4095 }
+__set%d test-bridge 3 size 2
+__set%d test-bridge 0
+	element 0d0c0b0a 00000f0e 00002a00  : 0 [end]	element 0d0c0b0a 00000f0e 0000ff0f  : 0 [end]
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ payload load 2b @ link header + 14 => reg 10 ]
+  [ bitwise reg 10 = ( reg 10 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index 98a2a2b0f379..1018d4c6588f 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -342,3 +342,17 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000100 ]
+
+# ether saddr . vlan id { 0a:0b:0c:0d:0e:0f . 42, 0a:0b:0c:0d:0e:0f . 4095 }
+__set%d test-netdev 3 size 2
+__set%d test-netdev 0
+	element 0d0c0b0a 00000f0e 00002a00  : 0 [end]	element 0d0c0b0a 00000f0e 0000ff0f  : 0 [end]
+netdev test-netdev ingress
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ payload load 2b @ link header + 14 => reg 10 ]
+  [ bitwise reg 10 = ( reg 10 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
-- 
2.35.1

