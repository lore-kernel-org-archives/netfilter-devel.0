Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3871482D8
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 11:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716551183; cv=none; b=KkdAZaFKWiJ0pCQRgxsDLB41hF5b1FLtMqUx7lr91kZqdEUdgsnqTmcnlOdabZq2IBWfp56RE/dZlnFO+jmxX3DnBFm09Tv02Jt0LwB5qlolcoSvcAIEmTaODWYzkthiDTm7XgYzsv+qprzczsxuBAiMvucs/nyGftVIRAcI4zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716551183; c=relaxed/simple;
	bh=6QDoW7y0Glp101zgkPwiov89jJk9oftxxaFszjP6J38=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=XPVEYIJ4ijBLj6vt4kxLlDVmGa89k7eZoS1Ouz9XxMmsZjbZ9AfVu0rhKd0mg+31qI9KpMP6Po8C91T35rj3tt1+C5rpvCym6bKHtuGmLrZRSmbf/yoqM8Yi6fzooeYM6192Zn8MoKYnmPefYGHuwPDeL8lu3gCvx5mgPxvZSp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] tests: shell: add vlan double tagging match simple test case
Date: Fri, 24 May 2024 13:46:06 +0200
Message-Id: <20240524114606.6145-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As a follow up for:

  74cf3d16d8e9 ("tests: shell: add vlan match test case")

Add basic test for q-in-q matching support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
NOTE: `vlan type ip` matches at offset 20 at link-layer.

But 'ip saddr' matching does not work with q-in-q, I suspect an issue with
skb_network_header() not set to IP address when two vlan tags are present.
With one single vlan tag it works, because vlan tag ends up in the vlan
offload fields of the skbuff.

That is why I have picked this:

+		ether type 8021ad vlan id 10 vlan type 8021q vlan id 100 vlan type ip counter
                                                                         ^----------^

instead of ip saddr until this is fixed.

 tests/shell/testcases/packetpath/vlan_qinq | 69 ++++++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/vlan_qinq

diff --git a/tests/shell/testcases/packetpath/vlan_qinq b/tests/shell/testcases/packetpath/vlan_qinq
new file mode 100755
index 000000000000..7169abc22e77
--- /dev/null
+++ b/tests/shell/testcases/packetpath/vlan_qinq
@@ -0,0 +1,69 @@
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
+ip -net "$ns1" link add link veth0 name vlan10 type vlan proto 802.1ad id 10
+ip -net "$ns1" link add link vlan10 name vlan10.100 type vlan proto 802.1q id 100
+
+ip -net "$ns2" link add link veth0 name vlan10 type vlan proto 802.1ad id 10
+ip -net "$ns2" link add link vlan10 name vlan10.100 type vlan proto 802.1q id 100
+
+for dev in veth0 vlan10 vlan10.100; do
+	ip -net "$ns1" link set $dev up
+	ip -net "$ns2" link set $dev up
+done
+
+ip -net "$ns1" addr add 10.1.1.1/24 dev vlan10.100
+ip -net "$ns2" addr add 10.1.1.2/24 dev vlan10.100
+
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+table netdev t {
+	chain c1 {
+		type filter hook ingress device veth0 priority filter;
+		ether type 8021ad vlan id 10 vlan type 8021q vlan id 100 vlan type ip counter
+	}
+
+	chain c2 {
+		type filter hook ingress device vlan10 priority filter;
+		vlan id 100 ip daddr 10.1.1.2 counter
+	}
+
+	chain c3 {
+		type filter hook ingress device vlan10.100 priority filter;
+		ip daddr 10.1.1.2 counter
+	}
+}
+EOF
+
+ip netns exec "$ns1" ping -c 1 10.1.1.2
+
+ip netns exec "$ns2" $NFT list ruleset
+ip netns exec "$ns2" $NFT list chain netdev t c1 | grep 'counter packets 0 bytes 0'
+[[ $? -eq 0 ]] && exit 1
+
+ip netns exec "$ns2" $NFT list chain netdev t c2 | grep 'counter packets 0 bytes 0'
+[[ $? -eq 0 ]] && exit 1
+
+ip netns exec "$ns2" $NFT list chain netdev t c3 | grep 'counter packets 0 bytes 0'
+[[ $? -eq 0 ]] && exit 1
-- 
2.30.2

