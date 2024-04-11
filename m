Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2E84C601;
	Thu, 11 Apr 2024 23:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878975; cv=none; b=jEF0lu8+H6W5Wjubig1h4BWHQxWDmuq6SfSu0dp4HGt86Rff2gZN1ryKrYUDljIIE5JHZAmNUUQvIQmExy0knyqWsSqysxABZ4uNmh/d0/g11nZfHIOY0a6c2gqquHtzP+bRxCxlN7nPpNsfb4+Hv04BCDD9uFsw5LbpnuhBQ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878975; c=relaxed/simple;
	bh=whtwwGbid6QwZLpkD1J7YMYQ1Kfyh2iTM3OtCJ9OgpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLR5X9rtEGEP1hNB1+0uTezUqBT7g2D2OEPiDfiDA0nAWa1JR20CdGxkSChEdl111YU2QV822XOLsj0Rgr1BN262oQV4Y1qsiKDGaB9b1bgoYSZZoxpJLKWSeTCn2O2BAGWPhZIN+Fws3Zu51xR0KrqaMhRRh2hJLYwqfvo5FNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv44C-0000vu-6s; Fri, 12 Apr 2024 01:42:52 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 08/15] selftests: netfilter: conntrack_ipip_mtu.sh" move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:13 +0200
Message-ID: <20240411233624.8129-9-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240411233624.8129-1-fw@strlen.de>
References: <20240411233624.8129-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/conntrack_ipip_mtu.sh       | 37 +++++++------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_ipip_mtu.sh b/tools/testing/selftests/net/netfilter/conntrack_ipip_mtu.sh
index eb9553e4986b..f87ca4c59d3b 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_ipip_mtu.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_ipip_mtu.sh
@@ -1,8 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+source lib.sh
 
 # Conntrack needs to reassemble fragments in order to have complete
 # packets for rule matching.  Reassembly can lead to packet loss.
@@ -23,15 +22,8 @@ ksft_skip=4
 # between Client A and Client B over WAN. Wanrouter has MTU 1400 set
 # on its interfaces.
 
-rnd=$(mktemp -u XXXXXXXX)
 rx=$(mktemp)
 
-r_a="ns-ra-$rnd"
-r_b="ns-rb-$rnd"
-r_w="ns-rw-$rnd"
-c_a="ns-ca-$rnd"
-c_b="ns-cb-$rnd"
-
 checktool (){
 	if ! $1 > /dev/null 2>&1; then
 		echo "SKIP: Could not $2"
@@ -40,29 +32,31 @@ checktool (){
 }
 
 checktool "iptables --version" "run test without iptables"
-checktool "ip -Version" "run test without ip tool"
-checktool "which socat" "run test without socat"
-checktool "ip netns add ${r_a}" "create net namespace"
+checktool "socat -h" "run test without socat"
 
-for n in ${r_b} ${r_w} ${c_a} ${c_b};do
-	ip netns add ${n}
-done
+setup_ns r_a r_b r_w c_a c_b
 
 cleanup() {
-	for n in ${r_a} ${r_b} ${r_w} ${c_a} ${c_b};do
-		ip netns del ${n}
-	done
+	cleanup_all_ns
 	rm -f ${rx}
 }
 
 trap cleanup EXIT
 
+listener_ready()
+{
+	ns="$1"
+	port="$2"
+	ss -N "$ns" -lnu -o "sport = :$port" | grep -q "$port"
+}
+
 test_path() {
 	msg="$1"
 
 	ip netns exec ${c_b} socat -t 3 - udp4-listen:5000,reuseaddr > ${rx} < /dev/null &
 
-	sleep 1
+	busywait $BUSYWAIT_TIMEOUT listener_ready "$c_b" 5000
+
 	for i in 1 2 3; do
 		head -c1400 /dev/zero | tr "\000" "a" | \
 			ip netns exec ${c_a} socat -t 1 -u STDIN UDP:192.168.20.2:5000
@@ -129,7 +123,7 @@ r_addr="10.2.2.1"
 
 ip netns exec ${r_b} ip link add ipip0 type ipip local ${l_addr} remote ${r_addr} mode ipip || exit $ksft_skip
 
-for dev in lo veth0 veth1 ipip0; do
+for dev in veth0 veth1 ipip0; do
 	ip -net ${r_b} link set $dev up
 done
 
@@ -142,21 +136,18 @@ ip netns exec ${r_b} sysctl -q net.ipv4.conf.all.forwarding=1 > /dev/null
 
 # Client A
 ip -net ${c_a} addr add 192.168.10.2/24 dev veth0
-ip -net ${c_a} link set dev lo up
 ip -net ${c_a} link set dev veth0 up
 ip -net ${c_a} route add default via 192.168.10.1
 
 # Client A
 ip -net ${c_b} addr add 192.168.20.2/24 dev veth0
 ip -net ${c_b} link set dev veth0 up
-ip -net ${c_b} link set dev lo up
 ip -net ${c_b} route add default via 192.168.20.1
 
 # Wan
 ip -net ${r_w} addr add 10.2.2.254/24 dev veth0
 ip -net ${r_w} addr add 10.4.4.254/24 dev veth1
 
-ip -net ${r_w} link set dev lo up
 ip -net ${r_w} link set dev veth0 up mtu 1400
 ip -net ${r_w} link set dev veth1 up mtu 1400
 
-- 
2.43.2

