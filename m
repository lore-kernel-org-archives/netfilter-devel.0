From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests: shell: add testcases for named objects
Date: Thu,  5 Oct 2017 15:45:39 +0530
Message-ID: <20171005101539.32010-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37240 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdJEKRv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Oct 2017 06:17:51 -0400
Received: by mail-pg0-f66.google.com with SMTP id o1so14136550pga.4
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Oct 2017 03:17:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add testcases for creating named objects with unique name, defined
by user and referencing them from rule.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/shell/testcases/sets/0024named_objects_0 | 41 ++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0024named_objects_0

diff --git a/tests/shell/testcases/sets/0024named_objects_0 b/tests/shell/testcases/sets/0024named_objects_0
new file mode 100755
index 0000000..de02d65
--- /dev/null
+++ b/tests/shell/testcases/sets/0024named_objects_0
@@ -0,0 +1,41 @@
+#!/bin/bash
+
+# This is the testscase:
+# * creating valid named objects
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
+table inet x {
+	counter user123 {
+		packets 12 bytes 1433
+	}
+	quota user123 {
+		over 2000 bytes
+	}
+	quota user124 {
+		over 2000 bytes
+	}
+	set y {
+		type ipv4_addr
+	}
+	map test {
+		type ipv4_addr : quota
+		elements = { 192.168.2.2 : "user124", 192.168.2.3 : "user124"}
+	}
+	chain y {
+		type filter hook input priority 0; policy accept;
+		counter name ip saddr map { 192.168.2.2 : "user123", 1.1.1.1 : "user123", 2.2.2.2 : "user123"}
+		quota name ip saddr map @test drop
+	}
+}" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
--
2.11.0

