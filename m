From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] tests: shell: make testcases which using tcp/udp port more rubost
Date: Sat, 11 Jun 2016 13:05:14 +0800
Message-ID: <1465621514-25589-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:48478 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbcFKFVJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 01:21:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

In my mechain, port 12345 is mapped to italk in /etc/services:
  italk           12345/tcp               # Italk Chat System

So when we add nft rule with udp port "12345", nft list ruleset
will displayed it as "italk", that cause the result is not same
with expected, then testcase fail.

Add "-nn" option when dump the rulesets from the kernel, make
testcases which using tcp/udp port more rubost.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 tests/shell/testcases/netns/0001nft-f_0         | 2 +-
 tests/shell/testcases/netns/0002loosecommands_0 | 2 +-
 tests/shell/testcases/netns/0003many_0          | 2 +-
 tests/shell/testcases/nft-f/0002rollback_rule_0 | 2 +-
 tests/shell/testcases/nft-f/0003rollback_jump_0 | 2 +-
 tests/shell/testcases/nft-f/0004rollback_set_0  | 2 +-
 tests/shell/testcases/nft-f/0005rollback_map_0  | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/shell/testcases/netns/0001nft-f_0 b/tests/shell/testcases/netns/0001nft-f_0
index e616363..663167d 100755
--- a/tests/shell/testcases/netns/0001nft-f_0
+++ b/tests/shell/testcases/netns/0001nft-f_0
@@ -99,7 +99,7 @@ if [ $? -ne 0 ] ; then
 	exit 1
 fi
 
-KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset)"
+KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset -nn)"
 $IP netns del $NETNS_NAME
 if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
         DIFF="$(which diff)"
diff --git a/tests/shell/testcases/netns/0002loosecommands_0 b/tests/shell/testcases/netns/0002loosecommands_0
index 1600d94..fbaa386 100755
--- a/tests/shell/testcases/netns/0002loosecommands_0
+++ b/tests/shell/testcases/netns/0002loosecommands_0
@@ -53,7 +53,7 @@ RULESET="table ip t {
 	}
 }"
 
-KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset)"
+KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset -nn)"
 $IP netns del $NETNS_NAME
 if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
         DIFF="$(which diff)"
diff --git a/tests/shell/testcases/netns/0003many_0 b/tests/shell/testcases/netns/0003many_0
index ad71ae3..f8853ee 100755
--- a/tests/shell/testcases/netns/0003many_0
+++ b/tests/shell/testcases/netns/0003many_0
@@ -104,7 +104,7 @@ function test_netns()
 		exit 1
 	fi
 
-	KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset)"
+	KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset -nn)"
 	if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
 		echo "E: ruleset in netns $NETNS_NAME differs from the loaded" >&2
 	        DIFF="$(which diff)"
diff --git a/tests/shell/testcases/nft-f/0002rollback_rule_0 b/tests/shell/testcases/nft-f/0002rollback_rule_0
index b1e224c..5518c0b 100755
--- a/tests/shell/testcases/nft-f/0002rollback_rule_0
+++ b/tests/shell/testcases/nft-f/0002rollback_rule_0
@@ -49,7 +49,7 @@ if [ $? -eq 0 ]	; then
 	exit 1
 fi
 
-KERNEL_RULESET="$($NFT list ruleset)"
+KERNEL_RULESET="$($NFT list ruleset -nn)"
 
 if [ "$GOOD_RULESET" != "$KERNEL_RULESET" ] ; then
         DIFF="$(which diff)"
diff --git a/tests/shell/testcases/nft-f/0003rollback_jump_0 b/tests/shell/testcases/nft-f/0003rollback_jump_0
index 567a70e..5c8c685 100755
--- a/tests/shell/testcases/nft-f/0003rollback_jump_0
+++ b/tests/shell/testcases/nft-f/0003rollback_jump_0
@@ -49,7 +49,7 @@ if [ $? -eq 0 ]	; then
 	exit 1
 fi
 
-KERNEL_RULESET="$($NFT list ruleset)"
+KERNEL_RULESET="$($NFT list ruleset -nn)"
 
 if [ "$GOOD_RULESET" != "$KERNEL_RULESET" ] ; then
         DIFF="$(which diff)"
diff --git a/tests/shell/testcases/nft-f/0004rollback_set_0 b/tests/shell/testcases/nft-f/0004rollback_set_0
index 3521aeb..db1c84c 100755
--- a/tests/shell/testcases/nft-f/0004rollback_set_0
+++ b/tests/shell/testcases/nft-f/0004rollback_set_0
@@ -49,7 +49,7 @@ if [ $? -eq 0 ]	; then
 	exit 1
 fi
 
-KERNEL_RULESET="$($NFT list ruleset)"
+KERNEL_RULESET="$($NFT list ruleset -nn)"
 
 if [ "$GOOD_RULESET" != "$KERNEL_RULESET" ] ; then
         DIFF="$(which diff)"
diff --git a/tests/shell/testcases/nft-f/0005rollback_map_0 b/tests/shell/testcases/nft-f/0005rollback_map_0
index 21b6a63..13bb907 100755
--- a/tests/shell/testcases/nft-f/0005rollback_map_0
+++ b/tests/shell/testcases/nft-f/0005rollback_map_0
@@ -52,7 +52,7 @@ if [ $? -eq 0 ]	; then
 	exit 1
 fi
 
-KERNEL_RULESET="$($NFT list ruleset)"
+KERNEL_RULESET="$($NFT list ruleset -nn)"
 
 if [ "$GOOD_RULESET" != "$KERNEL_RULESET" ] ; then
         DIFF="$(which diff)"
-- 
2.5.5


