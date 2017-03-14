From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/9] tests: py: add ct helper tests
Date: Tue, 14 Mar 2017 20:58:13 +0100
Message-ID: <20170314195816.1721-7-fw@strlen.de>
References: <20170314195816.1721-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42152 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751229AbdCNT6V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 15:58:21 -0400
In-Reply-To: <20170314195816.1721-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

needs minor tweak to nft-test.py so we don't zap the ';' within the {}
before attempting to add the rule/ct helper object.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/objects.t         |  4 ++++
 tests/py/ip/objects.t.payload | 14 ++++++++++++++
 tests/py/nft-test.py          | 11 ++++++++++-
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/tests/py/ip/objects.t b/tests/py/ip/objects.t
index 8109402da8ba..4c98f5533050 100644
--- a/tests/py/ip/objects.t
+++ b/tests/py/ip/objects.t
@@ -13,3 +13,7 @@ counter name tcp dport map {443 : "cnt1", 80 : "cnt2", 22 : "cnt1"};ok
 ip saddr 192.168.1.3 quota name "qt1";ok
 ip saddr 192.168.1.3 quota name "qt3";fail
 quota name tcp dport map {443 : "qt1", 80 : "qt2", 22 : "qt1"};ok
+
+%cthelp1 type ct helper { type \"ftp\"\; protocol tcp\; };ok
+ct helper set "cthelp1";ok
+ct helper set tcp dport map {21 : "cthelp1", 2121 : "cthelp1" };ok
diff --git a/tests/py/ip/objects.t.payload b/tests/py/ip/objects.t.payload
index b5cad4d1e3fc..6499d36348fe 100644
--- a/tests/py/ip/objects.t.payload
+++ b/tests/py/ip/objects.t.payload
@@ -29,3 +29,17 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d id 1 ]
+
+# ct helper set "cthelp1"
+ip test-ip4 output
+  [ objref type 3 name cthelp1 ]
+
+# ct helper set tcp dport map {21 : "cthelp1", 2121 : "cthelp1" }
+__objmap%d test-ip4 43
+__objmap%d test-ip4 0
+        element 00001500  : 0 [end]     element 00004908  : 0 [end]
+ip test-ip4 output
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ objref sreg 1 set __objmap%d id 1 ]
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 25009217e51d..b22404076edd 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -885,6 +885,10 @@ def obj_process(obj_line, filename, lineno):
     obj_type = tokens[2]
     obj_spcf = ""
 
+    if obj_type == "ct" and tokens[3] == "helper":
+       obj_type = "ct helper"
+       tokens[3] = ""
+
     if len(tokens) > 3:
         obj_spcf = " ".join(tokens[3:])
 
@@ -985,7 +989,12 @@ def run_test_file(filename, force_all_family_option, specific_file):
             continue
 
         if line[0] == "%":  # Adds this object
-            obj_line = line.rstrip()[1:].split(";")
+            brace = line.rfind("}")
+            if brace < 0:
+                obj_line = line.rstrip()[1:].split(";")
+            else:
+                obj_line = (line[1:brace+1], line[brace+2:].rstrip())
+
             ret = obj_process(obj_line, filename, lineno)
             tests += 1
             if ret == -1:
-- 
2.10.2

