Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16C7C61D9D
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 10:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjKVKcd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 05:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjKVKca (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 05:32:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3A9DBC
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 02:32:26 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/8] tests: shell: detach synproxy test
Date:   Wed, 22 Nov 2023 11:32:16 +0100
Message-Id: <20231122103221.90160-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231122103221.90160-1-pablo@netfilter.org>
References: <20231122103221.90160-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Old kernels do not support synproxy, split existing tests with stateful objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../shell/testcases/sets/0024named_objects_0  | 15 ----------
 tests/shell/testcases/sets/0024synproxy_0     | 29 +++++++++++++++++++
 .../sets/dumps/0024named_objects_0.nft        | 18 ------------
 .../testcases/sets/dumps/0024synproxy_0.nft   | 23 +++++++++++++++
 4 files changed, 52 insertions(+), 33 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0024synproxy_0
 create mode 100644 tests/shell/testcases/sets/dumps/0024synproxy_0.nft

diff --git a/tests/shell/testcases/sets/0024named_objects_0 b/tests/shell/testcases/sets/0024named_objects_0
index 6d21e3884da9..21200c3cca3c 100755
--- a/tests/shell/testcases/sets/0024named_objects_0
+++ b/tests/shell/testcases/sets/0024named_objects_0
@@ -18,15 +18,6 @@ table inet x {
 	quota user124 {
 		over 2000 bytes
 	}
-	synproxy https-synproxy {
-		mss 1460
-		wscale 7
-		timestamp sack-perm
-	}
-	synproxy other-synproxy {
-		mss 1460
-		wscale 5
-	}
 	set y {
 		type ipv4_addr
 	}
@@ -34,15 +25,9 @@ table inet x {
 		type ipv4_addr : quota
 		elements = { 192.168.2.2 : "user124", 192.168.2.3 : "user124"}
 	}
-	map test2 {
-		type ipv4_addr : synproxy
-		flags interval
-		elements = { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
-	}
 	chain y {
 		type filter hook input priority 0; policy accept;
 		counter name ip saddr map { 192.168.2.2 : "user123", 1.1.1.1 : "user123", 2.2.2.2 : "user123"}
-		synproxy name ip saddr map { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
 		quota name ip saddr map @test drop
 	}
 }"
diff --git a/tests/shell/testcases/sets/0024synproxy_0 b/tests/shell/testcases/sets/0024synproxy_0
new file mode 100755
index 000000000000..ccaed0325d44
--- /dev/null
+++ b/tests/shell/testcases/sets/0024synproxy_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+# * creating valid named objects
+# * referencing them from a valid rule
+
+RULESET="
+table inet x {
+	synproxy https-synproxy {
+		mss 1460
+		wscale 7
+		timestamp sack-perm
+	}
+	synproxy other-synproxy {
+		mss 1460
+		wscale 5
+	}
+	map test2 {
+		type ipv4_addr : synproxy
+		flags interval
+		elements = { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
+	}
+	chain y {
+		type filter hook input priority 0; policy accept;
+		synproxy name ip saddr map { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
+	}
+}"
+
+set -e
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/sets/dumps/0024named_objects_0.nft b/tests/shell/testcases/sets/dumps/0024named_objects_0.nft
index 52d1bf64b686..2ffa4f2ff757 100644
--- a/tests/shell/testcases/sets/dumps/0024named_objects_0.nft
+++ b/tests/shell/testcases/sets/dumps/0024named_objects_0.nft
@@ -15,17 +15,6 @@ table inet x {
 		over 2000 bytes
 	}
 
-	synproxy https-synproxy {
-		mss 1460
-		wscale 7
-		timestamp sack-perm
-	}
-
-	synproxy other-synproxy {
-		mss 1460
-		wscale 5
-	}
-
 	set y {
 		type ipv4_addr
 	}
@@ -35,16 +24,9 @@ table inet x {
 		elements = { 192.168.2.2 : "user124", 192.168.2.3 : "user124" }
 	}
 
-	map test2 {
-		type ipv4_addr : synproxy
-		flags interval
-		elements = { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
-	}
-
 	chain y {
 		type filter hook input priority filter; policy accept;
 		counter name ip saddr map { 1.1.1.1 : "user123", 2.2.2.2 : "user123", 192.168.2.2 : "user123" }
-		synproxy name ip saddr map { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
 		quota name ip saddr map @test drop
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0024synproxy_0.nft b/tests/shell/testcases/sets/dumps/0024synproxy_0.nft
new file mode 100644
index 000000000000..e0ee86db2217
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0024synproxy_0.nft
@@ -0,0 +1,23 @@
+table inet x {
+	synproxy https-synproxy {
+		mss 1460
+		wscale 7
+		timestamp sack-perm
+	}
+
+	synproxy other-synproxy {
+		mss 1460
+		wscale 5
+	}
+
+	map test2 {
+		type ipv4_addr : synproxy
+		flags interval
+		elements = { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
+	}
+
+	chain y {
+		type filter hook input priority filter; policy accept;
+		synproxy name ip saddr map { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
+	}
+}
-- 
2.30.2

