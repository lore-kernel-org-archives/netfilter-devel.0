Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC80737F015
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 15:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476607; cv=none; b=VyF+hm90e8qe1jMq0529iNDPgfy5/Zs9MoBvnOEjMlE518FGT3FSZVMFaHs041O8BM0i5cqCmH08M4MkU1KmDYxCUoPZt4wpeD/kLsci5VyVA/2xRHhQb1sVhlxTXsuUE1Q8XMcHc7VwjnhvwGLwcH2bGxZYIM/7I2CQeTz2q6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476607; c=relaxed/simple;
	bh=VwmfhluF2JeM9TBa2zHAB8/mq3bzEWet/djKNle3VfU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iT1gc8qtwmzP0DbhTuB0IsF2UTPfmaEpzcTfqhllc9osr75d9Sy37IrVZQQ2jnQZF/LEn7f730su57WfGFkxrbUa+xZafWSB0Yq4UWKGbI9L5ygYaDxwAWH51JQKdOLKf+R/eUi83vq2l2fM9HMwM0h11XEWAHuvwZezg0psIRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3B53F60336; Wed, 29 Apr 2026 17:29:56 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] conntrackd-netns-test.sh: rework for CI pipelines
Date: Wed, 29 Apr 2026 17:29:45 +0200
Message-ID: <20260429152950.12610-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1. Randomize the netns names so it won't collide with
   other tests that could run in parallel.

2. Exit with 1 if there are errors.

3. Add a 'test' parameter:
   Behaves like 'start' followed by single tcp syn plus check that this
   request can be found in the internal resp. external caches of the two
   conntrackd instances.

This script can still be used for manual testing:
'start' will keep the netns/conntrackd instances running.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../conntrackd/netns/conntrackd-netns-test.sh | 181 +++++++++++++-----
 1 file changed, 131 insertions(+), 50 deletions(-)

diff --git a/tests/conntrackd/netns/conntrackd-netns-test.sh b/tests/conntrackd/netns/conntrackd-netns-test.sh
index f6b11e26dcf7..39be56f05b21 100755
--- a/tests/conntrackd/netns/conntrackd-netns-test.sh
+++ b/tests/conntrackd/netns/conntrackd-netns-test.sh
@@ -6,71 +6,152 @@ then
 	exit 0
 fi
 
+ret=0
+R1=""
+R2=""
+NS1=""
+NS2=""
+statedir=""
+
+die() {
+	echo "Error: $@"
+	exit 1
+}
+
+warn() {
+	echo "Error: $@"
+	ret=1
+}
+
+cleanup() {
+	for n in "$R1" "$R2" "$NS1" "$NS2"; do
+		kill $(ip netns pid "$n") 2>/dev/null
+		ip netns del "$n"
+	done
+	test -d "$statedir" && (
+		rm -f "$statedir/r1"
+		rm -f "$statedir/r2"
+		rm -f "$statedir/ns1"
+		rm -f "$statedir/ns2"
+		rmdir "$statedir"
+	)
+}
+
+dump_state() {
+	statedir="$(mktemp -d -t ctd-state-XXXXXXXX)" || exit 1
+
+	echo "$R1" > "$statedir/r1"
+	echo "$R2" > "$statedir/r2"
+	echo "$NS1" > "$statedir/ns1"
+	echo "$NS2" > "$statedir/ns2"
+}
+
+restore_state() {
+	read R1 < "$statedir/r1"
+	read R2 < "$statedir/r2"
+	read NS1 < "$statedir/ns1"
+	read NS2 < "$statedir/ns2"
+}
+
 start () {
-	ip netns add ns1
-	ip netns add ns2
-	ip netns add nsr1
-	ip netns add nsr2
-
-	ip link add veth0 netns ns1 type veth peer name veth1 netns nsr1
-	ip link add veth0 netns nsr1 type veth peer name veth0 netns ns2
-	ip link add veth2 netns nsr1 type veth peer name veth0 netns nsr2
-
-	ip -net ns1 addr add 192.168.10.2/24 dev veth0
-	ip -6 -net ns1 addr add bbbb::2/64 dev veth0
-	ip -net ns1 link set up dev veth0
-	ip -net ns1 ro add 10.0.1.0/24 via 192.168.10.1 dev veth0
-	ip -6 -net ns1 ro add aaaa::/64 via bbbb::1 dev veth0
-
-	ip -net nsr1 addr add 10.0.1.1/24 dev veth0
-	ip -net nsr1 addr add 192.168.10.1/24 dev veth1
-	ip -6 -net nsr1 addr add aaaa::1/64 dev veth0
-	ip -6 -net nsr1 addr add bbbb::1/64 dev veth1
-	ip -net nsr1 link set up dev veth0
-	ip -net nsr1 link set up dev veth1
-	ip -net nsr1 route add default via 192.168.10.2
-	ip -6 -net nsr1 route add default via bbbb::2
-	ip netns exec nsr1 sysctl net.ipv4.ip_forward=1
-	ip netns exec nsr1 sysctl net.ipv6.conf.all.forwarding=1
-
-	ip -net nsr1 addr add 192.168.100.2/24 dev veth2
-	ip -6 -net nsr1 addr add cccc::2/96 dev veth2
-	ip -net nsr1 link set up dev veth2
-	ip -net nsr2 addr add 192.168.100.3/24 dev veth0
-	ip -6 -net nsr2 addr add cccc::3/96 dev veth0
-	ip -net nsr2 link set up dev veth0
-
-	ip -net ns2 addr add 10.0.1.2/24 dev veth0
-	ip -6 -net ns2 addr add aaaa::2/64 dev veth0
-	ip -net ns2 link set up dev veth0
-	ip -net ns2 route add default via 10.0.1.1
-	ip -6 -net ns2 route add default via aaaa::1
+	local rnd=$(mktemp -u XXXXXXXX)
+
+	R1="ctd-r1-$rnd"
+	R2="ctd-r2-$rnd"
+	NS1="ctd-ns1-$rnd"
+	NS2="ctd-ns2-$rnd"
+
+	for n in "$R1" "$R2" "$NS1" "$NS2"; do
+		ip netns add "$n"
+	done
+
+	ip link add veth0 netns "$NS1" type veth peer name veth1 netns "$R1"
+	ip link add veth0 netns "$R1" type veth peer name veth0 netns "$NS2"
+	ip link add veth2 netns "$R1" type veth peer name veth0 netns "$R2"
+
+	ip -net "$NS1" addr add 192.168.10.2/24 dev veth0
+	ip -6 -net "$NS1" addr add bbbb::2/64 dev veth0
+	ip -net "$NS1" link set up dev veth0
+	ip -net "$NS1" ro add 10.0.1.0/24 via 192.168.10.1 dev veth0
+	ip -6 -net "$NS1" ro add aaaa::/64 via bbbb::1 dev veth0
+
+	ip -net "$R1" addr add 10.0.1.1/24 dev veth0
+	ip -net "$R1" addr add 192.168.10.1/24 dev veth1
+	ip -6 -net "$R1" addr add aaaa::1/64 dev veth0
+	ip -6 -net "$R1" addr add bbbb::1/64 dev veth1
+	ip -net "$R1" link set up dev veth0
+	ip -net "$R1" link set up dev veth1
+	ip -net "$R1" route add default via 192.168.10.2
+	ip -6 -net "$R1" route add default via bbbb::2
+	ip netns exec "$R1" sysctl -q net.ipv4.ip_forward=1
+	ip netns exec "$R1" sysctl -q net.ipv6.conf.all.forwarding=1
+
+	ip -net "$R1" addr add 192.168.100.2/24 dev veth2
+	ip -6 -net "$R1" addr add cccc::2/96 dev veth2
+	ip -net "$R1" link set up dev veth2
+	ip -net "$R2" addr add 192.168.100.3/24 dev veth0
+	ip -6 -net "$R2" addr add cccc::3/96 dev veth0
+	ip -net "$R2" link set up dev veth0
+
+	ip -net "$NS2" addr add 10.0.1.2/24 dev veth0
+	ip -6 -net "$NS2" addr add aaaa::2/64 dev veth0
+	ip -net "$NS2" link set up dev veth0
+	ip -net "$NS2" route add default via 10.0.1.1
+	ip -6 -net "$NS2" route add default via aaaa::1
 
 	echo 1 > /proc/sys/net/netfilter/nf_log_all_netns
 
-	ip netns exec nsr1 nft -f ruleset-nsr1.nft
-	ip netns exec nsr1 conntrackd -C conntrackd-nsr1.conf -d
-	ip netns exec nsr2 conntrackd -C conntrackd-nsr2.conf -d
+	ip netns exec "$R1" nft -f ruleset-nsr1.nft
+	ip netns exec "$R1" conntrackd -C conntrackd-nsr1.conf -d
+	ip netns exec "$R2" conntrackd -C conntrackd-nsr2.conf -d
 }
 
-stop () {
-	ip netns del ns1
-	ip netns del ns2
-	ip netns del nsr1
-	ip netns del nsr2
-	killall -15 conntrackd
+selftest() {
+	# This will time out, but we only want to make sure this appears both in nsr1 and nsr2 conntrackd
+	# instances.
+	timeout 10 ip netns exec "$NS1" socat -u STDIN TCP-connect:10.0.1.31:12345 > /dev/null &
+	local pid=$!
+
+	sleep 1
+	if ! ip netns exec "$R1" conntrackd -C conntrackd-nsr1.conf -i | grep -q "src=192.168.10.2 dst=10.0.1.31"; then
+		warn "nsr1 had no record in internal cache."
+	fi
+
+	if ! ip netns exec "$R2" conntrackd -C conntrackd-nsr2.conf -e | grep -q "src=192.168.10.2 dst=10.0.1.31"; then
+		warn "nsr2 had no record in external cache."
+	fi
+
+	if [ $ret -eq 0 ];then
+		echo "PASS: Found connection in external cache in nsr2."
+		kill $pid
+	fi
 }
 
 case $1 in
 start)
+	trap cleanup EXIT
 	start
+	dump_state
+	echo "Running with: $NS1 $NS2 $R1 $R2, stop with $0 stop $statedir"
+	trap - EXIT
 	;;
 stop)
-	stop
+	if [ "$2"x = ""x ]; then
+		echo "$0 stop <statedir>"
+	fi
+	test -d "$2" || die "$2 not found"
+	statedir="$2"
+	trap cleanup EXIT
+	restore_state
+	;;
+test)
+	trap cleanup EXIT
+	start
+	selftest
 	;;
 *)
-	echo "$0 [start|stop]"
+	echo "$0 [start|stop|test]"
 	;;
 esac
 
-exit 0
+exit $ret
-- 
2.53.0

