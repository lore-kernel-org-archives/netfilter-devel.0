From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests/shell: add tests for deletion of objects via object handle
Date: Fri, 19 Jan 2018 02:15:14 +0530
Message-ID: <20180118204514.16312-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:39891 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932484AbeARUpb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jan 2018 15:45:31 -0500
Received: by mail-pf0-f195.google.com with SMTP id e11so15584697pff.6
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jan 2018 12:45:31 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Delete objects with given object handle

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 .../testcases/optionals/delete_object_handles_0    | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100755 tests/shell/testcases/optionals/delete_object_handles_0

diff --git a/tests/shell/testcases/optionals/delete_object_handles_0 b/tests/shell/testcases/optionals/delete_object_handles_0
new file mode 100755
index 0000000..355de5f
--- /dev/null
+++ b/tests/shell/testcases/optionals/delete_object_handles_0
@@ -0,0 +1,40 @@
+#!/bin/bash
+
+set -e
+$NFT add table test-ip
+$NFT add counter test-ip https-traffic # should have handle 1
+$NFT add quota test-ip https-quota 25 mbytes # should have handle 2
+$NFT add map test-ip ports { type inet_service : quota \; } # should have handle 3
+$NFT add table ip6 test-ip6
+$NFT add quota ip6 test-ip6 http-quota over 25 mbytes # should have handle 1
+$NFT add counter ip6 test-ip6 http-traffic # should have handle 2
+$NFT add quota ip6 test-ip6 ssh-quota 10 mbytes # should have handle 3
+$NFT delete counter test-ip handle 1
+$NFT delete quota ip6 test-ip6 handle 3
+
+EXPECTED="table ip test-ip {
+	quota https-quota {
+		25 mbytes used 2 bytes
+	} # handle 2
+
+	map ports {
+		type inet_service : quota
+	} # handle 3
+} # handle 1
+table ip6 test-ip6 {
+	quota http-quota {
+		over 25 mbytes used 1 bytes
+	} # handle 1
+
+	counter http-traffic {
+		packets 0 bytes 2
+	} # handle 2
+} # handle 2"
+
+GET="$($NFT list ruleset -a)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
-- 
2.11.0

