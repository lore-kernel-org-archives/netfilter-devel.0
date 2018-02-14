From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: add test case for sets updated from packet path
Date: Wed, 14 Feb 2018 17:40:17 +0100
Message-ID: <20180214164017.14205-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43000 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032720AbeBNQpM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 11:45:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

currently kernel may pick a set implementation that doesn't provide
a ->update() function. This causes an error when user attempts to
add the nftables rule that is supposed to add entries to the set.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
Pablo, unless you have objections I would push this now.

diff --git a/tests/shell/testcases/sets/0028autoselect_0 b/tests/shell/testcases/sets/0028autoselect_0
new file mode 100755
index 000000000000..2225e7aee247
--- /dev/null
+++ b/tests/shell/testcases/sets/0028autoselect_0
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+# This testscase checks kernel picks a suitable set backends.
+# Ruleset attempts to update from packet path, so set backend
+# needs an ->update() implementation.
+
+set -e
+
+$NFT add table t
+$NFT add set t s1 { type inet_proto \; }
+$NFT add set t s2 { type ipv4_addr \; }
+$NFT add set t s3 { type ipv4_addr \; size 1024\; }
+$NFT add chain t c {type filter hook input priority 0 \; }
+
+# chosen set type must support updates from packet path
+$NFT add rule t c meta iifname foobar set add ip protocol @s1
+$NFT add rule t c meta iifname foobar set add ip daddr @s2
+$NFT add rule t c meta iifname foobar set add ip daddr @s3
-- 
2.13.6

