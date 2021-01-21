Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4F8C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 17:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8720D23A54
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 17:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730613AbhAURBx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 12:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387463AbhAUPtV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 10:49:21 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDE0C061756
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 07:48:40 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l2cCN-0004nx-CG; Thu, 21 Jan 2021 16:48:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: icmp: move expected parts to json.output
Date:   Thu, 21 Jan 2021 16:48:30 +0100
Message-Id: <20210121154830.22530-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter says:
In general, *.t.json files should contain JSON equivalents for rules as
they are *input* into nft. So we want them to be as close to the
introductory standard syntax comment as possible.

Undo earlier change and place the expected dependency added by
nft internals to json.output rather than icmp.t.json.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/icmp.t.json        |  73 +-----------------
 tests/py/ip/icmp.t.json.output | 134 +++++++++++++++++++++++----------
 2 files changed, 98 insertions(+), 109 deletions(-)

diff --git a/tests/py/ip/icmp.t.json b/tests/py/ip/icmp.t.json
index 480740afb525..9691f0727f5e 100644
--- a/tests/py/ip/icmp.t.json
+++ b/tests/py/ip/icmp.t.json
@@ -485,8 +485,8 @@
             "op": "==",
             "right": {
                 "set": [
-                    "prot-unreachable",
-                    "frag-needed",
+                    2,
+                    4,
                     33,
                     54,
                     56
@@ -714,23 +714,6 @@
 
 # icmp id 1245 log
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "echo-reply",
-                    "echo-request"
-                ]
-            }
-        }
-    },
     {
         "match": {
             "left": {
@@ -750,23 +733,6 @@
 
 # icmp id 22
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "echo-reply",
-                    "echo-request"
-                ]
-            }
-        }
-    },
     {
         "match": {
             "left": {
@@ -783,23 +749,6 @@
 
 # icmp id != 233
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "echo-reply",
-                    "echo-request"
-                ]
-            }
-        }
-    },
     {
         "match": {
             "left": {
@@ -892,23 +841,6 @@
 
 # icmp id { 33-55}
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "echo-reply",
-                    "echo-request"
-                ]
-            }
-        }
-    },
     {
         "match": {
             "left": {
@@ -1911,4 +1843,3 @@
         }
     }
 ]
-
diff --git a/tests/py/ip/icmp.t.json.output b/tests/py/ip/icmp.t.json.output
index 2391983ab826..5a075858e8fa 100644
--- a/tests/py/ip/icmp.t.json.output
+++ b/tests/py/ip/icmp.t.json.output
@@ -1,4 +1,28 @@
-# icmp type {echo-reply, destination-unreachable, source-quench, redirect, echo-request, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply, router-advertisement, router-solicitation} accept
+# icmp code { 2, 4, 54, 33, 56}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "code",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "prot-unreachable",
+                    "frag-needed",
+                    33,
+                    54,
+                    56
+                ]
+            }
+        }
+    }
+]
+
+# icmp id 1245 log
 [
     {
         "match": {
@@ -8,104 +32,138 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
                     "echo-reply",
-                    "destination-unreachable",
-                    "source-quench",
-                    "redirect",
-                    "echo-request",
-                    "router-advertisement",
-                    "router-solicitation",
-                    "time-exceeded",
-                    "parameter-problem",
-                    "timestamp-request",
-                    "timestamp-reply",
-                    "info-request",
-                    "info-reply",
-                    "address-mask-request",
-                    "address-mask-reply"
+                    "echo-request"
                 ]
             }
         }
     },
     {
-        "accept": null
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": 1245
+        }
+    },
+    {
+        "log": null
     }
 ]
 
-# icmp code { 2, 4, 54, 33, 56}
+# icmp id 22
 [
     {
         "match": {
             "left": {
                 "payload": {
-                    "field": "code",
+                    "field": "type",
                     "protocol": "icmp"
                 }
             },
             "op": "==",
             "right": {
                 "set": [
-                    "prot-unreachable",
-                    "frag-needed",
-                    33,
-                    54,
-                    56
+                    "echo-reply",
+                    "echo-request"
                 ]
             }
         }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": 22
+        }
     }
 ]
 
-# icmp checksum { 1111, 222, 343} accept
+# icmp id != 233
 [
     {
         "match": {
             "left": {
                 "payload": {
-                    "field": "checksum",
+                    "field": "type",
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    222,
-                    343,
-                    1111
+                    "echo-reply",
+                    "echo-request"
                 ]
             }
         }
     },
     {
-        "accept": null
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "!=",
+            "right": 233
+        }
     }
 ]
 
-# icmp checksum != { 1111, 222, 343} accept
+# icmp id { 33-55}
 [
     {
         "match": {
             "left": {
                 "payload": {
-                    "field": "checksum",
+                    "field": "type",
                     "protocol": "icmp"
                 }
             },
-            "op": "!=",
+            "op": "==",
             "right": {
                 "set": [
-                    222,
-                    343,
-                    1111
+                    "echo-reply",
+                    "echo-request"
                 ]
             }
         }
     },
     {
-        "accept": null
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
+                ]
+            }
+        }
     }
 ]
 
+
-- 
2.26.2

