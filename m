Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BB3C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 09:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10475204EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 09:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfHNJYx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 05:24:53 -0400
Received: from correo.us.es ([193.147.175.20]:42586 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfHNJYw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 05:24:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 54F4DC40E9
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 11:24:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46DCB1150CB
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 11:24:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3C9315C023; Wed, 14 Aug 2019 11:24:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 288297E064;
        Wed, 14 Aug 2019 11:24:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 11:24:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D2FB14265A2F;
        Wed, 14 Aug 2019 11:24:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/7] selftests: netfilter: extend flowtable test script for ipsec
Date:   Wed, 14 Aug 2019 11:24:34 +0200
Message-Id: <20190814092440.20087-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190814092440.20087-1-pablo@netfilter.org>
References: <20190814092440.20087-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

'flow offload' expression should not offload flows that will be subject
to ipsec, but it does.

This results in a connectivity blackhole for the affected flows -- first
packets will go through (offload happens after established state is
reached), but all remaining ones bypass ipsec encryption and are thus
discarded by the peer.

This can be worked around by adding "rt ipsec exists accept"
before the 'flow offload' rule matches.

This test case will fail, support for such flows is added in
next patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index fe52488a6f72..16571ac1dab4 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -321,4 +321,52 @@ else
 	ip netns exec nsr1 nft list ruleset
 fi
 
+KEY_SHA="0x"$(ps -xaf | sha1sum | cut -d " " -f 1)
+KEY_AES="0x"$(ps -xaf | md5sum | cut -d " " -f 1)
+SPI1=$RANDOM
+SPI2=$RANDOM
+
+if [ $SPI1 -eq $SPI2 ]; then
+	SPI2=$((SPI2+1))
+fi
+
+do_esp() {
+    local ns=$1
+    local me=$2
+    local remote=$3
+    local lnet=$4
+    local rnet=$5
+    local spi_out=$6
+    local spi_in=$7
+
+    ip -net $ns xfrm state add src $remote dst $me proto esp spi $spi_in  enc aes $KEY_AES  auth sha1 $KEY_SHA mode tunnel sel src $rnet dst $lnet
+    ip -net $ns xfrm state add src $me  dst $remote proto esp spi $spi_out enc aes $KEY_AES auth sha1 $KEY_SHA mode tunnel sel src $lnet dst $rnet
+
+    # to encrypt packets as they go out (includes forwarded packets that need encapsulation)
+    ip -net $ns xfrm policy add src $lnet dst $rnet dir out tmpl src $me dst $remote proto esp mode tunnel priority 1 action allow
+    # to fwd decrypted packets after esp processing:
+    ip -net $ns xfrm policy add src $rnet dst $lnet dir fwd tmpl src $remote dst $me proto esp mode tunnel priority 1 action allow
+
+}
+
+do_esp nsr1 192.168.10.1 192.168.10.2 10.0.1.0/24 10.0.2.0/24 $SPI1 $SPI2
+
+do_esp nsr2 192.168.10.2 192.168.10.1 10.0.2.0/24 10.0.1.0/24 $SPI2 $SPI1
+
+ip netns exec nsr1 nft delete table ip nat
+
+# restore default routes
+ip -net ns2 route del 192.168.10.1 via 10.0.2.1
+ip -net ns2 route add default via 10.0.2.1
+ip -net ns2 route add default via dead:2::1
+
+test_tcp_forwarding ns1 ns2
+if [ $? -eq 0 ] ;then
+	echo "PASS: ipsec tunnel mode for ns1/ns2"
+else
+	echo "FAIL: ipsec tunnel mode for ns1/ns2"
+	ip netns exec nsr1 nft list ruleset 1>&2
+	ip netns exec nsr1 cat /proc/net/xfrm_stat 1>&2
+fi
+
 exit $ret
-- 
2.11.0


