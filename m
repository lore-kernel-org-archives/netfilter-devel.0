From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: validate generated netlink instructions
Date: Fri, 17 Jul 2015 03:31:39 +0200
Message-ID: <1437096699-8832-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57201 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbbGQBbx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2015 21:31:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't apply -- this patch is intentionally incomplete;
I don't want to spam this list with 350k patch.

If you think this is worthwile to have in nft I'll push the full
changeset (this patch + 64 test files with recorded netlink debug output).

The test script is extended to compare netlink instructions generated
by each of the nft test files with recorded version.

Example: udp dport 80 accept in ip family should look like

ip test-ip4 input
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000011 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp eq reg 1 0x00005000 ]
  [ immediate reg 0 accept ]

This is stored in udp.t.payload.ip

Other suffixes:
.payload.ip6
.payload.inet
.payload ('any')

The test script first looks for 'testname.t.payload.$family', if that
doesn't exist 'testname.t.payload' is used.

This allows for family independent test (e.g. meta).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/regression/nft-test.py | 100 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 95 insertions(+), 5 deletions(-)

Full diffstat with test files:
 65 files changed, 11259 insertions(+), 5 deletions(-)
 An excerpt of the ct.t.payload is included here
 so you can have a look at the format.

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 153f5e8..26fc2ec 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -423,9 +423,32 @@ def output_clean(pre_output, chain):
         return ""
     return rule
 
+def payload_check(payload_buffer, file, cmd):
+
+    file.seek(0, 0)
+
+    ret = False
+    i = 0
+
+    for lineno, want_line in enumerate(payload_buffer):
+        line = file.readline()
+
+        if want_line == line:
+            i += 1
+            continue
+
+        if want_line.find('[') < 0 and line.find('[') < 0:
+            continue
+        if want_line.find(']') < 0 and line.find(']') < 0:
+            continue
+
+        print_differences_warning(file.name, lineno, want_line.strip(), line.strip(), cmd);
+        return 0
+
+    return i > 0
 
 def rule_add(rule, table_list, chain_list, filename, lineno,
-             force_all_family_option):
+             force_all_family_option, filename_path):
     '''
     Adds a rule
     '''
@@ -437,7 +460,23 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
         print_error(reason, filename, lineno)
         return [-1, warning, error, unit_tests]
 
+    payload_expected = []
+
     for table in table_list:
+        try:
+            payload_log = open("%s.payload.%s" % (filename_path, table[0]))
+        except (IOError):
+            payload_log = open("%s.payload" % filename_path)
+
+        if rule[1].strip() == "ok":
+	    try:
+                payload_expected.index(rule[0])
+            except (ValueError):
+                payload_expected = payload_find_expected(payload_log, rule[0])
+
+                if payload_expected == []:
+                    print_error("did not find payload information for rule '%s'" % rule[0], payload_log.name, 1)
+
         for chain in chain_list:
             if len(rule) == 1:
                 reason = "Skipping malformed test. (" + \
@@ -450,7 +489,10 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
             table_info = " " + table[0] + " " + table[1] + " "
             cmd = "nft add rule" + table_info + chain + " " + rule[0]
 
-            ret = execute_cmd(cmd, filename, lineno)
+            payload_log = os.tmpfile();
+
+            cmd = "nft add rule --debug=netlink" + table_info + chain + " " + rule[0]
+            ret = execute_cmd(cmd, filename, lineno, payload_log)
 
             state = rule[1].rstrip()
             if (ret == 0 and state == "fail") or (ret != 0 and state == "ok"):
@@ -470,6 +512,20 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
                 continue
 
             if ret == 0:
+            # Check for matching payload
+                if state == "ok" and not payload_check(payload_expected, payload_log, cmd):
+                    error += 1
+                    gotf = open("%s.payload.got" % filename_path, 'a')
+                    payload_log.seek(0, 0)
+                    gotf.write("# %s\n" % rule[0])
+                    while True:
+                        line = payload_log.readline()
+                        if line == "":
+                            break
+                        gotf.write(line)
+	            gotf.close()
+                    print_warning("Wrote payload for rule %s" % rule[0], gotf.name, 1)
+
             # Check output of nft
                 process = subprocess.Popen(['nft', '-nnn', 'list', 'table'] + table,
                                            shell=False, stdout=subprocess.PIPE,
@@ -536,7 +592,7 @@ def signal_handler(signal, frame):
     signal_received = 1
 
 
-def execute_cmd(cmd, filename, lineno):
+def execute_cmd(cmd, filename, lineno, stdout_log = False):
     '''
     Executes a command, checks for segfaults and returns the command exit
     code.
@@ -549,8 +605,12 @@ def execute_cmd(cmd, filename, lineno):
     print >> log_file, "command: %s" % cmd
     if debug_option:
         print cmd
+
+    if not stdout_log:
+        stdout_log = log_file
+
     ret = subprocess.call(cmd, shell=True, universal_newlines=True,
-                          stderr=subprocess.STDOUT, stdout=log_file,
+                          stderr=log_file, stdout=stdout_log,
                           preexec_fn=preexec)
     log_file.flush()
 
@@ -619,6 +679,36 @@ def set_element_process(element_line, filename, lineno):
     return set_add_elements(set_element, set_name, all_set, rule_state,
                             table_list, filename, lineno)
 
+def payload_find_expected(payload_log, rule):
+    '''
+    Find the netlink payload that should be generated by given rule in payload_log
+
+    :param payload_log: open file handle of the payload data
+    :param rule: nft rule we are going to add
+    '''
+    found = 0
+    pos = 0
+    payload_buffer = []
+
+    while True:
+        line = payload_log.readline()
+	if not line:
+	    break
+
+        if line[0] == "#":  # rule start
+            rule_line = line.strip()[2:]
+
+            if rule_line == rule.strip():
+                found = 1
+                continue
+
+        if found == 1:
+            payload_buffer.append(line)
+            if line.isspace():
+                return payload_buffer
+
+    payload_log.seek(0, 0)
+    return payload_buffer
 
 def run_test_file(filename, force_all_family_option, specific_file):
     '''
@@ -699,7 +789,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
             continue
 
         result = rule_add(rule, table_list, chain_list, filename, lineno,
-                          force_all_family_option)
+                          force_all_family_option, filename_path)
         tests += 1
         ret = result[0]
         warning = result[1]
diff --git a/tests/regression/any/ct.t.payload b/tests/regression/any/ct.t.payload
new file mode 100644
index 0000000..f77c284
--- /dev/null
+++ b/tests/regression/any/ct.t.payload
@@ -0,0 +1,239 @@
+# ct state new,established, related, untracked
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000004e ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# ct state != related
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ cmp neq reg 1 0x00000004 ]
+
+# ct state {new,established, related, untracked}
+set%d test-ip4 3
+set%d test-ip4 0
+	element 00000008  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000040  : 0 [end]
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# ct state invalid drop
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+  [ immediate reg 0 drop ]
+
+# ct state established accept
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000002 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+  [ immediate reg 0 accept ]
+
+# ct state 8
+ip test-ip4 output
+  [ ct load state => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000008 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]

[ Rest omitted, they all look pretty much the same ...]

-- 
2.0.5

