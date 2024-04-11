Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE7B47F58;
	Thu, 11 Apr 2024 23:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878983; cv=none; b=gFH6y8a8dcfuBuwAXeFq3CRXkkV3WUk0xLUm4qolL4giyaGtrcTQC3+ZAm85S7mUVtICdi3qagAckk4bAZUna0U4U8vOb2Q4L7EgiRP0jFEg+baxRohxKvWyV3iRXYOcWh4dqUGyX4p3OQuc21Rzo8A9x/uHMd79LVyWq1wu1C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878983; c=relaxed/simple;
	bh=mohIqOPAhcXEuZUrzoS2P0GGSr+RtYRroQNCSiEQEnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGnOr+Pq/jVOVDvglMO+6yZvR5yEG9rwXKXFo7hN6fzaZYuXQZVvGii4TMmb+qbz9Kv+1spWGy5623t88cRJ01CRm/hbWRZMHny9R/vB3VOStruQ2/GYRAZ8XC2YogutrUkTarMMbOF5rcRUi9gdCf757Sx3JoNMFxXiZy+zKFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv44K-0000wr-CX; Fri, 12 Apr 2024 01:43:00 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 10/15] selftests: netfilter: ipvs.sh: move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:15 +0200
Message-ID: <20240411233624.8129-11-fw@strlen.de>
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

The setup_ns helper makes the netns names random, so replace nsX with $nsX
everywhere.

Replace nc with socat, otherwise script fails on my system due to
incompatible nc versions ("nc: cannot use -p and -l").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/ipvs.sh | 153 ++++++++----------
 1 file changed, 68 insertions(+), 85 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/ipvs.sh b/tools/testing/selftests/net/netfilter/ipvs.sh
index c3b8f90c497e..4ceee9fb3949 100755
--- a/tools/testing/selftests/net/netfilter/ipvs.sh
+++ b/tools/testing/selftests/net/netfilter/ipvs.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 #
 # End-to-end ipvs test suite
@@ -24,8 +24,8 @@
 # We assume that all network driver are loaded
 #
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+source lib.sh
+
 ret=0
 GREEN='\033[0;92m'
 RED='\033[0;31m'
@@ -46,53 +46,39 @@ readonly datalen=32
 
 sysipvsnet="/proc/sys/net/ipv4/vs/"
 if [ ! -d $sysipvsnet ]; then
-	modprobe -q ip_vs
-	if [ $? -ne 0 ]; then
+	if ! modprobe -q ip_vs; then
 		echo "skip: could not run test without ipvs module"
 		exit $ksft_skip
 	fi
 fi
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ]; then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-ipvsadm -v > /dev/null 2>&1
-if [ $? -ne 0 ]; then
-	echo "SKIP: Could not run test without ipvsadm"
-	exit $ksft_skip
-fi
+checktool "ipvsadm -v" "run test without ipvsadm"
+checktool "socat -h" "run test without socat"
 
 setup() {
-	ip netns add ns0
-	ip netns add ns1
-	ip netns add ns2
-
-	ip link add veth01 netns ns0 type veth peer name veth10 netns ns1
-	ip link add veth02 netns ns0 type veth peer name veth20 netns ns2
-	ip link add veth12 netns ns1 type veth peer name veth21 netns ns2
-
-	ip netns exec ns0 ip link set veth01 up
-	ip netns exec ns0 ip link set veth02 up
-	ip netns exec ns0 ip link add br0 type bridge
-	ip netns exec ns0 ip link set veth01 master br0
-	ip netns exec ns0 ip link set veth02 master br0
-	ip netns exec ns0 ip link set br0 up
-	ip netns exec ns0 ip addr add ${cip_v4}/24 dev br0
-
-	ip netns exec ns1 ip link set lo up
-	ip netns exec ns1 ip link set veth10 up
-	ip netns exec ns1 ip addr add ${gip_v4}/24 dev veth10
-	ip netns exec ns1 ip link set veth12 up
-	ip netns exec ns1 ip addr add ${dip_v4}/24 dev veth12
-
-	ip netns exec ns2 ip link set lo up
-	ip netns exec ns2 ip link set veth21 up
-	ip netns exec ns2 ip addr add ${rip_v4}/24 dev veth21
-	ip netns exec ns2 ip link set veth20 up
-	ip netns exec ns2 ip addr add ${sip_v4}/24 dev veth20
+	setup_ns ns0 ns1 ns2
+
+	ip link add veth01 netns "${ns0}" type veth peer name veth10 netns "${ns1}"
+	ip link add veth02 netns "${ns0}" type veth peer name veth20 netns "${ns2}"
+	ip link add veth12 netns "${ns1}" type veth peer name veth21 netns "${ns2}"
+
+	ip netns exec "${ns0}" ip link set veth01 up
+	ip netns exec "${ns0}" ip link set veth02 up
+	ip netns exec "${ns0}" ip link add br0 type bridge
+	ip netns exec "${ns0}" ip link set veth01 master br0
+	ip netns exec "${ns0}" ip link set veth02 master br0
+	ip netns exec "${ns0}" ip link set br0 up
+	ip netns exec "${ns0}" ip addr add "${cip_v4}/24" dev br0
+
+	ip netns exec "${ns1}" ip link set veth10 up
+	ip netns exec "${ns1}" ip addr add "${gip_v4}/24" dev veth10
+	ip netns exec "${ns1}" ip link set veth12 up
+	ip netns exec "${ns1}" ip addr add "${dip_v4}/24" dev veth12
+
+	ip netns exec "${ns2}" ip link set veth21 up
+	ip netns exec "${ns2}" ip addr add "${rip_v4}/24" dev veth21
+	ip netns exec "${ns2}" ip link set veth20 up
+	ip netns exec "${ns2}" ip addr add "${sip_v4}/24" dev veth20
 
 	sleep 1
 
@@ -100,10 +86,7 @@ setup() {
 }
 
 cleanup() {
-	for i in 0 1 2
-	do
-		ip netns del ns$i > /dev/null 2>&1
-	done
+	cleanup_all_ns
 
 	if [ -f "${outfile}" ]; then
 		rm "${outfile}"
@@ -114,13 +97,13 @@ cleanup() {
 }
 
 server_listen() {
-	ip netns exec ns2 nc -l -p 8080 > "${outfile}" &
+	ip netns exec "$ns2" socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT > "${outfile}" &
 	server_pid=$!
 	sleep 0.2
 }
 
 client_connect() {
-	ip netns exec ns0 timeout 2 nc -w 1 ${vip_v4} ${port} < "${infile}"
+	ip netns exec "${ns0}" timeout 2 socat -u -4 STDIN TCP:"${vip_v4}":"${port}" < "${infile}"
 }
 
 verify_data() {
@@ -136,58 +119,58 @@ test_service() {
 
 
 test_dr() {
-	ip netns exec ns0 ip route add ${vip_v4} via ${gip_v4} dev br0
+	ip netns exec "${ns0}" ip route add "${vip_v4}" via "${gip_v4}" dev br0
 
-	ip netns exec ns1 sysctl -qw net.ipv4.ip_forward=1
-	ip netns exec ns1 ipvsadm -A -t ${vip_v4}:${port} -s rr
-	ip netns exec ns1 ipvsadm -a -t ${vip_v4}:${port} -r ${rip_v4}:${port}
-	ip netns exec ns1 ip addr add ${vip_v4}/32 dev lo:1
+	ip netns exec "${ns1}" sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec "${ns1}" ipvsadm -A -t "${vip_v4}:${port}" -s rr
+	ip netns exec "${ns1}" ipvsadm -a -t "${vip_v4}:${port}" -r "${rip_v4}:${port}"
+	ip netns exec "${ns1}" ip addr add "${vip_v4}/32" dev lo:1
 
 	# avoid incorrect arp response
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_ignore=1
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_announce=2
+	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.all.arp_ignore=1
+	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.all.arp_announce=2
 	# avoid reverse route lookup
-	ip netns exec ns2 sysctl -qw  net.ipv4.conf.all.rp_filter=0
-	ip netns exec ns2 sysctl -qw  net.ipv4.conf.veth21.rp_filter=0
-	ip netns exec ns2 ip addr add ${vip_v4}/32 dev lo:1
+	ip netns exec "${ns2}" sysctl -qw  net.ipv4.conf.all.rp_filter=0
+	ip netns exec "${ns2}" sysctl -qw  net.ipv4.conf.veth21.rp_filter=0
+	ip netns exec "${ns2}" ip addr add "${vip_v4}/32" dev lo:1
 
 	test_service
 }
 
 test_nat() {
-	ip netns exec ns0 ip route add ${vip_v4} via ${gip_v4} dev br0
+	ip netns exec "${ns0}" ip route add "${vip_v4}" via "${gip_v4}" dev br0
 
-	ip netns exec ns1 sysctl -qw net.ipv4.ip_forward=1
-	ip netns exec ns1 ipvsadm -A -t ${vip_v4}:${port} -s rr
-	ip netns exec ns1 ipvsadm -a -m -t ${vip_v4}:${port} -r ${rip_v4}:${port}
-	ip netns exec ns1 ip addr add ${vip_v4}/32 dev lo:1
+	ip netns exec "${ns1}" sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec "${ns1}" ipvsadm -A -t "${vip_v4}:${port}" -s rr
+	ip netns exec "${ns1}" ipvsadm -a -m -t "${vip_v4}:${port}" -r "${rip_v4}:${port}"
+	ip netns exec "${ns1}" ip addr add "${vip_v4}/32" dev lo:1
 
-	ip netns exec ns2 ip link del veth20
-	ip netns exec ns2 ip route add default via ${dip_v4} dev veth21
+	ip netns exec "${ns2}" ip link del veth20
+	ip netns exec "${ns2}" ip route add default via "${dip_v4}" dev veth21
 
 	test_service
 }
 
 test_tun() {
-	ip netns exec ns0 ip route add ${vip_v4} via ${gip_v4} dev br0
-
-	ip netns exec ns1 modprobe ipip
-	ip netns exec ns1 ip link set tunl0 up
-	ip netns exec ns1 sysctl -qw net.ipv4.ip_forward=0
-	ip netns exec ns1 sysctl -qw net.ipv4.conf.all.send_redirects=0
-	ip netns exec ns1 sysctl -qw net.ipv4.conf.default.send_redirects=0
-	ip netns exec ns1 ipvsadm -A -t ${vip_v4}:${port} -s rr
-	ip netns exec ns1 ipvsadm -a -i -t ${vip_v4}:${port} -r ${rip_v4}:${port}
-	ip netns exec ns1 ip addr add ${vip_v4}/32 dev lo:1
-
-	ip netns exec ns2 modprobe ipip
-	ip netns exec ns2 ip link set tunl0 up
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_ignore=1
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_announce=2
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.rp_filter=0
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.tunl0.rp_filter=0
-	ip netns exec ns2 sysctl -qw net.ipv4.conf.veth21.rp_filter=0
-	ip netns exec ns2 ip addr add ${vip_v4}/32 dev lo:1
+	ip netns exec "${ns0}" ip route add "${vip_v4}" via "${gip_v4}" dev br0
+
+	ip netns exec "${ns1}" modprobe -q ipip
+	ip netns exec "${ns1}" ip link set tunl0 up
+	ip netns exec "${ns1}" sysctl -qw net.ipv4.ip_forward=0
+	ip netns exec "${ns1}" sysctl -qw net.ipv4.conf.all.send_redirects=0
+	ip netns exec "${ns1}" sysctl -qw net.ipv4.conf.default.send_redirects=0
+	ip netns exec "${ns1}" ipvsadm -A -t "${vip_v4}:${port}" -s rr
+	ip netns exec "${ns1}" ipvsadm -a -i -t "${vip_v4}:${port}" -r ${rip_v4}:${port}
+	ip netns exec "${ns1}" ip addr add ${vip_v4}/32 dev lo:1
+
+	ip netns exec "${ns2}" modprobe -q ipip
+	ip netns exec "${ns2}" ip link set tunl0 up
+	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.all.arp_ignore=1
+	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.all.arp_announce=2
+	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.all.rp_filter=0
+	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.tunl0.rp_filter=0
+	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.veth21.rp_filter=0
+	ip netns exec "${ns2}" ip addr add "${vip_v4}/32" dev lo:1
 
 	test_service
 }
-- 
2.43.2

