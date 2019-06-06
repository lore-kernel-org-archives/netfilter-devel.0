Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AF0C04AB5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 19:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07E51206BB
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 19:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UzLwRDtG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfFFTvO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 15:51:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34010 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfFFTvO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 15:51:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id h2so1943453pgg.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2019 12:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CrVq1ho2punL9RnFoDwWBaheJLpoZ+Zy0BpB1YjvmLk=;
        b=UzLwRDtG7A15duadQhocjnoBXEQiyXBTWOibPYdwVJq0od99G0pRELRdnm101/sunO
         s4YjsTFBztYfrEtExTubmwHK72qh0WRi0S7MHkhzotViRwRsdbRCRqRKHsQFAQwJibTO
         RG6m05+4Iqo1lbRmtnPJaYHsBvqTZuHGBrOBY/As4scUMvqnZ3LZsIg/e2kqnxgkdG72
         9Q6ePBBCOPc4sfmOWIWzWK7+DnuT5lq+YLYKtpJ85t6/fyFOXjhWS6pIY/cS4rLOsCOY
         SczDJy01ZfDKGKavZuhKGoRJMZMwcsrMg4K6zqN//t+R523CZhShXOqs8LfoEGEVNBNF
         JAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CrVq1ho2punL9RnFoDwWBaheJLpoZ+Zy0BpB1YjvmLk=;
        b=n7Ti3xHE185rrj7rrqyjBMYNRd3wcY0TEkyujL8yhFEe1umkJ4iRyTb4N55T5hJfRo
         l6i7JiV0In5Bg7vlci5QhkOaTBpU8ca19KI9i34Pk81uIQOpjW6JQKCQfixKtC6GryiY
         arwFaccjqmp41XJrBJe68nCp4LaBgRm8kApagoYZe6qvlzxK0EuutBifN0FMLtXe/Vaz
         WDiKvVhXl1tlm0VDpPw0OfA14LZT3igyEOcSQ0ePqqCS8N3KTy0aeqlY/ffZQo8wKT4V
         gkdFeUzuYAq5bMp1L8YKoDeO+CtB96nShX+jWZNbBhRrSpW31arTdvmcnf9nOYQ6utBR
         bZKQ==
X-Gm-Message-State: APjAAAVwVT2AGPAW4PcEXP0jytvEGSDLzkIokgJwIkvx12xM73bD0bmS
        OWif8lBQbjxl4/eQeUY8Kxkwt6+g
X-Google-Smtp-Source: APXvYqx/JS6/mpqhOAIYkaa78XdRQMwNQgIQF5japCzkUQ9Uaq98GE+MLtZnpPrGfBTFgeRVoV4q+Q==
X-Received: by 2002:aa7:82cd:: with SMTP id f13mr56282190pfn.203.1559850673389;
        Thu, 06 Jun 2019 12:51:13 -0700 (PDT)
Received: from localhost.localdomain ([2409:4043:2294:e6c5:3561:149c:3847:7d25])
        by smtp.gmail.com with ESMTPSA id g17sm6725111pfb.56.2019.06.06.12.51.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 12:51:12 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH iptables v1] iptables-test: fix python3
Date:   Fri,  7 Jun 2019 01:20:58 +0530
Message-Id: <20190606195058.4411-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch converts the 'iptables-test.py' file (iptables/iptables-test.py) to run on
both python 2 and python3.


Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 iptables-test.py | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 532dee7..8018b65 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -10,6 +10,7 @@
 # This software has been sponsored by Sophos Astaro <http://www.sophos.com>
 #
 
+from __future__ import print_function
 import sys
 import os
 import subprocess
@@ -45,8 +46,8 @@ def print_error(reason, filename=None, lineno=None):
     '''
     Prints an error with nice colors, indicating file and line number.
     '''
-    print (filename + ": " + Colors.RED + "ERROR" +
-        Colors.ENDC + ": line %d (%s)" % (lineno, reason))
+    print(filename + ": " + Colors.RED + "ERROR" +
+        Colors.ENDC + ": line {} ({})".format(lineno, reason))
 
 
 def delete_rule(iptables, rule, filename, lineno):
@@ -79,7 +80,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
 
     cmd = iptables + " -A " + rule
     if netns:
-            cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + " " + cmd
+            cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + "  {}".format(cmd)
 
     ret = execute_cmd(cmd, filename, lineno)
 
@@ -88,7 +89,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     #
     if ret:
         if res == "OK":
-            reason = "cannot load: " + cmd
+            reason = "cannot load: {}".format(cmd)
             print_error(reason, filename, lineno)
             return -1
         else:
@@ -96,7 +97,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
             return 0
     else:
         if res == "FAIL":
-            reason = "should fail: " + cmd
+            reason = "should fail: {}".format(cmd)
             print_error(reason, filename, lineno)
             delete_rule(iptables, rule, filename, lineno)
             return -1
@@ -119,10 +120,10 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
             command = EBTABLES_SAVE
 
     path = os.path.abspath(os.path.curdir) + "/iptables/" + EXECUTEABLE
-    command = path + " " + command
+    command = path + " {}".format(command)
 
     if netns:
-            command = "ip netns exec ____iptables-container-test " + command
+            command = "ip netns exec ____iptables-container-test {}".format(command)
 
     args = splitted[1:]
     proc = subprocess.Popen(command, shell=True,
@@ -134,7 +135,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     # check for segfaults
     #
     if proc.returncode == -11:
-        reason = "iptables-save segfaults: " + cmd
+        reason = "iptables-save segfaults: {}".format(cmd)
         print_error(reason, filename, lineno)
         delete_rule(iptables, rule, filename, lineno)
         return -1
@@ -142,7 +143,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     # find the rule
     matching = out.find(rule_save)
     if matching < 0:
-        reason = "cannot find: " + iptables + " -I " + rule
+        reason = "cannot find: {}".format(iptables) + " -I {}".format(rule)
         print_error(reason, filename, lineno)
         delete_rule(iptables, rule, filename, lineno)
         return -1
@@ -164,16 +165,16 @@ def execute_cmd(cmd, filename, lineno):
     '''
     global log_file
     if cmd.startswith('iptables ') or cmd.startswith('ip6tables ') or cmd.startswith('ebtables ') or cmd.startswith('arptables '):
-        cmd = os.path.abspath(os.path.curdir) + "/iptables/" + EXECUTEABLE + " " + cmd
+        cmd = os.path.abspath(os.path.curdir) + "/iptables/" + EXECUTEABLE + " {}".format(cmd)
 
-    print >> log_file, "command: %s" % cmd
+    print("command: {}".format(cmd), file=log_file)
     ret = subprocess.call(cmd, shell=True, universal_newlines=True,
         stderr=subprocess.STDOUT, stdout=log_file)
     log_file.flush()
 
     # generic check for segfaults
     if ret  == -11:
-        reason = "command segfaults: " + cmd
+        reason = "command segfaults: {}".format(cmd)
         print_error(reason, filename, lineno)
     return ret
 
@@ -232,7 +233,7 @@ def run_test_file(filename, netns):
         if line[0] == "@":
             external_cmd = line.rstrip()[1:]
             if netns:
-                external_cmd = "ip netns exec ____iptables-container-test " + external_cmd
+                external_cmd = "ip netns exec ____iptables-container-test {}".format(external_cmd)
             execute_cmd(external_cmd, filename, lineno)
             continue
 
@@ -240,7 +241,7 @@ def run_test_file(filename, netns):
         if line[0] == "%":
             external_cmd = line.rstrip()[1:]
             if netns:
-                external_cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + " " + external_cmd
+                external_cmd = "ip netns exec ____iptables-container-test {}".format(EXECUTEABLE) + " {}".format(external_cmd)
             execute_cmd(external_cmd, filename, lineno)
             continue
 
@@ -249,7 +250,7 @@ def run_test_file(filename, netns):
             continue
 
         if len(chain_array) == 0:
-            print "broken test, missing chain, leaving"
+            print("broken test, missing chain, leaving")
             sys.exit()
 
         test_passed = True
@@ -282,7 +283,7 @@ def run_test_file(filename, netns):
     if netns:
         execute_cmd("ip netns del ____iptables-container-test", filename, 0)
     if total_test_passed:
-        print filename + ": " + Colors.GREEN + "OK" + Colors.ENDC
+        print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
 
     f.close()
     return tests, passed
@@ -302,7 +303,7 @@ def show_missing():
     missing = [test_name(i) for i in libfiles
                if not test_name(i) in testfiles]
 
-    print '\n'.join(missing)
+    print('\n'.join(missing))
 
 
 #
@@ -336,7 +337,7 @@ def main():
         EXECUTEABLE = "xtables-nft-multi"
 
     if os.getuid() != 0:
-        print "You need to be root to run this, sorry"
+        print("You need to be root to run this, sorry")
         return
 
     os.putenv("XTABLES_LIBDIR", os.path.abspath(EXTENSIONS_PATH))
@@ -351,7 +352,7 @@ def main():
     try:
         log_file = open(LOGFILE, 'w')
     except IOError:
-        print "Couldn't open log file %s" % LOGFILE
+        print("Couldn't open log file {}".format(LOGFILE))
         return
 
     file_list = [os.path.join(EXTENSIONS_PATH, i)
@@ -365,9 +366,9 @@ def main():
             passed += file_passed
             test_files += 1
 
-    print ("%d test files, %d unit tests, %d passed" %
-           (test_files, tests, passed))
+    print("{} test files, {} unit tests, {} passed".format(test_files, tests, passed))
 
 
 if __name__ == '__main__':
     main()
+
-- 
2.21.0.windows.1

