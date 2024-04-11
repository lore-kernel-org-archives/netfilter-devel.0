Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A48A46B83;
	Thu, 11 Apr 2024 23:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878955; cv=none; b=l/OTveLo48yDDXidT3rumf9h7etLDNpQbWVe+MBOw8mn6VQVWTCAtDyg95B9u1qTJmZIi467Nuv5VIt0JRnXZI94nDXTry+u+Y0f4Meo4Aed0uTZZqN/szh1yATGj5guVprSt//5t3lmOac1HUaO6lS7fvX+dAcv6/uqF+qmTcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878955; c=relaxed/simple;
	bh=pL79Z+iUIZn4JRUKZpggGkV2Tui2/7ugdG27zBzJvfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKnbak55HiVrv+UKBfiuO7rVY5xSwodznA6fIQmh7rMfK75nVZ8py7Qp7i0z0EHsM4pltZug/9rfJE7q3wr/NIVqMnANVt0w7D3l41N6vsI0zPGHLZyFBznxtOG3KxVhNvtUFt7dWn1mIHw8LK0LycuR5vZglsqE3DjIUSBJ1Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv43r-0000th-PB; Fri, 12 Apr 2024 01:42:31 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 03/15] selftests: netfilter: br_netfilter.sh: move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:08 +0200
Message-ID: <20240411233624.8129-4-fw@strlen.de>
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

Also, fix two issues reported by Pablo Neira:
1. Must modprobe br_netfilter in case its not loaded,
   else sysctl cannot be set.
2. ping for netns4 fails if rp_filter is enabled in bridge netns,
   so set all and default to 0.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/br_netfilter.sh   | 131 ++++++++----------
 1 file changed, 55 insertions(+), 76 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/br_netfilter.sh b/tools/testing/selftests/net/netfilter/br_netfilter.sh
index 659b3ab02c8b..ea3afd6d401f 100755
--- a/tools/testing/selftests/net/netfilter/br_netfilter.sh
+++ b/tools/testing/selftests/net/netfilter/br_netfilter.sh
@@ -1,55 +1,40 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 #
-# Test bridge netfilter + conntrack, a combination that doesn't really work,
-# with multicast/broadcast packets racing for hash table insertion.
+# Test for legacy br_netfilter module combined with connection tracking,
+# a combination that doesn't really work.
+# Multicast/broadcast packets race for hash table insertion.
 
 #           eth0    br0     eth0
 # setup is: ns1 <->,ns0 <-> ns3
 #           ns2 <-'    `'-> ns4
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-ret=0
-
-sfx=$(mktemp -u "XXXXXXXX")
-ns0="ns0-$sfx"
-ns1="ns1-$sfx"
-ns2="ns2-$sfx"
-ns3="ns3-$sfx"
-ns4="ns4-$sfx"
+source lib.sh
 
-ebtables -V > /dev/null 2>&1
+nft --version > /dev/null 2>&1
 if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ebtables"
+	echo "SKIP: Could not run test without nft tool"
 	exit $ksft_skip
 fi
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-for i in $(seq 0 4); do
-  eval ip netns add \$ns$i
-done
-
 cleanup() {
-  for i in $(seq 0 4); do eval ip netns del \$ns$i;done
+	cleanup_all_ns
 }
 
 trap cleanup EXIT
 
+setup_ns ns0 ns1 ns2 ns3 ns4
+
+ret=0
+
 do_ping()
 {
 	fromns="$1"
 	dstip="$2"
 
-	ip netns exec $fromns ping -c 1 -q $dstip > /dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$fromns" ping -c 1 -q "$dstip" > /dev/null; then
 		echo "ERROR: ping from $fromns to $dstip"
-		ip netns exec ${ns0} nft list ruleset
+		ip netns exec "$ns0" nft list ruleset
 		ret=1
 	fi
 }
@@ -59,75 +44,75 @@ bcast_ping()
 	fromns="$1"
 	dstip="$2"
 
-	for i in $(seq 1 1000); do
-		ip netns exec $fromns ping -q -f -b -c 1 -q $dstip > /dev/null 2>&1
-		if [ $? -ne 0 ]; then
+	for i in $(seq 1 500); do
+		if ! ip netns exec "$fromns" ping -q -f -b -c 1 -q "$dstip" > /dev/null 2>&1; then
 			echo "ERROR: ping -b from $fromns to $dstip"
-			ip netns exec ${ns0} nft list ruleset
-			fi
+			ip netns exec "$ns0" nft list ruleset
+			ret=1
+			break
+		fi
 	done
 }
 
-ip link add veth1 netns ${ns0} type veth peer name eth0 netns ${ns1}
-if [ $? -ne 0 ]; then
+ip netns exec "$ns0" sysctl -q net.ipv4.conf.all.rp_filter=0
+ip netns exec "$ns0" sysctl -q net.ipv4.conf.default.rp_filter=0
+
+if ! ip link add veth1 netns "$ns0" type veth peer name eth0 netns "$ns1"; then
 	echo "SKIP: Can't create veth device"
 	exit $ksft_skip
 fi
 
-ip link add veth2 netns ${ns0} type veth peer name eth0 netns $ns2
-ip link add veth3 netns ${ns0} type veth peer name eth0 netns $ns3
-ip link add veth4 netns ${ns0} type veth peer name eth0 netns $ns4
-
-ip -net ${ns0} link set lo up
+ip link add veth2 netns "$ns0" type veth peer name eth0 netns "$ns2"
+ip link add veth3 netns "$ns0" type veth peer name eth0 netns "$ns3"
+ip link add veth4 netns "$ns0" type veth peer name eth0 netns "$ns4"
 
 for i in $(seq 1 4); do
-  ip -net ${ns0} link set veth$i up
+  ip -net "$ns0" link set "veth$i" up
 done
 
-ip -net ${ns0} link add br0 type bridge stp_state 0 forward_delay 0 nf_call_iptables 1 nf_call_ip6tables 1 nf_call_arptables 1
-if [ $? -ne 0 ]; then
+if ! ip -net "$ns0" link add br0 type bridge stp_state 0 forward_delay 0 nf_call_iptables 1 nf_call_ip6tables 1 nf_call_arptables 1; then
 	echo "SKIP: Can't create bridge br0"
 	exit $ksft_skip
 fi
 
 # make veth0,1,2 part of bridge.
 for i in $(seq 1 3); do
-  ip -net ${ns0} link set veth$i master br0
+  ip -net "$ns0" link set "veth$i" master br0
 done
 
 # add a macvlan on top of the bridge.
 MACVLAN_ADDR=ba:f3:13:37:42:23
-ip -net ${ns0} link add link br0 name macvlan0 type macvlan mode private
-ip -net ${ns0} link set macvlan0 address ${MACVLAN_ADDR}
-ip -net ${ns0} link set macvlan0 up
-ip -net ${ns0} addr add 10.23.0.1/24 dev macvlan0
+ip -net "$ns0" link add link br0 name macvlan0 type macvlan mode private
+ip -net "$ns0" link set macvlan0 address ${MACVLAN_ADDR}
+ip -net "$ns0" link set macvlan0 up
+ip -net "$ns0" addr add 10.23.0.1/24 dev macvlan0
 
 # add a macvlan on top of veth4.
 MACVLAN_ADDR=ba:f3:13:37:42:24
-ip -net ${ns0} link add link veth4 name macvlan4 type macvlan mode vepa
-ip -net ${ns0} link set macvlan4 address ${MACVLAN_ADDR}
-ip -net ${ns0} link set macvlan4 up
+ip -net "$ns0" link add link veth4 name macvlan4 type macvlan mode passthru
+ip -net "$ns0" link set macvlan4 address ${MACVLAN_ADDR}
+ip -net "$ns0" link set macvlan4 up
 
 # make the macvlan part of the bridge.
 # veth4 is not a bridge port, only the macvlan on top of it.
-ip -net ${ns0} link set macvlan4 master br0
+ip -net "$ns0" link set macvlan4 master br0
 
-ip -net ${ns0} link set br0 up
-ip -net ${ns0} addr add 10.0.0.1/24 dev br0
-ip netns exec ${ns0} sysctl -q net.bridge.bridge-nf-call-iptables=1
-ret=$?
-if [ $ret -ne 0 ] ; then
+ip -net "$ns0" link set br0 up
+ip -net "$ns0" addr add 10.0.0.1/24 dev br0
+
+modprobe -q br_netfilter
+if ! ip netns exec "$ns0" sysctl -q net.bridge.bridge-nf-call-iptables=1; then
 	echo "SKIP: bridge netfilter not available"
 	ret=$ksft_skip
 fi
 
 # for testing, so namespaces will reply to ping -b probes.
-ip netns exec ${ns0} sysctl -q net.ipv4.icmp_echo_ignore_broadcasts=0
+ip netns exec "$ns0" sysctl -q net.ipv4.icmp_echo_ignore_broadcasts=0
 
 # enable conntrack in ns0 and drop broadcast packets in forward to
 # avoid them from getting confirmed in the postrouting hook before
 # the cloned skb is passed up the stack.
-ip netns exec ${ns0} nft -f - <<EOF
+ip netns exec "$ns0" nft -f - <<EOF
 table ip filter {
 	chain input {
 		type filter hook input priority 1; policy accept
@@ -149,36 +134,30 @@ EOF
 # part of the bridge: the corresponding veth4 is not
 # part of the bridge, only its macvlan interface.
 for i in $(seq 1 4); do
-  eval ip -net \$ns$i link set lo up
-  eval ip -net \$ns$i link set eth0 up
+  eval ip -net \$ns"$i" link set eth0 up
 done
 for i in $(seq 1 2); do
-  eval ip -net \$ns$i addr add 10.0.0.1$i/24 dev eth0
+  eval ip -net \$ns"$i" addr add "10.0.0.1$i/24" dev eth0
 done
 
-ip -net ${ns3} addr add 10.23.0.13/24 dev eth0
-ip -net ${ns4} addr add 10.23.0.14/24 dev eth0
+ip -net "$ns3" addr add 10.23.0.13/24 dev eth0
+ip -net "$ns4" addr add 10.23.0.14/24 dev eth0
 
 # test basic connectivity
-do_ping ${ns1} 10.0.0.12
-do_ping ${ns3} 10.23.0.1
-do_ping ${ns4} 10.23.0.1
-
-if [ $ret -eq 0 ];then
-	echo "PASS: netns connectivity: ns1 can reach ns2, ns3 and ns4 can reach ns0"
-fi
+do_ping "$ns1" 10.0.0.12
+do_ping "$ns3" 10.23.0.1
+do_ping "$ns4" 10.23.0.1
 
-bcast_ping ${ns1} 10.0.0.255
+bcast_ping "$ns1" 10.0.0.255
 
 # This should deliver broadcast to macvlan0, which is on top of ns0:br0.
-bcast_ping ${ns3} 10.23.0.255
+bcast_ping "$ns3" 10.23.0.255
 
 # same, this time via veth4:macvlan4.
-bcast_ping ${ns4} 10.23.0.255
+bcast_ping "$ns4" 10.23.0.255
 
 read t < /proc/sys/kernel/tainted
-
-if [ $t -eq 0 ];then
+if [ "$t" -eq 0 ];then
 	echo PASS: kernel not tainted
 else
 	echo ERROR: kernel is tainted
-- 
2.43.2

