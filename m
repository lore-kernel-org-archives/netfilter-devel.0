Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C2A168B06;
	Thu, 18 Apr 2024 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454227; cv=none; b=jSmYsJ9JnZvuK8K1gLXBxIEImCdHpXcMSfuVkQ+Mfkho+XBCoTIhyTCaKfznzELXZV6SaVU0+QHKR9ykdIlP3dI17L4wW/0Iph9oVOpMb4T/7IURlxHGz2cucEbZO/8sIl1IsVpVQAEIx7/XGBW4JS3NUtoTm3dFOwBfEiEiRsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454227; c=relaxed/simple;
	bh=8TmnnmJzYrAEVHy0A2duQ8EUbQgKDllHOfZZ1Hr72fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNR6T5xadVncIJnyVCbFvb/RZNrJ3eyM8bwAzwIZgc1AThqqzpWc6eW+Ecig5mVhtGJWbCsmdEF4mD5k7ffK0i05x3V4/y/1j0DU4mKIljfpAMS6q9Msb6s9B7xV6YOT8gadVJ8/f5XzJ7E0VYXM0PAoYxmJ33EDULT/ofrFq4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxTiP-00009M-Iw; Thu, 18 Apr 2024 17:30:21 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next v2 07/12] selftests: netfilter: nft_nat_zones.sh: shellcheck cleanups
Date: Thu, 18 Apr 2024 17:27:35 +0200
Message-ID: <20240418152744.15105-8-fw@strlen.de>
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

While at it: No need for iperf here, use socat.
This also reduces the script runtime.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_nat_zones.sh  | 193 +++++++-----------
 1 file changed, 75 insertions(+), 118 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
index b9ab37380f33..549f264b41f3 100755
--- a/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
+++ b/tools/testing/selftests/net/netfilter/nft_nat_zones.sh
@@ -3,15 +3,14 @@
 # Test connection tracking zone and NAT source port reallocation support.
 #
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+source lib.sh
 
 # Don't increase too much, 2000 clients should work
 # just fine but script can then take several minutes with
 # KASAN/debug builds.
 maxclients=100
 
-have_iperf=1
+have_socat=0
 ret=0
 
 # client1---.
@@ -31,12 +30,6 @@ ret=0
 #   NAT Gateway is supposed to do port reallocation for each of the
 #   connections.
 
-sfx=$(mktemp -u "XXXXXXXX")
-gw="ns-gw-$sfx"
-cl1="ns-cl1-$sfx"
-cl2="ns-cl2-$sfx"
-srv="ns-srv-$sfx"
-
 v4gc1=$(sysctl -n net.ipv4.neigh.default.gc_thresh1 2>/dev/null)
 v4gc2=$(sysctl -n net.ipv4.neigh.default.gc_thresh2 2>/dev/null)
 v4gc3=$(sysctl -n net.ipv4.neigh.default.gc_thresh3 2>/dev/null)
@@ -46,61 +39,29 @@ v6gc3=$(sysctl -n net.ipv6.neigh.default.gc_thresh3 2>/dev/null)
 
 cleanup()
 {
-	ip netns del $gw
-	ip netns del $srv
-	for i in $(seq 1 $maxclients); do
-		ip netns del ns-cl$i-$sfx 2>/dev/null
-	done
-
-	sysctl -q net.ipv4.neigh.default.gc_thresh1=$v4gc1 2>/dev/null
-	sysctl -q net.ipv4.neigh.default.gc_thresh2=$v4gc2 2>/dev/null
-	sysctl -q net.ipv4.neigh.default.gc_thresh3=$v4gc3 2>/dev/null
-	sysctl -q net.ipv6.neigh.default.gc_thresh1=$v6gc1 2>/dev/null
-	sysctl -q net.ipv6.neigh.default.gc_thresh2=$v6gc2 2>/dev/null
-	sysctl -q net.ipv6.neigh.default.gc_thresh3=$v6gc3 2>/dev/null
+	cleanup_all_ns
+
+	sysctl -q net.ipv4.neigh.default.gc_thresh1="$v4gc1" 2>/dev/null
+	sysctl -q net.ipv4.neigh.default.gc_thresh2="$v4gc2" 2>/dev/null
+	sysctl -q net.ipv4.neigh.default.gc_thresh3="$v4gc3" 2>/dev/null
+	sysctl -q net.ipv6.neigh.default.gc_thresh1="$v6gc1" 2>/dev/null
+	sysctl -q net.ipv6.neigh.default.gc_thresh2="$v6gc2" 2>/dev/null
+	sysctl -q net.ipv6.neigh.default.gc_thresh3="$v6gc3" 2>/dev/null
 }
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without nft tool"
-	exit $ksft_skip
-fi
+checktool "nft --version" echo "run test without nft tool"
+checktool "conntrack -V" "run test without conntrack tool"
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
+if socat -h >/dev/null 2>&1; then
+	have_socat=1
 fi
 
-conntrack -V > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without conntrack tool"
-	exit $ksft_skip
-fi
-
-iperf3 -v >/dev/null 2>&1
-if [ $? -ne 0 ];then
-	have_iperf=0
-fi
-
-ip netns add "$gw"
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace $gw"
-	exit $ksft_skip
-fi
-ip -net "$gw" link set lo up
+setup_ns gw srv
 
 trap cleanup EXIT
 
-ip netns add "$srv"
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create server netns $srv"
-	exit $ksft_skip
-fi
-
 ip link add veth0 netns "$gw" type veth peer name eth0 netns "$srv"
 ip -net "$gw" link set veth0 up
-ip -net "$srv" link set lo up
 ip -net "$srv" link set eth0 up
 
 sysctl -q net.ipv6.neigh.default.gc_thresh1=512  2>/dev/null
@@ -110,55 +71,49 @@ sysctl -q net.ipv4.neigh.default.gc_thresh1=512  2>/dev/null
 sysctl -q net.ipv4.neigh.default.gc_thresh2=1024 2>/dev/null
 sysctl -q net.ipv4.neigh.default.gc_thresh3=4096 2>/dev/null
 
-for i in $(seq 1 $maxclients);do
-  cl="ns-cl$i-$sfx"
+for i in $(seq 1 "$maxclients");do
+  setup_ns "cl$i"
 
-  ip netns add "$cl"
-  if [ $? -ne 0 ];then
-     echo "SKIP: Could not create client netns $cl"
-     exit $ksft_skip
-  fi
-  ip link add veth$i netns "$gw" type veth peer name eth0 netns "$cl" > /dev/null 2>&1
-  if [ $? -ne 0 ];then
+  cl=$(eval echo \$cl"$i")
+  if ! ip link add veth"$i" netns "$gw" type veth peer name eth0 netns "$cl" > /dev/null 2>&1;then
     echo "SKIP: No virtual ethernet pair device support in kernel"
     exit $ksft_skip
   fi
 done
 
-for i in $(seq 1 $maxclients);do
-  cl="ns-cl$i-$sfx"
-  echo netns exec "$cl" ip link set lo up
+for i in $(seq 1 "$maxclients");do
+  cl=$(eval echo \$cl"$i")
   echo netns exec "$cl" ip link set eth0 up
   echo netns exec "$cl" sysctl -q net.ipv4.tcp_syn_retries=2
-  echo netns exec "$gw" ip link set veth$i up
-  echo netns exec "$gw" sysctl -q net.ipv4.conf.veth$i.arp_ignore=2
-  echo netns exec "$gw" sysctl -q net.ipv4.conf.veth$i.rp_filter=0
+  echo netns exec "$gw" ip link set "veth$i" up
+  echo netns exec "$gw" sysctl -q net.ipv4.conf.veth"$i".arp_ignore=2
+  echo netns exec "$gw" sysctl -q net.ipv4.conf.veth"$i".rp_filter=0
 
   # clients have same IP addresses.
   echo netns exec "$cl" ip addr add 10.1.0.3/24 dev eth0
-  echo netns exec "$cl" ip addr add dead:1::3/64 dev eth0
+  echo netns exec "$cl" ip addr add dead:1::3/64 dev eth0 nodad
   echo netns exec "$cl" ip route add default via 10.1.0.2 dev eth0
   echo netns exec "$cl" ip route add default via dead:1::2 dev eth0
 
   # NB: same addresses on client-facing interfaces.
-  echo netns exec "$gw" ip addr add 10.1.0.2/24 dev veth$i
-  echo netns exec "$gw" ip addr add dead:1::2/64 dev veth$i
+  echo netns exec "$gw" ip addr add 10.1.0.2/24 dev "veth$i"
+  echo netns exec "$gw" ip addr add dead:1::2/64 dev "veth$i" nodad
 
   # gw: policy routing
-  echo netns exec "$gw" ip route add 10.1.0.0/24 dev veth$i table $((1000+i))
-  echo netns exec "$gw" ip route add dead:1::0/64 dev veth$i table $((1000+i))
+  echo netns exec "$gw" ip route add 10.1.0.0/24 dev "veth$i" table $((1000+i))
+  echo netns exec "$gw" ip route add dead:1::0/64 dev "veth$i" table $((1000+i))
   echo netns exec "$gw" ip route add 10.3.0.0/24 dev veth0 table $((1000+i))
   echo netns exec "$gw" ip route add dead:3::0/64 dev veth0 table $((1000+i))
-  echo netns exec "$gw" ip rule add fwmark $i lookup $((1000+i))
+  echo netns exec "$gw" ip rule add fwmark "$i" lookup $((1000+i))
 done | ip -batch /dev/stdin
 
 ip -net "$gw" addr add 10.3.0.1/24 dev veth0
-ip -net "$gw" addr add dead:3::1/64 dev veth0
+ip -net "$gw" addr add dead:3::1/64 dev veth0 nodad
 
 ip -net "$srv" addr add 10.3.0.99/24 dev eth0
-ip -net "$srv" addr add dead:3::99/64 dev eth0
+ip -net "$srv" addr add dead:3::99/64 dev eth0 nodad
 
-ip netns exec $gw nft -f /dev/stdin<<EOF
+ip netns exec "$gw" nft -f /dev/stdin<<EOF
 table inet raw {
 	map iiftomark {
 		type ifname : mark
@@ -203,18 +158,22 @@ table inet raw {
 	}
 }
 EOF
+if [ "$?" -ne 0 ];then
+	echo "SKIP: Could not add nftables rules"
+	exit $ksft_skip
+fi
 
 ( echo add element inet raw iiftomark \{
 	for i in $(seq 1 $((maxclients-1))); do
-		echo \"veth$i\" : $i,
+		echo \"veth"$i"\" : "$i",
 	done
-	echo \"veth$maxclients\" : $maxclients \}
+	echo \"veth"$maxclients"\" : "$maxclients" \}
 	echo add element inet raw iiftozone \{
 	for i in $(seq 1 $((maxclients-1))); do
-		echo \"veth$i\" : $i,
+		echo \"veth"$i"\" : "$i",
 	done
 	echo \"veth$maxclients\" : $maxclients \}
-) | ip netns exec $gw nft -f /dev/stdin
+) | ip netns exec "$gw" nft -f /dev/stdin
 
 ip netns exec "$gw" sysctl -q net.ipv4.conf.all.forwarding=1 > /dev/null
 ip netns exec "$gw" sysctl -q net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -224,73 +183,72 @@ ip netns exec "$gw" sysctl -q net.ipv4.conf.all.rp_filter=0 >/dev/null
 ip netns exec "$gw" sysctl -q net.ipv4.fwmark_reflect=1 > /dev/null
 ip netns exec "$gw" sysctl -q net.ipv6.fwmark_reflect=1 > /dev/null
 
-for i in $(seq 1 $maxclients); do
-  cl="ns-cl$i-$sfx"
-  ip netns exec $cl ping -i 0.5 -q -c 3 10.3.0.99 > /dev/null 2>&1 &
-  if [ $? -ne 0 ]; then
-     echo FAIL: Ping failure from $cl 1>&2
-     ret=1
-     break
-  fi
+for i in $(seq 1 "$maxclients"); do
+  cl=$(eval echo \$cl"$i")
+  ip netns exec "$cl" ping -i 0.5 -q -c 3 10.3.0.99 > /dev/null 2>&1 &
 done
 
-wait
+wait || ret=1
 
-for i in $(seq 1 $maxclients); do
-   ip netns exec $gw nft get element inet raw inicmp "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 }" | grep -q "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 counter packets 3 bytes 252 }"
-   if [ $? -ne 0 ];then
+[ "$ret" -ne 0 ] && "FAIL: Ping failure from $cl" 1>&2
+
+for i in $(seq 1 "$maxclients"); do
+   if ! ip netns exec "$gw" nft get element inet raw inicmp "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 }" | grep -q "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 counter packets 3 bytes 252 }"; then
       ret=1
       echo "FAIL: counter icmp mismatch for veth$i" 1>&2
-      ip netns exec $gw nft get element inet raw inicmp "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 }" 1>&2
+      ip netns exec "$gw" nft get element inet raw inicmp "{ 10.1.0.3 . \"veth$i\" . 10.3.0.99 }" 1>&2
       break
    fi
 done
 
-ip netns exec $gw nft get element inet raw inicmp "{ 10.3.0.99 . \"veth0\" . 10.3.0.1 }" | grep -q "{ 10.3.0.99 . \"veth0\" . 10.3.0.1 counter packets $((3 * $maxclients)) bytes $((252 * $maxclients)) }"
-if [ $? -ne 0 ];then
+if ! ip netns exec "$gw" nft get element inet raw inicmp "{ 10.3.0.99 . \"veth0\" . 10.3.0.1 }" | grep -q "{ 10.3.0.99 . \"veth0\" . 10.3.0.1 counter packets $((3 * maxclients)) bytes $((252 * maxclients)) }"; then
     ret=1
-    echo "FAIL: counter icmp mismatch for veth0: { 10.3.0.99 . \"veth0\" . 10.3.0.1 counter packets $((3 * $maxclients)) bytes $((252 * $maxclients)) }"
-    ip netns exec $gw nft get element inet raw inicmp "{ 10.3.99 . \"veth0\" . 10.3.0.1 }" 1>&2
+    echo "FAIL: counter icmp mismatch for veth0: { 10.3.0.99 . \"veth0\" . 10.3.0.1 counter packets $((3 * maxclients)) bytes $((252 * maxclients)) }"
+    ip netns exec "$gw" nft get element inet raw inicmp "{ 10.3.99 . \"veth0\" . 10.3.0.1 }" 1>&2
 fi
 
-if  [ $ret -eq 0 ]; then
+if [ $ret -eq 0 ]; then
 	echo "PASS: ping test from all $maxclients namespaces"
 fi
 
-if [ $have_iperf -eq 0 ];then
-	echo "SKIP: iperf3 not installed"
+if [ $have_socat -eq 0 ];then
+	echo "SKIP: socat not installed"
 	if [ $ret -ne 0 ];then
 	    exit $ret
 	fi
 	exit $ksft_skip
 fi
 
-ip netns exec $srv iperf3 -s > /dev/null 2>&1 &
-iperfpid=$!
-sleep 1
+listener_ready()
+{
+	ss -N "$1" -lnt -o "sport = :5201" | grep -q 5201
+}
+
+ip netns exec "$srv" socat -u TCP-LISTEN:5201,fork STDOUT > /dev/null 2>/dev/null &
+socatpid=$!
+
+busywait 1000 listener_ready "$srv"
 
-for i in $(seq 1 $maxclients); do
+for i in $(seq 1 "$maxclients"); do
   if [ $ret -ne 0 ]; then
      break
   fi
-  cl="ns-cl$i-$sfx"
-  ip netns exec $cl iperf3 -c 10.3.0.99 --cport 10000 -n 1 > /dev/null
-  if [ $? -ne 0 ]; then
-     echo FAIL: Failure to connect for $cl 1>&2
-     ip netns exec $gw conntrack -S 1>&2
+  cl=$(eval echo \$cl"$i")
+  if ! ip netns exec "$cl" socat -4 -u STDIN TCP:10.3.0.99:5201,sourceport=10000 < /dev/null > /dev/null; then
+     echo "FAIL: Failure to connect for $cl" 1>&2
+     ip netns exec "$gw" conntrack -S 1>&2
      ret=1
   fi
 done
 if [ $ret -eq 0 ];then
-	echo "PASS: iperf3 connections for all $maxclients net namespaces"
+	echo "PASS: socat connections for all $maxclients net namespaces"
 fi
 
-kill $iperfpid
+kill $socatpid
 wait
 
-for i in $(seq 1 $maxclients); do
-   ip netns exec $gw nft get element inet raw inflows "{ 10.1.0.3 . 10000 . \"veth$i\" . 10.3.0.99 . 5201 }" > /dev/null
-   if [ $? -ne 0 ];then
+for i in $(seq 1 "$maxclients"); do
+   if ! ip netns exec "$gw" nft get element inet raw inflows "{ 10.1.0.3 . 10000 . \"veth$i\" . 10.3.0.99 . 5201 }" > /dev/null;then
       ret=1
       echo "FAIL: can't find expected tcp entry for veth$i" 1>&2
       break
@@ -300,8 +258,7 @@ if [ $ret -eq 0 ];then
 	echo "PASS: Found client connection for all $maxclients net namespaces"
 fi
 
-ip netns exec $gw nft get element inet raw inflows "{ 10.3.0.99 . 5201 . \"veth0\" . 10.3.0.1 . 10000 }" > /dev/null
-if [ $? -ne 0 ];then
+if ! ip netns exec "$gw" nft get element inet raw inflows "{ 10.3.0.99 . 5201 . \"veth0\" . 10.3.0.1 . 10000 }" > /dev/null;then
     ret=1
     echo "FAIL: cannot find return entry on veth0" 1>&2
 fi
-- 
2.43.2

