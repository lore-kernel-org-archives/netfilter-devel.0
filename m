Return-Path: <SRS0=pwfE=YW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8D8CA9EAE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 11:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C91BE20663
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 11:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfJ2LZT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Oct 2019 07:25:19 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42114 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfJ2LZT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Oct 2019 07:25:19 -0400
Received: from localhost ([::1]:55204 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPPcj-0004c7-BM; Tue, 29 Oct 2019 12:25:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests/py: Fix test script for Python3 tempfile
Date:   Tue, 29 Oct 2019 12:25:08 +0100
Message-Id: <20191029112508.16502-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When instantiating a temporary file using tempfile's TemporaryFile()
constructor, the resulting object's 'name' attribute is of type int.
This in turn makes print_msg() puke while trying to concatenate string
and int using '+' operator.

Fix this by using format strings consequently, thereby cleaning up code
a bit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index bc0849e0410b5..ce42b5ddb1cca 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -115,12 +115,12 @@ def print_msg(reason, errstr, filename=None, lineno=None, color=None):
     '''
     Prints a message with nice colors, indicating file and line number.
     '''
+    color_errstr = "%s%s%s" % (color, errstr, Colors.ENDC)
     if filename and lineno:
-        sys.stderr.write(filename + ": " + color + errstr + Colors.ENDC + \
-              " line %d: %s" % (lineno + 1, reason))
+        sys.stderr.write("%s: %s line %d: %s\n" %
+                         (filename, color_errstr, lineno + 1, reason))
     else:
-        sys.stderr.write(color + errstr + Colors.ENDC + " %s" % reason)
-    sys.stderr.write("\n")
+        sys.stderr.write("%s %s\n" % (color_errstr, reason))
     sys.stderr.flush() # So that the message stay in the right place.
 
 
-- 
2.23.0

