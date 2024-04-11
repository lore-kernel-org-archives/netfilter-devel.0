Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485364EB24;
	Thu, 11 Apr 2024 23:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712879004; cv=none; b=sH0P9Pf8P9088ZlYVSrJ2oRZJrCwTKNHYHn/O2HNTS1fVD6sUtqlsN0nx+uVilIJ37qoQWg4jhN8PmLhWlOhNPS+X9BExrkceBTnmD02YEGz7RYp1WOPG5wI6m0tPLijYDWVrltdUwLGztDAgpiviXTNk4GnpvHg/NWF0Rx0QY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712879004; c=relaxed/simple;
	bh=KTh0xo8N2z2KoJYIbAGlw68TyhAOCn4T+DlYGwDc1bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2xkjj1bB9cM4GycDi5mGq0OHcTNccOn6IluJ6vcCB5oqi+dXlqssUMuvfR2rscl7ptHyG6cOmVevKUHBlkG95UOzSqxfdA7eDnlQLoSfVEgyuR9b3IaqCZK01recbRD8a76mrgWjIQxGytwCzEVbjeA6fEfprRRtJQirOBQIzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv44e-0000zE-R7; Fri, 12 Apr 2024 01:43:20 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 15/15] selftests: netfilter: nft_nat.sh: move to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:20 +0200
Message-ID: <20240411233624.8129-16-fw@strlen.de>
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

Use busywait helper to wait until socat listener is up to avoid "sleep" calls.
This reduces script execution time slighty (12s to 7s).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_nat.sh        | 480 ++++++++----------
 1 file changed, 206 insertions(+), 274 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_nat.sh b/tools/testing/selftests/net/netfilter/nft_nat.sh
index dd40d9f6f259..9e39de26455f 100755
--- a/tools/testing/selftests/net/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/net/netfilter/nft_nat.sh
@@ -3,77 +3,60 @@
 # This test is for basic NAT functionality: snat, dnat, redirect, masquerade.
 #
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+source lib.sh
+
 ret=0
 test_inet_nat=true
 
-sfx=$(mktemp -u "XXXXXXXX")
-ns0="ns0-$sfx"
-ns1="ns1-$sfx"
-ns2="ns2-$sfx"
+checktool "nft --version" "run test without nft tool"
+checktool "socat -h" "run test without socat"
 
 cleanup()
 {
-	for i in 0 1 2; do ip netns del ns$i-"$sfx";done
-}
+	ip netns pids "$ns0" | xargs kill 2>/dev/null
+	ip netns pids "$ns1" | xargs kill 2>/dev/null
+	ip netns pids "$ns2" | xargs kill 2>/dev/null
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without nft tool"
-	exit $ksft_skip
-fi
-
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
+	rm -f "$INFILE" "$OUTFILE"
 
-ip netns add "$ns0"
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace $ns0"
-	exit $ksft_skip
-fi
+	cleanup_all_ns
+}
 
 trap cleanup EXIT
 
-ip netns add "$ns1"
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace $ns1"
-	exit $ksft_skip
-fi
+INFILE=$(mktemp)
+OUTFILE=$(mktemp)
 
-ip netns add "$ns2"
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace $ns2"
-	exit $ksft_skip
-fi
+setup_ns ns0 ns1 ns2
 
-ip link add veth0 netns "$ns0" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1
-if [ $? -ne 0 ];then
+if ! ip link add veth0 netns "$ns0" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1;then
     echo "SKIP: No virtual ethernet pair device support in kernel"
     exit $ksft_skip
 fi
 ip link add veth1 netns "$ns0" type veth peer name eth0 netns "$ns2"
 
-ip -net "$ns0" link set lo up
 ip -net "$ns0" link set veth0 up
 ip -net "$ns0" addr add 10.0.1.1/24 dev veth0
-ip -net "$ns0" addr add dead:1::1/64 dev veth0
+ip -net "$ns0" addr add dead:1::1/64 dev veth0 nodad
 
 ip -net "$ns0" link set veth1 up
 ip -net "$ns0" addr add 10.0.2.1/24 dev veth1
-ip -net "$ns0" addr add dead:2::1/64 dev veth1
-
-for i in 1 2; do
-  ip -net ns$i-$sfx link set lo up
-  ip -net ns$i-$sfx link set eth0 up
-  ip -net ns$i-$sfx addr add 10.0.$i.99/24 dev eth0
-  ip -net ns$i-$sfx route add default via 10.0.$i.1
-  ip -net ns$i-$sfx addr add dead:$i::99/64 dev eth0
-  ip -net ns$i-$sfx route add default via dead:$i::1
-done
+ip -net "$ns0" addr add dead:2::1/64 dev veth1 nodad
+
+do_config()
+{
+	ns="$1"
+	subnet="$2"
+
+	ip -net "$ns" link set eth0 up
+	ip -net "$ns" addr add "10.0.$subnet.99/24" dev eth0
+	ip -net "$ns" route add default via "10.0.$subnet.1"
+	ip -net "$ns" addr add "dead:$subnet::99/64" dev eth0 nodad
+	ip -net "$ns" route add default via "dead:$subnet::1"
+}
+
+do_config "$ns1" 1
+do_config "$ns2" 2
 
 bad_counter()
 {
@@ -83,7 +66,7 @@ bad_counter()
 	local tag=$4
 
 	echo "ERROR: $counter counter in $ns has unexpected value (expected $expect) at $tag" 1>&2
-	ip netns exec $ns nft list counter inet filter $counter 1>&2
+	ip netns exec "$ns" nft list counter inet filter "$counter" 1>&2
 }
 
 check_counters()
@@ -91,26 +74,23 @@ check_counters()
 	ns=$1
 	local lret=0
 
-	cnt=$(ip netns exec $ns nft list counter inet filter ns0in | grep -q "packets 1 bytes 84")
-	if [ $? -ne 0 ]; then
-		bad_counter $ns ns0in "packets 1 bytes 84" "check_counters 1"
+	if ! ip netns exec "$ns" nft list counter inet filter ns0in | grep -q "packets 1 bytes 84";then
+		bad_counter "$ns" ns0in "packets 1 bytes 84" "check_counters 1"
 		lret=1
 	fi
-	cnt=$(ip netns exec $ns nft list counter inet filter ns0out | grep -q "packets 1 bytes 84")
-	if [ $? -ne 0 ]; then
-		bad_counter $ns ns0out "packets 1 bytes 84" "check_counters 2"
+
+	if ! ip netns exec "$ns" nft list counter inet filter ns0out | grep -q "packets 1 bytes 84";then
+		bad_counter "$ns" ns0out "packets 1 bytes 84" "check_counters 2"
 		lret=1
 	fi
 
 	expect="packets 1 bytes 104"
-	cnt=$(ip netns exec $ns nft list counter inet filter ns0in6 | grep -q "$expect")
-	if [ $? -ne 0 ]; then
-		bad_counter $ns ns0in6 "$expect" "check_counters 3"
+	if ! ip netns exec "$ns" nft list counter inet filter ns0in6 | grep -q "$expect";then
+		bad_counter "$ns" ns0in6 "$expect" "check_counters 3"
 		lret=1
 	fi
-	cnt=$(ip netns exec $ns nft list counter inet filter ns0out6 | grep -q "$expect")
-	if [ $? -ne 0 ]; then
-		bad_counter $ns ns0out6 "$expect" "check_counters 4"
+	if ! ip netns exec "$ns" nft list counter inet filter ns0out6 | grep -q "$expect";then
+		bad_counter "$ns" ns0out6 "$expect" "check_counters 4"
 		lret=1
 	fi
 
@@ -122,41 +102,35 @@ check_ns0_counters()
 	local ns=$1
 	local lret=0
 
-	cnt=$(ip netns exec "$ns0" nft list counter inet filter ns0in | grep -q "packets 0 bytes 0")
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" nft list counter inet filter ns0in | grep -q "packets 0 bytes 0";then
 		bad_counter "$ns0" ns0in "packets 0 bytes 0" "check_ns0_counters 1"
 		lret=1
 	fi
 
-	cnt=$(ip netns exec "$ns0" nft list counter inet filter ns0in6 | grep -q "packets 0 bytes 0")
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" nft list counter inet filter ns0in6 | grep -q "packets 0 bytes 0";then
 		bad_counter "$ns0" ns0in6 "packets 0 bytes 0"
 		lret=1
 	fi
 
-	cnt=$(ip netns exec "$ns0" nft list counter inet filter ns0out | grep -q "packets 0 bytes 0")
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" nft list counter inet filter ns0out | grep -q "packets 0 bytes 0";then
 		bad_counter "$ns0" ns0out "packets 0 bytes 0" "check_ns0_counters 2"
 		lret=1
 	fi
-	cnt=$(ip netns exec "$ns0" nft list counter inet filter ns0out6 | grep -q "packets 0 bytes 0")
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" nft list counter inet filter ns0out6 | grep -q "packets 0 bytes 0";then
 		bad_counter "$ns0" ns0out6 "packets 0 bytes 0" "check_ns0_counters3 "
 		lret=1
 	fi
 
 	for dir in "in" "out" ; do
 		expect="packets 1 bytes 84"
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ${ns}${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns0" $ns$dir "$expect" "check_ns0_counters 4"
+		if ! ip netns exec "$ns0" nft list counter inet filter "${ns}${dir}" | grep -q "$expect";then
+			bad_counter "$ns0" "$ns${dir}" "$expect" "check_ns0_counters 4"
 			lret=1
 		fi
 
 		expect="packets 1 bytes 104"
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ${ns}${dir}6 | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns0" $ns$dir6 "$expect" "check_ns0_counters 5"
+		if ! ip netns exec "$ns0" nft list counter inet filter "${ns}${dir}6" | grep -q "$expect";then
+			bad_counter "$ns0" "$ns${dir}6" "$expect" "check_ns0_counters 5"
 			lret=1
 		fi
 	done
@@ -166,8 +140,8 @@ check_ns0_counters()
 
 reset_counters()
 {
-	for i in 0 1 2;do
-		ip netns exec ns$i-$sfx nft reset counters inet > /dev/null
+	for i in "$ns0" "$ns1" "$ns2" ;do
+		ip netns exec "$i" nft reset counters inet > /dev/null
 	done
 }
 
@@ -177,7 +151,7 @@ test_local_dnat6()
 	local lret=0
 	local IPF=""
 
-	if [ $family = "inet" ];then
+	if [ "$family" = "inet" ];then
 		IPF="ip6"
 	fi
 
@@ -195,8 +169,7 @@ EOF
 	fi
 
 	# ping netns1, expect rewrite to netns2
-	ip netns exec "$ns0" ping -q -c 1 dead:1::99 > /dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" ping -q -c 1 dead:1::99 > /dev/null;then
 		lret=1
 		echo "ERROR: ping6 failed"
 		return $lret
@@ -204,8 +177,7 @@ EOF
 
 	expect="packets 0 bytes 0"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
 			bad_counter "$ns0" ns1$dir "$expect" "test_local_dnat6 1"
 			lret=1
 		fi
@@ -213,8 +185,7 @@ EOF
 
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
 			bad_counter "$ns0" ns2$dir "$expect" "test_local_dnat6 2"
 			lret=1
 		fi
@@ -223,8 +194,7 @@ EOF
 	# expect 0 count in ns1
 	expect="packets 0 bytes 0"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns0${dir}" | grep -q "$expect";then
 			bad_counter "$ns1" ns0$dir "$expect" "test_local_dnat6 3"
 			lret=1
 		fi
@@ -233,8 +203,7 @@ EOF
 	# expect 1 packet in ns2
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns0${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns2" nft list counter inet filter "ns0${dir}" | grep -q "$expect";then
 			bad_counter "$ns2" ns0$dir "$expect" "test_local_dnat6 4"
 			lret=1
 		fi
@@ -252,7 +221,7 @@ test_local_dnat()
 	local lret=0
 	local IPF=""
 
-	if [ $family = "inet" ];then
+	if [ "$family" = "inet" ];then
 		IPF="ip"
 	fi
 
@@ -265,7 +234,7 @@ table $family nat {
 }
 EOF
 	if [ $? -ne 0 ]; then
-		if [ $family = "inet" ];then
+		if [ "$family" = "inet" ];then
 			echo "SKIP: inet nat tests"
 			test_inet_nat=false
 			return $ksft_skip
@@ -275,8 +244,7 @@ EOF
 	fi
 
 	# ping netns1, expect rewrite to netns2
-	ip netns exec "$ns0" ping -q -c 1 10.0.1.99 > /dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" ping -q -c 1 10.0.1.99 > /dev/null;then
 		lret=1
 		echo "ERROR: ping failed"
 		return $lret
@@ -284,18 +252,16 @@ EOF
 
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns0" ns1$dir "$expect" "test_local_dnat 1"
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
+			bad_counter "$ns0" "ns1$dir" "$expect" "test_local_dnat 1"
 			lret=1
 		fi
 	done
 
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns0" ns2$dir "$expect" "test_local_dnat 2"
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
+			bad_counter "$ns0" "ns2$dir" "$expect" "test_local_dnat 2"
 			lret=1
 		fi
 	done
@@ -303,9 +269,8 @@ EOF
 	# expect 0 count in ns1
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns1" ns0$dir "$expect" "test_local_dnat 3"
+		if ! ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect";then
+			bad_counter "$ns1" "ns0$dir" "$expect" "test_local_dnat 3"
 			lret=1
 		fi
 	done
@@ -313,20 +278,18 @@ EOF
 	# expect 1 packet in ns2
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns0${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns2" ns0$dir "$expect" "test_local_dnat 4"
+		if ! ip netns exec "$ns2" nft list counter inet filter ns0${dir} | grep -q "$expect";then
+			bad_counter "$ns2" "ns0$dir" "$expect" "test_local_dnat 4"
 			lret=1
 		fi
 	done
 
 	test $lret -eq 0 && echo "PASS: ping to $ns1 was $family NATted to $ns2"
 
-	ip netns exec "$ns0" nft flush chain $family nat output
+	ip netns exec "$ns0" nft flush chain "$family" nat output
 
 	reset_counters
-	ip netns exec "$ns0" ping -q -c 1 10.0.1.99 > /dev/null
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" ping -q -c 1 10.0.1.99 > /dev/null;then
 		lret=1
 		echo "ERROR: ping failed"
 		return $lret
@@ -334,16 +297,14 @@ EOF
 
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
 			bad_counter "$ns1" ns1$dir "$expect" "test_local_dnat 5"
 			lret=1
 		fi
 	done
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
 			bad_counter "$ns0" ns2$dir "$expect" "test_local_dnat 6"
 			lret=1
 		fi
@@ -352,8 +313,7 @@ EOF
 	# expect 1 count in ns1
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns0${dir}" | grep -q "$expect";then
 			bad_counter "$ns0" ns0$dir "$expect" "test_local_dnat 7"
 			lret=1
 		fi
@@ -362,8 +322,7 @@ EOF
 	# expect 0 packet in ns2
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns0${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns2" nft list counter inet filter "ns0${dir}" | grep -q "$expect";then
 			bad_counter "$ns2" ns0$dir "$expect" "test_local_dnat 8"
 			lret=1
 		fi
@@ -374,13 +333,19 @@ EOF
 	return $lret
 }
 
+listener_ready()
+{
+	local ns="$1"
+	local port="$2"
+	local proto="$3"
+	ss -N "$ns" -ln "$proto" -o "sport = :$port" | grep -q "$port"
+}
+
 test_local_dnat_portonly()
 {
 	local family=$1
 	local daddr=$2
 	local lret=0
-	local sr_s
-	local sr_r
 
 ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table $family nat {
@@ -392,7 +357,7 @@ table $family nat {
 }
 EOF
 	if [ $? -ne 0 ]; then
-		if [ $family = "inet" ];then
+		if [ "$family" = "inet" ];then
 			echo "SKIP: inet port test"
 			test_inet_nat=false
 			return
@@ -401,17 +366,16 @@ EOF
 		return
 	fi
 
-	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
-	sc_s=$!
+	echo "SERVER-$family" | ip netns exec "$ns1" timeout 3 socat -u STDIN TCP-LISTEN:2000 &
 
-	sleep 1
+	busywait $BUSYWAIT_TIMEOUT listener_ready "$ns1" 2000 "-t"
 
-	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
+	result=$(ip netns exec "$ns0" timeout 1 socat -u TCP:"$daddr":2000 STDOUT)
 
 	if [ "$result" = "SERVER-inet" ];then
 		echo "PASS: inet port rewrite without l3 address"
 	else
-		echo "ERROR: inet port rewrite"
+		echo "ERROR: inet port rewrite without l3 address, got $result"
 		ret=1
 	fi
 }
@@ -424,24 +388,20 @@ test_masquerade6()
 
 	ip netns exec "$ns0" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 
-	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null;then
 		echo "ERROR: cannot ping $ns1 from $ns2 via ipv6"
 		return 1
-		lret=1
 	fi
 
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns1" ns2$dir "$expect" "test_masquerade6 1"
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
+			bad_counter "$ns1" "ns2$dir" "$expect" "test_masquerade6 1"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns2" ns1$dir "$expect" "test_masquerade6 2"
+		if ! ip netns exec "$ns2" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
+			bad_counter "$ns2" "ns1$dir" "$expect" "test_masquerade6 2"
 			lret=1
 		fi
 	done
@@ -462,8 +422,7 @@ EOF
 		return $ksft_skip
 	fi
 
-	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null;then
 		echo "ERROR: cannot ping $ns1 from $ns2 with active $family masquerade $natflags"
 		lret=1
 	fi
@@ -471,14 +430,12 @@ EOF
 	# ns1 should have seen packets from ns0, due to masquerade
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns0${dir}" | grep -q "$expect";then
 			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade6 3"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns2" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
 			bad_counter "$ns2" ns1$dir "$expect" "test_masquerade6 4"
 			lret=1
 		fi
@@ -487,27 +444,23 @@ EOF
 	# ns1 should not have seen packets from ns2, due to masquerade
 	expect="packets 0 bytes 0"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
 			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade6 5"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns0" ns1$dir "$expect" "test_masquerade6 6"
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
+			bad_counter "$ns0" "ns1$dir" "$expect" "test_masquerade6 6"
 			lret=1
 		fi
 	done
 
-	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null;then
 		echo "ERROR: cannot ping $ns1 from $ns2 with active ipv6 masquerade $natflags (attempt 2)"
 		lret=1
 	fi
 
-	ip netns exec "$ns0" nft flush chain $family nat postrouting
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" nft flush chain "$family" nat postrouting;then
 		echo "ERROR: Could not flush $family nat postrouting" 1>&2
 		lret=1
 	fi
@@ -526,23 +479,20 @@ test_masquerade()
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 
-	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping $ns1 from "$ns2" $natflags"
+	if ! ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null;then
+		echo "ERROR: cannot ping $ns1 from $ns2 $natflags"
 		lret=1
 	fi
 
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns1" ns2$dir "$expect" "test_masquerade 1"
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
+			bad_counter "$ns1" "ns2$dir" "$expect" "test_masquerade 1"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns2" ns1$dir "$expect" "test_masquerade 2"
+		if ! ip netns exec "$ns2" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
+			bad_counter "$ns2" "ns1$dir" "$expect" "test_masquerade 2"
 			lret=1
 		fi
 	done
@@ -563,8 +513,7 @@ EOF
 		return $ksft_skip
 	fi
 
-	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null;then
 		echo "ERROR: cannot ping $ns1 from $ns2 with active $family masquerade $natflags"
 		lret=1
 	fi
@@ -572,15 +521,13 @@ EOF
 	# ns1 should have seen packets from ns0, due to masquerade
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade 3"
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns0${dir}" | grep -q "$expect";then
+			bad_counter "$ns1" "ns0$dir" "$expect" "test_masquerade 3"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns2" ns1$dir "$expect" "test_masquerade 4"
+		if ! ip netns exec "$ns2" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
+			bad_counter "$ns2" "ns1$dir" "$expect" "test_masquerade 4"
 			lret=1
 		fi
 	done
@@ -588,27 +535,23 @@ EOF
 	# ns1 should not have seen packets from ns2, due to masquerade
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade 5"
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
+			bad_counter "$ns1" "ns0$dir" "$expect" "test_masquerade 5"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns0" ns1$dir "$expect" "test_masquerade 6"
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
+			bad_counter "$ns0" "ns1$dir" "$expect" "test_masquerade 6"
 			lret=1
 		fi
 	done
 
-	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null;then
 		echo "ERROR: cannot ping $ns1 from $ns2 with active ip masquerade $natflags (attempt 2)"
 		lret=1
 	fi
 
-	ip netns exec "$ns0" nft flush chain $family nat postrouting
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" nft flush chain "$family" nat postrouting; then
 		echo "ERROR: Could not flush $family nat postrouting" 1>&2
 		lret=1
 	fi
@@ -625,22 +568,19 @@ test_redirect6()
 
 	ip netns exec "$ns0" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 
-	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null;then
 		echo "ERROR: cannnot ping $ns1 from $ns2 via ipv6"
 		lret=1
 	fi
 
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
 			bad_counter "$ns1" ns2$dir "$expect" "test_redirect6 1"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns2" nft list counter inet filter "ns1${dir}" | grep -q "$expect";then
 			bad_counter "$ns2" ns1$dir "$expect" "test_redirect6 2"
 			lret=1
 		fi
@@ -662,8 +602,7 @@ EOF
 		return $ksft_skip
 	fi
 
-	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null;then
 		echo "ERROR: cannot ping $ns1 from $ns2 via ipv6 with active $family redirect"
 		lret=1
 	fi
@@ -671,8 +610,7 @@ EOF
 	# ns1 should have seen no packets from ns2, due to redirection
 	expect="packets 0 bytes 0"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
 			bad_counter "$ns1" ns0$dir "$expect" "test_redirect6 3"
 			lret=1
 		fi
@@ -681,15 +619,13 @@ EOF
 	# ns0 should have seen packets from ns2, due to masquerade
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
 			bad_counter "$ns1" ns0$dir "$expect" "test_redirect6 4"
 			lret=1
 		fi
 	done
 
-	ip netns exec "$ns0" nft delete table $family nat
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" nft delete table "$family" nat;then
 		echo "ERROR: Could not delete $family nat table" 1>&2
 		lret=1
 	fi
@@ -707,22 +643,19 @@ test_redirect()
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 
-	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null;then
 		echo "ERROR: cannot ping $ns1 from $ns2"
 		lret=1
 	fi
 
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
-			bad_counter "$ns1" $ns2$dir "$expect" "test_redirect 1"
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
+			bad_counter "$ns1" "$ns2$dir" "$expect" "test_redirect 1"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect";then
 			bad_counter "$ns2" ns1$dir "$expect" "test_redirect 2"
 			lret=1
 		fi
@@ -744,8 +677,7 @@ EOF
 		return $ksft_skip
 	fi
 
-	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null;then
 		echo "ERROR: cannot ping $ns1 from $ns2 with active $family ip redirect"
 		lret=1
 	fi
@@ -754,8 +686,7 @@ EOF
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
 
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns1" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
 			bad_counter "$ns1" ns0$dir "$expect" "test_redirect 3"
 			lret=1
 		fi
@@ -764,15 +695,13 @@ EOF
 	# ns0 should have seen packets from ns2, due to masquerade
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns0" nft list counter inet filter "ns2${dir}" | grep -q "$expect";then
 			bad_counter "$ns0" ns0$dir "$expect" "test_redirect 4"
 			lret=1
 		fi
 	done
 
-	ip netns exec "$ns0" nft delete table $family nat
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" nft delete table "$family" nat;then
 		echo "ERROR: Could not delete $family nat table" 1>&2
 		lret=1
 	fi
@@ -803,13 +732,13 @@ test_port_shadow()
 	# make shadow entry, from client (ns2), going to (ns1), port 41404, sport 1405.
 	echo "fake-entry" | ip netns exec "$ns2" timeout 1 socat -u STDIN UDP:"$daddrc":41404,sourceport=1405
 
-	echo ROUTER | ip netns exec "$ns0" timeout 5 socat -u STDIN UDP4-LISTEN:1405 &
-	sc_r=$!
+	echo ROUTER | ip netns exec "$ns0" timeout 3 socat -T 3 -u STDIN UDP4-LISTEN:1405 2>/dev/null &
+	local sc_r=$!
+	echo CLIENT | ip netns exec "$ns2" timeout 3 socat -T 3 -u STDIN UDP4-LISTEN:1405,reuseport 2>/dev/null &
+	local sc_c=$!
 
-	echo CLIENT | ip netns exec "$ns2" timeout 5 socat -u STDIN UDP4-LISTEN:1405,reuseport &
-	sc_c=$!
-
-	sleep 0.3
+	busywait $BUSYWAIT_TIMEOUT listener_ready "$ns0" 1405 "-u"
+	busywait $BUSYWAIT_TIMEOUT listener_ready "$ns2" 1405 "-u"
 
 	# ns1 tries to connect to ns0:1405.  With default settings this should connect
 	# to client, it matches the conntrack entry created above.
@@ -846,7 +775,7 @@ table $family filter {
 EOF
 	test_port_shadow "port-filter" "ROUTER"
 
-	ip netns exec "$ns0" nft delete table $family filter
+	ip netns exec "$ns0" nft delete table "$family" filter
 }
 
 # This prevents port shadow of router service via notrack.
@@ -868,7 +797,7 @@ table $family raw {
 EOF
 	test_port_shadow "port-notrack" "ROUTER"
 
-	ip netns exec "$ns0" nft delete table $family raw
+	ip netns exec "$ns0" nft delete table "$family" raw
 }
 
 # This prevents port shadow of router service via sport remap.
@@ -886,21 +815,19 @@ table $family pat {
 EOF
 	test_port_shadow "pat" "ROUTER"
 
-	ip netns exec "$ns0" nft delete table $family pat
+	ip netns exec "$ns0" nft delete table "$family" pat
 }
 
 test_port_shadowing()
 {
 	local family="ip"
 
-	conntrack -h >/dev/null 2>&1
-	if [ $? -ne 0 ];then
+	if ! conntrack -h >/dev/null 2>&1;then
 		echo "SKIP: Could not run nat port shadowing test without conntrack tool"
 		return
 	fi
 
-	socat -h > /dev/null 2>&1
-	if [ $? -ne 0 ];then
+	if ! socat -h > /dev/null 2>&1;then
 		echo "SKIP: Could not run nat port shadowing test without socat tool"
 		return
 	fi
@@ -946,8 +873,7 @@ test_stateless_nat_ip()
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 
-	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null;then
 		echo "ERROR: cannot ping $ns1 from $ns2 before loading stateless rules"
 		return 1
 	fi
@@ -981,23 +907,20 @@ EOF
 
 	reset_counters
 
-	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null; then
 		echo "ERROR: cannot ping $ns1 from $ns2 with stateless rules"
 		lret=1
 	fi
 
 	# ns1 should have seen packets from .2.2, due to stateless rewrite.
 	expect="packets 1 bytes 84"
-	cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect")
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect";then
 		bad_counter "$ns1" ns0insl "$expect" "test_stateless 1"
 		lret=1
 	fi
 
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect";then
 			bad_counter "$ns2" ns1$dir "$expect" "test_stateless 2"
 			lret=1
 		fi
@@ -1006,14 +929,12 @@ EOF
 	# ns1 should not have seen packets from ns2, due to masquerade
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect";then
 			bad_counter "$ns1" ns0$dir "$expect" "test_stateless 3"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
-		if [ $? -ne 0 ]; then
+		if ! ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect";then
 			bad_counter "$ns0" ns1$dir "$expect" "test_stateless 4"
 			lret=1
 		fi
@@ -1021,8 +942,7 @@ EOF
 
 	reset_counters
 
-	socat -h > /dev/null 2>&1
-	if [ $? -ne 0 ];then
+	if ! socat -h > /dev/null 2>&1;then
 		echo "SKIP: Could not run stateless nat frag test without socat tool"
 		if [ $lret -eq 0 ]; then
 			return $ksft_skip
@@ -1032,42 +952,36 @@ EOF
 		return $lret
 	fi
 
-	local tmpfile=$(mktemp)
-	dd if=/dev/urandom of=$tmpfile bs=4096 count=1 2>/dev/null
+	dd if=/dev/urandom of="$INFILE" bs=4096 count=1 2>/dev/null
 
-	local outfile=$(mktemp)
-	ip netns exec "$ns1" timeout 3 socat -u UDP4-RECV:4233 OPEN:$outfile < /dev/null &
-	sc_r=$!
+	ip netns exec "$ns1" timeout 3 socat -u UDP4-RECV:4233 OPEN:"$OUTFILE" < /dev/null 2>/dev/null &
+
+	busywait $BUSYWAIT_TIMEOUT listener_ready "$ns1" 4233 "-u"
 
-	sleep 1
 	# re-do with large ping -> ip fragmentation
-	ip netns exec "$ns2" timeout 3 socat - UDP4-SENDTO:"10.0.1.99:4233" < "$tmpfile" > /dev/null
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec "$ns2" timeout 3 socat -u STDIN UDP4-SENDTO:"10.0.1.99:4233" < "$INFILE" > /dev/null;then
 		echo "ERROR: failed to test udp $ns1 to $ns2 with stateless ip nat" 1>&2
 		lret=1
 	fi
 
 	wait
 
-	cmp "$tmpfile" "$outfile"
-	if [ $? -ne 0 ]; then
-		ls -l "$tmpfile" "$outfile"
+	if ! cmp "$INFILE" "$OUTFILE";then
+		ls -l "$INFILE" "$OUTFILE"
 		echo "ERROR: in and output file mismatch when checking udp with stateless nat" 1>&2
 		lret=1
 	fi
 
-	rm -f "$tmpfile" "$outfile"
+	:> "$OUTFILE"
 
 	# ns1 should have seen packets from 2.2, due to stateless rewrite.
 	expect="packets 3 bytes 4164"
-	cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect")
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect";then
 		bad_counter "$ns1" ns0insl "$expect" "test_stateless 5"
 		lret=1
 	fi
 
-	ip netns exec "$ns0" nft delete table ip stateless
-	if [ $? -ne 0 ]; then
+	if ! ip netns exec "$ns0" nft delete table ip stateless; then
 		echo "ERROR: Could not delete table ip stateless" 1>&2
 		lret=1
 	fi
@@ -1078,8 +992,8 @@ EOF
 }
 
 # ip netns exec "$ns0" ping -c 1 -q 10.0.$i.99
-for i in 0 1 2; do
-ip netns exec ns$i-$sfx nft -f /dev/stdin <<EOF
+for i in "$ns0" "$ns1" "$ns2" ;do
+ip netns exec "$i" nft -f /dev/stdin <<EOF
 table inet filter {
 	counter ns0in {}
 	counter ns1in {}
@@ -1145,7 +1059,7 @@ done
 
 # special case for stateless nat check, counter needs to
 # be done before (input) ip defragmentation
-ip netns exec ns1-$sfx nft -f /dev/stdin <<EOF
+ip netns exec "$ns1" nft -f /dev/stdin <<EOF
 table inet filter {
 	counter ns0insl {}
 
@@ -1156,31 +1070,49 @@ table inet filter {
 }
 EOF
 
-sleep 3
-# test basic connectivity
-for i in 1 2; do
-  ip netns exec "$ns0" ping -c 1 -q 10.0.$i.99 > /dev/null
-  if [ $? -ne 0 ];then
-  	echo "ERROR: Could not reach other namespace(s)" 1>&2
-	ret=1
-  fi
-
-  ip netns exec "$ns0" ping -c 1 -q dead:$i::99 > /dev/null
-  if [ $? -ne 0 ];then
-	echo "ERROR: Could not reach other namespace(s) via ipv6" 1>&2
-	ret=1
-  fi
-  check_counters ns$i-$sfx
-  if [ $? -ne 0 ]; then
-	ret=1
-  fi
-
-  check_ns0_counters ns$i
-  if [ $? -ne 0 ]; then
-	ret=1
-  fi
-  reset_counters
-done
+ping_basic()
+{
+	i="$1"
+	if ! ip netns exec "$ns0" ping -c 1 -q 10.0."$i".99 > /dev/null;then
+		echo "ERROR: Could not reach other namespace(s)" 1>&2
+		ret=1
+	fi
+
+	if ! ip netns exec "$ns0" ping -c 1 -q dead:"$i"::99 > /dev/null;then
+		echo "ERROR: Could not reach other namespace(s) via ipv6" 1>&2
+		ret=1
+	fi
+}
+
+test_basic_conn()
+{
+	local nsexec
+	name="$1"
+
+	nsexec=$(eval echo \$"$1")
+
+	ping_basic 1
+	ping_basic 2
+
+	if ! check_counters "$nsexec";then
+		return 1
+	fi
+
+	if ! check_ns0_counters "$name";then
+		return 1
+	fi
+
+	reset_counters
+	return 0
+}
+
+if ! test_basic_conn "ns1" ; then
+	echo "ERROR: basic test for ns1 failed" 1>&2
+	exit 1
+fi
+if ! test_basic_conn "ns2"; then
+	echo "ERROR: basic test for ns1 failed" 1>&2
+fi
 
 if [ $ret -eq 0 ];then
 	echo "PASS: netns routing/connectivity: $ns0 can reach $ns1 and $ns2"
-- 
2.43.2

