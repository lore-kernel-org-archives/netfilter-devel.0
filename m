Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F674E7B61F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 14:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242790AbjJDOOi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 10:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242863AbjJDOOh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 10:14:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB96ECC;
        Wed,  4 Oct 2023 07:14:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qo2dt-0002MQ-Gc; Wed, 04 Oct 2023 16:14:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH net 4/6] selftests: netfilter: Extend nft_audit.sh
Date:   Wed,  4 Oct 2023 16:13:48 +0200
Message-ID: <20231004141405.28749-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231004141405.28749-1-fw@strlen.de>
References: <20231004141405.28749-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Add tests for sets and elements and deletion of all kinds. Also
reorder rule reset tests: By moving the bulk rule add command up, the
two 'reset rules' tests become identical.

While at it, fix for a failing bulk rule add test's error status getting
lost due to its use in a pipe. Avoid this by using a temporary file.

Headings in diff output for failing tests contain no useful data, strip
them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testing/selftests/netfilter/nft_audit.sh  | 97 ++++++++++++++++---
 1 file changed, 81 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
index 83c271b1c735..0b3255e7b353 100755
--- a/tools/testing/selftests/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -12,10 +12,11 @@ nft --version >/dev/null 2>&1 || {
 }
 
 logfile=$(mktemp)
+rulefile=$(mktemp)
 echo "logging into $logfile"
 ./audit_logread >"$logfile" &
 logread_pid=$!
-trap 'kill $logread_pid; rm -f $logfile' EXIT
+trap 'kill $logread_pid; rm -f $logfile $rulefile' EXIT
 exec 3<"$logfile"
 
 do_test() { # (cmd, log)
@@ -26,12 +27,14 @@ do_test() { # (cmd, log)
 	res=$(diff -a -u <(echo "$2") - <&3)
 	[ $? -eq 0 ] && { echo "OK"; return; }
 	echo "FAIL"
-	echo "$res"
-	((RC++))
+	grep -v '^\(---\|+++\|@@\)' <<< "$res"
+	((RC--))
 }
 
 nft flush ruleset
 
+# adding tables, chains and rules
+
 for table in t1 t2; do
 	do_test "nft add table $table" \
 	"table=$table family=2 entries=1 op=nft_register_table"
@@ -62,6 +65,28 @@ for table in t1 t2; do
 	"table=$table family=2 entries=6 op=nft_register_rule"
 done
 
+for ((i = 0; i < 500; i++)); do
+	echo "add rule t2 c3 counter accept comment \"rule $i\""
+done >$rulefile
+do_test "nft -f $rulefile" \
+'table=t2 family=2 entries=500 op=nft_register_rule'
+
+# adding sets and elements
+
+settype='type inet_service; counter'
+setelem='{ 22, 80, 443 }'
+setblock="{ $settype; elements = $setelem; }"
+do_test "nft add set t1 s $setblock" \
+"table=t1 family=2 entries=4 op=nft_register_set"
+
+do_test "nft add set t1 s2 $setblock; add set t1 s3 { $settype; }" \
+"table=t1 family=2 entries=5 op=nft_register_set"
+
+do_test "nft add element t1 s3 $setelem" \
+"table=t1 family=2 entries=3 op=nft_register_setelem"
+
+# resetting rules
+
 do_test 'nft reset rules t1 c2' \
 'table=t1 family=2 entries=3 op=nft_reset_rule'
 
@@ -70,19 +95,6 @@ do_test 'nft reset rules table t1' \
 table=t1 family=2 entries=3 op=nft_reset_rule
 table=t1 family=2 entries=3 op=nft_reset_rule'
 
-do_test 'nft reset rules' \
-'table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule'
-
-for ((i = 0; i < 500; i++)); do
-	echo "add rule t2 c3 counter accept comment \"rule $i\""
-done | do_test 'nft -f -' \
-'table=t2 family=2 entries=500 op=nft_register_rule'
-
 do_test 'nft reset rules t2 c3' \
 'table=t2 family=2 entries=189 op=nft_reset_rule
 table=t2 family=2 entries=188 op=nft_reset_rule
@@ -105,4 +117,57 @@ table=t2 family=2 entries=180 op=nft_reset_rule
 table=t2 family=2 entries=188 op=nft_reset_rule
 table=t2 family=2 entries=135 op=nft_reset_rule'
 
+# resetting sets and elements
+
+elem=(22 ,80 ,443)
+relem=""
+for i in {1..3}; do
+	relem+="${elem[((i - 1))]}"
+	do_test "nft reset element t1 s { $relem }" \
+	"table=t1 family=2 entries=$i op=nft_reset_setelem"
+done
+
+do_test 'nft reset set t1 s' \
+'table=t1 family=2 entries=3 op=nft_reset_setelem'
+
+# deleting rules
+
+readarray -t handles < <(nft -a list chain t1 c1 | \
+			 sed -n 's/.*counter.* handle \(.*\)$/\1/p')
+
+do_test "nft delete rule t1 c1 handle ${handles[0]}" \
+'table=t1 family=2 entries=1 op=nft_unregister_rule'
+
+cmd='delete rule t1 c1 handle'
+do_test "nft $cmd ${handles[1]}; $cmd ${handles[2]}" \
+'table=t1 family=2 entries=2 op=nft_unregister_rule'
+
+do_test 'nft flush chain t1 c2' \
+'table=t1 family=2 entries=3 op=nft_unregister_rule'
+
+do_test 'nft flush table t2' \
+'table=t2 family=2 entries=509 op=nft_unregister_rule'
+
+# deleting chains
+
+do_test 'nft delete chain t2 c2' \
+'table=t2 family=2 entries=1 op=nft_unregister_chain'
+
+# deleting sets and elements
+
+do_test 'nft delete element t1 s { 22 }' \
+'table=t1 family=2 entries=1 op=nft_unregister_setelem'
+
+do_test 'nft delete element t1 s { 80, 443 }' \
+'table=t1 family=2 entries=2 op=nft_unregister_setelem'
+
+do_test 'nft flush set t1 s2' \
+'table=t1 family=2 entries=3 op=nft_unregister_setelem'
+
+do_test 'nft delete set t1 s2' \
+'table=t1 family=2 entries=1 op=nft_unregister_set'
+
+do_test 'nft delete set t1 s3' \
+'table=t1 family=2 entries=1 op=nft_unregister_set'
+
 exit $RC
-- 
2.41.0

