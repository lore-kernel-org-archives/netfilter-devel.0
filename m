Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144E0C2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 17:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2EEE207E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 17:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfFGRZl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 13:25:41 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35984 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbfFGRZl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 13:25:41 -0400
Received: from localhost ([::1]:49074 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hZIcW-0006y5-95; Fri, 07 Jun 2019 19:25:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/4] tests/py: Fix JSON equivalents
Date:   Fri,  7 Jun 2019 19:25:24 +0200
Message-Id: <20190607172527.22177-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607172527.22177-1-phil@nwl.cc>
References: <20190607172527.22177-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recent patch removing single element set use missed to adjust JSON
equivalents accordingly.

Fixes: 27f6a4c68b4fd ("tests: replace single element sets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/ct.t.json        |  35 +++++++----
 tests/py/any/ct.t.json.output |  21 ++++++-
 tests/py/any/meta.t.json      | 110 +++++++++++++---------------------
 3 files changed, 86 insertions(+), 80 deletions(-)

diff --git a/tests/py/any/ct.t.json b/tests/py/any/ct.t.json
index 45e48f224957f..7c16f9df2195a 100644
--- a/tests/py/any/ct.t.json
+++ b/tests/py/any/ct.t.json
@@ -883,7 +883,7 @@
     }
 ]
 
-# ct expiration {33-55}
+# ct expiration {33-55, 66-88}
 [
     {
         "match": {
@@ -895,16 +895,15 @@
             "op": "==",
             "right": {
                 "set": [
-                    {
-                        "range": [ 33, 55 ]
-                    }
+                    { "range": [ 33, 55 ] },
+                    { "range": [ 66, 88 ] }
                 ]
             }
         }
     }
 ]
 
-# ct expiration != {33-55}
+# ct expiration != {33-55, 66-88}
 [
     {
         "match": {
@@ -916,9 +915,8 @@
             "op": "!=",
             "right": {
                 "set": [
-                    {
-                        "range": [ 33, 55 ]
-                    }
+                    { "range": [ 33, 55 ] },
+                    { "range": [ 66, 88 ] }
                 ]
             }
         }
@@ -1003,7 +1001,7 @@
     }
 ]
 
-# ct direction . ct mark { original . 0x12345678}
+# ct direction . ct mark { original . 0x12345678, reply . 0x87654321}
 [
     {
         "match": {
@@ -1029,6 +1027,12 @@
                             "original",
                             "0x12345678"
                         ]
+                    },
+                    {
+                        "concat": [
+                            "reply",
+                            "0x87654321"
+                        ]
                     }
                 ]
             }
@@ -1036,7 +1040,7 @@
     }
 ]
 
-# ct state . ct mark vmap { new . 0x12345678 : drop}
+# ct state . ct mark vmap { new . 0x12345678 : drop, established . 0x87654321 : accept}
 [
     {
         "vmap": {
@@ -1066,6 +1070,17 @@
                         {
                             "drop": null
                         }
+                    ],
+                    [
+                        {
+                            "concat": [
+                                "established",
+                                "0x87654321"
+                            ]
+                        },
+                        {
+                            "accept": null
+                        }
                     ]
                 ]
             }
diff --git a/tests/py/any/ct.t.json.output b/tests/py/any/ct.t.json.output
index 49d51771de9c1..aced3817cf49a 100644
--- a/tests/py/any/ct.t.json.output
+++ b/tests/py/any/ct.t.json.output
@@ -549,7 +549,7 @@
     }
 ]
 
-# ct direction . ct mark { original . 0x12345678}
+# ct direction . ct mark { original . 0x12345678, reply . 0x87654321}
 [
     {
         "match": {
@@ -575,6 +575,12 @@
                             "original",
                             305419896
                         ]
+                    },
+                    {
+                        "concat": [
+                            "reply",
+                            2271560481
+                        ]
                     }
                 ]
             }
@@ -582,7 +588,7 @@
     }
 ]
 
-# ct state . ct mark vmap { new . 0x12345678 : drop}
+# ct state . ct mark vmap { new . 0x12345678 : drop, established . 0x87654321 : accept}
 [
     {
         "vmap": {
@@ -602,6 +608,17 @@
             },
             "data": {
                 "set": [
+                    [
+                        {
+                            "concat": [
+                                "established",
+                                2271560481
+                            ]
+                        },
+                        {
+                            "accept": null
+                        }
+                    ],
                     [
                         {
                             "concat": [
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index 2cf91cdae60e8..447e553f8ba78 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -143,7 +143,7 @@
     }
 ]
 
-# meta length { 33-55}
+# meta length { 33-55, 66-88}
 [
     {
         "match": {
@@ -153,14 +153,15 @@
             "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    { "range": [ 33, 55 ] },
+		    { "range": [ 66, 88 ] }
                 ]
             }
         }
     }
 ]
 
-# meta length != { 33-55}
+# meta length != { 33-55, 66-88}
 [
     {
         "match": {
@@ -170,7 +171,8 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    { "range": [ 33, 55 ] },
+		    { "range": [ 66, 88 ] }
                 ]
             }
         }
@@ -339,7 +341,7 @@
     }
 ]
 
-# meta l4proto { 33-55}
+# meta l4proto { 33-55, 66-88}
 [
     {
         "match": {
@@ -349,14 +351,15 @@
             "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    { "range": [ 33, 55 ] },
+                    { "range": [ 66, 88 ] }
                 ]
             }
         }
     }
 ]
 
-# meta l4proto != { 33-55}
+# meta l4proto != { 33-55, 66-88}
 [
     {
         "match": {
@@ -366,7 +369,8 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    { "range": [ 33, 55 ] },
+                    { "range": [ 66, 88 ] }
                 ]
             }
         }
@@ -980,46 +984,6 @@
     }
 ]
 
-# meta oif {"lo"} accept
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "oif" }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "lo"
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
-# meta oif != {"lo"} accept
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "oif" }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    "lo"
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
 # meta oifname "dummy0"
 [
     {
@@ -1316,7 +1280,7 @@
     }
 ]
 
-# meta skuid { 2001-2005} accept
+# meta skuid { 2001-2005, 3001-3005} accept
 [
     {
         "match": {
@@ -1326,7 +1290,8 @@
             "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 2001, 2005 ] }
+                    { "range": [ 2001, 2005 ] },
+                    { "range": [ 3001, 3005 ] }
                 ]
             }
         }
@@ -1336,7 +1301,7 @@
     }
 ]
 
-# meta skuid != { 2001-2005} accept
+# meta skuid != { 2001-2005, 3001-3005} accept
 [
     {
         "match": {
@@ -1346,7 +1311,8 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 2001, 2005 ] }
+                    { "range": [ 2001, 2005 ] },
+                    { "range": [ 3001, 3005 ] }
                 ]
             }
         }
@@ -1988,7 +1954,7 @@
     }
 ]
 
-# meta iifgroup {"default"}
+# meta iifgroup {"default", 11}
 [
     {
         "match": {
@@ -1998,14 +1964,15 @@
             "op": "==",
             "right": {
                 "set": [
-                    "default"
+                    "default",
+		    11
                 ]
             }
         }
     }
 ]
 
-# meta iifgroup != {"default"}
+# meta iifgroup != {"default", 11}
 [
     {
         "match": {
@@ -2015,7 +1982,8 @@
             "op": "!=",
             "right": {
                 "set": [
-                    "default"
+                    "default",
+		    11
                 ]
             }
         }
@@ -2040,7 +2008,7 @@
     }
 ]
 
-# meta iifgroup {11-33}
+# meta iifgroup {11-33, 44-55}
 [
     {
         "match": {
@@ -2050,7 +2018,8 @@
             "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 11, 33 ] }
+                    { "range": [ 11, 33 ] },
+                    { "range": [ 44, 55 ] }
                 ]
             }
         }
@@ -2075,7 +2044,7 @@
     }
 ]
 
-# meta iifgroup != {11-33}
+# meta iifgroup != {11-33, 44-55}
 [
     {
         "match": {
@@ -2085,7 +2054,8 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 11, 33 ] }
+                    { "range": [ 11, 33 ] },
+                    { "range": [ 44, 55 ] }
                 ]
             }
         }
@@ -2144,7 +2114,7 @@
     }
 ]
 
-# meta oifgroup {"default"}
+# meta oifgroup {"default", 11}
 [
     {
         "match": {
@@ -2154,14 +2124,15 @@
             "op": "==",
             "right": {
                 "set": [
-                    "default"
+                    "default",
+		    11
                 ]
             }
         }
     }
 ]
 
-# meta oifgroup != {"default"}
+# meta oifgroup != {"default", 11}
 [
     {
         "match": {
@@ -2171,7 +2142,8 @@
             "op": "!=",
             "right": {
                 "set": [
-                    "default"
+                    "default",
+		    11
                 ]
             }
         }
@@ -2196,7 +2168,7 @@
     }
 ]
 
-# meta oifgroup {11-33}
+# meta oifgroup {11-33, 44-55}
 [
     {
         "match": {
@@ -2206,7 +2178,8 @@
             "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 11, 33 ] }
+                    { "range": [ 11, 33 ] },
+                    { "range": [ 44, 55 ] }
                 ]
             }
         }
@@ -2231,7 +2204,7 @@
     }
 ]
 
-# meta oifgroup != {11-33}
+# meta oifgroup != {11-33, 44-55}
 [
     {
         "match": {
@@ -2241,7 +2214,8 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 11, 33 ] }
+                    { "range": [ 11, 33 ] },
+                    { "range": [ 44, 55 ] }
                 ]
             }
         }
-- 
2.21.0

