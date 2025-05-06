Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC95280003
	for <netfilter-devel@vger.kernel.org>; Tue,  6 May 2025 13:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746536886; cv=none; b=ZcXnSgd8Z0r9RNIvsQA54HilgIrjzuv4Vb94u90HK1JN/IL8kADZRkW6iFrJG5rk3aD7x1G26g1I7xmMWrHLj3MbPm8wnsU8oRLqnahe0smKudTdKgTstRko4LwZjSYDzrMdurmFoWkb83HRouQLfL4c77X8fMZztcQNhx2vNWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746536886; c=relaxed/simple;
	bh=kHztFdPfgU0w2v/zhf2WURAtIXfcs0eJ6zeTfXgPuwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EGlryvyr42fqoWBIC/UtvZOMVBvszdzkFSRaMFc9LKiP/tukJWZERSYoNKP1y9J56/5JG+wa+DJ3qMiozV80DYR8+1h89y3MNTTPo34GoNigiUQ/PTMeQyu8NoFLfn9DYncIeNSj/w87Huj7v1Gi3z6O893gUybzvVehozLe/vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1uCI1a-0003Jh-ID; Tue, 06 May 2025 15:07:54 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH nf-next] selftests: netfilter: nft_concat_range.sh: add coverage for 4bit group representation
Date: Tue,  6 May 2025 15:07:11 +0200
Message-ID: <20250506130716.3266-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pipapo supports a more compact '4 bit group' format that is chosen when
the memory needed for the default exceeds a threshold (2mb).

Add coverage for those code paths, the existing tests use small sets that
are handled by the default representation.

This comes with a test script run-time increase, but I think its ok:

 normal: 2m35s -> 3m9s
 debug:  3m24s -> 5m29s (with KSFT_MACHINE_SLOW=yes).

Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 165 +++++++++++++++++-
 1 file changed, 161 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 1f5979c1510c..efea93cf23d4 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -15,10 +15,12 @@ source lib.sh
 # Available test groups:
 # - reported_issues: check for issues that were reported in the past
 # - correctness: check that packets match given entries, and only those
+# - correctness_large: same but with additional non-matching entries
 # - concurrency: attempt races between insertion, deletion and lookup
 # - timeout: check that packets match entries until they expire
 # - performance: estimate matching rate, compare with rbtree and hash baselines
-TESTS="reported_issues correctness concurrency timeout"
+TESTS="reported_issues correctness correctness_large concurrency timeout"
+
 [ -n "$NFT_CONCAT_RANGE_TESTS" ] && TESTS="${NFT_CONCAT_RANGE_TESTS}"
 
 # Set types, defined by TYPE_ variables below
@@ -1257,9 +1259,7 @@ send_nomatch() {
 # - add ranged element, check that packets match it
 # - check that packets outside range don't match it
 # - remove some elements, check that packets don't match anymore
-test_correctness() {
-	setup veth send_"${proto}" set || return ${ksft_skip}
-
+test_correctness_main() {
 	range_size=1
 	for i in $(seq "${start}" $((start + count))); do
 		end=$((start + range_size))
@@ -1293,6 +1293,163 @@ test_correctness() {
 	done
 }
 
+test_correctness() {
+	setup veth send_"${proto}" set || return ${ksft_skip}
+
+	test_correctness_main
+}
+
+# Repeat the correctness tests, but add extra non-matching entries.
+# This exercises the more compact '4 bit group' representation that
+# gets picked when the default 8-bit representation exceed
+# NFT_PIPAPO_LT_SIZE_HIGH bytes of memory.
+# See usage of NFT_PIPAPO_LT_SIZE_HIGH in pipapo_lt_bits_adjust().
+#
+# The format() helper is way too slow when generating lots of
+# entries so its not used here.
+test_correctness_large() {
+	setup veth send_"${proto}" set || return ${ksft_skip}
+	# number of dummy (filler) entries to add.
+	local dcount=16385
+
+	(
+	echo -n "add element inet filter test { "
+
+	case "$type_spec" in
+	"ether_addr . ipv4_addr")
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			format_mac $((1000000 + i))
+			printf ". 172.%i.%i.%i " $((RANDOM%256)) $((RANDOM%256)) $((i%256))
+		done
+		;;
+	"inet_proto . ipv6_addr")
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			printf "%i . " $((RANDOM%256))
+			format_addr6 $((1000000 + i))
+		done
+		;;
+	"inet_service . inet_proto")
+		# smaller key sizes, need more entries to hit the
+		# 4-bit threshold.
+		dcount=65536
+		for i in $(seq 1 $dcount); do
+			local proto=$((RANDOM%256))
+
+			# Test uses UDP to match, as it also fails when matching
+			# an entry that doesn't exist, so skip 'udp' entries
+			# to not trigger a wrong failure.
+			[ $proto -eq 17 ] && proto=18
+			[ $i -gt 1 ] && echo ", "
+			printf "%i . %i " $(((i%65534) + 1)) $((proto))
+		done
+		;;
+	"inet_service . ipv4_addr")
+		dcount=32768
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			printf "%i . 172.%i.%i.%i " $(((RANDOM%65534) + 1)) $((RANDOM%256)) $((RANDOM%256)) $((i%256))
+		done
+		;;
+	"ipv4_addr . ether_addr")
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			printf "172.%i.%i.%i . " $((RANDOM%256)) $((RANDOM%256)) $((i%256))
+			format_mac $((1000000 + i))
+		done
+		;;
+	"ipv4_addr . inet_service")
+		dcount=32768
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			printf "172.%i.%i.%i . %i" $((RANDOM%256)) $((RANDOM%256)) $((i%256)) $(((RANDOM%65534) + 1))
+		done
+		;;
+	"ipv4_addr . inet_service . ether_addr . inet_proto . ipv4_addr")
+		dcount=65536
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			printf "172.%i.%i.%i . %i . " $((RANDOM%256)) $((RANDOM%256)) $((i%256)) $(((RANDOM%65534) + 1))
+			format_mac $((1000000 + i))
+			printf ". %i . 192.168.%i.%i" $((RANDOM%256)) $((RANDOM%256)) $((i%256))
+		done
+		;;
+	"ipv4_addr . inet_service . inet_proto")
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			printf "172.%i.%i.%i . %i . %i " $((RANDOM%256)) $((RANDOM%256)) $((i%256)) $(((RANDOM%65534) + 1)) $((RANDOM%256))
+		done
+		;;
+	"ipv4_addr . inet_service . inet_proto . ipv4_addr")
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			printf "172.%i.%i.%i . %i . %i . 192.168.%i.%i " $((RANDOM%256)) $((RANDOM%256)) $((i%256)) $(((RANDOM%65534) + 1)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))
+		done
+		;;
+	"ipv4_addr . inet_service . ipv4_addr")
+		dcount=32768
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			printf "172.%i.%i.%i . %i . 192.168.%i.%i " $((RANDOM%256)) $((RANDOM%256)) $((i%256)) $(((RANDOM%65534) + 1)) $((RANDOM%256)) $((RANDOM%256))
+		done
+		;;
+	"ipv6_addr . ether_addr")
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			format_addr6 $((i + 1000000))
+			echo -n " . "
+			format_mac $((1000000 + i))
+		done
+		;;
+	"ipv6_addr . inet_service")
+		dcount=32768
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			format_addr6 $((i + 1000000))
+			echo -n " .  $(((RANDOM%65534) + 1))"
+		done
+		;;
+	"ipv6_addr . inet_service . ether_addr")
+		dcount=32768
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			format_addr6 $((i + 1000000))
+			echo -n " .  $(((RANDOM%65534) + 1)) . "
+			format_mac $((i + 1000000))
+		done
+		;;
+	"ipv6_addr . inet_service . ether_addr . inet_proto")
+		dcount=65536
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			format_addr6 $((i + 1000000))
+			echo -n " .  $(((RANDOM%65534) + 1)) . "
+			format_mac $((i + 1000000))
+			echo -n " .  $((RANDOM%256))"
+		done
+		;;
+	"ipv6_addr . inet_service . ipv6_addr . inet_service")
+		dcount=32768
+		for i in $(seq 1 $dcount); do
+			[ $i -gt 1 ] && echo ", "
+			format_addr6 $((i + 1000000))
+			echo -n " .  $(((RANDOM%65534) + 1)) . "
+			format_addr6 $((i + 2123456))
+			echo -n " .  $((RANDOM%256))"
+		done
+		;;
+	*)
+		"Unhandled $type_spec"
+		return 1
+	esac
+	echo -n "}"
+
+	) | nft -f - || return 1
+
+	test_correctness_main
+}
+
 # Concurrency test template:
 # - add all the elements
 # - start a thread for each physical thread that:
-- 
2.49.0

