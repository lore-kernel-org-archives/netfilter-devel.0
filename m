Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511CFC4708F
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3643B61423
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFDLmx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Jun 2021 07:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhFDLmx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 07:42:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72F5C06174A
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 04:41:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lp8CH-0004vp-F7; Fri, 04 Jun 2021 13:41:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/4] tests: add test case for removal of anon sets with only a single element
Date:   Fri,  4 Jun 2021 13:40:43 +0200
Message-Id: <20210604114043.4153-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210604114043.4153-1-fw@strlen.de>
References: <20210604114043.4153-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also add a few examples that should not be changed:
- anon set with 2 elements
- anon map with 1 element
- anon set with a concatenation

The latter could be done with cmp but this currently triggers
'Error: Use concatenations with sets and maps, not singleton values'
after removing the anon set.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../optimizations/dumps/single_anon_set.nft   | 15 ++++++++
 .../dumps/single_anon_set.nft.input           | 35 +++++++++++++++++++
 .../testcases/optimizations/single_anon_set   | 13 +++++++
 .../shell/testcases/sets/dumps/0053echo_0.nft |  2 +-
 4 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
 create mode 100755 tests/shell/testcases/optimizations/single_anon_set

diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
new file mode 100644
index 000000000000..35e3f36e1a54
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft
@@ -0,0 +1,15 @@
+table ip test {
+	chain test {
+		ip saddr 127.0.0.1 accept
+		iif "lo" accept
+		tcp dport != 22 drop
+		ip saddr 127.0.0.0/8 accept
+		ip saddr 127.0.0.1-192.168.7.3 accept
+		tcp sport 1-1023 drop
+		ip daddr { 192.168.7.1, 192.168.7.5 } accept
+		tcp dport { 80, 443 } accept
+		ip daddr . tcp dport { 192.168.0.1 . 22 } accept
+		meta mark set ip daddr map { 192.168.0.1 : 0x00000001 }
+		ct state { established, related } accept
+	}
+}
diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
new file mode 100644
index 000000000000..35b93832420f
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
@@ -0,0 +1,35 @@
+table ip test {
+	chain test {
+		# Test cases where anon set can be removed:
+		ip saddr { 127.0.0.1 } accept
+		iif { "lo" } accept
+
+		# negation, can change to != 22.
+		tcp dport != { 22 } drop
+
+		# single prefix, can remove anon set.
+		ip saddr { 127.0.0.0/8 } accept
+
+		# range, can remove anon set.
+		ip saddr { 127.0.0.1-192.168.7.3 } accept
+		tcp sport { 1-1023 } drop
+
+		# Test cases where anon set must be kept.
+
+		# 2 elements, cannot remove the anon set.
+		ip daddr { 192.168.7.1, 192.168.7.5 } accept
+		tcp dport { 80, 443 } accept
+
+		# single element, but concatenation which is not
+		# supported outside of set/map context at this time.
+		ip daddr . tcp dport { 192.168.0.1 . 22 } accept
+
+		# single element, but a map.
+		meta mark set ip daddr map { 192.168.0.1 : 1 }
+
+		# 2 elements.  This could be converted because
+		# ct state cannot be both established and related
+		# at the same time, but this needs extra work.
+		ct state { established, related } accept
+	}
+}
diff --git a/tests/shell/testcases/optimizations/single_anon_set b/tests/shell/testcases/optimizations/single_anon_set
new file mode 100755
index 000000000000..7275e3606900
--- /dev/null
+++ b/tests/shell/testcases/optimizations/single_anon_set
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+set -e
+
+# Input file contains rules with anon sets that contain
+# one element, plus extra rule with two elements (that should be
+# left alone).
+
+# Dump file has the simplified rules where anon sets have been
+# replaced by equality tests where possible.
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile".input
diff --git a/tests/shell/testcases/sets/dumps/0053echo_0.nft b/tests/shell/testcases/sets/dumps/0053echo_0.nft
index 6a8166360ceb..bb7c55136619 100644
--- a/tests/shell/testcases/sets/dumps/0053echo_0.nft
+++ b/tests/shell/testcases/sets/dumps/0053echo_0.nft
@@ -1,6 +1,6 @@
 table inet filter {
 	chain input {
 		type filter hook input priority filter; policy drop;
-		iifname { "lo" } ip saddr { 10.0.0.0/8 } ip daddr { 192.168.100.62 } tcp dport { 2001 } counter packets 0 bytes 0 accept
+		iifname "lo" ip saddr 10.0.0.0/8 ip daddr 192.168.100.62 tcp dport 2001 counter packets 0 bytes 0 accept
 	}
 }
-- 
2.26.3

