Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99FDC47255
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB3BB206F9
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgEKNhx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 09:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726934AbgEKNhx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 09:37:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D06AC061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 06:37:53 -0700 (PDT)
Received: from localhost ([::1]:42682 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jY8cx-00024q-RJ; Mon, 11 May 2020 15:37:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] iptables-test: Don't choke on empty lines
Date:   Mon, 11 May 2020 15:37:43 +0200
Message-Id: <20200511133743.10938-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The script code wasn't expecting empty lines:

| Traceback (most recent call last):
|   File "./iptables-test.py", line 380, in <module>
|     main()
|   File "./iptables-test.py", line 370, in main
|     file_tests, file_passed = run_test_file(filename, args.netns)
|   File "./iptables-test.py", line 265, in run_test_file
|     if item[1] == "=":
| IndexError: list index out of range

Fix this by ignoring empty lines or those consisting of whitespace only.

While being at it, remove the empty line from libxt_IDLETIMER.t which
exposed the problem.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_IDLETIMER.t | 1 -
 iptables-test.py             | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/extensions/libxt_IDLETIMER.t b/extensions/libxt_IDLETIMER.t
index d13b119e98e03..e8f306d2462c7 100644
--- a/extensions/libxt_IDLETIMER.t
+++ b/extensions/libxt_IDLETIMER.t
@@ -3,4 +3,3 @@
 -j IDLETIMER --timeout 42;;FAIL
 -j IDLETIMER --timeout 42 --label foo;=;OK
 -j IDLETIMER --timeout 42 --label foo --alarm;;OK
-
diff --git a/iptables-test.py b/iptables-test.py
index e986d7a318218..6b6eb611a7290 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -221,7 +221,7 @@ def run_test_file(filename, netns):
         execute_cmd("ip netns add ____iptables-container-test", filename, 0)
 
     for lineno, line in enumerate(f):
-        if line[0] == "#":
+        if line[0] == "#" or len(line.strip()) == 0:
             continue
 
         if line[0] == ":":
-- 
2.25.1

