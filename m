Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09EDC282E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 12:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1519B20678
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 12:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfDYM7x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 08:59:53 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:55862 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfDYM7x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 08:59:53 -0400
Received: from localhost ([::1]:40720 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hJdyh-0007qy-SO; Thu, 25 Apr 2019 14:59:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/4] tests/py: Fix error messages in chain_delete()
Date:   Thu, 25 Apr 2019 14:59:41 +0200
Message-Id: <20190425125943.15787-3-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190425125943.15787-1-phil@nwl.cc>
References: <20190425125943.15787-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adding string and chain object is an illegal operation in Python.
Instead concatenate with cmd string since that contains all required
information already.

Fixes: 820fd08b5f1d4 ("tests/py: Review print statements in nft-test.py")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 5c7e28a070204..1c0afd0ec0eb3 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -310,14 +310,14 @@ def chain_delete(chain, table, filename=None, lineno=None):
     cmd = "flush chain %s %s" % (table, chain)
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
-        reason = "I cannot flush this chain " + chain
+        reason = "I cannot " + cmd
         print_error(reason, filename, lineno)
         return -1
 
     cmd = "delete chain %s %s" % (table, chain)
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
-        reason = cmd + "I cannot delete this chain " + chain
+        reason = "I cannot " + cmd
         print_error(reason, filename, lineno)
         return -1
 
-- 
2.21.0

