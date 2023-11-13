Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A26C07524
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 13:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjKMNjQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 08:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjKMNjN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 08:39:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AFB81A2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 05:39:10 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft,v2 11/11] tests: shell: split merge nat optimization in two tests
Date:   Mon, 13 Nov 2023 14:38:58 +0100
Message-Id: <20231113133858.121324-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231113133858.121324-1-pablo@netfilter.org>
References: <20231113133858.121324-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

One without pipapo support and another with not to harm existing
coverage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 .../optimizations/dumps/merge_nat.nft          |  8 --------
 .../optimizations/dumps/merge_nat_concat.nft   |  8 ++++++++
 tests/shell/testcases/optimizations/merge_nat  | 13 -------------
 .../testcases/optimizations/merge_nat_concat   | 18 ++++++++++++++++++
 4 files changed, 26 insertions(+), 21 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_nat_concat.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_nat_concat

diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
index 48d18a676ee0..61feb278d5e6 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -11,14 +11,6 @@ table ip test2 {
 		ip saddr { 10.141.11.0/24, 10.141.13.0/24 } masquerade
 	}
 }
-table ip test3 {
-	chain y {
-		oif "lo" accept
-		snat to ip saddr . tcp sport map { 1.1.1.1 . 1024-65535 : 3.3.3.3, 2.2.2.2 . 1024-65535 : 4.4.4.4 }
-		oifname "enp2s0" snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
-		tcp dport { 8888, 9999 } redirect
-	}
-}
 table ip test4 {
 	chain y {
 		oif "lo" accept
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat_concat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat_concat.nft
new file mode 100644
index 000000000000..0faddfd14fb8
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat_concat.nft
@@ -0,0 +1,8 @@
+table ip test3 {
+	chain y {
+		oif "lo" accept
+		snat to ip saddr . tcp sport map { 1.1.1.1 . 1024-65535 : 3.3.3.3, 2.2.2.2 . 1024-65535 : 4.4.4.4 }
+		oifname "enp2s0" snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
+		tcp dport { 8888, 9999 } redirect
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
index 3a57d9402301..bfe978701b90 100755
--- a/tests/shell/testcases/optimizations/merge_nat
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -24,19 +24,6 @@ RULESET="table ip test2 {
 
 $NFT -o -f - <<< $RULESET
 
-RULESET="table ip test3 {
-        chain y {
-                oif lo accept
-                ip saddr 1.1.1.1 tcp sport 1024-65535 snat to 3.3.3.3
-                ip saddr 2.2.2.2 tcp sport 1024-65535 snat to 4.4.4.4
-                oifname enp2s0 snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
-                tcp dport 8888 redirect
-                tcp dport 9999 redirect
-        }
-}"
-
-$NFT -o -f - <<< $RULESET
-
 RULESET="table ip test4 {
         chain y {
                 oif lo accept
diff --git a/tests/shell/testcases/optimizations/merge_nat_concat b/tests/shell/testcases/optimizations/merge_nat_concat
new file mode 100755
index 000000000000..2e0a91a35bd6
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_nat_concat
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
+set -e
+
+RULESET="table ip test3 {
+        chain y {
+                oif lo accept
+                ip saddr 1.1.1.1 tcp sport 1024-65535 snat to 3.3.3.3
+                ip saddr 2.2.2.2 tcp sport 1024-65535 snat to 4.4.4.4
+                oifname enp2s0 snat ip to ip saddr map { 10.1.1.0/24 : 72.2.3.66-72.2.3.78 }
+                tcp dport 8888 redirect
+                tcp dport 9999 redirect
+        }
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

