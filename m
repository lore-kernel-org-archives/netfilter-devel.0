Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811B7C33CB3
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 16:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 498CA2075B
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 16:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgANQqi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 11:46:38 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:45652 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbgANQqh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 11:46:37 -0500
Received: from localhost ([::1]:58742 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1irPKu-0001ev-5l; Tue, 14 Jan 2020 17:46:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] tests: shell: Search diff tool once and for all
Date:   Tue, 14 Jan 2020 17:46:29 +0100
Message-Id: <20200114164630.2492-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of calling 'which diff' over and over again, just detect the
tool's presence in run-tests.sh and pass $DIFF to each testcase just
like with nft binary.

Fall back to using 'true' command to avoid the need for any conditional
calling in test cases.

While being at it, unify potential diff calls so that a string
comparison in shell happens irrespective of diff presence.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/run-tests.sh                             |  7 ++++++-
 tests/shell/testcases/flowtable/0010delete_handle_0  |  3 +--
 tests/shell/testcases/listing/0003table_0            |  6 ++----
 tests/shell/testcases/listing/0004table_0            |  3 +--
 tests/shell/testcases/listing/0005ruleset_ip_0       |  3 +--
 tests/shell/testcases/listing/0006ruleset_ip6_0      |  3 +--
 tests/shell/testcases/listing/0007ruleset_inet_0     |  3 +--
 tests/shell/testcases/listing/0008ruleset_arp_0      |  3 +--
 tests/shell/testcases/listing/0009ruleset_bridge_0   |  3 +--
 tests/shell/testcases/listing/0010sets_0             |  3 +--
 tests/shell/testcases/listing/0011sets_0             |  3 +--
 tests/shell/testcases/listing/0012sets_0             |  3 +--
 tests/shell/testcases/listing/0013objects_0          |  3 +--
 tests/shell/testcases/listing/0014objects_0          |  6 ++----
 tests/shell/testcases/listing/0015dynamic_0          |  3 +--
 tests/shell/testcases/listing/0017objects_0          |  3 +--
 tests/shell/testcases/listing/0018data_0             |  3 +--
 tests/shell/testcases/listing/0019set_0              |  3 +--
 tests/shell/testcases/listing/0020flowtable_0        |  3 +--
 .../shell/testcases/maps/0003map_add_many_elements_0 |  3 +--
 .../testcases/maps/0004interval_map_create_once_0    |  3 +--
 tests/shell/testcases/maps/0008interval_map_delete_0 |  3 +--
 tests/shell/testcases/netns/0001nft-f_0              |  3 +--
 tests/shell/testcases/netns/0002loosecommands_0      |  3 +--
 tests/shell/testcases/netns/0003many_0               |  3 +--
 tests/shell/testcases/nft-f/0016redefines_1          |  3 +--
 .../testcases/optionals/delete_object_handles_0      |  3 +--
 .../testcases/optionals/update_object_handles_0      |  3 +--
 .../rule_management/0001addinsertposition_0          | 12 ++++--------
 tests/shell/testcases/sets/0028delete_handle_0       |  3 +--
 .../testcases/sets/0036add_set_element_expiration_0  |  5 ++++-
 tests/shell/testcases/transactions/0003table_0       |  4 +---
 tests/shell/testcases/transactions/0040set_0         |  3 +--
 33 files changed, 46 insertions(+), 75 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 632cccee0af29..29a2c3988cdcd 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -43,6 +43,11 @@ if [ ! -x "$MODPROBE" ] ; then
 	msg_error "no modprobe binary found"
 fi
 
+DIFF="$(which diff)"
+if [ ! -x "$DIFF" ] ; then
+	DIFF=true
+fi
+
 if [ "$1" == "-v" ] ; then
 	VERBOSE=y
 	shift
@@ -96,7 +101,7 @@ do
 	kernel_cleanup
 
 	msg_info "[EXECUTING]	$testfile"
-	test_output=$(NFT=$NFT ${testfile} 2>&1)
+	test_output=$(NFT=$NFT DIFF=$DIFF ${testfile} 2>&1)
 	rc_got=$?
 	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 
diff --git a/tests/shell/testcases/flowtable/0010delete_handle_0 b/tests/shell/testcases/flowtable/0010delete_handle_0
index 985d4a3ad6ce2..8dd8d9fdab002 100755
--- a/tests/shell/testcases/flowtable/0010delete_handle_0
+++ b/tests/shell/testcases/flowtable/0010delete_handle_0
@@ -16,7 +16,6 @@ EXPECTED="table inet t {
 
 GET="$($NFT list ruleset)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0003table_0 b/tests/shell/testcases/listing/0003table_0
index 1b288e43ae5ff..5060be01cd9b8 100755
--- a/tests/shell/testcases/listing/0003table_0
+++ b/tests/shell/testcases/listing/0003table_0
@@ -11,15 +11,13 @@ $NFT add table test
 
 GET="$($NFT list table test)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
 
 # also this way
 GET="$($NFT list table ip test)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0004table_0 b/tests/shell/testcases/listing/0004table_0
index 2c7c995203b85..1d69119f338d7 100755
--- a/tests/shell/testcases/listing/0004table_0
+++ b/tests/shell/testcases/listing/0004table_0
@@ -12,8 +12,7 @@ $NFT add table test2
 
 GET="$($NFT list table test)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
 
diff --git a/tests/shell/testcases/listing/0005ruleset_ip_0 b/tests/shell/testcases/listing/0005ruleset_ip_0
index c326680629f4e..39c0328261ed1 100755
--- a/tests/shell/testcases/listing/0005ruleset_ip_0
+++ b/tests/shell/testcases/listing/0005ruleset_ip_0
@@ -15,7 +15,6 @@ $NFT add table bridge test
 
 GET="$($NFT list ruleset ip)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0006ruleset_ip6_0 b/tests/shell/testcases/listing/0006ruleset_ip6_0
index 093d5a57f6b7a..1b67f50cf0a36 100755
--- a/tests/shell/testcases/listing/0006ruleset_ip6_0
+++ b/tests/shell/testcases/listing/0006ruleset_ip6_0
@@ -15,7 +15,6 @@ $NFT add table bridge test
 
 GET="$($NFT list ruleset ip6)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0007ruleset_inet_0 b/tests/shell/testcases/listing/0007ruleset_inet_0
index b24cc4c0dadb0..257c7a908cfec 100755
--- a/tests/shell/testcases/listing/0007ruleset_inet_0
+++ b/tests/shell/testcases/listing/0007ruleset_inet_0
@@ -15,7 +15,6 @@ $NFT add table bridge test
 
 GET="$($NFT list ruleset inet)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0008ruleset_arp_0 b/tests/shell/testcases/listing/0008ruleset_arp_0
index fff0fee3244dc..be42c4789a1f6 100755
--- a/tests/shell/testcases/listing/0008ruleset_arp_0
+++ b/tests/shell/testcases/listing/0008ruleset_arp_0
@@ -15,7 +15,6 @@ $NFT add table bridge test
 
 GET="$($NFT list ruleset arp)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0009ruleset_bridge_0 b/tests/shell/testcases/listing/0009ruleset_bridge_0
index 247ed47706acb..c6a99f509f37d 100755
--- a/tests/shell/testcases/listing/0009ruleset_bridge_0
+++ b/tests/shell/testcases/listing/0009ruleset_bridge_0
@@ -15,7 +15,6 @@ $NFT add table bridge test
 
 GET="$($NFT list ruleset bridge)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0010sets_0 b/tests/shell/testcases/listing/0010sets_0
index 855cceb85932b..0f5f2bd56611b 100755
--- a/tests/shell/testcases/listing/0010sets_0
+++ b/tests/shell/testcases/listing/0010sets_0
@@ -57,7 +57,6 @@ $NFT add set inet filter set2 { type icmpv6_type \; }
 
 GET="$($NFT list sets)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0011sets_0 b/tests/shell/testcases/listing/0011sets_0
index aac9eac93ff66..b6f12b59533b3 100755
--- a/tests/shell/testcases/listing/0011sets_0
+++ b/tests/shell/testcases/listing/0011sets_0
@@ -38,7 +38,6 @@ $NFT add rule inet filter test tcp dport {80, 443}
 GET="$($NFT list sets)"
 
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0012sets_0 b/tests/shell/testcases/listing/0012sets_0
index da16d94d5a60f..6e4c959034aae 100755
--- a/tests/shell/testcases/listing/0012sets_0
+++ b/tests/shell/testcases/listing/0012sets_0
@@ -33,7 +33,6 @@ $NFT add set inet filter set2 { type icmpv6_type \; }
 
 GET="$($NFT list sets inet)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0013objects_0 b/tests/shell/testcases/listing/0013objects_0
index f6915796eacf2..4d39143d9ce03 100755
--- a/tests/shell/testcases/listing/0013objects_0
+++ b/tests/shell/testcases/listing/0013objects_0
@@ -42,7 +42,6 @@ $NFT add table test-ip
 
 GET="$($NFT list table test)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0014objects_0 b/tests/shell/testcases/listing/0014objects_0
index 20f68406e58fa..31d94f8621604 100755
--- a/tests/shell/testcases/listing/0014objects_0
+++ b/tests/shell/testcases/listing/0014objects_0
@@ -17,15 +17,13 @@ $NFT add table test-ip
 
 GET="$($NFT list quotas)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
 
 GET="$($NFT list quota test https-quota)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
 
diff --git a/tests/shell/testcases/listing/0015dynamic_0 b/tests/shell/testcases/listing/0015dynamic_0
index 4ff74e321b8c4..65fbe62cbdf6e 100755
--- a/tests/shell/testcases/listing/0015dynamic_0
+++ b/tests/shell/testcases/listing/0015dynamic_0
@@ -16,8 +16,7 @@ $NFT -f - <<< "$EXPECTED"
 
 GET="$($NFT list set ip filter test_set)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
 
diff --git a/tests/shell/testcases/listing/0017objects_0 b/tests/shell/testcases/listing/0017objects_0
index 8a586e8034f9c..c4e72db0cd5f8 100755
--- a/tests/shell/testcases/listing/0017objects_0
+++ b/tests/shell/testcases/listing/0017objects_0
@@ -13,7 +13,6 @@ $NFT flush map inet filter countermap
 
 GET="$($NFT list map inet filter countermap)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0018data_0 b/tests/shell/testcases/listing/0018data_0
index 544b6bf588e23..4af253dceeace 100755
--- a/tests/shell/testcases/listing/0018data_0
+++ b/tests/shell/testcases/listing/0018data_0
@@ -13,7 +13,6 @@ $NFT flush map inet filter ipmap
 
 GET="$($NFT list map inet filter ipmap)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0019set_0 b/tests/shell/testcases/listing/0019set_0
index 54a8a06440793..6e8cb4d6f9ef7 100755
--- a/tests/shell/testcases/listing/0019set_0
+++ b/tests/shell/testcases/listing/0019set_0
@@ -13,7 +13,6 @@ $NFT flush set inet filter ipset
 
 GET="$($NFT list set inet filter ipset)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/listing/0020flowtable_0 b/tests/shell/testcases/listing/0020flowtable_0
index 6f630f14a8ba9..2f0a98d16fd38 100755
--- a/tests/shell/testcases/listing/0020flowtable_0
+++ b/tests/shell/testcases/listing/0020flowtable_0
@@ -15,7 +15,6 @@ $NFT -f - <<< "$EXPECTED"
 
 GET="$($NFT list flowtable inet filter f)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/maps/0003map_add_many_elements_0 b/tests/shell/testcases/maps/0003map_add_many_elements_0
index 047f9497dff0d..2b254c51b3c3f 100755
--- a/tests/shell/testcases/maps/0003map_add_many_elements_0
+++ b/tests/shell/testcases/maps/0003map_add_many_elements_0
@@ -61,8 +61,7 @@ EXPECTED="table ip x {
 }"
 GET=$($NFT list ruleset)
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
 
diff --git a/tests/shell/testcases/maps/0004interval_map_create_once_0 b/tests/shell/testcases/maps/0004interval_map_create_once_0
index 58b399c116218..3de0c9de4f934 100755
--- a/tests/shell/testcases/maps/0004interval_map_create_once_0
+++ b/tests/shell/testcases/maps/0004interval_map_create_once_0
@@ -60,8 +60,7 @@ EXPECTED="table ip x {
 }"
 GET=$($NFT list ruleset)
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
 
diff --git a/tests/shell/testcases/maps/0008interval_map_delete_0 b/tests/shell/testcases/maps/0008interval_map_delete_0
index 7da6eb38ddf73..39ea3127be89a 100755
--- a/tests/shell/testcases/maps/0008interval_map_delete_0
+++ b/tests/shell/testcases/maps/0008interval_map_delete_0
@@ -26,7 +26,6 @@ $NFT add element filter m { 127.0.0.2 : 0x2 }
 
 GET=$($NFT -s list ruleset)
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/netns/0001nft-f_0 b/tests/shell/testcases/netns/0001nft-f_0
index 819422638339d..a591f2cdf863d 100755
--- a/tests/shell/testcases/netns/0001nft-f_0
+++ b/tests/shell/testcases/netns/0001nft-f_0
@@ -93,8 +93,7 @@ fi
 KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset)"
 $IP netns del $NETNS_NAME
 if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
-        DIFF="$(which diff)"
-        [ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
+        $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
         exit 1
 fi
 exit 0
diff --git a/tests/shell/testcases/netns/0002loosecommands_0 b/tests/shell/testcases/netns/0002loosecommands_0
index 465c2e8646dc0..231f1fb7c0f0d 100755
--- a/tests/shell/testcases/netns/0002loosecommands_0
+++ b/tests/shell/testcases/netns/0002loosecommands_0
@@ -56,7 +56,6 @@ RULESET="table ip t {
 KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset)"
 $IP netns del $NETNS_NAME
 if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
-        DIFF="$(which diff)"
-        [ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
+        $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
         exit 1
 fi
diff --git a/tests/shell/testcases/netns/0003many_0 b/tests/shell/testcases/netns/0003many_0
index a5fcb5d6b2ef4..afe9117dd501c 100755
--- a/tests/shell/testcases/netns/0003many_0
+++ b/tests/shell/testcases/netns/0003many_0
@@ -97,8 +97,7 @@ function test_netns()
 	KERNEL_RULESET="$($IP netns exec $NETNS_NAME $NFT list ruleset)"
 	if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
 		echo "E: ruleset in netns $NETNS_NAME differs from the loaded" >&2
-	        DIFF="$(which diff)"
-	        [ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
+	        $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
 		$IP netns del $NETNS_NAME
 	        exit 1
 	fi
diff --git a/tests/shell/testcases/nft-f/0016redefines_1 b/tests/shell/testcases/nft-f/0016redefines_1
index 4c26b3796fbf6..1f59f6b8233df 100755
--- a/tests/shell/testcases/nft-f/0016redefines_1
+++ b/tests/shell/testcases/nft-f/0016redefines_1
@@ -26,8 +26,7 @@ $NFT -f - <<< "$RULESET"
 GET="$($NFT list ruleset)"
 
 if [ "$EXPECTED" != "$GET" ] ; then
-        DIFF="$(which diff)"
-        [ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+        $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
         exit 1
 fi
 
diff --git a/tests/shell/testcases/optionals/delete_object_handles_0 b/tests/shell/testcases/optionals/delete_object_handles_0
index a2ae4228d6fa4..9b65e6771e169 100755
--- a/tests/shell/testcases/optionals/delete_object_handles_0
+++ b/tests/shell/testcases/optionals/delete_object_handles_0
@@ -37,7 +37,6 @@ table ip6 test-ip6 {
 GET="$($NFT list ruleset)"
 
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/optionals/update_object_handles_0 b/tests/shell/testcases/optionals/update_object_handles_0
index 17c0c86cf9b0f..8b12b8c57cd8b 100755
--- a/tests/shell/testcases/optionals/update_object_handles_0
+++ b/tests/shell/testcases/optionals/update_object_handles_0
@@ -19,7 +19,6 @@ EXPECTED="table ip test-ip {
 
 GET="$($NFT list ruleset)"
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/rule_management/0001addinsertposition_0 b/tests/shell/testcases/rule_management/0001addinsertposition_0
index bb3fda51c27f0..237e9e3204c93 100755
--- a/tests/shell/testcases/rule_management/0001addinsertposition_0
+++ b/tests/shell/testcases/rule_management/0001addinsertposition_0
@@ -30,8 +30,7 @@ for arg in "position 2" "handle 2" "index 0"; do
 
 	GET="$($NFT list ruleset)"
 	if [ "$EXPECTED" != "$GET" ] ; then
-		DIFF="$(which diff)"
-		[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+		$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 		exit 1
 	fi
 done
@@ -42,8 +41,7 @@ for arg in "position 3" "handle 3" "index 1"; do
 
 	GET="$($NFT list ruleset)"
 	if [ "$EXPECTED" != "$GET" ] ; then
-		DIFF="$(which diff)"
-		[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+		$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 		exit 1
 	fi
 done
@@ -62,8 +60,7 @@ for arg in "position 3" "handle 3" "index 1"; do
 
 	GET="$($NFT list ruleset)"
 	if [ "$EXPECTED" != "$GET" ] ; then
-		DIFF="$(which diff)"
-		[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+		$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 		exit 1
 	fi
 done
@@ -82,8 +79,7 @@ for arg in "position 2" "handle 2" "index 0"; do
 
 	GET="$($NFT list ruleset)"
 	if [ "$EXPECTED" != "$GET" ] ; then
-		DIFF="$(which diff)"
-		[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+		$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 		exit 1
 	fi
 done
diff --git a/tests/shell/testcases/sets/0028delete_handle_0 b/tests/shell/testcases/sets/0028delete_handle_0
index 5ad17c223db27..c6d1253424e7d 100755
--- a/tests/shell/testcases/sets/0028delete_handle_0
+++ b/tests/shell/testcases/sets/0028delete_handle_0
@@ -29,7 +29,6 @@ EXPECTED="table ip test-ip {
 GET="$($NFT list ruleset)"
 
 if [ "$EXPECTED" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
index 8dfed6c1a6446..51ed0f2c1b3e8 100755
--- a/tests/shell/testcases/sets/0036add_set_element_expiration_0
+++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
@@ -8,6 +8,9 @@ add element ip x y { 1.1.1.1 timeout 30s expires 15s }"
 
 test_output=$($NFT -e -f - <<< "$RULESET" 2>&1)
 
-diff -u <(echo "$test_output") <(echo "$RULESET")
+if [ "$test_output" != "$RULESET" ] ; then
+	$DIFF -u <(echo "$test_output") <(echo "$RULESET")
+	exit 1
+fi
 
 $NFT "add chain ip x c; add rule ip x c ip saddr @y"
diff --git a/tests/shell/testcases/transactions/0003table_0 b/tests/shell/testcases/transactions/0003table_0
index 6861eabab1256..91186deca13d0 100755
--- a/tests/shell/testcases/transactions/0003table_0
+++ b/tests/shell/testcases/transactions/0003table_0
@@ -14,7 +14,6 @@ fi
 
 KERNEL_RULESET="$($NFT list ruleset)"
 if [ "" != "$KERNEL_RULESET" ] ; then
-	DIFF="$(which diff)"
 	echo "Got a ruleset, but expected empty: "
 	echo "$KERNEL_RULESET"
 	exit 1
@@ -42,7 +41,6 @@ $NFT -f - <<< "$RULESETFAIL" && exit 2
 
 KERNEL_RULESET="$($NFT list ruleset)"
 if [ "$RULESET" != "$KERNEL_RULESET" ] ; then
-        DIFF="$(which diff)"
-        [ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
+        $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
         exit 1
 fi
diff --git a/tests/shell/testcases/transactions/0040set_0 b/tests/shell/testcases/transactions/0040set_0
index a404abc8e029d..468816b03b504 100755
--- a/tests/shell/testcases/transactions/0040set_0
+++ b/tests/shell/testcases/transactions/0040set_0
@@ -29,8 +29,7 @@ fi
 GET="$($NFT list ruleset)"
 
 if [ "$RULESET" != "$GET" ] ; then
-	DIFF="$(which diff)"
-	[ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$GET")
+	$DIFF -u <(echo "$RULESET") <(echo "$GET")
 	exit 1
 fi
 
-- 
2.24.1

