Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3356C1459E7
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2024 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715858813; cv=none; b=L70iRtKJLtJYQnZymIyHSCy4OUdAmv6mGtUBmnFZTYas+DRQjQ2Quxeo9eP74r1LnpgU0NSrGLzSldW0tKrYS4oNynK+1yN3Z8rtY3iDAa+KAh+wjc7ee5hPfBI1LFJ90YOqBfSFWFRajbMo6fVIuhTF2m282QIR1OBR0phcQuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715858813; c=relaxed/simple;
	bh=o+9Pw/zZ87RmBfLa3VoCrF8L1KrcmgTRsn7caS6/Hqo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kGR3EP1jIkbGvBS8PT0BROOUKZArnFD0uybf8PlQqQEzEOXVVdh7KJxDQVtGBbN+MGYzn11kBJ/zelF6uVTPNae9ydM7haMCjAazDT0AMxQYOsZdbSoaWid3RY6Qh2e1XXlsvfoM62xfGx687Nkn7UQ1H5f3wtUjAfJzAobuVfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] tests: shell: add vlan double tagging match simple test case
Date: Thu, 16 May 2024 13:26:38 +0200
Message-Id: <20240516112639.141425-3-pablo@netfilter.org>
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

Add basic test for q-in-q matching support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../packetpath/dumps/vlan_qinq.nodump         |  0
 tests/shell/testcases/packetpath/vlan_qinq    | 52 +++++++++++++++++++
 2 files changed, 52 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/vlan_qinq.nodump
 create mode 100755 tests/shell/testcases/packetpath/vlan_qinq

diff --git a/tests/shell/testcases/packetpath/dumps/vlan_qinq.nodump b/tests/shell/testcases/packetpath/dumps/vlan_qinq.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/packetpath/vlan_qinq b/tests/shell/testcases/packetpath/vlan_qinq
new file mode 100755
index 000000000000..a663fa7056db
--- /dev/null
+++ b/tests/shell/testcases/packetpath/vlan_qinq
@@ -0,0 +1,52 @@
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
+	chain c {
+		type filter hook ingress device veth0 priority filter;
+		ether type 8021ad vlan id 10 vlan type 8021q vlan id 100 counter
+	}
+}
+EOF
+
+ip netns exec "$ns1" ping -c 1 10.1.1.2
+
+ip netns exec "$ns2" $NFT list ruleset
+ip netns exec "$ns2" $NFT list chain netdev t c | grep 'counter packets' | grep -v 'counter packets 0 bytes 0' &> /dev/null
-- 
2.30.2

