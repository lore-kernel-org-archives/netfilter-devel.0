Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D7716C697;
	Thu, 18 Apr 2024 15:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454208; cv=none; b=VD/tCSCe+vZP1mzFnU9i3bt6rEtl7Zdg+EPdTd++KI8uE5jVR8sBTJyp7Y+RAOJVQyawuVuRx5WMEjYQWmDyJSDehVPD9CVDRC7BqxpTkp+nPV6cL3PLVAYrrgrzvpQ7Z1Y4tP6FhM8MyoJ8PzQbrA3HjaO3H0sGJ4HD9VqtDwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454208; c=relaxed/simple;
	bh=3h0NBWMzgto6BGm+sLI3ugtHWn7/B5pl7UTWSdf86Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ8vGVCI4o3mvsk1nmJCAbzrHYvemzFwRD7JIdSGcuZpv7Fh7/53mVMVUoEDXRDw4L1gjJUKzVQOkSUtRAtP6uBMOlpGmr37/mkcFubK1v6Mnrc/eI9w+F+/5cHlY46Wq49Jeup2vFjdd2C5ljhHl+Fj8H1mXhSdUsmKFgHZvUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxTi1-00007E-5B; Thu, 18 Apr 2024 17:29:57 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next v2 01/12] selftests: netfilter: nft_queue.sh: move to lib.sh infra
Date: Thu, 18 Apr 2024 17:27:29 +0200
Message-ID: <20240418152744.15105-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240418152744.15105-1-fw@strlen.de>
References: <20240418152744.15105-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- switch to socat, like other tests
- use buswait helper to test once listener netns is ready
- do not generate multiple input test files, only generate
  one and use cleanup hook to remove it, like other temporary files.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_queue.sh      | 95 +++++++------------
 1 file changed, 34 insertions(+), 61 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 2eb65887e570..9aee4169d198 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -3,16 +3,10 @@
 # This tests nf_queue:
 # 1. can process packets from all hooks
 # 2. support running nfqueue from more than one base chain
-#
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-ret=0
 
-sfx=$(mktemp -u "XXXXXXXX")
-ns1="ns1-$sfx"
-ns2="ns2-$sfx"
-nsrouter="nsrouter-$sfx"
-timeout=4
+source lib.sh
+ret=0
+timeout=2
 
 cleanup()
 {
@@ -20,9 +14,9 @@ cleanup()
 	ip netns pids ${ns2} | xargs kill 2>/dev/null
 	ip netns pids ${nsrouter} | xargs kill 2>/dev/null
 
-	ip netns del ${ns1}
-	ip netns del ${ns2}
-	ip netns del ${nsrouter}
+	cleanup_all_ns
+
+	rm -f "$TMPINPUT"
 	rm -f "$TMPFILE0"
 	rm -f "$TMPFILE1"
 	rm -f "$TMPFILE2" "$TMPFILE3"
@@ -34,26 +28,17 @@ if [ $? -ne 0 ];then
 	exit $ksft_skip
 fi
 
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
+trap cleanup EXIT
 
-ip netns add ${nsrouter}
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace"
-	exit $ksft_skip
-fi
+setup_ns ns1 ns2 nsrouter
 
 TMPFILE0=$(mktemp)
 TMPFILE1=$(mktemp)
 TMPFILE2=$(mktemp)
 TMPFILE3=$(mktemp)
-trap cleanup EXIT
 
-ip netns add ${ns1}
-ip netns add ${ns2}
+TMPINPUT=$(mktemp)
+dd conv=sparse status=none if=/dev/zero bs=1M count=200 of=$TMPINPUT
 
 ip link add veth0 netns ${nsrouter} type veth peer name eth0 netns ${ns1} > /dev/null 2>&1
 if [ $? -ne 0 ];then
@@ -62,28 +47,24 @@ if [ $? -ne 0 ];then
 fi
 ip link add veth1 netns ${nsrouter} type veth peer name eth0 netns ${ns2}
 
-ip -net ${nsrouter} link set lo up
 ip -net ${nsrouter} link set veth0 up
 ip -net ${nsrouter} addr add 10.0.1.1/24 dev veth0
-ip -net ${nsrouter} addr add dead:1::1/64 dev veth0
+ip -net ${nsrouter} addr add dead:1::1/64 dev veth0 nodad
 
 ip -net ${nsrouter} link set veth1 up
 ip -net ${nsrouter} addr add 10.0.2.1/24 dev veth1
-ip -net ${nsrouter} addr add dead:2::1/64 dev veth1
+ip -net ${nsrouter} addr add dead:2::1/64 dev veth1 nodad
 
-ip -net ${ns1} link set lo up
 ip -net ${ns1} link set eth0 up
-
-ip -net ${ns2} link set lo up
 ip -net ${ns2} link set eth0 up
 
 ip -net ${ns1} addr add 10.0.1.99/24 dev eth0
-ip -net ${ns1} addr add dead:1::99/64 dev eth0
+ip -net ${ns1} addr add dead:1::99/64 dev eth0 nodad
 ip -net ${ns1} route add default via 10.0.1.1
 ip -net ${ns1} route add default via dead:1::1
 
 ip -net ${ns2} addr add 10.0.2.99/24 dev eth0
-ip -net ${ns2} addr add dead:2::99/64 dev eth0
+ip -net ${ns2} addr add dead:2::99/64 dev eth0 nodad
 ip -net ${ns2} route add default via 10.0.2.1
 ip -net ${ns2} route add default via dead:2::1
 
@@ -161,7 +142,7 @@ test_ping() {
 
   ip netns exec ${ns1} ping -c 1 -q dead:2::99 > /dev/null
   if [ $? -ne 0 ];then
-	return 1
+	return 2
   fi
 
   return 0
@@ -170,12 +151,12 @@ test_ping() {
 test_ping_router() {
   ip netns exec ${ns1} ping -c 1 -q 10.0.2.1 > /dev/null
   if [ $? -ne 0 ];then
-	return 1
+	return 3
   fi
 
   ip netns exec ${ns1} ping -c 1 -q dead:2::1 > /dev/null
   if [ $? -ne 0 ];then
-	return 1
+	return 4
   fi
 
   return 0
@@ -257,40 +238,40 @@ test_queue()
 	echo "PASS: Expected and received $last"
 }
 
+listener_ready()
+{
+	ss -N "$1" -lnt -o "sport = :12345" | grep -q 12345
+}
+
 test_tcp_forward()
 {
 	ip netns exec ${nsrouter} ./nf_queue -q 2 -t $timeout &
 	local nfqpid=$!
 
-	tmpfile=$(mktemp) || exit 1
-	dd conv=sparse status=none if=/dev/zero bs=1M count=200 of=$tmpfile
-	ip netns exec ${ns2} nc -w 5 -l -p 12345 <"$tmpfile" >/dev/null &
+	timeout 5 ip netns exec ${ns2} socat -u TCP-LISTEN:12345 STDOUT >/dev/null &
 	local rpid=$!
 
-	sleep 1
-	ip netns exec ${ns1} nc -w 5 10.0.2.99 12345 <"$tmpfile" >/dev/null &
+	busywait $BUSYWAIT_TIMEOUT listener_ready ${ns2}
 
-	rm -f "$tmpfile"
+	ip netns exec ${ns1} socat -u STDIN TCP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
 
 	wait $rpid
-	wait $lpid
+
 	[ $? -eq 0 ] && echo "PASS: tcp and nfqueue in forward chain"
 }
 
 test_tcp_localhost()
 {
-	tmpfile=$(mktemp) || exit 1
-
-	dd conv=sparse status=none if=/dev/zero bs=1M count=200 of=$tmpfile
-	ip netns exec ${nsrouter} nc -w 5 -l -p 12345 <"$tmpfile" >/dev/null &
+	dd conv=sparse status=none if=/dev/zero bs=1M count=200 of=$TMPINPUT
+	timeout 5 ip netns exec ${nsrouter} socat -u TCP-LISTEN:12345 STDOUT >/dev/null &
 	local rpid=$!
 
 	ip netns exec ${nsrouter} ./nf_queue -q 3 -t $timeout &
 	local nfqpid=$!
 
-	sleep 1
-	ip netns exec ${nsrouter} nc -w 5 127.0.0.1 12345 <"$tmpfile" > /dev/null
-	rm -f "$tmpfile"
+	busywait $BUSYWAIT_TIMEOUT listener_ready ${nsrouter}
+
+	ip netns exec ${nsrouter} socat -u STDIN TCP:127.0.0.1:12345 <"$TMPINPUT" >/dev/null
 
 	wait $rpid
 	[ $? -eq 0 ] && echo "PASS: tcp via loopback"
@@ -299,15 +280,12 @@ test_tcp_localhost()
 
 test_tcp_localhost_connectclose()
 {
-	tmpfile=$(mktemp) || exit 1
-
 	ip netns exec ${nsrouter} ./connect_close -p 23456 -t $timeout &
 
 	ip netns exec ${nsrouter} ./nf_queue -q 3 -t $timeout &
 	local nfqpid=$!
 
 	sleep 1
-	rm -f "$tmpfile"
 
 	wait $rpid
 	[ $? -eq 0 ] && echo "PASS: tcp via loopback with connect/close"
@@ -329,9 +307,7 @@ table inet filter {
 	}
 }
 EOF
-	tmpfile=$(mktemp) || exit 1
-	dd conv=sparse status=none if=/dev/zero bs=1M count=200 of=$tmpfile
-	ip netns exec ${nsrouter} nc -w 5 -l -p 12345 <"$tmpfile" >/dev/null &
+	timeout 5 ip netns exec ${nsrouter} socat -u TCP-LISTEN:12345 STDOUT >/dev/null &
 	local rpid=$!
 
 	ip netns exec ${nsrouter} ./nf_queue -c -q 1 -t $timeout > "$TMPFILE2" &
@@ -340,9 +316,8 @@ EOF
         # re-queue the packet to nfqueue program on queue 2.
 	ip netns exec ${nsrouter} ./nf_queue -G -d 150 -c -q 0 -Q 1 -t $timeout > "$TMPFILE3" &
 
-	sleep 1
-	ip netns exec ${nsrouter} nc -w 5 127.0.0.1 12345 <"$tmpfile" > /dev/null
-	rm -f "$tmpfile"
+	busywait $BUSYWAIT_TIMEOUT listener_ready ${nsrouter}
+	ip netns exec ${nsrouter} socat -u STDIN TCP:127.0.0.1:12345 <"$TMPINPUT" > /dev/null
 
 	wait
 
@@ -409,8 +384,6 @@ ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 
 load_ruleset "filter" 0
 
-sleep 3
-
 test_ping
 ret=$?
 if [ $ret -eq 0 ];then
-- 
2.43.2

