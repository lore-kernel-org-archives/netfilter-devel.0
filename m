Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CABEC433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DBBF2087F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfG3M6l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:58:41 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42274 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726241AbfG3M6l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:58:41 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hsRiA-0003sF-Ss; Tue, 30 Jul 2019 14:58:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] selftests: netfilter: extend flowtable test script for ipsec
Date:   Tue, 30 Jul 2019 14:57:18 +0200
Message-Id: <20190730125719.23553-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
---
 .../selftests/netfilter/nft_flowtable.sh      | 48 +++++++++++++++++++
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
2.21.0

