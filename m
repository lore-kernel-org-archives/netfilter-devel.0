Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11AC4C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 20:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E95C960F6B
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 20:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhG0Uu2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:50:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36292 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhG0Uu1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 16:50:27 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2318E642A7;
        Tue, 27 Jul 2021 22:49:56 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     tom.ty89@gmail.com
Subject: [PATCH nft 1/2] tests: py: idempotent tcp flags & syn != 0 to tcp flag syn
Date:   Tue, 27 Jul 2021 22:50:13 +0200
Message-Id: <20210727205014.17281-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a test to cover this case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/tcp.t         |  1 +
 tests/py/inet/tcp.t.json    | 16 ++++++++++++++++
 tests/py/inet/tcp.t.payload |  8 ++++++++
 3 files changed, 25 insertions(+)

diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 13b84215bd86..5e2830b679a8 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -69,6 +69,7 @@ tcp flags != cwr;ok
 tcp flags == syn;ok
 tcp flags fin,syn / fin,syn;ok
 tcp flags != syn / fin,syn;ok
+tcp flags & syn != 0;ok;tcp flags syn
 tcp flags & (fin | syn | rst | ack) syn;ok;tcp flags syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | ack) != syn;ok;tcp flags != syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index 033a4f22e0fd..6155c81f6150 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1521,6 +1521,22 @@
     }
 ]
 
+# tcp flags & syn != 0
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "flags",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "in",
+            "right": "syn"
+        }
+    }
+]
+
 # tcp flags & (fin | syn | rst | ack) syn
 [
     {
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index eaa7cd099bd6..6b8b4ecdb4ac 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -370,6 +370,14 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000002 ]
 
+# tcp flags & syn != 0
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
 # tcp flags & (fin | syn | rst | ack) syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-- 
2.20.1

