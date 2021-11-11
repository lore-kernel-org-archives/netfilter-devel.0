Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4897C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Nov 2021 17:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFF6360EE4
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Nov 2021 17:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhKKR0a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 12:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhKKR0a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 12:26:30 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7D0C061767
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Nov 2021 09:23:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mlDnT-0000um-4Q; Thu, 11 Nov 2021 18:23:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH nf] selftests: nft_nat: switch port shadow test cases to socat
Date:   Thu, 11 Nov 2021 18:23:30 +0100
Message-Id: <20211111172330.31086-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are now at least three distinct flavours of netcat/nc tool:
'original' version, one version ported from openbsd and nmap-ncat.

The script only works with original because it sets SOREUSEPORT option.

Other nc versions return 'port already in use' error and port shadow test fails:

PASS: inet IPv6 redirection for ns2-hMHcaRvx
nc: bind failed: Address already in use
ERROR: portshadow test default: got reply from "ROUTER", not CLIENT as intended

Switch to socat instead.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 26 ++++++++++++++------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index c62e4e26252c..d88867d2fed7 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -760,20 +760,20 @@ test_port_shadow()
 	local logmsg=""
 
 	# make shadow entry, from client (ns2), going to (ns1), port 41404, sport 1405.
-	echo "fake-entry" | ip netns exec "$ns2" nc -w 1 -p 1405 -u "$daddrc" 41404 > /dev/null
+	echo "fake-entry" | ip netns exec "$ns2" timeout 1 socat -u STDIN UDP:"$daddrc":41404,sourceport=1405
 
-	echo ROUTER | ip netns exec "$ns0" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
-	nc_r=$!
+	echo ROUTER | ip netns exec "$ns0" timeout 5 socat -u STDIN UDP4-LISTEN:1405 &
+	sc_r=$!
 
-	echo CLIENT | ip netns exec "$ns2" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
-	nc_c=$!
+	echo CLIENT | ip netns exec "$ns2" timeout 5 socat -u STDIN UDP4-LISTEN:1405,reuseport &
+	sc_c=$!
 
 	sleep 0.3
 
 	# ns1 tries to connect to ns0:1405.  With default settings this should connect
 	# to client, it matches the conntrack entry created above.
 
-	result=$(echo "" | ip netns exec "$ns1" nc -w 1 -p 41404 -u "$daddrs" 1405)
+	result=$(echo "data" | ip netns exec "$ns1" timeout 1 socat - UDP:"$daddrs":1405,sourceport=41404)
 
 	if [ "$result" = "$expect" ] ;then
 		echo "PASS: portshadow test $test: got reply from ${expect}${logmsg}"
@@ -782,7 +782,7 @@ test_port_shadow()
 		ret=1
 	fi
 
-	kill $nc_r $nc_c 2>/dev/null
+	kill $sc_r $sc_c 2>/dev/null
 
 	# flush udp entries for next test round, if any
 	ip netns exec "$ns0" conntrack -F >/dev/null 2>&1
@@ -852,6 +852,18 @@ test_port_shadowing()
 {
 	local family="ip"
 
+	conntrack -h >/dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not run nat port shadowing test without conntrack tool"
+		return
+	fi
+
+	socat -h > /dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not run nat port shadowing test without socat tool"
+		return
+	fi
+
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 
-- 
2.32.0

