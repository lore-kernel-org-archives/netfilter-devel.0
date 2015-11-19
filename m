From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 1/2] tests: regression: homogenize indentation style
Date: Thu, 19 Nov 2015 19:51:48 +0100
Message-ID: <1447959109-17295-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37797 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081AbbKSSwH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2015 13:52:07 -0500
Received: by wmww144 with SMTP id w144so129427177wmw.0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2015 10:52:06 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Python interpreter doesn't like mixed indentation. So in order to
prevent future problems, this commit replace some tabs found in the
script with space indentation.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 tests/regression/nft-test.py | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index d2fbe45..ed9653d 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -499,7 +499,7 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
             payload_log = open("%s.payload" % filename_path)
 
         if rule[1].strip() == "ok":
-	    try:
+            try:
                 payload_expected.index(rule[0])
             except (ValueError):
                 payload_expected = payload_find_expected(payload_log, rule[0])
@@ -553,7 +553,7 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
                         if line == "":
                             break
                         gotf.write(line)
-	            gotf.close()
+                    gotf.close()
                     print_warning("Wrote payload for rule %s" % rule[0], gotf.name, 1)
 
             # Check output of nft
@@ -722,8 +722,8 @@ def payload_find_expected(payload_log, rule):
 
     while True:
         line = payload_log.readline()
-	if not line:
-	    break
+        if not line:
+            break
 
         if line[0] == "#":  # rule start
             rule_line = line.strip()[2:]
@@ -910,7 +910,7 @@ def main():
 
     if not os.path.isdir("tests/regression/"):
         print "You have to run nft-test.py from the repository root directory, eg.\n\n" + \
-            "	nftables# python tests/regression/nft-test.py\n"
+            "    nftables# python tests/regression/nft-test.py\n"
         return
 
     test_files = files_ok = run_total = 0
-- 
2.6.2

