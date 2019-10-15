Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10082ECE58E
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 07:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6B802067B
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 07:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfJOHdL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 03:33:11 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42146 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbfJOHdK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 03:33:10 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 01D4B25BE3A;
        Tue, 15 Oct 2019 18:32:57 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 884D1E207E9; Tue, 15 Oct 2019 09:32:52 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 6/6] selftests: netfilter: add ipvs tunnel test case
Date:   Tue, 15 Oct 2019 09:32:12 +0200
Message-Id: <20191015073212.19394-7-horms@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191015073212.19394-1-horms@verge.net.au>
References: <20191015073212.19394-1-horms@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Test virtual server via ipip tunnel.

Tested:
# selftests: netfilter: ipvs.sh
# Testing DR mode...
# Testing NAT mode...
# Testing Tunnel mode...
# ipvs.sh: PASS
ok 6 selftests: netfilter: ipvs.sh

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 tools/testing/selftests/netfilter/ipvs.sh | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/netfilter/ipvs.sh b/tools/testing/selftests/netfilter/ipvs.sh
index 8b2e618d6a6a..c3b8f90c497e 100755
--- a/tools/testing/selftests/netfilter/ipvs.sh
+++ b/tools/testing/selftests/netfilter/ipvs.sh
@@ -168,6 +168,30 @@ test_nat() {
 	test_service
 }
 
+test_tun() {
+	ip netns exec ns0 ip route add ${vip_v4} via ${gip_v4} dev br0
+
+	ip netns exec ns1 modprobe ipip
+	ip netns exec ns1 ip link set tunl0 up
+	ip netns exec ns1 sysctl -qw net.ipv4.ip_forward=0
+	ip netns exec ns1 sysctl -qw net.ipv4.conf.all.send_redirects=0
+	ip netns exec ns1 sysctl -qw net.ipv4.conf.default.send_redirects=0
+	ip netns exec ns1 ipvsadm -A -t ${vip_v4}:${port} -s rr
+	ip netns exec ns1 ipvsadm -a -i -t ${vip_v4}:${port} -r ${rip_v4}:${port}
+	ip netns exec ns1 ip addr add ${vip_v4}/32 dev lo:1
+
+	ip netns exec ns2 modprobe ipip
+	ip netns exec ns2 ip link set tunl0 up
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_ignore=1
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_announce=2
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.rp_filter=0
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.tunl0.rp_filter=0
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.veth21.rp_filter=0
+	ip netns exec ns2 ip addr add ${vip_v4}/32 dev lo:1
+
+	test_service
+}
+
 run_tests() {
 	local errors=
 
@@ -183,6 +207,12 @@ run_tests() {
 	test_nat
 	errors=$(( $errors + $? ))
 
+	echo "Testing Tunnel mode..."
+	cleanup
+	setup
+	test_tun
+	errors=$(( $errors + $? ))
+
 	return $errors
 }
 
-- 
2.11.0

