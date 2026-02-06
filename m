Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DED242D76;
	Fri,  6 Feb 2026 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770391872; cv=none; b=T/YOjm3/ETBXZGKeXyqzy9V8SoyXb3iegu6MNnboBzsJC/aDgxg9sy65xWC93j4yzCJNlvi6Yq1wOOsTiYKhvDDN3l/Ftw+rAmvkTNDGUdH2X1pM4kSR3yY/Vnb21EDY8o256EW8I94z2miCs7ey28pDwbi4UN9y7zbnELJgP+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770391872; c=relaxed/simple;
	bh=uyN33aUCJ/8oKLfIUaYp8Ta7ulzubtTL2pXFlzzbgpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/GzbieURsBb+jOPUmEhRKwMEOaahSE/yggQavyBVUALnugX+iW6L8wGLbdDs5+KiojfWMpGYIwCzjBMNleguC4jM6XQKwfIKw14flOVnfwnHMVKWLkk3nRNmkw+elQn07TN/rwqRVTfz4tTdgIrV3pXU5XCIRpLSONvVSkYBzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D01FA60345; Fri, 06 Feb 2026 16:31:10 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 03/11] selftests: netfilter: nft_queue.sh: add udp fraglist gro test case
Date: Fri,  6 Feb 2026 16:30:40 +0100
Message-ID: <20260206153048.17570-4-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206153048.17570-1-fw@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without the preceding patch, this fails with:

FAIL: test_udp_gro_ct: Expected udp conntrack entry
FAIL: test_udp_gro_ct: Expected software segmentation to occur, had 10 and 0

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_queue.sh      | 142 +++++++++++++++++-
 1 file changed, 136 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 6136ceec45e0..139bc1211878 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -510,7 +510,7 @@ EOF
 
 udp_listener_ready()
 {
-	ss -S -N "$1" -uln -o "sport = :12345" | grep -q 12345
+	ss -S -N "$1" -uln -o "sport = :$2" | grep -q "$2"
 }
 
 output_files_written()
@@ -518,7 +518,7 @@ output_files_written()
 	test -s "$1" && test -s "$2"
 }
 
-test_udp_ct_race()
+test_udp_nat_race()
 {
         ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
 flush ruleset
@@ -545,8 +545,8 @@ EOF
 	ip netns exec "$nsrouter" ./nf_queue -q 12 -d 1000 &
 	local nfqpid=$!
 
-	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns2"
-	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns3"
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns2" 12345
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns3" 12345
 	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 12
 
 	# Send two packets, one should end up in ns1, other in ns2.
@@ -557,7 +557,7 @@ EOF
 
 	busywait 10000 output_files_written "$TMPFILE1" "$TMPFILE2"
 
-	kill "$nfqpid"
+	kill "$nfqpid" "$rpid1" "$rpid2"
 
 	if ! ip netns exec "$nsrouter" bash -c 'conntrack -L -p udp --dport 12345 2>/dev/null | wc -l | grep -q "^1"'; then
 		echo "FAIL: Expected One udp conntrack entry"
@@ -585,6 +585,135 @@ EOF
 	echo "PASS: both udp receivers got one packet each"
 }
 
+# Make sure UDPGRO aggregated packets don't lose
+# their skb->nfct entry when nfqueue passes the
+# skb to userspace with software gso segmentation on.
+test_udp_gro_ct()
+{
+	local errprefix="FAIL: test_udp_gro_ct:"
+
+	ip netns exec "$nsrouter" conntrack -F 2>/dev/null
+
+        ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet udpq {
+	# Number of packets/bytes queued to userspace
+	counter toqueue { }
+	# Number of packets/bytes reinjected from userspace with 'ct new' intact
+	counter fromqueue { }
+	# These two counters should be identical and not 0.
+
+	chain prerouting {
+		type filter hook prerouting priority -300; policy accept;
+
+		# userspace sends small packets, if < 1000, UDPGRO did
+		# not kick in, but test needs a 'new' conntrack with udpgro skb.
+		meta iifname veth0 meta l4proto udp meta length > 1000 accept
+
+		# don't pick up non-gso packets and don't queue them to
+		# userspace.
+		notrack
+	}
+
+        chain postrouting {
+		type filter hook postrouting priority 0; policy accept;
+
+		# Only queue unconfirmed fraglist gro skbs to userspace.
+		udp dport 12346 ct status ! confirmed counter name "toqueue" mark set 1 queue num 1
+        }
+
+	chain validate {
+		type filter hook postrouting priority 1; policy accept;
+		# ... and only count those that were reinjected with the
+		# skb->nfct intact.
+		mark 1 counter name "fromqueue"
+	}
+}
+EOF
+	timeout 10 ip netns exec "$ns2" socat UDP-LISTEN:12346,fork,pf=ipv4 OPEN:"$TMPFILE1",trunc &
+	local rpid=$!
+
+	ip netns exec "$nsrouter" ./nf_queue -G -c -q 1 -t 2 > "$TMPFILE2" &
+	local nfqpid=$!
+
+	ip netns exec "$nsrouter" ethtool -K "veth0" rx-udp-gro-forwarding on rx-gro-list on generic-receive-offload on
+
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns2" 12346
+	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 1
+
+	local bs=512
+	local count=$(((32 * 1024 * 1024) / bs))
+	dd if=/dev/zero bs="$bs" count="$count" 2>/dev/null | for i in $(seq 1 16); do
+		timeout 5 ip netns exec "$ns1" \
+			socat -u -b 512 STDIN UDP-DATAGRAM:10.0.2.99:12346,reuseport,bind=0.0.0.0:55221 &
+	done
+
+	busywait 10000 test -s "$TMPFILE1"
+
+	kill "$rpid"
+
+	wait
+
+	local p
+	local b
+	local pqueued
+	local bqueued
+
+	c=$(ip netns exec "$nsrouter" nft list counter inet udpq "toqueue" | grep packets)
+	read p pqueued b bqueued <<EOF
+$c
+EOF
+	local preinject
+	local breinject
+	c=$(ip netns exec "$nsrouter" nft list counter inet udpq "fromqueue" | grep packets)
+	read p preinject b breinject <<EOF
+$c
+EOF
+	ip netns exec "$nsrouter" ethtool -K "veth0" rx-udp-gro-forwarding off
+	ip netns exec "$nsrouter" ethtool -K "veth1" rx-udp-gro-forwarding off
+
+	if [ "$pqueued" -eq 0 ];then
+		# happens when gro did not build at least on aggregate
+		echo "SKIP: No packets were queued"
+		return
+	fi
+
+	local saw_ct_entry=0
+	if ip netns exec "$nsrouter" bash -c 'conntrack -L -p udp --dport 12346 2>/dev/null | wc -l | grep -q "^1"'; then
+		saw_ct_entry=1
+	else
+		echo "$errprefix Expected udp conntrack entry"
+		ip netns exec "$nsrouter" conntrack -L
+		ret=1
+	fi
+
+	if [ "$pqueued" -ge "$preinject" ] ;then
+		echo "$errprefix Expected software segmentation to occur, had $pqueued and $preinject"
+		ret=1
+		return
+	fi
+
+	# sw segmentation adds extra udp and ip headers.
+	local breinject_expect=$((preinject * (512 + 20 + 8)))
+
+	if [ "$breinject" -eq "$breinject_expect" ]; then
+		if [ "$saw_ct_entry" -eq 1 ];then
+			echo "PASS: fraglist gro skb passed with conntrack entry"
+		else
+			echo "$errprefix fraglist gro skb passed without conntrack entry"
+			ret=1
+		fi
+	else
+		echo "$errprefix Counter mismatch, conntrack entry dropped by nfqueue? Queued: $pqueued, $bqueued. Post-queue: $preinject, $breinject. Expected $breinject_expect"
+		ret=1
+	fi
+
+	if ! ip netns exec "$nsrouter" nft delete table inet udpq; then
+		echo "$errprefix: Could not delete udpq table"
+		ret=1
+	fi
+}
+
 test_queue_removal()
 {
 	read tainted_then < /proc/sys/kernel/tainted
@@ -663,7 +792,8 @@ test_tcp_localhost_connectclose
 test_tcp_localhost_requeue
 test_sctp_forward
 test_sctp_output
-test_udp_ct_race
+test_udp_nat_race
+test_udp_gro_ct
 
 # should be last, adds vrf device in ns1 and changes routes
 test_icmp_vrf
-- 
2.52.0

