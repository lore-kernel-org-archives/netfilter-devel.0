Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F157C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Sep 2021 13:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 807AB611B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Sep 2021 13:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhIWNOd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 09:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbhIWNOd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 09:14:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF186C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2021 06:13:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mTOX6-00026G-H0; Thu, 23 Sep 2021 15:13:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     eric@garver.life, phil@nwl.cc, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] selftests: nft_nat: add udp hole punch test case
Date:   Thu, 23 Sep 2021 15:12:42 +0200
Message-Id: <20210923131243.24071-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210923131243.24071-1-fw@strlen.de>
References: <20210923131243.24071-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a test case that demonstrates port shadowing via UDP.

ns2 sends packet to ns1, from source port used by a udp service on the
router, ns0.  Then, ns1 sends packet to ns0:service, but that ends up getting
forwarded to ns2.

Also add three test cases that demonstrate mitigations:
1. disable use of $port as source from 'unstrusted' origin
2. make the service untracked.  This prevents masquerade entries
   from having any effects.
3. add forced PAT via 'random' mode to translate the "wrong" sport
   into an acceptable range.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 145 +++++++++++++++++++
 1 file changed, 145 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index d7e07f4c3d7f..da1c1e4b6c86 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -741,6 +741,149 @@ EOF
 	return $lret
 }
 
+# test port shadowing.
+# create two listening services, one on router (ns0), one
+# on client (ns2), which is masqueraded from ns1 point of view.
+# ns2 sends udp packet coming from service port to ns1, on a highport.
+# Later, if n1 uses same highport to connect to ns0:service, packet
+# might be port-forwarded to ns2 instead.
+
+# second argument tells if we expect the 'fake-entry' to take effect
+# (CLIENT) or not (ROUTER).
+test_port_shadow()
+{
+	local test=$1
+	local expect=$2
+	local daddrc="10.0.1.99"
+	local daddrs="10.0.1.1"
+	local result=""
+	local logmsg=""
+
+	echo ROUTER | ip netns exec "$ns0" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
+	nc_r=$!
+
+	echo CLIENT | ip netns exec "$ns2" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
+	nc_c=$!
+
+	# make shadow entry, from client (ns2), going to (ns1), port 41404, sport 1405.
+	echo "fake-entry" | ip netns exec "$ns2" nc -w 1 -p 1405 -u "$daddrc" 41404 > /dev/null
+
+	# ns1 tries to connect to ns0:1405.  With default settings this should connect
+	# to client, it matches the conntrack entry created above.
+
+	result=$(echo "" | ip netns exec "$ns1" nc -w 1 -p 41404 -u "$daddrs" 1405)
+
+	if [ "$result" = "$expect" ] ;then
+		echo "PASS: portshadow test $test: got reply from ${expect}${logmsg}"
+	else
+		echo "ERROR: portshadow test $test: got reply from \"$result\", not $expect as intended"
+		ret=1
+	fi
+
+	kill $nc_r $nc_c 2>/dev/null
+
+	# flush udp entries for next test round, if any
+	ip netns exec "$ns0" conntrack -F >/dev/null 2>&1
+}
+
+# This prevents port shadow of router service via packet filter,
+# packets claiming to originate from service port from internal
+# network are dropped.
+test_port_shadow_filter()
+{
+	local family=$1
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table $family filter {
+	chain forward {
+		type filter hook forward priority 0; policy accept;
+		meta iif veth1 udp sport 1405 drop
+	}
+}
+EOF
+	test_port_shadow "port-filter" "ROUTER"
+
+	ip netns exec "$ns0" nft delete table $family filter
+}
+
+# This prevents port shadow of router service via notrack.
+test_port_shadow_notrack()
+{
+	local family=$1
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table $family raw {
+	chain prerouting {
+		type filter hook prerouting priority -300; policy accept;
+		meta iif veth0 udp dport 1405 notrack
+		udp dport 1405 notrack
+	}
+	chain output {
+		type filter hook output priority -300; policy accept;
+		udp sport 1405 notrack
+	}
+}
+EOF
+	test_port_shadow "port-notrack" "ROUTER"
+
+	ip netns exec "$ns0" nft delete table $family raw
+}
+
+# This prevents port shadow of router service via sport remap.
+test_port_shadow_pat()
+{
+	local family=$1
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table $family pat {
+	chain postrouting {
+		type nat hook postrouting priority -1; policy accept;
+		meta iif veth1 udp sport <= 1405 masquerade to : 1406-65535 random
+	}
+}
+EOF
+	test_port_shadow "pat" "ROUTER"
+
+	ip netns exec "$ns0" nft delete table $family pat
+}
+
+test_port_shadowing()
+{
+	local family="ip"
+
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+
+	ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table $family nat {
+	chain postrouting {
+		type nat hook postrouting priority 0; policy accept;
+		meta oif veth0 masquerade
+	}
+}
+EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add add $family masquerade hook"
+		return $ksft_skip
+	fi
+
+	# test default behaviour. Packet from ns1 to ns0 is redirected to ns2.
+	test_port_shadow "default" "CLIENT"
+
+	# test packet filter based mitigation: prevent forwarding of
+	# packets claiming to come from the service port.
+	test_port_shadow_filter "$family"
+
+	# test conntrack based mitigation: connections going or coming
+	# from router:service bypass connection tracking.
+	test_port_shadow_notrack "$family"
+
+	# test nat based mitigation: fowarded packets coming from service port
+	# are masqueraded with random highport.
+	test_port_shadow_pat "$family"
+
+	ip netns exec "$ns0" nft delete table $family nat
+}
 
 # ip netns exec "$ns0" ping -c 1 -q 10.0.$i.99
 for i in 0 1 2; do
@@ -861,6 +1004,8 @@ reset_counters
 $test_inet_nat && test_redirect inet
 $test_inet_nat && test_redirect6 inet
 
+test_port_shadowing
+
 if [ $ret -ne 0 ];then
 	echo -n "FAIL: "
 	nft --version
-- 
2.32.0

