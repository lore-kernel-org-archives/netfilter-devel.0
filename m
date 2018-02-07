From: =?UTF-8?q?Ville=20Skytt=C3=A4?= <ville.skytta@iki.fi>
Subject: [PATCH] Spelling fixes
Date: Wed,  7 Feb 2018 11:34:31 +0200
Message-ID: <20180207093431.10047-1-ville.skytta@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:42515 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753337AbeBGJei (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 04:34:38 -0500
Received: by mail-lf0-f67.google.com with SMTP id q17so365599lfa.9
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Feb 2018 01:34:38 -0800 (PST)
Received: from localhost.localdomain (87-100-219-255.bb.dnainternet.fi. [87.100.219.255])
        by smtp.gmail.com with ESMTPSA id f14sm203086lje.84.2018.02.07.01.34.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Feb 2018 01:34:35 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ville Skyttä <ville.skytta@iki.fi>
---
 INSTALL                                             | 2 +-
 doc/nft.xml                                         | 2 +-
 include/datatype.h                                  | 2 +-
 src/exthdr.c                                        | 4 ++--
 src/netlink_delinearize.c                           | 2 +-
 src/payload.c                                       | 4 ++--
 tests/py/nft-test.py                                | 2 +-
 tests/shell/README                                  | 2 +-
 tests/shell/testcases/include/0012glob_dependency_1 | 2 +-
 tests/shell/testcases/listing/0002ruleset_0         | 2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/INSTALL b/INSTALL
index e212bac..9475711 100644
--- a/INSTALL
+++ b/INSTALL
@@ -43,7 +43,7 @@ Installation instructions for nftables
 
  --datarootdir=
 
- 	The base directory for arch-independant files. Defaults to
+ 	The base directory for arch-independent files. Defaults to
 	$prefix/share.
 
  --disable-debug
diff --git a/doc/nft.xml b/doc/nft.xml
index d5b9c27..807c836 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -3568,7 +3568,7 @@ inet filter output rt ip6 nexthop fd00::1
 							</row>
 							<row>
 								<entry>vtag</entry>
-								<entry>Verfication Tag</entry>
+								<entry>Verification Tag</entry>
 								<entry>integer (32 bit)</entry>
 							</row>
 							<row>
diff --git a/include/datatype.h b/include/datatype.h
index e9f6079..cc4cb07 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -129,7 +129,7 @@ enum datatype_flags {
  * @subtypes:	number of subtypes (concat type)
  * @name:	type name
  * @desc:	type description
- * @basetype:	basetype for subtypes, determines type compatibilty
+ * @basetype:	basetype for subtypes, determines type compatibility
  * @basefmt:	format string for basetype
  * @print:	function to print a constant of this type
  * @parse:	function to parse a symbol and return an expression
diff --git a/src/exthdr.c b/src/exthdr.c
index ac3e163..f5c20ac 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -26,8 +26,8 @@
 static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
-		/* Offset calcualtion is a bit hacky at this point.
-		 * There might be an tcp option one day with another
+		/* Offset calculation is a bit hacky at this point.
+		 * There might be a tcp option one day with another
 		 * multiplicator
 		 */
 		unsigned int offset = expr->exthdr.offset / 64;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 256552b..6b66257 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2173,7 +2173,7 @@ static void stmt_payload_postprocess(struct rule_pp_ctx *ctx)
 
 /*
  * We can only remove payload dependencies if they occur without
- * a statment with side effects in between.
+ * a statement with side effects in between.
  *
  * For instance:
  * 'ip protocol tcp tcp dport 22 counter' is same as
diff --git a/src/payload.c b/src/payload.c
index 60090ac..c036da6 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -429,13 +429,13 @@ void payload_dependency_store(struct payload_dep_ctx *ctx,
 }
 
 /**
- * __payload_dependency_kill - kill a redundant payload depedency
+ * __payload_dependency_kill - kill a redundant payload dependency
  *
  * @ctx: payload dependency context
  * @expr: higher layer payload expression
  *
  * Kill a redundant payload expression if a higher layer payload expression
- * implies its existance.
+ * implies its existence.
  */
 void __payload_dependency_kill(struct payload_dep_ctx *ctx,
 			       enum proto_bases base)
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 6aedfb0..87e3d51 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -384,7 +384,7 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
             print_error(reason, filename, lineno)
             return -1
 
-        # Add element into a all_set.
+        # Add element into all_set.
         if ret == 0 and state == "ok":
             for e in set_element:
                 all_set[set_name].add(e)
diff --git a/tests/shell/README b/tests/shell/README
index 2d8681f..3ffe642 100644
--- a/tests/shell/README
+++ b/tests/shell/README
@@ -10,7 +10,7 @@ To run the test suite (as root):
 
 Test files are executables files with the pattern <<name_N>>, where N is the
 expected return code of the executable. Since they are located with `find',
-test-files can be spreaded in any sub-directories.
+test-files can be spread in any sub-directories.
 
 You can turn on a verbose execution by calling:
  % ./run-tests.sh -v
diff --git a/tests/shell/testcases/include/0012glob_dependency_1 b/tests/shell/testcases/include/0012glob_dependency_1
index 740f5ea..6cf4ba1 100755
--- a/tests/shell/testcases/include/0012glob_dependency_1
+++ b/tests/shell/testcases/include/0012glob_dependency_1
@@ -38,7 +38,7 @@ RULESET1="add table x"
 RULESET2="add chain x y"
 RULESET3="include \"$tmpdir/*\""
 
-# Note different order when compared with 0011dir_depencency_0. The idea
+# Note different order when compared with 0011dir_dependency_0. The idea
 # here is to introduce wrong order to get the loading fail.
 echo "$RULESET1" > $tmpfile2
 echo "$RULESET2" > $tmpfile1
diff --git a/tests/shell/testcases/listing/0002ruleset_0 b/tests/shell/testcases/listing/0002ruleset_0
index 916034f..45121fb 100755
--- a/tests/shell/testcases/listing/0002ruleset_0
+++ b/tests/shell/testcases/listing/0002ruleset_0
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-# list ruleset show nothing if emtpy ruleset
+# list ruleset show nothing if empty ruleset
 
 EXPECTED=""
 
-- 
2.14.1

