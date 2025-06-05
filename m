Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B751220FAA4;
	Thu,  5 Jun 2025 08:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749113873; cv=none; b=Qe8xIKGewCLzQjCSwM5VcCRKUgfKFV7EEx9Go6bQe7/rLjbKnkwBeJat6GI1FIZvNkmxIk/D9JMqf16CevKH2uHZsS2ZE8p1vDzYssdzysBkOSGo1T0CbfH/rYhlnTyf80BFAmy0nTonOOUgIaqWEJDso0VwouHHomdaEOh1f9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749113873; c=relaxed/simple;
	bh=OxSHRNyMZ94XZE7r7fBDo33kGy8ACOblcfHVfQg8loc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IGaHlHBgVSy00MqUl4b5JzzzzplLpDO5A3HB9B3lC+ZPknEvM9Eu3baGw4RRDI0B4tQvsQ5N+HYLsqWdS3z9Z0SiiS4lDEHr6OZPS7TOu/ZHgD6Vo0eOojq3rEXzR+Bjf2hgV0tDyqsmnl/cqAGDs83003JIvFW4QN9Q9RdW1OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lXUFaWu0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LUUqEJLZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lXUFaWu0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LUUqEJLZ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2FBD560759; Thu,  5 Jun 2025 10:57:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113870;
	bh=5FoZeIHK4v76h9r8U3m8U0omZZmKGNwVADLMP0HvhdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXUFaWu0HciygefGBxw6S9G/AjF5EdSw0GIk8FJ2iiRKjKWXMLoGK2QMJkPNdgEeF
	 3sowdpUoe1uyds2H1dQf+qjtYEGnG0TxFXbNuvbdu8DV4UFIoKA8RVdiUV/woT2e+R
	 oTDFZT3u48duNpvYZir+phWfXhAV9fXq9qMxj0pM5MEfDaUfJIn8Oqm7Kx2lFfSoCI
	 EdBvGUQAv8TMZDHddHXNtiCBDkVLo4fN8H5vhD2KwUgY8SrzybEtUPMn/y9qTcc94n
	 ileXI6CWTw0igzKMRm9xlECqM6juvbfF6ncq6c2rgLeVSyXjYOA0By2HtNzmrhsMbY
	 f4d3vbC17w+gg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BA5BB60751;
	Thu,  5 Jun 2025 10:57:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113863;
	bh=5FoZeIHK4v76h9r8U3m8U0omZZmKGNwVADLMP0HvhdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUUqEJLZnppuKEyiwKK6Ag3LYX1y+SY1d4rvZNWqwXQXsUDDXjUCaUQCWL9TbMvLI
	 tDbwuor+JHlBOaxtXf/9cJZbvO8BvN4BYvGOnBV00t/4ETI+EsesiMgJgz8iW6WTWM
	 OaIhQSsyHlUOMfY4FqLzJVULJGr2l7D3tUnYI4R45LRGQ9UgtTgzenjJPTUmb1ZMky
	 EatreicycyvW+y/E2lSNxXjbFq8I2ShP9WvOB4OseCLw7Np4TEfXFnNC7/A7cPzp1i
	 MEi7ufeB3Y9ooC8vbkVDRRRg7Vl9bEXVfCoQ2lg4i9Xp4LyahSDuvbOfPGAt53QLFX
	 hcJf0TVYB9+sw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 5/5] selftests: netfilter: nft_nat.sh: add test for reverse clash with nat
Date: Thu,  5 Jun 2025 10:57:35 +0200
Message-Id: <20250605085735.52205-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250605085735.52205-1-pablo@netfilter.org>
References: <20250605085735.52205-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

This will fail without the previous bug fix because we erronously
believe that the clashing entry went way.

However, the clash exists in the opposite direction due to an
existing nat mapping:
 PASS: IP statless for ns2-LgTIuS
 ERROR: failed to test udp ns1-x4iyOW to ns2-LgTIuS with dnat rule step 2, result: ""

This is partially adapted from test instructions from the below
ubuntu tracker.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2109889
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Shaun Brady <brady.1345@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/nft_nat.sh        | 81 +++++++++++++++++--
 1 file changed, 76 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_nat.sh b/tools/testing/selftests/net/netfilter/nft_nat.sh
index 9e39de26455f..a954754b99b3 100755
--- a/tools/testing/selftests/net/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/net/netfilter/nft_nat.sh
@@ -866,6 +866,24 @@ EOF
 	ip netns exec "$ns0" nft delete table $family nat
 }
 
+file_cmp()
+{
+	local infile="$1"
+	local outfile="$2"
+
+	if ! cmp "$infile" "$outfile";then
+		echo -n "Infile "
+		ls -l "$infile"
+		echo -n "Outfile "
+		ls -l "$outfile"
+		echo "ERROR: in and output file mismatch when checking $msg" 1>&1
+		ret=1
+		return 1
+	fi
+
+	return 0
+}
+
 test_stateless_nat_ip()
 {
 	local lret=0
@@ -966,11 +984,7 @@ EOF
 
 	wait
 
-	if ! cmp "$INFILE" "$OUTFILE";then
-		ls -l "$INFILE" "$OUTFILE"
-		echo "ERROR: in and output file mismatch when checking udp with stateless nat" 1>&2
-		lret=1
-	fi
+	file_cmp "$INFILE" "$OUTFILE" "udp with stateless nat" || lret=1
 
 	:> "$OUTFILE"
 
@@ -991,6 +1005,62 @@ EOF
 	return $lret
 }
 
+test_dnat_clash()
+{
+	local lret=0
+
+	if ! socat -h > /dev/null 2>&1;then
+		echo "SKIP: Could not run dnat clash test without socat tool"
+		[ $ret -eq 0 ] && ret=$ksft_skip
+		return $ksft_skip
+	fi
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+flush ruleset
+table ip dnat-test {
+ chain prerouting {
+  type nat hook prerouting priority dstnat; policy accept;
+  ip daddr 10.0.2.1 udp dport 1234 counter dnat to 10.0.1.1:1234
+ }
+}
+EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add dnat rules"
+		[ $ret -eq 0 ] && ret=$ksft_skip
+		return $ksft_skip
+	fi
+
+	local udpdaddr="10.0.2.1"
+	for i in 1 2;do
+		echo "PING $udpdaddr" > "$INFILE"
+		echo "PONG 10.0.1.1 step $i" | ip netns exec "$ns0" timeout 3 socat STDIO UDP4-LISTEN:1234,bind=10.0.1.1 > "$OUTFILE" 2>/dev/null &
+		local lpid=$!
+
+		busywait $BUSYWAIT_TIMEOUT listener_ready "$ns0" 1234 "-u"
+
+		result=$(ip netns exec "$ns1" timeout 3 socat STDIO UDP4-SENDTO:"$udpdaddr:1234,sourceport=4321" < "$INFILE")
+		udpdaddr="10.0.1.1"
+
+		if [ "$result" != "PONG 10.0.1.1 step $i" ] ; then
+			echo "ERROR: failed to test udp $ns1 to $ns2 with dnat rule step $i, result: \"$result\"" 1>&2
+			lret=1
+			ret=1
+		fi
+
+		wait
+
+		file_cmp "$INFILE" "$OUTFILE" "udp dnat step $i" || lret=1
+
+		:> "$OUTFILE"
+	done
+
+	test $lret -eq 0 && echo "PASS: IP dnat clash $ns1:$ns2"
+
+	ip netns exec "$ns0" nft flush ruleset
+
+	return $lret
+}
+
 # ip netns exec "$ns0" ping -c 1 -q 10.0.$i.99
 for i in "$ns0" "$ns1" "$ns2" ;do
 ip netns exec "$i" nft -f /dev/stdin <<EOF
@@ -1147,6 +1217,7 @@ $test_inet_nat && test_redirect6 inet
 
 test_port_shadowing
 test_stateless_nat_ip
+test_dnat_clash
 
 if [ $ret -ne 0 ];then
 	echo -n "FAIL: "
-- 
2.30.2

