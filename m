Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBCDC2D0E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 18:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A75B2466D
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 18:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbgKQSHO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 13:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbgKQSHN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 13:07:13 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC993C0613CF
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2020 10:07:13 -0800 (PST)
Received: from localhost ([::1]:53854 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kf5No-00010q-AI; Tue, 17 Nov 2020 19:07:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] iptables-test.py: Try to unshare netns by default
Date:   Tue, 17 Nov 2020 19:06:58 +0100
Message-Id: <20201117180658.31425-2-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117180658.31425-1-phil@nwl.cc>
References: <20201117180658.31425-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user did not explicitly requst to "test netnamespace path", try an
import of 'unshare' module and call unshare() to avoid killing the local
host's network by accident.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/iptables-test.py b/iptables-test.py
index 52897a5d93ced..ca5efb1b6670b 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -366,6 +366,13 @@ def main():
                      if i.endswith('.t')]
         file_list.sort()
 
+    if not args.netns:
+        try:
+            import unshare
+            unshare.unshare(unshare.CLONE_NEWNET)
+        except:
+            print("Cannot run in own namespace, connectivity might break")
+
     for filename in file_list:
         file_tests, file_passed = run_test_file(filename, args.netns)
         if file_tests:
-- 
2.28.0

