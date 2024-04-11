Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD033487A7;
	Thu, 11 Apr 2024 23:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878995; cv=none; b=GFMSXOb4MAtskKdmjp0z6D22H8uQASHlsm+bgeylgaBnJM8GAgfGo0dau7F0oJ66pAOZzwUNUF/a0weRb4EcH+qkpolY174XGPbeGBuUoKi9svvzjZr0DF6gm/l682MCznmxfKV5cEAFPDuFFXDEBQXKf0qqadpCFWCbzjfnOjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878995; c=relaxed/simple;
	bh=HinpyPH3QgsuNcfO3n8QgpZSobC/GGsHUqLGy4X+wrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUH9zxtCeLpnJOtOzBA6slIVr+VWbJD5AiL9HJOAVdWZQHJ/aqnhu9d+9HvpWWK/ng6YBWZDhbuchAPQuF5RhWZ6WlmuLhuPRCbSLh/tH8RWuouO5NCcgl9P3UELi4oRnZTpqvv+ox/hyEpet4xtTW6WF/NSx5lWdisXlvPuHXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv44W-0000yJ-L7; Fri, 12 Apr 2024 01:43:12 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 13/15] selftests: netfilter: nft_fib.sh: move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:18 +0200
Message-ID: <20240411233624.8129-14-fw@strlen.de>
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

Also lower ping interval, wait times (helpers get called several times)
and set nodad for ipv6 addresses: 20s down to 4s.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_fib.sh        | 71 +++++--------------
 1 file changed, 19 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index dff476e45e77..04d6dc886b8a 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -3,43 +3,25 @@
 # This tests the fib expression.
 #
 # Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+
+source lib.sh
+
 ret=0
 
-sfx=$(mktemp -u "XXXXXXXX")
-ns1="ns1-$sfx"
-ns2="ns2-$sfx"
-nsrouter="nsrouter-$sfx"
 timeout=4
 
 log_netns=$(sysctl -n net.netfilter.nf_log_all_netns)
 
 cleanup()
 {
-	ip netns del ${ns1}
-	ip netns del ${ns2}
-	ip netns del ${nsrouter}
+	cleanup_all_ns
 
 	[ $log_netns -eq 0 ] && sysctl -q net.netfilter.nf_log_all_netns=$log_netns
 }
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without nft tool"
-	exit $ksft_skip
-fi
+checktool "nft --version" "run test without nft"
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-ip netns add ${nsrouter}
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace"
-	exit $ksft_skip
-fi
+setup_ns nsrouter ns1 ns2
 
 trap cleanup EXIT
 
@@ -50,8 +32,6 @@ if [ $? -eq 0 ]; then
 fi
 
 sysctl -q net.netfilter.nf_log_all_netns=1
-ip netns add ${ns1}
-ip netns add ${ns2}
 
 load_ruleset() {
 	local netns=$1
@@ -95,8 +75,7 @@ EOF
 }
 
 check_drops() {
-	dmesg | grep -q ' nft_rpfilter: '
-	if [ $? -eq 0 ]; then
+	if dmesg | grep -q ' nft_rpfilter: ';then
 		dmesg | grep ' nft_rpfilter: '
 		echo "FAIL: rpfilter did drop packets"
 		return 1
@@ -130,35 +109,30 @@ load_ruleset ${nsrouter}
 load_ruleset ${ns1}
 load_ruleset ${ns2}
 
-ip link add veth0 netns ${nsrouter} type veth peer name eth0 netns ${ns1} > /dev/null 2>&1
-if [ $? -ne 0 ];then
+if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1; then
     echo "SKIP: No virtual ethernet pair device support in kernel"
     exit $ksft_skip
 fi
 ip link add veth1 netns ${nsrouter} type veth peer name eth0 netns ${ns2}
 
-ip -net ${nsrouter} link set lo up
 ip -net ${nsrouter} link set veth0 up
 ip -net ${nsrouter} addr add 10.0.1.1/24 dev veth0
-ip -net ${nsrouter} addr add dead:1::1/64 dev veth0
+ip -net ${nsrouter} addr add dead:1::1/64 dev veth0 nodad
 
 ip -net ${nsrouter} link set veth1 up
 ip -net ${nsrouter} addr add 10.0.2.1/24 dev veth1
-ip -net ${nsrouter} addr add dead:2::1/64 dev veth1
+ip -net ${nsrouter} addr add dead:2::1/64 dev veth1 nodad
 
-ip -net ${ns1} link set lo up
 ip -net ${ns1} link set eth0 up
-
-ip -net ${ns2} link set lo up
 ip -net ${ns2} link set eth0 up
 
 ip -net ${ns1} addr add 10.0.1.99/24 dev eth0
-ip -net ${ns1} addr add dead:1::99/64 dev eth0
+ip -net ${ns1} addr add dead:1::99/64 dev eth0 nodad
 ip -net ${ns1} route add default via 10.0.1.1
 ip -net ${ns1} route add default via dead:1::1
 
 ip -net ${ns2} addr add 10.0.2.99/24 dev eth0
-ip -net ${ns2} addr add dead:2::99/64 dev eth0
+ip -net ${ns2} addr add dead:2::99/64 dev eth0 nodad
 ip -net ${ns2} route add default via 10.0.2.1
 ip -net ${ns2} route add default via dead:2::1
 
@@ -166,17 +140,13 @@ test_ping() {
   local daddr4=$1
   local daddr6=$2
 
-  ip netns exec ${ns1} ping -c 1 -q $daddr4 > /dev/null
-  ret=$?
-  if [ $ret -ne 0 ];then
+  if ! ip netns exec "$ns1" ping -c 1 -q "$daddr4" > /dev/null; then
 	check_drops
 	echo "FAIL: ${ns1} cannot reach $daddr4, ret $ret" 1>&2
 	return 1
   fi
 
-  ip netns exec ${ns1} ping -c 3 -q $daddr6 > /dev/null
-  ret=$?
-  if [ $ret -ne 0 ];then
+  if ! ip netns exec "$ns1" ping -c 1 -q "$daddr6" > /dev/null; then
 	check_drops
 	echo "FAIL: ${ns1} cannot reach $daddr6, ret $ret" 1>&2
 	return 1
@@ -191,8 +161,6 @@ ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.all.rp_filter=0 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
 
-sleep 3
-
 test_ping 10.0.2.1 dead:2::1 || exit 1
 check_drops || exit 1
 
@@ -210,12 +178,12 @@ ip -net ${ns1} addr del 10.0.1.99/24 dev eth0
 ip -net ${ns1} addr del dead:1::99/64 dev eth0
 
 ip -net ${ns1} addr add 10.0.2.99/24 dev eth0
-ip -net ${ns1} addr add dead:2::99/64 dev eth0
+ip -net "$ns1" addr add dead:2::99/64 dev eth0 nodad
 
 ip -net ${ns1} route add default via 10.0.2.1
 ip -net ${ns1} -6 route add default via dead:2::1
 
-ip -net ${nsrouter} addr add dead:2::1/64 dev veth0
+ip -net "$nsrouter" addr add dead:2::1/64 dev veth0 nodad
 
 # switch to ruleset that doesn't log, this time
 # its expected that this does drop the packets.
@@ -227,11 +195,10 @@ load_ruleset_count ${nsrouter}
 check_fib_counter 0 ${nsrouter} 1.1.1.1 || exit 1
 check_fib_counter 0 ${nsrouter} 1c3::c01d || exit 1
 
-ip netns exec ${ns1} ping -c 1 -W 1 -q 1.1.1.1 > /dev/null
+ip netns exec "$ns1" ping -W 0.5 -c 1 -q 1.1.1.1 > /dev/null
 check_fib_counter 1 ${nsrouter} 1.1.1.1 || exit 1
 
-sleep 2
-ip netns exec ${ns1} ping -c 3 -q 1c3::c01d > /dev/null
+ip netns exec "$ns1" ping -W 0.5 -i 0.1 -c 3 -q 1c3::c01d > /dev/null
 check_fib_counter 3 ${nsrouter} 1c3::c01d || exit 1
 
 # delete all rules
@@ -240,7 +207,7 @@ ip netns exec ${ns2} nft flush ruleset
 ip netns exec ${nsrouter} nft flush ruleset
 
 ip -net ${ns1} addr add 10.0.1.99/24 dev eth0
-ip -net ${ns1} addr add dead:1::99/64 dev eth0
+ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
 
 ip -net ${ns1} addr del 10.0.2.99/24 dev eth0
 ip -net ${ns1} addr del dead:2::99/64 dev eth0
-- 
2.43.2

