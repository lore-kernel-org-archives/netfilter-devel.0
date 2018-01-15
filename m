From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests/shell: add tests for deletion of sets via set handle
Date: Mon, 15 Jan 2018 17:21:33 +0530
Message-ID: <20180115115133.15480-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:39237 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932077AbeAOLwW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 06:52:22 -0500
Received: by mail-pl0-f66.google.com with SMTP id bi12so3565979plb.6
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 03:52:22 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Delete set with given unique set handle.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/shell/testcases/sets/0028delete_handle_0 | 33 ++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0028delete_handle_0

diff --git a/tests/shell/testcases/sets/0028delete_handle_0 b/tests/shell/testcases/sets/0028delete_handle_0
new file mode 100755
index 0000000..215323c
--- /dev/null
+++ b/tests/shell/testcases/sets/0028delete_handle_0
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+set -e
+$NFT add table test-ip
+$NFT add set test-ip x { type ipv4_addr\; }	# should have handle 1
+$NFT add set test-ip y { type inet_service \; timeout 3h45s \;} 	# should have handle 2
+$NFT add set test-ip z { type ipv4_addr\; flags constant , interval\;} # should have handle 3
+$NFT add set test-ip c {type ipv4_addr \; flags timeout \; elements={192.168.1.1 timeout 10s, 192.168.1.2 timeout 30s} \;} #should have handle 4
+$NFT delete set test-ip handle 4
+
+EXPECTED="table ip test-ip {
+	set x {
+		type ipv4_addr
+	}
+
+	set y {
+		type inet_service
+		timeout 3h45s
+	}
+
+	set z {
+		type ipv4_addr
+		flags constant,interval
+	}
+}"
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.11.0

