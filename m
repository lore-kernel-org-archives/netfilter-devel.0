Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2130C18A93F
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726666692; cv=none; b=U/3/pZoSwqI5EHcYA53/Qh+eytb9FErBV03r4Z+6aqPO5dc/lMU6/zIzBgmmb44cjbRVjZ/nITSwrZ2f3ZeG0l0ZKZlzCogRFhpxD/ZbKt+ybsTd+sKUaVsQd8tYj+vy7N9Nqf7Orm/pMxRdd9wOiPJDtYGRfkKqqs4rfPsjtTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726666692; c=relaxed/simple;
	bh=fomavL9nArJgfOo57KLGKCJ1TlSonPkB6wosb7Uz2T8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=esRbi80SPdcy5KrnK/ZhPqoISYokEWglm/PqgBXzbHIGDkRjX9D4D9P4kXGmql4iXSHNYgZdLK7q2V1F1S+SYs/y8rjizEoInWiQepOVXlYXHuNoqRhLflxA0qWyGF8Bfhu26120EaxZcJ3PmS8x2Uyfsp+ZZbxiIDZtaW9p/0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1squsi-0004Ui-EE; Wed, 18 Sep 2024 15:38:08 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Antonio Ojea <aojea@google.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] kselftest: add test for nfqueue induced conntrack race
Date: Wed, 18 Sep 2024 15:16:33 +0200
Message-ID: <20240918131637.9733-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

The netfilter race happens when two packets with the same tuple are DNATed
and enqueued with nfqueue in the postrouting hook.

Once one of the packet is reinjected it may be DNATed again to a different
destination, but the conntrack entry remains the same and the return packet
was dropped.

Based on earlier patch from Antonio Ojea.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1766
Co-developed-by: Antonio Ojea <aojea@google.com>
Signed-off-by: Antonio Ojea <aojea@google.com>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_queue.sh      | 92 ++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index d66e3c4dfec6..a9d109fcc15c 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -31,7 +31,7 @@ modprobe -q sctp
 
 trap cleanup EXIT
 
-setup_ns ns1 ns2 nsrouter
+setup_ns ns1 ns2 ns3 nsrouter
 
 TMPFILE0=$(mktemp)
 TMPFILE1=$(mktemp)
@@ -48,6 +48,7 @@ if ! ip link add veth0 netns "$nsrouter" type veth peer name eth0 netns "$ns1" >
     exit $ksft_skip
 fi
 ip link add veth1 netns "$nsrouter" type veth peer name eth0 netns "$ns2"
+ip link add veth2 netns "$nsrouter" type veth peer name eth0 netns "$ns3"
 
 ip -net "$nsrouter" link set veth0 up
 ip -net "$nsrouter" addr add 10.0.1.1/24 dev veth0
@@ -57,8 +58,13 @@ ip -net "$nsrouter" link set veth1 up
 ip -net "$nsrouter" addr add 10.0.2.1/24 dev veth1
 ip -net "$nsrouter" addr add dead:2::1/64 dev veth1 nodad
 
+ip -net "$nsrouter" link set veth2 up
+ip -net "$nsrouter" addr add 10.0.3.1/24 dev veth2
+ip -net "$nsrouter" addr add dead:3::1/64 dev veth2 nodad
+
 ip -net "$ns1" link set eth0 up
 ip -net "$ns2" link set eth0 up
+ip -net "$ns3" link set eth0 up
 
 ip -net "$ns1" addr add 10.0.1.99/24 dev eth0
 ip -net "$ns1" addr add dead:1::99/64 dev eth0 nodad
@@ -70,6 +76,11 @@ ip -net "$ns2" addr add dead:2::99/64 dev eth0 nodad
 ip -net "$ns2" route add default via 10.0.2.1
 ip -net "$ns2" route add default via dead:2::1
 
+ip -net "$ns3" addr add 10.0.3.99/24 dev eth0
+ip -net "$ns3" addr add dead:3::99/64 dev eth0 nodad
+ip -net "$ns3" route add default via 10.0.3.1
+ip -net "$ns3" route add default via dead:3::1
+
 load_ruleset() {
 	local name=$1
 	local prio=$2
@@ -473,6 +484,83 @@ EOF
 	check_output_files "$TMPINPUT" "$TMPFILE1" "sctp output"
 }
 
+udp_listener_ready()
+{
+	ss -S -N "$1" -uln -o "sport = :12345" | grep -q 12345
+}
+
+output_files_written()
+{
+	test -s "$1" && test -s "$2"
+}
+
+test_udp_ct_race()
+{
+        ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet udpq {
+	chain prerouting {
+		type nat hook prerouting priority dstnat - 5; policy accept;
+		ip daddr 10.6.6.6 udp dport 12345 counter dnat to numgen inc mod 2 map { 0 : 10.0.2.99, 1 : 10.0.3.99 }
+	}
+        chain postrouting {
+		type filter hook postrouting priority srcnat - 5; policy accept;
+		udp dport 12345 counter queue num 12
+        }
+}
+EOF
+	:> "$TMPFILE1"
+	:> "$TMPFILE2"
+
+	timeout 10 ip netns exec "$ns2" socat UDP-LISTEN:12345,fork OPEN:"$TMPFILE1",trunc &
+	local rpid1=$!
+
+	timeout 10 ip netns exec "$ns3" socat UDP-LISTEN:12345,fork OPEN:"$TMPFILE2",trunc &
+	local rpid2=$!
+
+	ip netns exec "$nsrouter" ./nf_queue -q 12 -d 1000 &
+	local nfqpid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns2"
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns3"
+	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 12
+
+	# Send two packets, one should end up in ns1, other in ns2.
+	# This is because nfqueue will delay packet for long enough so that
+	# second packet will not find existing conntrack entry.
+	echo "Packet 1" | ip netns exec "$ns1" socat STDIN UDP-DATAGRAM:10.6.6.6:12345,bind=0.0.0.0:55221
+	echo "Packet 2" | ip netns exec "$ns1" socat STDIN UDP-DATAGRAM:10.6.6.6:12345,bind=0.0.0.0:55221
+
+	busywait 10000 output_files_written "$TMPFILE1" "$TMPFILE2"
+
+	kill "$nfqpid"
+
+	if ! ip netns exec "$nsrouter" bash -c 'conntrack -L -p udp --dport 12345 2>/dev/null | wc -l | grep -q "^1"'; then
+		echo "FAIL: Expected One udp conntrack entry"
+		ip netns exec "$nsrouter" conntrack -L -p udp --dport 12345
+		ret=1
+	fi
+
+	if ! ip netns exec "$nsrouter" nft delete table inet udpq; then
+		echo "FAIL: Could not delete udpq table"
+		ret=1
+		return
+	fi
+
+	NUMLINES1=$(wc -l < "$TMPFILE1")
+	NUMLINES2=$(wc -l < "$TMPFILE2")
+
+	if [ "$NUMLINES1" -ne 1 ] || [ "$NUMLINES2" -ne 1 ]; then
+		ret=1
+		echo "FAIL: uneven udp packet distribution: $NUMLINES1 $NUMLINES2"
+		echo -n "$TMPFILE1: ";cat "$TMPFILE1"
+		echo -n "$TMPFILE2: ";cat "$TMPFILE2"
+		return
+	fi
+
+	echo "PASS: both udp receivers got one packet each"
+}
+
 test_queue_removal()
 {
 	read tainted_then < /proc/sys/kernel/tainted
@@ -512,6 +600,7 @@ EOF
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth2.forwarding=1 > /dev/null
 
 load_ruleset "filter" 0
 
@@ -549,6 +638,7 @@ test_tcp_localhost_connectclose
 test_tcp_localhost_requeue
 test_sctp_forward
 test_sctp_output
+test_udp_ct_race
 
 # should be last, adds vrf device in ns1 and changes routes
 test_icmp_vrf
-- 
2.44.2

