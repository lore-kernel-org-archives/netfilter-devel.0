Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF46C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Apr 2022 11:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351132AbiD2LRv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Apr 2022 07:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358155AbiD2LRq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Apr 2022 07:17:46 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5125C6177
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2022 04:14:26 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:45792.1794189647
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.163.227 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 12354280221;
        Fri, 29 Apr 2022 19:14:21 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id e03e7f9d05b245d5ab7b6dd22d77d378 for pablo@netfilter.org;
        Fri, 29 Apr 2022 19:14:22 CST
X-Transaction-ID: e03e7f9d05b245d5ab7b6dd22d77d378
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
From:   wenxu@chinatelecom.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] selftests: netfilter: flowtable vlan filtering bridge support
Date:   Fri, 29 Apr 2022 07:14:08 -0400
Message-Id: <1651230848-14402-1-git-send-email-wenxu@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
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
 tools/testing/selftests/netfilter/nft_flowtable.sh | 25 ++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index d4ffebb..5882982 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -37,6 +37,7 @@ checktool "nft --version" "run test without nft tool"
 checktool "ip -Version" "run test without ip tool"
 checktool "which nc" "run test without nc (netcat)"
 checktool "ip netns add nsr1" "create net namespace"
+checktool "bridge -Version" "run test without bridge tool"
 
 ip netns add ns1
 ip netns add ns2
@@ -431,12 +432,32 @@ else
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

