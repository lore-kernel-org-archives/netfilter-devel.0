Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A461229551A;
	Fri, 23 May 2025 13:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006902; cv=none; b=Hyt+9RwW3rIijb1l8P7PO5vQDOwdbcJiV1yRP79AAyxTsYZrWDQWBqBzC14N0+INuSrjDi1lJQEPipbRLysiOw+sm3acHZJ9+ZcyOT87ahD8MkBqCb0DTL4TfSFDdQEc1tdZVIvTeJxag1gFWV6vbQLSRxy6tEwA2++DXeI0Wik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006902; c=relaxed/simple;
	bh=+WyuSzY8iTXakgKPrZTOoJAzKr6no3oaF9Hoo6viGco=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bcIwpgNdudSR4vAX4cmnvJPfDpxvPuxCxAG53snouoa/oU4QZJlQd3gSM7djStvo9x/MO1afWifU1QU6M1jqviZqeOwuTMnd9W7AG64Zte562h9Wz3FgjhGyh/zskokvukbGGNOjeWdVIrrKrzk3eaTE+/QxfQ24J45yDkmR5gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dQZ3CFFJ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vJiRhUYN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dQZ3CFFJ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vJiRhUYN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7F61B60700; Fri, 23 May 2025 15:28:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006899;
	bh=fgtfte1RQBzSglXlyusqVeme6v6O+BEQRvyDXs0vEDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQZ3CFFJV/mHJbIGl58TqsDPIjuA++XAZ9x4CW0YWau+iZAXxgRCAouR1aHbFgOfG
	 BhAII/Dj7UhpsH+bx60j8ZWQ8Z+ycm9WY3M5OPMWU/779MZHGa38q0dxknTafT+ulk
	 qFiI/RpdAf1iJYoNR2lWhTcPbKfVjhbBFpiCcbOgMr9dlMYCw11Ta7PYR7JRQWLdpL
	 AIASHIu04rQzaud/5x0/LdwBErEh3832xOONDKYmV6JgwzJSJOwW6akx3WKkAiR1vy
	 c7+x7uK1GqKKmU5gNel1B+EKFZtTnr8pV4D6SwKkF6FRnbxkfB4z+3CaTfFkJUtChZ
	 eOzQqJEnYWMAg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1B6F46078C;
	Fri, 23 May 2025 15:27:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006857;
	bh=fgtfte1RQBzSglXlyusqVeme6v6O+BEQRvyDXs0vEDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJiRhUYNnO1PF2+sNb9tRT2wjG8zjJ9hwThTsv2crxgoIYH7fY/5aMy0ldl4Np6Dn
	 t7oMnUjfodFW/OpytSbtoh66DTjTXuQJnXEPkYAfxfmcBuj25O1tYecYuBrVqixCLW
	 OfCGh+rQYqLZJzMbmTjfJnmpB8giQfRuXOJ0IOCkMLs5acrbydGKv+isI9FK9c5beM
	 jx1InuyBQgYN3tPf7Vfzk2grZtgpJiBp52byx7CuZ15buf4AgNPHHHw9WMtGCOKUsM
	 e2iygdbNw09sXw37MPkyy5CrCUtu0NOSqM/Ch0xuMaVy2ve26Wdk7PuTRLYAxmhlYr
	 NNGg+LFOmJQEQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 26/26] selftests: netfilter: Torture nftables netdev hooks
Date: Fri, 23 May 2025 15:27:12 +0200
Message-Id: <20250523132712.458507-27-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Add a ruleset which binds to various interface names via netdev-family
chains and flowtables and massage the notifiers by frequently renaming
interfaces to match these names. While doing so:
- Keep an 'nft monitor' running in background to receive the notifications
- Loop over 'nft list ruleset' to exercise ruleset dump codepath
- Have iperf running so the involved chains/flowtables see traffic

If supported, also test interface wildcard support separately by
creating a flowtable with 'wild*' interface spec and quickly add/remove
matching dummy interfaces.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_interface_stress.sh     | 151 ++++++++++++++++++
 2 files changed, 152 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index 3bdcbbdba925..e9b2f553588d 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -24,6 +24,7 @@ TEST_PROGS += nft_concat_range.sh
 TEST_PROGS += nft_conntrack_helper.sh
 TEST_PROGS += nft_fib.sh
 TEST_PROGS += nft_flowtable.sh
+TEST_PROGS += nft_interface_stress.sh
 TEST_PROGS += nft_meta.sh
 TEST_PROGS += nft_nat.sh
 TEST_PROGS += nft_nat_zones.sh
diff --git a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
new file mode 100755
index 000000000000..11d82d11495e
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
@@ -0,0 +1,151 @@
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
+# how many seconds to torture the kernel?
+# default to 80% of max run time but don't exceed 48s
+TEST_RUNTIME=$((${kselftest_timeout:-60} * 8 / 10))
+[[ $TEST_RUNTIME -gt 48 ]] && TEST_RUNTIME=48
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
+while true; do ip netns exec $nsr nft list ruleset >/dev/null 2>&1; done &
+nft_list_pid=$!
+
+ip netns exec $nsr nft monitor >/dev/null &
+nft_monitor_pid=$!
+
+ip netns exec $nss iperf3 --server --daemon -1
+summary_expr='s,^\[SUM\] .* \([0-9\.]\+\) Kbits/sec .* receiver,\1,p'
+rate=$(ip netns exec $nsc iperf3 \
+	--format k -c 10.1.0.1 --time $TEST_RUNTIME \
+	--length 56 --parallel 10 -i 0 | sed -n "$summary_expr")
+
+kill $nft_list_pid
+kill $nft_monitor_pid
+kill $rename_loop_pid
+wait
+
+ip netns exec $nsr nft -f - <<EOF
+table ip t {
+	flowtable ft_wild {
+		hook ingress priority 0
+		devices = { wild* }
+	}
+}
+EOF
+if [[ $? -ne 0 ]]; then
+	echo "SKIP wildcard tests: not supported by host's nft?"
+else
+	for ((i = 0; i < 100; i++)); do
+		ip -net $nsr link add wild$i type dummy &
+	done
+	wait
+	for ((i = 80; i < 100; i++)); do
+		ip -net $nsr link del wild$i &
+	done
+	for ((i = 0; i < 80; i++)); do
+		ip -net $nsr link del wild$i &
+	done
+	wait
+	for ((i = 0; i < 100; i += 10)); do
+		(
+		for ((j = 0; j < 10; j++)); do
+			ip -net $nsr link add wild$((i + j)) type dummy
+		done
+		for ((j = 0; j < 10; j++)); do
+			ip -net $nsr link del wild$((i + j))
+		done
+		) &
+	done
+	wait
+fi
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
+[[ -f /sys/kernel/debug/kmemleak && \
+   -n $(</sys/kernel/debug/kmemleak) ]] && {
+	echo "FAIL: non-empty kmemleak report"
+	exit $ksft_fail
+}
+
+exit $ksft_pass
-- 
2.30.2

