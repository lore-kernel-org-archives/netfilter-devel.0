Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3666984A27;
	Tue, 23 Apr 2024 11:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870679; cv=none; b=HLGxtf8tVTC4JY50f8FyZiEqkPouwwdRj190wjpzBVwRgEHDnpS/NI6jxVyV+3EvLdI1HbudGUEXa9Lue8+NoFg/ow7qAVT6X99QdJLgPQ9eMQdZ4MMxY1McNxqZNIWJvMwKuhNRUS3hq7Lbl2W9HU7l8ny6REdCCudEZRZNW9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870679; c=relaxed/simple;
	bh=CWKGyCMh7lt2tiOv58uV2VevfP0ak2NQFxs/DblmiqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGYf9EcHe39ELpqYHJ0bxEgkjzna97MtMC1IUKAAa3xenyd8z+Lre+NqlsOa/SFVk2+V6LOpg1j4fFRdT90SAMjRg7UHL1lYut6d6YCj+RLTJNXxlSRP49daoAbj5AsnvPOSdR492X+uZZc+V8KAHvnBw45G2UKsHoDAH14DeW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzE3H-0006vi-UQ; Tue, 23 Apr 2024 13:11:07 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 3/7] selftests: netfilter: nft_concat_range.sh: shellcheck cleanups
Date: Tue, 23 Apr 2024 15:05:46 +0200
Message-ID: <20240423130604.7013-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240423130604.7013-1-fw@strlen.de>
References: <20240423130604.7013-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

no functional changes intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 53 +++++++++----------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 2160de014525..2b6661519055 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -546,7 +546,7 @@ setup_send_udp() {
 			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
 			[ -z "${dst_port}" ] && dst_port=12345
 
-			echo "test4" | B socat -t 0.01 STDIN UDP4-DATAGRAM:${dst_addr4}:${dst_port}"${__socatbind}"
+			echo "test4" | B socat -t 0.01 STDIN UDP4-DATAGRAM:"$dst_addr4":"$dst_port""${__socatbind}"
 
 			src_addr4=
 			src_port=
@@ -601,11 +601,7 @@ setup_send_udp6() {
 			__socatbind6=
 
 			if [ -n "${src_addr6}" ]; then
-				if [ -n "${src_addr6} != "${src_addr6_added} ]; then
-					B ip addr add "${src_addr6}" dev veth_b nodad
-
-					src_addr6_added=${src_addr6}
-				fi
+				B ip addr add "${src_addr6}" dev veth_b nodad
 
 				__socatbind6=",bind=[${src_addr6}]"
 
@@ -614,7 +610,7 @@ setup_send_udp6() {
 				fi
 			fi
 
-			echo "test6" | B socat -t 0.01 STDIN UDP6-DATAGRAM:[${dst_addr6}]:${dst_port}"${__socatbind6}"
+			echo "test6" | B socat -t 0.01 STDIN UDP6-DATAGRAM:["$dst_addr6"]:"$dst_port""${__socatbind6}"
 		}
 	elif [ -z "$(bash -c 'type -p')" ]; then
 		send_udp6() {
@@ -947,6 +943,7 @@ cleanup() {
 	ip link del dummy0			2>/dev/null
 	ip route del default			2>/dev/null
 	ip -6 route del default			2>/dev/null
+	ip netns pids B				2>/dev/null | xargs kill 2>/dev/null
 	ip netns del B				2>/dev/null
 	ip link del veth_a			2>/dev/null
 	timeout=
@@ -954,7 +951,7 @@ cleanup() {
 	killall iperf				2>/dev/null
 	killall netperf				2>/dev/null
 	killall netserver			2>/dev/null
-	rm -f ${tmp}
+	rm -f "$tmp"
 }
 
 # Entry point for setup functions
@@ -1237,7 +1234,7 @@ test_correctness() {
 		srcend=$((end + src_delta))
 
 		add "$(format)" || return 1
-		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+		for j in $(seq "$start" $((range_size / 2 + 1)) ${end}); do
 			send_match "${j}" $((j + src_delta)) || return 1
 		done
 		send_nomatch $((end + 1)) $((end + 1 + src_delta)) || return 1
@@ -1245,7 +1242,7 @@ test_correctness() {
 		# Delete elements now and then
 		if [ $((i % 3)) -eq 0 ]; then
 			del "$(format)" || return 1
-			for j in $(seq ${start} \
+			for j in $(seq "$start" \
 				   $((range_size / 2 + 1)) ${end}); do
 				send_nomatch "${j}" $((j + src_delta)) \
 					|| return 1
@@ -1276,7 +1273,7 @@ test_concurrency() {
 	range_size=1
 	cstart=${start}
 	flood_pids=
-	for i in $(seq ${start} $((start + count))); do
+	for i in $(seq "$start" $((start + count))); do
 		end=$((start + range_size))
 		srcstart=$((start + src_delta))
 		srcend=$((end + src_delta))
@@ -1299,7 +1296,7 @@ test_concurrency() {
 			# $start needs to be local to this subshell
 			# shellcheck disable=SC2030
 			start=${cstart}
-			for i in $(seq ${start} $((start + count))); do
+			for i in $(seq "$start" $((start + count))); do
 				end=$((start + range_size))
 				srcstart=$((start + src_delta))
 				srcend=$((end + src_delta))
@@ -1314,7 +1311,7 @@ test_concurrency() {
 
 			range_size=1
 			start=${cstart}
-			for i in $(seq ${start} $((start + count))); do
+			for i in $(seq "$start" $((start + count))); do
 				end=$((start + range_size))
 				srcstart=$((start + src_delta))
 				srcend=$((end + src_delta))
@@ -1330,7 +1327,7 @@ test_concurrency() {
 
 			range_size=1
 			start=${cstart}
-			for i in $(seq ${start} $((start + count))); do
+			for i in $(seq "$start" $((start + count))); do
 				end=$((start + range_size))
 				srcstart=$((start + src_delta))
 				srcend=$((end + src_delta))
@@ -1343,7 +1340,7 @@ test_concurrency() {
 
 			range_size=1
 			start=${cstart}
-			for i in $(seq ${start} $((start + count))); do
+			for i in $(seq "$start" $((start + count))); do
 				end=$((start + range_size))
 				srcstart=$((start + src_delta))
 				srcend=$((end + src_delta))
@@ -1375,14 +1372,14 @@ test_timeout() {
 
 	timeout=3
 	range_size=1
-	for i in $(seq "${start}" $((start + count))); do
+	for i in $(seq "$start" $((start + count))); do
 		end=$((start + range_size))
 		srcstart=$((start + src_delta))
 		srcend=$((end + src_delta))
 
 		add "$(format)" || return 1
 
-		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+		for j in $(seq "$start" $((range_size / 2 + 1)) ${end}); do
 			send_match "${j}" $((j + src_delta)) || return 1
 		done
 
@@ -1390,12 +1387,12 @@ test_timeout() {
 		start=$((end + range_size))
 	done
 	sleep 3
-	for i in $(seq ${start} $((start + count))); do
+	for i in $(seq "$start" $((start + count))); do
 		end=$((start + range_size))
 		srcstart=$((start + src_delta))
 		srcend=$((end + src_delta))
 
-		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+		for j in $(seq "$start" $((range_size / 2 + 1)) ${end}); do
 			send_nomatch "${j}" $((j + src_delta)) || return 1
 		done
 
@@ -1420,7 +1417,7 @@ test_performance() {
 	range_size=1
 	for set in test norange noconcat; do
 		start=${first}
-		for i in $(seq ${start} $((start + perf_entries))); do
+		for i in $(seq "$start" $((start + perf_entries))); do
 			end=$((start + range_size))
 			srcstart=$((start + src_delta))
 			srcend=$((end + src_delta))
@@ -1428,7 +1425,7 @@ test_performance() {
 			if [ $((end / 65534)) -gt $((start / 65534)) ]; then
 				start=${end}
 				end=$((end + 1))
-			elif [ ${start} -eq ${end} ]; then
+			elif [ "$start" -eq "$end" ]; then
 				end=$((start + 1))
 			fi
 
@@ -1439,7 +1436,7 @@ test_performance() {
 		nft -f "${tmp}"
 	done
 
-	perf $((end - 1)) ${srcstart}
+	perf $((end - 1)) "$srcstart"
 
 	sleep 2
 
@@ -1486,11 +1483,11 @@ test_bug_flush_remove_add() {
 	set_cmd='{ set s { type ipv4_addr . inet_service; flags interval; }; }'
 	elem1='{ 10.0.0.1 . 22-25, 10.0.0.1 . 10-20 }'
 	elem2='{ 10.0.0.1 . 10-20, 10.0.0.1 . 22-25 }'
-	for i in `seq 1 100`; do
-		nft add table t ${set_cmd}	|| return ${ksft_skip}
-		nft add element t s ${elem1}	2>/dev/null || return 1
+	for i in $(seq 1 100); do
+		nft add table t "$set_cmd"	|| return ${ksft_skip}
+		nft add element t s "$elem1"	2>/dev/null || return 1
 		nft flush set t s		2>/dev/null || return 1
-		nft add element t s ${elem2}	2>/dev/null || return 1
+		nft add element t s "$elem2"	2>/dev/null || return 1
 	done
 	nft flush ruleset
 }
@@ -1537,7 +1534,7 @@ test_bug_reload() {
 		srcstart=$((start + src_delta))
 		srcend=$((end + src_delta))
 
-		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+		for j in $(seq "$start" $((range_size / 2 + 1)) ${end}); do
 			send_match "${j}" $((j + src_delta)) || return 1
 		done
 
@@ -1560,7 +1557,7 @@ trap cleanup EXIT
 # Entry point for test runs
 passed=0
 for name in ${TESTS}; do
-	printf "TEST: %s\n" "$(echo ${name} | tr '_' ' ')"
+	printf "TEST: %s\n" "$(echo "$name" | tr '_' ' ')"
 	if [ "${name}" = "reported_issues" ]; then
 		SUBTESTS="${BUGS}"
 	else
-- 
2.43.2

