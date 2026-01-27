Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83DD35FF67
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769552966; cv=none; b=MyWnH0P7Dw8UtBI1IasxLQSue6s9+EhSs5Ej3kAnWfnW2wMWMUo5+h76K7zj+KXSPzYc4+RuDdSENmZIOHkqco4Vs1bHEE4/wMdZlIplRPzi7GHYYLsE4wxsjuJy5NifAHgbX8wG/FP6TinpDXblGWdZIAe//oAjvu9yABlhpm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769552966; c=relaxed/simple;
	bh=DDN0Pw8bWC8ovyxX2X4M7irZqZXYiuwSG1bi7n+dRrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8N2Whs6N6X8x5pqYF9CxDV9mOW/XyQmFrsKjdM6h78UbyRZ3uKuCoyRHWouSeNgMiqubFEjHNvsFfYWXcOA+nbKsJ+0umga3gi49PMj6S4hawYkOeC8raGl32pij+kM5EbuXmb/00P7yS0QUOzh4x16ZjtriAEqNAB94SHUExs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BD2T17PA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BD2T17PA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=07W+u4mnLPdMJPbYvZGvLIuE9XkUoeCohK15WL4+RKw=; b=BD2T17PAvFl70pnDMpuXQcHyOq
	AdY5EknfFSFgzpFu7XABlkYltRUU2XlaWdStS12gCNCPhxjwNMBuN1TTBEvahhaG+WtAA8D3XjDMe
	o98CeIArobcdgJjlipS4ghzMe42gWbjJruvyvLaDHYRLqXGyMgRBktyOHk2dMPwDuPn01ZJbt3iFN
	5T1+YwZdDsX5J83ggWh39gfML2ABD7Im8VA/BQ9uW6RS+KXVzQJK4uiDE4mEU8W64RI8Z8Hc+VrAq
	c1d/yhfSwnEocHVu8prMSxV1eTT3S20sPgRUNJFXyxAwk8YlQUOOVO6RDBZLe+IAHXCbKn7Lk5EXZ
	IMmQ51JA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkrYp-000000002lq-2Sae;
	Tue, 27 Jan 2026 23:29:23 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/4] tests: shell: Add a simple test for nftrace
Date: Tue, 27 Jan 2026 23:29:14 +0100
Message-ID: <20260127222916.31806-3-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127222916.31806-1-phil@nwl.cc>
References: <20260127222916.31806-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test suites did not cover src/trace.c at all. This test touches over
90% of its lines.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/trace/0001simple | 85 ++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100755 tests/shell/testcases/trace/0001simple

diff --git a/tests/shell/testcases/trace/0001simple b/tests/shell/testcases/trace/0001simple
new file mode 100755
index 0000000000000..a1bf4dd1318b2
--- /dev/null
+++ b/tests/shell/testcases/trace/0001simple
@@ -0,0 +1,85 @@
+#!/bin/bash -x
+
+set -e
+
+ns1=$(mktemp -u ns1-XXXXXX)
+ns2=$(mktemp -u ns2-XXXXXX)
+tracelog=$(mktemp)
+tracepid=0
+cleanup() {
+	ip netns del $ns1
+	ip netns del $ns2
+	[ $tracepid -eq 0 ] || {
+		kill $tracepid
+		wait
+	}
+	rm -f $tracelog
+}
+trap "cleanup" EXIT
+ip netns add $ns1
+ip netns add $ns2
+ip -net $ns1 link add eth0 type veth peer name eth0 netns $ns2
+ip -net $ns1 link set eth0 up
+ip -net $ns1 addr add 10.23.42.1/24 dev eth0
+ip -net $ns2 link set eth0 up
+ip -net $ns2 addr add 10.23.42.2/24 dev eth0
+ns1mac=$(ip -net $ns1 link show dev eth0 | awk '/link\/ether/{ print $2 }')
+ns2mac=$(ip -net $ns2 link show dev eth0 | awk '/link\/ether/{ print $2 }')
+ip netns exec $ns1 ping -c 1 10.23.42.2
+ip netns exec $ns2 ping -c 1 10.23.42.1
+
+ip netns exec $ns1 $NFT -f - <<EOF
+table inet t {
+	chain pre {
+		type filter hook prerouting priority 0
+
+		icmp type { echo-request, echo-reply } meta mark set 0x42 ct state new,established meta nftrace set 1
+	}
+	chain foo {
+		tcp dport 456 accept
+		ct status != dying return
+		tcp dport 23 drop
+	}
+	chain input {
+		type filter hook input priority 0
+
+		meta mark 0x42 jump foo
+		meta mark 0x42 tcp dport 789 accept
+	}
+	chain output {
+		type filter hook output priority 0
+
+		icmp type echo-reply meta nftrace set 1
+	}
+}
+EOF
+
+ip netns exec $ns1 $NFT monitor trace >$tracelog &
+tracepid=$!
+sleep 0.5
+ip netns exec $ns2 ping -c 1 10.23.42.1
+sleep 0.5
+kill $tracepid
+wait
+tracepid=0
+
+EXPECT="trace id 0 inet t pre conntrack: ct direction original ct state new ct id 0 
+trace id 0 inet t pre packet: iif \"eth0\" ether saddr $ns2mac ether daddr $ns1mac ip saddr 10.23.42.2 ip daddr 10.23.42.1 ip dscp cs0 ip ecn not-ect ip ttl 64 ip id 0 ip protocol icmp ip length 84 icmp type echo-request icmp code 0 icmp id 0 icmp sequence 1 
+trace id 0 inet t pre rule icmp type { echo-reply, echo-request } meta mark set 0x00000042 ct state established,new meta nftrace set 1 (verdict continue)
+trace id 0 inet t pre policy accept meta mark 0x00000042 
+trace id 0 inet t input conntrack: ct direction original ct state new ct id 0 
+trace id 0 inet t input packet: iif \"eth0\" ether saddr $ns2mac ether daddr $ns1mac ip saddr 10.23.42.2 ip daddr 10.23.42.1 ip dscp cs0 ip ecn not-ect ip ttl 64 ip id 0 ip protocol icmp ip length 84 icmp type echo-request icmp code 0 icmp id 0 icmp sequence 1 
+trace id 0 inet t input rule meta mark 0x00000042 jump foo (verdict jump foo)
+trace id 0 inet t foo rule ct status != dying return (verdict return)
+trace id 0 inet t input policy accept meta mark 0x00000042 
+trace id 0 inet t output conntrack: ct direction reply ct state established ct status seen-reply,confirmed ct id 0 
+trace id 0 inet t output packet: oif \"eth0\" ip saddr 10.23.42.1 ip daddr 10.23.42.2 ip dscp cs0 ip ecn not-ect ip ttl 64 ip id 0 ip protocol icmp ip length 84 icmp type echo-reply icmp code 0 icmp id 0 icmp sequence 1 
+trace id 0 inet t output rule icmp type echo-reply meta nftrace set 1 (verdict continue)
+trace id 0 inet t output policy accept "
+
+
+tracefilter() {
+	sed -e 's/\(trace\|ip\|icmp\|ct\) id [^ ]\+/\1 id 0/g'
+}
+diff -u <(echo "$EXPECT") <(cat $tracelog | tracefilter)
+exit 0
-- 
2.51.0

