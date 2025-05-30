Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD0B221D9C
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2025 10:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748601268; cv=none; b=UK2dF/b9GA3mjsJUka6kz/ULq4LUUw6Hrny8mWhZ4qng4zy07OnGd7sVqoJ1PHhf6nLpFSkhlNllMdo3C2Vl2uta8i56HaJXz1SHD4UFzZpD8Le5qovggABZImUq8wwPlT6Prsd9y7e6Al8DnMU+o+m1dWYivevIlilNw7xGMvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748601268; c=relaxed/simple;
	bh=aWVVCYbybSNYxSprfcl0z5KMBV3r7TUgwv7wRnx1znQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wl6OSN8IiNYTYtizcvORgRSiKgCDd/JWEx/qavBHTfE6WhgEQYez/Mzqw8t7n52J30QkI+BXTb9rfLU44K7sHLuB6WChNkf6hlXENmTs7OFAl6HAVffo3fAhdO2y/po+MqNz4TtTQakP5pNzCqOH3heRAWnUxeHO5dJBpkecfeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 816116048A; Fri, 30 May 2025 12:34:24 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] selftests: netfilter: nft_nat.sh: add test for reverse clash with nat
Date: Fri, 30 May 2025 12:34:03 +0200
Message-ID: <20250530103408.3767-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250530103408.3767-1-fw@strlen.de>
References: <20250530103408.3767-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.49.0

