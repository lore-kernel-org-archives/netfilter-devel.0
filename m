Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4220EE743FA
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 08:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbjI2Inw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 04:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbjI2Ina (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 04:43:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E42CE8
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 01:43:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qm95r-0004kU-Ra; Fri, 29 Sep 2023 10:43:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     david.ward@ll.mit.edu, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add vlan match test case
Date:   Fri, 29 Sep 2023 10:43:08 +0200
Message-ID: <20230929084318.19493-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check that we can match on the 8021ad header and vlan tag.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/packetpath/vlan_8021ad_tag      | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/vlan_8021ad_tag

diff --git a/tests/shell/testcases/packetpath/vlan_8021ad_tag b/tests/shell/testcases/packetpath/vlan_8021ad_tag
new file mode 100755
index 000000000000..379a5710c1cb
--- /dev/null
+++ b/tests/shell/testcases/packetpath/vlan_8021ad_tag
@@ -0,0 +1,50 @@
+#!/bin/bash
+
+rnd=$(mktemp -u XXXXXXXX)
+ns1="nft1ifname-$rnd"
+ns2="nft2ifname-$rnd"
+
+cleanup()
+{
+	ip netns del "$ns1"
+	ip netns del "$ns2"
+}
+
+trap cleanup EXIT
+
+set -e
+
+ip netns add "$ns1"
+ip netns add "$ns2"
+ip -net "$ns1" link set lo up
+ip -net "$ns2" link set lo up
+
+ip link add veth0 netns $ns1 type veth peer name veth0 netns $ns2
+
+ip -net "$ns1" link set veth0 addr da:d3:00:01:02:03
+
+ip -net "$ns1" link add vlan123 link veth0 type vlan id 123 proto 802.1ad
+ip -net "$ns2" link add vlan123 link veth0 type vlan id 123 proto 802.1ad
+
+
+for dev in veth0 vlan123; do
+	ip -net "$ns1" link set $dev up
+	ip -net "$ns2" link set $dev up
+done
+
+ip -net "$ns1" addr add 10.1.1.1/24 dev vlan123
+ip -net "$ns2" addr add 10.1.1.2/24 dev vlan123
+
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+table netdev t {
+	chain c {
+		type filter hook ingress device veth0 priority filter;
+		ether saddr da:d3:00:01:02:03 ether type 8021ad vlan id 123 ip daddr 10.1.1.2 icmp type echo-request counter
+	}
+}
+EOF
+
+ip netns exec "$ns1" ping -c 1 10.1.1.2
+
+ip netns exec "$ns2" $NFT list ruleset
+ip netns exec "$ns2" $NFT list chain netdev t c | grep 'counter packets 1 bytes 84'
-- 
2.41.0

