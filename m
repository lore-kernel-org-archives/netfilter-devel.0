Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C949C74E0B
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Dec 2023 22:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: add test to cover payload transport match and mangle
Date: Mon, 18 Dec 2023 23:13:47 +0100
Message-Id: <20231218221347.187873-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Exercise payload transport match and mangle for inet, bridge and netdev
families with IPv4 and IPv6 packets.

To cover kernel patch ("netfilter: nf_tables: set transport offset from
mac header for netdev/egress").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Related to: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231214205650.1571-1-pablo@netfilter.org/

 .../testcases/packetpath/dumps/payload.nodump |   0
 tests/shell/testcases/packetpath/payload      | 180 ++++++++++++++++++
 2 files changed, 180 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/payload.nodump
 create mode 100755 tests/shell/testcases/packetpath/payload

diff --git a/tests/shell/testcases/packetpath/dumps/payload.nodump b/tests/shell/testcases/packetpath/dumps/payload.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/payload b/tests/shell/testcases/packetpath/payload
new file mode 100755
index 000000000000..1a89d853ae82
--- /dev/null
+++ b/tests/shell/testcases/packetpath/payload
@@ -0,0 +1,180 @@
+#!/bin/bash
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
+RULESET="table netdev payload_netdev {
+       counter ingress {}
+       counter egress {}
+       counter mangle_ingress {}
+       counter mangle_egress {}
+       counter mangle_ingress_match {}
+       counter mangle_egress_match {}
+
+       chain ingress {
+               type filter hook ingress device veth0 priority 0;
+               tcp dport 7777 counter name ingress
+               tcp dport 7778 tcp dport set 7779 counter name mangle_ingress
+               tcp dport 7779 counter name mangle_ingress_match
+       }
+
+       chain egress {
+               type filter hook egress device veth0 priority 0;
+               tcp dport 8887 counter name egress
+               tcp dport 8888 tcp dport set 8889 counter name mangle_egress
+               tcp dport 8889 counter name mangle_egress_match
+       }
+}
+
+table inet payload_inet {
+       counter input {}
+       counter output {}
+       counter mangle_input {}
+       counter mangle_output {}
+       counter mangle_input_match {}
+       counter mangle_output_match {}
+
+       chain in {
+               type filter hook input priority 0;
+               tcp dport 7770 counter name input
+               tcp dport 7771 tcp dport set 7772 counter name mangle_input
+               tcp dport 7772 counter name mangle_input_match
+       }
+
+       chain out {
+               type filter hook output priority 0;
+               tcp dport 8880 counter name output
+               tcp dport 8881 tcp dport set 8882 counter name mangle_output
+               tcp dport 8882 counter name mangle_output_match
+        }
+}"
+
+	ip netns exec "$ns1" $NFT -f - <<< "$RULESET" || exit 1
+
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8887,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8888,connect-timeout=2 < /dev/null > /dev/null
+
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=2 < /dev/null > /dev/null
+
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7777,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7778,connect-timeout=2 < /dev/null > /dev/null
+
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=2 < /dev/null > /dev/null
+
+	ip netns exec "$ns1" $NFT list ruleset
+
+	ip netns exec "$ns1" nft list counter netdev payload_netdev ingress | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter netdev payload_netdev mangle_ingress | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter netdev payload_netdev mangle_ingress_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter netdev payload_netdev egress | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter netdev payload_netdev mangle_egress | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter netdev payload_netdev mangle_egress_match | grep -v "packets 0" > /dev/null || exit 1
+
+	ip netns exec "$ns1" nft list counter inet payload_inet input | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter inet payload_inet mangle_input | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter inet payload_inet mangle_input_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter inet payload_inet output | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter inet payload_inet mangle_output | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter inet payload_inet mangle_output_match | grep -v "packets 0" > /dev/null || exit 1
+
+	#
+	# ... next stage
+	#
+
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
+RULESET="table bridge payload_bridge {
+       counter input {}
+       counter output {}
+       counter mangle_input {}
+       counter mangle_output {}
+       counter mangle_input_match {}
+       counter mangle_output_match {}
+
+       chain in {
+               type filter hook input priority 0;
+               tcp dport 7770 counter name input
+               tcp dport 7771 tcp dport set 7772 counter name mangle_input
+               tcp dport 7772 counter name mangle_input_match
+       }
+
+       chain out {
+               type filter hook output priority 0;
+               tcp dport 8880 counter name output
+               tcp dport 8881 tcp dport set 8882 counter name mangle_output
+               tcp dport 8882 counter name mangle_output_match
+        }
+}"
+
+	ip netns exec "$ns1" $NFT -f - <<< "$RULESET" || exit 1
+
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=2 < /dev/null > /dev/null
+
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=2 < /dev/null > /dev/null
+	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=2 < /dev/null > /dev/null
+
+	ip netns exec "$ns1" $NFT list ruleset
+
+	ip netns exec "$ns1" nft list counter bridge payload_bridge input | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter bridge payload_bridge mangle_input | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter bridge payload_bridge mangle_input_match | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter bridge payload_bridge output | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter bridge payload_bridge mangle_output | grep -v "packets 0" > /dev/null || exit 1
+	ip netns exec "$ns1" nft list counter bridge payload_bridge mangle_output_match | grep -v "packets 0" > /dev/null || exit 1
+}
+
+run_test "4" "10.141.10.2" "10.141.10.3" "24"
+cleanup
+run_test 6 "abcd::2" "abcd::3" "64"
+# trap calls cleanup
-- 
2.30.2

