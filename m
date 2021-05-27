Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E6D8C4708C
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24487613C9
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbhE0Ppa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 11:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235470AbhE0PpZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 11:45:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF26C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2021 08:43:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lmIAm-0003Ou-Lq; Thu, 27 May 2021 17:43:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/6] tests: add test case for -O no-remove-dependencies
Date:   Thu, 27 May 2021 17:43:22 +0200
Message-Id: <20210527154323.4003-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210527154323.4003-1-fw@strlen.de>
References: <20210527154323.4003-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Contains two different text files that contain the same rules, one
is with the implicit deps, the other one is without them.

Check they are the same and check that '-O no-remove-dependencies'
keeps the redundant meta/payload expressions.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../optimizations/dumps/payload_meta_deps.nft | 10 ++++++
 .../dumps/payload_meta_deps.no-remove-deps    | 10 ++++++
 .../testcases/optimizations/payload_meta_deps | 33 +++++++++++++++++++
 3 files changed, 53 insertions(+)
 create mode 100644 tests/shell/testcases/optimizations/dumps/payload_meta_deps.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/payload_meta_deps.no-remove-deps
 create mode 100755 tests/shell/testcases/optimizations/payload_meta_deps

diff --git a/tests/shell/testcases/optimizations/dumps/payload_meta_deps.nft b/tests/shell/testcases/optimizations/dumps/payload_meta_deps.nft
new file mode 100644
index 000000000000..5f26f0d317d9
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/payload_meta_deps.nft
@@ -0,0 +1,10 @@
+table inet test {
+	chain test {
+		ip saddr 1.2.3.4
+		ip6 saddr dead::1
+		tcp dport 22
+		ip saddr 1.2.3.5 tcp dport 22 accept
+		ip6 nexthdr udp
+		ip ttl < 5 drop
+	}
+}
diff --git a/tests/shell/testcases/optimizations/dumps/payload_meta_deps.no-remove-deps b/tests/shell/testcases/optimizations/dumps/payload_meta_deps.no-remove-deps
new file mode 100644
index 000000000000..5e458e88eb29
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/payload_meta_deps.no-remove-deps
@@ -0,0 +1,10 @@
+table inet test {
+	chain test {
+		meta nfproto ipv4 ip saddr 1.2.3.4
+		meta nfproto ipv6 ip6 saddr dead::1
+		meta l4proto tcp tcp dport 22
+		meta nfproto ipv4 ip saddr 1.2.3.5 meta l4proto tcp tcp dport 22 accept
+		meta nfproto ipv6 ip6 nexthdr udp
+		meta nfproto ipv4 ip ttl < 5 drop
+	}
+}
diff --git a/tests/shell/testcases/optimizations/payload_meta_deps b/tests/shell/testcases/optimizations/payload_meta_deps
new file mode 100755
index 000000000000..1ec3bf0776e8
--- /dev/null
+++ b/tests/shell/testcases/optimizations/payload_meta_deps
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+set -e
+
+# Input files are identical.  Second version includes the
+# (redundant) payload/meta dependencies, i.e. the files
+# are textually different but logically the rule sets are
+# the same.
+dumpfile_depon=$(dirname $0)/dumps/$(basename $0).nft
+dumpfile_depoff=$(dirname $0)/dumps/$(basename $0).no-remove-deps
+
+$NFT -f "$dumpfile_depon"
+A=$(mktemp)
+$NFT -O no-remove-dependencies list ruleset > "$A"
+
+# This checks that -O no-remove... kept all auto-generated
+# dependencies, even though the imported file doesn't
+# mention them.
+
+diff -u $dumpfile_depoff "$A"
+ret=$?
+
+rm -f "$A"
+
+$NFT delete table inet test
+
+# This makes calling test script check that the
+# no-remove-deps dump file logically matches the .nft version.
+# This detects future mismatches between the two representations.
+
+$NFT -f "$dumpfile_depoff"
+
+exit $ret
-- 
2.26.3

