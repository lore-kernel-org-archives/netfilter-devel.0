Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4FFC31E5E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 13:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B91882183F
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 13:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfFSNjF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 09:39:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfFSNjF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 09:39:05 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DFFCA8831C;
        Wed, 19 Jun 2019 13:39:04 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-121-240.rdu2.redhat.com [10.10.121.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69AD7619B0;
        Wed, 19 Jun 2019 13:39:04 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        shekhar sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: replace calls to cmp()
Date:   Wed, 19 Jun 2019 09:38:52 -0400
Message-Id: <20190619133852.8660-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 19 Jun 2019 13:39:04 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

cmp() is not in python3.

Signed-off-by: Eric Garver <eric@garver.life>
---
 tests/py/nft-test.py | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 4da6fa650f6d..c712c1d9ebef 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -488,12 +488,11 @@ def set_check_element(rule1, rule2):
     '''
     Check if element exists in anonymous sets.
     '''
-    ret = -1
     pos1 = rule1.find("{")
     pos2 = rule2.find("{")
 
-    if (cmp(rule1[:pos1], rule2[:pos2]) != 0):
-        return ret;
+    if (rule1[:pos1] != rule2[:pos2]):
+        return False
 
     end1 = rule1.find("}")
     end2 = rule2.find("}")
@@ -503,13 +502,12 @@ def set_check_element(rule1, rule2):
         list2 = (rule2[pos2 + 1:end2].replace(" ", "")).split(",")
         list1.sort()
         list2.sort()
-        if cmp(list1, list2) == 0:
-            ret = 0
+        if list1 != list2:
+            return False
 
-    if ret != 0:
-        return ret
+        return rule1[end1:] == rule2[end2:]
 
-    return cmp(rule1[end1:], rule2[end2:])
+    return False
 
 
 def obj_add(o, test_result, filename, lineno):
@@ -842,8 +840,8 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
             if rule_output.rstrip() != teoric_exit.rstrip():
                 if rule[0].find("{") != -1:  # anonymous sets
-                    if set_check_element(teoric_exit.rstrip(),
-                                         rule_output.rstrip()) != 0:
+                    if not set_check_element(teoric_exit.rstrip(),
+                                             rule_output.rstrip()):
                         warning += 1
                         retest_output = True
                         print_differences_warning(filename, lineno,
-- 
2.20.1

