Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C454AEC7;
	Thu, 11 Apr 2024 23:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878999; cv=none; b=k+UHt49IIi85cBE4YZtvN61fFFlSCZRqFKAfAAB+BxnBlxE0EszxhTRfWly7PDe8h8YIAorPaMvVNaICXfGtRDFPP8PGiyBUZ8JK+VcGtxTsWvM9zgKPziv714RdbfmXzNOrmj961BKIuKcFGwaHUw08M+FS3tK84zF+HzfdeZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878999; c=relaxed/simple;
	bh=gukgdCqU26eXYcdZvldAEj4TCb02Do9XdMZPHPv0E9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIOucSqx19myNm3P/1BtvB8QLEwct2g8m+KZOjPzaC36uBO4fjGJ28SD2NCDMg7WNowV2XATFR/r1npsatXwAbXKoo29LcQtMFIIT9nedfEE25SomdIxk0d+77LrDWCQcbYSKn9hFtCxjB6VWO/+LxmFBcPHMkgp6IBUqeRoohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv44a-0000yj-OA; Fri, 12 Apr 2024 01:43:16 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 14/15] selftests: netfilter: nft_flowtable.sh: move test to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:19 +0200
Message-ID: <20240411233624.8129-15-fw@strlen.de>
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

Use socat, the different nc implementations have too much variance wrt.
supported options.

Avoid sleeping until listener is up, use busywait helper for this,
this also greatly reduces test duration.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 108 ++++++------------
 1 file changed, 36 insertions(+), 72 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index a32f490f7539..d765c65c31f3 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -14,14 +14,8 @@
 # nft_flowtable.sh -o8000 -l1500 -r2000
 #
 
-sfx=$(mktemp -u "XXXXXXXX")
-ns1="ns1-$sfx"
-ns2="ns2-$sfx"
-nsr1="nsr1-$sfx"
-nsr2="nsr2-$sfx"
-
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+source lib.sh
+
 ret=0
 
 nsin=""
@@ -30,27 +24,16 @@ ns2out=""
 
 log_netns=$(sysctl -n net.netfilter.nf_log_all_netns)
 
-checktool (){
-	if ! $1 > /dev/null 2>&1; then
-		echo "SKIP: Could not $2"
-		exit $ksft_skip
-	fi
-}
-
 checktool "nft --version" "run test without nft tool"
-checktool "ip -Version" "run test without ip tool"
-checktool "which nc" "run test without nc (netcat)"
-checktool "ip netns add $nsr1" "create net namespace $nsr1"
+checktool "socat -h" "run test without socat"
 
-ip netns add $ns1
-ip netns add $ns2
-ip netns add $nsr2
+setup_ns ns1 ns2 nsr1 nsr2
 
 cleanup() {
-	ip netns del $ns1
-	ip netns del $ns2
-	ip netns del $nsr1
-	ip netns del $nsr2
+	ip netns pids "$ns1" | xargs kill 2>/dev/null
+	ip netns pids "$ns2" | xargs kill 2>/dev/null
+
+	cleanup_all_ns
 
 	rm -f "$nsin" "$ns1out" "$ns2out"
 
@@ -66,16 +49,16 @@ ip link add veth1 netns $nsr1 type veth peer name veth0 netns $nsr2
 
 ip link add veth1 netns $nsr2 type veth peer name eth0 netns $ns2
 
-for dev in lo veth0 veth1; do
-    ip -net $nsr1 link set $dev up
-    ip -net $nsr2 link set $dev up
+for dev in veth0 veth1; do
+    ip -net "$nsr1" link set "$dev" up
+    ip -net "$nsr2" link set "$dev" up
 done
 
-ip -net $nsr1 addr add 10.0.1.1/24 dev veth0
-ip -net $nsr1 addr add dead:1::1/64 dev veth0
+ip -net "$nsr1" addr add 10.0.1.1/24 dev veth0
+ip -net "$nsr1" addr add dead:1::1/64 dev veth0 nodad
 
-ip -net $nsr2 addr add 10.0.2.1/24 dev veth1
-ip -net $nsr2 addr add dead:2::1/64 dev veth1
+ip -net "$nsr2" addr add 10.0.2.1/24 dev veth1
+ip -net "$nsr2" addr add dead:2::1/64 dev veth1 nodad
 
 # set different MTUs so we need to push packets coming from ns1 (large MTU)
 # to ns2 (smaller MTU) to stack either to perform fragmentation (ip_no_pmtu_disc=1),
@@ -121,11 +104,11 @@ ip -net $ns2 link set eth0 mtu $rmtu
 
 # transfer-net between nsr1 and nsr2.
 # these addresses are not used for connections.
-ip -net $nsr1 addr add 192.168.10.1/24 dev veth1
-ip -net $nsr1 addr add fee1:2::1/64 dev veth1
+ip -net "$nsr1" addr add 192.168.10.1/24 dev veth1
+ip -net "$nsr1" addr add fee1:2::1/64 dev veth1 nodad
 
-ip -net $nsr2 addr add 192.168.10.2/24 dev veth0
-ip -net $nsr2 addr add fee1:2::2/64 dev veth0
+ip -net "$nsr2" addr add 192.168.10.2/24 dev veth0
+ip -net "$nsr2" addr add fee1:2::2/64 dev veth0 nodad
 
 for i in 0 1; do
   ip netns exec $nsr1 sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
@@ -148,8 +131,8 @@ ip -net $ns1 addr add 10.0.1.99/24 dev eth0
 ip -net $ns2 addr add 10.0.2.99/24 dev eth0
 ip -net $ns1 route add default via 10.0.1.1
 ip -net $ns2 route add default via 10.0.2.1
-ip -net $ns1 addr add dead:1::99/64 dev eth0
-ip -net $ns2 addr add dead:2::99/64 dev eth0
+ip -net $ns1 addr add dead:1::99/64 dev eth0 nodad
+ip -net $ns2 addr add dead:2::99/64 dev eth0 nodad
 ip -net $ns1 route add default via dead:1::1
 ip -net $ns2 route add default via dead:2::1
 
@@ -219,10 +202,6 @@ if ! ip netns exec $ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
   exit 1
 fi
 
-if [ $ret -eq 0 ];then
-	echo "PASS: netns routing/connectivity: $ns1 can reach $ns2"
-fi
-
 nsin=$(mktemp)
 ns1out=$(mktemp)
 ns2out=$(mktemp)
@@ -345,6 +324,11 @@ check_transfer()
 	return 0
 }
 
+listener_ready()
+{
+	ss -N "$nsb" -lnt -o "sport = :12345" | grep -q 12345
+}
+
 test_tcp_forwarding_ip()
 {
 	local nsa=$1
@@ -353,33 +337,14 @@ test_tcp_forwarding_ip()
 	local dstport=$4
 	local lret=0
 
-	ip netns exec $nsb nc -w 5 -l -p 12345 < "$nsin" > "$ns2out" &
+	timeout 10 ip netns exec "$nsb" socat -4 TCP-LISTEN:12345,reuseaddr STDIO < "$nsin" > "$ns2out" &
 	lpid=$!
 
-	sleep 1
-	ip netns exec $nsa nc -w 4 "$dstip" "$dstport" < "$nsin" > "$ns1out" &
-	cpid=$!
-
-	sleep 1
-
-	prev="$(ls -l $ns1out $ns2out)"
-	sleep 1
+	busywait 1000 listener_ready
 
-	while [[ "$prev" != "$(ls -l $ns1out $ns2out)" ]]; do
-		sleep 1;
-		prev="$(ls -l $ns1out $ns2out)"
-	done
-
-	if test -d /proc/"$lpid"/; then
-		kill $lpid
-	fi
-
-	if test -d /proc/"$cpid"/; then
-		kill $cpid
-	fi
+	timeout 10 ip netns exec "$nsa" socat -4 TCP:"$dstip":"$dstport" STDIO < "$nsin" > "$ns1out"
 
 	wait $lpid
-	wait $cpid
 
 	if ! check_transfer "$nsin" "$ns2out" "ns1 -> ns2"; then
 		lret=1
@@ -550,7 +515,7 @@ ip -net $nsr1 addr flush dev veth0
 ip -net $nsr1 link set up dev veth0
 ip -net $nsr1 link set veth0 master br0
 ip -net $nsr1 addr add 10.0.1.1/24 dev br0
-ip -net $nsr1 addr add dead:1::1/64 dev br0
+ip -net $nsr1 addr add dead:1::1/64 dev br0 nodad
 ip -net $nsr1 link set up dev br0
 
 ip netns exec $nsr1 sysctl net.ipv4.conf.br0.forwarding=1 > /dev/null
@@ -593,7 +558,7 @@ ip -net $ns1 link set eth0 up
 ip -net $ns1 link set eth0.10 up
 ip -net $ns1 addr add 10.0.1.99/24 dev eth0.10
 ip -net $ns1 route add default via 10.0.1.1
-ip -net $ns1 addr add dead:1::99/64 dev eth0.10
+ip -net $ns1 addr add dead:1::99/64 dev eth0.10 nodad
 
 if ! test_tcp_forwarding_nat $ns1 $ns2 1 "bridge and VLAN"; then
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT and VLAN" 1>&2
@@ -616,10 +581,10 @@ ip -net $ns1 link delete eth0.10 type vlan
 ip -net $ns1 link set eth0 up
 ip -net $ns1 addr add 10.0.1.99/24 dev eth0
 ip -net $ns1 route add default via 10.0.1.1
-ip -net $ns1 addr add dead:1::99/64 dev eth0
+ip -net $ns1 addr add dead:1::99/64 dev eth0 nodad
 ip -net $ns1 route add default via dead:1::1
 ip -net $nsr1 addr add 10.0.1.1/24 dev veth0
-ip -net $nsr1 addr add dead:1::1/64 dev veth0
+ip -net $nsr1 addr add dead:1::1/64 dev veth0 nodad
 ip -net $nsr1 link set up dev veth0
 
 KEY_SHA="0x"$(ps -af | sha1sum | cut -d " " -f 1)
@@ -647,7 +612,6 @@ do_esp() {
     ip -net $ns xfrm policy add src $lnet dst $rnet dir out tmpl src $me dst $remote proto esp mode tunnel priority 1 action allow
     # to fwd decrypted packets after esp processing:
     ip -net $ns xfrm policy add src $rnet dst $lnet dir fwd tmpl src $remote dst $me proto esp mode tunnel priority 1 action allow
-
 }
 
 do_esp $nsr1 192.168.10.1 192.168.10.2 10.0.1.0/24 10.0.2.0/24 $SPI1 $SPI2
@@ -661,12 +625,12 @@ ip -net $ns2 route del 192.168.10.1 via 10.0.2.1
 ip -net $ns2 route add default via 10.0.2.1
 ip -net $ns2 route add default via dead:2::1
 
-if test_tcp_forwarding $ns1 $ns2; then
+if test_tcp_forwarding "$ns1" "$ns2"; then
 	check_counters "ipsec tunnel mode for ns1/ns2"
 else
 	echo "FAIL: ipsec tunnel mode for ns1/ns2"
-	ip netns exec $nsr1 nft list ruleset 1>&2
-	ip netns exec $nsr1 cat /proc/net/xfrm_stat 1>&2
+	ip netns exec "$nsr1" nft list ruleset 1>&2
+	ip netns exec "$nsr1" cat /proc/net/xfrm_stat 1>&2
 fi
 
 exit $ret
-- 
2.43.2

