Return-Path: <SRS0=ECng=UI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20425C28EBD
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jun 2019 18:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D615C20679
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jun 2019 18:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u0p5L4fz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbfFISTD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jun 2019 14:19:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35973 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbfFISTD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jun 2019 14:19:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id u22so3955346pfm.3
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Jun 2019 11:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BX7Ds3JLdLLdHrs4sBbf/6m09CJfkyVp51yxFrWfKHg=;
        b=u0p5L4fzELZR8GWv0IulX33tNNTDeHPqQxP9cD4haQCzRROMdcNsLlJJAauAXtzlRE
         gHYol+lJ+fc6R3q4dYDkC76L2aRVo8mufkYvWL+YHekvyI15jhZSw1cbcjM3lAfOdaJl
         nLi7Oiec4FqJ/Mi0VxMr/Io8qrRigloD4o8WL/JL49D2Qo0HBJixk/CysdpD8qfYa3nw
         LRqP9PfOzwJfBI3loosAVMtlmDpE0q1rKhR3OijFuUOPD4JP+5tjpiOfPoKkPWmMWohi
         v+1q6ubHCqkQp1/ipczw7I3r+ctNT7xJJFMkyxLiG7t6qumNaWa7thIQHHbKze4k9NNe
         5IEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BX7Ds3JLdLLdHrs4sBbf/6m09CJfkyVp51yxFrWfKHg=;
        b=aI5rxkPZfyggSlJ5jXVQEcRPQq3/C4cvaUbyC71m5tWHJ/K6TiTPWKlqF6NV+xp6Ko
         5WO2g5ja7XFtef3qGLaCFY+UoRgz2o1Z2GOFbLDOCpTcyci/QKRLKresOGybQ9049hP9
         JaIRiPiktjwoK+MDdecKJCLwQJgLXYlWXxGGqia4NUhXKcgJrBWfXFCGs64wpeRC1BzW
         6bRHZDVUNlt3s1KtQ1aVdnBWAz4eYtVuXCRhZBfPOMvWlt/adkCPNIyrmn12K6IV3ZiR
         Yg8q6qzEA31QLyMhbXzz+Lc2mZg67ZOie48mgfsHepsltdYdbDpovSmthzB7IOoHRIj9
         ZoNg==
X-Gm-Message-State: APjAAAXKnK8wdyE5Y+wCMLrwcHj1B8eN5bi6a+o6CXGgn75RT7Ma/t2k
        jLIO9jupWzMJ5t3Ar5FNyJT4od3W+iA=
X-Google-Smtp-Source: APXvYqzX4fFoFkBNhDiPpyq/KDWPPr3kCq2XmY4+PlgFIIMrAMU6ZoV+Gcr5uQHQ5iK6legpoktp8Q==
X-Received: by 2002:aa7:8705:: with SMTP id b5mr48841357pfo.27.1560104342434;
        Sun, 09 Jun 2019 11:19:02 -0700 (PDT)
Received: from shekhar.domain.name ([117.200.145.68])
        by smtp.gmail.com with ESMTPSA id 124sm6072050pfd.63.2019.06.09.11.19.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 11:19:02 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v6 2/2]tests: py: add netns feature
Date:   Sun,  9 Jun 2019 23:48:49 +0530
Message-Id: <20190609181849.10131-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the netns feature to the 'nft-test.py' file.

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
The version history of the patch is :
v1: add the netns feature
v2: use format() method to simplify print statements.
v3: updated the shebang
v4: resent the same with small changes

 tests/py/nft-test.py | 98 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 80 insertions(+), 18 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 4e18ae54..c9f65dc5 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -173,27 +173,31 @@ def print_differences_error(filename, lineno, cmd):
     print_error(reason, filename, lineno)
 
 
-def table_exist(table, filename, lineno):
+def table_exist(table, filename, lineno, netns):
     '''
     Exists a table.
     '''
     cmd = "list table %s" % table
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def table_flush(table, filename, lineno):
+def table_flush(table, filename, lineno, netns):
     '''
     Flush a table.
     '''
     cmd = "flush table %s" % table
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
     execute_cmd(cmd, filename, lineno)
 
     return cmd
 
 
-def table_create(table, filename, lineno):
+def table_create(table, filename, lineno, netns):
     '''
     Adds a table.
     '''
@@ -207,6 +211,8 @@ def table_create(table, filename, lineno):
 
     # We add a new table
     cmd = "add table %s" % table
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
     ret = execute_cmd(cmd, filename, lineno)
 
     if ret != 0:
@@ -235,7 +241,7 @@ def table_create(table, filename, lineno):
     return 0
 
 
-def table_delete(table, filename=None, lineno=None):
+def table_delete(table, filename=None, lineno=None, netns=0):
     '''
     Deletes a table.
     '''
@@ -245,6 +251,8 @@ def table_delete(table, filename=None, lineno=None):
         return -1
 
     cmd = "delete table %s" % table
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "%s: I cannot delete table %s. Giving up!" % (cmd, table)
@@ -260,17 +268,19 @@ def table_delete(table, filename=None, lineno=None):
     return 0
 
 
-def chain_exist(chain, table, filename):
+def chain_exist(chain, table, filename, netns):
     '''
     Checks a chain
     '''
     cmd = "list chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
     ret = execute_cmd(cmd, filename, chain.lineno)
 
     return True if (ret == 0) else False
 
 
-def chain_create(chain, table, filename):
+def chain_create(chain, table, filename, netns):
     '''
     Adds a chain
     '''
@@ -281,6 +291,9 @@ def chain_create(chain, table, filename):
         return -1
 
     cmd = "add chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
     if chain.config:
         cmd += " { %s; }" % chain.config
 
@@ -299,7 +312,7 @@ def chain_create(chain, table, filename):
     return 0
 
 
-def chain_delete(chain, table, filename=None, lineno=None):
+def chain_delete(chain, table, filename=None, lineno=None, netns=0):
     '''
     Flushes and deletes a chain.
     '''
@@ -310,6 +323,9 @@ def chain_delete(chain, table, filename=None, lineno=None):
         return -1
 
     cmd = "flush chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "I cannot " + cmd
@@ -317,6 +333,8 @@ def chain_delete(chain, table, filename=None, lineno=None):
         return -1
 
     cmd = "delete chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "I cannot " + cmd
@@ -342,7 +360,7 @@ def chain_get_by_name(name):
     return chain
 
 
-def set_add(s, test_result, filename, lineno):
+def set_add(s, test_result, filename, lineno, netns):
     '''
     Adds a set.
     '''
@@ -364,6 +382,9 @@ def set_add(s, test_result, filename, lineno):
             flags = "flags %s; " % flags
 
         cmd = "add set %s %s { type %s;%s %s}" % (table, s.name, s.type, s.timeout, flags)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and test_result == "fail") or \
@@ -381,7 +402,7 @@ def set_add(s, test_result, filename, lineno):
     return 0
 
 
-def set_add_elements(set_element, set_name, state, filename, lineno):
+def set_add_elements(set_element, set_name, state, filename, lineno, netns):
     '''
     Adds elements to the set.
     '''
@@ -401,6 +422,9 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
 
         element = ", ".join(set_element)
         cmd = "add element %s %s { %s }" % (table, set_name, element)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (state == "fail" and ret == 0) or (state == "ok" and ret != 0):
@@ -418,12 +442,15 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
 
 
 def set_delete_elements(set_element, set_name, table, filename=None,
-                        lineno=None):
+                        lineno=None, netns=0):
     '''
     Deletes elements in a set.
     '''
     for element in set_element:
         cmd = "delete element %s %s { %s }" % (table, set_name, element)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
         ret = execute_cmd(cmd, filename, lineno)
         if ret != 0:
             reason = "I cannot delete element %s " \
@@ -434,7 +461,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     return 0
 
 
-def set_delete(table, filename=None, lineno=None):
+def set_delete(table, filename=None, lineno=None, netns=0):
     '''
     Deletes set and its content.
     '''
@@ -452,6 +479,9 @@ def set_delete(table, filename=None, lineno=None):
 
         # We delete the set.
         cmd = "delete set %s %s" % (table, set_name)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
         ret = execute_cmd(cmd, filename, lineno)
 
         # Check if the set still exists after I deleted it.
@@ -463,21 +493,27 @@ def set_delete(table, filename=None, lineno=None):
     return 0
 
 
-def set_exist(set_name, table, filename, lineno):
+def set_exist(set_name, table, filename, lineno, netns):
     '''
     Check if the set exists.
     '''
     cmd = "list set %s %s" % (table, set_name)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+	
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def _set_exist(s, filename, lineno):
+def _set_exist(s, filename, lineno, netns):
     '''
     Check if the set exists.
     '''
     cmd = "list set %s %s %s" % (s.family, s.table, s.name)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -511,7 +547,7 @@ def set_check_element(rule1, rule2):
     return cmp(rule1[end1:], rule2[end2:])
 
 
-def obj_add(o, test_result, filename, lineno):
+def obj_add(o, test_result, filename, lineno, netns):
     '''
     Adds an object.
     '''
@@ -530,6 +566,9 @@ def obj_add(o, test_result, filename, lineno):
             return -1
 
         cmd = "add %s %s %s %s" % (o.type, table, o.name, o.spcf)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and test_result == "fail") or \
@@ -556,7 +595,7 @@ def obj_add(o, test_result, filename, lineno):
         print_error(reason, filename, lineno)
         return -1
 
-def obj_delete(table, filename=None, lineno=None):
+def obj_delete(table, filename=None, lineno=None, netns=0):
     '''
     Deletes object.
     '''
@@ -570,6 +609,9 @@ def obj_delete(table, filename=None, lineno=None):
 
         # We delete the object.
         cmd = "delete %s %s %s" % (o.type, table, o.name)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
         ret = execute_cmd(cmd, filename, lineno)
 
         # Check if the object still exists after I deleted it.
@@ -581,21 +623,27 @@ def obj_delete(table, filename=None, lineno=None):
     return 0
 
 
-def obj_exist(o, table, filename, lineno):
+def obj_exist(o, table, filename, lineno, netns):
     '''
     Check if the object exists.
     '''
     cmd = "list %s %s %s" % (o.type, table, o.name)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def _obj_exist(o, filename, lineno):
+def _obj_exist(o, filename, lineno, netns):
     '''
     Check if the object exists.
     '''
     cmd = "list %s %s %s %s" % (o.type, o.family, o.table, o.name)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -697,7 +745,7 @@ def json_validate(json_string):
         print_error("schema validation failed for input '%s'" % json_string)
         print_error(traceback.format_exc())
 
-def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
+def rule_add(rule, filename, lineno, force_all_family_option, filename_path, netns):
     '''
     Adds a rule
     '''
@@ -775,6 +823,9 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
             # Add rule and check return code
             cmd = "add rule %s %s %s" % (table, chain, rule[0])
+            if netns:
+                cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
             ret = execute_cmd(cmd, filename, lineno, payload_log, debug="netlink")
 
             state = rule[1].rstrip()
@@ -871,6 +922,9 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
                 # Add rule and check return code
                 cmd = "add rule %s %s %s" % (table, chain, rule_output.rstrip())
+                if netns:
+                    cmd = "ip netns exec ___nftables-container-test {}".format(cmd) 
+
                 ret = execute_cmd(cmd, filename, lineno, payload_log, debug="netlink")
 
                 if ret != 0:
@@ -1208,6 +1262,9 @@ def run_test_file(filename, force_all_family_option, specific_file):
     filename_path = os.path.join(TESTS_PATH, filename)
     f = open(filename_path)
     tests = passed = total_unit_run = total_warning = total_error = 0
+    if netns:
+        execute_cmd("ip netns add ___nftables-container-test", filename, 0)
+ 
 
     for lineno, line in enumerate(f):
         sys.stdout.flush()
@@ -1327,6 +1384,8 @@ def run_test_file(filename, force_all_family_option, specific_file):
     else:
         if tests == passed and tests > 0:
             print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
+        if netns:
+            execute_cmd("ip netns del ___nftables-container-test", filename, 0)
 
     f.close()
     del table_list[:]
@@ -1359,6 +1418,9 @@ def main():
     parser.add_argument('-s', '--schema', action='store_true',
                         dest='enable_schema',
                         help='verify json input/output against schema')
+
+    parser.add_argument('-N', '--netns', action='store_true',
+                        help='Test namespace path')
 	
     parser.add_argument('-v', '--version', action='version',
                         version='1.0',
-- 
2.17.1

