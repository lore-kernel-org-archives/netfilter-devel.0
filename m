Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A27234971
	for <netfilter-devel@vger.kernel.org>; Fri, 23 May 2025 12:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748002895; cv=none; b=a1VSIFuHlN0ewS/s9AI2mZgY/lxELGVzsbMFWs5jWbq5kTzgC+wZh97sOm2GuR/0IXXjii4w0KlqJbOeCkpOwuLpgFp69+XrXFp7NW8/pxa/cRaLnNGI0PPHhydOHrXX+yNlKTk/f3Q1qWHpXDukE7AK7ThR+cZeSwniRALx3UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748002895; c=relaxed/simple;
	bh=5P7D8nUjVWMVtDm6XklXnxjbK8W1AR1xg40KGrBjhYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7MzrYuLxi+paQe8Qxs7GKLYbM9EgE1S09fZGAZ3BHJJMYzCNJu//yG790glhqS9NjSTCf23QctnqapHbzcyt5EE0nHV8hk3zDkz8hyzf1RKSMQM1pqWsdaOH+HKlYTG/xy1kQZsqLIIkqYAGiNts2W49u3xZpQ/OBRUkan1FxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C924260368; Fri, 23 May 2025 14:21:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] selftests: netfilter: nft_concat_range.sh: prefer per element counters for testing
Date: Fri, 23 May 2025 14:20:45 +0200
Message-ID: <20250523122051.20315-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523122051.20315-1-fw@strlen.de>
References: <20250523122051.20315-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The selftest uses following rule:
  ... @test counter name "test"

Then sends a packet, then checks if the named counter did increment or
not.

This is fine for the 'no-match' test case: If anything matches the
counter increments and the test fails as expected.

But for the 'should match' test cases this isn't optimal.
Consider buggy matching, where the packet matches entry x, but it
should have matched entry y.

In that case the test would erronously pass.

Rework the selftest to use per-element counters to avoid this.

After sending packet that should have matched entry x, query the
relevant element via 'nft reset element' and check that its counter
had incremented.

The 'nomatch' case isn't altered, no entry should match so the named
counter must be 0, changing it to the per-element counter would then
pass if another entry matches.

The downside of this change is a slight increase in test run-time by
a few seconds.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 40 ++++++++++++++-----
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index efea93cf23d4..86b8ce742700 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -419,6 +419,7 @@ table inet filter {
 
 	set test {
 		type ${type_spec}
+		counter
 		flags interval,timeout
 	}
 
@@ -1158,8 +1159,17 @@ del() {
 	fi
 }
 
-# Return packet count from 'test' counter in 'inet filter' table
+# Return packet count for elem $1 from 'test' counter in 'inet filter' table
 count_packets() {
+	found=0
+	for token in $(nft reset element inet filter test "${1}" ); do
+		[ ${found} -eq 1 ] && echo "${token}" && return
+		[ "${token}" = "packets" ] && found=1
+	done
+}
+
+# Return packet count from 'test' counter in 'inet filter' table
+count_packets_nomatch() {
 	found=0
 	for token in $(nft list counter inet filter test); do
 		[ ${found} -eq 1 ] && echo "${token}" && return
@@ -1206,6 +1216,10 @@ perf() {
 
 # Set MAC addresses, send single packet, check that it matches, reset counter
 send_match() {
+	local elem="$1"
+
+	shift
+
 	ip link set veth_a address "$(format_mac "${1}")"
 	ip -n B link set veth_b address "$(format_mac "${2}")"
 
@@ -1216,7 +1230,7 @@ send_match() {
 		eval src_"$f"=\$\(format_\$f "${2}"\)
 	done
 	eval send_\$proto
-	if [ "$(count_packets)" != "1" ]; then
+	if [ "$(count_packets "$elem")" != "1" ]; then
 		err "${proto} packet to:"
 		err "  $(for f in ${dst}; do
 			 eval format_\$f "${1}"; printf ' '; done)"
@@ -1242,7 +1256,7 @@ send_nomatch() {
 		eval src_"$f"=\$\(format_\$f "${2}"\)
 	done
 	eval send_\$proto
-	if [ "$(count_packets)" != "0" ]; then
+	if [ "$(count_packets_nomatch)" != "0" ]; then
 		err "${proto} packet to:"
 		err "  $(for f in ${dst}; do
 			 eval format_\$f "${1}"; printf ' '; done)"
@@ -1262,6 +1276,8 @@ send_nomatch() {
 test_correctness_main() {
 	range_size=1
 	for i in $(seq "${start}" $((start + count))); do
+		local elem=""
+
 		end=$((start + range_size))
 
 		# Avoid negative or zero-sized port ranges
@@ -1272,15 +1288,16 @@ test_correctness_main() {
 		srcstart=$((start + src_delta))
 		srcend=$((end + src_delta))
 
-		add "$(format)" || return 1
+		elem="$(format)"
+		add "$elem" || return 1
 		for j in $(seq "$start" $((range_size / 2 + 1)) ${end}); do
-			send_match "${j}" $((j + src_delta)) || return 1
+			send_match "$elem" "${j}" $((j + src_delta)) || return 1
 		done
 		send_nomatch $((end + 1)) $((end + 1 + src_delta)) || return 1
 
 		# Delete elements now and then
 		if [ $((i % 3)) -eq 0 ]; then
-			del "$(format)" || return 1
+			del "$elem" || return 1
 			for j in $(seq "$start" \
 				   $((range_size / 2 + 1)) ${end}); do
 				send_nomatch "${j}" $((j + src_delta)) \
@@ -1572,14 +1589,17 @@ test_timeout() {
 
 	range_size=1
 	for i in $(seq "$start" $((start + count))); do
+		local elem=""
+
 		end=$((start + range_size))
 		srcstart=$((start + src_delta))
 		srcend=$((end + src_delta))
 
-		add "$(format)" || return 1
+		elem="$(format)"
+		add "$elem" || return 1
 
 		for j in $(seq "$start" $((range_size / 2 + 1)) ${end}); do
-			send_match "${j}" $((j + src_delta)) || return 1
+			send_match "$elem" "${j}" $((j + src_delta)) || return 1
 		done
 
 		range_size=$((range_size + 1))
@@ -1737,7 +1757,7 @@ test_bug_reload() {
 		srcend=$((end + src_delta))
 
 		for j in $(seq "$start" $((range_size / 2 + 1)) ${end}); do
-			send_match "${j}" $((j + src_delta)) || return 1
+			send_match "$(format)" "${j}" $((j + src_delta)) || return 1
 		done
 
 		range_size=$((range_size + 1))
@@ -1817,7 +1837,7 @@ test_bug_avx2_mismatch()
 	dst_addr6="$a2"
 	send_icmp6
 
-	if [ "$(count_packets)" -gt "0" ]; then
+	if [ "$(count_packets "{ icmpv6 . $a1 }")" -gt "0" ]; then
 		err "False match for $a2"
 		return 1
 	fi
-- 
2.49.0

