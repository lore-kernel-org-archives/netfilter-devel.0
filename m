From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/4] tests: regression: simplify run_test_file() in case `-e' is used
Date: Sun, 14 Dec 2014 18:01:02 +0100
Message-ID: <1418576463-3606-4-git-send-email-pablo@netfilter.org>
References: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45135 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaLNQ6y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:58:54 -0500
In-Reply-To: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Avoid copy&paste coding style pattern by simplifying the code that
handles the `-e' option that allows us to run known broken tests.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/nft-test.py |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index dea0f36..7e5b475 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -692,23 +692,9 @@ def run_test_file(filename, force_all_family_option, specific_file):
                 continue
             if need_fix_option:
                 rule[0] = rule[0].rstrip()[1:].strip()
-                result = rule_add(rule, table_list, chain_list, filename,
-                                  lineno, force_all_family_option)
-                tests += 1
-                warning = result[1]
-                ret = result[0]
-                total_warning += warning
-                total_error += result[2]
-                total_unit_run += result[3]
-
-                if ret != 0:
-                    total_test_passed = False
-                elif warning == 0:
-                    passed += 1
-                continue
             else:
                 continue
-        if need_fix_option:
+        elif need_fix_option:
             continue
 
         result = rule_add(rule, table_list, chain_list, filename, lineno,
-- 
1.7.10.4

