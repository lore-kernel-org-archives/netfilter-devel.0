From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] tests/shell: Add back named_interval_automerging_0
Date: Sat, 20 Jan 2018 14:21:01 +0100
Message-ID: <20180120132101.14921-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58360 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbeATNVN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jan 2018 08:21:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Change the test to expect no automerging since it was disabled recently.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/0002named_interval_automerging_0 | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0002named_interval_automerging_0

diff --git a/tests/shell/testcases/sets/0002named_interval_automerging_0 b/tests/shell/testcases/sets/0002named_interval_automerging_0
new file mode 100755
index 0000000000000..688986387d177
--- /dev/null
+++ b/tests/shell/testcases/sets/0002named_interval_automerging_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+# This testscase checks the automerging of adjacent intervals
+
+set -e
+
+$NFT add table t
+$NFT add set t s { type ipv4_addr \; flags interval \; }
+$NFT add element t s { 192.168.0.0/24, 192.168.1.0/24 }
+$NFT list ruleset | grep "192.168.0.0/23" >/dev/null || exit 0
+echo "E: automerging of adjacent intervals happened unexpectedly." >&2
+exit 1
-- 
2.15.1

