Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999AAC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 22:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6536C64F4A
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 22:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhBCWq5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 17:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhBCWq5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 17:46:57 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B102C061573
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Feb 2021 14:46:17 -0800 (PST)
Received: from localhost ([::1]:39968 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1l7Quc-0003gc-1c; Wed, 03 Feb 2021 23:46:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] tests/py: Write dissenting payload into the right file
Date:   Wed,  3 Feb 2021 23:46:04 +0100
Message-Id: <20210203224605.8140-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The testsuite supports diverging payloads depending on table family.
This is necessary since for some families, dependency matches are
created.
If a payload mismatch happens, record it into a "got"-file which matches
the family-specific payload file, not the common one. This eases use of
diff-tools a lot as the extra other families' payloads confuse the
tools.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 7ca5a22a16fbf..18e9c67fa26be 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -712,8 +712,10 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
     if rule[1].strip() == "ok":
         payload_expected = None
+        payload_path = None
         try:
             payload_log = open("%s.payload" % filename_path)
+            payload_path = payload_log.name
             payload_expected = payload_find_expected(payload_log, rule[0])
         except:
             payload_log = None
@@ -756,6 +758,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
             table_payload_expected = None
             try:
                 payload_log = open("%s.payload.%s" % (filename_path, table.family))
+                payload_path = payload_log.name
                 table_payload_expected = payload_find_expected(payload_log, rule[0])
             except:
                 if not payload_log:
@@ -802,7 +805,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
             if state == "ok" and not payload_check(table_payload_expected,
                                                    payload_log, cmd):
                 error += 1
-                gotf = open("%s.payload.got" % filename_path, 'a')
+                gotf = open("%s.got" % payload_path, 'a')
                 payload_log.seek(0, 0)
                 gotf.write("# %s\n" % rule[0])
                 while True:
-- 
2.28.0

