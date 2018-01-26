From: Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] tests: xlate-test: no need to require superuser privileges
Date: Fri, 26 Jan 2018 23:31:48 +0100
Message-ID: <20180126223148.685-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60450 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751321AbeAZWb7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jan 2018 17:31:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 xlate-test.py | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 53b035c7..dbba1d67 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -86,9 +86,7 @@ def load_test_files():
     print("%d test files, %d tests, %d tests passed, %d tests failed, %d errors" % (test_files, total_tests, total_passed, total_failed, total_error))
 
 def main():
-    if os.getuid() != 0:
-        print(red("Error: ") + "You need to be root to run this, sorry")
-    elif args.test:
+    if args.test:
         if not args.test.endswith(".txlate"):
             args.test += ".txlate"
         try:
-- 
2.14.3

