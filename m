Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC303C48BE5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96BDD613DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 21:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbhFPVUD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 17:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhFPVUB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 17:20:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CC8C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 14:17:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltcv3-0002VA-9y; Wed, 16 Jun 2021 23:17:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     jake.owen@superloop.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 8/8] src: queue: allow use of MAP statement for queue number retrieval
Date:   Wed, 16 Jun 2021 23:16:52 +0200
Message-Id: <20210616211652.11765-9-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616211652.11765-1-fw@strlen.de>
References: <20210616211652.11765-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to chose a queue number at run time using map statements,
e.g.:

queue flags bypass to ip saddr map { 192.168.7/24 : 0, 192.168.0/24 : 1 }

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/statements.txt           |  6 ++++--
 src/parser_bison.y           |  1 +
 tests/py/any/queue.t         |  1 +
 tests/py/any/queue.t.json    | 34 ++++++++++++++++++++++++++++++++++
 tests/py/any/queue.t.payload |  9 +++++++++
 5 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index c2a616594fce..097cf2e07eeb 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -595,11 +595,13 @@ ____
 
 'QUEUE_FLAGS' := 'QUEUE_FLAG' [*,* 'QUEUE_FLAGS']
 'QUEUE_FLAG'  := *bypass* | *fanout*
-'QUEUE_EXPRESSION' := *numgen* | *hash* | *symhash*
+'QUEUE_EXPRESSION' := *numgen* | *hash* | *symhash* | *MAP STATEMENT*
 ____
 
 QUEUE_EXPRESSION can be used to compute a queue number
-at run-time with the hash or numgen expressions.
+at run-time with the hash or numgen expressions. It also
+allows to use the map statement to assign fixed queue numbers
+based on external inputs such as the source ip address or interface names.
 
 .queue statement values
 [options="header"]
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d75960715a90..2615db1ba14b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3787,6 +3787,7 @@ queue_stmt_expr_simple	:	integer_expr
 
 queue_stmt_expr		:	numgen_expr
 			|	hash_expr
+			|	map_expr
 			;
 
 queue_stmt_flags	:	queue_stmt_flag
diff --git a/tests/py/any/queue.t b/tests/py/any/queue.t
index 670dfd92d5b0..446b8b1806f2 100644
--- a/tests/py/any/queue.t
+++ b/tests/py/any/queue.t
@@ -25,3 +25,4 @@ queue flags bypass to numgen inc mod 65536;ok
 queue to jhash oif . meta mark mod 32;ok
 queue to oif;fail
 queue num oif;fail
+queue flags bypass to oifname map { "eth0" : 0, "ppp0" : 2, "eth1" : 2 };ok
diff --git a/tests/py/any/queue.t.json b/tests/py/any/queue.t.json
index 18ed3c817ac9..162bdff875d6 100644
--- a/tests/py/any/queue.t.json
+++ b/tests/py/any/queue.t.json
@@ -140,3 +140,37 @@
     }
 ]
 
+# queue flags bypass to oifname map { "eth0" : 0, "ppp0" : 2, "eth1" : 2 }
+[
+    {
+        "queue": {
+            "flags": "bypass",
+            "num": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "eth0",
+                                0
+                            ],
+                            [
+                                "ppp0",
+                                2
+                            ],
+                            [
+                                "eth1",
+                                2
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "meta": {
+                            "key": "oifname"
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/any/queue.t.payload b/tests/py/any/queue.t.payload
index 35e757ee5cf0..02660afa8d30 100644
--- a/tests/py/any/queue.t.payload
+++ b/tests/py/any/queue.t.payload
@@ -46,3 +46,12 @@ ip
 ip
   [ numgen reg 1 = inc mod 65536 ]
   [ queue sreg_qnum 1 bypass ]
+
+# queue flags bypass to oifname map { "eth0" : 0, "ppp0" : 2, "eth1" : 2 }
+__map%d test-ip4 b size 3
+__map%d test-ip4 0
+	element 30687465 00000000 00000000 00000000  : 00000000 0 [end]	element 30707070 00000000 00000000 00000000  : 00000002 0 [end]	element 31687465 00000000 00000000 00000000  : 00000002 0 [end]
+ip
+  [ meta load oifname => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ queue sreg_qnum 1 bypass ]
-- 
2.31.1

