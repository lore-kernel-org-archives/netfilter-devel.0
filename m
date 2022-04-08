Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF128C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 08:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiDHIfk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiDHIfi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 04:35:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72F272FF537
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 01:33:36 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CBFF8642EE;
        Fri,  8 Apr 2022 10:29:46 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     martin.gignac@gmail.com
Subject: [PATCH nft] tests: py: extend meta time coverage
Date:   Fri,  8 Apr 2022 10:33:32 +0200
Message-Id: <20220408083332.19976-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add meta time tests using < and > operands.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/any/meta.t         |  2 ++
 tests/py/any/meta.t.json    | 36 ++++++++++++++++++++++++++++++++++++
 tests/py/any/meta.t.payload | 14 ++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index fcf4292d63c0..e3beea2eed6c 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -208,6 +208,8 @@ meta time "2019-06-21 17:00:00" drop;ok
 meta time "2019-07-01 00:00:00" drop;ok
 meta time "2019-07-01 00:01:00" drop;ok
 meta time "2019-07-01 00:00:01" drop;ok
+meta time < "2022-07-01 11:00:00" accept;ok
+meta time > "2022-07-01 11:00:00" accept;ok
 meta day "Saturday" drop;ok
 meta day 6 drop;ok;meta day "Saturday" drop
 meta day "Satturday" drop;fail
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index b140aaaa0e1c..5472dc85cfb5 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -2561,6 +2561,42 @@
     }
 ]
 
+# meta time < "2022-07-01 11:00:00" accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "<",
+            "right": "2022-07-01 11:00:00"
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
+# meta time > "2022-07-01 11:00:00" accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": ">",
+            "right": "2022-07-01 11:00:00"
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
 # meta day "Saturday" drop
 [
     {
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index d8351c275e64..1543906273c0 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1003,6 +1003,20 @@ ip meta-test input
   [ cmp eq reg 1 0x22eb8a00 0x15ad18e1 ]
   [ immediate reg 0 drop ]
 
+# meta time < "2022-07-01 11:00:00" accept
+ip test-ip4 input
+  [ meta load time => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
+  [ cmp lt reg 1 0xf3a8fd16 0x00a07719 ]
+  [ immediate reg 0 accept ]
+
+# meta time > "2022-07-01 11:00:00" accept
+ip test-ip4 input
+  [ meta load time => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 8, 8) ]
+  [ cmp gt reg 1 0xf3a8fd16 0x00a07719 ]
+  [ immediate reg 0 accept ]
+
 # meta day "Saturday" drop
 ip test-ip4 input
   [ meta load day => reg 1 ]
-- 
2.30.2

