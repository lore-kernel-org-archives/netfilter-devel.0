Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898E3C06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 19:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 579822184C
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 19:20:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DrbbhkUU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfGBTU7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:20:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43116 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBTU6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 15:20:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so8734307pfg.10
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Jul 2019 12:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jc6pAj3fWFfPMVckprQm+8Wby2uHCh2Pbj2R/MXSswU=;
        b=DrbbhkUUNwEAcmnjzv8h//L38b/ZdE7zqtqyXR85VfmFJ6xfadnaWIUpE919hDw2wu
         Gafx2vGZD0CW9GWwX21gUKfbi7Uoq3n9nHiLfTP6/A15cRwtAP8k2YkNJoHwAY+Hbmrr
         i8trLPXsbXjufLjASqUYkKv+ThI4o2OrASSxXmUjk9kSFU6DKGIBwjWleOjQukfJp2M3
         25DwIrY5Wb/IjCfn+OaknNwpDgWdq05lmDBoD8LxSbIPdtfORx9Gy2q38Sz4R7oO6KR4
         maTiRfbYOp3Tj1nb4cPcV499A176UUs+Z7Yzy0yUOjI9r8vNd+pprPUBQAgITSZBqJRC
         ezPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jc6pAj3fWFfPMVckprQm+8Wby2uHCh2Pbj2R/MXSswU=;
        b=PLsejXCXCBkxPmqQCUs0zotkr1/sDb8o1HkiUNf2AYam1FE4L/Bojeft0mDGYtGPAS
         mwJu++5XT0OenS2COJQgBOfOHNNL9q5eKzNF06NmVTWlCZZzQIx/3ZXqDdDbWxaAEpI7
         s4SyziaQCylDGfAE+TGAsF1mWQEgBrqA+7rb5oadTaxAFO1ODBFrz5Teh0f2unKHMHLe
         aNyatgg+cknB5Zbrq5sIPK1n4lvrNoPMxVQ3qwZ1Bg74a/NLwBV18+p++7btuh3IefOG
         2BcUKNDW23nI4PB1SbmTagkc4/yyrZul8OhYfdZgMANEwIxRZ7QzSt4gbi0fLgrATsey
         NdHQ==
X-Gm-Message-State: APjAAAWmeApNIa22E6qReChK2EsHTRj9ym4G7Uz5MScziIj/2/i4K1Or
        ky/5Ss+aKLNvP0b7cdW9pnJcBiSulAU=
X-Google-Smtp-Source: APXvYqywAnh/LLLNWD+cD98scrkVFwTYN/EjxlYahW5QUvP+OTq7UJRROPjWf5bBP9r/HagHOJL/ig==
X-Received: by 2002:a63:1657:: with SMTP id 23mr30307312pgw.98.1562095257128;
        Tue, 02 Jul 2019 12:20:57 -0700 (PDT)
Received: from shekhar.domain.name ([117.199.23.106])
        by smtp.gmail.com with ESMTPSA id f10sm12225237pgq.73.2019.07.02.12.20.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:20:56 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v12]tests: py: add netns feature
Date:   Wed,  3 Jul 2019 00:50:45 +0530
Message-Id: <20190702192045.16537-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This adds the netns feature to the nft-test.py file.

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
The version history of the patch is :
v1: add the netns feature
v2: use format() method to simplify print statements.
v3: updated the shebang
v4: resent the same with small changes
v5&v6: resent with small changes
v7: netns commands changed for passing the netns name via netns argument.
v8: correct typo error
v9: use tempfile, replace cmp() and add a global variable 'netns'
    and store the args.netns value in it.
v10: the cmp() function has again been added so that it can be
     replaced the way eric has proposed.
v11: the cmp() function has been replaced in the same way as
     eric had done in his patch.(this patch has all the changes
     for python3 conversion, netns feature and the changes proposed
     by eric).
v12: all changes for python3 removed from the patch. New patch 
     contains only changes related to netns feature.
---
 tests/py/nft-test.py | 103 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 83 insertions(+), 20 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index fcbd28ca..8076ce78 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -174,27 +174,31 @@ def print_differences_error(filename, lineno, cmd):
     print_error(reason, filename, lineno)
 
 
-def table_exist(table, filename, lineno):
+def table_exist(table, filename, lineno, netns=""):
     '''
     Exists a table.
     '''
     cmd = "list table %s" % table
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def table_flush(table, filename, lineno):
+def table_flush(table, filename, lineno, netns=""):
     '''
     Flush a table.
     '''
     cmd = "flush table %s" % table
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns, cmd)
     execute_cmd(cmd, filename, lineno)
 
     return cmd
 
 
-def table_create(table, filename, lineno):
+def table_create(table, filename, lineno, netns=""):
     '''
     Adds a table.
     '''
@@ -208,6 +212,8 @@ def table_create(table, filename, lineno):
 
     # We add a new table
     cmd = "add table %s" % table
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, lineno)
 
     if ret != 0:
@@ -236,7 +242,7 @@ def table_create(table, filename, lineno):
     return 0
 
 
-def table_delete(table, filename=None, lineno=None):
+def table_delete(table, filename=None, lineno=None, netns=""):
     '''
     Deletes a table.
     '''
@@ -246,6 +252,8 @@ def table_delete(table, filename=None, lineno=None):
         return -1
 
     cmd = "delete table %s" % table
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "%s: I cannot delete table %s. Giving up!" % (cmd, table)
@@ -261,17 +269,19 @@ def table_delete(table, filename=None, lineno=None):
     return 0
 
 
-def chain_exist(chain, table, filename):
+def chain_exist(chain, table, filename, netns=""):
     '''
     Checks a chain
     '''
     cmd = "list chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, chain.lineno)
 
     return True if (ret == 0) else False
 
 
-def chain_create(chain, table, filename):
+def chain_create(chain, table, filename, netns=""):
     '''
     Adds a chain
     '''
@@ -282,6 +292,9 @@ def chain_create(chain, table, filename):
         return -1
 
     cmd = "add chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     if chain.config:
         cmd += " { %s; }" % chain.config
 
@@ -300,7 +313,7 @@ def chain_create(chain, table, filename):
     return 0
 
 
-def chain_delete(chain, table, filename=None, lineno=None):
+def chain_delete(chain, table, filename=None, lineno=None, netns=""):
     '''
     Flushes and deletes a chain.
     '''
@@ -311,6 +324,9 @@ def chain_delete(chain, table, filename=None, lineno=None):
         return -1
 
     cmd = "flush chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "I cannot " + cmd
@@ -318,6 +334,8 @@ def chain_delete(chain, table, filename=None, lineno=None):
         return -1
 
     cmd = "delete chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "I cannot " + cmd
@@ -343,7 +361,7 @@ def chain_get_by_name(name):
     return chain
 
 
-def set_add(s, test_result, filename, lineno):
+def set_add(s, test_result, filename, lineno, netns=""):
     '''
     Adds a set.
     '''
@@ -365,6 +383,9 @@ def set_add(s, test_result, filename, lineno):
             flags = "flags %s; " % flags
 
         cmd = "add set %s %s { type %s;%s %s}" % (table, s.name, s.type, s.timeout, flags)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and test_result == "fail") or \
@@ -382,7 +403,7 @@ def set_add(s, test_result, filename, lineno):
     return 0
 
 
-def set_add_elements(set_element, set_name, state, filename, lineno):
+def set_add_elements(set_element, set_name, state, filename, lineno, netns=""):
     '''
     Adds elements to the set.
     '''
@@ -402,6 +423,9 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
 
         element = ", ".join(set_element)
         cmd = "add element %s %s { %s }" % (table, set_name, element)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (state == "fail" and ret == 0) or (state == "ok" and ret != 0):
@@ -419,12 +443,15 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
 
 
 def set_delete_elements(set_element, set_name, table, filename=None,
-                        lineno=None):
+                        lineno=None, netns=""):
     '''
     Deletes elements in a set.
     '''
     for element in set_element:
         cmd = "delete element %s %s { %s }" % (table, set_name, element)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
         if ret != 0:
             reason = "I cannot delete element %s " \
@@ -435,7 +462,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     return 0
 
 
-def set_delete(table, filename=None, lineno=None):
+def set_delete(table, filename=None, lineno=None, netns=""):
     '''
     Deletes set and its content.
     '''
@@ -453,6 +480,9 @@ def set_delete(table, filename=None, lineno=None):
 
         # We delete the set.
         cmd = "delete set %s %s" % (table, set_name)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         # Check if the set still exists after I deleted it.
@@ -464,21 +494,27 @@ def set_delete(table, filename=None, lineno=None):
     return 0
 
 
-def set_exist(set_name, table, filename, lineno):
+def set_exist(set_name, table, filename, lineno, netns=""):
     '''
     Check if the set exists.
     '''
     cmd = "list set %s %s" % (table, set_name)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def _set_exist(s, filename, lineno):
+def _set_exist(s, filename, lineno, netns=""):
     '''
     Check if the set exists.
     '''
     cmd = "list set %s %s %s" % (s.family, s.table, s.name)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -510,7 +546,7 @@ def set_check_element(rule1, rule2):
     return False
 
 
-def obj_add(o, test_result, filename, lineno):
+def obj_add(o, test_result, filename, lineno, netns=""):
     '''
     Adds an object.
     '''
@@ -529,6 +565,9 @@ def obj_add(o, test_result, filename, lineno):
             return -1
 
         cmd = "add %s %s %s %s" % (o.type, table, o.name, o.spcf)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and test_result == "fail") or \
@@ -555,7 +594,7 @@ def obj_add(o, test_result, filename, lineno):
         print_error(reason, filename, lineno)
         return -1
 
-def obj_delete(table, filename=None, lineno=None):
+def obj_delete(table, filename=None, lineno=None, netns=""):
     '''
     Deletes object.
     '''
@@ -569,6 +608,9 @@ def obj_delete(table, filename=None, lineno=None):
 
         # We delete the object.
         cmd = "delete %s %s %s" % (o.type, table, o.name)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         # Check if the object still exists after I deleted it.
@@ -580,21 +622,27 @@ def obj_delete(table, filename=None, lineno=None):
     return 0
 
 
-def obj_exist(o, table, filename, lineno):
+def obj_exist(o, table, filename, lineno, netns=""):
     '''
     Check if the object exists.
     '''
     cmd = "list %s %s %s" % (o.type, table, o.name)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def _obj_exist(o, filename, lineno):
+def _obj_exist(o, filename, lineno, netns=""):
     '''
     Check if the object exists.
     '''
     cmd = "list %s %s %s %s" % (o.type, o.family, o.table, o.name)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -696,7 +744,7 @@ def json_validate(json_string):
         print_error("schema validation failed for input '%s'" % json_string)
         print_error(traceback.format_exc())
 
-def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
+def rule_add(rule, filename, lineno, force_all_family_option, filename_path, netns=""):
     '''
     Adds a rule
     '''
@@ -774,6 +822,9 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
             # Add rule and check return code
             cmd = "add rule %s %s %s" % (table, chain, rule[0])
+            if netns:
+                cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
             ret = execute_cmd(cmd, filename, lineno, payload_log, debug="netlink")
 
             state = rule[1].rstrip()
@@ -870,6 +921,9 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
                 # Add rule and check return code
                 cmd = "add rule %s %s %s" % (table, chain, rule_output.rstrip())
+                if netns:
+                    cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
                 ret = execute_cmd(cmd, filename, lineno, payload_log, debug="netlink")
 
                 if ret != 0:
@@ -1198,7 +1252,7 @@ def json_find_expected(json_log, rule):
     return json_buffer
 
 
-def run_test_file(filename, force_all_family_option, specific_file):
+def run_test_file(filename, force_all_family_option, specific_file,netns=""):
     '''
     Runs a test file
 
@@ -1207,6 +1261,8 @@ def run_test_file(filename, force_all_family_option, specific_file):
     filename_path = os.path.join(TESTS_PATH, filename)
     f = open(filename_path)
     tests = passed = total_unit_run = total_warning = total_error = 0
+    if netns:
+        execute_cmd("ip netns add " + netns, filename, 0)
 
     for lineno, line in enumerate(f):
         sys.stdout.flush()
@@ -1326,6 +1382,8 @@ def run_test_file(filename, force_all_family_option, specific_file):
     else:
         if tests == passed and tests > 0:
             print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
+        if netns:
+            execute_cmd("ip netns del " + netns, filename, 0)
 
     f.close()
     del table_list[:]
@@ -1359,17 +1417,22 @@ def main():
                         dest='enable_schema',
                         help='verify json input/output against schema')
 
+    parser.add_argument('-N', '--netns', action='store_true',
+			dest='netns',
+                        help='Test namespace path')
+
     parser.add_argument('-v', '--version', action='version',
                         version='1.0',
                         help='Print the version information')
 
     args = parser.parse_args()
-    global debug_option, need_fix_option, enable_json_option, enable_json_schema
+    global debug_option, need_fix_option, enable_json_option, enable_json_schema, netns
     debug_option = args.debug
     need_fix_option = args.need_fix_line
     force_all_family_option = args.force_all_family
     enable_json_option = args.enable_json
     enable_json_schema = args.enable_schema
+    netns = args.netns
     specific_file = False
 
     signal.signal(signal.SIGINT, signal_handler)
-- 
2.17.1

