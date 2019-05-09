Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FA1C04AB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1F520989
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfEILft (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 07:35:49 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35026 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfEILft (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 07:35:49 -0400
Received: from localhost ([::1]:48116 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hOhL2-0000bg-6V; Thu, 09 May 2019 13:35:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 9/9] tests/py: Fix JSON expected output for icmpv6 code values
Date:   Thu,  9 May 2019 13:35:45 +0200
Message-Id: <20190509113545.4017-10-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509113545.4017-1-phil@nwl.cc>
References: <20190509113545.4017-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reverse translation is happening for values which are known, even if
they are part of a range. In contrast to standard output, this is OK
because in JSON lower and upper bounds are properties and there is no
ambiguity if names contain a dash.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/ip6/icmpv6.t.json.output | 59 +++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/tests/py/ip6/icmpv6.t.json.output b/tests/py/ip6/icmpv6.t.json.output
index 17032a03d80bd..3a1066211f56b 100644
--- a/tests/py/ip6/icmpv6.t.json.output
+++ b/tests/py/ip6/icmpv6.t.json.output
@@ -109,6 +109,24 @@
     }
 ]
 
+# icmpv6 code 3-66
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "code",
+                    "protocol": "icmpv6"
+                }
+            },
+	    "op": "==",
+            "right": {
+                "range": [ "addr-unreachable", 66 ]
+            }
+        }
+    }
+]
+
 # icmpv6 code {5, 6, 7} accept
 [
     {
@@ -133,3 +151,44 @@
         "accept": null
     }
 ]
+
+# icmpv6 code { 3-66}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "code",
+                    "protocol": "icmpv6"
+                }
+            },
+	    "op": "==",
+            "right": {
+                "set": [
+                    { "range": [ "addr-unreachable", 66 ] }
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 code != { 3-66}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "code",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "!=",
+            "right": {
+                "set": [
+                    { "range": [ "addr-unreachable", 66 ] }
+                ]
+            }
+        }
+    }
+]
+
-- 
2.21.0

