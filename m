Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6981C074FD
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 13:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjKMNjP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 08:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjKMNjN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 08:39:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 505A7D72
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 05:39:09 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft,v2 08/11] tests: shell: split set NAT interval test
Date:   Mon, 13 Nov 2023 14:38:55 +0100
Message-Id: <20231113133858.121324-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231113133858.121324-1-pablo@netfilter.org>
References: <20231113133858.121324-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Split test in two, one for interval sets and another with concatenation
+ intervals, so at least intervals are tested in older kernels with no
pipapo support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 .../testcases/sets/0067nat_concat_interval_0   | 17 ++---------------
 tests/shell/testcases/sets/0067nat_interval_0  | 18 ++++++++++++++++++
 .../sets/dumps/0067nat_concat_interval_0.nft   |  7 -------
 .../sets/dumps/0067nat_interval_0.nft          | 12 ++++++++++++
 4 files changed, 32 insertions(+), 22 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0067nat_interval_0
 create mode 100644 tests/shell/testcases/sets/dumps/0067nat_interval_0.nft

diff --git a/tests/shell/testcases/sets/0067nat_concat_interval_0 b/tests/shell/testcases/sets/0067nat_concat_interval_0
index 55cc0d4b43df..816219573870 100755
--- a/tests/shell/testcases/sets/0067nat_concat_interval_0
+++ b/tests/shell/testcases/sets/0067nat_concat_interval_0
@@ -1,21 +1,8 @@
 #!/bin/bash
 
-set -e
-
-EXPECTED="table ip nat {
-       map ipportmap {
-                type ipv4_addr : interval ipv4_addr . inet_service
-                flags interval
-                elements = { 192.168.1.2 : 10.141.10.1-10.141.10.3 . 8888-8999 }
-       }
-       chain prerouting {
-                type nat hook prerouting priority dstnat; policy accept;
-                ip protocol tcp dnat ip to ip saddr map @ipportmap
-       }
-}"
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
 
-$NFT -f - <<< $EXPECTED
-$NFT add element ip nat ipportmap { 192.168.2.0/24 : 10.141.11.5-10.141.11.20 . 8888-8999 }
+set -e
 
 EXPECTED="table ip nat {
         map ipportmap2 {
diff --git a/tests/shell/testcases/sets/0067nat_interval_0 b/tests/shell/testcases/sets/0067nat_interval_0
new file mode 100755
index 000000000000..c90203d0d648
--- /dev/null
+++ b/tests/shell/testcases/sets/0067nat_interval_0
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table ip nat {
+       map ipportmap {
+                type ipv4_addr : interval ipv4_addr . inet_service
+                flags interval
+                elements = { 192.168.1.2 : 10.141.10.1-10.141.10.3 . 8888-8999 }
+       }
+       chain prerouting {
+                type nat hook prerouting priority dstnat; policy accept;
+                ip protocol tcp dnat ip to ip saddr map @ipportmap
+       }
+}"
+
+$NFT -f - <<< $EXPECTED
+$NFT add element ip nat ipportmap { 192.168.2.0/24 : 10.141.11.5-10.141.11.20 . 8888-8999 }
diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
index 0215691e28ee..9ac3774a7222 100644
--- a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
@@ -1,10 +1,4 @@
 table ip nat {
-	map ipportmap {
-		type ipv4_addr : interval ipv4_addr . inet_service
-		flags interval
-		elements = { 192.168.1.2 : 10.141.10.1-10.141.10.3 . 8888-8999, 192.168.2.0/24 : 10.141.11.5-10.141.11.20 . 8888-8999 }
-	}
-
 	map ipportmap2 {
 		type ipv4_addr . ipv4_addr : interval ipv4_addr . inet_service
 		flags interval
@@ -33,7 +27,6 @@ table ip nat {
 
 	chain prerouting {
 		type nat hook prerouting priority dstnat; policy accept;
-		ip protocol tcp dnat ip to ip saddr map @ipportmap
 		ip protocol tcp dnat ip to ip saddr . ip daddr map @ipportmap2
 		meta l4proto { tcp, udp } dnat ip to ip daddr . th dport map @fwdtoip_th
 		dnat ip to iifname . ip saddr map @ipportmap4
diff --git a/tests/shell/testcases/sets/dumps/0067nat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_interval_0.nft
new file mode 100644
index 000000000000..b6d07fcdc248
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0067nat_interval_0.nft
@@ -0,0 +1,12 @@
+table ip nat {
+	map ipportmap {
+		type ipv4_addr : interval ipv4_addr . inet_service
+		flags interval
+		elements = { 192.168.1.2 : 10.141.10.1-10.141.10.3 . 8888-8999, 192.168.2.0/24 : 10.141.11.5-10.141.11.20 . 8888-8999 }
+	}
+
+	chain prerouting {
+		type nat hook prerouting priority dstnat; policy accept;
+		ip protocol tcp dnat ip to ip saddr map @ipportmap
+	}
+}
-- 
2.30.2

