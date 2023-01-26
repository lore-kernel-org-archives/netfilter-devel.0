Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C0BC54E94
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 12:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbjAZMYR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Jan 2023 07:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjAZMYQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2023 07:24:16 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9C01BAEB
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2023 04:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/FFCW9GhpZrLEmSXj82OYUi/+evxb/w1ECd0BdOrhng=; b=SQn9eGPdyF16FewtUqxduEV8FN
        nvPzJf1X7hqbv7Ne3qPAL4TxMls8/A/X4qykp02hOm0PkrAwRC6MZdfv6S+rKxAhPZw6joLdkdlP0
        7zLM3iRXm2LCEupaNxRE0QZ7IiDe2cnAAYa052kso1+G/e/YFxPyI67ArgHaOJW6jz4ifHY1gMlCy
        vBi7DgWDzCWdLW0zfCWugLoE1jCLLl0Ifk5wyXL9YvPWP/47lrL23u6NpjMiwo/AyGEmPdcY03JXz
        kekvtAoke1n40I9ADSLwcLqs1FG6mL0SBb1zo62+tePt+VgECbvLERE4AIjBC5lDUN/p6mRA84vMy
        pjxpVh9Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pL1Ia-00056p-VN
        for netfilter-devel@vger.kernel.org; Thu, 26 Jan 2023 13:24:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 7/7] tests: xlate: Support testing multiple individual files
Date:   Thu, 26 Jan 2023 13:24:06 +0100
Message-Id: <20230126122406.23288-8-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230126122406.23288-1-phil@nwl.cc>
References: <20230126122406.23288-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Simple use-case: run xlate-test for ebtables-nft:

| % ./xlate-test.py extensions/libebt_*.txlate

The script interpreted all parameters as a single file.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 4cb1401b71677..1b544600aa242 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -241,17 +241,22 @@ xtables_nft_multi = 'xtables-nft-multi'
                             + '/iptables/' + xtables_nft_multi
 
     files = tests = passed = failed = errors = 0
-    if args.test:
-        if not args.test.endswith(".txlate"):
-            args.test += ".txlate"
+    for test in args.test:
+        if not test.endswith(".txlate"):
+            test += ".txlate"
         try:
-            with open(args.test, "r") as payload:
-                files = 1
-                tests, passed, failed, errors = run_test(args.test, payload)
+            with open(test, "r") as payload:
+                t, p, f, e = run_test(test, payload)
+                files += 1
+                tests += t
+                passed += p
+                failed += f
+                errors += e
         except IOError:
             print(red("Error: ") + "test file does not exist", file=sys.stderr)
             return 99
-    else:
+
+    if files == 0:
         files, tests, passed, failed, errors = load_test_files()
 
     if files > 1:
@@ -272,6 +277,6 @@ parser.add_argument('-n', '--nft', type=str, default='nft',
                     help='Replay using given nft binary (default: \'%(default)s\')')
 parser.add_argument('--no-netns', action='store_true',
                     help='Do not run testsuite in own network namespace')
-parser.add_argument("test", nargs="?", help="run only the specified test file")
+parser.add_argument("test", nargs="*", help="run only the specified test file(s)")
 args = parser.parse_args()
 sys.exit(main())
-- 
2.38.0

