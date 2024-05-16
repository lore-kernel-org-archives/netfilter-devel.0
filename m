Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F8A1459EA
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2024 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715858814; cv=none; b=SSF3jQF9kVNtwjXdYi2VVOtPFKizolu1QyHh2/bz5QNsl55KnxRscOh6qG0gFGuWoOZ0BveCO0qPWBE7X85LVwpYEdw6Og/0SP9BwdPgWt3ma4xIANEGC+CXTysaSH3SQIw3eb4NZehYQdVBWc9kIYukw0JlP2hW4E1gZcn1Eg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715858814; c=relaxed/simple;
	bh=GNfjAiI+7UD18kKyF5+c+qgvAc6enEwRrWmZahgAPiQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aJsxM7s+2ybZz1xOn58YZEWc1/ZLfrmULR3RpOyUUbfMrXC8SW3Uvut8s9IDXyIqcvXPsnYiLccfSISIn1T/HR/WM7dVwulSXLQvSI1Mjd55WE3a6k8ZIXEEvcDhkrYpIAsDOA09dALkjuKWt7f4IMrLC+HXOHJUa+YjX0HTl4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] tests: shell: add vlan mangling test case
Date: Thu, 16 May 2024 13:26:39 +0200
Message-Id: <20240516112639.141425-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240516112639.141425-1-pablo@netfilter.org>
References: <20240516112639.141425-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As a follow up for:

      74cf3d16d8e9 ("tests: shell: add vlan match test case")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../shell/testcases/packetpath/vlan_mangling  | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/vlan_mangling

diff --git a/tests/shell/testcases/packetpath/vlan_mangling b/tests/shell/testcases/packetpath/vlan_mangling
new file mode 100755
index 000000000000..b3f87c66ddec
--- /dev/null
+++ b/tests/shell/testcases/packetpath/vlan_mangling
@@ -0,0 +1,75 @@
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
+ip -net "$ns1" link add vlan123 link veth0 type vlan id 123
+ip -net "$ns2" link add vlan321 link veth0 type vlan id 321
+
+
+for dev in veth0 ; do
+	ip -net "$ns1" link set $dev up
+	ip -net "$ns2" link set $dev up
+done
+ip -net "$ns1" link set vlan123 up
+ip -net "$ns2" link set vlan321 up
+
+ip -net "$ns1" addr add 10.1.1.1/24 dev vlan123
+ip -net "$ns2" addr add 10.1.1.2/24 dev vlan321
+
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+table netdev t {
+	chain in_update_vlan {
+		vlan type arp vlan id set 321 counter
+		ip saddr 10.1.1.1 icmp type echo-request vlan id set 321 counter
+	}
+
+	chain in {
+		type filter hook ingress device veth0 priority filter;
+		ether saddr da:d3:00:01:02:03 vlan id 123 jump in_update_vlan
+	}
+
+	chain out_update_vlan {
+		vlan type arp vlan id set 123 counter
+		ip daddr 10.1.1.1 icmp type echo-reply vlan id set 123 counter
+	}
+
+	chain out {
+		type filter hook egress device veth0 priority filter;
+		ether daddr da:d3:00:01:02:03 vlan id 321 jump out_update_vlan
+	}
+}
+EOF
+
+ip netns exec "$ns1" ping -c 1 10.1.1.2
+
+set +e
+
+ip netns exec "$ns2" $NFT list ruleset
+ip netns exec "$ns2" $NFT list table netdev t | grep 'counter packets' | grep 'counter packets 0 bytes 0'
+if [ $? -eq 1 ]
+then
+	exit 0
+fi
+
+exit 1
-- 
2.30.2

