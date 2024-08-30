Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB413175D27;
	Fri, 30 Aug 2024 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725010978; cv=none; b=S6K5p380Vks9qvHJAih11e3jUaIU+ATU00dSQLswG/YTAorbdBQ65RmwriqMlcLY8nWS0En/AFtGTpDmVl5x8reKQ6Ctx+FZioRfj/cVBsaIjGBcIuoQwISmGF//v1U40NcQzyqJwBkdwrkt4N2JwYHIINUBCVd3Z2dUUff3FCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725010978; c=relaxed/simple;
	bh=nTGWXxD/G2Dl9QjJR0mErgcAxdiHv0B1YNX0OSaVA1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I7DMhPVU7ENX4Bo/CPaTgblYc/QtmZUqDS0P0F72AzJYTnya2XcHMfwyqVCAgxm0riqHOE6DAA4bvoHiWEqyr/6+hBXbVX3vFAB+fPj0nyKfsvsO9DqKpNlkPZq8cnt7ZRj1s2XfOQmxvtSbHX8bevK8+IiBSU9YcHMsA/JLytQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sjy9V-0005Wv-LU; Fri, 30 Aug 2024 11:42:45 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] selftests: netfilter: nft_queue.sh: fix spurious timeout on debug kernel
Date: Fri, 30 Aug 2024 11:22:39 +0200
Message-ID: <20240830092254.8029-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sctp selftest is very slow on debug kernels.

Its possible that the nf_queue listener program exits due to timeout
before first sctp packet is processed.

In this case socat hangs until script times out.
Fix this by removing the -t option where possible and kill the test
program once the file transfer/socat has exited.

-t sets SO_RCVTIMEO, its inteded for the 'ping' part of the selftest
where we want to make sure that packets get reinjected properly without
skipping a second queue request.

While at it, add a helper to compare the (binary) files instead of diff.
The 'diff' part was copied from a another sub-test that compares text.

Let helper dump file sizes on error so we can see the progress made.

Tested on an old 2010-ish box with a debug kernel and 100 iterations.

This is a followup to the earlier filesize reduction change.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20240829080109.GB30766@breakpoint.cc/
Fixes: 0a8b08c554da ("selftests: netfilter: nft_queue.sh: reduce test file size for debug build")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_queue.sh      | 62 ++++++++++++-------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 9e5f423bff09..d66e3c4dfec6 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -8,7 +8,7 @@
 
 source lib.sh
 ret=0
-timeout=2
+timeout=5
 
 cleanup()
 {
@@ -255,17 +255,19 @@ listener_ready()
 
 test_tcp_forward()
 {
-	ip netns exec "$nsrouter" ./nf_queue -q 2 -t "$timeout" &
+	ip netns exec "$nsrouter" ./nf_queue -q 2 &
 	local nfqpid=$!
 
 	timeout 5 ip netns exec "$ns2" socat -u TCP-LISTEN:12345 STDOUT >/dev/null &
 	local rpid=$!
 
 	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns2"
+	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 2
 
 	ip netns exec "$ns1" socat -u STDIN TCP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
 
 	wait "$rpid" && echo "PASS: tcp and nfqueue in forward chain"
+	kill "$nfqpid"
 }
 
 test_tcp_localhost()
@@ -273,26 +275,29 @@ test_tcp_localhost()
 	timeout 5 ip netns exec "$nsrouter" socat -u TCP-LISTEN:12345 STDOUT >/dev/null &
 	local rpid=$!
 
-	ip netns exec "$nsrouter" ./nf_queue -q 3 -t "$timeout" &
+	ip netns exec "$nsrouter" ./nf_queue -q 3 &
 	local nfqpid=$!
 
 	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$nsrouter"
+	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 3
 
 	ip netns exec "$nsrouter" socat -u STDIN TCP:127.0.0.1:12345 <"$TMPINPUT" >/dev/null
 
 	wait "$rpid" && echo "PASS: tcp via loopback"
-	wait 2>/dev/null
+	kill "$nfqpid"
 }
 
 test_tcp_localhost_connectclose()
 {
-	ip netns exec "$nsrouter" ./connect_close -p 23456 -t "$timeout" &
-	ip netns exec "$nsrouter" ./nf_queue -q 3 -t "$timeout" &
+	ip netns exec "$nsrouter" ./nf_queue -q 3 &
+	local nfqpid=$!
 
 	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 3
 
+	timeout 10 ip netns exec "$nsrouter" ./connect_close -p 23456 -t 3
+
+	kill "$nfqpid"
 	wait && echo "PASS: tcp via loopback with connect/close"
-	wait 2>/dev/null
 }
 
 test_tcp_localhost_requeue()
@@ -357,7 +362,7 @@ table inet filter {
 	}
 }
 EOF
-	ip netns exec "$ns1" ./nf_queue -q 1 -t "$timeout" &
+	ip netns exec "$ns1" ./nf_queue -q 1 &
 	local nfqpid=$!
 
 	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$ns1" 1
@@ -367,6 +372,7 @@ EOF
 	for n in output post; do
 		for d in tvrf eth0; do
 			if ! ip netns exec "$ns1" nft list chain inet filter "$n" | grep -q "oifname \"$d\" icmp type echo-request counter packets 1"; then
+				kill "$nfqpid"
 				echo "FAIL: chain $n: icmp packet counter mismatch for device $d" 1>&2
 				ip netns exec "$ns1" nft list ruleset
 				ret=1
@@ -375,8 +381,8 @@ EOF
 		done
 	done
 
-	wait "$nfqpid" && echo "PASS: icmp+nfqueue via vrf"
-	wait 2>/dev/null
+	kill "$nfqpid"
+	echo "PASS: icmp+nfqueue via vrf"
 }
 
 sctp_listener_ready()
@@ -384,6 +390,22 @@ sctp_listener_ready()
 	ss -S -N "$1" -ln -o "sport = :12345" | grep -q 12345
 }
 
+check_output_files()
+{
+	local f1="$1"
+	local f2="$2"
+	local err="$3"
+
+	if ! cmp "$f1" "$f2" ; then
+		echo "FAIL: $err: input and output file differ" 1>&2
+		echo -n " Input file" 1>&2
+		ls -l "$f1" 1>&2
+		echo -n "Output file" 1>&2
+		ls -l "$f2" 1>&2
+		ret=1
+	fi
+}
+
 test_sctp_forward()
 {
 	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
@@ -400,7 +422,7 @@ EOF
 
 	busywait "$BUSYWAIT_TIMEOUT" sctp_listener_ready "$ns2"
 
-	ip netns exec "$nsrouter" ./nf_queue -q 10 -G -t "$timeout" &
+	ip netns exec "$nsrouter" ./nf_queue -q 10 -G &
 	local nfqpid=$!
 
 	ip netns exec "$ns1" socat -u STDIN SCTP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
@@ -411,11 +433,9 @@ EOF
 	fi
 
 	wait "$rpid" && echo "PASS: sctp and nfqueue in forward chain"
+	kill "$nfqpid"
 
-	if ! diff -u "$TMPINPUT" "$TMPFILE1" ; then
-		echo "FAIL: lost packets?!" 1>&2
-		exit 1
-	fi
+	check_output_files "$TMPINPUT" "$TMPFILE1" "sctp forward"
 }
 
 test_sctp_output()
@@ -429,14 +449,14 @@ table inet sctpq {
 }
 EOF
 	# reduce test file size, software segmentation causes sk wmem increase.
-	dd conv=sparse status=none if=/dev/zero bs=1M count=50 of="$TMPINPUT"
+	dd conv=sparse status=none if=/dev/zero bs=1M count=$((COUNT/2)) of="$TMPINPUT"
 
 	timeout 60 ip netns exec "$ns2" socat -u SCTP-LISTEN:12345 STDOUT > "$TMPFILE1" &
 	local rpid=$!
 
 	busywait "$BUSYWAIT_TIMEOUT" sctp_listener_ready "$ns2"
 
-	ip netns exec "$ns1" ./nf_queue -q 11 -t "$timeout" &
+	ip netns exec "$ns1" ./nf_queue -q 11 &
 	local nfqpid=$!
 
 	ip netns exec "$ns1" socat -u STDIN SCTP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
@@ -448,11 +468,9 @@ EOF
 
 	# must wait before checking completeness of output file.
 	wait "$rpid" && echo "PASS: sctp and nfqueue in output chain with GSO"
+	kill "$nfqpid"
 
-	if ! diff -u "$TMPINPUT" "$TMPFILE1" ; then
-		echo "FAIL: lost packets?!" 1>&2
-		exit 1
-	fi
+	check_output_files "$TMPINPUT" "$TMPFILE1" "sctp output"
 }
 
 test_queue_removal()
@@ -468,7 +486,7 @@ table ip filter {
 	}
 }
 EOF
-	ip netns exec "$ns1" ./nf_queue -q 0 -d 30000 -t "$timeout" &
+	ip netns exec "$ns1" ./nf_queue -q 0 -d 30000 &
 	local nfqpid=$!
 
 	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$ns1" 0
-- 
2.44.2

