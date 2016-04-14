From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: delete tempfile failover in testcases
Date: Thu, 14 Apr 2016 21:47:05 +0200
Message-ID: <146066322498.28580.12517682150584977759.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53817 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751161AbcDNTrQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 15:47:16 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 9F20E51F13C
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 19:47:11 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jMYGRLUBHtcS for <netfilter-devel@vger.kernel.org>;
	Thu, 14 Apr 2016 21:47:06 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	by smtp.cica.es (Postfix) with ESMTP id EBCD651F125
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 21:47:05 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems both Debian/Fedora (and derivates) contains mktemp (from the coreutils
package) so it makes no sense to have this failover, which looks buggy also.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/netns/0001nft-f_0         |    8 +-------
 tests/shell/testcases/netns/0003many_0          |    8 +-------
 tests/shell/testcases/nft-f/0001define_slash_0  |    8 +-------
 tests/shell/testcases/nft-f/0002rollback_rule_0 |    8 +-------
 tests/shell/testcases/nft-f/0003rollback_jump_0 |    8 +-------
 tests/shell/testcases/nft-f/0004rollback_set_0  |    8 +-------
 tests/shell/testcases/nft-f/0005rollback_map_0  |    8 +-------
 7 files changed, 7 insertions(+), 49 deletions(-)

diff --git a/tests/shell/testcases/netns/0001nft-f_0 b/tests/shell/testcases/netns/0001nft-f_0
index 721444a..e616363 100755
--- a/tests/shell/testcases/netns/0001nft-f_0
+++ b/tests/shell/testcases/netns/0001nft-f_0
@@ -8,13 +8,7 @@ if [ ! -x "$IP" ] ; then
 	exit 1
 fi
 
-MKTEMP=$(which mktemp)
-if [ -x $MKTEMP ] ; then
-	tmpfile=$(${MKTEMP})
-else
-	tmpfile=$(/tmp/${RANDOM})
-fi
-
+tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
 	exit 0
diff --git a/tests/shell/testcases/netns/0003many_0 b/tests/shell/testcases/netns/0003many_0
index b6706ff..ad71ae3 100755
--- a/tests/shell/testcases/netns/0003many_0
+++ b/tests/shell/testcases/netns/0003many_0
@@ -11,13 +11,7 @@ if [ ! -x "$IP" ] ; then
 	exit 1
 fi
 
-MKTEMP=$(which mktemp)
-if [ -x $MKTEMP ] ; then
-	tmpfile=$(${MKTEMP})
-else
-	tmpfile=$(/tmp/${RANDOM})
-fi
-
+tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
 	exit 0
diff --git a/tests/shell/testcases/nft-f/0001define_slash_0 b/tests/shell/testcases/nft-f/0001define_slash_0
index 4ce7089..bf0763d 100755
--- a/tests/shell/testcases/nft-f/0001define_slash_0
+++ b/tests/shell/testcases/nft-f/0001define_slash_0
@@ -2,13 +2,7 @@
 
 # tests for commit 85d6803 (parser_bison: initializer_expr must use rhs_expr)
 
-MKTEMP=$(which mktemp)
-if [ -x $MKTEMP ] ; then
-	tmpfile=$(${MKTEMP})
-else
-	tmpfile=$(/tmp/${RANDOM})
-fi
-
+tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
 	exit 0
diff --git a/tests/shell/testcases/nft-f/0002rollback_rule_0 b/tests/shell/testcases/nft-f/0002rollback_rule_0
index a3f6676..b1e224c 100755
--- a/tests/shell/testcases/nft-f/0002rollback_rule_0
+++ b/tests/shell/testcases/nft-f/0002rollback_rule_0
@@ -3,13 +3,7 @@
 # test a kernel rollback operation
 # fail reason: rule
 
-MKTEMP=$(which mktemp)
-if [ -x $MKTEMP ] ; then
-	tmpfile=$(${MKTEMP})
-else
-	tmpfile=$(/tmp/${RANDOM})
-fi
-
+tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
 	exit 0
diff --git a/tests/shell/testcases/nft-f/0003rollback_jump_0 b/tests/shell/testcases/nft-f/0003rollback_jump_0
index b3ebe94..567a70e 100755
--- a/tests/shell/testcases/nft-f/0003rollback_jump_0
+++ b/tests/shell/testcases/nft-f/0003rollback_jump_0
@@ -3,13 +3,7 @@
 # test a kernel rollback operation
 # fail reason: invalid jump
 
-MKTEMP=$(which mktemp)
-if [ -x $MKTEMP ] ; then
-	tmpfile=$(${MKTEMP})
-else
-	tmpfile=$(/tmp/${RANDOM})
-fi
-
+tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
 	exit 0
diff --git a/tests/shell/testcases/nft-f/0004rollback_set_0 b/tests/shell/testcases/nft-f/0004rollback_set_0
index 55043ef..3521aeb 100755
--- a/tests/shell/testcases/nft-f/0004rollback_set_0
+++ b/tests/shell/testcases/nft-f/0004rollback_set_0
@@ -3,13 +3,7 @@
 # test a kernel rollback operation
 # fail reason: invalid set
 
-MKTEMP=$(which mktemp)
-if [ -x $MKTEMP ] ; then
-	tmpfile=$(${MKTEMP})
-else
-	tmpfile=$(/tmp/${RANDOM})
-fi
-
+tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
 	exit 0
diff --git a/tests/shell/testcases/nft-f/0005rollback_map_0 b/tests/shell/testcases/nft-f/0005rollback_map_0
index 38018f6..21b6a63 100755
--- a/tests/shell/testcases/nft-f/0005rollback_map_0
+++ b/tests/shell/testcases/nft-f/0005rollback_map_0
@@ -3,13 +3,7 @@
 # test a kernel rollback operation
 # fail reason: invalid map
 
-MKTEMP=$(which mktemp)
-if [ -x $MKTEMP ] ; then
-	tmpfile=$(${MKTEMP})
-else
-	tmpfile=$(/tmp/${RANDOM})
-fi
-
+tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
 	exit 0

