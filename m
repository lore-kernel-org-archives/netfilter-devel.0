From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/6 nft] tests: regression: reduce code duplication a bit on error reporting
Date: Tue,  2 Jun 2015 19:03:06 +0200
Message-ID: <1433264587-29705-6-git-send-email-pablo@netfilter.org>
References: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49744 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759618AbbFBQ6C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 12:58:02 -0400
In-Reply-To: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Consolidate print_err() and print_warning() into print_msg() to reduce code
duplication.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/nft-test.py |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 559ad41..7823f44 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -44,26 +44,21 @@ class Colors:
         RED = ''
         ENDC = ''
 
-def print_error(reason, filename=None, lineno=None):
+def print_msg(reason, filename=None, lineno=None, color=None, errstr=None):
     '''
-    Prints an error with nice colors, indicating file and line number.
+    Prints a message with nice colors, indicating file and line number.
     '''
     if filename and lineno:
-        print (filename + ": " + Colors.RED + "ERROR:" +
+        print (filename + ": " + color + "ERROR:" +
                Colors.ENDC + " line %d: %s" % (lineno + 1, reason))
     else:
-        print (Colors.RED + "ERROR:" + Colors.ENDC + " %s" % (reason))
+        print (color + "ERROR:" + Colors.ENDC + " %s" % (reason))
 
+def print_error(reason, filename=None, lineno=None):
+    print_msg(reason, filename, lineno, Colors.RED, "ERROR:")
 
 def print_warning(reason, filename=None, lineno=None):
-    '''
-    Prints a warning with nice colors, indicating file and line number.
-    '''
-    if filename and lineno:
-        print (filename + ": " + Colors.YELLOW + "WARNING:" + \
-               Colors.ENDC + " line %d: %s" % (lineno + 1, reason))
-    else:
-        print (Colors.YELLOW + "WARNING:" + " %s" % (reason))
+    print_msg(reason, filename, lineno, Colors.YELLOW, "WARNING:")
 
 
 def print_differences_warning(filename, lineno, rule1, rule2, cmd):
-- 
1.7.10.4

