Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4338514AA7;
	Thu, 11 Apr 2024 23:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878951; cv=none; b=ZlcVtASfyCVXKVfkd+3cM9N8jInNvKhon3Q9GeZU06DQv4MsqvD3Jk7ZO3Tvo4GuN7/CJCFKYn2vbfNJbg28SYzh7pCkecjNGwNFIFCymhvq1lokhphAtCIDCBI0MLGGtifMR+tJsxyh7kkIv8XInvs+CsDB7rjiqjFS76LbLuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878951; c=relaxed/simple;
	bh=/OMS7BKyqGbd6XvDWMqH/K15uYWKdbrXsDYCDEsp80k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0fRsN/we+zet2axxKWexZ23gf/s5/6x24F5tWgsSTENUM8rYZ5R+Q+fiYUEj6/2CRimF0LBP83CwEwKPiCn3Fd9pol6RFdaI1yM6tKhqdoEljeV+acSZzP1vqGfEi5UISE4hJdGLqii6wtes9xBYmGWOu1kXHRxwfjMXQ/qQgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv43n-0000tM-M7; Fri, 12 Apr 2024 01:42:27 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 02/15] selftests: netfilter: bridge_brouter.sh: move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:07 +0200
Message-ID: <20240411233624.8129-3-fw@strlen.de>
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

Doing so gets us dynamically generated netns names.

Also:
* do not assume rp_filter is disabled, if its on script failed
* reduce timeout (-W) for "expected to fail" ping commands
* don't print PASS line for basic sanity ping
* shellcheck cleanups

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/bridge_brouter.sh | 128 +++++++-----------
 1 file changed, 52 insertions(+), 76 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/bridge_brouter.sh b/tools/testing/selftests/net/netfilter/bridge_brouter.sh
index 29f3955b9af7..2549b6590693 100755
--- a/tools/testing/selftests/net/netfilter/bridge_brouter.sh
+++ b/tools/testing/selftests/net/netfilter/bridge_brouter.sh
@@ -5,142 +5,118 @@
 # part of a bridge.
 
 #           eth0    br0     eth0
-# setup is: ns1 <-> ns0 <-> ns2
+# setup is: ns1 <-> nsbr <-> ns2
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-ret=0
+source lib.sh
 
-ebtables -V > /dev/null 2>&1
-if [ $? -ne 0 ];then
+if ! ebtables -V > /dev/null 2>&1;then
 	echo "SKIP: Could not run test without ebtables"
 	exit $ksft_skip
 fi
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
+cleanup() {
+	cleanup_all_ns
+}
 
-ip netns add ns0
-ip netns add ns1
-ip netns add ns2
+trap cleanup EXIT
 
-ip link add veth0 netns ns0 type veth peer name eth0 netns ns1
-if [ $? -ne 0 ]; then
+setup_ns nsbr ns1 ns2
+
+ip netns exec "$nsbr" sysctl -q net.ipv4.conf.default.rp_filter=0
+ip netns exec "$nsbr" sysctl -q net.ipv4.conf.all.rp_filter=0
+if ! ip link add veth0 netns "$nsbr" type veth peer name eth0 netns "$ns1"; then
 	echo "SKIP: Can't create veth device"
 	exit $ksft_skip
 fi
-ip link add veth1 netns ns0 type veth peer name eth0 netns ns2
-
-ip -net ns0 link set lo up
-ip -net ns0 link set veth0 up
-ip -net ns0 link set veth1 up
+ip link add veth1 netns "$nsbr" type veth peer name eth0 netns "$ns2"
 
-ip -net ns0 link add br0 type bridge
-if [ $? -ne 0 ]; then
+if ! ip -net "$nsbr" link add br0 type bridge; then
 	echo "SKIP: Can't create bridge br0"
 	exit $ksft_skip
 fi
 
-ip -net ns0 link set veth0 master br0
-ip -net ns0 link set veth1 master br0
-ip -net ns0 link set br0 up
-ip -net ns0 addr add 10.0.0.1/24 dev br0
+ip -net "$nsbr" link set veth0 up
+ip -net "$nsbr" link set veth1 up
+
+ip -net "$nsbr" link set veth0 master br0
+ip -net "$nsbr" link set veth1 master br0
+ip -net "$nsbr" link set br0 up
+ip -net "$nsbr" addr add 10.0.0.1/24 dev br0
 
-# place both in same subnet, ns1 and ns2 connected via ns0:br0
-for i in 1 2; do
-  ip -net ns$i link set lo up
-  ip -net ns$i link set eth0 up
-  ip -net ns$i addr add 10.0.0.1$i/24 dev eth0
-done
+# place both in same subnet, ${ns1} and ${ns2} connected via ${nsbr}:br0
+ip -net "$ns1" link set eth0 up
+ip -net "$ns2" link set eth0 up
+ip -net "$ns1" addr add 10.0.0.11/24 dev eth0
+ip -net "$ns2" addr add 10.0.0.12/24 dev eth0
 
 test_ebtables_broute()
 {
-	local cipt
-
 	# redirect is needed so the dstmac is rewritten to the bridge itself,
 	# ip stack won't process OTHERHOST (foreign unicast mac) packets.
-	ip netns exec ns0 ebtables -t broute -A BROUTING -p ipv4 --ip-protocol icmp -j redirect --redirect-target=DROP
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$nsbr" ebtables -t broute -A BROUTING -p ipv4 --ip-protocol icmp -j redirect --redirect-target=DROP; then
 		echo "SKIP: Could not add ebtables broute redirect rule"
 		return $ksft_skip
 	fi
 
-	# ping netns1, expected to not work (ip forwarding is off)
-	ip netns exec ns1 ping -q -c 1 10.0.0.12 > /dev/null 2>&1
-	if [ $? -eq 0 ]; then
+	ip netns exec "$nsbr" sysctl -q net.ipv4.conf.veth0.forwarding=0
+
+	# ping net${ns1}, expected to not work (ip forwarding is off)
+	if ip netns exec "$ns1" ping -q -c 1 10.0.0.12 -W 0.5 > /dev/null 2>&1; then
 		echo "ERROR: ping works, should have failed" 1>&2
 		return 1
 	fi
 
 	# enable forwarding on both interfaces.
 	# neither needs an ip address, but at least the bridge needs
-	# an ip address in same network segment as ns1 and ns2 (ns0
+	# an ip address in same network segment as ${ns1} and ${ns2} (${nsbr}
 	# needs to be able to determine route for to-be-forwarded packet).
-	ip netns exec ns0 sysctl -q net.ipv4.conf.veth0.forwarding=1
-	ip netns exec ns0 sysctl -q net.ipv4.conf.veth1.forwarding=1
-
-	sleep 1
+	ip netns exec "$nsbr" sysctl -q net.ipv4.conf.veth0.forwarding=1
+	ip netns exec "$nsbr" sysctl -q net.ipv4.conf.veth1.forwarding=1
 
-	ip netns exec ns1 ping -q -c 1 10.0.0.12 > /dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns1" ping -q -c 1 10.0.0.12 > /dev/null; then
 		echo "ERROR: ping did not work, but it should (broute+forward)" 1>&2
 		return 1
 	fi
 
-	echo "PASS: ns1/ns2 connectivity with active broute rule"
-	ip netns exec ns0 ebtables -t broute -F
+	echo "PASS: ${ns1}/${ns2} connectivity with active broute rule"
+	ip netns exec "$nsbr" ebtables -t broute -F
 
-	# ping netns1, expected to work (frames are bridged)
-	ip netns exec ns1 ping -q -c 1 10.0.0.12 > /dev/null
-	if [ $? -ne 0 ]; then
+	# ping net${ns1}, expected to work (frames are bridged)
+	if ! ip netns exec "$ns1" ping -q -c 1 10.0.0.12 > /dev/null; then
 		echo "ERROR: ping did not work, but it should (bridged)" 1>&2
 		return 1
 	fi
 
-	ip netns exec ns0 ebtables -t filter -A FORWARD -p ipv4 --ip-protocol icmp -j DROP
+	ip netns exec "$nsbr" ebtables -t filter -A FORWARD -p ipv4 --ip-protocol icmp -j DROP
 
-	# ping netns1, expected to not work (DROP in bridge forward)
-	ip netns exec ns1 ping -q -c 1 10.0.0.12 > /dev/null 2>&1
-	if [ $? -eq 0 ]; then
+	# ping net${ns1}, expected to not work (DROP in bridge forward)
+	if ip netns exec "$ns1" ping -q -c 1 10.0.0.12 -W 0.5 > /dev/null 2>&1; then
 		echo "ERROR: ping works, should have failed (icmp forward drop)" 1>&2
 		return 1
 	fi
 
 	# re-activate brouter
-	ip netns exec ns0 ebtables -t broute -A BROUTING -p ipv4 --ip-protocol icmp -j redirect --redirect-target=DROP
+	ip netns exec "$nsbr" ebtables -t broute -A BROUTING -p ipv4 --ip-protocol icmp -j redirect --redirect-target=DROP
 
-	ip netns exec ns2 ping -q -c 1 10.0.0.11 > /dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns2" ping -q -c 1 10.0.0.11 > /dev/null; then
 		echo "ERROR: ping did not work, but it should (broute+forward 2)" 1>&2
 		return 1
 	fi
 
-	echo "PASS: ns1/ns2 connectivity with active broute rule and bridge forward drop"
+	echo "PASS: ${ns1}/${ns2} connectivity with active broute rule and bridge forward drop"
 	return 0
 }
 
 # test basic connectivity
-ip netns exec ns1 ping -c 1 -q 10.0.0.12 > /dev/null
-if [ $? -ne 0 ]; then
-    echo "ERROR: Could not reach ns2 from ns1" 1>&2
-    ret=1
+if ! ip netns exec "$ns1" ping -c 1 -q 10.0.0.12 > /dev/null; then
+    echo "ERROR: Could not reach ${ns2} from ${ns1}" 1>&2
+    exit 1
 fi
 
-ip netns exec ns2 ping -c 1 -q 10.0.0.11 > /dev/null
-if [ $? -ne 0 ]; then
-    echo "ERROR: Could not reach ns1 from ns2" 1>&2
-    ret=1
-fi
-
-if [ $ret -eq 0 ];then
-    echo "PASS: netns connectivity: ns1 and ns2 can reach each other"
+if ! ip netns exec "$ns2" ping -c 1 -q 10.0.0.11 > /dev/null; then
+    echo "ERROR: Could not reach ${ns1} from ${ns2}" 1>&2
+    exit 1
 fi
 
 test_ebtables_broute
-ret=$?
-for i in 0 1 2; do ip netns del ns$i;done
-
-exit $ret
+exit $?
-- 
2.43.2

