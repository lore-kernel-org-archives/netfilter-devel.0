Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FEA6C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jun 2022 08:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245707AbiFAIsF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jun 2022 04:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243559AbiFAIsD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jun 2022 04:48:03 -0400
Received: from Chamillionaire.breakpoint.cc (unknown [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6984BFD7
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2022 01:48:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nwK12-0000il-Pb; Wed, 01 Jun 2022 10:47:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>
Subject: [PATCH nf] netfilter: nat: really support inet nat without l3 address
Date:   Wed,  1 Jun 2022 10:47:35 +0200
Message-Id: <20220601084735.79090-1-fw@strlen.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When no l3 address is given, priv->family is set to NFPROTO_INET and
the evaluation function isn't called.

Call it too so l4-only rewrite can work.
Also add a test case for this.

Fixes: a33f387ecd5aa ("netfilter: nft_nat: allow to specify layer 4 protocol NAT only")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_nat.c                      |  3 +-
 tools/testing/selftests/netfilter/nft_nat.sh | 43 ++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 4394df4bc99b..e5fd6995e4bf 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -335,7 +335,8 @@ static void nft_nat_inet_eval(const struct nft_expr *expr,
 {
 	const struct nft_nat *priv = nft_expr_priv(expr);
 
-	if (priv->family == nft_pf(pkt))
+	if (priv->family == nft_pf(pkt) ||
+	    priv->family == NFPROTO_INET)
 		nft_nat_eval(expr, regs, pkt);
 }
 
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index eb8543b9a5c4..61d6df1367d0 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -374,6 +374,45 @@ EOF
 	return $lret
 }
 
+test_local_dnat_portonly()
+{
+	local family=$1
+	local daddr=$2
+	local lret=0
+	local sr_s
+	local sr_r
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table $family nat {
+	chain output {
+		type nat hook output priority 0; policy accept;
+		meta l4proto tcp dnat to :2000
+
+	}
+}
+EOF
+	if [ $? -ne 0 ]; then
+		if [ $family = "inet" ];then
+			echo "SKIP: inet port test"
+			test_inet_nat=false
+			return
+		fi
+		echo "SKIP: Could not add $family dnat hook"
+		return
+	fi
+
+	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
+	sc_s=$!
+
+	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
+
+	if [ "$result" = "SERVER-inet" ];then
+		echo "PASS: inet port rewrite without l3 address"
+	else
+		echo "ERROR: inet port rewrite"
+		ret=1
+	fi
+}
 
 test_masquerade6()
 {
@@ -1148,6 +1187,10 @@ fi
 reset_counters
 test_local_dnat ip
 test_local_dnat6 ip6
+
+reset_counters
+test_local_dnat_portonly inet 10.0.1.99
+
 reset_counters
 $test_inet_nat && test_local_dnat inet
 $test_inet_nat && test_local_dnat6 inet
-- 
2.36.1

