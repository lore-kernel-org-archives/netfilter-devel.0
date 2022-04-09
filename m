Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555CFC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242289AbiDIOBS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 10:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiDIOBQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 10:01:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1E3DF2B
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:59:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndBcJ-0008ME-VS; Sat, 09 Apr 2022 15:59:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 7/9] tests: add testcases for interface names in sets
Date:   Sat,  9 Apr 2022 15:58:30 +0200
Message-Id: <20220409135832.17401-8-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add initial test case, sets with names and interfaces,
anonymous and named ones.

Check match+no-match.
netns with ppp1 and ppq veth, send packets via both interfaces.
Rule counters should have incremented on the three rules.
(that match on set that have "abcdef1" or "abcdef*" strings in them).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../sets/dumps/sets_with_ifnames.nft          | 28 +++++++
 tests/shell/testcases/sets/sets_with_ifnames  | 83 +++++++++++++++++++
 2 files changed, 111 insertions(+)
 create mode 100644 tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
 create mode 100755 tests/shell/testcases/sets/sets_with_ifnames

diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
new file mode 100644
index 000000000000..12c1aa960a66
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
@@ -0,0 +1,28 @@
+table inet testifsets {
+	set simple {
+		type ifname
+		elements = { "abcdef0",
+			     "abcdef1",
+			     "othername" }
+	}
+
+	set simple_wild {
+		type ifname
+		flags interval
+		elements = { "abcdef*",
+			     "othername",
+			     "ppp0" }
+	}
+
+	chain v4icmp {
+		iifname @simple counter packets 0 bytes 0
+		iifname @simple_wild counter packets 0 bytes 0
+		iifname { "eth0", "abcdef0" } counter packets 0 bytes 0
+		iifname { "abcdef*", "eth0" } counter packets 0 bytes 0
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+		ip protocol icmp goto v4icmp
+	}
+}
diff --git a/tests/shell/testcases/sets/sets_with_ifnames b/tests/shell/testcases/sets/sets_with_ifnames
new file mode 100755
index 000000000000..0f9a6b5b0048
--- /dev/null
+++ b/tests/shell/testcases/sets/sets_with_ifnames
@@ -0,0 +1,83 @@
+#!/bin/bash
+
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+[ -z "$NFT" ] && exit 111
+
+$NFT -f "$dumpfile" || exit 1
+
+rnd=$(mktemp -u XXXXXXXX)
+ns1="nft1ifname-$rnd"
+ns2="nft2ifname-$rnd"
+
+cleanup()
+{
+	ip netns del "$ns1"
+}
+
+trap cleanup EXIT
+
+check_elem()
+{
+	setname=$1
+	ifname=$2
+	fail=$3
+
+	if [ $fail -eq 1 ]; then
+		ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$ifname" } && exit 2
+	else
+		ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$ifname" } || exit 3
+	fi
+}
+
+# send pings, check all rules with sets that contain abcdef1 match.
+# there are 4 rules in this chain, 4 should match.
+check_matching_icmp_ppp()
+{
+	pkt=$((RANDOM%10))
+	pkt=$((pkt+1))
+	ip netns exec "$ns1" ping -f -c $pkt 10.1.2.2
+
+	# replies should arrive via 'abcdeg', so, should NOT increment any counters.
+	ip netns exec "$ns1" ping -f -c 100 10.2.2.2
+
+	matches=$(ip netns exec "$ns1" $NFT list chain inet testifsets v4icmp | grep "counter packets $pkt " | wc -l)
+	want=3
+
+	if [ "$matches" -ne $want ] ;then
+		echo "Excpected $matches matching rules, got $want, packets $pkt"
+		ip netns exec "$ns1" $NFT list ruleset
+		exit 1
+	fi
+}
+
+ip netns add "$ns1" || exit 111
+ip netns add "$ns2" || exit 111
+ip netns exec "$ns1" $NFT -f "$dumpfile" || exit 3
+
+for n in abcdef0 abcdef1 othername;do
+	check_elem simple $n 0
+done
+
+check_elem simple foo 1
+
+set -e
+ip -net "$ns1" link set lo up
+ip -net "$ns2" link set lo up
+ip netns exec "$ns1" ping -f -c 10 127.0.0.1
+
+ip link add abcdef1 netns $ns1 type veth peer name veth0 netns $ns2
+ip link add abcdeg  netns $ns1 type veth peer name veth1 netns $ns2
+
+ip -net "$ns1" link set abcdef1 up
+ip -net "$ns2" link set veth0 up
+ip -net "$ns1" link set abcdeg up
+ip -net "$ns2" link set veth1 up
+
+ip -net "$ns1" addr add 10.1.2.1/24 dev abcdef1
+ip -net "$ns1" addr add 10.2.2.1/24 dev abcdeg
+
+ip -net "$ns2" addr add 10.1.2.2/24 dev veth0
+ip -net "$ns2" addr add 10.2.2.2/24 dev veth1
+
+check_matching_icmp_ppp
-- 
2.35.1

