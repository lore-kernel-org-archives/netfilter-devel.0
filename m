From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] tests: shell: add endless jump loop tests
Date: Mon, 13 Jun 2016 20:53:55 +0800
Message-ID: <1465822435-39991-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:38282 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422747AbcFMMyn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jun 2016 08:54:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Add some tests for endless jump loop validation.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 tests/shell/testcases/chains/0010endless_jump_loop_1 |  9 +++++++++
 tests/shell/testcases/chains/0011endless_jump_loop_1 | 14 ++++++++++++++
 2 files changed, 23 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0010endless_jump_loop_1
 create mode 100755 tests/shell/testcases/chains/0011endless_jump_loop_1

diff --git a/tests/shell/testcases/chains/0010endless_jump_loop_1 b/tests/shell/testcases/chains/0010endless_jump_loop_1
new file mode 100755
index 0000000..dba70e1
--- /dev/null
+++ b/tests/shell/testcases/chains/0010endless_jump_loop_1
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c
+# kernel should return ELOOP
+$NFT add rule t c tcp dport vmap {1 : jump c} 2>/dev/null
+echo "E: accepted endless jump loop in a vmap" >&2
diff --git a/tests/shell/testcases/chains/0011endless_jump_loop_1 b/tests/shell/testcases/chains/0011endless_jump_loop_1
new file mode 100755
index 0000000..adbff8d
--- /dev/null
+++ b/tests/shell/testcases/chains/0011endless_jump_loop_1
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table t
+$NFT add chain t c1
+$NFT add chain t c2
+$NFT add map t m {type inet_service : verdict \;}
+$NFT add element t m {2 : jump c2}
+$NFT add rule t c1 tcp dport vmap @m
+
+# kernel should return ELOOP
+$NFT add element t m {1 : jump c1} 2>/dev/null
+echo "E: accepted endless jump loop in a vmap" >&2
-- 
2.5.5


