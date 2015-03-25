From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] nft-test: don't use colors if output is not a tty
Date: Wed, 25 Mar 2015 07:31:50 +0000
Message-ID: <1427268710-2889-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, anarey@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44768 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbCYHby (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 03:31:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 tests/regression/nft-test.py | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 2677127..559ad41 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -31,12 +31,18 @@ signal_received = 0
 
 
 class Colors:
-    HEADER = '\033[95m'
-    GREEN = '\033[92m'
-    YELLOW = '\033[93m'
-    RED = '\033[91m'
-    ENDC = '\033[0m'
-
+    if sys.stdout.isatty():
+        HEADER = '\033[95m'
+        GREEN = '\033[92m'
+        YELLOW = '\033[93m'
+        RED = '\033[91m'
+        ENDC = '\033[0m'
+    else:
+        HEADER = ''
+        GREEN = ''
+        YELLOW = ''
+        RED = ''
+        ENDC = ''
 
 def print_error(reason, filename=None, lineno=None):
     '''
-- 
2.1.0

