From: Ana Rey <anarey@gmail.com>
Subject: [PATCH 6/6] [nft] tests: Add bridge folder with test files.
Date: Thu, 31 Jul 2014 11:08:11 +0200
Message-ID: <1406797691-1080-7-git-send-email-anarey@gmail.com>
References: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:48103 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaGaJIg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:08:36 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so2479968wes.29
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2014 02:08:35 -0700 (PDT)
In-Reply-To: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"bridge" folder contains the test files that are executed in bridge tables.

These test files are executed with nft-tests.py

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/bridge/chains.t | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 tests/bridge/chains.t

diff --git a/tests/bridge/chains.t b/tests/bridge/chains.t
new file mode 100644
index 0000000..2c534b5
--- /dev/null
+++ b/tests/bridge/chains.t
@@ -0,0 +1,8 @@
+*bridge;test-bridge
+
+# filter chains available are: input, output, forward
+:filter-input;type filter hook input priority 0
+:filter-forward;type filter hook forward priority 0
+:filter-output;type filter hook output priority 0
+
+-ether type 1;ok
-- 
2.0.0

