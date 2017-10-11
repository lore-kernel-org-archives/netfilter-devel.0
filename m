From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 3/9] tests: shell: Add test case for sets.
Date: Wed, 11 Oct 2017 10:14:33 +0530
Message-ID: <42e35571e5a59d637c39582e242ddd710f103fa3.1507696149.git.rvarsha016@gmail.com>
References: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34524 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdJKEoz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 00:44:55 -0400
Received: by mail-pg0-f66.google.com with SMTP id u27so869453pgn.1
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 21:44:55 -0700 (PDT)
In-Reply-To: <cover.1507696149.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds test case for anonymous sets.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/sets/0025anonymous_set_0 | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0025anonymous_set_0

diff --git a/tests/shell/testcases/sets/0025anonymous_set_0 b/tests/shell/testcases/sets/0025anonymous_set_0
new file mode 100755
index 0000000..93a7c02
--- /dev/null
+++ b/tests/shell/testcases/sets/0025anonymous_set_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+# Adding anonymous sets
+
+set -e
+
+$NFT add table t
+$NFT add chain t c { type filter hook output priority 0 \; }
+# set: IP addresses
+$NFT add rule t c ip daddr { \
+        192.168.0.1, \
+        192.168.0.2, \
+        192.168.0.3, \
+}
+
+#set : tcp ports
+$NFT add rule t c tcp dport { 22, 23 } counter
-- 
2.13.6

