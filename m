Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AACC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A164660F45
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244137AbhIFQbW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 12:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243918AbhIFQbW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 12:31:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7D7C061575
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 09:30:17 -0700 (PDT)
Received: from localhost ([::1]:42346 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mNHVf-0008Ee-U4; Mon, 06 Sep 2021 18:30:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/7] tests: iptables-test: Fix missing chain case
Date:   Mon,  6 Sep 2021 18:30:32 +0200
Message-Id: <20210906163038.15381-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a chain line was really missing, Python complained about reference
before assignment of 'chain_array' variable. While being at it, reuse
print_error() function for reporting and allow to continue with the next
input file instead of exiting.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 90e07feed3658..01966f916957b 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -215,6 +215,7 @@ def run_test_file(filename, netns):
     tests = 0
     passed = 0
     table = ""
+    chain_array = []
     total_test_passed = True
 
     if netns:
@@ -249,8 +250,10 @@ def run_test_file(filename, netns):
             continue
 
         if len(chain_array) == 0:
-            print("broken test, missing chain, leaving")
-            sys.exit()
+            print_error("broken test, missing chain",
+                        filename = filename, lineno = lineno)
+            total_test_passed = False
+            break
 
         test_passed = True
         tests += 1
-- 
2.33.0

