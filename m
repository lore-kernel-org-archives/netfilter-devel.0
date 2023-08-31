Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E745C83F10
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 13:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbjHaNvY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 09:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242473AbjHaNvW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 09:51:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA45CEB
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 06:51:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qbi4r-0000Y4-OS; Thu, 31 Aug 2023 15:51:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC] tests: add feature probing
Date:   Thu, 31 Aug 2023 15:51:06 +0200
Message-ID: <20230831135112.30306-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Running selftests on older kernels makes some of them fail very early
because some tests use features that are not available on older
kernels, e.g. -stable releases.

Known examples:
- inner header matching
- anonymous chains
- elem delete from packet path

Also, some test cases might fail because a feature isn't
compiled in, such as netdev chains for example.

This adds a feature-probing to the shell tests.

Simply drop a 'nft -f' compatible file with a .nft suffix into
tests/shell/features.

run-tests.sh will load it via --check and will add

NFT_TESTS_HAVE_${filename}=$?

to the environment.

The test script can then either elide a part of the test
or replace it with a supported feature subset.

This adds the probing skeleton, a probe file for chain_binding
and alters 30s-stress to suppress anonon chains when its unuspported.

Note that 30s-stress is optionally be run standalone, so this adds
more code than needed, for tests that always run via run-tests.sh
its enough to do

[ $NFT_HAVE_chain_binding -eq 1 ] && test_chain_binding

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Not yet fully tested, so RFC tag.

 tests/shell/features/chain_binding.nft        |  5 ++
 tests/shell/run-tests.sh                      | 23 ++++++++
 tests/shell/testcases/transactions/30s-stress | 52 ++++++++++++++++---
 3 files changed, 73 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/features/chain_binding.nft

diff --git a/tests/shell/features/chain_binding.nft b/tests/shell/features/chain_binding.nft
new file mode 100644
index 000000000000..eac8b941ab5c
--- /dev/null
+++ b/tests/shell/features/chain_binding.nft
@@ -0,0 +1,5 @@
+table ip t {
+	chain c {
+		jump { counter; }
+	}
+}
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index b66ef4fa4d1f..3855bd9f4768 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -163,6 +163,23 @@ ok=0
 failed=0
 taint=0
 
+check_features()
+{
+	for ffilename in features/*.nft; do
+		feature=${ffilename#*/}
+		feature=${feature%*.nft}
+		eval NFT_HAVE_${feature}=0
+		$NFT -f "$ffilename" 2>/dev/null
+		if [ $? -eq 0 ]; then
+			eval NFT_HAVE_${feature}=1
+		else
+			echo "WARNING: Disabling feature $feature" 1>&2
+		fi
+
+		export NFT_HAVE_${feature}
+	done
+}
+
 check_taint()
 {
 	read taint_now < /proc/sys/kernel/tainted
@@ -211,6 +228,7 @@ check_kmemleak()
 	fi
 }
 
+check_features
 check_taint
 
 for testfile in $(find_tests)
@@ -277,5 +295,10 @@ check_kmemleak_force
 
 msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
 
+if [ "$VERBOSE" == "y" ] ; then
+	echo "Used Features:"
+	env | grep NFT_HAVE_
+fi
+
 kernel_cleanup
 [ "$failed" -eq 0 ]
diff --git a/tests/shell/testcases/transactions/30s-stress b/tests/shell/testcases/transactions/30s-stress
index 4d3317e22b0c..924e7e28f97e 100755
--- a/tests/shell/testcases/transactions/30s-stress
+++ b/tests/shell/testcases/transactions/30s-stress
@@ -16,6 +16,18 @@ if [ x = x"$NFT" ] ; then
 	NFT=nft
 fi
 
+if [ -z $NFT_HAVE_chain_binding ];then
+	NFT_HAVE_chain_binding=0
+	mydir=$(dirname $0)
+	$NFT --check -f $mydir/../../features/chain_binding.nft
+	if [ $? -eq 0 ];then
+		NFT_HAVE_chain_binding=1
+	else
+		echo "Assuming anonymous chains are not supported"
+	fi
+
+fi
+
 testns=testns-$(mktemp -u "XXXXXXXX")
 tmp=""
 
@@ -31,8 +43,8 @@ failslab_defaults() {
 	# allow all slabs to fail (if process is tagged).
 	find /sys/kernel/slab/ -wholename '*/kmalloc-[0-9]*/failslab' -type f -exec sh -c 'echo 1 > {}' \;
 
-	# no limit on the number of failures
-	echo -1 > /sys/kernel/debug/failslab/times
+	# no limit on the number of failures, or clause works around old kernels that reject negative integer.
+	echo -1 > /sys/kernel/debug/failslab/times 2>/dev/null || printf '%#x -1' > /sys/kernel/debug/failslab/times
 
 	# Set to 2 for full dmesg traces for each injected error
 	echo 0 > /sys/kernel/debug/failslab/verbose
@@ -91,6 +103,15 @@ nft_with_fault_inject()
 trap cleanup EXIT
 tmp=$(mktemp)
 
+jump_or_goto()
+{
+	if [ $((RANDOM & 1)) -eq 0 ] ;then
+		echo -n "jump"
+	else
+		echo -n "goto"
+	fi
+}
+
 random_verdict()
 {
 	max="$1"
@@ -102,7 +123,8 @@ random_verdict()
 	rnd=$((RANDOM%max))
 
 	if [ $rnd -gt 0 ];then
-		printf "jump chain%03u" "$((rnd+1))"
+		jump_or_goto
+		printf " chain%03u" "$((rnd+1))"
 		return
 	fi
 
@@ -411,6 +433,21 @@ stress_all()
 	randmonitor &
 }
 
+gen_anon_chain_jump()
+{
+	echo -n "insert rule inet $@ "
+	jump_or_goto
+
+	if [ $NFT_HAVE_chain_binding -ne 1 ];then
+		echo " defaultchain"
+		return
+	fi
+
+	echo -n " { "
+	jump_or_goto
+	echo " defaultchain; counter; }"
+}
+
 gen_ruleset() {
 echo > "$tmp"
 for table in $tables; do
@@ -452,12 +489,13 @@ for table in $tables; do
 	echo "insert rule inet $table $chain ip6 saddr { ::1, dead::beef } counter" comment hash >> "$tmp"
 	echo "insert rule inet $table $chain ip saddr { 1.2.3.4 - 5.6.7.8, 127.0.0.1 } comment rbtree" >> "$tmp"
 	# bitmap 1byte, with anon chain jump
-	echo "insert rule inet $table $chain ip protocol { 6, 17 } jump { jump defaultchain; counter; }" >> "$tmp"
+	gen_anon_chain_jump "$table $chain ip protocol { 6, 17 }" >> "$tmp"
+
 	# bitmap 2byte
 	echo "insert rule inet $table $chain tcp dport != { 22, 23, 80 } goto defaultchain" >> "$tmp"
 	echo "insert rule inet $table $chain tcp dport { 1-1024, 8000-8080 } jump defaultchain comment rbtree" >> "$tmp"
 	# pipapo (concat + set), with goto anonymous chain.
-	echo "insert rule inet $table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 } goto { jump defaultchain; counter; }" >> "$tmp"
+	gen_anon_chain_jump "$table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
 
 	# add a few anonymous sets. rhashtable is convered by named sets below.
 	c=$((RANDOM%$count))
@@ -466,12 +504,12 @@ for table in $tables; do
 	echo "insert rule inet $table $chain ip6 saddr { ::1, dead::beef } counter" comment hash >> "$tmp"
 	echo "insert rule inet $table $chain ip saddr { 1.2.3.4 - 5.6.7.8, 127.0.0.1 } comment rbtree" >> "$tmp"
 	# bitmap 1byte, with anon chain jump
-	echo "insert rule inet $table $chain ip protocol { 6, 17 } jump { jump defaultchain; counter; }" >> "$tmp"
+	gen_anon_chain_jump "$table $chain ip protocol { 6, 17 }" >> "$tmp"
 	# bitmap 2byte
 	echo "insert rule inet $table $chain tcp dport != { 22, 23, 80 } goto defaultchain" >> "$tmp"
 	echo "insert rule inet $table $chain tcp dport { 1-1024, 8000-8080 } jump defaultchain comment rbtree" >> "$tmp"
 	# pipapo (concat + set), with goto anonymous chain.
-	echo "insert rule inet $table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 } goto { jump defaultchain; counter; }" >> "$tmp"
+	gen_anon_chain_jump "$table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
 
 	# add constant/immutable sets
 	size=$((RANDOM%5120000))
-- 
2.41.0

