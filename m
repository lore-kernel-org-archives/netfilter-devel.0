Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9E3C04AB3
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 00:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359F82075E
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 00:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P8KdVy0D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfE1AhH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 20:37:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34959 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfE1AhH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 20:37:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id d126so8150746pfd.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2019 17:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=z2XkHZ10nDsnCSDYi5Plw2Z/B8Mw9lPeZMYmzDC94L4=;
        b=P8KdVy0Doimq+It5MWfaKDjoY5Xrwbn8DBRoFZX18JBnAFVjDFbLuIVyXnw8dKsVv9
         DKBKpWps8BXhSAjHi/qui1hZzHSvGlOtCJusAN3duylCF81mrFDsoCzFC56jgmU5Oy5r
         kVBxqLaiQtnIF9DWdW2znOOKH1WlQtGlRXMEo0lDzE6O+d6nREtubwEzVRVskVXsNBCm
         goRn2ZXvBR64bwNGhpMLvtfOViJjme7U4wLLssO0clHf1zJkbxeCDx0sg2m5j7+z82ny
         xXRXMUeCq3zXYDnDcKecej7UZL98829x4iW0d0LnKwbsGesuAg8LAE/sj2H21DVyiJvQ
         LarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z2XkHZ10nDsnCSDYi5Plw2Z/B8Mw9lPeZMYmzDC94L4=;
        b=nSddTlxKLiN1hdOsVwZAOoDekZnP996zKj261yuyjs8QKt5LXCeOGGNX1uXhJYgoW6
         o0XSpb5M02em6JPFjfEd8gZudnBmuzePuDw4IMe96Q2FurNBCI68JK5zczcWMj1gHwxb
         vASB28dIHQZP7gz07f3DwD+V9ykospYOD3CMdn9HokddZFFN35NTKutv0H3gQFqBZDYy
         bfoDZAJIHE/YV9P3amufyk+JX54oAnd6BJjPYIMtnp+Diq89UBEz2XBPKKaObR6fPn4t
         q7JZ+4LgUUDI8YMiC4hm1GAfZQjIKpRTGd96VuXxCKiciEFZ8WpZ0ipQQkN0S78aH1wB
         UIaA==
X-Gm-Message-State: APjAAAUhiFeaU/yXu2t0VXWG8pPUBcX0CLrJXhzWLyr9qRalZ22wwgYC
        hNjTBHgkmlY0RgeYwq5D2efVAV0W
X-Google-Smtp-Source: APXvYqwfDrEfCuBQUv1+3oZQnWtwAnFLwSn+9/PQn4HSGklVBU51FM6ebOAq+kgVjv0Wo0XqZp2vXA==
X-Received: by 2002:a17:90a:2e89:: with SMTP id r9mr1794968pjd.117.1559003826394;
        Mon, 27 May 2019 17:37:06 -0700 (PDT)
Received: from localhost.localdomain ([2409:4043:98d:28c6:c0fb:3264:16ab:2dfa])
        by smtp.gmail.com with ESMTPSA id w66sm13799805pfb.47.2019.05.27.17.37.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 17:37:05 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v2]tests: json_echo: convert to py3
Date:   Tue, 28 May 2019 06:06:53 +0530
Message-Id: <20190528003653.7565-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch converts the run-test.py file to run on both python3 and python2.
The version history of the patch is:
v1: modified print and other statments.
v2: updated the shebang and order of import statements.
 

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 tests/json_echo/run-test.py | 45 +++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
index 0132b139..dd7797fb 100755
--- a/tests/json_echo/run-test.py
+++ b/tests/json_echo/run-test.py
@@ -1,5 +1,6 @@
-#!/usr/bin/python2
+#!/usr/bin/python
 
+from __future__ import print_function
 import sys
 import os
 import json
@@ -13,8 +14,8 @@ from nftables import Nftables
 os.chdir(TESTS_PATH + "/../..")
 
 if not os.path.exists('src/.libs/libnftables.so'):
-    print "The nftables library does not exist. " \
-          "You need to build the project."
+    print("The nftables library does not exist. "
+          "You need to build the project.")
     sys.exit(1)
 
 nftables = Nftables(sofile = 'src/.libs/libnftables.so')
@@ -79,26 +80,26 @@ add_quota = { "add": {
 # helper functions
 
 def exit_err(msg):
-    print "Error: %s" % msg
+    print("Error: %s" %msg)
     sys.exit(1)
 
 def exit_dump(e, obj):
-    print "FAIL: %s" % e
-    print "Output was:"
+    print("FAIL: {}".format(e))
+    print("Output was:")
     json.dumps(out, sort_keys = True, indent = 4, separators = (',', ': '))
     sys.exit(1)
 
 def do_flush():
     rc, out, err = nftables.json_cmd({ "nftables": [flush_ruleset] })
     if not rc is 0:
-        exit_err("flush ruleset failed: %s" % err)
+        exit_err("flush ruleset failed: {}".format(err))
 
 def do_command(cmd):
     if not type(cmd) is list:
         cmd = [cmd]
     rc, out, err = nftables.json_cmd({ "nftables": cmd })
     if not rc is 0:
-        exit_err("command failed: %s" % err)
+        exit_err("command failed: {}".format(err))
     return out
 
 def do_list_ruleset():
@@ -123,7 +124,7 @@ def get_handle(output, search):
             if not k in data:
                 continue
             found = True
-            for key in search[k].keys():
+            for key in list(search[k].keys()):
                 if key == "handle":
                     continue
                 if not key in data[k] or search[k][key] != data[k][key]:
@@ -140,7 +141,7 @@ def get_handle(output, search):
 
 do_flush()
 
-print "Adding table t"
+print("Adding table t")
 out = do_command(add_table)
 handle = get_handle(out, add_table["add"])
 
@@ -152,7 +153,7 @@ if handle != handle_cmp:
 
 add_table["add"]["table"]["handle"] = handle
 
-print "Adding chain c"
+print("Adding chain c")
 out = do_command(add_chain)
 handle = get_handle(out, add_chain["add"])
 
@@ -164,7 +165,7 @@ if handle != handle_cmp:
 
 add_chain["add"]["chain"]["handle"] = handle
 
-print "Adding set s"
+print("Adding set s")
 out = do_command(add_set)
 handle = get_handle(out, add_set["add"])
 
@@ -176,7 +177,7 @@ if handle != handle_cmp:
 
 add_set["add"]["set"]["handle"] = handle
 
-print "Adding rule"
+print("Adding rule")
 out = do_command(add_rule)
 handle = get_handle(out, add_rule["add"])
 
@@ -188,7 +189,7 @@ if handle != handle_cmp:
 
 add_rule["add"]["rule"]["handle"] = handle
 
-print "Adding counter"
+print("Adding counter")
 out = do_command(add_counter)
 handle = get_handle(out, add_counter["add"])
 
@@ -200,7 +201,7 @@ if handle != handle_cmp:
 
 add_counter["add"]["counter"]["handle"] = handle
 
-print "Adding quota"
+print("Adding quota")
 out = do_command(add_quota)
 handle = get_handle(out, add_quota["add"])
 
@@ -222,37 +223,37 @@ add_set["add"]["set"]["name"] = "s2"
 add_counter["add"]["counter"]["name"] = "c2"
 add_quota["add"]["quota"]["name"] = "q2"
 
-print "Adding table t2"
+print("Adding table t2")
 out = do_command(add_table)
 handle = get_handle(out, add_table["add"])
 if handle == add_table["add"]["table"]["handle"]:
    exit_err("handle not changed in re-added table!")
 
-print "Adding chain c2"
+print("Adding chain c2")
 out = do_command(add_chain)
 handle = get_handle(out, add_chain["add"])
 if handle == add_chain["add"]["chain"]["handle"]:
    exit_err("handle not changed in re-added chain!")
 
-print "Adding set s2"
+print("Adding set s2")
 out = do_command(add_set)
 handle = get_handle(out, add_set["add"])
 if handle == add_set["add"]["set"]["handle"]:
    exit_err("handle not changed in re-added set!")
 
-print "Adding rule again"
+print("Adding rule again")
 out = do_command(add_rule)
 handle = get_handle(out, add_rule["add"])
 if handle == add_rule["add"]["rule"]["handle"]:
    exit_err("handle not changed in re-added rule!")
 
-print "Adding counter c2"
+print("Adding counter c2")
 out = do_command(add_counter)
 handle = get_handle(out, add_counter["add"])
 if handle == add_counter["add"]["counter"]["handle"]:
    exit_err("handle not changed in re-added counter!")
 
-print "Adding quota q2"
+print("Adding quota q2")
 out = do_command(add_quota)
 handle = get_handle(out, add_quota["add"])
 if handle == add_quota["add"]["quota"]["handle"]:
@@ -269,7 +270,7 @@ add_quota["add"]["quota"]["name"] = "q"
 
 do_flush()
 
-print "doing multi add"
+print("doing multi add")
 # XXX: Add table separately, otherwise this triggers cache bug
 out = do_command(add_table)
 thandle = get_handle(out, add_table["add"])
-- 
2.17.1

