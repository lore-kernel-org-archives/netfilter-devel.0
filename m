Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE8CC43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 10:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C4D22070B
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 10:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ffbrv0Nv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfFTKtn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 06:49:43 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34023 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfFTKtn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 06:49:43 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so1397283pgn.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 03:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TpMNZdk4Ero1Vp/fApMCB3Ohu576IrAq2K9SDyj45Ss=;
        b=Ffbrv0NvbjrwE949yzU3KL2eE/AOLJFq+Kd3XbwfAjaVantO15B9r+ebAvyvA6VvP8
         +F50iK6CSyfbURo4tG9R1Jkk/SgPaJHFL1R5u/X7IGGqCI9vHtXAGFzVt4tk8hhd/lXC
         kKm0wkKAMpogFp25S0pKRlYHxepXxFevZz5dr0YIeGMJkTcYA3MrwG9KltQh2rFYGJjw
         uZYN8H/iE9mcrGwlGn5DVIt8b0WIKjD940iyzAsEpbdOu7nPCzX29E7J3ogW9NMfqUvc
         aB6Kv9AGcNZcxBp3wV85HZQwLLA3+SwePq6jGgganEHu8gOjfWtNWP1LEEufgqBWd3us
         o8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TpMNZdk4Ero1Vp/fApMCB3Ohu576IrAq2K9SDyj45Ss=;
        b=hHu6Hxk6qIZjY+eGQQLovjQ6uEq9h6DOZFN1YfnDZRAj+s11+EvL13o9o7HqjeT8tZ
         a/BnOwTIsXwWaUXoPc+InO3H3VYzYbjyPtXwZTa37d3SxH9q7TJPyQMhFZBbDLeH6UfF
         cnhzKL2RoZv0J5TAQAMnG8Fr7XG3G+Omkp29X7VZGttCkC4uNkboi5XZd2fDP7a38wOH
         EBWJNCsOO40CtXHqcD3vr8MLjCuvIKBZZTWBAHMYmLaJ11CVWP1ZQOAfqtnftfzhWhWI
         p57UnUgbWyeiHo5lnUmof+dwCKncNkgM8v83g+jhbCzOVyJajuqgIyY0gIGkEh4wJLJO
         qfdA==
X-Gm-Message-State: APjAAAXpl+qxTWnQBKOJac7Eaz93GrauAbdkV39mb5gaVecKAxevpvHR
        WJjzAi6VKg/OocY6ThGbJxt/hkfPorM=
X-Google-Smtp-Source: APXvYqzrkDVzDyAhOJU0MF7jWCrlBpd4l5EoCZvo/WpQOWwfa+P7GAuKZvTxSLvEwwPuDARiVyyMQg==
X-Received: by 2002:a17:90a:214e:: with SMTP id a72mr2542208pje.0.1561027782759;
        Thu, 20 Jun 2019 03:49:42 -0700 (PDT)
Received: from shekhar.domain.name ([59.91.145.76])
        by smtp.gmail.com with ESMTPSA id y22sm21153588pfm.70.2019.06.20.03.49.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 03:49:42 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH iptables v3]iptables-test.py : fix python3.
Date:   Thu, 20 Jun 2019 16:19:32 +0530
Message-Id: <20190620104932.3356-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This converts the iptables-test.py file to run on both python2 and python3.
The error regarding out.find() has been fixed by
using method .encode('utf-8') in it's argument.


Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
The version history of this patch is:
v2: change print statments.
v3: add .encode('utf-8') to out.find(). (To solve TypeError)

 iptables-test.py | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 532dee7..dc5f0ea 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/env python
 #
 # (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
 #
@@ -10,6 +10,7 @@
 # This software has been sponsored by Sophos Astaro <http://www.sophos.com>
 #
 
+from __future__ import print_function
 import sys
 import os
 import subprocess
@@ -45,7 +46,7 @@ def print_error(reason, filename=None, lineno=None):
     '''
     Prints an error with nice colors, indicating file and line number.
     '''
-    print (filename + ": " + Colors.RED + "ERROR" +
+    print(filename + ": " + Colors.RED + "ERROR" +
         Colors.ENDC + ": line %d (%s)" % (lineno, reason))
 
 
@@ -140,7 +141,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
         return -1
 
     # find the rule
-    matching = out.find(rule_save)
+    matching = out.find(rule_save.encode('utf-8'))
     if matching < 0:
         reason = "cannot find: " + iptables + " -I " + rule
         print_error(reason, filename, lineno)
@@ -166,7 +167,7 @@ def execute_cmd(cmd, filename, lineno):
     if cmd.startswith('iptables ') or cmd.startswith('ip6tables ') or cmd.startswith('ebtables ') or cmd.startswith('arptables '):
         cmd = os.path.abspath(os.path.curdir) + "/iptables/" + EXECUTEABLE + " " + cmd
 
-    print >> log_file, "command: %s" % cmd
+    print("command: {}".format(cmd), file=log_file)
     ret = subprocess.call(cmd, shell=True, universal_newlines=True,
         stderr=subprocess.STDOUT, stdout=log_file)
     log_file.flush()
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
+        print("Couldn't open log file %s" % LOGFILE)
         return
 
     file_list = [os.path.join(EXTENSIONS_PATH, i)
@@ -365,8 +366,7 @@ def main():
             passed += file_passed
             test_files += 1
 
-    print ("%d test files, %d unit tests, %d passed" %
-           (test_files, tests, passed))
+    print("%d test files, %d unit tests, %d passed" % (test_files, tests, passed))
 
 
 if __name__ == '__main__':
-- 
2.17.1

