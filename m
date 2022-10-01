Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C2EC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Oct 2022 09:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJAJnu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJAJnX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Oct 2022 05:43:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E849643178
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Oct 2022 02:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YoVBqFLsEf6i+B2OnWgoX1Gl8qb72kwBNuKzgyAJQgg=; b=nsT8GArYESAg62GBsuDT4CnqEA
        hac9f5d72PDf7FezGqzOQs67m/AVJiDuMINOSh3wQcgLCd3NaBDu5EwD8OSYU0chBmY4Bbzh+6ipx
        1vhOHCq0hv4izIeM7rW9m5ZsuF8Qoujafxo6JtU/Fn/UtPr9RUt7FFhXDlIPBDBC8mf9l8c75FqI6
        QO3c0CT3CccCJBGCajXHkr9/mDBKgc1dtLmtBxF41xq2AhPTjw7LJ4igo7nLvV/AvNXXntWsSqqwy
        FcjDErMPY8eGefe0NK+6DUxdnIzunUhO4XMEZwJ/TUtjGwWKmYvnx85f7Gh9Syszv+BDTHQB9+Lmk
        CTy+FTbQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oeZ1j-0006RH-9y
        for netfilter-devel@vger.kernel.org; Sat, 01 Oct 2022 11:43:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/4] tests: iptables-test: Test both variants by default
Date:   Sat,  1 Oct 2022 11:43:10 +0200
Message-Id: <20221001094310.29452-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221001094310.29452-1-phil@nwl.cc>
References: <20221001094310.29452-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Via '--legacy' and '--nftables' flags one may choose the variant to
test. Change the default (none of them given) from legacy to both,
by effectively running twice. Prefix the summary line with the tested
variant for clarity and print a total count line as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 84 +++++++++++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 33 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 6504b231666d1..b5a70e44b9e44 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -408,10 +408,13 @@ def main():
         show_missing()
         return
 
-    global EXECUTABLE
-    EXECUTABLE = "xtables-legacy-multi"
+    variants = []
+    if args.legacy:
+        variants.append("legacy")
     if args.nftables:
-        EXECUTABLE = "xtables-nft-multi"
+        variants.append("nft")
+    if len(variants) == 0:
+        variants = [ "legacy", "nft" ]
 
     if os.getuid() != 0:
         print("You need to be root to run this, sorry", file=sys.stderr)
@@ -426,36 +429,51 @@ def main():
         os.putenv("PATH", "%s/iptables:%s" % (os.path.abspath(os.path.curdir),
                                               os.getenv("PATH")))
 
-    test_files = 0
-    tests = 0
-    passed = 0
-
-    # setup global var log file
-    global log_file
-    try:
-        log_file = open(LOGFILE, 'w')
-    except IOError:
-        print("Couldn't open log file %s" % LOGFILE, file=sys.stderr)
-        return
-
-    if args.filename:
-        file_list = args.filename
-    else:
-        file_list = [os.path.join(EXTENSIONS_PATH, i)
-                     for i in os.listdir(EXTENSIONS_PATH)
-                     if i.endswith('.t')]
-        file_list.sort()
-
-    for filename in file_list:
-        file_tests, file_passed = run_test_file(filename, args.netns)
-        if file_tests:
-            tests += file_tests
-            passed += file_passed
-            test_files += 1
-
-    print("%d test files, %d unit tests, %d passed" % (test_files, tests, passed))
-    return passed - tests
-
+    total_test_files = 0
+    total_passed = 0
+    total_tests = 0
+    for variant in variants:
+        global EXECUTABLE
+        EXECUTABLE = "xtables-" + variant + "-multi"
+
+        test_files = 0
+        tests = 0
+        passed = 0
+
+        # setup global var log file
+        global log_file
+        try:
+            log_file = open(LOGFILE, 'w')
+        except IOError:
+            print("Couldn't open log file %s" % LOGFILE, file=sys.stderr)
+            return
+
+        if args.filename:
+            file_list = args.filename
+        else:
+            file_list = [os.path.join(EXTENSIONS_PATH, i)
+                         for i in os.listdir(EXTENSIONS_PATH)
+                         if i.endswith('.t')]
+            file_list.sort()
+
+        for filename in file_list:
+            file_tests, file_passed = run_test_file(filename, args.netns)
+            if file_tests:
+                tests += file_tests
+                passed += file_passed
+                test_files += 1
+
+        print("%s: %d test files, %d unit tests, %d passed"
+              % (variant, test_files, tests, passed))
+
+        total_passed += passed
+        total_tests += tests
+        total_test_files = max(total_test_files, test_files)
+
+    if len(variants) > 1:
+        print("total: %d test files, %d unit tests, %d passed"
+              % (total_test_files, total_tests, total_passed))
+    return total_passed - total_tests
 
 if __name__ == '__main__':
     sys.exit(main())
-- 
2.34.1

