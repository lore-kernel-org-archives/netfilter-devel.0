Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2683613790D;
	Sun, 14 Apr 2024 23:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713135886; cv=none; b=rFd3GBSCCMw2EbIwWfIgiS33syuDxTywfVCaY0z94RFojLgpoKBxeHzUAhlqvc2aors6Lk5bclAuJDAKs6I9zMhlXMcmaXbf/TvSc5t19OW6HF2J1aLuR72ZbxBaKqIRI1tt6wvJm0Koj177/dfONCD3azYq30FUvPez5Z98maM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713135886; c=relaxed/simple;
	bh=L8cERopWrokoDtv3ZKI1wfXYyTrjRt+5ft9/V5gGWS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebj4IJfigP4IDJGcNB2Pitw9679iO+Qj79bzhuJ81XZA6NsAVBk59qQAweB19FptvPfWJPYDHWhSRRAueAUDYgt2gPmywmNECC6Pn4NGgMFHLSEtcMJvnVwRNuUIpFOB8toLrGwFmTXMMO2bQ+RO6aLSWK2KDXWVZrFAq6fP7Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rw8tn-0002Vx-Id; Mon, 15 Apr 2024 01:04:35 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 04/12] selftests: netfilter: nft_synproxy.sh: move to lib.sh infra
Date: Mon, 15 Apr 2024 00:57:16 +0200
Message-ID: <20240414225729.18451-5-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240414225729.18451-1-fw@strlen.de>
References: <20240414225729.18451-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

use checktool helper where applicable.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_synproxy.sh   | 77 +++++++------------
 1 file changed, 28 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_synproxy.sh b/tools/testing/selftests/net/netfilter/nft_synproxy.sh
index b62933b680d6..293f667a6aec 100755
--- a/tools/testing/selftests/net/netfilter/nft_synproxy.sh
+++ b/tools/testing/selftests/net/netfilter/nft_synproxy.sh
@@ -1,84 +1,65 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
-#
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-ret=0
-
-rnd=$(mktemp -u XXXXXXXX)
-nsr="nsr-$rnd"	# synproxy machine
-ns1="ns1-$rnd"  # iperf client
-ns2="ns2-$rnd"  # iperf server
+source lib.sh
 
-checktool (){
-	if ! $1 > /dev/null 2>&1; then
-		echo "SKIP: Could not $2"
-		exit $ksft_skip
-	fi
-}
+ret=0
 
 checktool "nft --version" "run test without nft tool"
-checktool "ip -Version" "run test without ip tool"
 checktool "iperf3 --version" "run test without iperf3"
-checktool "ip netns add $nsr" "create net namespace"
 
-modprobe -q nf_conntrack
+setup_ns nsr ns1 ns2
 
-ip netns add $ns1
-ip netns add $ns2
+modprobe -q nf_conntrack
 
 cleanup() {
-	ip netns pids $ns1 | xargs kill 2>/dev/null
-	ip netns pids $ns2 | xargs kill 2>/dev/null
-	ip netns del $ns1
-	ip netns del $ns2
+	ip netns pids "$ns1" | xargs kill 2>/dev/null
+	ip netns pids "$ns2" | xargs kill 2>/dev/null
 
-	ip netns del $nsr
+	cleanup_all_ns
 }
 
 trap cleanup EXIT
 
-ip link add veth0 netns $nsr type veth peer name eth0 netns $ns1
-ip link add veth1 netns $nsr type veth peer name eth0 netns $ns2
+ip link add veth0 netns "$nsr" type veth peer name eth0 netns "$ns1"
+ip link add veth1 netns "$nsr" type veth peer name eth0 netns "$ns2"
 
-for dev in lo veth0 veth1; do
-ip -net $nsr link set $dev up
+for dev in veth0 veth1; do
+	ip -net "$nsr" link set "$dev" up
 done
 
-ip -net $nsr addr add 10.0.1.1/24 dev veth0
-ip -net $nsr addr add 10.0.2.1/24 dev veth1
+ip -net "$nsr" addr add 10.0.1.1/24 dev veth0
+ip -net "$nsr" addr add 10.0.2.1/24 dev veth1
 
-ip netns exec $nsr sysctl -q net.ipv4.conf.veth0.forwarding=1
-ip netns exec $nsr sysctl -q net.ipv4.conf.veth1.forwarding=1
-ip netns exec $nsr sysctl -q net.netfilter.nf_conntrack_tcp_loose=0
+ip netns exec "$nsr" sysctl -q net.ipv4.conf.veth0.forwarding=1
+ip netns exec "$nsr" sysctl -q net.ipv4.conf.veth1.forwarding=1
+ip netns exec "$nsr" sysctl -q net.netfilter.nf_conntrack_tcp_loose=0
 
 for n in $ns1 $ns2; do
-  ip -net $n link set lo up
-  ip -net $n link set eth0 up
+  ip -net "$n" link set eth0 up
 done
-ip -net $ns1 addr add 10.0.1.99/24 dev eth0
-ip -net $ns2 addr add 10.0.2.99/24 dev eth0
-ip -net $ns1 route add default via 10.0.1.1
-ip -net $ns2 route add default via 10.0.2.1
+ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
+ip -net "$ns2" addr add 10.0.2.99/24 dev eth0
+ip -net "$ns1" route add default via 10.0.1.1
+ip -net "$ns2" route add default via 10.0.2.1
 
 # test basic connectivity
-if ! ip netns exec $ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
+if ! ip netns exec "$ns1" ping -c 1 -q 10.0.2.99 > /dev/null; then
   echo "ERROR: $ns1 cannot reach $ns2" 1>&2
   exit 1
 fi
 
-if ! ip netns exec $ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
+if ! ip netns exec "$ns2" ping -c 1 -q 10.0.1.99 > /dev/null; then
   echo "ERROR: $ns2 cannot reach $ns1" 1>&2
   exit 1
 fi
 
-ip netns exec $ns2 iperf3 -s > /dev/null 2>&1 &
+ip netns exec "$ns2" iperf3 -s > /dev/null 2>&1 &
 # ip netns exec $nsr tcpdump -vvv -n -i veth1 tcp | head -n 10 &
 
 sleep 1
 
-ip netns exec $nsr nft -f - <<EOF
+ip netns exec "$nsr" nft -f - <<EOF
 table inet filter {
    chain prerouting {
       type filter hook prerouting priority -300; policy accept;
@@ -104,12 +85,10 @@ if [ $? -ne 0 ]; then
 	exit $ksft_skip
 fi
 
-ip netns exec $ns1 timeout 5 iperf3 -c 10.0.2.99 -n $((1 * 1024 * 1024)) > /dev/null
-
-if [ $? -ne 0 ]; then
+if ! ip netns exec "$ns1" timeout 5 iperf3 -c 10.0.2.99 -n $((1 * 1024 * 1024)) > /dev/null; then
 	echo "FAIL: iperf3 returned an error" 1>&2
-	ret=$?
-	ip netns exec $nsr nft list ruleset
+	ret=1
+	ip netns exec "$nsr" nft list ruleset
 else
 	echo "PASS: synproxy connection successful"
 fi
-- 
2.43.2

