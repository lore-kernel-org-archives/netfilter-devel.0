Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15DDC4320A
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 03:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83F2B60F22
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 03:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhHKDoS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 23:44:18 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43614 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbhHKDoS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 23:44:18 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id AF2696005D
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 05:43:12 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tcpopt: bogus assertion on undefined options
Date:   Wed, 11 Aug 2021 05:43:45 +0200
Message-Id: <20210811034345.3267-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft add rule x y tcp option 6 exists
 # nft list ruleset
 nft: tcpopt.c:208: tcpopt_init_raw: Assertion `expr->exthdr.desc != NULL' failed.
 Aborted

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1557
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/tcpopt.c                  |  3 ++-
 tests/py/any/tcpopt.t         |  1 +
 tests/py/any/tcpopt.t.json    | 17 +++++++++++++++++
 tests/py/any/tcpopt.t.payload |  5 +++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/src/tcpopt.c b/src/tcpopt.c
index 05b5ee6e3a0b..53fe9bc860a8 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -200,7 +200,8 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int off,
 	else
 		datatype_set(expr, &integer_type);
 
-	if (type >= array_size(tcpopt_protocols))
+	if (type >= array_size(tcpopt_protocols) ||
+	    !tcpopt_protocols[type])
 		return;
 
 	expr->exthdr.desc = tcpopt_protocols[type];
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index f17a20b59492..bcc64eac2e21 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -31,6 +31,7 @@ tcp option timestamp length 1;ok
 tcp option timestamp tsval 1;ok
 tcp option timestamp tsecr 1;ok
 tcp option 255 missing;ok
+tcp option 6 exists;ok
 tcp option @255,8,8 255;ok
 
 tcp option foobar;fail
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index 139e97d8f043..a45b4c8b5c58 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -414,6 +414,23 @@
     }
 ]
 
+# tcp option 6 exists
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "base": 6,
+                    "len": 8,
+                    "offset": 0
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
 # tcp option 255 missing
 [
     {
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 1005df32ab33..51f3a7527668 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -133,6 +133,11 @@ inet
   [ exthdr load tcpopt 1b @ 255 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
+# tcp option 6 exists
+inet
+  [ exthdr load tcpopt 1b @ 6 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
 # tcp option @255,8,8 255
 inet
   [ exthdr load tcpopt 1b @ 255 + 1 => reg 1 ]
-- 
2.20.1

