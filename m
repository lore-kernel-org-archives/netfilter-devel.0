Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46202299ABA;
	Thu, 22 May 2025 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932782; cv=none; b=rT1UE+3F9clZJ5iUPR74r56CsL7GlXfDGiriHJYaGYj3vlTBiWtByWI+hMJGSHDY9bAh9BFT/i50uP0t8E+91ZjNg77QhknBbxwLDXo9g/wnxJYVJ3rrgYyH/a+/1W6EIYem4h9n4VzEYP2oNlI+nNtBlXTq2uQdejGrlTM80mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932782; c=relaxed/simple;
	bh=/QYcmDszcQ3wcvWhsbVhi+ZoekOt8llcKMTOjaU8ug0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y8y7Rryygy4ORgL16htOwjqdKOzJESltzVSnyzn1tjJDSBjp6c2UQOvC6/HKG1R4NArwKGhnNZ6N6liGDTJhZIU46I9bshdDJFVCwuLuzlcrkGIWRTx8hY7BmhhFrZ5IuS+Px7261GB0PpCex8/O4Tk0xt541kuRvBWA5eYwhrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NhS/E01c; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a3Jr/T7l; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NhS/E01c";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a3Jr/T7l"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B027260735; Thu, 22 May 2025 18:52:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932772;
	bh=tQIdFw7PHkXMKQD9JAXUxWHS0IhpFoyUQh9Gbyxd5RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhS/E01cphqmxuNdqI1SW/yGHOtbPNCbc/otVne7Mdmqyg9S6kwGSc0rxVUcLtNAa
	 bMuLMq9hnjGMcdY4IjGdQuLZkxGvKwPO7hJcNtw+/XG0Ti4MyBQrvOmdBbdkVN+a3m
	 gZhFHJY4QX9EtLD4ushY50mdxjheZ8ccyNFynuQCmFyNBLh4MNxQLRlC83Ia0im552
	 xnO2u9GXlP4pr1i8SO30jLdaNXOi6Puu7mXH/X2hWaG1uCCvDjEW79+mlMUdNA52x8
	 6mFzhhmlzCXWbqE0y55NEm+XWO7JFwyhScPIlTK2Dxhby20PRC4r8VCN5r52IQ5T0I
	 +pYyRDGf2F2pA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 38AB560718;
	Thu, 22 May 2025 18:52:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932767;
	bh=tQIdFw7PHkXMKQD9JAXUxWHS0IhpFoyUQh9Gbyxd5RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3Jr/T7lNAzpXrGAUhybo3MgFGgikrqT/wiOYZHwoQwX1S1Nc4RaYIJ461Q5mRG2f
	 WH9VsgCYaM25JZjf8MlNkHRwzdPxkkBlLwEx4aiiMddLeMvPc2htyrxsGMe0axRxER
	 w6qgfZgzy8gkOwaM2XONQoda006OC2GRVEQjpAF7fd/pYwh1aNO2KbQqdhIPqJMZAc
	 NOGtk0Q0Ert8Yunho8pfapQdHAU/1/mMTlzFCBeGD8sRif+kQV/JMtJQofjCx/RFtz
	 CevSlkReQSzKJDA3ShzhszfFM3VVfWWGg7lynR2Uw0Ki0z0rS2VwM7yjIaJKOJ3PEA
	 DTgbrwR2sv/Xw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 01/26] selftests: netfilter: nft_concat_range.sh: add coverage for 4bit group representation
Date: Thu, 22 May 2025 18:52:13 +0200
Message-Id: <20250522165238.378456-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Pipapo supports a more compact '4 bit group' format that is chosen when
the memory needed for the default exceeds a threshold (2mb).

Add coverage for those code paths, the existing tests use small sets that
are handled by the default representation.

This comes with a test script run-time increase, but I think its ok:

 normal: 2m35s -> 3m9s
 debug:  3m24s -> 5m29s (with KSFT_MACHINE_SLOW=yes).

Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

