Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE955C433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 09:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E43C61A30
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 09:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhCYJe4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 05:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhCYJeu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 05:34:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5418C06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Mar 2021 02:34:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lPMO8-00014O-5C; Thu, 25 Mar 2021 10:34:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser: fix scope closure of COUNTER token
Date:   Thu, 25 Mar 2021 10:34:40 +0100
Message-Id: <20210325093440.3610-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is closed after allocation, which is too early: this
stopped 'packets' and 'bytes' from getting parsed correctly.

Also add a test case for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                 |  6 ++---
 tests/py/any/counter.t             | 14 +++++++++++
 tests/py/any/counter.t.json        | 39 ++++++++++++++++++++++++++++++
 tests/py/any/counter.t.json.output | 28 +++++++++++++++++++++
 tests/py/any/counter.t.payload     | 15 ++++++++++++
 5 files changed, 99 insertions(+), 3 deletions(-)
 create mode 100644 tests/py/any/counter.t
 create mode 100644 tests/py/any/counter.t.json
 create mode 100644 tests/py/any/counter.t.json.output
 create mode 100644 tests/py/any/counter.t.payload

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5cb4f8e1be9f..cd0a717de033 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2685,7 +2685,7 @@ stateful_stmt_list	:	stateful_stmt
 			}
 			;
 
-stateful_stmt		:	counter_stmt
+stateful_stmt		:	counter_stmt	close_scope_counter
 			|	limit_stmt
 			|	quota_stmt
 			|	connlimit_stmt
@@ -2785,11 +2785,11 @@ connlimit_stmt		:	CT	COUNT	NUM	close_scope_ct
 counter_stmt		:	counter_stmt_alloc
 			|	counter_stmt_alloc	counter_args
 
-counter_stmt_alloc	:	COUNTER	close_scope_counter
+counter_stmt_alloc	:	COUNTER
 			{
 				$$ = counter_stmt_alloc(&@$);
 			}
-			|	COUNTER		NAME	stmt_expr	close_scope_counter
+			|	COUNTER		NAME	stmt_expr
 			{
 				$$ = objref_stmt_alloc(&@$);
 				$$->objref.type = NFT_OBJECT_COUNTER;
diff --git a/tests/py/any/counter.t b/tests/py/any/counter.t
new file mode 100644
index 000000000000..1c72742c1363
--- /dev/null
+++ b/tests/py/any/counter.t
@@ -0,0 +1,14 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+*arp;test-arp;input
+*bridge;test-bridge;input
+*netdev;test-netdev;ingress
+
+counter;ok
+counter packets 0 bytes 0;ok;counter
+counter packets 2 bytes 1;ok;counter
+counter bytes 1024 packets 1;ok;counter
diff --git a/tests/py/any/counter.t.json b/tests/py/any/counter.t.json
new file mode 100644
index 000000000000..2d1eaa999aab
--- /dev/null
+++ b/tests/py/any/counter.t.json
@@ -0,0 +1,39 @@
+# counter
+[
+    {
+        "counter": {
+            "bytes": 0,
+            "packets": 0
+        }
+    }
+]
+
+# counter packets 0 bytes 0
+[
+    {
+        "counter": {
+            "bytes": 0,
+            "packets": 0
+        }
+    }
+]
+
+# counter packets 2 bytes 1
+[
+    {
+        "counter": {
+            "bytes": 1,
+            "packets": 2
+        }
+    }
+]
+
+# counter bytes 1024 packets 1
+[
+    {
+        "counter": {
+            "bytes": 1024,
+            "packets": 1
+        }
+    }
+]
diff --git a/tests/py/any/counter.t.json.output b/tests/py/any/counter.t.json.output
new file mode 100644
index 000000000000..6a62ffb03d9b
--- /dev/null
+++ b/tests/py/any/counter.t.json.output
@@ -0,0 +1,28 @@
+# counter
+[
+    {
+        "counter": null
+    }
+]
+
+# counter packets 0 bytes 0
+[
+    {
+        "counter": null
+    }
+]
+
+# counter packets 2 bytes 1
+[
+    {
+        "counter": null
+    }
+]
+
+# counter bytes 1024 packets 1
+[
+    {
+        "counter": null
+    }
+]
+
diff --git a/tests/py/any/counter.t.payload b/tests/py/any/counter.t.payload
new file mode 100644
index 000000000000..23e96bae14f3
--- /dev/null
+++ b/tests/py/any/counter.t.payload
@@ -0,0 +1,15 @@
+# counter
+ip
+  [ counter pkts 0 bytes 0 ]
+
+# counter packets 0 bytes 0
+ip
+  [ counter pkts 0 bytes 0 ]
+
+# counter packets 2 bytes 1
+ip
+  [ counter pkts 2 bytes 1 ]
+
+# counter bytes 1024 packets 1
+ip
+  [ counter pkts 1 bytes 1024 ]
-- 
2.26.3

