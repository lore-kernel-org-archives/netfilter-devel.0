Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5752168B06;
	Thu, 18 Apr 2024 15:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454235; cv=none; b=E1cTXvsuMxi/QQsiIkT0mtdwdEbYxJjXRn0Rwa1KWhxzTmwlnB/80/lj/BAsjVFYvuzfEVjD5adDBq2feTDOsxHU/yZbzvRRpItVQmEySoePd2Pm/rLFsZY8Mu29LHQDSOlniL30zBw6pW+4nCI0djRP5RBH195sS8x3lVm4XE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454235; c=relaxed/simple;
	bh=UIBG++aMXdWyyIukRkVB0NgtM+pw22owy8C5ip8p+oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDxV71klcTSGCxPW3xeMrluqUisaDikae4XxpT3KOKwDVLg5xxpqoUcnZnyu+dBn4wPznSoPZsXA2y8SHegiLy5T94iyMjEPH5Xn+WFHA1tDJGR+lS5bSSu2KBTw/KrhA3bNkXOde9XGvsKJ/CmnXhuQyP9+ma2QTvS4f1RpLqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxTiX-0000AK-OP; Thu, 18 Apr 2024 17:30:29 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next v2 09/12] selftests: netfilter: nft_fib.sh: shellcheck cleanups
Date: Thu, 18 Apr 2024 17:27:37 +0200
Message-ID: <20240418152744.15105-10-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240418152744.15105-1-fw@strlen.de>
References: <20240418152744.15105-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

no functional change intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_fib.sh        | 128 +++++++++---------
 1 file changed, 61 insertions(+), 67 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index 04d6dc886b8a..ce1451c275fd 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -16,7 +16,7 @@ cleanup()
 {
 	cleanup_all_ns
 
-	[ $log_netns -eq 0 ] && sysctl -q net.netfilter.nf_log_all_netns=$log_netns
+	[ "$log_netns" -eq 0 ] && sysctl -q net.netfilter.nf_log_all_netns=$log_netns
 }
 
 checktool "nft --version" "run test without nft"
@@ -25,8 +25,7 @@ setup_ns nsrouter ns1 ns2
 
 trap cleanup EXIT
 
-dmesg | grep -q ' nft_rpfilter: '
-if [ $? -eq 0 ]; then
+if dmesg | grep -q ' nft_rpfilter: ';then
 	dmesg -c | grep ' nft_rpfilter: '
 	echo "WARN: a previous test run has failed" 1>&2
 fi
@@ -36,7 +35,7 @@ sysctl -q net.netfilter.nf_log_all_netns=1
 load_ruleset() {
 	local netns=$1
 
-ip netns exec ${netns} nft -f /dev/stdin <<EOF
+ip netns exec "$netns" nft -f /dev/stdin <<EOF
 table inet filter {
 	chain prerouting {
 		type filter hook prerouting priority 0; policy accept;
@@ -49,7 +48,7 @@ EOF
 load_pbr_ruleset() {
 	local netns=$1
 
-ip netns exec ${netns} nft -f /dev/stdin <<EOF
+ip netns exec "$netns" nft -f /dev/stdin <<EOF
 table inet filter {
 	chain forward {
 		type filter hook forward priority raw;
@@ -63,7 +62,7 @@ EOF
 load_ruleset_count() {
 	local netns=$1
 
-ip netns exec ${netns} nft -f /dev/stdin <<EOF
+ip netns exec "$netns" nft -f /dev/stdin <<EOF
 table inet filter {
 	chain prerouting {
 		type filter hook prerouting priority 0; policy accept;
@@ -89,52 +88,49 @@ check_fib_counter() {
 	local ns=$2
 	local address=$3
 
-	line=$(ip netns exec ${ns} nft list table inet filter | grep 'fib saddr . iif' | grep $address | grep "packets $want" )
-	ret=$?
-
-	if [ $ret -ne 0 ];then
+	if ! ip netns exec "$ns" nft list table inet filter | grep 'fib saddr . iif' | grep "$address" | grep -q "packets $want";then
 		echo "Netns $ns fib counter doesn't match expected packet count of $want for $address" 1>&2
-		ip netns exec ${ns} nft list table inet filter
+		ip netns exec "$ns" nft list table inet filter
 		return 1
 	fi
 
-	if [ $want -gt 0 ]; then
+	if [ "$want" -gt 0 ]; then
 		echo "PASS: fib expression did drop packets for $address"
 	fi
 
 	return 0
 }
 
-load_ruleset ${nsrouter}
-load_ruleset ${ns1}
-load_ruleset ${ns2}
+load_ruleset "$nsrouter"
+load_ruleset "$ns1"
+load_ruleset "$ns2"
 
 if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1; then
     echo "SKIP: No virtual ethernet pair device support in kernel"
     exit $ksft_skip
 fi
-ip link add veth1 netns ${nsrouter} type veth peer name eth0 netns ${ns2}
+ip link add veth1 netns "$nsrouter" type veth peer name eth0 netns "$ns2"
 
-ip -net ${nsrouter} link set veth0 up
-ip -net ${nsrouter} addr add 10.0.1.1/24 dev veth0
-ip -net ${nsrouter} addr add dead:1::1/64 dev veth0 nodad
+ip -net "$nsrouter" link set veth0 up
+ip -net "$nsrouter" addr add 10.0.1.1/24 dev veth0
+ip -net "$nsrouter" addr add dead:1::1/64 dev veth0 nodad
 
-ip -net ${nsrouter} link set veth1 up
-ip -net ${nsrouter} addr add 10.0.2.1/24 dev veth1
-ip -net ${nsrouter} addr add dead:2::1/64 dev veth1 nodad
+ip -net "$nsrouter" link set veth1 up
+ip -net "$nsrouter" addr add 10.0.2.1/24 dev veth1
+ip -net "$nsrouter" addr add dead:2::1/64 dev veth1 nodad
 
-ip -net ${ns1} link set eth0 up
-ip -net ${ns2} link set eth0 up
+ip -net "$ns1" link set eth0 up
+ip -net "$ns2" link set eth0 up
 
-ip -net ${ns1} addr add 10.0.1.99/24 dev eth0
-ip -net ${ns1} addr add dead:1::99/64 dev eth0 nodad
-ip -net ${ns1} route add default via 10.0.1.1
-ip -net ${ns1} route add default via dead:1::1
+ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
+ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
+ip -net "$ns1" route add default via 10.0.1.1
+ip -net "$ns1" route add default via dead:1::1
 
-ip -net ${ns2} addr add 10.0.2.99/24 dev eth0
-ip -net ${ns2} addr add dead:2::99/64 dev eth0 nodad
-ip -net ${ns2} route add default via 10.0.2.1
-ip -net ${ns2} route add default via dead:2::1
+ip -net "$ns2" addr add 10.0.2.99/24 dev eth0
+ip -net "$ns2" addr add dead:2::99/64 dev eth0 nodad
+ip -net "$ns2" route add default via 10.0.2.1
+ip -net "$ns2" route add default via dead:2::1
 
 test_ping() {
   local daddr4=$1
@@ -155,11 +151,11 @@ test_ping() {
   return 0
 }
 
-ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
-ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
-ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
-ip netns exec ${nsrouter} sysctl net.ipv4.conf.all.rp_filter=0 > /dev/null
-ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.all.rp_filter=0 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
 
 test_ping 10.0.2.1 dead:2::1 || exit 1
 check_drops || exit 1
@@ -169,69 +165,67 @@ check_drops || exit 1
 
 echo "PASS: fib expression did not cause unwanted packet drops"
 
-ip netns exec ${nsrouter} nft flush table inet filter
+ip netns exec "$nsrouter" nft flush table inet filter
 
-ip -net ${ns1} route del default
-ip -net ${ns1} -6 route del default
+ip -net "$ns1" route del default
+ip -net "$ns1" -6 route del default
 
-ip -net ${ns1} addr del 10.0.1.99/24 dev eth0
-ip -net ${ns1} addr del dead:1::99/64 dev eth0
+ip -net "$ns1" addr del 10.0.1.99/24 dev eth0
+ip -net "$ns1" addr del dead:1::99/64 dev eth0
 
-ip -net ${ns1} addr add 10.0.2.99/24 dev eth0
+ip -net "$ns1" addr add 10.0.2.99/24 dev eth0
 ip -net "$ns1" addr add dead:2::99/64 dev eth0 nodad
 
-ip -net ${ns1} route add default via 10.0.2.1
-ip -net ${ns1} -6 route add default via dead:2::1
+ip -net "$ns1" route add default via 10.0.2.1
+ip -net "$ns1" -6 route add default via dead:2::1
 
 ip -net "$nsrouter" addr add dead:2::1/64 dev veth0 nodad
 
 # switch to ruleset that doesn't log, this time
 # its expected that this does drop the packets.
-load_ruleset_count ${nsrouter}
+load_ruleset_count "$nsrouter"
 
 # ns1 has a default route, but nsrouter does not.
 # must not check return value, ping to 1.1.1.1 will
 # fail.
-check_fib_counter 0 ${nsrouter} 1.1.1.1 || exit 1
-check_fib_counter 0 ${nsrouter} 1c3::c01d || exit 1
+check_fib_counter 0 "$nsrouter" 1.1.1.1 || exit 1
+check_fib_counter 0 "$nsrouter" 1c3::c01d || exit 1
 
 ip netns exec "$ns1" ping -W 0.5 -c 1 -q 1.1.1.1 > /dev/null
-check_fib_counter 1 ${nsrouter} 1.1.1.1 || exit 1
+check_fib_counter 1 "$nsrouter" 1.1.1.1 || exit 1
 
 ip netns exec "$ns1" ping -W 0.5 -i 0.1 -c 3 -q 1c3::c01d > /dev/null
-check_fib_counter 3 ${nsrouter} 1c3::c01d || exit 1
+check_fib_counter 3 "$nsrouter" 1c3::c01d || exit 1
 
 # delete all rules
-ip netns exec ${ns1} nft flush ruleset
-ip netns exec ${ns2} nft flush ruleset
-ip netns exec ${nsrouter} nft flush ruleset
+ip netns exec "$ns1" nft flush ruleset
+ip netns exec "$ns2" nft flush ruleset
+ip netns exec "$nsrouter" nft flush ruleset
 
-ip -net ${ns1} addr add 10.0.1.99/24 dev eth0
+ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
 ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
 
-ip -net ${ns1} addr del 10.0.2.99/24 dev eth0
-ip -net ${ns1} addr del dead:2::99/64 dev eth0
+ip -net "$ns1" addr del 10.0.2.99/24 dev eth0
+ip -net "$ns1" addr del dead:2::99/64 dev eth0
 
-ip -net ${nsrouter} addr del dead:2::1/64 dev veth0
+ip -net "$nsrouter" addr del dead:2::1/64 dev veth0
 
 # ... pbr ruleset for the router, check iif+oif.
-load_pbr_ruleset ${nsrouter}
-if [ $? -ne 0 ] ; then
+if ! load_pbr_ruleset "$nsrouter";then
 	echo "SKIP: Could not load fib forward ruleset"
 	exit $ksft_skip
 fi
 
-ip -net ${nsrouter} rule add from all table 128
-ip -net ${nsrouter} rule add from all iif veth0 table 129
-ip -net ${nsrouter} route add table 128 to 10.0.1.0/24 dev veth0
-ip -net ${nsrouter} route add table 129 to 10.0.2.0/24 dev veth1
+ip -net "$nsrouter" rule add from all table 128
+ip -net "$nsrouter" rule add from all iif veth0 table 129
+ip -net "$nsrouter" route add table 128 to 10.0.1.0/24 dev veth0
+ip -net "$nsrouter" route add table 129 to 10.0.2.0/24 dev veth1
 
 # drop main ipv4 table
-ip -net ${nsrouter} -4 rule delete table main
+ip -net "$nsrouter" -4 rule delete table main
 
-test_ping 10.0.2.99 dead:2::99
-if [ $? -ne 0 ] ; then
-	ip -net ${nsrouter} nft list ruleset
+if ! test_ping 10.0.2.99 dead:2::99;then
+	ip -net "$nsrouter" nft list ruleset
 	echo "FAIL: fib mismatch in pbr setup"
 	exit 1
 fi
-- 
2.43.2

