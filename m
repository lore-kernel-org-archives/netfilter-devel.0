From: Manuel Johannes Messner <manuel.johannes.messner@hs-furtwangen.de>
Subject: [PATCH 1/3] tests: py: nft-tests.py: Add function for loading and removing kernel modules
Date: Mon,  5 Sep 2016 20:20:12 +0200
Message-ID: <20160905182014.8762-2-manuel.johannes.messner@hs-furtwangen.de>
References: <20160905182014.8762-1-manuel.johannes.messner@hs-furtwangen.de>
Cc: fw@strlen.de, messnera@hs-furtwangen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx.rz.hs-furtwangen.de ([141.28.2.11]:39108 "HELO
        mx.rz.hs-furtwangen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1754782AbcIES1d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 14:27:33 -0400
In-Reply-To: <20160905182014.8762-1-manuel.johannes.messner@hs-furtwangen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some tests use the dummy kernel module. This commit adds a function to
automatically load that module and remove it afterwards.

Signed-off-by: Manuel Johannes Messner <manuel.johannes.messner@hs-furtwangen.de>
---
 tests/py/nft-test.py | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index fc7ae60..c1217bb 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -28,6 +28,7 @@ table_list = []
 chain_list = []
 all_set = dict()
 signal_received = 0
+modules = []
 
 
 class Colors:
@@ -114,6 +115,30 @@ def print_differences_error(filename, lineno, cmd):
           str(lineno + 1) + ": '" + cmd + "': " + reason
 
 
+def cleanup_modules():
+    for i in modules:
+        modprobe(i, remove=True)
+
+
+def modprobe(name, remove=False):
+    '''
+    Loads or removes a kernel module
+    '''
+    if name is None:
+        return -1
+
+    cmds = {
+        'ins': ['modprobe', '--first-time', '--quiet', name],
+        'del': ['modprobe', '-r', name],
+    }
+
+    ret = subprocess.call(cmds['del' if remove else 'ins']) == 0
+    if ret and not remove:
+        # the kernel module has been loaded -> remove it afterwards
+        global modules
+        modules.append(name)
+
+
 def table_exist(table, filename, lineno):
     '''
     Exists a table.
@@ -686,6 +711,8 @@ def cleanup_on_exit():
             set_delete(table)
         table_delete(table)
 
+    cleanup_modules()
+
 
 def signal_handler(signal, frame):
     global signal_received
@@ -965,6 +992,8 @@ def main():
         print "The nft binary does not exist. You need to build the project."
         return
 
+    modprobe('dummy')
+
     test_files = files_ok = run_total = 0
     tests = passed = warnings = errors = 0
     global log_file
@@ -972,6 +1001,7 @@ def main():
         log_file = open(LOGFILE, 'w')
     except IOError:
         print "Cannot open log file %s" % LOGFILE
+        cleanup_modules()
         return
 
     file_list = []
@@ -1020,6 +1050,8 @@ def main():
                       "%d error, %d warning" \
                       % (test_files, files_ok, tests, errors, warnings)
 
+    cleanup_modules()
+
 
 if __name__ == '__main__':
     main()
-- 
2.9.3

