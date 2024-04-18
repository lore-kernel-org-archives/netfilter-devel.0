Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4114A16C697;
	Thu, 18 Apr 2024 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454214; cv=none; b=J8qF/u1peRgODZGejXrTQvrcC2s5nL5LxkwnIyOLRDphJstnNcrzM+2jpTg6ckgQjM5JNWYlFQKoOBkJf4MpUgVYG7wBRB0ZNrFF3WGTp5SSGLjYtkyPH3CD5+HYOlQZTma86pZhICOQ1mOicseiv97gXfb/Ec9NPCuVjPkCXdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454214; c=relaxed/simple;
	bh=l1qijLueM6viVgjXJza1IbVOkLKxo5q6yeHXfR5VYI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUhKsunXGCOTKMmXtfKyUKt2O/Rkz80zH3jBcdzwjim9mBgFUmLfw8T3O0qqhRqhscCFj29te+T+76dVmhyGg5fdoVvITh74i5Mvnh8HXaU0jUqRfwtpnxyMuMiLlv6oTth2y2s/Ofe7xKaJ8Gmnuix3krrNmhW3W0d5Ay/IxnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxTiD-00008F-BT; Thu, 18 Apr 2024 17:30:09 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next v2 04/12] selftests: netfilter: nft_zones_many.sh: move to lib.sh infra
Date: Thu, 18 Apr 2024 17:27:32 +0200
Message-ID: <20240418152744.15105-5-fw@strlen.de>
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

Also do shellcheck cleanups here, no functional changes intended.
When running tests via vng tool, the packetpath insertion test fails:
dd: failed to open '/dev/stdout': Device or resource busy

Just omit 'of=' and this will work as intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_zones_many.sh | 93 +++++++++----------
 1 file changed, 45 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_zones_many.sh b/tools/testing/selftests/net/netfilter/nft_zones_many.sh
index 5a8db0b48928..db53de348783 100755
--- a/tools/testing/selftests/net/netfilter/nft_zones_many.sh
+++ b/tools/testing/selftests/net/netfilter/nft_zones_many.sh
@@ -3,11 +3,7 @@
 # Test insertion speed for packets with identical addresses/ports
 # that are all placed in distinct conntrack zones.
 
-sfx=$(mktemp -u "XXXXXXXX")
-ns="ns-$sfx"
-
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+source lib.sh
 
 zones=2000
 have_ct_tool=0
@@ -15,35 +11,25 @@ ret=0
 
 cleanup()
 {
-	ip netns del $ns
-}
-
-checktool (){
-	if ! $1 > /dev/null 2>&1; then
-		echo "SKIP: Could not $2"
-		exit $ksft_skip
-	fi
+	cleanup_all_ns
 }
 
 checktool "nft --version" "run test without nft tool"
-checktool "ip -Version" "run test without ip tool"
 checktool "socat -V" "run test without socat tool"
-checktool "ip netns add $ns" "create net namespace"
+
+setup_ns ns1
 
 trap cleanup EXIT
 
-conntrack -V > /dev/null 2>&1
-if [ $? -eq 0 ];then
+if conntrack -V > /dev/null 2>&1; then
 	have_ct_tool=1
 fi
 
-ip -net "$ns" link set lo up
-
 test_zones() {
 	local max_zones=$1
 
-ip netns exec $ns sysctl -q net.netfilter.nf_conntrack_udp_timeout=3600
-ip netns exec $ns nft -f /dev/stdin<<EOF
+ip netns exec "$ns1" sysctl -q net.netfilter.nf_conntrack_udp_timeout=3600
+ip netns exec "$ns1" nft -f /dev/stdin<<EOF
 flush ruleset
 table inet raw {
 	map rndzone {
@@ -56,29 +42,36 @@ table inet raw {
 	}
 }
 EOF
+if [ "$?" -ne 0 ];then
+	echo "SKIP: Cannot add nftables rules"
+	exit $ksft_skip
+fi
 	(
 		echo "add element inet raw rndzone {"
-	for i in $(seq 1 $max_zones);do
+	for i in $(seq 1 "$max_zones");do
 		echo -n "$i : $i"
-		if [ $i -lt $max_zones ]; then
+		if [ "$i" -lt "$max_zones" ]; then
 			echo ","
 		else
 			echo "}"
 		fi
 	done
-	) | ip netns exec $ns nft -f /dev/stdin
+	) | ip netns exec "$ns1" nft -f /dev/stdin
 
 	local i=0
 	local j=0
-	local outerstart=$(date +%s%3N)
-	local stop=$outerstart
-
-	while [ $i -lt $max_zones ]; do
-		local start=$(date +%s%3N)
+	local outerstart
+	local stop
+	outerstart=$(date +%s%3N)
+	stop=$outerstart
+
+	while [ "$i" -lt "$max_zones" ]; do
+		local start
+		start=$(date +%s%3N)
 		i=$((i + 1000))
 		j=$((j + 1))
 		# nft rule in output places each packet in a different zone.
-		dd if=/dev/zero of=/dev/stdout bs=8k count=1000 2>/dev/null | ip netns exec "$ns" socat STDIN UDP:127.0.0.1:12345,sourceport=12345
+		dd if=/dev/zero bs=8k count=1000 2>/dev/null | ip netns exec "$ns1" socat -u STDIN UDP:127.0.0.1:12345,sourceport=12345
 		if [ $? -ne 0 ] ;then
 			ret=1
 			break
@@ -89,14 +82,15 @@ EOF
 		echo "PASS: added 1000 entries in $duration ms (now $i total, loop $j)"
 	done
 
-	if [ $have_ct_tool -eq 1 ]; then
-		local count=$(ip netns exec "$ns" conntrack -C)
-		local duration=$((stop-outerstart))
+	if [ "$have_ct_tool" -eq 1 ]; then
+		local count duration
+		count=$(ip netns exec "$ns1" conntrack -C)
+		duration=$((stop-outerstart))
 
-		if [ $count -eq $max_zones ]; then
+		if [ "$count" -eq "$max_zones" ]; then
 			echo "PASS: inserted $count entries from packet path in $duration ms total"
 		else
-			ip netns exec $ns conntrack -S 1>&2
+			ip netns exec "$ns1" conntrack -S 1>&2
 			echo "FAIL: inserted $count entries from packet path in $duration ms total, expected $max_zones entries"
 			ret=1
 		fi
@@ -110,18 +104,19 @@ EOF
 test_conntrack_tool() {
 	local max_zones=$1
 
-	ip netns exec $ns conntrack -F >/dev/null 2>/dev/null
+	ip netns exec "$ns1" conntrack -F >/dev/null 2>/dev/null
 
-	local outerstart=$(date +%s%3N)
-	local start=$(date +%s%3N)
-	local stop=$start
-	local i=0
-	while [ $i -lt $max_zones ]; do
+	local outerstart start stop i
+	outerstart=$(date +%s%3N)
+	start=$(date +%s%3N)
+	stop="$start"
+	i=0
+	while [ "$i" -lt "$max_zones" ]; do
 		i=$((i + 1))
-		ip netns exec "$ns" conntrack -I -s 1.1.1.1 -d 2.2.2.2 --protonum 6 \
+		ip netns exec "$ns1" conntrack -I -s 1.1.1.1 -d 2.2.2.2 --protonum 6 \
 	                 --timeout 3600 --state ESTABLISHED --sport 12345 --dport 1000 --zone $i >/dev/null 2>&1
 		if [ $? -ne 0 ];then
-			ip netns exec "$ns" conntrack -I -s 1.1.1.1 -d 2.2.2.2 --protonum 6 \
+			ip netns exec "$ns1" conntrack -I -s 1.1.1.1 -d 2.2.2.2 --protonum 6 \
 	                 --timeout 3600 --state ESTABLISHED --sport 12345 --dport 1000 --zone $i > /dev/null
 			echo "FAIL: conntrack -I returned an error"
 			ret=1
@@ -137,13 +132,15 @@ test_conntrack_tool() {
 		fi
 	done
 
-	local count=$(ip netns exec "$ns" conntrack -C)
-	local duration=$((stop-outerstart))
+	local count
+	local duration
+	count=$(ip netns exec "$ns1" conntrack -C)
+	duration=$((stop-outerstart))
 
-	if [ $count -eq $max_zones ]; then
+	if [ "$count" -eq "$max_zones" ]; then
 		echo "PASS: inserted $count entries via ctnetlink in $duration ms"
 	else
-		ip netns exec $ns conntrack -S 1>&2
+		ip netns exec "$ns1" conntrack -S 1>&2
 		echo "FAIL: inserted $count entries via ctnetlink in $duration ms, expected $max_zones entries ($duration ms)"
 		ret=1
 	fi
@@ -151,7 +148,7 @@ test_conntrack_tool() {
 
 test_zones $zones
 
-if [ $have_ct_tool -eq 1 ];then
+if [ "$have_ct_tool" -eq 1 ];then
 	test_conntrack_tool $zones
 else
 	echo "SKIP: Could not run ctnetlink insertion test without conntrack tool"
-- 
2.43.2

