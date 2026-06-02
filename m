Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC943E172E
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jun 2026 13:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780407137; cv=none; b=kNevbHFUD++kMCQqS2zkBCes3rZRqGkXJh3TGXhlcBxWQLBxXlUcLkYVy/aK/SyJTDH8x0vlA72nJK6uQfjPfbK+vvEwZYnSrB4ZgaTnzLya5/xtjWPppMRiUKgTMp2l7eeFaBbICsVn3AFkirMAlOew7EXy9THYW2tqW+FhSDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780407137; c=relaxed/simple;
	bh=xfMx5Ds8Eexotp8g6Kahr30y7t0CrwMshyRZfzOtDGY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S/4XKEIZbG+TwTE+8nvxDR8asHIz14OJy00EjznFVOd7NBxl6yZy7cPBn0FEh6gG3K1HqC2v0Z7nbdnj6+lEkSKV/fhAhFyetPhgktpLaaIW0SbOhn4ZPhnea3Y6tiGXP7/lz3TGyEo1RMMXEq3/QSP96BPqg6h5d4ApqFCeg8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C9B1C60337; Tue, 02 Jun 2026 15:32:07 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] selftests: nft_queue.sh: add a bridge queue test
Date: Tue,  2 Jun 2026 15:31:06 +0200
Message-ID: <20260602133109.11524-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test queueing from bridge family.
This was lacking: we queued from inet for ipv4 and ipv6 but
we had no bridge queue test so far.

Given kernel MUST validate that in/out port are still part of
a bridge device on reinject add a test case for this before
adding this check.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_queue.sh      | 66 ++++++++++++++++---
 1 file changed, 58 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index d80390848e85..7c857a2e0f34 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -85,11 +85,12 @@ ip -net "$ns3" route add default via 10.0.3.1
 ip -net "$ns3" route add default via dead:3::1
 
 load_ruleset() {
-	local name=$1
-	local prio=$2
+	local family=$1
+	local name=$2
+	local prio=$3
 
 ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
-table inet $name {
+table $family $name {
 	chain nfq {
 		ip protocol icmp queue bypass
 		icmpv6 type { "echo-request", "echo-reply" } queue num 1 bypass
@@ -228,6 +229,7 @@ nf_queue_wait()
 test_queue()
 {
 	local expected="$1"
+	local family="$2"
 	local last=""
 
 	# spawn nf_queue listeners
@@ -255,11 +257,13 @@ test_queue()
 		if [ x"$last" != x"$expected packets total" ]; then
 			echo "FAIL: Expected $expected packets total, but got $last" 1>&2
 			ip netns exec "$nsrouter" nft list ruleset
+			echo -n "$TMPFILE0: ";cat "$TMPFILE0"
+			echo -n "$TMPFILE1: ";cat "$TMPFILE1"
 			exit 1
 		fi
 	done
 
-	echo "PASS: Expected and received $last"
+	echo "PASS: Expected and received $last ($family)"
 }
 
 listener_ready()
@@ -400,6 +404,8 @@ EOF
 
 	kill "$nfqpid"
 	echo "PASS: icmp+nfqueue via vrf"
+	ip -net "$ns1" link del tvrf
+	ip netns exec "$ns1" nft flush ruleset
 }
 
 sctp_listener_ready()
@@ -814,12 +820,53 @@ EOF
 	check_tainted "queue program exiting while packets queued"
 }
 
+test_queue_bridge()
+{
+	ip -net "$nsrouter" addr flush dev veth0
+	ip -net "$nsrouter" addr flush dev veth1
+
+	ip -net "$nsrouter" link add br0 type bridge
+	ip -net "$nsrouter" link set veth0 master br0
+	ip -net "$nsrouter" link set veth1 master br0
+
+	ip -net "$nsrouter" link set br0 up
+
+	ip -net "$nsrouter" addr add 10.0.2.1/16 dev br0
+	ip -net "$nsrouter" addr add dead:2::1/64 dev br0 nodad
+
+	ip -net "$ns1" addr flush dev eth0
+	ip -net "$ns2" addr flush dev eth0
+
+	ip -net "$ns1" addr add 10.0.1.1/16 dev eth0
+	ip -net "$ns1" addr add dead:2::2/64 dev eth0 nodad
+
+	ip -net "$ns2" addr add 10.0.2.99/16 dev eth0
+	ip -net "$ns2" addr add dead:2::99/64 dev eth0 nodad
+
+	ip netns exec "$nsrouter" nft flush ruleset
+
+	ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=0 > /dev/null
+	ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=0 > /dev/null
+	ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=0 > /dev/null
+
+	if ! test_ping;then
+		echo "FAIL: netns bridge connectivity" 1>&2
+		exit $ret
+	fi
+
+	load_ruleset "bridge" "filter" 10
+	test_queue 10 "bridge"
+
+	load_ruleset "bridge" "filter2" 20
+	test_queue 20 "bridge"
+}
+
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth2.forwarding=1 > /dev/null
 
-load_ruleset "filter" 0
+load_ruleset "inet" "filter" 0
 
 if test_ping; then
 	# queue bypass works (rules were skipped, no listener)
@@ -842,11 +889,11 @@ load_counter_ruleset 10
 # 1x icmp prerouting,forward,postrouting -> 3 queue events (6 incl. reply).
 # 1x icmp prerouting,input,output postrouting -> 4 queue events incl. reply.
 # so we expect that userspace program receives 10 packets.
-test_queue 10
+test_queue 10 "inet"
 
 # same.  We queue to a second program as well.
-load_ruleset "filter2" 20
-test_queue 20
+load_ruleset "inet" "filter2" 20
+test_queue 20 "inet"
 ip netns exec "$ns1" nft flush ruleset
 
 test_tcp_forward
@@ -863,4 +910,7 @@ test_queue_stress
 test_icmp_vrf
 test_queue_removal
 
+# turns router into a bridge
+test_queue_bridge
+
 exit $ret
-- 
2.53.0

