Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BAEEC05031
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 16:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjKIQXT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343850AbjKIQXQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 11:23:16 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC39A35A9
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 08:23:13 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     thaller@redhat.com, fw@strlen.de
Subject: [PATCH nft 11/12] tests: shell: split single element in anonymous set
Date:   Thu,  9 Nov 2023 17:23:03 +0100
Message-Id: <20231109162304.119506-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231109162304.119506-1-pablo@netfilter.org>
References: <20231109162304.119506-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Split this to move set stateful expression support into a separated test
not to harm existing coverage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../optimizations/dumps/single_anon_set.nft   |  1 -
 .../dumps/single_anon_set_expr.nft            |  5 ++++
 .../testcases/optimizations/single_anon_set   |  3 ---
 .../optimizations/single_anon_set_expr        | 26 +++++++++++++++++++
 4 files changed, 31 insertions(+), 4 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set_expr.nft
 create mode 100755 tests/shell/testcases/optimizations/single_anon_set_expr

diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
index 3f703034d80f..35e3f36e1a54 100644
--- a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
@@ -11,6 +11,5 @@ table ip test {
 		ip daddr . tcp dport { 192.168.0.1 . 22 } accept
 		meta mark set ip daddr map { 192.168.0.1 : 0x00000001 }
 		ct state { established, related } accept
-		meta mark { 0x0000000a counter packets 0 bytes 0 }
 	}
 }
diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set_expr.nft b/tests/shell/testcases/optimizations/dumps/single_anon_set_expr.nft
new file mode 100644
index 000000000000..54880b927250
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set_expr.nft
@@ -0,0 +1,5 @@
+table ip test {
+	chain test {
+		meta mark { 0x0000000a counter packets 0 bytes 0 }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/single_anon_set b/tests/shell/testcases/optimizations/single_anon_set
index 84fc2a7f03a8..632e965f37a7 100755
--- a/tests/shell/testcases/optimizations/single_anon_set
+++ b/tests/shell/testcases/optimizations/single_anon_set
@@ -46,9 +46,6 @@ table ip test {
 		# ct state cannot be both established and related
 		# at the same time, but this needs extra work.
 		ct state { established, related } accept
-
-		# with stateful statement
-		meta mark { 0x0000000a counter }
 	}
 }
 EOF
diff --git a/tests/shell/testcases/optimizations/single_anon_set_expr b/tests/shell/testcases/optimizations/single_anon_set_expr
new file mode 100755
index 000000000000..81b7cebadd5d
--- /dev/null
+++ b/tests/shell/testcases/optimizations/single_anon_set_expr
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
+
+set -e
+
+test -d "$NFT_TEST_TESTTMPDIR"
+
+# Input file contains rules with anon sets that contain
+# one element, plus extra rule with two elements (that should be
+# left alone).
+
+# Dump file has the simplified rules where anon sets have been
+# replaced by equality tests where possible.
+file_input1="$NFT_TEST_TESTTMPDIR/input1.nft"
+
+cat <<EOF > "$file_input1"
+table ip test {
+	chain test {
+		# with stateful statement
+		meta mark { 0x0000000a counter }
+	}
+}
+EOF
+
+$NFT -f "$file_input1"
-- 
2.30.2

