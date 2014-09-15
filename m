From: Ana Rey <anarey@gmail.com>
Subject: [PATCH nft v2 5/6] tests: Add bridge folder with test files.
Date: Mon, 15 Sep 2014 14:47:09 +0200
Message-ID: <1410785230-8498-6-git-send-email-anarey@gmail.com>
References: <1410785230-8498-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46538 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaIOMpF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:45:05 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so3868472wgh.10
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2014 05:45:04 -0700 (PDT)
In-Reply-To: <1410785230-8498-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"bridge" folder contains the test files that are executed in bridge tables.

These test files are executed with nft-tests.py

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/regression/bridge/chains.t |    7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 tests/regression/bridge/chains.t

diff --git a/tests/regression/bridge/chains.t b/tests/regression/bridge/chains.t
new file mode 100644
index 0000000..3fb1c89
--- /dev/null
+++ b/tests/regression/bridge/chains.t
@@ -0,0 +1,7 @@
+*bridge;test-bridge
+# filter chains available are: input, output, forward
+:filter-input;type filter hook input priority 0
+:filter-forward;type filter hook forward priority 0
+:filter-output;type filter hook output priority 0
+
+- ether type 1;ok
-- 
1.7.10.4

