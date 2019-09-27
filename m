Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44EC0C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 12:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20B45217D9
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 12:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfI0M50 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 08:57:26 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:49858 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbfI0M50 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 08:57:26 -0400
Received: from localhost ([::1]:34716 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDpoL-0005i7-7Q; Fri, 27 Sep 2019 14:57:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] iptables-test: Run tests in lexical order
Date:   Fri, 27 Sep 2019 14:57:16 +0200
Message-Id: <20190927125716.1769-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To quickly see if a given test was run or not, sort the file list. Also
filter non-test files right when preparing the list.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 2aac8ef2256dc..fdb4e6a3644e4 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -359,10 +359,14 @@ def main():
         print("Couldn't open log file %s" % LOGFILE)
         return
 
-    file_list = [os.path.join(EXTENSIONS_PATH, i)
-                 for i in os.listdir(EXTENSIONS_PATH)]
     if args.filename:
         file_list = [args.filename]
+    else:
+        file_list = [os.path.join(EXTENSIONS_PATH, i)
+                     for i in os.listdir(EXTENSIONS_PATH)
+                     if i.endswith('.t')]
+        file_list.sort()
+
     for filename in file_list:
         file_tests, file_passed = run_test_file(filename, args.netns)
         if file_tests:
-- 
2.23.0

