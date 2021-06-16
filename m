Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0358C48BE6
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9C07613DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhFPVT5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhFPVT5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 17:19:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33D4C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 14:17:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltcuz-0002Us-5k; Wed, 16 Jun 2021 23:17:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     jake.owen@superloop.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 7/8] tests: extend queue testcases for new sreg support
Date:   Wed, 16 Jun 2021 23:16:51 +0200
Message-Id: <20210616211652.11765-8-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616211652.11765-1-fw@strlen.de>
References: <20210616211652.11765-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/queue.t         | 10 +++++++
 tests/py/any/queue.t.json    | 56 ++++++++++++++++++++++++++++++++++++
 tests/py/any/queue.t.payload | 16 +++++++++++
 3 files changed, 82 insertions(+)

diff --git a/tests/py/any/queue.t b/tests/py/any/queue.t
index af844aa7c835..670dfd92d5b0 100644
--- a/tests/py/any/queue.t
+++ b/tests/py/any/queue.t
@@ -15,3 +15,13 @@ queue num 1-65535;ok
 queue num 4-5 fanout bypass;ok;queue flags bypass,fanout num 4-5
 queue num 4-5 fanout;ok;queue flags fanout num 4-5
 queue num 4-5 bypass;ok;queue flags bypass num 4-5
+
+queue to symhash mod 2 offset 65536;fail
+queue num symhash mod 65536;fail
+queue to symhash mod 65536;ok
+queue flags fanout to symhash mod 65536;fail
+queue flags bypass,fanout to symhash mod 65536;fail
+queue flags bypass to numgen inc mod 65536;ok
+queue to jhash oif . meta mark mod 32;ok
+queue to oif;fail
+queue num oif;fail
diff --git a/tests/py/any/queue.t.json b/tests/py/any/queue.t.json
index 48e86727a2ff..18ed3c817ac9 100644
--- a/tests/py/any/queue.t.json
+++ b/tests/py/any/queue.t.json
@@ -84,3 +84,59 @@
     }
 ]
 
+# queue to symhash mod 65536
+[
+    {
+        "queue": {
+            "num": {
+                "symhash": {
+                    "mod": 65536
+                }
+            }
+        }
+    }
+]
+
+# queue flags bypass to numgen inc mod 65536
+[
+    {
+        "queue": {
+            "flags": "bypass",
+            "num": {
+                "numgen": {
+                    "mod": 65536,
+                    "mode": "inc",
+                    "offset": 0
+                }
+            }
+        }
+    }
+]
+
+# queue to jhash oif . meta mark mod 32
+[
+    {
+        "queue": {
+            "num": {
+                "jhash": {
+                    "expr": {
+                        "concat": [
+                            {
+                                "meta": {
+                                    "key": "oif"
+                                }
+                            },
+                            {
+                                "meta": {
+                                    "key": "mark"
+                                }
+                            }
+                        ]
+                    },
+                    "mod": 32
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/any/queue.t.payload b/tests/py/any/queue.t.payload
index 78d939c692e9..35e757ee5cf0 100644
--- a/tests/py/any/queue.t.payload
+++ b/tests/py/any/queue.t.payload
@@ -30,3 +30,19 @@ ip test-ip4 output
 ip test-ip4 output
   [ queue num 4-5 bypass ]
 
+# queue to symhash mod 65536
+ip
+  [ hash reg 1 = symhash() % mod 65536 ]
+  [ queue sreg_qnum 1 ]
+
+# queue to jhash oif . meta mark mod 32
+ip
+  [ meta load oif => reg 2 ]
+  [ meta load mark => reg 13 ]
+  [ hash reg 1 = jhash(reg 2, 8, 0x0) % mod 32 ]
+  [ queue sreg_qnum 1 ]
+
+# queue flags bypass to numgen inc mod 65536
+ip
+  [ numgen reg 1 = inc mod 65536 ]
+  [ queue sreg_qnum 1 bypass ]
-- 
2.31.1

