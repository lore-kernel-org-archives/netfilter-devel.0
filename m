Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639181755A;
	Thu, 11 Apr 2024 23:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878962; cv=none; b=kvIiYOC9ybFiDxlKsWmS7c2bRxucbrd2OgI8jeTr5uMxGSQ29AD2vTF05smdLqrT0Uj5dzJATB+Wa/fvW0SROsBOrpx7AR/KMeSyTAx4mliHz3aovUYUITpwiM+ASeRFZEGKlS4EwPcu2tSPo9Gqw/wA1QaTgmRcbxPAQLzfI0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878962; c=relaxed/simple;
	bh=2JtBxlFN3nNMaKBv+CaQfWd6hiYEwORpfE3uEuEuwT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3q030nptOdRyY8QJhh6ut6hUej6WuvZOcZlsKK/52rijtcLJXMjzBMGd9I0CGCkiPcFUe1F1GBFfgGyba2Au9MpWdOzemAP8mqmojaybFNK9kHEbi8OiEe/PX30N9vbFn/iHJKkTzCDWnP+Cya++HBlrnSZkuW88q726GKX6tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv43z-0000uf-UY; Fri, 12 Apr 2024 01:42:39 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 05/15] selftests: netfilter: conntrack_tcp_unreplied.sh: move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:10 +0200
Message-ID: <20240411233624.8129-6-fw@strlen.de>
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

Replace nc with socat. Too many different implementations of nc
are around with incompatible options ("nc: cannot use -p and -l").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/conntrack_tcp_unreplied.sh  | 124 ++++++++----------
 1 file changed, 55 insertions(+), 69 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_tcp_unreplied.sh b/tools/testing/selftests/net/netfilter/conntrack_tcp_unreplied.sh
index e7d7bf13cff5..1f862c089028 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_tcp_unreplied.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_tcp_unreplied.sh
@@ -4,37 +4,29 @@
 # Check that UNREPLIED tcp conntrack will eventually timeout.
 #
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-ret=0
-
-waittime=20
-sfx=$(mktemp -u "XXXXXXXX")
-ns1="ns1-$sfx"
-ns2="ns2-$sfx"
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
+if ! conntrack --version > /dev/null 2>&1;then
+	echo "SKIP: Could not run test without conntrack tool"
 	exit $ksft_skip
 fi
 
+ret=0
+
 cleanup() {
-	ip netns pids $ns1 | xargs kill 2>/dev/null
-	ip netns pids $ns2 | xargs kill 2>/dev/null
+	ip netns pids "$ns1" | xargs kill 2>/dev/null
+	ip netns pids "$ns2" | xargs kill 2>/dev/null
 
-	ip netns del $ns1
-	ip netns del $ns2
+	cleanup_all_ns
 }
 
 ipv4() {
-    echo -n 192.168.$1.2
+    echo -n 192.168."$1".2
 }
 
 check_counter()
@@ -44,51 +36,53 @@ check_counter()
 	expect=$3
 	local lret=0
 
-	cnt=$(ip netns exec $ns2 nft list counter inet filter "$name" | grep -q "$expect")
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns2" nft list counter inet filter "$name" | grep -q "$expect"; then
 		echo "ERROR: counter $name in $ns2 has unexpected value (expected $expect)" 1>&2
-		ip netns exec $ns2 nft list counter inet filter "$name" 1>&2
+		ip netns exec "$ns2" nft list counter inet filter "$name" 1>&2
 		lret=1
 	fi
 
 	return $lret
 }
 
-# Create test namespaces
-ip netns add $ns1 || exit 1
-
 trap cleanup EXIT
 
-ip netns add $ns2 || exit 1
+# Create test namespaces
+setup_ns ns1 ns2
 
 # Connect the namespace to the host using a veth pair
-ip -net $ns1 link add name veth1 type veth peer name veth2
-ip -net $ns1 link set netns $ns2 dev veth2
+ip -net "$ns1" link add name veth1 type veth peer name veth2
+ip -net "$ns1" link set netns "$ns2" dev veth2
 
-ip -net $ns1 link set up dev lo
-ip -net $ns2 link set up dev lo
-ip -net $ns1 link set up dev veth1
-ip -net $ns2 link set up dev veth2
+ip -net "$ns1" link set up dev lo
+ip -net "$ns2" link set up dev lo
+ip -net "$ns1" link set up dev veth1
+ip -net "$ns2" link set up dev veth2
 
-ip -net $ns2 addr add 10.11.11.2/24 dev veth2
-ip -net $ns2 route add default via 10.11.11.1
+ip -net "$ns2" addr add 10.11.11.2/24 dev veth2
+ip -net "$ns2" route add default via 10.11.11.1
 
-ip netns exec $ns2 sysctl -q net.ipv4.conf.veth2.forwarding=1
+ip netns exec "$ns2" sysctl -q net.ipv4.conf.veth2.forwarding=1
 
 # add a rule inside NS so we enable conntrack
-ip netns exec $ns1 iptables -A INPUT -m state --state established,related -j ACCEPT
+ip netns exec "$ns1" nft -f - <<EOF
+table inet filter {
+	chain input {
+		type filter hook input priority 0; policy accept;
+		ct state established accept
+	}
+}
+EOF
 
-ip -net $ns1 addr add 10.11.11.1/24 dev veth1
-ip -net $ns1 route add 10.99.99.99 via 10.11.11.2
+ip -net "$ns1" addr add 10.11.11.1/24 dev veth1
+ip -net "$ns1" route add 10.99.99.99 via 10.11.11.2
 
 # Check connectivity works
-ip netns exec $ns1 ping -q -c 2 10.11.11.2 >/dev/null || exit 1
-
-ip netns exec $ns2 nc -l -p 8080 < /dev/null &
+ip netns exec "$ns1" ping -q -c 2 10.11.11.2 >/dev/null || exit 1
 
-# however, conntrack entries are there
+ip netns exec "$ns2" socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT &
 
-ip netns exec $ns2 nft -f - <<EOF
+ip netns exec "$ns2" nft -f - <<EOF
 table inet filter {
 	counter connreq { }
 	counter redir { }
@@ -104,17 +98,15 @@ if [ $? -ne 0 ]; then
 	exit 1
 fi
 
-ip netns exec $ns2 sysctl -q net.netfilter.nf_conntrack_tcp_timeout_syn_sent=10
+ip netns exec "$ns2" sysctl -q net.netfilter.nf_conntrack_tcp_timeout_syn_sent=10
 
 echo "INFO: connect $ns1 -> $ns2 to the virtual ip"
-ip netns exec $ns1 bash -c 'while true ; do
-	nc -p 60000 10.99.99.99 80
-	sleep 1
+ip netns exec "$ns1" bash -c 'for i in $(seq 1 $BUSYWAIT_TIMEOUT) ; do
+	socat -u STDIN TCP:10.99.99.99:80 < /dev/null
+	sleep 0.1
 	done' &
 
-sleep 1
-
-ip netns exec $ns2 nft -f - <<EOF
+ip netns exec "$ns2" nft -f - <<EOF
 table inet nat {
 	chain prerouting {
 		type nat hook prerouting priority 0; policy accept;
@@ -127,34 +119,28 @@ if [ $? -ne 0 ]; then
 	exit 1
 fi
 
-count=$(ip netns exec $ns2 conntrack -L -p tcp --dport 80 2>/dev/null | wc -l)
-if [ $count -eq 0 ]; then
+count=$(ip netns exec "$ns2" conntrack -L -p tcp --dport 80 2>/dev/null | wc -l)
+if [ "$count" -eq 0 ]; then
 	echo "ERROR: $ns2 did not pick up tcp connection from peer"
 	exit 1
 fi
 
-echo "INFO: NAT redirect added in ns $ns2, waiting for $waittime seconds for nat to take effect"
-for i in $(seq 1 $waittime); do
-	echo -n "."
-
-	sleep 1
-
-	count=$(ip netns exec $ns2 conntrack -L -p tcp --reply-port-src 8080 2>/dev/null | wc -l)
-	if [ $count -gt 0 ]; then
-		echo
-		echo "PASS: redirection took effect after $i seconds"
-		break
+wait_for_redirect()
+{
+	count=$(ip netns exec "$ns2" conntrack -L -p tcp --reply-port-src 8080 2>/dev/null | wc -l)
+	if [ "$count" -gt 0 ]; then
+		return 0
 	fi
 
-	m=$((i%20))
-	if [ $m -eq 0 ]; then
-		echo " waited for $i seconds"
-	fi
-done
+	return 1
+}
+echo "INFO: NAT redirect added in ns $ns2, waiting for $BUSYWAIT_TIMEOUT ms for nat to take effect"
+
+busywait $BUSYWAIT_TIMEOUT wait_for_redirect
+ret=$?
 
 expect="packets 1 bytes 60"
-check_counter "$ns2" "redir" "$expect"
-if [ $? -ne 0 ]; then
+if ! check_counter "$ns2" "redir" "$expect"; then
 	ret=1
 fi
 
-- 
2.43.2

