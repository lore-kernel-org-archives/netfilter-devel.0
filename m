Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C310F1ABEDD
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344620; cv=none; b=syKoqdo6TBPXHbPEZrgHaCEY4Lyqn3p5enQgPLdxyCfBwlaTENgUsE2TOtKbkSvp2uLdiiq3rNg3Fi/uJi82dPVm6rB48qTWL5YdMWBwl+Lt2cN5gN0pGFjd8o3dZJE/zQ7hkHtF8JZn6eikCs8dzp27HJOKj6uzIR22V5P6XzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344620; c=relaxed/simple;
	bh=mmqSIpTtQNQg/qE46Qvp7c0GrRImxhT6jbV0TjqL6+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWOl1U0wogKs4YdSbFR31F9gJWGnuaYEGCcmxRxfP+7o3Oh4C9ZkUHXUOfUmB0MbwDa2HyAAa5kb7PCd3Z+z5j32/knEB7E8ZmY3a6eXC4Np4tRs4Bo10w489uApnTyne1jaRhxxrfVndSIXavou7lTBeh/aexlVgE5Jm0dfkQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KYD2RrWM; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KYD2RrWM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iM4k32SPTQc/FnvghelDiLY4b+VEgOV47HN5WblMF04=; b=KYD2RrWMigTRe5m/iQzUYZcha8
	jWmP7ePLjL8eOr12JdkoswmMZvztINQRWiyr4s3hSLBDtXJjs5f4NAA7qm6Y4VCs8ICGk7iliRHYF
	OVhkStYLese5sG+5gdSVZxHZxAajkIdyhHcCWjHQOoADcn8ONQ6dW84uitCh4U1liLGHpEighuWyu
	VHxfHQviXz8rBPJd+QpQ5DTk9VIeAeRoSrBz6n2BE9tO1cGxPyMaX+CvQYf1V78ZXxIf2ydNhxbYU
	GQCjcULAyQrFni4MbwJbjmSYY4bZNGsp9jYVdPVImhYPxYsGTcDiI+GJtSrlbBUyxLDj+hWD5AVQZ
	oH8QUhSQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlF3-000000006Gj-06vt;
	Thu, 26 Sep 2024 11:56:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 18/18] selftests: netfilter: Torture nftables netdev hooks
Date: Thu, 26 Sep 2024 11:56:43 +0200
Message-ID: <20240926095643.8801-19-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240926095643.8801-1-phil@nwl.cc>
References: <20240926095643.8801-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
Changes since v4:
- Limit maximum run-time to 48s.
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_interface_stress.sh     | 151 ++++++++++++++++++
 2 files changed, 152 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index d13fb5ea3e89..823e0acf7171 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -21,6 +21,7 @@ TEST_PROGS += nft_concat_range.sh
 TEST_PROGS += nft_conntrack_helper.sh
 TEST_PROGS += nft_fib.sh
 TEST_PROGS += nft_flowtable.sh
+TEST_PROGS += nft_interface_stress.sh
 TEST_PROGS += nft_meta.sh
 TEST_PROGS += nft_nat.sh
 TEST_PROGS += nft_nat_zones.sh
diff --git a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
new file mode 100755
index 000000000000..27ef082a09a7
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
+summary_expr='s,^\[SUM\] .* \([0-9]\+\) Mbits/sec .* receiver,\1,p'
+rate=$(ip netns exec $nsc iperf3 \
+	--format m -c 10.1.0.1 --time $TEST_RUNTIME \
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
2.43.0

