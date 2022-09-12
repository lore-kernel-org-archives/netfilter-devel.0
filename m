Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F369C6FA83
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiILI7D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Sep 2022 04:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiILI67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2022 04:58:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1139A31371
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2022 01:58:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oXfHK-0001Zm-BH; Mon, 12 Sep 2022 10:58:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Yi Chen <yiche@redhat.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] tests: add ebtables among testcase
Date:   Mon, 12 Sep 2022 10:58:45 +0200
Message-Id: <20220912085846.9116-2-fw@strlen.de>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220912085846.9116-1-fw@strlen.de>
References: <20220912085846.9116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Yi Chen <yiche@redhat.com>

Validate that matching works as expected.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/ebtables/0008-ebtables-among_0  | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0008-ebtables-among_0

diff --git a/iptables/tests/shell/testcases/ebtables/0008-ebtables-among_0 b/iptables/tests/shell/testcases/ebtables/0008-ebtables-among_0
new file mode 100755
index 000000000000..b5df972559e4
--- /dev/null
+++ b/iptables/tests/shell/testcases/ebtables/0008-ebtables-among_0
@@ -0,0 +1,98 @@
+#!/bin/sh
+
+case "$XT_MULTI" in
+*xtables-nft-multi)
+	;;
+*)
+	echo "skip $XT_MULTI"
+	exit 0
+	;;
+esac
+
+sfx=$(mktemp -u "XXXXXXXX")
+nsa="nsa-$sfx"
+nsb="nsb-$sfx"
+nsc="nsc-$sfx"
+
+cleanup()
+{
+	ip netns del "$nsa"
+	ip netns del "$nsb"
+	ip netns del "$nsc"
+}
+
+trap cleanup EXIT
+
+assert_fail()
+{
+	if [ $1 -eq 0 ]; then
+		echo "FAILED: $2"
+		exit 1
+	fi
+}
+
+assert_pass()
+{
+	if [ $1 -ne 0 ]; then
+		echo "FAILED: $2"
+		exit 2
+	fi
+}
+
+ip netns add "$nsa"
+ip netns add "$nsb"
+ip netns add "$nsc"
+
+ip link add name c_b netns "$nsc" type veth peer name b_c netns "$nsb"
+ip link add name s_b netns "$nsa" type veth peer name b_s netns "$nsb"
+ip netns exec "$nsb" ip link add name br0 type bridge
+
+ip -net "$nsb" link set b_c up
+ip netns exec "$nsb" ip link set b_s up
+ip netns exec "$nsb" ip addr add 10.167.11.254/24 dev br0
+ip netns exec "$nsb" ip link set br0 up
+ip netns exec "$nsb" ip link set b_c master br0
+ip netns exec "$nsb" ip link set b_s master br0
+ip netns exec "$nsc" ip addr add 10.167.11.2/24 dev c_b
+ip netns exec "$nsc" ip link set c_b up
+ip -net "$nsa" addr add 10.167.11.1/24 dev s_b
+ip -net "$nsa" link set s_b up
+
+ip netns exec "$nsc" ping -q 10.167.11.1 -c1 >/dev/null  || exit 1
+
+bf_bridge_mac1=`ip netns exec "$nsb" cat /sys/class/net/b_s/address`
+bf_bridge_mac0=`ip netns exec "$nsb" cat /sys/class/net/b_c/address`
+bf_client_mac1=`ip netns exec "$nsc" cat /sys/class/net/c_b/address`
+bf_server_mac1=`ip netns exec "$nsa" cat /sys/class/net/s_b/address`
+
+bf_server_ip1="10.167.11.1"
+bf_bridge_ip0="10.167.11.254"
+bf_client_ip1="10.167.11.2"
+pktsize=64
+
+# --among-src [mac,IP]
+ip netns exec "$nsb" $XT_MULTI ebtables -F
+ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD -p ip --ip-dst $bf_server_ip1 --among-src $bf_bridge_mac0=$bf_bridge_ip0,$bf_client_mac1=$bf_client_ip1 -j DROP > /dev/null
+ip netns exec "$nsc" ping -q $bf_server_ip1 -c 1 -s $pktsize -W 1 >/dev/null
+assert_fail $? "--among-src [match]"
+
+# ip netns exec "$nsb" $XT_MULTI ebtables -L --Ln --Lc
+
+ip netns exec "$nsb" $XT_MULTI ebtables -F
+ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD -p ip --ip-dst $bf_server_ip1 --among-src ! $bf_bridge_mac0=$bf_bridge_ip0,$bf_client_mac1=$bf_client_ip1 -j DROP > /dev/null
+ip netns exec "$nsc" ping $bf_server_ip1 -c 1 -s $pktsize -W 1 >/dev/null
+assert_pass $? "--among-src [not match]"
+
+# --among-dst [mac,IP]
+ip netns exec "$nsb" $XT_MULTI ebtables -F
+ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD -p ip --ip-src $bf_client_ip1 --among-dst $bf_client_mac1=$bf_client_ip1,$bf_server_mac1=$bf_server_ip1 -j DROP > /dev/null
+ip netns exec "$nsc" ping -q $bf_server_ip1 -c 1 -s $pktsize -W 1 > /dev/null
+assert_fail $? "--among-dst [match]"
+
+# --among-dst ! [mac,IP]
+ip netns exec "$nsb" $XT_MULTI ebtables -F
+ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD -p ip --ip-src $bf_client_ip1 --among-dst ! $bf_client_mac1=$bf_client_ip1,$bf_server_mac1=$bf_server_ip1 -j DROP > /dev/null
+ip netns exec "$nsc" ping -q $bf_server_ip1 -c 1 -s $pktsize -W 1 > /dev/null
+assert_pass $? "--among-dst [not match]"
+
+exit 0
-- 
2.37.1

