Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B77F2920B4;
	Fri, 23 May 2025 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006850; cv=none; b=AdqnRcshOKehuNbHStJ5CVebS6AdIH3QbNBMtuuFp5ERkn82AvFeWjXA6Xgg3PdhXaF73mBaldM2VLJX55ktmGYNYPBJvy2UZi00AbAr4l9v5ZvJdO5tBM7Hm46DEXB/tQeBts9v3nUvURPcjgUv5JCXYhssqG0eRSmPs3+Xz4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006850; c=relaxed/simple;
	bh=/QYcmDszcQ3wcvWhsbVhi+ZoekOt8llcKMTOjaU8ug0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FZ0gn9SFp+G8gN9rfMgbBYK4vOQd2v3Dhb0VyfJ7LkofOhoqQzFz9Y6EACnwhYqcpaudYNMB9vuroDhY7GQIMQdkKCPNBQ1uqeDbA1OeKbQY0CITA6DnThy6OIDdPpNmgj8QoypD997EXzg7cNtLaMxStbwQe4nRU201ijEsh1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ud8ef83m; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F+EiRhKm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ud8ef83m";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F+EiRhKm"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8761460777; Fri, 23 May 2025 15:27:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006846;
	bh=tQIdFw7PHkXMKQD9JAXUxWHS0IhpFoyUQh9Gbyxd5RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ud8ef83muDKqLymZa4yFu4uMxX8pQ0C64mpjO3M4rAmCQVOlL39ovnWLlI8tm6qwd
	 9fmnUgovkxn4eGIjosxJo21D3ALFM3GNeY2GX+Me4Ro7V83d6P+Etc12EBUNjx9fLu
	 P7Wbz4uqMvOFMg6BYRsO4xKsQe+J5U81kyklyHlZDLub0ZdjBMNahND9VY/A5OhKYx
	 w7milMbeK3YG95UfWQQQn+5ygQwP3xbNrbKdyORh/GUprLxelFq5mGIfcPpNEKQtn+
	 meBR+FyY9Uu6av5G7A9GzPIxMDgQ3JzrapFWTeH0cgP3jZYu3IeWJddrHf794RDu5u
	 M/2exKyuBfgiQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 40C3F60764;
	Fri, 23 May 2025 15:27:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006840;
	bh=tQIdFw7PHkXMKQD9JAXUxWHS0IhpFoyUQh9Gbyxd5RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+EiRhKmlgqj3A/B3NVXC9C+0ql32N1XzKwMTDf7tq6vg8dKg910pxT5k0P80fp8J
	 pNbkLDgEjTXYa+x8ACSRP7Bz8TVvK4ffnZrMhmBhzxROLY25xB2kDk+sRzoHeaZuye
	 398rE1Lb++32s8PPV63UaVoM3LHFVX9ul3PVtZdv1Ee3ulbN5N/noUcEP9LkQPIEFX
	 zQ6PucLoBTta/aHdVYWqugtIr3C/5DNY+rUb2Ag7OVmH/2/BOICNmtVA6r/m2ODXEK
	 rJcz1PS+v/CEBp/FLhlTA/vXM3bHr+pjEAk1GvDy0jT9Ha/Tpy/ARC7IV+kOl5X5Tv
	 LgiycAoNnB1qA==
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
Date: Fri, 23 May 2025 15:26:47 +0200
Message-Id: <20250523132712.458507-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
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

