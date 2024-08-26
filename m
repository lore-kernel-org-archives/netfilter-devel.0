Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FC484039
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2024 19:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724698971; cv=none; b=jvAwblupwZLIc97Nw/rLMyyp+qUCvpbQg7DYPx7PsGXImSwh0t3LGw2W7OmhiHEbjZIZWJTcIeT+OCkC+Wl5xEhOahBfLbNv5oC2/LTtRUD5UkXfCmbfHf5zJ62OCVe/rFOqhQ0tygy1LOVOO9VDIUe2n+wOjWliBKtiSEBtpyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724698971; c=relaxed/simple;
	bh=V0x5cRx036uxb4v3HHW0pnrfBBAuNgZ6GMN+Ts+jpV0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=okFo9jqyGZROSOI6EtASQW2oIuALw2psRF4mPvVnduiw2UHJFR9HkAlCWwu0DYNAWCGUMR4FIT3722Iy1RQ4T0YwFHplhyHrDTiIfm7UDJjdKPoe7PXPQ8YBmbe/OrjmA8JAGmoF9EA0DAfMN3rFr5EuXwQEaxy9Y3MxaWrMYB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: extend coverage for meta l4proto netdev/egress matching
Date: Mon, 26 Aug 2024 21:02:42 +0200
Message-Id: <20240826190242.176214-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend coverage to match on small UDP packets from netdev/egress.

While at it, cover bridge/input and bridge/output hooks too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../shell/testcases/packetpath/match_l4proto  | 149 ++++++++++++++++++
 1 file changed, 149 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/match_l4proto

diff --git a/tests/shell/testcases/packetpath/match_l4proto b/tests/shell/testcases/packetpath/match_l4proto
new file mode 100755
index 000000000000..31fbe6c27d66
--- /dev/null
+++ b/tests/shell/testcases/packetpath/match_l4proto
@@ -0,0 +1,149 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_egress)
+
+rnd=$(mktemp -u XXXXXXXX)
+ns1="nft1payload-$rnd"
+ns2="nft2payload-$rnd"
+
+cleanup()
+{
+	ip netns del "$ns1"
+	ip netns del "$ns2"
+}
+
+trap cleanup EXIT
+
+run_test()
+{
+	ns1_addr=$2
+	ns2_addr=$3
+	cidr=$4
+
+	# socat needs square brackets, ie. [abcd::2]
+	if [ $1 -eq 6 ]; then
+		nsx1_addr="["$ns1_addr"]"
+		nsx2_addr="["$ns2_addr"]"
+	else
+		nsx1_addr="$ns1_addr"
+		nsx2_addr="$ns2_addr"
+	fi
+
+	ip netns add "$ns1" || exit 111
+	ip netns add "$ns2" || exit 111
+
+	ip -net "$ns1" link set lo up
+	ip -net "$ns2" link set lo up
+
+	ip link add veth0 netns $ns1 type veth peer name veth0 netns $ns2
+
+	ip -net "$ns1" link set veth0 up
+	ip -net "$ns2" link set veth0 up
+	ip -net "$ns1" addr add $ns1_addr/$cidr dev veth0
+	ip -net "$ns2" addr add $ns2_addr/$cidr dev veth0
+
+	sleep 5
+
+RULESET="table netdev payload_netdev {
+       counter ingress {}
+       counter ingress_2 {}
+       counter egress {}
+       counter egress_2 {}
+
+       chain ingress {
+               type filter hook ingress device veth0 priority 0;
+               udp dport 7777 counter name ingress
+               meta l4proto udp counter name ingress_2
+       }
+
+       chain egress {
+               type filter hook egress device veth0 priority 0;
+               udp dport 7777 counter name egress
+               meta l4proto udp counter name egress_2
+       }
+}"
+
+	ip netns exec "$ns1" $NFT -f - <<< "$RULESET" || exit 1
+
+	ip netns exec "$ns1" bash -c "echo 'A' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+	ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+	ip netns exec "$ns1" bash -c "echo 'AAA' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+	ip netns exec "$ns1" bash -c "echo 'AAAA' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+	ip netns exec "$ns1" bash -c "echo 'AAAAA' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+
+	ip netns exec "$ns2" bash -c "echo 'A' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+	ip netns exec "$ns2" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+	ip netns exec "$ns2" bash -c "echo 'AAA' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+	ip netns exec "$ns2" bash -c "echo 'AAAA' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+	ip netns exec "$ns2" bash -c "echo 'AAAAA' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+
+	ip netns exec "$ns1" $NFT list ruleset
+
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev ingress | grep "packets 5" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev ingress_2 | grep "packets 5" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev egress | grep "packets 5" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter netdev payload_netdev egress_2| grep "packets 5" > /dev/null || exit 1
+
+	#
+	# ... next stage
+	#
+	ip netns exec "$ns1" $NFT flush ruleset
+
+	#
+	# bridge
+	#
+
+	ip -net "$ns1" addr del $ns1_addr/$cidr dev veth0
+
+	ip -net "$ns1" link add name br0 type bridge
+	ip -net "$ns1" link set veth0 master br0
+	ip -net "$ns1" addr add $ns1_addr/$cidr dev br0
+	ip -net "$ns1" link set up dev br0
+
+	sleep 5
+
+RULESET="table bridge payload_bridge {
+       counter input {}
+       counter output {}
+       counter input_2 {}
+       counter output_2 {}
+
+       chain in {
+               type filter hook input priority 0;
+               udp dport 7777 counter name input
+               meta l4proto udp counter name input_2
+       }
+
+       chain out {
+               type filter hook output priority 0;
+               udp dport 7777 counter name output
+               meta l4proto udp counter name output_2
+        }
+}"
+
+	ip netns exec "$ns1" $NFT -f - <<< "$RULESET" || exit 1
+
+	ip netns exec "$ns1" bash -c "echo 'A' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+	ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+	ip netns exec "$ns1" bash -c "echo 'AAA' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+	ip netns exec "$ns1" bash -c "echo 'AAAA' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+	ip netns exec "$ns1" bash -c "echo 'AAAAA' | socat -u STDIN UDP:$nsx2_addr:7777 > /dev/null"
+
+	ip netns exec "$ns2" bash -c "echo 'A' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+	ip netns exec "$ns2" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+	ip netns exec "$ns2" bash -c "echo 'AAA' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+	ip netns exec "$ns2" bash -c "echo 'AAAA' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+	ip netns exec "$ns2" bash -c "echo 'AAAAA' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+
+	ip netns exec "$ns1" $NFT list ruleset
+
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge input | grep "packets 5" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge input_2 | grep "packets 5" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge output | grep "packets 5" > /dev/null || exit 1
+	ip netns exec "$ns1" $NFT list counter bridge payload_bridge output_2 | grep "packets 5" > /dev/null || exit 1
+}
+
+run_test "4" "10.141.10.2" "10.141.10.3" "24"
+cleanup
+run_test "6" "abcd::2" "abcd::3" "64"
+# trap calls cleanup
-- 
2.30.2

