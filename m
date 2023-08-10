Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5088DC04A94
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 11:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjHJLXr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 07:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbjHJLXq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 07:23:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A7C2684
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 04:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zQsuJ1wcVL7kZ8MdBh7Kee0pnETd0nUSD5w2Nh/yrk0=; b=RHEPOqDA0foPGMR2B+f0bFiTfq
        WzbZHEsbCibquP6eIKeFT9SChuEv3WNa2/GhM1Oh011ryhTiqJYd/Es+QBJBYvOZDIUOHbU8VDjzo
        vhM+hGoGtpPV26No9GqGN/r4HupMC+8C3jJe6P3cz7G4/DmiOP20OJ7kIWe/lyD6LPZ5nWtXh1MNf
        3niAqcKvt3EN/NjK08mdlnAfnA4TUFdq7N+0VAsCi1BohMGmC5J/iMWaLj60OPGSRvj71j0E9RfRS
        P0+I8O6oaEOQrIzf6DTuafYmHv0R/Buro8Iip+CLSpRGdYvyc4EprXD8Pm0VkaJ+Tl9EEOoEF7brW
        Lbb6tSJw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qU3lY-0004O3-Ix
        for netfilter-devel@vger.kernel.org; Thu, 10 Aug 2023 13:23:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 3/3] tests: shell: Test chain policy counter behaviour
Date:   Thu, 10 Aug 2023 13:23:25 +0200
Message-Id: <20230810112325.20630-4-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230810112325.20630-1-phil@nwl.cc>
References: <20230810112325.20630-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Test the last two fixes in that area.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/chain/0007counters_0      | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/chain/0007counters_0

diff --git a/iptables/tests/shell/testcases/chain/0007counters_0 b/iptables/tests/shell/testcases/chain/0007counters_0
new file mode 100755
index 0000000000000..0b21a92663299
--- /dev/null
+++ b/iptables/tests/shell/testcases/chain/0007counters_0
@@ -0,0 +1,78 @@
+#!/bin/bash -e
+
+SETUP="*filter
+:FORWARD ACCEPT [13:37]
+-A FORWARD -c 1 2 -j ACCEPT
+-A FORWARD -c 3 4 -j ACCEPT
+COMMIT"
+
+
+### -Z with index shall zero a single chain only
+
+EXPECT="-P FORWARD ACCEPT -c 13 37
+-A FORWARD -c 0 0 -j ACCEPT
+-A FORWARD -c 3 4 -j ACCEPT"
+
+$XT_MULTI iptables-restore --counters <<< "$SETUP"
+$XT_MULTI iptables -Z FORWARD 1
+diff -u <(echo "$EXPECT") <($XT_MULTI iptables -vS FORWARD)
+
+
+### -Z without index shall zero the chain and all rules
+
+EXPECT="-P FORWARD ACCEPT -c 0 0
+-A FORWARD -c 0 0 -j ACCEPT
+-A FORWARD -c 0 0 -j ACCEPT"
+
+$XT_MULTI iptables -Z FORWARD
+diff -u <(echo "$EXPECT") <($XT_MULTI iptables -vS FORWARD)
+
+
+### prepare for live test
+
+# iptables-nft will create output chain on demand, so make sure it exists
+$XT_MULTI iptables -A OUTPUT -d 127.2.3.4 -j ACCEPT
+
+# test runs in its own netns, lo is there but down by default
+ip link set lo up
+
+
+### pings (and pongs) hit OUTPUT policy, its counters must increase
+
+get_pkt_counter() { # (CHAIN)
+	$XT_MULTI iptables -vS $1 | awk '/^-P '$1'/{print $5; exit}'
+}
+
+counter_inc_test() {
+	pkt_pre=$(get_pkt_counter OUTPUT)
+	ping -q -i 0.2 -c 3 127.0.0.1
+	pkt_post=$(get_pkt_counter OUTPUT)
+	[[ $pkt_post -gt $pkt_pre ]]
+}
+
+counter_inc_test
+
+# iptables-nft-restore needed --counters to create chains with them
+if [[ $XT_MULTI == *xtables-nft-multi ]]; then
+	$XT_MULTI iptables -F OUTPUT
+	$XT_MULTI iptables -X OUTPUT
+	$XT_MULTI iptables-restore <<EOF
+*filter
+:OUTPUT ACCEPT [0:0]
+COMMIT
+EOF
+	counter_inc_test
+fi
+
+### unrelated restore must not touch changing counters in kernel
+
+# With legacy iptables, this works without --noflush even. With iptables-nft,
+# ruleset is flushed though. Not sure which behaviour is actually correct. :)
+pkt_pre=$pkt_post
+$XT_MULTI iptables-restore --noflush <<EOF
+*filter$(ping -i 0.2 -c 3 127.0.0.1 >/dev/null 2>&1)
+COMMIT
+EOF
+nft list ruleset
+pkt_post=$(get_pkt_counter OUTPUT)
+[[ $pkt_post -eq $((pkt_pre + 6 )) ]]
-- 
2.40.0

