From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 3/3] tests: fix crash when rule test is malformed
Date: Tue,  1 Dec 2015 23:45:23 +0100
Message-ID: <1449009923-10726-3-git-send-email-pablombg@gmail.com>
References: <1449009923-10726-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:33616 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbbLAWqL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2015 17:46:11 -0500
Received: by wmec201 with SMTP id c201so227976091wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Dec 2015 14:46:09 -0800 (PST)
In-Reply-To: <1449009923-10726-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The tests script suffers a crash when a rule test line is malformed
(e.g. if expected result is missing). This commit fixes these crashes
and now the line is skipped and a warning is printed.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 tests/regression/nft-test.py | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 9d623b7..e68087f 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -508,12 +508,6 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
                     print_error("did not find payload information for rule '%s'" % rule[0], payload_log.name, 1)
 
         for chain in chain_list:
-            if len(rule) == 1:
-                reason = "Skipping malformed test. (" + \
-                    str(rule[0].rstrip('\n')) + ")"
-                print_warning(reason, filename, lineno)
-                continue
-
             unit_tests += 1
             table_flush(table, filename, lineno)
             table_info = " " + table[0] + " " + table[1] + " "
@@ -808,6 +802,11 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
         # Rule
         rule = line.split(';')  # rule[1] Ok or FAIL
+        if len(rule) == 1 or len(rule) > 3 or rule[1].rstrip() not in {"ok", "fail"}:
+            reason = "Skipping malformed rule test. (" + line.rstrip('\n') + ")"
+            print_warning(reason, filename, lineno)
+            continue
+
         if line[0] == "-":  # Run omitted lines
             if need_fix_option:
                 rule[0] = rule[0].rstrip()[1:].strip()
-- 
2.6.2

