Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A85C61DB3
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 10:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjKVKce (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 05:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjKVKcc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 05:32:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08F34E7
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 02:32:28 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 6/8] tests: shell: split nat inet tests
Date:   Wed, 22 Nov 2023 11:32:19 +0100
Message-Id: <20231122103221.90160-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231122103221.90160-1-pablo@netfilter.org>
References: <20231122103221.90160-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Detach nat inet from existing tests not to reduce test coverage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../optimizations/dumps/merge_nat.nft         | 11 ----------
 .../optimizations/dumps/merge_nat_inet.nft    | 11 ++++++++++
 tests/shell/testcases/optimizations/merge_nat | 16 --------------
 .../testcases/optimizations/merge_nat_inet    | 21 +++++++++++++++++++
 4 files changed, 32 insertions(+), 27 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_nat_inet.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_nat_inet

diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat.nft b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
index 61feb278d5e6..f6c119eca810 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat.nft
@@ -19,14 +19,3 @@ table ip test4 {
 		tcp dport 85 redirect
 	}
 }
-table inet nat {
-	chain prerouting {
-		oif "lo" accept
-		dnat ip to iifname . ip daddr . tcp dport map { "enp2s0" . 72.2.3.70 . 80 : 10.1.1.52 . 80, "enp2s0" . 72.2.3.66 . 53122 : 10.1.1.10 . 22, "enp2s0" . 72.2.3.66 . 443 : 10.1.1.52 . 443 }
-	}
-
-	chain postrouting {
-		oif "lo" accept
-		snat ip to ip daddr map { 72.2.3.66 : 10.2.2.2, 72.2.3.67 : 10.2.3.3 }
-	}
-}
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat_inet.nft b/tests/shell/testcases/optimizations/dumps/merge_nat_inet.nft
new file mode 100644
index 000000000000..a1a1135482b9
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat_inet.nft
@@ -0,0 +1,11 @@
+table inet nat {
+	chain prerouting {
+		oif "lo" accept
+		dnat ip to iifname . ip daddr . tcp dport map { "enp2s0" . 72.2.3.70 . 80 : 10.1.1.52 . 80, "enp2s0" . 72.2.3.66 . 53122 : 10.1.1.10 . 22, "enp2s0" . 72.2.3.66 . 443 : 10.1.1.52 . 443 }
+	}
+
+	chain postrouting {
+		oif "lo" accept
+		snat ip to ip daddr map { 72.2.3.66 : 10.2.2.2, 72.2.3.67 : 10.2.3.3 }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_nat b/tests/shell/testcases/optimizations/merge_nat
index bfe978701b90..3ffcbd576691 100755
--- a/tests/shell/testcases/optimizations/merge_nat
+++ b/tests/shell/testcases/optimizations/merge_nat
@@ -36,19 +36,3 @@ RULESET="table ip test4 {
 }"
 
 $NFT -o -f - <<< $RULESET
-
-RULESET="table inet nat {
-	chain prerouting {
-		oif lo accept
-		iifname enp2s0 ip daddr 72.2.3.66 tcp dport 53122 dnat to 10.1.1.10:22
-		iifname enp2s0 ip daddr 72.2.3.66 tcp dport 443 dnat to 10.1.1.52:443
-		iifname enp2s0 ip daddr 72.2.3.70 tcp dport 80 dnat to 10.1.1.52:80
-	}
-	chain postrouting {
-		oif lo accept
-		ip daddr 72.2.3.66 snat to 10.2.2.2
-		ip daddr 72.2.3.67 snat to 10.2.3.3
-	}
-}"
-
-$NFT -o -f - <<< $RULESET
diff --git a/tests/shell/testcases/optimizations/merge_nat_inet b/tests/shell/testcases/optimizations/merge_nat_inet
new file mode 100755
index 000000000000..ff1916d3f897
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_nat_inet
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_inet_nat)
+
+set -e
+
+RULESET="table inet nat {
+	chain prerouting {
+		oif lo accept
+		iifname enp2s0 ip daddr 72.2.3.66 tcp dport 53122 dnat to 10.1.1.10:22
+		iifname enp2s0 ip daddr 72.2.3.66 tcp dport 443 dnat to 10.1.1.52:443
+		iifname enp2s0 ip daddr 72.2.3.70 tcp dport 80 dnat to 10.1.1.52:80
+	}
+	chain postrouting {
+		oif lo accept
+		ip daddr 72.2.3.66 snat to 10.2.2.2
+		ip daddr 72.2.3.67 snat to 10.2.3.3
+	}
+}"
+
+$NFT -o -f - <<< $RULESET
-- 
2.30.2

