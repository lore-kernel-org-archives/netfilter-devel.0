Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81FEC072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 18:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81153217F9
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 18:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tMSM6z90"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbfEXSoY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 14:44:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37412 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728594AbfEXSoY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 14:44:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id a23so5827706pff.4
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 11:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hfvd20yKR8tUQycpK5AX6Z9nuR65uyqNJ0Z2WxNdz9c=;
        b=tMSM6z90tPapZXkBjTlO2CGbFkvgc58BbcEHz0Tr38+max7WQK+bS3jtFHA1VQFzc9
         sKjZLHs4aciG3091jFD9I7ZxlZLiNRbLYuFj6TdfWaySkJjZjGg7ZV727u5XZ1T0663l
         Fy6Q2k3dxffMliUk/FUsrmjykaFtZYT8cURtmdXZ8fLLqpaWQsiy90VL+Uw/UXMIDrBM
         GCJJ/gNFxrQ3Z7KCvBQFmd6OEsdfSiZhbzRRQcUT0yIevQjSuNgIspA5rjeuVzMhxJPa
         yopUSPl3RI7RSRSwyxftui/8AO2Fx07UcWs/TILBn/G7MpYYxcPnDjgxP6dgSVCv4Dmc
         rt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hfvd20yKR8tUQycpK5AX6Z9nuR65uyqNJ0Z2WxNdz9c=;
        b=dlbkzdJm0JVbx3fKSR7CvOWKeRQXhteGhAuwtAa/bDKkW5djlHVWty/JPO//ZdiIuA
         f7Dv8zaPLP14RLHT3R0NI5cuy8bzifGgoGpJG5IACUDIZdHd7r9msUHNBWFlCkeq10hy
         XR2ssKdCCFHtaRN7OaRCdzrmA9XA/gOAyW7JVcr2qstoj7SUc3w8ybu9fd0xdw6DfxYJ
         Gj1J+vSiMk2Php/NbJzHsGNVvRBTT6C6KA2W97TIq2ourhajmygtYyVZjSUEQNqaiG7p
         1vuH2UeX9jFiS+GTplnCdK3jlqK1DDCz53foYlADZHowEoGJBUn27JTsqNcCaMWuKhHK
         V6sw==
X-Gm-Message-State: APjAAAXR2TMMR756Y+ikII0dQBGRiXBB4rrNOQliA51p3Av18Yvhz3TZ
        UFNJZBzd6mOLkznsvXrAzO64LVR9XGA=
X-Google-Smtp-Source: APXvYqxYPW1W2RAnW4nABdlhqEJ/FLhFCcOpwQQ5yPTLqIEdJpRZ+ZLjkjBY7RapGeYemZ7N3q2ogA==
X-Received: by 2002:a63:c508:: with SMTP id f8mr22217036pgd.48.1558723462934;
        Fri, 24 May 2019 11:44:22 -0700 (PDT)
Received: from localhost.localdomain ([2405:204:e08c:113f:983f:2b22:f507:ea96])
        by smtp.gmail.com with ESMTPSA id a26sm4544189pfl.177.2019.05.24.11.44.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 11:44:22 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v1] tests: json_echo: fix python3
Date:   Sat, 25 May 2019 00:14:09 +0530
Message-Id: <20190524184409.466036-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


This patch converts the 'run-test.py' file to run on both python2 and python3.

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 tests/json_echo/run-test.py | 45 +++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
index 0132b139..f5c81b7d 100755
--- a/tests/json_echo/run-test.py
+++ b/tests/json_echo/run-test.py
@@ -1,5 +1,7 @@
 #!/usr/bin/python2
 
+from nftables import Nftables
+from __future__ import print_function
 import sys
 import os
 import json
@@ -7,14 +9,13 @@ import json
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
 
-from nftables import Nftables
 
 # Change working directory to repository root
 os.chdir(TESTS_PATH + "/../..")
 
 if not os.path.exists('src/.libs/libnftables.so'):
-    print "The nftables library does not exist. " \
-          "You need to build the project."
+    print("The nftables library does not exist. " \
+          "You need to build the project.")
     sys.exit(1)
 
 nftables = Nftables(sofile = 'src/.libs/libnftables.so')
@@ -79,26 +80,26 @@ add_quota = { "add": {
 # helper functions
 
 def exit_err(msg):
-    print "Error: %s" % msg
+    print("Error: {}".format(msg))
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
2.21.0.windows.1

