Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97DE2356D9
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236066; cv=none; b=JvmRCwzCZ0LW2F9a8XgOIyII4YN0jFtbbrqkhUvjPv+lJDdgfhA3Zewi9WjgnpgkdungF/9ZUKaSDsRXKtRymNKpy8Q5HsGfPfDLi1CLq4JJdzCxJAhedrMm3aWRqmHw/kIJczdNaoezueVbPyjYPs6+OQ7aHbjhSXNxbP+igpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236066; c=relaxed/simple;
	bh=aDHNRjs32vMgoGCGH/JyPmi8Nq3m8jfYzwT0D1vh5bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+xT/2XxffFES16aw/dEsrzqUu/IQhVfP6+mLam8a5BpwQSCp9cNmfDHlQmmSdsxFPGeajGU7AQYMeFImhU8rz9+eEC//rtVV+rZRbZCeaPlpcwrYe/q58aY0swlLS2YHWeJmcyyLmsy9BG6eIfdWC1v3/rtOhF9tQEdjZAigEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=W+sqeLkC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="W+sqeLkC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gggW7qI4+lkLU/2BuPAZ0bmDdndh9hMR9NjeOwI/gMw=; b=W+sqeLkCmufZTC9NIL46mM/JLB
	0Ev3mrXRBXWUK74/GkmfHBZJjCd0PvejaAx2AENlrY+GtSrKr7Ml6W4TAPPbZnvnwolpMQZuOWtTq
	V3VwA0UskfCi3FIGV3sp0GKa2t8/1FncQ12L6gyevw2YW4axukFye47pqk6MvJSHhnEffVQgr22z1
	uj0+Xf8oIJkp1+17yINMZ4RF1KAqL+ZI8x2NJlI/Ma3i64ZCuIcbfqy31B2WLRw5jYtZl9dJNulSn
	6nHDfvZhO+Q6AkWDVaF0T9MIU+Pij2hdiD4+BWtI/c5jh5I1ib65IdgKgKrNnmThNJvPX8Z5H3oN1
	FQxMZbhQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxG-000000008WN-2msy;
	Thu, 23 Oct 2025 18:14:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 07/28] tests: py: Implement payload_record()
Date: Thu, 23 Oct 2025 18:13:56 +0200
Message-ID: <20251023161417.13228-8-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a helper function to store payload records (and JSON
equivalents) in .got files. The code it replaces missed to insert a
newline before the new entry and also did not check for existing records
in all spots.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 117 ++++++++++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 46 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 019c828f957a5..dc074d4c3872a 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -16,6 +16,7 @@
 from __future__ import print_function
 import sys
 import os
+import io
 import argparse
 import signal
 import json
@@ -741,6 +742,66 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     return i > 0
 
 
+def payload_record(path, rule, payload, desc="payload"):
+    '''
+    Record payload for @rule in file at @path
+
+    - @payload may be a file handle, a string or an array of strings
+    - Avoid duplicate entries by searching for a match first
+    - Separate entries by a single empty line, so check for trailing newlines
+      before writing
+    - @return False if already existing, True otherwise
+    '''
+    try:
+        with open(path, 'r') as f:
+            lines = f.readlines()
+    except:
+        lines = []
+
+    plines = []
+    if isinstance(payload, io.TextIOWrapper):
+        payload.seek(0, 0)
+        while True:
+            line = payload.readline()
+            if line.startswith("family "):
+                continue
+            if line == "":
+                break
+            plines.append(line)
+    elif isinstance(payload, str):
+        plines = [l + "\n" for l in payload.split("\n")]
+    elif isinstance(payload, list):
+        plines = payload
+    else:
+        raise Exception
+
+    found = False
+    for i in range(len(lines)):
+        if lines[i] == rule + "\n":
+            found = True
+            for pline in plines:
+                i += 1
+                if lines[i] != pline:
+                    found = False
+                    break
+            if found:
+                return False
+
+    try:
+        with open(path, 'a') as f:
+            if len(lines) > 0 and lines[-1] != "\n":
+                f.write("\n")
+            f.write("# %s\n" % rule)
+            f.writelines(plines)
+    except:
+        warnfmt = "Failed to write %s for rule %s"
+    else:
+        warnfmt = "Wrote %s for rule %s"
+
+    print_warning(warnfmt % (desc, rule[0]), os.path.basename(path), 1)
+    return True
+
+
 def json_dump_normalize(json_string, human_readable = False):
     json_obj = json.loads(json_string)
 
@@ -867,28 +928,8 @@ def set_delete_elements(set_element, set_name, table, filename=None,
             if state == "ok" and not payload_check(table_payload_expected,
                                                    payload_log, cmd):
                 error += 1
-
-                try:
-                    gotf = open("%s.got" % table_payload_path)
-                    gotf_payload_expected = payload_find_expected(gotf, rule[0])
-                    gotf.close()
-                except:
-                    gotf_payload_expected = None
-                payload_log.seek(0, 0)
-                if not payload_check(gotf_payload_expected, payload_log, cmd):
-                    gotf = open("%s.got" % table_payload_path, 'a')
-                    payload_log.seek(0, 0)
-                    gotf.write("# %s\n" % rule[0])
-                    while True:
-                        line = payload_log.readline()
-                        if line.startswith("family "):
-                            continue
-                        if line == "":
-                            break
-                        gotf.write(line)
-                    gotf.close()
-                    print_warning("Wrote payload for rule %s" % rule[0],
-                                  gotf.name, 1)
+                payload_record("%s.got" % table_payload_path,
+                               rule[0], payload_log)
 
             # Check for matching ruleset listing
             numeric_proto_old = nftables.set_numeric_proto_output(True)
@@ -979,13 +1020,9 @@ def set_delete_elements(set_element, set_name, table, filename=None,
                         json_output = item["rule"]
                         break
                 json_input = json.dumps(json_output["expr"], sort_keys = True)
-
-                gotf = open("%s.json.got" % filename_path, 'a')
-                jdump = json_dump_normalize(json_input, True)
-                gotf.write("# %s\n%s\n\n" % (rule[0], jdump))
-                gotf.close()
-                print_warning("Wrote JSON equivalent for rule %s" % rule[0],
-                              gotf.name, 1)
+                payload_record("%s.json.got" % filename_path, rule[0],
+                               json_dump_normalize(json_input, True),
+                               "JSON equivalent")
 
             table_flush(table, filename, lineno)
             payload_log = tempfile.TemporaryFile(mode="w+")
@@ -1013,17 +1050,8 @@ def set_delete_elements(set_element, set_name, table, filename=None,
             # Check for matching payload
             if not payload_check(table_payload_expected, payload_log, cmd):
                 error += 1
-                gotf = open("%s.json.payload.got" % filename_path, 'a')
-                payload_log.seek(0, 0)
-                gotf.write("# %s\n" % rule[0])
-                while True:
-                    line = payload_log.readline()
-                    if line == "":
-                        break
-                    gotf.write(line)
-                gotf.close()
-                print_warning("Wrote JSON payload for rule %s" % rule[0],
-                              gotf.name, 1)
+                payload_record("%s.json.payload.got" % filename_path,
+                               rule[0], payload_log, "JSON payload")
 
             # Check for matching ruleset listing
             numeric_proto_old = nftables.set_numeric_proto_output(True)
@@ -1049,12 +1077,9 @@ def set_delete_elements(set_element, set_name, table, filename=None,
                 print_differences_warning(filename, lineno,
                                           json_input, json_output, cmd)
                 error += 1
-                gotf = open("%s.json.output.got" % filename_path, 'a')
-                jdump = json_dump_normalize(json_output, True)
-                gotf.write("# %s\n%s\n\n" % (rule[0], jdump))
-                gotf.close()
-                print_warning("Wrote JSON output for rule %s" % rule[0],
-                              gotf.name, 1)
+                payload_record("%s.json.output.got" % filename_path, rule[0],
+                               json_dump_normalize(json_output, True),
+                               "JSON output")
                 # prevent further warnings and .got file updates
                 json_expected = json_output
             elif json_expected and json_output != json_expected:
-- 
2.51.0

