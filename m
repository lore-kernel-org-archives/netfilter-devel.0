Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BB776F17
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jul 2024 11:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719919575; cv=none; b=nuunoqn2mCSbfikKfD8+CqLaU3yP6edSb5u+Nq0whyU/4+rQtkO5SM8ySZ9ho/ZATYtxxTmOaYkO6KrAtkU5i7UyHWN6PrCtRXt6iMT+03SSLo31RMLXwAT6k8rKv5KvRhy3oSuPlbfkejfdhtl8pDU+3Os3cHM5cAl0tfgA214=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719919575; c=relaxed/simple;
	bh=oX0t9YsUZC93M1Gjii8f/m4lQfw+RR07GcJm5Ub68Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=khJKGgZlP6pfPPhytRSoA7Qtxqk/XULN/RxUVDwVZsOhSlMH0TT8bSebPBNW6TZFSO5uEid+wU7dBkaM5PX26T+znWDsLpYyCdESo9zvj8OFtt8Txt24vxkQF6Ojp5z4zNvixUgl7t3toQklIbm8Mu+5vudG530TFXNRMeUPpFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sObeE-0006qW-K4; Tue, 02 Jul 2024 13:26:10 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Antonio Ojea <aojea@google.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] selftests: netfilter: nft_queue.sh: sctp coverage
Date: Tue,  2 Jul 2024 13:15:36 +0200
Message-ID: <20240702111539.32432-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
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
 Squash patch of original+local fixes to make this work in netdev CI.

 Main changes:
  * update config, ss -S won't work without SCTP_DIAG=m
  * reduce file size for sctp output test.
    This is rather slow (~3mbyte/s), but I'm reluctant to just
    skb_orphan() before doing the nfnetlink_queue segmentation
    (this "fixes" the problem).
  * "wait" before comparing output file size, not after.
     Else we might get file mismatch because sender exited but
     receiver is still processing inflight packets.
  * flush existing rules
  * don't start nf_queue program first: it has an idle (no-packets-seen)
    timeout of just 2s, on slow machines this can cause exit() before
    the sender emits the init packet (-> test timeout).

 I did not find anything wrong with the sctp patch to nfnetlink_queue.

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
2.44.2

