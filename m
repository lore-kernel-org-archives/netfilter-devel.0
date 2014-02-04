From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 8/8] tests: add two tests for error reporting
Date: Tue,  4 Feb 2014 08:35:20 +0000
Message-ID: <1391502920-19186-9-git-send-email-kaber@trash.net>
References: <1391502920-19186-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43628 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaBDIf3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:35:29 -0500
In-Reply-To: <1391502920-19186-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mixed syntactical and non-syntactical errors in individual commands and
blocks.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 tests/error.1 |  9 +++++++++
 tests/error.2 | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 tests/error.1
 create mode 100644 tests/error.2

diff --git a/tests/error.1 b/tests/error.1
new file mode 100644
index 0000000..bc3bf16
--- /dev/null
+++ b/tests/error.1
@@ -0,0 +1,9 @@
+#! nft -f
+
+# mixed syntactical and non-syntactical errors
+filter {
+filter input
+filter input tcp
+filter input tcp dport
+filter input tcp dport tcp
+filter input tcp dport tcp dport
diff --git a/tests/error.2 b/tests/error.2
new file mode 100644
index 0000000..744a63d
--- /dev/null
+++ b/tests/error.2
@@ -0,0 +1,18 @@
+#! nft -f
+
+# mixed syntactical and non-syntactical errors in blocks
+table filter {
+	# missing identifier
+	chain
+
+	# missing chain block
+	chain output
+
+	chain output {
+		tcp
+		tcp dport
+		tcp dport tcp
+		tcp dport tcp dport
+		tcp dport ssh
+	}
+}
-- 
1.8.5.3

