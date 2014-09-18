From: Ana Rey <anarey@gmail.com>
Subject: [v3 nft 6/7] tests: Add bridge folder with test files.
Date: Thu, 18 Sep 2014 12:39:20 +0200
Message-ID: <1411036761-26825-7-git-send-email-anarey@gmail.com>
References: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35826 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbaIRKhJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:37:09 -0400
Received: by mail-wi0-f178.google.com with SMTP id ho1so910644wib.5
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2014 03:37:08 -0700 (PDT)
In-Reply-To: <1411036761-26825-1-git-send-email-anarey@gmail.com>
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

