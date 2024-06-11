Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF499172BD8
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 08:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718094906; cv=none; b=NLZbqLzeMVu63+zSwC5XoaPkFsWsy/LeHJmhFIilk1DXOTOTOEb98Sa64dr2DRkpjhiyJgDTqm++m0feMfdnJixQe3wOeAdEMC1MViKZMXOMVzvyem5NYJWqBCmzT7kTrAozdLTz7faUHTHzNo6oX5yPOTkqU72IPOE/K/JshEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718094906; c=relaxed/simple;
	bh=IC5JR52VZjO3+TPvht9hidVmCj0ru4Pogz1R4HWGEQk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r1ijSW0TfCP1CQZUpPSLNIXMe0urGQZWXcpDCNQtcc6JuVJI4JDjQa+0tFqQDDXuXP5wY+I3/TMc0FkVW4cHhvIhZg9uDPTwQfEyPGuObtX7WsS90EPvkIOD4h0gDP+rpJ3vLdzOPrieuNljRL0OZdyUMGsib78VKjbZMwsxx4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: aojea@google.com,
	fw@strlen.de
Subject: [PATCH nf-next,v4 2/2] selftests: net: netfilter: nft_queue.sh: sctp coverage
Date: Tue, 11 Jun 2024 10:34:57 +0200
Message-Id: <20240611083457.3006-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240611083457.3006-1-pablo@netfilter.org>
References: <20240611083457.3006-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Antonio Ojea <aojea@google.com>

Test that nfqueue with and without GSO process SCTP packets correctly.

Signed-off-by: Antonio Ojea <aojea@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: - use ss -S to detect listener socket reliably.
    - add test to cover SCTP GSO from output path.

 .../selftests/net/netfilter/nft_queue.sh      | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 8538f08c64c2..288b3cc55ed7 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -25,6 +25,9 @@ cleanup()
 }
 
 checktool "nft --version" "test without nft tool"
+checktool "socat -h" "run test without socat"
+
+modprobe -q sctp
 
 trap cleanup EXIT
 
@@ -375,6 +378,77 @@ EOF
 	wait 2>/dev/null
 }
 
+sctp_listener_ready()
+{
+	ss -S -N "$1" -lnt -o "sport = :12345" | grep -q 12345
+}
+
+test_sctp_forward()
+{
+	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+table inet sctpq {
+        chain forward {
+        type filter hook forward priority 0; policy accept;
+                sctp dport 12345 queue num 10
+        }
+}
+EOF
+	ip netns exec "$nsrouter" ./nf_queue -q 10 -G -t "$timeout" &
+	local nfqpid=$!
+
+	timeout 60 ip netns exec "$ns2" socat -u SCTP-LISTEN:12345 STDOUT > "$TMPFILE1" &
+	local rpid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" sctp_listener_ready "$ns2"
+
+	ip netns exec "$ns1" socat -u STDIN SCTP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
+
+	if ! ip netns exec "$nsrouter" nft delete table inet sctpq; then
+		echo "FAIL:  Could not delete sctpq table"
+		exit 1
+	fi
+
+	if ! diff -u "$TMPINPUT" "$TMPFILE1" ; then
+		echo "FAIL: lost packets?!" 1>&2
+		return
+	fi
+
+	wait "$rpid" && echo "PASS: sctp and nfqueue in forward chain"
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
+	ip netns exec "$ns1" ./nf_queue -q 11 -t "$timeout" &
+	local nfqpid=$!
+
+	timeout 60 ip netns exec "$ns2" socat -u SCTP-LISTEN:12345 STDOUT > "$TMPFILE1" &
+	local rpid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" sctp_listener_ready "$ns2"
+
+	ip netns exec "$ns1" socat -u STDIN SCTP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
+
+	if ! ip netns exec "$ns1" nft delete table inet sctpq; then
+		echo "FAIL:  Could not delete sctpq table"
+		exit 1
+	fi
+
+	if ! diff -u "$TMPINPUT" "$TMPFILE1" ; then
+		echo "FAIL: lost packets?!" 1>&2
+		return
+	fi
+
+	wait "$rpid" && echo "PASS: sctp and nfqueue in output chain with GSO"
+}
+
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
@@ -413,5 +487,7 @@ test_tcp_localhost
 test_tcp_localhost_connectclose
 test_tcp_localhost_requeue
 test_icmp_vrf
+test_sctp_forward
+test_sctp_output
 
 exit $ret
-- 
2.30.2

