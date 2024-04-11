Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D35A46B83;
	Thu, 11 Apr 2024 23:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878959; cv=none; b=lk82bi9OliS8GxdiOCNUSFR83vJWOtd45nvZa/0NDxc+wCV0qzWPuV/IOp0he/X7iOkScRTQ6rgiqdPIEq8xf7ACuG66uWUOwPD//lXREjgHxwrPQrgG2V4MC5HNSWCgBYO/YUJPZv5ynrz6wUA2Q5WH1Q0LVzRsWhqhhKcREsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878959; c=relaxed/simple;
	bh=1s0HNkhLeVxCZiGBKaDLO7xYuNfZY9L7rWej9yRrU2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg3lkHVo0+fEZhFMkhAHntwODgkpWZ6QWHlkUdXde+DChnnWxFQ40rvQH3Vgr0AvIAqCCB4RlfPr+NBv+H+c4FXRl1qtPvkks2RYvZHjDz6hnWEfPBAmpHilwdPEvIVh7kcP3DKixC6ynma6TU7ifTxrKQiCnmUU3XGJiEmFv34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv43v-0000uE-SZ; Fri, 12 Apr 2024 01:42:35 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 04/15] selftests: netfilter: conntrack_icmp_related.sh: move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:09 +0200
Message-ID: <20240411233624.8129-5-fw@strlen.de>
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

Only relevant change is that netns names have random suffix names,
i.e. its safe to run this in parallel with other tests.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/conntrack_icmp_related.sh   | 179 +++++++-----------
 1 file changed, 71 insertions(+), 108 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh b/tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh
index 76645aaf2b58..c63d840ead61 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh
@@ -14,35 +14,32 @@
 # check the icmp errors are propagated to the correct host as per
 # nat of "established" icmp-echo "connection".
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-ret=0
+source lib.sh
 
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
 cleanup() {
-	for i in 1 2;do ip netns del nsclient$i;done
-	for i in 1 2;do ip netns del nsrouter$i;done
+	cleanup_all_ns
 }
 
 trap cleanup EXIT
 
-ipv4() {
-    echo -n 192.168.$1.2
-}
+setup_ns nsclient1 nsclient2 nsrouter1 nsrouter2
+
+ret=0
+
+add_addr()
+{
+	ns=$1
+	dev=$2
+	i=$3
 
-ipv6 () {
-    echo -n dead:$1::2
+	ip -net "$ns" link set "$dev" up
+	ip -net "$ns" addr add "192.168.$i.2/24" dev "$dev"
+	ip -net "$ns" addr add "dead:$i::2/64" dev "$dev" nodad
 }
 
 check_counter()
@@ -52,10 +49,9 @@ check_counter()
 	expect=$3
 	local lret=0
 
-	cnt=$(ip netns exec $ns nft list counter inet filter "$name" | grep -q "$expect")
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns" nft list counter inet filter "$name" | grep -q "$expect"; then
 		echo "ERROR: counter $name in $ns has unexpected value (expected $expect)" 1>&2
-		ip netns exec $ns nft list counter inet filter "$name" 1>&2
+		ip netns exec "$ns" nft list counter inet filter "$name" 1>&2
 		lret=1
 	fi
 
@@ -65,9 +61,8 @@ check_counter()
 check_unknown()
 {
 	expect="packets 0 bytes 0"
-	for n in nsclient1 nsclient2 nsrouter1 nsrouter2; do
-		check_counter $n "unknown" "$expect"
-		if [ $? -ne 0 ] ;then
+	for n in ${nsclient1} ${nsclient2} ${nsrouter1} ${nsrouter2}; do
+		if ! check_counter "$n" "unknown" "$expect"; then
 			return 1
 		fi
 	done
@@ -75,61 +70,48 @@ check_unknown()
 	return 0
 }
 
-for n in nsclient1 nsclient2 nsrouter1 nsrouter2; do
-  ip netns add $n
-  ip -net $n link set lo up
-done
-
-DEV=veth0
-ip link add $DEV netns nsclient1 type veth peer name eth1 netns nsrouter1
 DEV=veth0
-ip link add $DEV netns nsclient2 type veth peer name eth1 netns nsrouter2
+ip link add "$DEV" netns "$nsclient1" type veth peer name eth1 netns "$nsrouter1"
+ip link add "$DEV" netns "$nsclient2" type veth peer name eth1 netns "$nsrouter2"
+ip link add "$DEV" netns "$nsrouter1" type veth peer name eth2 netns "$nsrouter2"
 
-DEV=veth0
-ip link add $DEV netns nsrouter1 type veth peer name eth2 netns nsrouter2
+add_addr "$nsclient1" $DEV 1
+add_addr "$nsclient2" $DEV 2
 
-DEV=veth0
-for i in 1 2; do
-    ip -net nsclient$i link set $DEV up
-    ip -net nsclient$i addr add $(ipv4 $i)/24 dev $DEV
-    ip -net nsclient$i addr add $(ipv6 $i)/64 dev $DEV
-done
-
-ip -net nsrouter1 link set eth1 up
-ip -net nsrouter1 link set veth0 up
+ip -net "$nsrouter1" link set eth1 up
+ip -net "$nsrouter1" link set $DEV up
 
-ip -net nsrouter2 link set eth1 up
-ip -net nsrouter2 link set eth2 up
+ip -net "$nsrouter2" link set eth1 mtu 1280 up
+ip -net "$nsrouter2" link set eth2 up
 
-ip -net nsclient1 route add default via 192.168.1.1
-ip -net nsclient1 -6 route add default via dead:1::1
+ip -net "$nsclient1" route add default via 192.168.1.1
+ip -net "$nsclient1" -6 route add default via dead:1::1
 
-ip -net nsclient2 route add default via 192.168.2.1
-ip -net nsclient2 route add default via dead:2::1
+ip -net "$nsclient2" route add default via 192.168.2.1
+ip -net "$nsclient2" route add default via dead:2::1
+ip -net "$nsclient2" link set veth0 mtu 1280
 
-i=3
-ip -net nsrouter1 addr add 192.168.1.1/24 dev eth1
-ip -net nsrouter1 addr add 192.168.3.1/24 dev veth0
-ip -net nsrouter1 addr add dead:1::1/64 dev eth1
-ip -net nsrouter1 addr add dead:3::1/64 dev veth0
-ip -net nsrouter1 route add default via 192.168.3.10
-ip -net nsrouter1 -6 route add default via dead:3::10
+ip -net "$nsrouter1" addr add 192.168.1.1/24 dev eth1
+ip -net "$nsrouter1" addr add 192.168.3.1/24 dev veth0
+ip -net "$nsrouter1" addr add dead:1::1/64 dev eth1 nodad
+ip -net "$nsrouter1" addr add dead:3::1/64 dev veth0 nodad
+ip -net "$nsrouter1" route add default via 192.168.3.10
+ip -net "$nsrouter1" -6 route add default via dead:3::10
 
-ip -net nsrouter2 addr add 192.168.2.1/24 dev eth1
-ip -net nsrouter2 addr add 192.168.3.10/24 dev eth2
-ip -net nsrouter2 addr add dead:2::1/64 dev eth1
-ip -net nsrouter2 addr add dead:3::10/64 dev eth2
-ip -net nsrouter2 route add default via 192.168.3.1
-ip -net nsrouter2 route add default via dead:3::1
+ip -net "$nsrouter2" addr add 192.168.2.1/24 dev eth1
+ip -net "$nsrouter2" addr add 192.168.3.10/24 dev eth2
+ip -net "$nsrouter2" addr add dead:2::1/64  dev eth1 nodad
+ip -net "$nsrouter2" addr add dead:3::10/64 dev eth2 nodad
+ip -net "$nsrouter2" route add default via 192.168.3.1
+ip -net "$nsrouter2" route add default via dead:3::1
 
-sleep 2
 for i in 4 6; do
-	ip netns exec nsrouter1 sysctl -q net.ipv$i.conf.all.forwarding=1
-	ip netns exec nsrouter2 sysctl -q net.ipv$i.conf.all.forwarding=1
+	ip netns exec "$nsrouter1" sysctl -q net.ipv$i.conf.all.forwarding=1
+	ip netns exec "$nsrouter2" sysctl -q net.ipv$i.conf.all.forwarding=1
 done
 
-for netns in nsrouter1 nsrouter2; do
-ip netns exec $netns nft -f - <<EOF
+for netns in "$nsrouter1" "$nsrouter2"; do
+ip netns exec "$netns" nft -f - <<EOF
 table inet filter {
 	counter unknown { }
 	counter related { }
@@ -144,7 +126,7 @@ table inet filter {
 EOF
 done
 
-ip netns exec nsclient1 nft -f - <<EOF
+ip netns exec "$nsclient1" nft -f - <<EOF
 table inet filter {
 	counter unknown { }
 	counter related { }
@@ -164,7 +146,7 @@ table inet filter {
 }
 EOF
 
-ip netns exec nsclient2 nft -f - <<EOF
+ip netns exec "$nsclient2" nft -f - <<EOF
 table inet filter {
 	counter unknown { }
 	counter new { }
@@ -189,11 +171,10 @@ table inet filter {
 }
 EOF
 
-
 # make sure NAT core rewrites adress of icmp error if nat is used according to
 # conntrack nat information (icmp error will be directed at nsrouter1 address,
 # but it needs to be routed to nsclient1 address).
-ip netns exec nsrouter1 nft -f - <<EOF
+ip netns exec "$nsrouter1" nft -f - <<EOF
 table ip nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
@@ -208,44 +189,32 @@ table ip6 nat {
 }
 EOF
 
-ip netns exec nsrouter2 ip link set eth1  mtu 1280
-ip netns exec nsclient2 ip link set veth0 mtu 1280
-sleep 1
-
-ip netns exec nsclient1 ping -c 1 -s 1000 -q -M do 192.168.2.2 >/dev/null
-if [ $? -ne 0 ]; then
+if ! ip netns exec "$nsclient1" ping -c 1 -s 1000 -q -M "do" 192.168.2.2 >/dev/null; then
 	echo "ERROR: netns ip routing/connectivity broken" 1>&2
-	cleanup
 	exit 1
 fi
-ip netns exec nsclient1 ping6 -q -c 1 -s 1000 dead:2::2 >/dev/null
-if [ $? -ne 0 ]; then
+if ! ip netns exec "$nsclient1" ping -c 1 -s 1000 -q dead:2::2 >/dev/null; then
 	echo "ERROR: netns ipv6 routing/connectivity broken" 1>&2
-	cleanup
 	exit 1
 fi
 
-check_unknown
-if [ $? -ne 0 ]; then
+if ! check_unknown; then
 	ret=1
 fi
 
 expect="packets 0 bytes 0"
-for netns in nsrouter1 nsrouter2 nsclient1;do
-	check_counter "$netns" "related" "$expect"
-	if [ $? -ne 0 ]; then
+for netns in "$nsrouter1" "$nsrouter2" "$nsclient1";do
+	if ! check_counter "$netns" "related" "$expect"; then
 		ret=1
 	fi
 done
 
 expect="packets 2 bytes 2076"
-check_counter nsclient2 "new" "$expect"
-if [ $? -ne 0 ]; then
+if ! check_counter "$nsclient2" "new" "$expect"; then
 	ret=1
 fi
 
-ip netns exec nsclient1 ping -q -c 1 -s 1300 -M do 192.168.2.2 > /dev/null
-if [ $? -eq 0 ]; then
+if ip netns exec "$nsclient1" ping -W 0.5 -q -c 1 -s 1300 -M "do" 192.168.2.2 > /dev/null; then
 	echo "ERROR: ping should have failed with PMTU too big error" 1>&2
 	ret=1
 fi
@@ -253,30 +222,26 @@ fi
 # nsrouter2 should have generated the icmp error, so
 # related counter should be 0 (its in forward).
 expect="packets 0 bytes 0"
-check_counter "nsrouter2" "related" "$expect"
-if [ $? -ne 0 ]; then
+if ! check_counter "$nsrouter2" "related" "$expect"; then
 	ret=1
 fi
 
 # but nsrouter1 should have seen it, same for nsclient1.
 expect="packets 1 bytes 576"
-for netns in nsrouter1 nsclient1;do
-	check_counter "$netns" "related" "$expect"
-	if [ $? -ne 0 ]; then
+for netns in ${nsrouter1} ${nsclient1};do
+	if ! check_counter "$netns" "related" "$expect"; then
 		ret=1
 	fi
 done
 
-ip netns exec nsclient1 ping6 -c 1 -s 1300 dead:2::2 > /dev/null
-if [ $? -eq 0 ]; then
+if ip netns exec "${nsclient1}" ping6 -W 0.5 -c 1 -s 1300 dead:2::2 > /dev/null; then
 	echo "ERROR: ping6 should have failed with PMTU too big error" 1>&2
 	ret=1
 fi
 
 expect="packets 2 bytes 1856"
-for netns in nsrouter1 nsclient1;do
-	check_counter "$netns" "related" "$expect"
-	if [ $? -ne 0 ]; then
+for netns in "${nsrouter1}" "${nsclient1}";do
+	if ! check_counter "$netns" "related" "$expect"; then
 		ret=1
 	fi
 done
@@ -288,21 +253,19 @@ else
 fi
 
 # add 'bad' route,  expect icmp REDIRECT to be generated
-ip netns exec nsclient1 ip route add 192.168.1.42 via 192.168.1.1
-ip netns exec nsclient1 ip route add dead:1::42 via dead:1::1
+ip netns exec "${nsclient1}" ip route add 192.168.1.42 via 192.168.1.1
+ip netns exec "${nsclient1}" ip route add dead:1::42 via dead:1::1
 
-ip netns exec "nsclient1" ping -q -c 2 192.168.1.42 > /dev/null
+ip netns exec "$nsclient1" ping -W 1 -q -i 0.5 -c 2 192.168.1.42 > /dev/null
 
 expect="packets 1 bytes 112"
-check_counter nsclient1 "redir4" "$expect"
-if [ $? -ne 0 ];then
+if ! check_counter "$nsclient1" "redir4" "$expect"; then
 	ret=1
 fi
 
-ip netns exec "nsclient1" ping -c 1 dead:1::42 > /dev/null
+ip netns exec "$nsclient1" ping -W 1 -c 1 dead:1::42 > /dev/null
 expect="packets 1 bytes 192"
-check_counter nsclient1 "redir6" "$expect"
-if [ $? -ne 0 ];then
+if ! check_counter "$nsclient1" "redir6" "$expect"; then
 	ret=1
 fi
 
-- 
2.43.2

