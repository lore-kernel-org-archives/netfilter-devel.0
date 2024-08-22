Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D98188926;
	Thu, 22 Aug 2024 22:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365191; cv=none; b=CRh6k/JngPTthz6FIjDvr8xhjyYXb1EnTlkP6Yz8SDkZl7kFr4PA2WAibdMhP+BXd+yAMXIl44gqO4nPuUb5XGWyfTX1rSM6QZ8aL25lxPYHMxwlKDV0oayISy+DufXg3CWP0Jz5CAv78gCcDM5rfP6vD3OynQ1zc+BayoRw7Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365191; c=relaxed/simple;
	bh=hYzBsoSliziWJTfW9UvKyfE62os9S2NbGdT5kJ3tuGQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eY6cMdWx+m57NrKEp8m0Lp5g/0QDBYVqsDp+nhL+V5pv63+CWP4CicqIMs4P4OGQKRpTp7L7xAnMEv1GnwOeBDxUVJJ/xf+usX/HcmknFfKPSRCCe/KK/fmCgukN54wyYfIaGo4bN/ovtJM9tQjkFPOM/BalZurSAS86X8tCdzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 2/9] selftests: netfilter: nft_queue.sh: sctp coverage
Date: Fri, 23 Aug 2024 00:19:32 +0200
Message-Id: <20240822221939.157858-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240822221939.157858-1-pablo@netfilter.org>
References: <20240822221939.157858-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Antonio Ojea <aojea@google.com>

Test that nfqueue with and without GSO process SCTP packets correctly.

Joint work with Florian and Pablo.

Signed-off-by: Antonio Ojea <aojea@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/config  |  2 +
 .../selftests/net/netfilter/nft_queue.sh      | 85 ++++++++++++++++++-
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 63ef80ef47a4..b2dd4db45215 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -87,3 +87,5 @@ CONFIG_XFRM_USER=m
 CONFIG_XFRM_STATISTICS=y
 CONFIG_NET_PKTGEN=m
 CONFIG_TUN=m
+CONFIG_INET_DIAG=m
+CONFIG_SCTP_DIAG=m
diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index c61d23a8c88d..f3bdeb1271eb 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -25,6 +25,9 @@ cleanup()
 }
 
 checktool "nft --version" "test without nft tool"
+checktool "socat -h" "run test without socat"
+
+modprobe -q sctp
 
 trap cleanup EXIT
 
@@ -265,7 +268,6 @@ test_tcp_forward()
 
 test_tcp_localhost()
 {
-	dd conv=sparse status=none if=/dev/zero bs=1M count=200 of="$TMPINPUT"
 	timeout 5 ip netns exec "$nsrouter" socat -u TCP-LISTEN:12345 STDOUT >/dev/null &
 	local rpid=$!
 
@@ -375,6 +377,82 @@ EOF
 	wait 2>/dev/null
 }
 
+sctp_listener_ready()
+{
+	ss -S -N "$1" -ln -o "sport = :12345" | grep -q 12345
+}
+
+test_sctp_forward()
+{
+	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet sctpq {
+        chain forward {
+        type filter hook forward priority 0; policy accept;
+                sctp dport 12345 queue num 10
+        }
+}
+EOF
+	timeout 60 ip netns exec "$ns2" socat -u SCTP-LISTEN:12345 STDOUT > "$TMPFILE1" &
+	local rpid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" sctp_listener_ready "$ns2"
+
+	ip netns exec "$nsrouter" ./nf_queue -q 10 -G -t "$timeout" &
+	local nfqpid=$!
+
+	ip netns exec "$ns1" socat -u STDIN SCTP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
+
+	if ! ip netns exec "$nsrouter" nft delete table inet sctpq; then
+		echo "FAIL:  Could not delete sctpq table"
+		exit 1
+	fi
+
+	wait "$rpid" && echo "PASS: sctp and nfqueue in forward chain"
+
+	if ! diff -u "$TMPINPUT" "$TMPFILE1" ; then
+		echo "FAIL: lost packets?!" 1>&2
+		exit 1
+	fi
+}
+
+test_sctp_output()
+{
+        ip netns exec "$ns1" nft -f /dev/stdin <<EOF
+table inet sctpq {
+        chain output {
+        type filter hook output priority 0; policy accept;
+                sctp dport 12345 queue num 11
+        }
+}
+EOF
+	# reduce test file size, software segmentation causes sk wmem increase.
+	dd conv=sparse status=none if=/dev/zero bs=1M count=50 of="$TMPINPUT"
+
+	timeout 60 ip netns exec "$ns2" socat -u SCTP-LISTEN:12345 STDOUT > "$TMPFILE1" &
+	local rpid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" sctp_listener_ready "$ns2"
+
+	ip netns exec "$ns1" ./nf_queue -q 11 -t "$timeout" &
+	local nfqpid=$!
+
+	ip netns exec "$ns1" socat -u STDIN SCTP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
+
+	if ! ip netns exec "$ns1" nft delete table inet sctpq; then
+		echo "FAIL:  Could not delete sctpq table"
+		exit 1
+	fi
+
+	# must wait before checking completeness of output file.
+	wait "$rpid" && echo "PASS: sctp and nfqueue in output chain with GSO"
+
+	if ! diff -u "$TMPINPUT" "$TMPFILE1" ; then
+		echo "FAIL: lost packets?!" 1>&2
+		exit 1
+	fi
+}
+
 test_queue_removal()
 {
 	read tainted_then < /proc/sys/kernel/tainted
@@ -443,11 +521,16 @@ test_queue 10
 # same.  We queue to a second program as well.
 load_ruleset "filter2" 20
 test_queue 20
+ip netns exec "$ns1" nft flush ruleset
 
 test_tcp_forward
 test_tcp_localhost
 test_tcp_localhost_connectclose
 test_tcp_localhost_requeue
+test_sctp_forward
+test_sctp_output
+
+# should be last, adds vrf device in ns1 and changes routes
 test_icmp_vrf
 test_queue_removal
 
-- 
2.30.2

