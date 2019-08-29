Return-Path: <SRS0=245l=WZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87670C3A59F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 09:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63B3C233A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 09:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfH2JoE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 05:44:04 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:49354 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726038AbfH2JoE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 05:44:04 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1i3GyH-0002NZ-Rp; Thu, 29 Aug 2019 11:44:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: json: add support for element deletion
Date:   Thu, 29 Aug 2019 11:36:20 +0200
Message-Id: <20190829093620.3594-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

also add a test case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c                  |  2 ++
 tests/py/ip6/sets.t                |  1 +
 tests/py/ip6/sets.t.json           | 25 +++++++++++++++++++++++++
 tests/py/ip6/sets.t.payload.inet   |  7 +++++++
 tests/py/ip6/sets.t.payload.ip6    |  6 ++++++
 tests/py/ip6/sets.t.payload.netdev |  8 ++++++++
 6 files changed, 49 insertions(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index a969bd4c3676..8ca07d717b13 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2055,6 +2055,8 @@ static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
 		op = NFT_DYNSET_OP_ADD;
 	} else if (!strcmp(opstr, "update")) {
 		op = NFT_DYNSET_OP_UPDATE;
+	} else if (!strcmp(opstr, "delete")) {
+		op = NFT_DYNSET_OP_DELETE;
 	} else {
 		json_error(ctx, "Unknown set statement op '%s'.", opstr);
 		return NULL;
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index 5adec53f56ce..add82eb8feb8 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -40,3 +40,4 @@ ip6 saddr != @set33 drop;fail
 !set5 type ipv6_addr . ipv6_addr;ok
 ip6 saddr . ip6 daddr @set5 drop;ok
 add @set5 { ip6 saddr . ip6 daddr };ok
+delete @set5 { ip6 saddr . ip6 daddr };ok
diff --git a/tests/py/ip6/sets.t.json b/tests/py/ip6/sets.t.json
index 9a75dd6fa210..948c1f168d0f 100644
--- a/tests/py/ip6/sets.t.json
+++ b/tests/py/ip6/sets.t.json
@@ -91,3 +91,28 @@
     }
 ]
 
+# delete @set5 { ip6 saddr . ip6 daddr }
+[
+    {
+        "set": {
+            "elem": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip6"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip6"
+                        }
+                    }
+                ]
+            },
+            "op": "delete",
+            "set": "@set5"
+        }
+    }
+]
diff --git a/tests/py/ip6/sets.t.payload.inet b/tests/py/ip6/sets.t.payload.inet
index 3886db67526c..47ad86a20864 100644
--- a/tests/py/ip6/sets.t.payload.inet
+++ b/tests/py/ip6/sets.t.payload.inet
@@ -31,3 +31,10 @@ inet test-inet input
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset add reg_key 1 set set5 ]
 
+# delete @set5 { ip6 saddr . ip6 daddr }
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ payload load 16b @ network header + 24 => reg 2 ]
+  [ dynset delete reg_key 1 set set5 ]
diff --git a/tests/py/ip6/sets.t.payload.ip6 b/tests/py/ip6/sets.t.payload.ip6
index 0b318f8de97f..a5febb9fe591 100644
--- a/tests/py/ip6/sets.t.payload.ip6
+++ b/tests/py/ip6/sets.t.payload.ip6
@@ -23,3 +23,9 @@ ip6 test-ip6 input
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset add reg_key 1 set set5 ]
 
+# delete @set5 { ip6 saddr . ip6 daddr }
+ip6 test-ip6 input
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ payload load 16b @ network header + 24 => reg 2 ]
+  [ dynset delete reg_key 1 set set5 ]
+
diff --git a/tests/py/ip6/sets.t.payload.netdev b/tests/py/ip6/sets.t.payload.netdev
index 0dfabb778a0c..dab74159a098 100644
--- a/tests/py/ip6/sets.t.payload.netdev
+++ b/tests/py/ip6/sets.t.payload.netdev
@@ -31,3 +31,11 @@ netdev test-netdev ingress
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset add reg_key 1 set set5 ]
 
+# delete @set5 { ip6 saddr . ip6 daddr }
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ payload load 16b @ network header + 24 => reg 2 ]
+  [ dynset delete reg_key 1 set set5 ]
+
-- 
2.21.0

