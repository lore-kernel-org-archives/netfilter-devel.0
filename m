Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E3BC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58CE460F6B
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244032AbhIFQbC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 12:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243932AbhIFQbB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 12:31:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E7AC061575
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 09:29:57 -0700 (PDT)
Received: from localhost ([::1]:42314 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mNHVK-0008D9-Lb; Mon, 06 Sep 2021 18:29:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/7] tests: xlate-test: Don't skip any input after the first empty line
Date:   Mon,  6 Sep 2021 18:30:33 +0200
Message-Id: <20210906163038.15381-2-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906163038.15381-1-phil@nwl.cc>
References: <20210906163038.15381-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In conditionals, testing the empty string evaluates to false. This is
dumb but seems intentional, as readline() method returns an empty string
at EOF. This is distinct from reading an empty line as the latter
contains the newline character - unless it is stripped in between
readline() and conditional. The fixed commit introduced just that by
accident, effectively reducing any test file to the first contained
test:

| $ ./xlate-test.py
| [...]
| 81 test files, 84 tests, 84 tests passed, 0 tests failed, 0 errors

With this change in place, the summary looks much better:

| 81 test files, 368 tests, 368 tests passed, 0 tests failed, 0 errors

Fixes: 62828a6aff231 ("tests: xlate-test: support multiline expectation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index cba98b6e8e491..1fa5eca3e0764 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -48,9 +48,9 @@ def run_test(name, payload):
             if process.returncode == 0:
                 translation = output.decode("utf-8").rstrip(" \n")
                 expected = payload.readline().rstrip(" \n")
-                next_expected = payload.readline().rstrip(" \n")
+                next_expected = payload.readline()
                 if next_expected.startswith("nft"):
-                    expected += "\n" + next_expected
+                    expected += "\n" + next_expected.rstrip(" \n")
                     line = payload.readline()
                 else:
                     line = next_expected
-- 
2.33.0

