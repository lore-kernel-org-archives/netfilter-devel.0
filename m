From: Kohei Suzuki <eagletmt@gmail.com>
Subject: [PATCH nft] parser: Add glob support to include directive
Date: Mon, 5 Dec 2016 20:58:38 +0900
Message-ID: <CAAVa8iscQtgaXbauR6MJ_iwU+YZuXpzaFCBM+4QR3676XHx5KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35604 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751722AbcLEL71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Dec 2016 06:59:27 -0500
Received: by mail-qk0-f181.google.com with SMTP id n204so343115857qke.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Dec 2016 03:59:00 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 src/scanner.l                                 | 36 +++++++++++++++++----------
 tests/shell/testcases/include/0005glob_0      | 32 ++++++++++++++++++++++++
 tests/shell/testcases/include/0006globempty_1 | 14 +++++++++++
 3 files changed, 69 insertions(+), 13 deletions(-)
 create mode 100755 tests/shell/testcases/include/0005glob_0
 create mode 100755 tests/shell/testcases/include/0006globempty_1

diff --git a/src/scanner.l b/src/scanner.l
index 625023f..64fe6fc 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -11,6 +11,7 @@
 %{

 #include <limits.h>
+#include <glob.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <linux/types.h>
@@ -640,37 +641,46 @@ int scanner_include_file(void *scanner, const
char *filename,
     struct parser_state *state = yyget_extra(scanner);
     struct error_record *erec;
     char buf[PATH_MAX];
-    const char *name = buf;
     unsigned int i;
-    FILE *f;
+    glob_t globbuf;

-    f = NULL;
+    globbuf.gl_pathc = 0;
     if (search_in_include_path(filename)) {
         for (i = 0; i < INCLUDE_PATHS_MAX; i++) {
             if (include_paths[i] == NULL)
                 break;
             snprintf(buf, sizeof(buf), "%s/%s",
                  include_paths[i], filename);
-            f = fopen(buf, "r");
-            if (f != NULL)
+            if (glob(buf, 0, NULL, &globbuf) != 0) {
                 break;
+            }
         }
     } else {
-        f = fopen(filename, "r");
-        name = filename;
+        glob(filename, 0, NULL, &globbuf);
     }
-    if (f == NULL) {
-        erec = error(loc, "Could not open file \"%s\": %s",
-                 filename, strerror(errno));
+    if (globbuf.gl_pathc == 0) {
+        erec = error(loc, "Could not find file matching \"%s\"\n", filename);
         goto err;
     }

-    erec = scanner_push_file(scanner, name, f, loc);
-    if (erec != NULL)
-        goto err;
+    for (i = 0; i < globbuf.gl_pathc; i++) {
+        const char *name = globbuf.gl_pathv[i];
+        FILE *f = fopen(name, "r");
+        if (f == NULL) {
+            erec = error(loc, "Could not open file \"%s\": %s\n",
name, strerror(errno));
+            goto err;
+        }
+        erec = scanner_push_file(scanner, name, f, loc);
+        if (erec != NULL) {
+            goto err;
+        }
+    }
+
+    globfree(&globbuf);
     return 0;

 err:
+    globfree(&globbuf);
     erec_queue(erec, state->msgs);
     return -1;
 }
diff --git a/tests/shell/testcases/include/0005glob_0
b/tests/shell/testcases/include/0005glob_0
new file mode 100755
index 0000000..99dbf53
--- /dev/null
+++ b/tests/shell/testcases/include/0005glob_0
@@ -0,0 +1,32 @@
+#!/bin/bash
+
+set -e
+
+tmpdir=$(mktemp -d)
+tmpfile=$(mktemp)
+
+trap "rm -rf $tmpdir $tmpfile" EXIT # cleanup if aborted
+
+RULESET1="add table x"
+RULESET2="add table y"
+RULESET3="include \"$tmpdir/*.conf\""
+
+echo "$RULESET1" > $tmpdir/ruleset1.conf
+echo "$RULESET2" > $tmpdir/ruleset2.conf
+echo "$RULESET3" > $tmpfile
+
+$NFT -f $tmpfile
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
+$NFT list table x
+if [ $? -ne 0 ] ; then
+        echo "E: unable to include ruleset1.conf" >&2
+        exit 1
+fi
+$NFT list table y
+if [ $? -ne 0 ] ; then
+        echo "E: unable to include ruleset2.conf" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0006globempty_1
b/tests/shell/testcases/include/0006globempty_1
new file mode 100755
index 0000000..3ac8c72
--- /dev/null
+++ b/tests/shell/testcases/include/0006globempty_1
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+set -e
+
+tmpdir=$(mktemp -d)
+tmpfile=$(mktemp)
+
+trap "rm -rf $tmpdir $tmpfile" EXIT # cleanup if aborted
+
+RULESET="include \"$tmpdir/*.conf\""
+
+echo "$RULESET" > $tmpfile
+
+$NFT -f $tmpfile 2>/dev/null
-- 
2.10.2


Kohei Suzuki
eagletmt@gmail.com
