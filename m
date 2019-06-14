Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00B8C31E44
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 11:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7005B2133D
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 11:52:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W7M3nv1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfFNLwt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 07:52:49 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33617 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbfFNLwt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 07:52:49 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so944830plo.0
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 04:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iCjFsoBaUMu0hYubOqPRRDJsJAhgKNuF5l6ls9IFhwo=;
        b=W7M3nv1A98/GY3HpS2I5oRrNDIkm20JrId7oMttwukPw25WuW9lAUPmgeXaYIvII+M
         dmeZY8f+OG6iboDwS6Z7gn1d7hsO/QdM6FsSwUBXK1dcYpX8B2QYHPMFkqCHh7dxdM89
         hAauQ9ppEjOD0J10KxbTFL5HEX/AVPXJ8hsWvDDaspXVEdB878YCk7nw/ywk8M0Xcqjh
         8OCD6HLWamy6ZX/Q9AEP7SbApUrqMZ2EuAlup/vfZw+Qv0CvpeLWCmz0cSOJI7Ey/ljG
         VJpUwc2+/loH63BbVtEdXIVmEfx4SWlJ8/oiFQA8OMy4yFzbE5DzamH7kICD53YT8wm8
         yrgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iCjFsoBaUMu0hYubOqPRRDJsJAhgKNuF5l6ls9IFhwo=;
        b=jUINR3E5tf3ZbbxVXhiUFfgSlr/vwv8nA0Gzz9HdCg0WvKMFPiPctNo6fQXUyNvFrj
         0sDAiJ8iDGrhdwqTDgKgC+ZB8f7XTC0Wy4R7rT1zEkrF5IeV2mvjXfWeR3rvynxcFNsc
         sffD1uL5kmO+/0KYBGd365hxCq+TbsOuWdhKyKNG6z77fo5nZ6EUBJsrMBuFF8wx+Rbx
         D6ZHp0xHZdtRJSYQLb7+K52pfd3wbrI6DP1MooOMLlbHSzET4sQXy3adl5S4+6n2tGzH
         xHlyGoymayCHsPxWdAxcUbVq4WY0wC6uZsUWiIFxabDxsSaAtmOoUvVbcd9mtpHgKv7t
         J7zA==
X-Gm-Message-State: APjAAAVu5AWTuQRKRdW8d8IR9lQY0CxkOUvotitCkcPCrew+C5FuUBS5
        bkVdB6LERZYe+/R/R46yHngfSx60OzM=
X-Google-Smtp-Source: APXvYqyPaH+BBeZlu15ks8FSCjFfmPz/oBPyvVdwd67TYDNPr5mtEvg7PQEb/oYh+8cvyEpZE5YYRw==
X-Received: by 2002:a17:902:f204:: with SMTP id gn4mr74855802plb.3.1560513168009;
        Fri, 14 Jun 2019 04:52:48 -0700 (PDT)
Received: from shekhar.domain.name ([59.91.149.38])
        by smtp.gmail.com with ESMTPSA id 5sm2323466pfh.109.2019.06.14.04.52.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 04:52:47 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH iptables v2]iptables-test: fix python3
Date:   Fri, 14 Jun 2019 17:22:35 +0530
Message-Id: <20190614115235.9435-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This changes the print statements to convert the file to run on both python2 and python3.

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 iptables-test.py | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 532dee7..233c4d6 100755
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

