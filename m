Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91745C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 06:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346314AbiEZG56 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 May 2022 02:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245118AbiEZG5z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 May 2022 02:57:55 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AF6627CD9
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 23:57:52 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:47608.1673014714
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.165.111 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id DF65D2800C5;
        Thu, 26 May 2022 14:57:49 +0800 (CST)
X-189-SAVE-TO-SEND: +wenxu@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 41b61bdb85504a31bd26e8f7d066db93 for pablo@netfilter.org;
        Thu, 26 May 2022 14:57:50 CST
X-Transaction-ID: 41b61bdb85504a31bd26e8f7d066db93
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
From:   wenxu@chinatelecom.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, wenxu@chinatelecom.cn
Subject: [PATCH nf-next v2 3/3] selftests: netfilter: flowtable vlan filtering bridge support
Date:   Thu, 26 May 2022 02:57:32 -0400
Message-Id: <1653548252-2602-3-git-send-email-wenxu@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>
References: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@chinatelecom.cn>

Add vlan_filtering enabled bridge and vlan case.
Add a vlan_filtering bridge device to the Router1 (nsr1) container
and attach the veth0 device to the bridge. Set the IP address to
the bridge device to exercise the bridge forwarding path.
The veth0 add in the vlan 10 domain and the br0 also add in the
vlan 10 domain with untaged.

Signed-off-by: wenxu <wenxu@chinatelecom.cn>
---
v2: fix set up the br0
    change iif br0 to iifname br0 for br0 destroy
    All the test PASS

 tools/testing/selftests/netfilter/nft_flowtable.sh | 28 +++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index d4ffebb..13e03e3 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -37,6 +37,7 @@ checktool "nft --version" "run test without nft tool"
 checktool "ip -Version" "run test without ip tool"
 checktool "which nc" "run test without nc (netcat)"
 checktool "ip netns add nsr1" "create net namespace"
+checktool "bridge -Version" "run test without bridge tool"
 
 ip netns add ns1
 ip netns add ns2
@@ -388,7 +389,7 @@ flush table ip nat
 table ip nat {
    chain prerouting {
       type nat hook prerouting priority 0; policy accept;
-      meta iif "br0" ip daddr 10.6.6.6 tcp dport 1666 counter dnat ip to 10.0.2.99:12345
+      meta iifname "br0" ip daddr 10.6.6.6 tcp dport 1666 counter dnat ip to 10.0.2.99:12345
    }
 
    chain postrouting {
@@ -431,12 +432,33 @@ else
 	ret=1
 fi
 
-# restore test topology (remove bridge and VLAN)
-ip -net nsr1 link set veth0 nomaster
+# Another test:
+# Add vlan filtering bridge interface br0 to Router1, with NAT and VLAN.
+ip -net nsr1 link set veth0.10 nomaster
 ip -net nsr1 link set veth0 down
 ip -net nsr1 link set veth0.10 down
 ip -net nsr1 link delete veth0.10 type vlan
 ip -net nsr1 link delete br0 type bridge
+ip -net nsr1 link add name br0 type bridge vlan_filtering 1
+ip -net nsr1 link set up dev veth0
+ip -net nsr1 link set veth0 master br0
+ip -net nsr1 link set up dev br0
+ip -net nsr1 addr add 10.0.1.1/24 dev br0
+bridge -n nsr1 vlan add dev veth0 vid 10 pvid
+bridge -n nsr1 vlan add dev br0 vid 10 pvid untagged self
+
+if test_tcp_forwarding_nat ns1 ns2; then
+	echo "PASS: flow offloaded for ns1/ns2 with vlan filtering bridge NAT and VLAN"
+else
+	echo "FAIL: flow offload for ns1/ns2 with vlan filtering bridge NAT and VLAN" 1>&2
+	ip netns exec nsr1 nft list ruleset
+	ret=1
+fi
+
+# restore test topology (remove bridge and VLAN)
+ip -net nsr1 link set veth0 nomaster
+ip -net nsr1 link set veth0 down
+ip -net nsr1 link delete br0 type bridge
 ip -net ns1 addr flush dev eth0.10
 ip -net ns1 link set eth0.10 down
 ip -net ns1 link set eth0 down
-- 
1.8.3.1

