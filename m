Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211604EB36
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 13:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951186; cv=none; b=El6FVq9AZLlZ8T/O6n4id86/a0BsABS1xkOrQv/RSUejaoh3ALg2v96J2vKxKDjpuN+dUmh6rOuTjBI3zHSQ40wN1952fGWEFXiKQ/LAmYQ3POOSldMN/wtow4gm7+7nSLl9zRGeWFlPafpkTLD+v6qmlPh/9ccBz725qf5z510=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951186; c=relaxed/simple;
	bh=3rbF81zTXDUQTkU2KcCV7F1MSZWPHU6INb9y0FPc66Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4v+mQyaJgAZtG8VBlgDwX2yemJOOz3lctdc0W4OL374lGMJa+2WJaU8H4UNvCcKP1M71aOUTW68wQBKV/GbyKzn+ezLCYeyOUJttSmcgO+B/8jcSd0vi4sc0vpypv/fq8ZfBa9Y/sedRlDe6SAgHQgxwNjV0pzDns4xhbmujkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=etEd7+ZY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="etEd7+ZY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OcxlbAM6sfj4uad9lIZEbiKhEbty/rucr/Oeq4+E4Gw=; b=etEd7+ZYv287hBFyG0MNDMgKBa
	Eut2mirZCqgjlwkfTs5c+QziaKVJQkDQoBJZQS9Zg9gmv993yD41pLGJ9PGm7nfdBtKi20u37xsWk
	mScVfGXtWjV25iFIyioEY5A3piDD0YgF15+l0HeYVcPQbGre6plzTGfImWSBQQhJSGvo34iCiQgg5
	G1qNWkPX2/ZRlFvR6C0JPIsyVw5rjazD7Gr0kOtsfIBCZ0eOZgBIbG27eibA3eSpqKEp9poLXP2A3
	RJmKEZaDyKpiaXgM8kDgbn42RrZPOfYzUt+ffDD+gBwS15EanmOYP53SkzdI9iEYf+fHkVyuJ8W0z
	7xYfcrLg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s7xHt-000000001dI-1YY2;
	Fri, 17 May 2024 15:06:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [PATCH v2 7/7] selftests: netfilter: Torture nftables netdev hooks
Date: Fri, 17 May 2024 15:06:15 +0200
Message-ID: <20240517130615.19979-8-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240517130615.19979-1-phil@nwl.cc>
References: <20240517130615.19979-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a ruleset which binds to various interface names via netdev-family
chains and flowtables and massage the notifiers by frequently renaming
interfaces to match these names.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_interface_stress.sh     | 106 ++++++++++++++++++
 2 files changed, 107 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index dd9a75a33d28..f95678882819 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -19,6 +19,7 @@ TEST_PROGS += nft_concat_range.sh
 TEST_PROGS += nft_conntrack_helper.sh
 TEST_PROGS += nft_fib.sh
 TEST_PROGS += nft_flowtable.sh
+TEST_PROGS += nft_interface_stress.sh
 TEST_PROGS += nft_meta.sh
 TEST_PROGS += nft_nat.sh
 TEST_PROGS += nft_nat_zones.sh
diff --git a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
new file mode 100755
index 000000000000..6d739f2e0ab9
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
@@ -0,0 +1,106 @@
+#!/bin/bash -e
+#
+# SPDX-License-Identifier: GPL-2.0
+#
+# Torture nftables' netdevice notifier callbacks and related code by frequent
+# renaming of interfaces which netdev-family chains and flowtables hook into.
+
+source lib.sh
+
+checktool "nft --version" "run test without nft tool"
+checktool "iperf3 --version" "run test without iperf3 tool"
+
+# how many seconds to torture the kernel, default to 80% of max run time
+TEST_RUNTIME=$((kselftest_timeout * 8 / 10))
+
+trap "cleanup_all_ns" EXIT
+
+setup_ns nsc nsr nss
+
+ip -net $nsc link add cr0 type veth peer name rc0 netns $nsr
+ip -net $nsc addr add 10.0.0.1/24 dev cr0
+ip -net $nsc link set cr0 up
+ip -net $nsc route add default via 10.0.0.2
+
+ip -net $nss link add sr0 type veth peer name rs0 netns $nsr
+ip -net $nss addr add 10.1.0.1/24 dev sr0
+ip -net $nss link set sr0 up
+ip -net $nss route add default via 10.1.0.2
+
+ip -net $nsr addr add 10.0.0.2/24 dev rc0
+ip -net $nsr link set rc0 up
+ip -net $nsr addr add 10.1.0.2/24 dev rs0
+ip -net $nsr link set rs0 up
+ip netns exec $nsr sysctl -q net.ipv4.ip_forward=1
+ip netns exec $nsr sysctl -q net.ipv4.conf.all.forwarding=1
+
+{
+	echo "table netdev t {"
+	for ((i = 0; i < 10; i++)); do
+		cat <<-EOF
+		chain chain_rc$i {
+			type filter hook ingress device rc$i priority 0
+			counter
+		}
+		chain chain_rs$i {
+			type filter hook ingress device rs$i priority 0
+			counter
+		}
+		EOF
+	done
+	echo "}"
+	echo "table ip t {"
+	for ((i = 0; i < 10; i++)); do
+		cat <<-EOF
+		flowtable ft_${i} {
+			hook ingress priority 0
+			devices = { rc$i, rs$i }
+		}
+		EOF
+	done
+	echo "chain c {"
+	echo "type filter hook forward priority 0"
+	for ((i = 0; i < 10; i++)); do
+		echo -n "iifname rc$i oifname rs$i "
+		echo    "ip protocol tcp counter flow add @ft_${i}"
+	done
+	echo "counter"
+	echo "}"
+	echo "}"
+} | ip netns exec $nsr nft -f - || {
+	echo "SKIP: Could not load nft ruleset"
+	exit $ksft_skip
+}
+
+for ((o=0, n=1; ; o=n, n++, n %= 10)); do
+	ip -net $nsr link set rc$o name rc$n
+	ip -net $nsr link set rs$o name rs$n
+done &
+rename_loop_pid=$!
+
+ip netns exec $nsr nft monitor >/dev/null &
+nft_monitor_pid=$!
+
+ip netns exec $nss iperf3 --server --daemon -1
+summary_expr='s,^\[SUM\] .* \([0-9]\+\) Mbits/sec .* receiver,\1,p'
+rate=$(ip netns exec $nsc iperf3 \
+	--format m -c 10.1.0.1 --time $TEST_RUNTIME \
+	--length 56 --parallel 10 -i 0 | sed -n "$summary_expr")
+
+kill $nft_monitor_pid
+kill $rename_loop_pid
+wait
+
+#ip netns exec $nsr nft list ruleset
+
+[[ $(</proc/sys/kernel/tainted) -eq 0 ]] || {
+	echo "FAIL: Kernel is tainted!"
+	exit $ksft_fail
+}
+
+[[ $rate -gt 0 ]] || {
+	echo "FAIL: Zero throughput in iperf3"
+	exit $ksft_fail
+}
+
+exit $ksft_pass
-- 
2.43.0

