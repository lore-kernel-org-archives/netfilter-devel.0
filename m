Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1C247F58;
	Thu, 11 Apr 2024 23:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878971; cv=none; b=BLM4cq+t+0BodpolEvPI8JYqzh2Abm0jlzVCnXtuoklFR1vKbtQsW7SyDXhriOrwqGocIWnL7Qe3EHfO5jtWsCK6qfWsyBg02QLFy7zTK/PcMswt1k6oyAZ2rqcFfv2rYPDUAb/C+O1e8lZ4rGvMGp1QvD0Zpsqqc/ooMmcMI9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878971; c=relaxed/simple;
	bh=uREVuv0j7lxNVKOebzeCfKFuRGQ2SCDtaVNHIakP7x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6dHO01txucFM9yFvDBxWErHLfog3nrrW+d3wFsorh+oqNCQ0POKsE0zzxMYzmb59JW0I2aEGWTg07GYbmrEWPQtNKZ42pIWIPd4okE6Thq61Y+Aj4KeIboBF6FB9em2i8ao7UGdKziXYVNW/GDXEvJA3EQsXll4x2hMxBMdMQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv448-0000vc-3w; Fri, 12 Apr 2024 01:42:48 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 07/15] selftests: netfilter: conntrack_vrf.sh: move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:12 +0200
Message-ID: <20240411233624.8129-8-fw@strlen.de>
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

swap test for "ip" with "conntrack", former is already accounted for
via setup_ns helper.  Also switch to bash.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/conntrack_vrf.sh  | 101 +++++++-----------
 1 file changed, 39 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
index 8b5ea9234588..f7417004ec71 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 # This script demonstrates interaction of conntrack and vrf.
 # The vrf driver calls the netfilter hooks again, with oif/iif
@@ -28,84 +28,65 @@
 # that was supposed to be fixed by the commit mentioned above to make sure
 # that any fix to test case 1 won't break masquerade again.
 
-ksft_skip=4
+source lib.sh
 
 IP0=172.30.30.1
 IP1=172.30.30.2
 PFXL=30
 ret=0
 
-sfx=$(mktemp -u "XXXXXXXX")
-ns0="ns0-$sfx"
-ns1="ns1-$sfx"
-
 cleanup()
 {
 	ip netns pids $ns0 | xargs kill 2>/dev/null
 	ip netns pids $ns1 | xargs kill 2>/dev/null
 
-	ip netns del $ns0 $ns1
+	cleanup_all_ns
 }
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
+if ! nft --version > /dev/null 2>&1;then
 	echo "SKIP: Could not run test without nft tool"
 	exit $ksft_skip
 fi
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-ip netns add "$ns0"
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace $ns0"
+if ! conntrack --version > /dev/null 2>&1;then
+	echo "SKIP: Could not run test without conntrack tool"
 	exit $ksft_skip
 fi
-ip netns add "$ns1"
 
 trap cleanup EXIT
 
-ip netns exec $ns0 sysctl -q -w net.ipv4.conf.default.rp_filter=0
-ip netns exec $ns0 sysctl -q -w net.ipv4.conf.all.rp_filter=0
-ip netns exec $ns0 sysctl -q -w net.ipv4.conf.all.rp_filter=0
+setup_ns ns0 ns1
 
-ip link add veth0 netns "$ns0" type veth peer name veth0 netns "$ns1" > /dev/null 2>&1
-if [ $? -ne 0 ];then
+ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.default.rp_filter=0
+ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.all.rp_filter=0
+ip netns exec "$ns0" sysctl -q -w net.ipv4.conf.all.rp_filter=0
+
+if ! ip link add veth0 netns "$ns0" type veth peer name veth0 netns "$ns1" > /dev/null 2>&1; then
 	echo "SKIP: Could not add veth device"
 	exit $ksft_skip
 fi
 
-ip -net $ns0 li add tvrf type vrf table 9876
-if [ $? -ne 0 ];then
+if ! ip -net "$ns0" li add tvrf type vrf table 9876; then
 	echo "SKIP: Could not add vrf device"
 	exit $ksft_skip
 fi
 
-ip -net $ns0 li set lo up
-
-ip -net $ns0 li set veth0 master tvrf
-ip -net $ns0 li set tvrf up
-ip -net $ns0 li set veth0 up
-ip -net $ns1 li set veth0 up
+ip -net "$ns0" li set veth0 master tvrf
+ip -net "$ns0" li set tvrf up
+ip -net "$ns0" li set veth0 up
+ip -net "$ns1" li set veth0 up
 
-ip -net $ns0 addr add $IP0/$PFXL dev veth0
-ip -net $ns1 addr add $IP1/$PFXL dev veth0
+ip -net "$ns0" addr add $IP0/$PFXL dev veth0
+ip -net "$ns1" addr add $IP1/$PFXL dev veth0
 
-ip netns exec $ns1 iperf3 -s > /dev/null 2>&1&
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not start iperf3"
-	exit $ksft_skip
-fi
+ip netns exec "$ns1" iperf3 -s > /dev/null 2>&1 &
 
 # test vrf ingress handling.
 # The incoming connection should be placed in conntrack zone 1,
 # as decided by the first iteration of the ruleset.
 test_ct_zone_in()
 {
-ip netns exec $ns0 nft -f - <<EOF
+ip netns exec "$ns0" nft -f - <<EOF
 table testct {
 	chain rawpre {
 		type filter hook prerouting priority raw;
@@ -126,21 +107,21 @@ table testct {
 	}
 }
 EOF
-	ip netns exec $ns1 ping -W 1 -c 1 -I veth0 $IP0 > /dev/null
+	ip netns exec "$ns1" ping -W 1 -c 1 -I veth0 "$IP0" > /dev/null
 
 	# should be in zone 1, not zone 2
-	count=$(ip netns exec $ns0 conntrack -L -s $IP1 -d $IP0 -p icmp --zone 1 2>/dev/null | wc -l)
-	if [ $count -eq 1 ]; then
+	count=$(ip netns exec "$ns0" conntrack -L -s $IP1 -d $IP0 -p icmp --zone 1 2>/dev/null | wc -l)
+	if [ "$count" -eq 1 ]; then
 		echo "PASS: entry found in conntrack zone 1"
 	else
 		echo "FAIL: entry not found in conntrack zone 1"
-		count=$(ip netns exec $ns0 conntrack -L -s $IP1 -d $IP0 -p icmp --zone 2 2> /dev/null | wc -l)
-		if [ $count -eq 1 ]; then
+		count=$(ip netns exec "$ns0" conntrack -L -s $IP1 -d $IP0 -p icmp --zone 2 2> /dev/null | wc -l)
+		if [ "$count" -eq 1 ]; then
 			echo "FAIL: entry found in zone 2 instead"
 		else
 			echo "FAIL: entry not in zone 1 or 2, dumping table"
-			ip netns exec $ns0 conntrack -L
-			ip netns exec $ns0 nft list ruleset
+			ip netns exec "$ns0" conntrack -L
+			ip netns exec "$ns0" nft list ruleset
 		fi
 	fi
 }
@@ -153,12 +134,12 @@ test_masquerade_vrf()
 	local qdisc=$1
 
 	if [ "$qdisc" != "default" ]; then
-		tc -net $ns0 qdisc add dev tvrf root $qdisc
+		tc -net "$ns0" qdisc add dev tvrf root "$qdisc"
 	fi
 
-	ip netns exec $ns0 conntrack -F 2>/dev/null
+	ip netns exec "$ns0" conntrack -F 2>/dev/null
 
-ip netns exec $ns0 nft -f - <<EOF
+ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain rawout {
@@ -179,17 +160,15 @@ table ip nat {
 	}
 }
 EOF
-	ip netns exec $ns0 ip vrf exec tvrf iperf3 -t 1 -c $IP1 >/dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" ip vrf exec tvrf iperf3 -t 1 -c $IP1 >/dev/null; then
 		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on vrf device"
 		ret=1
 		return
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2' &&
-	ip netns exec $ns0 nft list table ip nat |grep -q 'untracked counter packets [1-9]'
-	if [ $? -eq 0 ]; then
+	ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 2' &&
+	if ip netns exec "$ns0" nft list table ip nat |grep -q 'untracked counter packets [1-9]'; then
 		echo "PASS: iperf3 connect with masquerade + sport rewrite on vrf device ($qdisc qdisc)"
 	else
 		echo "FAIL: vrf rules have unexpected counter value"
@@ -197,7 +176,7 @@ EOF
 	fi
 
 	if [ "$qdisc" != "default" ]; then
-		tc -net $ns0 qdisc del dev tvrf root
+		tc -net "$ns0" qdisc del dev tvrf root
 	fi
 }
 
@@ -206,8 +185,8 @@ EOF
 # oifname is the lower device (veth0 in this case).
 test_masquerade_veth()
 {
-	ip netns exec $ns0 conntrack -F 2>/dev/null
-ip netns exec $ns0 nft -f - <<EOF
+	ip netns exec "$ns0" conntrack -F 2>/dev/null
+ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain postrouting {
@@ -216,16 +195,14 @@ table ip nat {
 	}
 }
 EOF
-	ip netns exec $ns0 ip vrf exec tvrf iperf3 -t 1 -c $IP1 > /dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" ip vrf exec tvrf iperf3 -t 1 -c $IP1 > /dev/null; then
 		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on veth device"
 		ret=1
 		return
 	fi
 
 	# must also check that nat table was evaluated on second (lower device) iteration.
-	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2'
-	if [ $? -eq 0 ]; then
+	if ip netns exec "$ns0" nft list table ip nat |grep -q 'counter packets 2'; then
 		echo "PASS: iperf3 connect with masquerade + sport rewrite on veth device"
 	else
 		echo "FAIL: vrf masq rule has unexpected counter value"
-- 
2.43.2

