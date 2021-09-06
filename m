Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A083C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51E4660F45
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 16:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243932AbhIFQbT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 12:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243918AbhIFQbR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 12:31:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3068DC061575
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 09:30:12 -0700 (PDT)
Received: from localhost ([::1]:42340 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mNHVa-0008EZ-JY; Mon, 06 Sep 2021 18:30:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/7] tests: iptables-test: Exit non-zero on error
Date:   Mon,  6 Sep 2021 18:30:37 +0200
Message-Id: <20210906163038.15381-6-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906163038.15381-1-phil@nwl.cc>
References: <20210906163038.15381-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If any test fails, return a non-zero exit code.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/iptables-test.py b/iptables-test.py
index 1790da3d0b074..5eafe5896414b 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -408,7 +408,8 @@ def main():
             test_files += 1
 
     print("%d test files, %d unit tests, %d passed" % (test_files, tests, passed))
+    return passed - tests
 
 
 if __name__ == '__main__':
-    main()
+    sys.exit(main())
-- 
2.33.0

