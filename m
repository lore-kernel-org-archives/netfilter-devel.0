Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAE2C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7653260F6B
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244065AbhIFQbM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 12:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243932AbhIFQbL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 12:31:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19B7C061575
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 09:30:06 -0700 (PDT)
Received: from localhost ([::1]:42334 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mNHVV-0008EU-9i; Mon, 06 Sep 2021 18:30:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/7] tests: xlate-test: Exit non-zero on error
Date:   Mon,  6 Sep 2021 18:30:36 +0200
Message-Id: <20210906163038.15381-5-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906163038.15381-1-phil@nwl.cc>
References: <20210906163038.15381-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a test fails, return a non-zero exit code. To do so, propagate the
pass/fail statistics up to main() for evaluation. While being at it,
move the statistics printing into there as well and get rid of that
redundant assignment to 'test_passed'.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index bb7a447dc799e..4a56e798b9587 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -61,7 +61,6 @@ def run_test(name, payload):
                     result.append(magenta("src: ") + line.rstrip(" \n"))
                     result.append(magenta("exp: ") + expected)
                     result.append(magenta("res: ") + translation + "\n")
-                    test_passed = False
                 else:
                     passed += 1
             else:
@@ -76,10 +75,7 @@ def run_test(name, payload):
         print(name + ": " + green("OK"))
     if not test_passed:
         print("\n".join(result), file=sys.stderr)
-    if args.test:
-        print("1 test file, %d tests, %d tests passed, %d tests failed, %d errors" % (tests, passed, failed, errors))
-    else:
-        return tests, passed, failed, errors
+    return tests, passed, failed, errors
 
 
 def load_test_files():
@@ -93,10 +89,9 @@ def load_test_files():
                 total_passed += passed
                 total_failed += failed
                 total_error += errors
+    return (test_files, total_tests, total_passed, total_failed, total_error)
 
 
-    print("%d test files, %d tests, %d tests passed, %d tests failed, %d errors" % (test_files, total_tests, total_passed, total_failed, total_error))
-
 def main():
     global xtables_nft_multi
     if not args.host:
@@ -104,16 +99,27 @@ def main():
         xtables_nft_multi = os.path.abspath(os.path.curdir) \
                             + '/iptables/' + xtables_nft_multi
 
+    files = tests = passed = failed = errors = 0
     if args.test:
         if not args.test.endswith(".txlate"):
             args.test += ".txlate"
         try:
             with open(args.test, "r") as payload:
-                run_test(args.test, payload)
+                files = 1
+                tests, passed, failed, errors = run_test(args.test, payload)
         except IOError:
             print(red("Error: ") + "test file does not exist", file=sys.stderr)
+            return -1
+    else:
+        files, tests, passed, failed, errors = load_test_files()
+
+    if files > 1:
+        file_word = "files"
     else:
-        load_test_files()
+        file_word = "file"
+    print("%d test %s, %d tests, %d tests passed, %d tests failed, %d errors"
+            % (files, file_word, tests, passed, failed, errors))
+    return passed - tests
 
 
 parser = argparse.ArgumentParser()
@@ -121,4 +127,4 @@ parser.add_argument('-H', '--host', action='store_true',
                     help='Run tests against installed binaries')
 parser.add_argument("test", nargs="?", help="run only the specified test file")
 args = parser.parse_args()
-main()
+sys.exit(main())
-- 
2.33.0

