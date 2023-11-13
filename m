Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75193C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 13:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjKMNjQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 08:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjKMNjN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 08:39:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F2501734
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 05:39:09 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft,v2 09/11] tests: shell: split map test
Date:   Mon, 13 Nov 2023 14:38:56 +0100
Message-Id: <20231113133858.121324-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231113133858.121324-1-pablo@netfilter.org>
References: <20231113133858.121324-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Split interval + concatenation into a separated file, so older kernels
with no pipapo can still run what it is supported.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 tests/shell/testcases/maps/0012map_0          | 19 ---------------
 tests/shell/testcases/maps/0012map_concat_0   | 24 +++++++++++++++++++
 .../shell/testcases/maps/dumps/0012map_0.nft  | 13 ----------
 .../testcases/maps/dumps/0012map_concat_0.nft | 14 +++++++++++
 4 files changed, 38 insertions(+), 32 deletions(-)
 create mode 100755 tests/shell/testcases/maps/0012map_concat_0
 create mode 100644 tests/shell/testcases/maps/dumps/0012map_concat_0.nft

diff --git a/tests/shell/testcases/maps/0012map_0 b/tests/shell/testcases/maps/0012map_0
index 49e51b755b0f..dd93c482f441 100755
--- a/tests/shell/testcases/maps/0012map_0
+++ b/tests/shell/testcases/maps/0012map_0
@@ -15,22 +15,3 @@ table ip x {
 }"
 
 $NFT -f - <<< "$EXPECTED"
-
-EXPECTED="table ip x {
-	map w {
-		typeof ip saddr . meta mark : verdict
-		flags interval
-		counter
-		elements = {
-			127.0.0.1-127.0.0.4 . 0x123434-0xb00122 : accept,
-		}
-	}
-
-	chain k {
-		type filter hook input priority filter + 1; policy accept;
-		meta mark set 0x123434
-		ip saddr . meta mark vmap @w
-	}
-}"
-
-$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/maps/0012map_concat_0 b/tests/shell/testcases/maps/0012map_concat_0
new file mode 100755
index 000000000000..d18c7a73c844
--- /dev/null
+++ b/tests/shell/testcases/maps/0012map_concat_0
@@ -0,0 +1,24 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
+set -e
+
+EXPECTED="table ip x {
+        map w {
+                typeof ip saddr . meta mark : verdict
+                flags interval
+                counter
+                elements = {
+                        127.0.0.1-127.0.0.4 . 0x123434-0xb00122 : accept,
+                }
+        }
+
+        chain k {
+                type filter hook input priority filter + 1; policy accept;
+                meta mark set 0x123434
+                ip saddr . meta mark vmap @w
+        }
+}"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/maps/dumps/0012map_0.nft b/tests/shell/testcases/maps/dumps/0012map_0.nft
index 895490cffa8c..e734fc1c70b9 100644
--- a/tests/shell/testcases/maps/dumps/0012map_0.nft
+++ b/tests/shell/testcases/maps/dumps/0012map_0.nft
@@ -6,20 +6,7 @@ table ip x {
 			     "eth1" : drop }
 	}
 
-	map w {
-		typeof ip saddr . meta mark : verdict
-		flags interval
-		counter
-		elements = { 127.0.0.1-127.0.0.4 . 0x00123434-0x00b00122 counter packets 0 bytes 0 : accept }
-	}
-
 	chain y {
 		iifname vmap { "lo" : accept, "eth0" : drop, "eth1" : drop }
 	}
-
-	chain k {
-		type filter hook input priority filter + 1; policy accept;
-		meta mark set 0x00123434
-		ip saddr . meta mark vmap @w
-	}
 }
diff --git a/tests/shell/testcases/maps/dumps/0012map_concat_0.nft b/tests/shell/testcases/maps/dumps/0012map_concat_0.nft
new file mode 100644
index 000000000000..6649d0342a28
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/0012map_concat_0.nft
@@ -0,0 +1,14 @@
+table ip x {
+	map w {
+		typeof ip saddr . meta mark : verdict
+		flags interval
+		counter
+		elements = { 127.0.0.1-127.0.0.4 . 0x00123434-0x00b00122 counter packets 0 bytes 0 : accept }
+	}
+
+	chain k {
+		type filter hook input priority filter + 1; policy accept;
+		meta mark set 0x00123434
+		ip saddr . meta mark vmap @w
+	}
+}
-- 
2.30.2

