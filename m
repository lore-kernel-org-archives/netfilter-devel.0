From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/4] tests: regression: fix wrong number of test files
Date: Sun, 14 Dec 2014 18:01:01 +0100
Message-ID: <1418576463-3606-3-git-send-email-pablo@netfilter.org>
References: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45112 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaLNQ6o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:58:44 -0500
In-Reply-To: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Always increment the test file counter for each test file in the list.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/nft-test.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 9998ab3..dea0f36 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -830,6 +830,8 @@ def main():
         file_errors = result[3]
         file_unit_run = result[4]
 
+        test_files += 1
+
         if file_warnings == 0 and file_tests == file_passed:
             files_ok += 1
         if file_tests:
@@ -837,7 +839,6 @@ def main():
             passed += file_passed
             errors += file_errors
             warnings += file_warnings
-            test_files += 1
         if force_all_family_option:
             run_total += file_unit_run
 
-- 
1.7.10.4

