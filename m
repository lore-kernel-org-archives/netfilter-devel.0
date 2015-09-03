From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: display error when trying to run tests out of the root directory
Date: Thu,  3 Sep 2015 19:48:54 +0200
Message-ID: <1441302534-2724-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51405 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbbICRm0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Sep 2015 13:42:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since 357d8cfcceb2 ("tests: use the src/nft binary instead of $PATH one"), the
tests fail if you try to run them if you are not under the root directory of
the nftables repository.

Display an error so I don't forget I have to do it like this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/nft-test.py |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index c3d2aae..8168203 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -879,6 +879,11 @@ def main():
         print "You need to be root to run this, sorry"
         return
 
+    if not os.path.isdir("tests/regression/"):
+        print "You have to run nft-test.py from the repository root directory, eg.\n\n" + \
+            "	nftables# python tests/regression/nft-test.py\n"
+        return
+
     test_files = files_ok = run_total = 0
     tests = passed = warnings = errors = 0
     global log_file
-- 
1.7.10.4

