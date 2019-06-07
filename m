Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74713C2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 17:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 554B0207E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 17:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbfFGRZg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 13:25:36 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35978 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbfFGRZg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 13:25:36 -0400
Received: from localhost ([::1]:49068 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hZIcQ-0006xg-UW; Fri, 07 Jun 2019 19:25:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/4] tests/py: Add missing arp.t JSON equivalents
Date:   Fri,  7 Jun 2019 19:25:25 +0200
Message-Id: <20190607172527.22177-3-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607172527.22177-1-phil@nwl.cc>
References: <20190607172527.22177-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 4b0f2a712b579 ("src: support for arp sender and target ethernet and IPv4 addresses")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/arp/arp.t.json        | 64 ++++++++++++++++++++++++++++++++++
 tests/py/arp/arp.t.json.output | 14 ++++----
 2 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/tests/py/arp/arp.t.json b/tests/py/arp/arp.t.json
index 4b0439e6edd58..0ea62645bbf6a 100644
--- a/tests/py/arp/arp.t.json
+++ b/tests/py/arp/arp.t.json
@@ -816,6 +816,70 @@
     }
 ]
 
+# arp saddr ip 1.2.3.4
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr ip",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "1.2.3.4"
+        }
+    }
+]
+
+# arp daddr ip 4.3.2.1
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr ip",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "4.3.2.1"
+        }
+    }
+]
+
+# arp saddr ether aa:bb:cc:aa:bb:cc
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr ether",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "aa:bb:cc:aa:bb:cc"
+        }
+    }
+]
+
+# arp daddr ether aa:bb:cc:aa:bb:cc
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr ether",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "aa:bb:cc:aa:bb:cc"
+        }
+    }
+]
+
 # meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566
 [
     {
diff --git a/tests/py/arp/arp.t.json.output b/tests/py/arp/arp.t.json.output
index 4053d94763de5..b8507bffc8cc4 100644
--- a/tests/py/arp/arp.t.json.output
+++ b/tests/py/arp/arp.t.json.output
@@ -129,25 +129,23 @@
         "match": {
             "left": {
                 "payload": {
-                    "base": "nh",
-                    "len": 32,
-                    "offset": 192
+                    "field": "daddr ip",
+                    "protocol": "arp"
                 }
             },
 	    "op": "==",
-            "right": 3232272144
+            "right": "192.168.143.16"
         }
     },
     {
         "mangle": {
             "key": {
                 "payload": {
-                    "base": "nh",
-                    "len": 48,
-                    "offset": 144
+                    "field": "daddr ether",
+                    "protocol": "arp"
                 }
             },
-            "value": 18838586676582
+            "value": "11:22:33:44:55:66"
         }
     }
 ]
-- 
2.21.0

