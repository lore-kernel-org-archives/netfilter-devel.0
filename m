From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/5] tests: regression: fix "Listing is broken" instead of output mismatch
Date: Mon,  1 Dec 2014 12:45:52 +0100
Message-ID: <1417434354-5782-4-git-send-email-pablo@netfilter.org>
References: <1417434354-5782-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41622 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaLALnq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:43:46 -0500
In-Reply-To: <1417434354-5782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the output string doesn't match the input, indicate that the output
mismatches instead of the misleading "Listing is broken".

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/nft-test.py |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index e1aec89..9998ab3 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -505,15 +505,12 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
                                                         rule_output, cmd)
                                 if not force_all_family_option:
                                     return [ret, warning, error, unit_tests]
-                            if rule[0].find(rule_output.split(" ")[0]) > -1:
-                                warning += 1
-                                print_differences_warning(filename, lineno,
-                                                          rule[0], rule_output,
-                                                          cmd)
-                            else:
-                                error += 1
-                                print_differences_error(filename, lineno,
-                                                        rule_output, cmd)
+
+                            warning += 1
+                            print_differences_warning(filename, lineno,
+                                                      rule[0], rule_output,
+                                                      cmd)
+
                             if not force_all_family_option:
                                 return [ret, warning, error, unit_tests]
 
-- 
1.7.10.4

