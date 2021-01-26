Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A7FC4332B
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jan 2021 23:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 285742067B
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jan 2021 23:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbhAZXKi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392287AbhAZR67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 12:58:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A00C06178C
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2021 09:56:28 -0800 (PST)
Received: from localhost ([::1]:44180 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1l4SZn-0004q9-2M; Tue, 26 Jan 2021 18:56:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] json: limit: Always include burst value
Date:   Tue, 26 Jan 2021 18:56:18 +0100
Message-Id: <20210126175618.9953-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The default burst value is non-zero, so JSON output should include it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c                       |  12 +-
 tests/py/any/limit.t.json.output | 277 +++++++++++++++++++++++++++++++
 2 files changed, 282 insertions(+), 7 deletions(-)
 create mode 100644 tests/py/any/limit.t.json.output

diff --git a/src/json.c b/src/json.c
index 585d35326ac01..8371714147de8 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1168,19 +1168,17 @@ json_t *limit_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		burst_unit = get_rate(stmt->limit.burst, &burst);
 	}
 
-	root = json_pack("{s:I, s:s}",
+	root = json_pack("{s:I, s:I, s:s}",
 			 "rate", rate,
+			 "burst", burst,
 			 "per", get_unit(stmt->limit.unit));
 	if (inv)
 		json_object_set_new(root, "inv", json_boolean(inv));
 	if (rate_unit)
 		json_object_set_new(root, "rate_unit", json_string(rate_unit));
-	if (burst && burst != 5) {
-		json_object_set_new(root, "burst", json_integer(burst));
-		if (burst_unit)
-			json_object_set_new(root, "burst_unit",
-					    json_string(burst_unit));
-	}
+	if (burst_unit)
+		json_object_set_new(root, "burst_unit",
+				    json_string(burst_unit));
 
 	return json_pack("{s:o}", "limit", root);
 }
diff --git a/tests/py/any/limit.t.json.output b/tests/py/any/limit.t.json.output
new file mode 100644
index 0000000000000..e6f26496e01cb
--- /dev/null
+++ b/tests/py/any/limit.t.json.output
@@ -0,0 +1,277 @@
+# limit rate 400/minute
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": "minute",
+            "rate": 400
+        }
+    }
+]
+
+# limit rate 20/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": "second",
+            "rate": 20
+        }
+    }
+]
+
+# limit rate 400/hour
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": "hour",
+            "rate": 400
+        }
+    }
+]
+
+# limit rate 40/day
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": "day",
+            "rate": 40
+        }
+    }
+]
+
+# limit rate 400/week
+[
+    {
+        "limit": {
+            "burst": 5,
+            "per": "week",
+            "rate": 400
+        }
+    }
+]
+
+# limit rate 1 kbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1,
+            "rate_unit": "kbytes"
+        }
+    }
+]
+
+# limit rate 2 kbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 2,
+            "rate_unit": "kbytes"
+        }
+    }
+]
+
+# limit rate 1025 kbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1025,
+            "rate_unit": "kbytes"
+        }
+    }
+]
+
+# limit rate 1023 mbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1023,
+            "rate_unit": "mbytes"
+        }
+    }
+]
+
+# limit rate 10230 mbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 10230,
+            "rate_unit": "mbytes"
+        }
+    }
+]
+
+# limit rate 1023000 mbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1023000,
+            "rate_unit": "mbytes"
+        }
+    }
+]
+
+# limit rate over 400/minute
+[
+    {
+        "limit": {
+            "burst": 5,
+            "inv": true,
+            "per": "minute",
+            "rate": 400
+        }
+    }
+]
+
+# limit rate over 20/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "inv": true,
+            "per": "second",
+            "rate": 20
+        }
+    }
+]
+
+# limit rate over 400/hour
+[
+    {
+        "limit": {
+            "burst": 5,
+            "inv": true,
+            "per": "hour",
+            "rate": 400
+        }
+    }
+]
+
+# limit rate over 40/day
+[
+    {
+        "limit": {
+            "burst": 5,
+            "inv": true,
+            "per": "day",
+            "rate": 40
+        }
+    }
+]
+
+# limit rate over 400/week
+[
+    {
+        "limit": {
+            "burst": 5,
+            "inv": true,
+            "per": "week",
+            "rate": 400
+        }
+    }
+]
+
+# limit rate over 1 kbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 1,
+            "rate_unit": "kbytes"
+        }
+    }
+]
+
+# limit rate over 2 kbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 2,
+            "rate_unit": "kbytes"
+        }
+    }
+]
+
+# limit rate over 1025 kbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 1025,
+            "rate_unit": "kbytes"
+        }
+    }
+]
+
+# limit rate over 1023 mbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 1023,
+            "rate_unit": "mbytes"
+        }
+    }
+]
+
+# limit rate over 10230 mbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 10230,
+            "rate_unit": "mbytes"
+        }
+    }
+]
+
+# limit rate over 1023000 mbytes/second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "inv": true,
+            "per": "second",
+            "rate": 1023000,
+            "rate_unit": "mbytes"
+        }
+    }
+]
+
-- 
2.28.0

