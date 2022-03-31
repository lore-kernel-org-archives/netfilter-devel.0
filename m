Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22CBC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Mar 2022 13:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbiCaNsw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 09:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiCaNst (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 09:48:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA2010CF02
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2022 06:47:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nZv8c-0001bD-IT; Thu, 31 Mar 2022 15:46:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] selftests: netfilter: add fib expression forward test case
Date:   Thu, 31 Mar 2022 15:46:52 +0200
Message-Id: <20220331134652.3202-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its now possible to use fib expression in the forward chain (where both
the input and output interfaces are known).

Add a simple test case for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/nft_fib.sh | 50 ++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_fib.sh b/tools/testing/selftests/netfilter/nft_fib.sh
index 695a1958723f..fd76b69635a4 100755
--- a/tools/testing/selftests/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/netfilter/nft_fib.sh
@@ -66,6 +66,20 @@ table inet filter {
 EOF
 }
 
+load_pbr_ruleset() {
+	local netns=$1
+
+ip netns exec ${netns} nft -f /dev/stdin <<EOF
+table inet filter {
+	chain forward {
+		type filter hook forward priority raw;
+		fib saddr . iif oif gt 0 accept
+		log drop
+	}
+}
+EOF
+}
+
 load_ruleset_count() {
 	local netns=$1
 
@@ -219,4 +233,40 @@ sleep 2
 ip netns exec ${ns1} ping -c 3 -q 1c3::c01d > /dev/null
 check_fib_counter 3 ${nsrouter} 1c3::c01d || exit 1
 
+# delete all rules
+ip netns exec ${ns1} nft flush ruleset
+ip netns exec ${ns2} nft flush ruleset
+ip netns exec ${nsrouter} nft flush ruleset
+
+ip -net ${ns1} addr add 10.0.1.99/24 dev eth0
+ip -net ${ns1} addr add dead:1::99/64 dev eth0
+
+ip -net ${ns1} addr del 10.0.2.99/24 dev eth0
+ip -net ${ns1} addr del dead:2::99/64 dev eth0
+
+ip -net ${nsrouter} addr del dead:2::1/64 dev veth0
+
+# ... pbr ruleset for the router, check iif+oif.
+load_pbr_ruleset ${nsrouter}
+if [ $? -ne 0 ] ; then
+	echo "SKIP: Could not load fib forward ruleset"
+	exit $ksft_skip
+fi
+
+ip -net ${nsrouter} rule add from all table 128
+ip -net ${nsrouter} rule add from all iif veth0 table 129
+ip -net ${nsrouter} route add table 128 to 10.0.1.0/24 dev veth0
+ip -net ${nsrouter} route add table 129 to 10.0.2.0/24 dev veth1
+
+# drop main ipv4 table
+ip -net ${nsrouter} -4 rule delete table main
+
+test_ping 10.0.2.99 dead:2::99
+if [ $? -ne 0 ] ; then
+	ip -net ${nsrouter} nft list ruleset
+	echo "FAIL: fib mismatch in pbr setup"
+	exit 1
+fi
+
+echo "PASS: fib expression forward check with policy based routing"
 exit 0
-- 
2.35.1

