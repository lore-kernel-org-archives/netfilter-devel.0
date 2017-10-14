From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests: shell: add testcases for named limits
Date: Sat, 14 Oct 2017 16:16:03 +0530
Message-ID: <20171014104603.16365-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:50403 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdJNKsS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Oct 2017 06:48:18 -0400
Received: by mail-pg0-f41.google.com with SMTP id y7so3145780pgb.7
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Oct 2017 03:48:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add testcases for creating named limits and referencing them
from rule

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/shell/testcases/sets/0025named_limit_0 | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0025named_limit_0

diff --git a/tests/shell/testcases/sets/0025named_limit_0 b/tests/shell/testcases/sets/0025named_limit_0
new file mode 100755
index 0000000..91553f3
--- /dev/null
+++ b/tests/shell/testcases/sets/0025named_limit_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+# This is the testscase:
+# * creating valid named limits
+# * referencing them from a valid rule
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+table ip filter {
+	limit http-traffic {
+		rate 1/second
+	}
+	chain input {
+		type filter hook input priority 0; policy accept;
+		limit name tcp dport map { 80 : "http-traffic", 443 : "http-traffic"}
+	}
+}" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
-- 
2.11.0

