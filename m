Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35900C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB9360F45
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244178AbhIFQbj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 12:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244185AbhIFQbc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 12:31:32 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FAEC061575
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 09:30:28 -0700 (PDT)
Received: from localhost ([::1]:42358 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mNHVq-0008Eo-I5; Mon, 06 Sep 2021 18:30:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/7] tests: xlate-test: Print errors to stderr
Date:   Mon,  6 Sep 2021 18:30:34 +0200
Message-Id: <20210906163038.15381-3-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906163038.15381-1-phil@nwl.cc>
References: <20210906163038.15381-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Return code is always zero, so grepping for output on stderr is a
simple way to detect testsuite failures.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 1fa5eca3e0764..bb7a447dc799e 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -75,7 +75,7 @@ def run_test(name, payload):
     if (passed == tests) and not args.test:
         print(name + ": " + green("OK"))
     if not test_passed:
-        print("\n".join(result))
+        print("\n".join(result), file=sys.stderr)
     if args.test:
         print("1 test file, %d tests, %d tests passed, %d tests failed, %d errors" % (tests, passed, failed, errors))
     else:
@@ -111,7 +111,7 @@ def main():
             with open(args.test, "r") as payload:
                 run_test(args.test, payload)
         except IOError:
-            print(red("Error: ") + "test file does not exist")
+            print(red("Error: ") + "test file does not exist", file=sys.stderr)
     else:
         load_test_files()
 
-- 
2.33.0

