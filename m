From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] tests: shell: add testcase for reject expr
Date: Mon, 22 Aug 2016 23:43:53 +0800
Message-ID: <1471880633-21640-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:45014 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754527AbcHVPom (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 11:44:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Reject expr is only valid in input/forward/output chain,
and if user can add reject expr in prerouting chain, kernel
panic will happen.

So add a simple test case to cover this situation.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 tests/shell/testcases/chains/0012reject_in_prerouting_1 | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0012reject_in_prerouting_1

diff --git a/tests/shell/testcases/chains/0012reject_in_prerouting_1 b/tests/shell/testcases/chains/0012reject_in_prerouting_1
new file mode 100755
index 0000000..81cda0c
--- /dev/null
+++ b/tests/shell/testcases/chains/0012reject_in_prerouting_1
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t prerouting {type filter hook prerouting priority 0 \; }
+# wrong hook prerouting, only input/forward/output is valid
+$NFT add rule t prerouting reject 2>/dev/null
+echo "E: accepted reject in prerouting hook" >&2
-- 
2.5.5


