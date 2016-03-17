From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: unload modules between tests
Date: Thu, 17 Mar 2016 09:34:47 +0100
Message-ID: <145820368731.17259.3174729391842967272.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34448 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932676AbcCQIfG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 04:35:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adjusts the main test script so it unload all nftables
kernel modules between tests.

This way we achieve two interesting things:
 * avoid false errors in some testcases due to module loading order
 * the module loading/unloading path itself

The false positives is for example, listing ruleset per families, which depends
on the loading order of nf_tables_xx modules.

We can later add more modules to unload incrementally (for
example nf_tables_switchdev).

This patch assumes we are working with a kernel which is compiled with
nf_tables =m, the case using =y is not supported and can still produce false
positives in some testcases due to module ordering.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/run-tests.sh |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index df2670b..c08a3eb 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -37,16 +37,37 @@ if [ ! -x "$FIND" ] ; then
 	msg_error "no find binary found"
 fi
 
+MODPROBE="$(which modprobe)"
+if [ ! -x "$MODPROBE" ] ; then
+	msg_error "no modprobe binary found"
+fi
+
 if [ "$1" == "-v" ] ; then
 	VERBOSE=y
 fi
 
+kernel_cleanup() {
+	$NFT flush ruleset
+	$MODPROBE -rq \
+	nft_reject_ipv4 nft_reject_ipv6 nft_bridge_reject \
+	nft_reject_ipv6 nft_reject \
+	nft_redir_ipv4 nft_redir_ipv6 nft_redir \
+	nft_dup_ipv4 nft_dup_ipv6 nft_dup \
+	nft_nat_ipv4 nft_nat_ipv6 nft_nat \
+	nft_masq_ipv4 nft_masq_ipv6 nft_masq \
+	nft_exthdr nft_payload nft_cmp \
+	nft_meta nft_bridge_meta nft_counter nft_log nft_limit \
+	nft_hash nft_rbtree nft_ct nft_compat \
+	nf_tables_inet nf_tables_bridge nf_tables_arp \
+	nf_tables_ipv4 nf_tables_ipv6 nf_tables
+}
+
 echo ""
 ok=0
 failed=0
 for testfile in $(${FIND} ${TESTDIR} -executable -regex .*${RETURNCODE_SEPARATOR}[0-9]+)
 do
-	$NFT flush ruleset
+	kernel_cleanup
 
 	rc_spec=$(awk -F${RETURNCODE_SEPARATOR} '{print $NF}' <<< $testfile)
 	test_output=$(NFT=$NFT ${testfile} ${TESTS_OUTPUT} 2>&1)
@@ -69,4 +90,4 @@ done
 echo ""
 msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
 
-$NFT flush ruleset
+kernel_cleanup

