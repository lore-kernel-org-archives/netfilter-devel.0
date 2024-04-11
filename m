Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8C0482E4;
	Thu, 11 Apr 2024 23:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878987; cv=none; b=r3wIYVABPWJ5ap9vMkDUjQQWVcNXTLycqm5B7iywUHvKh3zkOTiB2M0nlF7uFwnqopDYU1wkLLBY1n9WV4bM0+U00uPb2NWWt8MZS5p+f6TJJta/rrlUqD4Htd1dcpXfcz9H36AJGXMf0HoPRvGRTVbCHaTxdpa546oakLI3R3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878987; c=relaxed/simple;
	bh=awl1Y0gRaatzbgh/lINLdMWulxxmyubrimSXFDCA3/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoRM6AnWFZtG2ct5Te1sHfLv9hBlj8aB1bf7xTBkicDqROU7ukBljDGUiuGVPJMcLJ+5nuQeL8QONrOLsRQJR3BCt5g4EdO1oN0MN2EQyAx17nDcR8tcaxPIUT5L/7bO568zIuF9z8rSabFhfOHuOl4hNht7GBlkqKdHrbR0bn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv44O-0000xP-FR; Fri, 12 Apr 2024 01:43:04 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 11/15] selftests: netfilter: nf_nat_edemux.sh: move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:16 +0200
Message-ID: <20240411233624.8129-12-fw@strlen.de>
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

While at it, use checktool helper.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nf_nat_edemux.sh  | 82 ++++++-------------
 1 file changed, 26 insertions(+), 56 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nf_nat_edemux.sh b/tools/testing/selftests/net/netfilter/nf_nat_edemux.sh
index a1aa8f4a5828..1014551dd769 100755
--- a/tools/testing/selftests/net/netfilter/nf_nat_edemux.sh
+++ b/tools/testing/selftests/net/netfilter/nf_nat_edemux.sh
@@ -4,88 +4,60 @@
 # Test NAT source port clash resolution
 #
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+source lib.sh
 ret=0
-
-sfx=$(mktemp -u "XXXXXXXX")
-ns1="ns1-$sfx"
-ns2="ns2-$sfx"
 socatpid=0
 
 cleanup()
 {
-	[ $socatpid -gt 0 ] && kill $socatpid
-	ip netns del $ns1
-	ip netns del $ns2
-}
-
-socat -h > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without socat"
-	exit $ksft_skip
-fi
-
-iptables --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without iptables"
-	exit $ksft_skip
-fi
+	[ "$socatpid" -gt 0 ] && kill "$socatpid"
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
+	cleanup_all_ns
+}
 
-ip netns add "$ns1"
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace $ns1"
-	exit $ksft_skip
-fi
+checktool "socat -h" "run test without socat"
+checktool "iptables --version" "run test without iptables"
 
 trap cleanup EXIT
 
-ip netns add $ns2
+setup_ns ns1 ns2
 
 # Connect the namespaces using a veth pair
 ip link add name veth2 type veth peer name veth1
-ip link set netns $ns1 dev veth1
-ip link set netns $ns2 dev veth2
+ip link set netns "$ns1" dev veth1
+ip link set netns "$ns2" dev veth2
 
-ip netns exec $ns1 ip link set up dev lo
-ip netns exec $ns1 ip link set up dev veth1
-ip netns exec $ns1 ip addr add 192.168.1.1/24 dev veth1
+ip netns exec "$ns1" ip link set up dev lo
+ip netns exec "$ns1" ip link set up dev veth1
+ip netns exec "$ns1" ip addr add 192.168.1.1/24 dev veth1
 
-ip netns exec $ns2 ip link set up dev lo
-ip netns exec $ns2 ip link set up dev veth2
-ip netns exec $ns2 ip addr add 192.168.1.2/24 dev veth2
+ip netns exec "$ns2" ip link set up dev lo
+ip netns exec "$ns2" ip link set up dev veth2
+ip netns exec "$ns2" ip addr add 192.168.1.2/24 dev veth2
 
 # Create a server in one namespace
-ip netns exec $ns1 socat -u TCP-LISTEN:5201,fork OPEN:/dev/null,wronly=1 &
+ip netns exec "$ns1" socat -u TCP-LISTEN:5201,fork OPEN:/dev/null,wronly=1 &
 socatpid=$!
 
 # Restrict source port to just one so we don't have to exhaust
 # all others.
-ip netns exec $ns2 sysctl -q net.ipv4.ip_local_port_range="10000 10000"
+ip netns exec "$ns2" sysctl -q net.ipv4.ip_local_port_range="10000 10000"
 
 # add a virtual IP using DNAT
-ip netns exec $ns2 iptables -t nat -A OUTPUT -d 10.96.0.1/32 -p tcp --dport 443 -j DNAT --to-destination 192.168.1.1:5201
+ip netns exec "$ns2" iptables -t nat -A OUTPUT -d 10.96.0.1/32 -p tcp --dport 443 -j DNAT --to-destination 192.168.1.1:5201
 
 # ... and route it to the other namespace
-ip netns exec $ns2 ip route add 10.96.0.1 via 192.168.1.1
-
-sleep 1
+ip netns exec "$ns2" ip route add 10.96.0.1 via 192.168.1.1
 
 # add a persistent connection from the other namespace
-ip netns exec $ns2 socat -t 10 - TCP:192.168.1.1:5201 > /dev/null &
+ip netns exec "$ns2" socat -t 10 - TCP:192.168.1.1:5201 > /dev/null &
 
 sleep 1
 
 # ip daddr:dport will be rewritten to 192.168.1.1 5201
 # NAT must reallocate source port 10000 because
 # 192.168.1.2:10000 -> 192.168.1.1:5201 is already in use
-echo test | ip netns exec $ns2 socat -t 3 -u STDIN TCP:10.96.0.1:443,connect-timeout=3 >/dev/null
+echo test | ip netns exec "$ns2" socat -t 3 -u STDIN TCP:10.96.0.1:443,connect-timeout=3 >/dev/null
 ret=$?
 
 # Check socat can connect to 10.96.0.1:443 (aka 192.168.1.1:5201).
@@ -96,16 +68,14 @@ else
 fi
 
 # check sport clashres.
-ip netns exec $ns1 iptables -t nat -A PREROUTING -p tcp --dport 5202 -j REDIRECT --to-ports 5201
-ip netns exec $ns1 iptables -t nat -A PREROUTING -p tcp --dport 5203 -j REDIRECT --to-ports 5201
+ip netns exec "$ns1" iptables -t nat -A PREROUTING -p tcp --dport 5202 -j REDIRECT --to-ports 5201
+ip netns exec "$ns1" iptables -t nat -A PREROUTING -p tcp --dport 5203 -j REDIRECT --to-ports 5201
 
-sleep 5 | ip netns exec $ns2 socat -t 5 -u STDIN TCP:192.168.1.1:5202,connect-timeout=5 >/dev/null &
-cpid1=$!
-sleep 1
+sleep 5 | ip netns exec "$ns2" socat -t 5 -u STDIN TCP:192.168.1.1:5202,connect-timeout=5 >/dev/null &
 
 # if connect succeeds, client closes instantly due to EOF on stdin.
 # if connect hangs, it will time out after 5s.
-echo | ip netns exec $ns2 socat -t 3 -u STDIN TCP:192.168.1.1:5203,connect-timeout=5 >/dev/null &
+echo | ip netns exec "$ns2" socat -t 3 -u STDIN TCP:192.168.1.1:5203,connect-timeout=5 >/dev/null &
 cpid2=$!
 
 time_then=$(date +%s)
@@ -117,7 +87,7 @@ time_now=$(date +%s)
 # 'cpid2' to connect and then exit (and no connect delay).
 delta=$((time_now - time_then))
 
-if [ $delta -lt 2 -a $rv -eq 0 ]; then
+if [ $delta -lt 2 ] && [ $rv -eq 0 ]; then
 	echo "PASS: could connect to service via redirected ports"
 else
 	echo "FAIL: socat cannot connect to service via redirect ($delta seconds elapsed, returned $rv)"
-- 
2.43.2

