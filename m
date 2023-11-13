Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB9BC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 13:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjKMNjM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 08:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjKMNjL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 08:39:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 886B6D53
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 05:39:06 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft,v2 01/11] tests: shell: skip pipapo tests if kernel lacks support
Date:   Mon, 13 Nov 2023 14:38:48 +0100
Message-Id: <20231113133858.121324-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip tests that require net/netfilter/nft_set_pipapo support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use git describe --contains, requested by Florian.

 tests/shell/features/pipapo.nft                      |  9 +++++++++
 tests/shell/testcases/maps/0013map_0                 |  2 ++
 tests/shell/testcases/maps/anon_objmap_concat        |  2 ++
 tests/shell/testcases/maps/typeof_integer_0          |  2 ++
 .../shell/testcases/optimizations/merge_stmts_concat |  2 ++
 tests/shell/testcases/optimizations/merge_vmap_raw   |  2 ++
 tests/shell/testcases/sets/0034get_element_0         |  2 ++
 tests/shell/testcases/sets/0043concatenated_ranges_0 |  1 +
 tests/shell/testcases/sets/0043concatenated_ranges_1 |  2 ++
 tests/shell/testcases/sets/0044interval_overlap_0    | 12 ++++++++++--
 tests/shell/testcases/sets/0047nat_0                 |  2 ++
 tests/shell/testcases/sets/concat_interval_0         |  2 ++
 12 files changed, 38 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/features/pipapo.nft

diff --git a/tests/shell/features/pipapo.nft b/tests/shell/features/pipapo.nft
new file mode 100644
index 000000000000..3557721e62d4
--- /dev/null
+++ b/tests/shell/features/pipapo.nft
@@ -0,0 +1,9 @@
+# 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
+# v5.6-rc1~151^2~28^2~1
+table t {
+	set s {
+		type ipv4_addr . inet_service
+		flags interval
+		elements = { 1.1.1.1-2.2.2.2 . 80-90 }
+	}
+}
diff --git a/tests/shell/testcases/maps/0013map_0 b/tests/shell/testcases/maps/0013map_0
index 70d7fd3b002f..c8d20cee7ca7 100755
--- a/tests/shell/testcases/maps/0013map_0
+++ b/tests/shell/testcases/maps/0013map_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 set -e
 
 RULESET="
diff --git a/tests/shell/testcases/maps/anon_objmap_concat b/tests/shell/testcases/maps/anon_objmap_concat
index 07820b7c4fdd..34465f1da0be 100755
--- a/tests/shell/testcases/maps/anon_objmap_concat
+++ b/tests/shell/testcases/maps/anon_objmap_concat
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 set -e
 dumpfile=$(dirname $0)/dumps/$(basename $0).nft
 
diff --git a/tests/shell/testcases/maps/typeof_integer_0 b/tests/shell/testcases/maps/typeof_integer_0
index 0deff5eef67b..e93604e849c7 100755
--- a/tests/shell/testcases/maps/typeof_integer_0
+++ b/tests/shell/testcases/maps/typeof_integer_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 EXPECTED="table inet t {
 	map m1 {
 		typeof udp length . @ih,32,32 : verdict
diff --git a/tests/shell/testcases/optimizations/merge_stmts_concat b/tests/shell/testcases/optimizations/merge_stmts_concat
index 9679d86223fd..4db4a6f90944 100755
--- a/tests/shell/testcases/optimizations/merge_stmts_concat
+++ b/tests/shell/testcases/optimizations/merge_stmts_concat
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 set -e
 
 RULESET="table ip x {
diff --git a/tests/shell/testcases/optimizations/merge_vmap_raw b/tests/shell/testcases/optimizations/merge_vmap_raw
index f3dc0721b94f..eb04bec3ae69 100755
--- a/tests/shell/testcases/optimizations/merge_vmap_raw
+++ b/tests/shell/testcases/optimizations/merge_vmap_raw
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 set -e
 
 RULESET="table inet x {
diff --git a/tests/shell/testcases/sets/0034get_element_0 b/tests/shell/testcases/sets/0034get_element_0
index 3343529b8ffa..32375b9f50c2 100755
--- a/tests/shell/testcases/sets/0034get_element_0
+++ b/tests/shell/testcases/sets/0034get_element_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 RC=0
 
 check() { # (set, elems, expected)
diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests/shell/testcases/sets/0043concatenated_ranges_0
index 83d743503c7b..a3dbf5bf28ba 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_0
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
@@ -1,5 +1,6 @@
 #!/bin/bash -e
 #
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
 # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
 #
 # 0043concatenated_ranges_0 - Add, get, list, timeout for concatenated ranges
diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_1 b/tests/shell/testcases/sets/0043concatenated_ranges_1
index 1be2889352c9..bb3bf6b27ea7 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_1
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_1
@@ -2,6 +2,8 @@
 #
 # 0043concatenated_ranges_1 - Insert and list subnets of different sizes
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 check() {
 	$NFT add element "${1}" t s "{ ${2} . ${3} }"
 	[ "$( $NFT list set "${1}" t s | grep -c "${2} . ${3}" )" = 1 ]
diff --git a/tests/shell/testcases/sets/0044interval_overlap_0 b/tests/shell/testcases/sets/0044interval_overlap_0
index 71bf3345a558..b0f51cc8873b 100755
--- a/tests/shell/testcases/sets/0044interval_overlap_0
+++ b/tests/shell/testcases/sets/0044interval_overlap_0
@@ -117,7 +117,11 @@ add_elements() {
 	IFS='	
 '
 	for t in ${intervals_simple} switch ${intervals_concat}; do
+if [ "$NFT_TEST_HAVE_pipapo" = y ] ; then
 		[ "${t}" = "switch" ] && set="c"         && continue
+else
+		break
+fi
 		[ -z "${pass}" ]      && pass="${t}"     && continue
 		[ -z "${interval}" ]  && interval="${t}" && continue
 		unset IFS
@@ -148,7 +152,9 @@ add_elements() {
 
 $NFT add table t
 $NFT add set t s '{ type inet_service ; flags interval ; }'
-$NFT add set t c '{ type inet_service . inet_service ; flags interval ; }'
+if [ "$NFT_TEST_HAVE_pipapo" = y ] ; then
+	$NFT add set t c '{ type inet_service . inet_service ; flags interval ; }'
+fi
 add_elements
 
 $NFT flush ruleset
@@ -157,7 +163,9 @@ estimate_timeout
 $NFT flush ruleset
 $NFT add table t
 $NFT add set t s "{ type inet_service ; flags interval,timeout; timeout ${timeout}s; gc-interval ${timeout}s; }"
-$NFT add set t c "{ type inet_service . inet_service ; flags interval,timeout ; timeout ${timeout}s; gc-interval ${timeout}s; }"
+if [ "$NFT_TEST_HAVE_pipapo" = y ] ; then
+	$NFT add set t c "{ type inet_service . inet_service ; flags interval,timeout ; timeout ${timeout}s; gc-interval ${timeout}s; }"
+fi
 add_elements
 
 sleep $((timeout * 3 / 2))
diff --git a/tests/shell/testcases/sets/0047nat_0 b/tests/shell/testcases/sets/0047nat_0
index 4e53b7b8e8c8..757605ee3492 100755
--- a/tests/shell/testcases/sets/0047nat_0
+++ b/tests/shell/testcases/sets/0047nat_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 EXPECTED="table ip x {
             map y {
                     type ipv4_addr : interval ipv4_addr
diff --git a/tests/shell/testcases/sets/concat_interval_0 b/tests/shell/testcases/sets/concat_interval_0
index 4d90af9a6557..36138ae0de78 100755
--- a/tests/shell/testcases/sets/concat_interval_0
+++ b/tests/shell/testcases/sets/concat_interval_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_pipapo)
+
 set -e
 
 RULESET="table ip t {
-- 
2.30.2

