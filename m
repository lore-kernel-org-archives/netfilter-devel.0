Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983F633ADB8;
	Tue, 25 Nov 2025 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110018; cv=none; b=qDWD3up5Dd57Eq9VDp6w99eK65nsZMH6LCr902GNi7hjZqVVD0HKwp3ipOkcHiSxSDjodkuC6+MxfGFKLrUNgXFTEh0x7GMZyBkCoKUtm9r8NokEFKJj7Pe1blTfqqwoAt08fl8vpCt9NjnS62Je9hak0sg6ae2mSwiOHMvn6F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110018; c=relaxed/simple;
	bh=9BDIA2vfL3sjr5xCRY+HzcEJX0nfB89xeEr4Kcee0uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE0lPuBiugaPGyi1n9Xd1Quiq2DxeTwN/cBWkrJzh5s/faoJHf5TmMKryfMX0TjJc0SpaK2Qf+HCVbwFKrJD79YcBvGvU0ixUuMDo4ValdK74ZhUCekW9/16MkUBhJhIhp4YX4XToRXRsDxw9SrigmsCeB0RmwsrwHyJoK9qJhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bQfbW5AE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bQfbW5AE"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 87D7360265;
	Tue, 25 Nov 2025 23:33:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764110014;
	bh=fGe6vQmMeJnlViQ7drEQi3cYNaM9YTp2uYTpqySEgog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQfbW5AEs7GsSLas5IB/p60mYCbhMZwG9lwD2FzyLCWyU9pFyXEf7B7PJo4ShRNN9
	 J3baBJYTeATLkZWh3H9gL5rRdXZjCjEm+5m4TJ4VWmXJFKk6WaGDtEY77ujg1x3Nu5
	 6qyYisQ4cTUn9jjIk6jGpGhnxpNWXVrzVPP+4EbSgCtRhLgJSaeYDEXbDmZZ1U0sp4
	 RTm74N5o08gnaEaCiHrQQnXAyVld9m7cybPvDTe2S8puzt7da7Yv9r9NFdXyuR7+6V
	 yroJ1lzq1nsycd4QWXge2IjI39M+Dj1EBAal+Bu5Kx2cy7EeDB1zfz7rbMfcWFVG8w
	 YimN96Opo6FNQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 14/16] selftests: netfilter: nft_flowtable.sh: Add the capability to send IPv6 TCP traffic
Date: Tue, 25 Nov 2025 22:33:10 +0000
Message-ID: <20251125223312.1246891-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125223312.1246891-1-pablo@netfilter.org>
References: <20251125223312.1246891-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce the capability to send TCP traffic over IPv6 to
nft_flowtable netfilter selftest.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 47 +++++++++++++------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 1fbfc8ad8dcd..24b4e60b9145 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -127,6 +127,8 @@ ip -net "$nsr1" addr add fee1:2::1/64 dev veth1 nodad
 ip -net "$nsr2" addr add 192.168.10.2/24 dev veth0
 ip -net "$nsr2" addr add fee1:2::2/64 dev veth0 nodad
 
+ip netns exec "$nsr1" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec "$nsr2" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 for i in 0 1; do
   ip netns exec "$nsr1" sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
   ip netns exec "$nsr2" sysctl net.ipv4.conf.veth$i.forwarding=1 > /dev/null
@@ -153,7 +155,9 @@ ip -net "$ns1" route add default via dead:1::1
 ip -net "$ns2" route add default via dead:2::1
 
 ip -net "$nsr1" route add default via 192.168.10.2
+ip -6 -net "$nsr1" route add default via fee1:2::2
 ip -net "$nsr2" route add default via 192.168.10.1
+ip -6 -net "$nsr2" route add default via fee1:2::1
 
 ip netns exec "$nsr1" nft -f - <<EOF
 table inet filter {
@@ -352,8 +356,9 @@ test_tcp_forwarding_ip()
 	local nsa=$1
 	local nsb=$2
 	local pmtu=$3
-	local dstip=$4
-	local dstport=$5
+	local proto=$4
+	local dstip=$5
+	local dstport=$6
 	local lret=0
 	local socatc
 	local socatl
@@ -363,12 +368,12 @@ test_tcp_forwarding_ip()
 		infile="$nsin_small"
 	fi
 
-	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsb" socat -4 TCP-LISTEN:12345,reuseaddr STDIO < "$infile" > "$ns2out" &
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsb" socat -${proto} TCP${proto}-LISTEN:12345,reuseaddr STDIO < "$infile" > "$ns2out" &
 	lpid=$!
 
 	busywait 1000 listener_ready
 
-	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsa" socat -4 TCP:"$dstip":"$dstport" STDIO < "$infile" > "$ns1out"
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsa" socat -${proto} TCP${proto}:"$dstip":"$dstport" STDIO < "$infile" > "$ns1out"
 	socatc=$?
 
 	wait $lpid
@@ -394,8 +399,11 @@ test_tcp_forwarding_ip()
 test_tcp_forwarding()
 {
 	local pmtu="$3"
+	local proto="$4"
+	local dstip="$5"
+	local dstport="$6"
 
-	test_tcp_forwarding_ip "$1" "$2" "$pmtu" 10.0.2.99 12345
+	test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstport"
 
 	return $?
 }
@@ -403,6 +411,9 @@ test_tcp_forwarding()
 test_tcp_forwarding_set_dscp()
 {
 	local pmtu="$3"
+	local proto="$4"
+	local dstip="$5"
+	local dstport="$6"
 
 ip netns exec "$nsr1" nft -f - <<EOF
 table netdev dscpmangle {
@@ -413,7 +424,7 @@ table netdev dscpmangle {
 }
 EOF
 if [ $? -eq 0 ]; then
-	test_tcp_forwarding_ip "$1" "$2" "$3" 10.0.2.99 12345
+	test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstport"
 	check_dscp "dscp_ingress" "$pmtu"
 
 	ip netns exec "$nsr1" nft delete table netdev dscpmangle
@@ -430,7 +441,7 @@ table netdev dscpmangle {
 }
 EOF
 if [ $? -eq 0 ]; then
-	test_tcp_forwarding_ip "$1" "$2" "$pmtu"  10.0.2.99 12345
+	test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstport"
 	check_dscp "dscp_egress" "$pmtu"
 
 	ip netns exec "$nsr1" nft delete table netdev dscpmangle
@@ -441,7 +452,7 @@ fi
 	# partial.  If flowtable really works, then both dscp-is-0 and dscp-is-cs3
 	# counters should have seen packets (before and after ft offload kicks in).
 	ip netns exec "$nsr1" nft -a insert rule inet filter forward ip dscp set cs3
-	test_tcp_forwarding_ip "$1" "$2" "$pmtu"  10.0.2.99 12345
+	test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstport"
 	check_dscp "dscp_fwd" "$pmtu"
 }
 
@@ -455,7 +466,7 @@ test_tcp_forwarding_nat()
 
 	[ "$pmtu" -eq 0 ] && what="$what (pmtu disabled)"
 
-	test_tcp_forwarding_ip "$nsa" "$nsb" "$pmtu" 10.0.2.99 12345
+	test_tcp_forwarding_ip "$nsa" "$nsb" "$pmtu" 4 10.0.2.99 12345
 	lret=$?
 
 	if [ "$lret" -eq 0 ] ; then
@@ -465,7 +476,7 @@ test_tcp_forwarding_nat()
 			echo "PASS: flow offload for ns1/ns2 with masquerade $what"
 		fi
 
-		test_tcp_forwarding_ip "$1" "$2" "$pmtu" 10.6.6.6 1666
+		test_tcp_forwarding_ip "$1" "$2" "$pmtu" 4 10.6.6.6 1666
 		lret=$?
 		if [ "$pmtu" -eq 1 ] ;then
 			check_counters "flow offload for ns1/ns2 with dnat $what"
@@ -487,7 +498,7 @@ make_file "$nsin_small" "$filesize_small"
 # Due to MTU mismatch in both directions, all packets (except small packets like pure
 # acks) have to be handled by normal forwarding path.  Therefore, packet counters
 # are not checked.
-if test_tcp_forwarding "$ns1" "$ns2" 0; then
+if test_tcp_forwarding "$ns1" "$ns2" 0 4 10.0.2.99 12345; then
 	echo "PASS: flow offloaded for ns1/ns2"
 else
 	echo "FAIL: flow offload for ns1/ns2:" 1>&2
@@ -495,6 +506,14 @@ else
 	ret=1
 fi
 
+if test_tcp_forwarding "$ns1" "$ns2" 0 6 "[dead:2::99]" 12345; then
+	echo "PASS: IPv6 flow offloaded for ns1/ns2"
+else
+	echo "FAIL: IPv6 flow offload for ns1/ns2:" 1>&2
+	ip netns exec "$nsr1" nft list ruleset
+	ret=1
+fi
+
 # delete default route, i.e. ns2 won't be able to reach ns1 and
 # will depend on ns1 being masqueraded in nsr1.
 # expect ns1 has nsr1 address.
@@ -520,7 +539,7 @@ table ip nat {
 EOF
 
 check_dscp "dscp_none" "0"
-if ! test_tcp_forwarding_set_dscp "$ns1" "$ns2" 0 ""; then
+if ! test_tcp_forwarding_set_dscp "$ns1" "$ns2" 0 4 10.0.2.99 12345; then
 	echo "FAIL: flow offload for ns1/ns2 with dscp update and no pmtu discovery" 1>&2
 	exit 0
 fi
@@ -546,7 +565,7 @@ ip netns exec "$ns2" sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 ip netns exec "$nsr1" nft reset counters table inet filter >/dev/null
 ip netns exec "$ns2"  nft reset counters table inet filter >/dev/null
 
-if ! test_tcp_forwarding_set_dscp "$ns1" "$ns2" 1 ""; then
+if ! test_tcp_forwarding_set_dscp "$ns1" "$ns2" 1 4 10.0.2.99 12345; then
 	echo "FAIL: flow offload for ns1/ns2 with dscp update and pmtu discovery" 1>&2
 	exit 0
 fi
@@ -752,7 +771,7 @@ ip -net "$ns2" route del 192.168.10.1 via 10.0.2.1
 ip -net "$ns2" route add default via 10.0.2.1
 ip -net "$ns2" route add default via dead:2::1
 
-if test_tcp_forwarding "$ns1" "$ns2" 1; then
+if test_tcp_forwarding "$ns1" "$ns2" 1 4 10.0.2.99 12345; then
 	check_counters "ipsec tunnel mode for ns1/ns2"
 else
 	echo "FAIL: ipsec tunnel mode for ns1/ns2"
-- 
2.47.3

