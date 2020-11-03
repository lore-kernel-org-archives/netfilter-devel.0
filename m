Return-Path: <SRS0=5/tH=EJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A218C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Nov 2020 18:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99CF20786
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Nov 2020 18:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbgKCSU5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729149AbgKCSU5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Nov 2020 13:20:57 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CCFC0613D1
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2020 10:20:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ka0vP-0001cy-UD; Tue, 03 Nov 2020 19:20:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] tests: avoid warning and add missing json test cases
Date:   Tue,  3 Nov 2020 19:20:39 +0100
Message-Id: <20201103182040.24858-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103182040.24858-1-fw@strlen.de>
References: <20201103182040.24858-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

make dnat.t pass in json mode.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/dnat.t      |  4 +--
 tests/py/inet/dnat.t.json | 55 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/tests/py/inet/dnat.t b/tests/py/inet/dnat.t
index a266100890e3..b460af392557 100644
--- a/tests/py/inet/dnat.t
+++ b/tests/py/inet/dnat.t
@@ -15,7 +15,7 @@ dnat to 1.2.3.4;fail
 dnat ip6 to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};fail
 ip6 daddr dead::beef dnat to 10.1.2.3;fail
 
-meta l4proto { tcp, udp } dnat ip to 1.1.1.1:80;ok
-ip protocol { tcp, udp } dnat ip to 1.1.1.1:80;ok
+meta l4proto { tcp, udp } dnat ip to 1.1.1.1:80;ok;meta l4proto { 6, 17} dnat ip to 1.1.1.1:80
+ip protocol { tcp, udp } dnat ip to 1.1.1.1:80;ok;ip protocol { 6, 17} dnat ip to 1.1.1.1:80
 meta l4proto { tcp, udp } tcp dport 20 dnat to 1.1.1.1:80;fail
 ip protocol { tcp, udp } tcp dport 20 dnat to 1.1.1.1:80;fail
diff --git a/tests/py/inet/dnat.t.json b/tests/py/inet/dnat.t.json
index ac6dac620a85..1b8aba6297d3 100644
--- a/tests/py/inet/dnat.t.json
+++ b/tests/py/inet/dnat.t.json
@@ -164,3 +164,58 @@
     }
 ]
 
+# meta l4proto { tcp, udp } dnat ip to 1.1.1.1:80
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    6,
+                    17
+                ]
+            }
+        }
+    },
+    {
+        "dnat": {
+            "addr": "1.1.1.1",
+            "family": "ip",
+            "port": 80
+        }
+    }
+]
+
+# ip protocol { tcp, udp } dnat ip to 1.1.1.1:80
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    6,
+                    17
+                ]
+            }
+        }
+    },
+    {
+        "dnat": {
+            "addr": "1.1.1.1",
+            "family": "ip",
+            "port": 80
+        }
+    }
+]
+
-- 
2.26.2

