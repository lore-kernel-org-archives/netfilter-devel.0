Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE5C81722;
	Tue, 23 Apr 2024 11:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870680; cv=none; b=M/nc0Kt/Xkb9IT4+hHsl3nRshRsOUZBouNNFR1nHdDh4JqNI0AIa2wh71aiqugToBgxlRIxDWOb48sHhkynZJY49hC4GqbmvE0JGlo+tBRCxUEn47c2U9Fnt7thsZ6KXYB+T/ahJ/NDGSLr6IlP3+o+l0xQsXawbI6OVtG4ZmvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870680; c=relaxed/simple;
	bh=kKtn93TwIuA2Vm0dDPR3fJH1nZR/lqp1S+yjVh8ZQAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MP58N2g8lo1DkTXvPmmrswmwCq32zwjOdAzhXIAKxCbBxgJT3ZK2EMkJx+7JtDaT4L1FM9wMwPrWuwg8kn3/oVMZqsOvOQGTVp1p1eXgsGS1k5AbAZY9CqJPHzprDJ90kxhEp4s1Qij0FGM+Zs86C3Y2PCovQhLP8dJylBaLcBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzE3O-0006wO-2M; Tue, 23 Apr 2024 13:11:14 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 5/7] selftests: netfilter: nft_flowtable.sh: shellcheck cleanups
Date: Tue, 23 Apr 2024 15:05:48 +0200
Message-ID: <20240423130604.7013-6-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240423130604.7013-1-fw@strlen.de>
References: <20240423130604.7013-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

no functional changes intended except that test will now SKIP in
case kernel lacks bridge support and initial rule load failure provides
nft version information.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 257 +++++++++---------
 1 file changed, 136 insertions(+), 121 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 8b5a3a7e22f0..86d516e8acd6 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -37,17 +37,17 @@ cleanup() {
 
 	rm -f "$nsin" "$ns1out" "$ns2out"
 
-	[ $log_netns -eq 0 ] && sysctl -q net.netfilter.nf_log_all_netns=$log_netns
+	[ "$log_netns" -eq 0 ] && sysctl -q net.netfilter.nf_log_all_netns="$log_netns"
 }
 
 trap cleanup EXIT
 
 sysctl -q net.netfilter.nf_log_all_netns=1
 
-ip link add veth0 netns $nsr1 type veth peer name eth0 netns $ns1
-ip link add veth1 netns $nsr1 type veth peer name veth0 netns $nsr2
+ip link add veth0 netns "$nsr1" type veth peer name eth0 netns "$ns1"
+ip link add veth1 netns "$nsr1" type veth peer name veth0 netns "$nsr2"
 
-ip link add veth1 netns $nsr2 type veth peer name eth0 netns $ns2
+ip link add veth1 netns "$nsr2" type veth peer name eth0 netns "$ns2"
 
 for dev in veth0 veth1; do
     ip -net "$nsr1" link set "$dev" up
@@ -90,13 +90,13 @@ do
 	esac
 done
 
-if ! ip -net $nsr1 link set veth0 mtu $omtu; then
+if ! ip -net "$nsr1" link set veth0 mtu "$omtu"; then
 	exit 1
 fi
 
-ip -net $ns1 link set eth0 mtu $omtu
+ip -net "$ns1" link set eth0 mtu "$omtu"
 
-if ! ip -net $nsr2 link set veth1 mtu $rmtu; then
+if ! ip -net "$nsr2" link set veth1 mtu "$rmtu"; then
 	exit 1
 fi
 
@@ -108,7 +108,7 @@ if ! ip -net "$nsr2" link set veth0 mtu "$lmtu"; then
 	exit 1
 fi
 
-ip -net $ns2 link set eth0 mtu $rmtu
+ip -net "$ns2" link set eth0 mtu "$rmtu"
 
 # transfer-net between nsr1 and nsr2.
 # these addresses are not used for connections.
@@ -119,35 +119,34 @@ ip -net "$nsr2" addr add 192.168.10.2/24 dev veth0
 ip -net "$nsr2" addr add fee1:2::2/64 dev veth0 nodad
 
 for i in 0 1; do
-  ip netns exec $nsr1 sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
-  ip netns exec $nsr2 sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
+  ip netns exec "$nsr1" sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
+  ip netns exec "$nsr2" sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
 done
 
-for ns in $ns1 $ns2;do
-  ip -net $ns link set lo up
-  ip -net $ns link set eth0 up
+for ns in "$ns1" "$ns2";do
+  ip -net "$ns" link set eth0 up
 
-  if ! ip netns exec $ns sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null; then
+  if ! ip netns exec "$ns" sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null; then
 	echo "ERROR: Check Originator/Responder values (problem during address addition)"
 	exit 1
   fi
   # don't set ip DF bit for first two tests
-  ip netns exec $ns sysctl net.ipv4.ip_no_pmtu_disc=1 > /dev/null
+  ip netns exec "$ns" sysctl net.ipv4.ip_no_pmtu_disc=1 > /dev/null
 done
 
-ip -net $ns1 addr add 10.0.1.99/24 dev eth0
-ip -net $ns2 addr add 10.0.2.99/24 dev eth0
-ip -net $ns1 route add default via 10.0.1.1
-ip -net $ns2 route add default via 10.0.2.1
-ip -net $ns1 addr add dead:1::99/64 dev eth0 nodad
-ip -net $ns2 addr add dead:2::99/64 dev eth0 nodad
-ip -net $ns1 route add default via dead:1::1
-ip -net $ns2 route add default via dead:2::1
+ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
+ip -net "$ns2" addr add 10.0.2.99/24 dev eth0
+ip -net "$ns1" route add default via 10.0.1.1
+ip -net "$ns2" route add default via 10.0.2.1
+ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
+ip -net "$ns2" addr add dead:2::99/64 dev eth0 nodad
+ip -net "$ns1" route add default via dead:1::1
+ip -net "$ns2" route add default via dead:2::1
 
-ip -net $nsr1 route add default via 192.168.10.2
-ip -net $nsr2 route add default via 192.168.10.1
+ip -net "$nsr1" route add default via 192.168.10.2
+ip -net "$nsr2" route add default via 192.168.10.1
 
-ip netns exec $nsr1 nft -f - <<EOF
+ip netns exec "$nsr1" nft -f - <<EOF
 table inet filter {
   flowtable f1 {
      hook ingress priority 0
@@ -179,7 +178,7 @@ if [ $? -ne 0 ]; then
 	exit $ksft_skip
 fi
 
-ip netns exec $ns2 nft -f - <<EOF
+ip netns exec "$ns2" nft -f - <<EOF
 table inet filter {
    counter ip4dscp0 { }
    counter ip4dscp3 { }
@@ -195,17 +194,18 @@ table inet filter {
 EOF
 
 if [ $? -ne 0 ]; then
-	echo "SKIP: Could not load nft ruleset"
+	echo -n "SKIP: Could not load ruleset: "
+	nft --version
 	exit $ksft_skip
 fi
 
 # test basic connectivity
-if ! ip netns exec $ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
+if ! ip netns exec "$ns1" ping -c 1 -q 10.0.2.99 > /dev/null; then
   echo "ERROR: $ns1 cannot reach ns2" 1>&2
   exit 1
 fi
 
-if ! ip netns exec $ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
+if ! ip netns exec "$ns2" ping -c 1 -q 10.0.1.99 > /dev/null; then
   echo "ERROR: $ns2 cannot reach $ns1" 1>&2
   exit 1
 fi
@@ -235,23 +235,27 @@ check_counters()
 	local what=$1
 	local ok=1
 
-	local orig=$(ip netns exec $nsr1 nft reset counter inet filter routed_orig | grep packets)
-	local repl=$(ip netns exec $nsr1 nft reset counter inet filter routed_repl | grep packets)
+	local orig repl
+	orig=$(ip netns exec "$nsr1" nft reset counter inet filter routed_orig | grep packets)
+	repl=$(ip netns exec "$nsr1" nft reset counter inet filter routed_repl | grep packets)
 
 	local orig_cnt=${orig#*bytes}
 	local repl_cnt=${repl#*bytes}
 
-	local fs=$(du -sb $nsin)
+	local fs
+	fs=$(du -sb "$nsin")
 	local max_orig=${fs%%/*}
 	local max_repl=$((max_orig/4))
 
-	if [ $orig_cnt -gt $max_orig ];then
+	# flowtable fastpath should bypass normal routing one, i.e. the counters in forward hook
+	# should always be lower than the size of the transmitted file (max_orig).
+	if [ "$orig_cnt" -gt "$max_orig" ];then
 		echo "FAIL: $what: original counter $orig_cnt exceeds expected value $max_orig" 1>&2
 		ret=1
 		ok=0
 	fi
 
-	if [ $repl_cnt -gt $max_repl ];then
+	if [ "$repl_cnt" -gt $max_repl ];then
 		echo "FAIL: $what: reply counter $repl_cnt exceeds expected value $max_repl" 1>&2
 		ret=1
 		ok=0
@@ -267,39 +271,40 @@ check_dscp()
 	local what=$1
 	local ok=1
 
-	local counter=$(ip netns exec $ns2 nft reset counter inet filter ip4dscp3 | grep packets)
+	local counter
+	counter=$(ip netns exec "$ns2" nft reset counter inet filter ip4dscp3 | grep packets)
 
 	local pc4=${counter%*bytes*}
 	local pc4=${pc4#*packets}
 
-	local counter=$(ip netns exec $ns2 nft reset counter inet filter ip4dscp0 | grep packets)
+	counter=$(ip netns exec "$ns2" nft reset counter inet filter ip4dscp0 | grep packets)
 	local pc4z=${counter%*bytes*}
 	local pc4z=${pc4z#*packets}
 
 	case "$what" in
 	"dscp_none")
-		if [ $pc4 -gt 0 ] || [ $pc4z -eq 0 ]; then
+		if [ "$pc4" -gt 0 ] || [ "$pc4z" -eq 0 ]; then
 			echo "FAIL: dscp counters do not match, expected dscp3 == 0, dscp0 > 0, but got $pc4,$pc4z" 1>&2
 			ret=1
 			ok=0
 		fi
 		;;
 	"dscp_fwd")
-		if [ $pc4 -eq 0 ] || [ $pc4z -eq 0 ]; then
+		if [ "$pc4" -eq 0 ] || [ "$pc4z" -eq 0 ]; then
 			echo "FAIL: dscp counters do not match, expected dscp3 and dscp0 > 0 but got $pc4,$pc4z" 1>&2
 			ret=1
 			ok=0
 		fi
 		;;
 	"dscp_ingress")
-		if [ $pc4 -eq 0 ] || [ $pc4z -gt 0 ]; then
+		if [ "$pc4" -eq 0 ] || [ "$pc4z" -gt 0 ]; then
 			echo "FAIL: dscp counters do not match, expected dscp3 > 0, dscp0 == 0 but got $pc4,$pc4z" 1>&2
 			ret=1
 			ok=0
 		fi
 		;;
 	"dscp_egress")
-		if [ $pc4 -eq 0 ] || [ $pc4z -gt 0 ]; then
+		if [ "$pc4" -eq 0 ] || [ "$pc4z" -gt 0 ]; then
 			echo "FAIL: dscp counters do not match, expected dscp3 > 0, dscp0 == 0 but got $pc4,$pc4z" 1>&2
 			ret=1
 			ok=0
@@ -311,7 +316,7 @@ check_dscp()
 		ok=0
 	esac
 
-	if [ $ok -eq 1 ] ;then
+	if [ "$ok" -eq 1 ] ;then
 		echo "PASS: $what: dscp packet counters match"
 	fi
 }
@@ -356,10 +361,12 @@ test_tcp_forwarding_ip()
 
 	if ! check_transfer "$nsin" "$ns2out" "ns1 -> ns2"; then
 		lret=1
+		ret=1
 	fi
 
 	if ! check_transfer "$nsin" "$ns1out" "ns1 <- ns2"; then
 		lret=1
+		ret=1
 	fi
 
 	return $lret
@@ -376,7 +383,7 @@ test_tcp_forwarding_set_dscp()
 {
 	check_dscp "dscp_none"
 
-ip netns exec $nsr1 nft -f - <<EOF
+ip netns exec "$nsr1" nft -f - <<EOF
 table netdev dscpmangle {
    chain setdscp0 {
       type filter hook ingress device "veth0" priority 0; policy accept
@@ -388,12 +395,12 @@ if [ $? -eq 0 ]; then
 	test_tcp_forwarding_ip "$1" "$2"  10.0.2.99 12345
 	check_dscp "dscp_ingress"
 
-	ip netns exec $nsr1 nft delete table netdev dscpmangle
+	ip netns exec "$nsr1" nft delete table netdev dscpmangle
 else
 	echo "SKIP: Could not load netdev:ingress for veth0"
 fi
 
-ip netns exec $nsr1 nft -f - <<EOF
+ip netns exec "$nsr1" nft -f - <<EOF
 table netdev dscpmangle {
    chain setdscp0 {
       type filter hook egress device "veth1" priority 0; policy accept
@@ -405,14 +412,14 @@ if [ $? -eq 0 ]; then
 	test_tcp_forwarding_ip "$1" "$2"  10.0.2.99 12345
 	check_dscp "dscp_egress"
 
-	ip netns exec $nsr1 nft flush table netdev dscpmangle
+	ip netns exec "$nsr1" nft flush table netdev dscpmangle
 else
 	echo "SKIP: Could not load netdev:egress for veth1"
 fi
 
 	# partial.  If flowtable really works, then both dscp-is-0 and dscp-is-cs3
 	# counters should have seen packets (before and after ft offload kicks in).
-	ip netns exec $nsr1 nft -a insert rule inet filter forward ip dscp set cs3
+	ip netns exec "$nsr1" nft -a insert rule inet filter forward ip dscp set cs3
 	test_tcp_forwarding_ip "$1" "$2"  10.0.2.99 12345
 	check_dscp "dscp_fwd"
 }
@@ -428,8 +435,8 @@ test_tcp_forwarding_nat()
 	pmtu=$3
 	what=$4
 
-	if [ $lret -eq 0 ] ; then
-		if [ $pmtu -eq 1 ] ;then
+	if [ "$lret" -eq 0 ] ; then
+		if [ "$pmtu" -eq 1 ] ;then
 			check_counters "flow offload for ns1/ns2 with masquerade and pmtu discovery $what"
 		else
 			echo "PASS: flow offload for ns1/ns2 with masquerade $what"
@@ -437,9 +444,9 @@ test_tcp_forwarding_nat()
 
 		test_tcp_forwarding_ip "$1" "$2" 10.6.6.6 1666
 		lret=$?
-		if [ $pmtu -eq 1 ] ;then
+		if [ "$pmtu" -eq 1 ] ;then
 			check_counters "flow offload for ns1/ns2 with dnat and pmtu discovery $what"
-		elif [ $lret -eq 0 ] ; then
+		elif [ "$lret" -eq 0 ] ; then
 			echo "PASS: flow offload for ns1/ns2 with dnat $what"
 		fi
 	fi
@@ -454,25 +461,25 @@ make_file "$nsin"
 # Due to MTU mismatch in both directions, all packets (except small packets like pure
 # acks) have to be handled by normal forwarding path.  Therefore, packet counters
 # are not checked.
-if test_tcp_forwarding $ns1 $ns2; then
+if test_tcp_forwarding "$ns1" "$ns2"; then
 	echo "PASS: flow offloaded for ns1/ns2"
 else
 	echo "FAIL: flow offload for ns1/ns2:" 1>&2
-	ip netns exec $nsr1 nft list ruleset
+	ip netns exec "$nsr1" nft list ruleset
 	ret=1
 fi
 
 # delete default route, i.e. ns2 won't be able to reach ns1 and
 # will depend on ns1 being masqueraded in nsr1.
 # expect ns1 has nsr1 address.
-ip -net $ns2 route del default via 10.0.2.1
-ip -net $ns2 route del default via dead:2::1
-ip -net $ns2 route add 192.168.10.1 via 10.0.2.1
+ip -net "$ns2" route del default via 10.0.2.1
+ip -net "$ns2" route del default via dead:2::1
+ip -net "$ns2" route add 192.168.10.1 via 10.0.2.1
 
 # Second test:
 # Same, but with NAT enabled.  Same as in first test: we expect normal forward path
 # to handle most packets.
-ip netns exec $nsr1 nft -f - <<EOF
+ip netns exec "$nsr1" nft -f - <<EOF
 table ip nat {
    chain prerouting {
       type nat hook prerouting priority 0; policy accept;
@@ -486,14 +493,14 @@ table ip nat {
 }
 EOF
 
-if ! test_tcp_forwarding_set_dscp $ns1 $ns2 0 ""; then
+if ! test_tcp_forwarding_set_dscp "$ns1" "$ns2" 0 ""; then
 	echo "FAIL: flow offload for ns1/ns2 with dscp update" 1>&2
 	exit 0
 fi
 
-if ! test_tcp_forwarding_nat $ns1 $ns2 0 ""; then
+if ! test_tcp_forwarding_nat "$ns1" "$ns2" 0 ""; then
 	echo "FAIL: flow offload for ns1/ns2 with NAT" 1>&2
-	ip netns exec $nsr1 nft list ruleset
+	ip netns exec "$nsr1" nft list ruleset
 	ret=1
 fi
 
@@ -501,35 +508,40 @@ fi
 # Same as second test, but with PMTU discovery enabled. This
 # means that we expect the fastpath to handle packets as soon
 # as the endpoints adjust the packet size.
-ip netns exec $ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
-ip netns exec $ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
+ip netns exec "$ns1" sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
+ip netns exec "$ns2" sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 
 # reset counters.
 # With pmtu in-place we'll also check that nft counters
 # are lower than file size and packets were forwarded via flowtable layer.
 # For earlier tests (large mtus), packets cannot be handled via flowtable
 # (except pure acks and other small packets).
-ip netns exec $nsr1 nft reset counters table inet filter >/dev/null
+ip netns exec "$nsr1" nft reset counters table inet filter >/dev/null
 
-if ! test_tcp_forwarding_nat $ns1 $ns2 1 ""; then
+if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 ""; then
 	echo "FAIL: flow offload for ns1/ns2 with NAT and pmtu discovery" 1>&2
-	ip netns exec $nsr1 nft list ruleset
+	ip netns exec "$nsr1" nft list ruleset
 fi
 
 # Another test:
 # Add bridge interface br0 to Router1, with NAT enabled.
-ip -net $nsr1 link add name br0 type bridge
-ip -net $nsr1 addr flush dev veth0
-ip -net $nsr1 link set up dev veth0
-ip -net $nsr1 link set veth0 master br0
-ip -net $nsr1 addr add 10.0.1.1/24 dev br0
-ip -net $nsr1 addr add dead:1::1/64 dev br0 nodad
-ip -net $nsr1 link set up dev br0
+test_bridge() {
+if ! ip -net "$nsr1" link add name br0 type bridge 2>/dev/null;then
+	echo "SKIP: could not add bridge br0"
+	[ "$ret" -eq 0 ] && ret=$ksft_skip
+	return
+fi
+ip -net "$nsr1" addr flush dev veth0
+ip -net "$nsr1" link set up dev veth0
+ip -net "$nsr1" link set veth0 master br0
+ip -net "$nsr1" addr add 10.0.1.1/24 dev br0
+ip -net "$nsr1" addr add dead:1::1/64 dev br0 nodad
+ip -net "$nsr1" link set up dev br0
 
-ip netns exec $nsr1 sysctl net.ipv4.conf.br0.forwarding=1 > /dev/null
+ip netns exec "$nsr1" sysctl net.ipv4.conf.br0.forwarding=1 > /dev/null
 
 # br0 with NAT enabled.
-ip netns exec $nsr1 nft -f - <<EOF
+ip netns exec "$nsr1" nft -f - <<EOF
 flush table ip nat
 table ip nat {
    chain prerouting {
@@ -544,56 +556,59 @@ table ip nat {
 }
 EOF
 
-if ! test_tcp_forwarding_nat $ns1 $ns2 1 "on bridge"; then
+if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "on bridge"; then
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT" 1>&2
-	ip netns exec $nsr1 nft list ruleset
+	ip netns exec "$nsr1" nft list ruleset
 	ret=1
 fi
 
 
 # Another test:
 # Add bridge interface br0 to Router1, with NAT and VLAN.
-ip -net $nsr1 link set veth0 nomaster
-ip -net $nsr1 link set down dev veth0
-ip -net $nsr1 link add link veth0 name veth0.10 type vlan id 10
-ip -net $nsr1 link set up dev veth0
-ip -net $nsr1 link set up dev veth0.10
-ip -net $nsr1 link set veth0.10 master br0
-
-ip -net $ns1 addr flush dev eth0
-ip -net $ns1 link add link eth0 name eth0.10 type vlan id 10
-ip -net $ns1 link set eth0 up
-ip -net $ns1 link set eth0.10 up
-ip -net $ns1 addr add 10.0.1.99/24 dev eth0.10
-ip -net $ns1 route add default via 10.0.1.1
-ip -net $ns1 addr add dead:1::99/64 dev eth0.10 nodad
-
-if ! test_tcp_forwarding_nat $ns1 $ns2 1 "bridge and VLAN"; then
+ip -net "$nsr1" link set veth0 nomaster
+ip -net "$nsr1" link set down dev veth0
+ip -net "$nsr1" link add link veth0 name veth0.10 type vlan id 10
+ip -net "$nsr1" link set up dev veth0
+ip -net "$nsr1" link set up dev veth0.10
+ip -net "$nsr1" link set veth0.10 master br0
+
+ip -net "$ns1" addr flush dev eth0
+ip -net "$ns1" link add link eth0 name eth0.10 type vlan id 10
+ip -net "$ns1" link set eth0 up
+ip -net "$ns1" link set eth0.10 up
+ip -net "$ns1" addr add 10.0.1.99/24 dev eth0.10
+ip -net "$ns1" route add default via 10.0.1.1
+ip -net "$ns1" addr add dead:1::99/64 dev eth0.10 nodad
+
+if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "bridge and VLAN"; then
 	echo "FAIL: flow offload for ns1/ns2 with bridge NAT and VLAN" 1>&2
-	ip netns exec $nsr1 nft list ruleset
+	ip netns exec "$nsr1" nft list ruleset
 	ret=1
 fi
 
 # restore test topology (remove bridge and VLAN)
-ip -net $nsr1 link set veth0 nomaster
-ip -net $nsr1 link set veth0 down
-ip -net $nsr1 link set veth0.10 down
-ip -net $nsr1 link delete veth0.10 type vlan
-ip -net $nsr1 link delete br0 type bridge
-ip -net $ns1 addr flush dev eth0.10
-ip -net $ns1 link set eth0.10 down
-ip -net $ns1 link set eth0 down
-ip -net $ns1 link delete eth0.10 type vlan
+ip -net "$nsr1" link set veth0 nomaster
+ip -net "$nsr1" link set veth0 down
+ip -net "$nsr1" link set veth0.10 down
+ip -net "$nsr1" link delete veth0.10 type vlan
+ip -net "$nsr1" link delete br0 type bridge
+ip -net "$ns1" addr flush dev eth0.10
+ip -net "$ns1" link set eth0.10 down
+ip -net "$ns1" link set eth0 down
+ip -net "$ns1" link delete eth0.10 type vlan
 
 # restore address in ns1 and nsr1
-ip -net $ns1 link set eth0 up
-ip -net $ns1 addr add 10.0.1.99/24 dev eth0
-ip -net $ns1 route add default via 10.0.1.1
-ip -net $ns1 addr add dead:1::99/64 dev eth0 nodad
-ip -net $ns1 route add default via dead:1::1
-ip -net $nsr1 addr add 10.0.1.1/24 dev veth0
-ip -net $nsr1 addr add dead:1::1/64 dev veth0 nodad
-ip -net $nsr1 link set up dev veth0
+ip -net "$ns1" link set eth0 up
+ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
+ip -net "$ns1" route add default via 10.0.1.1
+ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
+ip -net "$ns1" route add default via dead:1::1
+ip -net "$nsr1" addr add 10.0.1.1/24 dev veth0
+ip -net "$nsr1" addr add dead:1::1/64 dev veth0 nodad
+ip -net "$nsr1" link set up dev veth0
+}
+
+test_bridge
 
 KEY_SHA="0x"$(ps -af | sha1sum | cut -d " " -f 1)
 KEY_AES="0x"$(ps -af | md5sum | cut -d " " -f 1)
@@ -613,25 +628,25 @@ do_esp() {
     local spi_out=$6
     local spi_in=$7
 
-    ip -net $ns xfrm state add src $remote dst $me proto esp spi $spi_in  enc aes $KEY_AES  auth sha1 $KEY_SHA mode tunnel sel src $rnet dst $lnet
-    ip -net $ns xfrm state add src $me  dst $remote proto esp spi $spi_out enc aes $KEY_AES auth sha1 $KEY_SHA mode tunnel sel src $lnet dst $rnet
+    ip -net "$ns" xfrm state add src "$remote" dst "$me" proto esp spi "$spi_in"  enc aes "$KEY_AES"  auth sha1 "$KEY_SHA" mode tunnel sel src "$rnet" dst "$lnet"
+    ip -net "$ns" xfrm state add src "$me"  dst "$remote" proto esp spi "$spi_out" enc aes "$KEY_AES" auth sha1 "$KEY_SHA" mode tunnel sel src "$lnet" dst "$rnet"
 
     # to encrypt packets as they go out (includes forwarded packets that need encapsulation)
-    ip -net $ns xfrm policy add src $lnet dst $rnet dir out tmpl src $me dst $remote proto esp mode tunnel priority 1 action allow
+    ip -net "$ns" xfrm policy add src "$lnet" dst "$rnet" dir out tmpl src "$me" dst "$remote" proto esp mode tunnel priority 1 action allow
     # to fwd decrypted packets after esp processing:
-    ip -net $ns xfrm policy add src $rnet dst $lnet dir fwd tmpl src $remote dst $me proto esp mode tunnel priority 1 action allow
+    ip -net "$ns" xfrm policy add src "$rnet" dst "$lnet" dir fwd tmpl src "$remote" dst "$me" proto esp mode tunnel priority 1 action allow
 }
 
-do_esp $nsr1 192.168.10.1 192.168.10.2 10.0.1.0/24 10.0.2.0/24 $SPI1 $SPI2
+do_esp "$nsr1" 192.168.10.1 192.168.10.2 10.0.1.0/24 10.0.2.0/24 "$SPI1" "$SPI2"
 
-do_esp $nsr2 192.168.10.2 192.168.10.1 10.0.2.0/24 10.0.1.0/24 $SPI2 $SPI1
+do_esp "$nsr2" 192.168.10.2 192.168.10.1 10.0.2.0/24 10.0.1.0/24 "$SPI2" "$SPI1"
 
-ip netns exec $nsr1 nft delete table ip nat
+ip netns exec "$nsr1" nft delete table ip nat
 
 # restore default routes
-ip -net $ns2 route del 192.168.10.1 via 10.0.2.1
-ip -net $ns2 route add default via 10.0.2.1
-ip -net $ns2 route add default via dead:2::1
+ip -net "$ns2" route del 192.168.10.1 via 10.0.2.1
+ip -net "$ns2" route add default via 10.0.2.1
+ip -net "$ns2" route add default via dead:2::1
 
 if test_tcp_forwarding "$ns1" "$ns2"; then
 	check_counters "ipsec tunnel mode for ns1/ns2"
@@ -641,7 +656,7 @@ else
 	ip netns exec "$nsr1" cat /proc/net/xfrm_stat 1>&2
 fi
 
-if [ x"$1" = x ]; then
+if [ "$1" = "" ]; then
 	low=1280
 	mtu=$((65536 - low))
 	o=$(((RANDOM%mtu) + low))
-- 
2.43.2

