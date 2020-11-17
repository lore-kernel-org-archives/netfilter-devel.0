Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906FFC6379F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 18:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44A942225E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Nov 2020 18:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgKQSHJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 13:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbgKQSHJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 13:07:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E119C0613CF
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2020 10:07:09 -0800 (PST)
Received: from localhost ([::1]:53848 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kf5Nj-00010k-0j; Tue, 17 Nov 2020 19:07:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] iptables-test.py: Accept multiple test files on commandline
Date:   Tue, 17 Nov 2020 19:06:57 +0100
Message-Id: <20201117180658.31425-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to call the script like so:

| # ./iptables-test.py -n extensions/libebt_*.t

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 6b6eb611a7290..52897a5d93ced 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -310,7 +310,7 @@ def show_missing():
 #
 def main():
     parser = argparse.ArgumentParser(description='Run iptables tests')
-    parser.add_argument('filename', nargs='?',
+    parser.add_argument('filename', nargs='*',
                         metavar='path/to/file.t',
                         help='Run only this test')
     parser.add_argument('-H', '--host', action='store_true',
@@ -359,7 +359,7 @@ def main():
         return
 
     if args.filename:
-        file_list = [args.filename]
+        file_list = args.filename
     else:
         file_list = [os.path.join(EXTENSIONS_PATH, i)
                      for i in os.listdir(EXTENSIONS_PATH)
-- 
2.28.0

