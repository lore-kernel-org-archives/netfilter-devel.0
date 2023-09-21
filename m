Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A5BE7109A
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 16:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjIUQ7k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 12:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjIUQ7g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 12:59:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76091FC8
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2023 09:58:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qjFMt-0004Lv-UU; Thu, 21 Sep 2023 10:49:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/3] tests: shell: add feature probe for sets with more than one element
Date:   Thu, 21 Sep 2023 10:48:45 +0200
Message-ID: <20230921084849.634-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230921084849.634-1-fw@strlen.de>
References: <20230921084849.634-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernels < 5.11 can handle only one expression per element, e.g.
its possible to attach a counter per key, or a rate limiter,
or a quota, but not two at the same time.

Add a probe file and skip the relevant tests if the feature is absent.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/features/set_with_two_expressions.nft     | 9 +++++++++
 tests/shell/testcases/nft-f/0025empty_dynset_0        | 8 ++++++++
 tests/shell/testcases/sets/0059set_update_multistmt_0 | 2 ++
 tests/shell/testcases/sets/0060set_multistmt_0        | 2 ++
 tests/shell/testcases/sets/0060set_multistmt_1        | 2 ++
 5 files changed, 23 insertions(+)
 create mode 100644 tests/shell/features/set_with_two_expressions.nft

diff --git a/tests/shell/features/set_with_two_expressions.nft b/tests/shell/features/set_with_two_expressions.nft
new file mode 100644
index 000000000000..97632a7af6d3
--- /dev/null
+++ b/tests/shell/features/set_with_two_expressions.nft
@@ -0,0 +1,9 @@
+# 48b0ae046ee9 ("netfilter: nftables: netlink support for several set element expressions")
+# v5.11-rc1~169^2~25^2
+table x {
+        set y {
+                type ipv4_addr
+                size 65535
+                counter quota 500 bytes
+        }
+}
diff --git a/tests/shell/testcases/nft-f/0025empty_dynset_0 b/tests/shell/testcases/nft-f/0025empty_dynset_0
index b66c802f8536..fbdb57931ed0 100755
--- a/tests/shell/testcases/nft-f/0025empty_dynset_0
+++ b/tests/shell/testcases/nft-f/0025empty_dynset_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+set -e
+
 RULESET="table ip foo {
 	        set inflows {
                 type ipv4_addr . inet_service . ifname . ipv4_addr . inet_service
@@ -20,3 +22,9 @@ RULESET="table ip foo {
 }"
 
 $NFT -f - <<< "$RULESET"
+
+# inflows_ratelimit will be dumped without 'limit rate .. counter' on old kernels.
+if [ "$NFT_TEST_HAVE_set_with_two_expressions" = n ]; then
+	echo "Partial test due to NFT_TEST_HAVE_set_with_two_expressions=n."
+	exit 77
+fi
diff --git a/tests/shell/testcases/sets/0059set_update_multistmt_0 b/tests/shell/testcases/sets/0059set_update_multistmt_0
index 107bfb870932..2aeba2c5d227 100755
--- a/tests/shell/testcases/sets/0059set_update_multistmt_0
+++ b/tests/shell/testcases/sets/0059set_update_multistmt_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_with_two_expressions)
+
 RULESET="table x {
 	set y {
 		type ipv4_addr
diff --git a/tests/shell/testcases/sets/0060set_multistmt_0 b/tests/shell/testcases/sets/0060set_multistmt_0
index 6bd147c3540c..8e17444e9ec5 100755
--- a/tests/shell/testcases/sets/0060set_multistmt_0
+++ b/tests/shell/testcases/sets/0060set_multistmt_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_with_two_expressions)
+
 RULESET="table x {
 	set y {
 		type ipv4_addr
diff --git a/tests/shell/testcases/sets/0060set_multistmt_1 b/tests/shell/testcases/sets/0060set_multistmt_1
index 1652668a2fec..04ef047caa52 100755
--- a/tests/shell/testcases/sets/0060set_multistmt_1
+++ b/tests/shell/testcases/sets/0060set_multistmt_1
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_with_two_expressions)
+
 RULESET="table x {
 	set y {
 		type ipv4_addr
-- 
2.41.0

