Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D166C4708A
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0368661008
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbhE0Pp3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 11:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbhE0Pp1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 11:45:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E5FC06138B
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2021 08:43:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lmIAq-0003PD-Ru; Thu, 27 May 2021 17:43:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/6] tests: add test case for removal of anon sets with only a single element
Date:   Thu, 27 May 2021 17:43:23 +0200
Message-Id: <20210527154323.4003-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210527154323.4003-1-fw@strlen.de>
References: <20210527154323.4003-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../optimizations/dumps/single_anon_set.nft   | 12 ++++++++
 .../single_anon_set.replace-single-anon-sets  | 12 ++++++++
 .../testcases/optimizations/single_anon_set   | 30 +++++++++++++++++++
 3 files changed, 54 insertions(+)
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set.replace-single-anon-sets
 create mode 100755 tests/shell/testcases/optimizations/single_anon_set

diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
new file mode 100644
index 000000000000..5320bcfc360a
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
@@ -0,0 +1,12 @@
+table ip test {
+	chain test {
+		ip saddr { 127.0.0.1 } accept
+		ip saddr { 127.0.0.0/8 } accept
+		ip saddr { 127.0.0.1-192.168.7.3 } accept
+		ip daddr { 192.168.7.1, 192.168.7.5 } accept
+		tcp dport { 80, 443 } accept
+		tcp dport != { 22 } drop
+		tcp sport { 1-1023 } drop
+		iif { "lo" } accept
+	}
+}
diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.replace-single-anon-sets b/tests/shell/testcases/optimizations/dumps/single_anon_set.replace-single-anon-sets
new file mode 100644
index 000000000000..b9afa245fc16
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set.replace-single-anon-sets
@@ -0,0 +1,12 @@
+table ip test {
+	chain test {
+		ip saddr 127.0.0.1 accept
+		ip saddr 127.0.0.0/8 accept
+		ip saddr 127.0.0.1-192.168.7.3 accept
+		ip daddr { 192.168.7.1, 192.168.7.5 } accept
+		tcp dport { 80, 443 } accept
+		tcp dport != 22 drop
+		tcp sport 1-1023 drop
+		iif "lo" accept
+	}
+}
diff --git a/tests/shell/testcases/optimizations/single_anon_set b/tests/shell/testcases/optimizations/single_anon_set
new file mode 100755
index 000000000000..81c8533b2a57
--- /dev/null
+++ b/tests/shell/testcases/optimizations/single_anon_set
@@ -0,0 +1,30 @@
+#!/bin/bash
+
+set -e
+
+# Input file contains rules with anon sets that contain
+# one element, plus extra rule with two elements (that should be
+# left alone).
+
+# Second file contains a postprocessed version with rules
+# translated to simple equality test rather than set lookup.
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+dumpfile_pp=$(dirname $0)/dumps/$(basename $0).replace-single-anon-sets
+
+$NFT -O replace-single-anon-sets -f "$dumpfile"
+A=$(mktemp)
+$NFT list ruleset > "$A"
+
+# This checks that -O no-remove... kept all auto-generated
+# dependencies, even though the imported file doesn't
+# mention them.
+
+diff -u "$A" "$dumpfile_pp"
+ret=$?
+
+rm -f "$A"
+
+$NFT delete table ip test
+$NFT -f "$dumpfile"
+
+exit $ret
-- 
2.26.3

