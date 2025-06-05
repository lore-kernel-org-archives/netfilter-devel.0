Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A366B1FDE39;
	Thu,  5 Jun 2025 08:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749113868; cv=none; b=ezt1YuuS64411zz8vBuIwt5W04e/NeYyuq1KLXb5X7+51Nbkmo5gnOHT7JY2GC3Rn01imb07fXf0NOEi5/f5E6NyCxBwRNRigirstbem0P9UkAvQuykYM26DL3YE/OuvIC59xymPtCvxca7xe9sp5NPmaszcHhKkRqH8S8tg7fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749113868; c=relaxed/simple;
	bh=rUWB1w3MckiWZ75rzdtHh+yMItPhW++gUBtsnEb+nOo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ILQyVIwIaOcaeTNKbK5alEWMHSxcupm7R5ATcoQlsuVgQpoii0V1Y5lRP7WYHajBkN4LpF1smQIJFGxYdGT0Kf48Vs7qa0yzjN7PeLfBUP1tqv+eEBV0kA90aPdjPIR/qZHaHsVrc1v0xnWqjk24XTRo4pHIecTWjRv39Q4avrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SV0+H934; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rAFJr5ae; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SV0+H934";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rAFJr5ae"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0D60260768; Thu,  5 Jun 2025 10:57:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113865;
	bh=eUnqp5xmR69T0pYIkCKOX1fkLlnWVjQ2gtplRu2xnXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SV0+H934KDEzRAwF0f2VzuFlixxqXdbEYzygLOEPfRuGD4b5KhHpCD1Njbwu0bXP/
	 dndpA9gYIK1GvSgtBZ3KF0MdPviKkjkpzWNWaa9lAN9LPxYcH7zNJa0O3MRggjkZ2N
	 3qs/hfu9mUxugrOywF4FpAJDku/rzwk+E5GK2OnoUbMETHQKOWqHSZvR3j4NIWXDCE
	 8tOgNgxREo2YetAZzYUzsDbW0EW3G71XpKcjYes/26yW6LDCTK3x1cGeon5znO0dck
	 xNii6MTGtopq2gS+oBk+dXDVwAc5AnFPEPxu2MkzxAeL9qyeg6Ortaq65NtMC8i4BQ
	 WDRQjQLkZ0s/Q==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DBC016075A;
	Thu,  5 Jun 2025 10:57:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113861;
	bh=eUnqp5xmR69T0pYIkCKOX1fkLlnWVjQ2gtplRu2xnXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAFJr5aeiXUT7e9+bxTpW+jGq0o+VdpXaG3M6J9yX/4gzmiAH4kHhx6FBfcEfBsaC
	 5M2i3hCnORH9+rpNhHXHiZhXL1r09GYxvFhIS+vBDl2jszKEoJW1KpoeKZQQR305HP
	 XYj7sxkfo9WCPW1rsSq/E8GkGaXiBlXVPjA2VlZjaWZraofGGSHsO/Jy+TuiuMoJe9
	 CDlV+0lQFe+60gCLAhN3j948vTGhjKvXJaWsuFQwtEX05jfU90TwtkzwsMrRLkTfAW
	 2XzIYGs1ohR4E8ekKDYMIa1+t4wdNJNasfaQCF6NmmKmn9hBakccbzROUff1fQf0e8
	 YY7MILPSN7Oqg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 2/5] selftests: netfilter: nft_concat_range.sh: prefer per element counters for testing
Date: Thu,  5 Jun 2025 10:57:32 +0200
Message-Id: <20250605085735.52205-3-pablo@netfilter.org>
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
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

