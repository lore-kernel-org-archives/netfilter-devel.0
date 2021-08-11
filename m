Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E2EC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 22:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F75C61008
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 22:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbhHKWyE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 18:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbhHKWyE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 18:54:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037F9C061765
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 15:53:40 -0700 (PDT)
Received: from localhost ([::1]:56310 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mDx6Q-0005Pc-Ek; Thu, 12 Aug 2021 00:53:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/3] tests: json_echo: Print errors to stderr
Date:   Thu, 12 Aug 2021 00:53:25 +0200
Message-Id: <20210811225327.26229-1-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Apart from the obvious, this fixes exit_dump() which tried to dump the
wrong variable ('out' instead of 'obj') and missed that json.dumps()
doesn't print but just returns a string. Make it call exit_err() to
share some code, which changes the prefix from 'FAIL' to 'Error' as a
side-effect.

While being at it, fix for a syntax warning with newer Python in
unrelated code.

Fixes: bb32d8db9a125 ("JSON: Add support for echo option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/json_echo/run-test.py | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
index 36a377ac95eec..a6bdfc61afd7b 100755
--- a/tests/json_echo/run-test.py
+++ b/tests/json_echo/run-test.py
@@ -95,25 +95,25 @@ add_quota = { "add": {
 # helper functions
 
 def exit_err(msg):
-    print("Error: %s" %msg)
+    print("Error: %s" %msg, file=sys.stderr)
     sys.exit(1)
 
 def exit_dump(e, obj):
-    print("FAIL: {}".format(e))
-    print("Output was:")
-    json.dumps(out, sort_keys = True, indent = 4, separators = (',', ': '))
-    sys.exit(1)
+    msg = "{}\n".format(e)
+    msg += "Output was:\n"
+    msg += json.dumps(obj, sort_keys = True, indent = 4, separators = (',', ': '))
+    exit_err(msg)
 
 def do_flush():
     rc, out, err = nftables.json_cmd({ "nftables": [flush_ruleset] })
-    if not rc is 0:
+    if rc != 0:
         exit_err("flush ruleset failed: {}".format(err))
 
 def do_command(cmd):
     if not type(cmd) is list:
         cmd = [cmd]
     rc, out, err = nftables.json_cmd({ "nftables": cmd })
-    if not rc is 0:
+    if rc != 0:
         exit_err("command failed: {}".format(err))
     return out
 
-- 
2.32.0

