Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2B7C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 16:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23B6061260
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 16:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhJTQ17 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 12:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhJTQ17 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 12:27:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738A6C061749
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 09:25:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mdEPO-0003m1-QR; Wed, 20 Oct 2021 18:25:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] selftests: netfilter: extend nfqueue tests to cover vrf device
Date:   Wed, 20 Oct 2021 18:25:37 +0200
Message-Id: <20211020162537.11361-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

VRF device calls the output/postrouting hooks so packet should be seeon
with oifname tvrf and once with eth0.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This triggers a KASAN splat without the
 'skb_mac_header_was_set' fix for nfnetlink_queue that i sent a few
 minutes ago.

 .../testing/selftests/netfilter/nft_queue.sh  | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_queue.sh b/tools/testing/selftests/netfilter/nft_queue.sh
index 3d202b90b33d..7d27f1f3bc01 100755
--- a/tools/testing/selftests/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/netfilter/nft_queue.sh
@@ -16,6 +16,10 @@ timeout=4
 
 cleanup()
 {
+	ip netns pids ${ns1} | xargs kill 2>/dev/null
+	ip netns pids ${ns2} | xargs kill 2>/dev/null
+	ip netns pids ${nsrouter} | xargs kill 2>/dev/null
+
 	ip netns del ${ns1}
 	ip netns del ${ns2}
 	ip netns del ${nsrouter}
@@ -332,6 +336,55 @@ EOF
 	echo "PASS: tcp via loopback and re-queueing"
 }
 
+test_icmp_vrf() {
+	ip -net $ns1 link add tvrf type vrf table 9876
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not add vrf device"
+		return
+	fi
+
+	ip -net $ns1 li set eth0 master tvrf
+	ip -net $ns1 li set tvrf up
+
+	ip -net $ns1 route add 10.0.2.0/24 via 10.0.1.1 dev eth0 table 9876
+ip netns exec ${ns1} nft -f /dev/stdin <<EOF
+flush ruleset
+table inet filter {
+	chain output {
+		type filter hook output priority 0; policy accept;
+		meta oifname "tvrf" icmp type echo-request counter queue num 1
+		meta oifname "eth0" icmp type echo-request counter queue num 1
+	}
+	chain post {
+		type filter hook postrouting priority 0; policy accept;
+		meta oifname "tvrf" icmp type echo-request counter queue num 1
+		meta oifname "eth0" icmp type echo-request counter queue num 1
+	}
+}
+EOF
+	ip netns exec ${ns1} ./nf-queue -q 1 -t $timeout &
+	local nfqpid=$!
+
+	sleep 1
+	ip netns exec ${ns1} ip vrf exec tvrf ping -c 1 10.0.2.99 > /dev/null
+
+	for n in output post; do
+		for d in tvrf eth0; do
+			ip netns exec ${ns1} nft list chain inet filter $n | grep -q "oifname \"$d\" icmp type echo-request counter packets 1"
+			if [ $? -ne 0 ] ; then
+				echo "FAIL: chain $n: icmp packet counter mismatch for device $d" 1>&2
+				ip netns exec ${ns1} nft list ruleset
+				ret=1
+				return
+			fi
+		done
+	done
+
+	wait $nfqpid
+	[ $? -eq 0 ] && echo "PASS: icmp+nfqueue via vrf"
+	wait 2>/dev/null
+}
+
 ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
@@ -372,5 +425,6 @@ test_queue 20
 test_tcp_forward
 test_tcp_localhost
 test_tcp_localhost_requeue
+test_icmp_vrf
 
 exit $ret
-- 
2.32.0

