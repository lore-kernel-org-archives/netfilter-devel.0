Return-Path: <SRS0=a9hH=2D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41653C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 00:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 118F8206E2
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 00:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbfLMAUK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 19:20:10 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:37620 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730882AbfLMAUK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 19:20:10 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ifYgd-0008J4-29; Fri, 13 Dec 2019 01:20:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] selftests: netfilter: extend flowtable test script with dnat rule
Date:   Fri, 13 Dec 2019 01:19:58 +0100
Message-Id: <20191213001958.31472-1-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NAT test currently covers snat (masquerade) only.

Also add a dnat rule and then check that a connecting to the
to-be-dnated address will work.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/netfilter/nft_flowtable.sh      | 39 ++++++++++++++++---
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 16571ac1dab4..d3e0809ab368 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -226,17 +226,19 @@ check_transfer()
 	return 0
 }
 
-test_tcp_forwarding()
+test_tcp_forwarding_ip()
 {
 	local nsa=$1
 	local nsb=$2
+	local dstip=$3
+	local dstport=$4
 	local lret=0
 
 	ip netns exec $nsb nc -w 5 -l -p 12345 < "$ns2in" > "$ns2out" &
 	lpid=$!
 
 	sleep 1
-	ip netns exec $nsa nc -w 4 10.0.2.99 12345 < "$ns1in" > "$ns1out" &
+	ip netns exec $nsa nc -w 4 "$dstip" "$dstport" < "$ns1in" > "$ns1out" &
 	cpid=$!
 
 	sleep 3
@@ -258,6 +260,28 @@ test_tcp_forwarding()
 	return $lret
 }
 
+test_tcp_forwarding()
+{
+	test_tcp_forwarding_ip "$1" "$2" 10.0.2.99 12345
+
+	return $?
+}
+
+test_tcp_forwarding_nat()
+{
+	local lret
+
+	test_tcp_forwarding_ip "$1" "$2" 10.0.2.99 12345
+	lret=$?
+
+	if [ $lret -eq 0 ] ; then
+		test_tcp_forwarding_ip "$1" "$2" 10.6.6.6 1666
+		lret=$?
+	fi
+
+	return $lret
+}
+
 make_file "$ns1in" "ns1"
 make_file "$ns2in" "ns2"
 
@@ -283,14 +307,19 @@ ip -net ns2 route add 192.168.10.1 via 10.0.2.1
 # Same, but with NAT enabled.
 ip netns exec nsr1 nft -f - <<EOF
 table ip nat {
+   chain prerouting {
+      type nat hook prerouting priority 0; policy accept;
+      meta iif "veth0" ip daddr 10.6.6.6 tcp dport 1666 counter dnat ip to 10.0.2.99:12345
+   }
+
    chain postrouting {
       type nat hook postrouting priority 0; policy accept;
-      meta oifname "veth1" masquerade
+      meta oifname "veth1" counter masquerade
    }
 }
 EOF
 
-test_tcp_forwarding ns1 ns2
+test_tcp_forwarding_nat ns1 ns2
 
 if [ $? -eq 0 ] ;then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT"
@@ -313,7 +342,7 @@ fi
 ip netns exec ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 ip netns exec ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 
-test_tcp_forwarding ns1 ns2
+test_tcp_forwarding_nat ns1 ns2
 if [ $? -eq 0 ] ;then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT and pmtu discovery"
 else
-- 
2.23.0

