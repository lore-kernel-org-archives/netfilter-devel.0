Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0002C4708F
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 18:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D9261359
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 18:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhFBSu5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 14:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhFBSu4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 14:50:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888A3C06174A
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 11:49:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1loVvU-0001iC-2h; Wed, 02 Jun 2021 20:49:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: py: update netdev reject test file
Date:   Wed,  2 Jun 2021 20:47:34 +0200
Message-Id: <20210602184734.60930-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

netdev/reject.t throws a couple of WARNINGs. For some reason this file
wasn't updated after the reject statement json output was changed to
keep the icmp type/protocol.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/netdev/reject.t.json | 66 +++++++++++------------------------
 1 file changed, 21 insertions(+), 45 deletions(-)

diff --git a/tests/py/netdev/reject.t.json b/tests/py/netdev/reject.t.json
index 21e6ebb5117b..616a2bc1cb64 100644
--- a/tests/py/netdev/reject.t.json
+++ b/tests/py/netdev/reject.t.json
@@ -130,6 +130,17 @@
 
 # mark 12345 reject with tcp reset
 [
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
     {
         "match": {
             "left": {
@@ -151,43 +162,30 @@
 # reject
 [
     {
-        "reject": null
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpx"
+        }
     }
 ]
 
 # meta protocol ip reject
 [
     {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "protocol"
-                }
-            },
-            "op": "==",
-            "right": "ip"
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmp"
         }
-    },
-    {
-        "reject": null
     }
 ]
 
 # meta protocol ip6 reject
 [
     {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "protocol"
-                }
-            },
-            "op": "==",
-            "right": "ip6"
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpv6"
         }
-    },
-    {
-        "reject": null
     }
 ]
 
@@ -233,17 +231,6 @@
 
 # meta protocol ip reject with icmp type host-unreachable
 [
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "protocol"
-                }
-            },
-            "op": "==",
-            "right": "ip"
-        }
-    },
     {
         "reject": {
             "expr": "host-unreachable",
@@ -254,17 +241,6 @@
 
 # meta protocol ip6 reject with icmpv6 type no-route
 [
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "protocol"
-                }
-            },
-            "op": "==",
-            "right": "ip6"
-        }
-    },
     {
         "reject": {
             "expr": "no-route",
-- 
2.31.1

