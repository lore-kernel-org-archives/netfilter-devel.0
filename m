Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F96B1624C9
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 06:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743747743; cv=none; b=kjUp69nAAx5Y+hn7L/Cm6EzKFr6BPOT/I1DoqdyPhdfHRFEkN7dpK7C8DBpzxeCwETxk1OqO2jBxSEfDB0L8f7bqn2b8Lc1QI8TlelBxJXiFlM711jAsroXwDOpvPMTDFH/opyNwxdneyNRsJStXIcBBb+pE/2rKDzLOOT1qgrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743747743; c=relaxed/simple;
	bh=7SzqOAY3w43yL+oDmBCJO7G08ewXjfAG5XHFou3DfbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khtolMPql2XRLVV7jLhsUiie1bfz3Tdj6rVLqq44PGTOGn3leeuouo6SjgoNL+TBNruaDMdOlAybj91vZbvbL9wTwMSFMc6m1GCHXcCV8VzbFNkxn4Xd9NqZn7O70RMtPOHvPA36aAf6MmkY521aLJeuw2Wyuz604K9+P5vBH84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u0aRY-0005v1-1N; Fri, 04 Apr 2025 08:22:20 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sontu21@gmail.com,
	sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/3] selftests: netfilter: add test case for recent mismatch bug
Date: Fri,  4 Apr 2025 08:20:54 +0200
Message-ID: <20250404062105.4285-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404062105.4285-1-fw@strlen.de>
References: <20250404062105.4285-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without 'nft_set_pipapo: fix incorrect avx2 match of 5th field octet"
this fails:

TEST: reported issues
  Add two elements, flush, re-add       1s                              [ OK ]
  net,mac with reload                   0s                              [ OK ]
  net,port,proto                        3s                              [ OK ]
  avx2 false match                      0s                              [FAIL]
False match for fe80:dead:01fe:0a02:0b03:6007:8009:a001

Other tests do not detect the kernel bug as they only alter parts in
the /64 netmask.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 39 ++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 47088b005390..1f5979c1510c 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -27,7 +27,7 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add reload net_port_proto_match"
+BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -387,6 +387,25 @@ race_repeat	0
 
 perf_duration	0
 "
+
+TYPE_avx2_mismatch="
+display		avx2 false match
+type_spec	inet_proto . ipv6_addr
+chain_spec	meta l4proto . ip6 daddr
+dst		proto addr6
+src
+start		1
+count		1
+src_delta	1
+tools		ping
+proto		icmp6
+
+race_repeat	0
+
+perf_duration	0
+"
+
+
 # Set template for all tests, types and rules are filled in depending on test
 set_template='
 flush ruleset
@@ -1629,6 +1648,24 @@ test_bug_net_port_proto_match() {
 	nft flush ruleset
 }
 
+test_bug_avx2_mismatch()
+{
+	setup veth send_"${proto}" set || return ${ksft_skip}
+
+	local a1="fe80:dead:01ff:0a02:0b03:6007:8009:a001"
+	local a2="fe80:dead:01fe:0a02:0b03:6007:8009:a001"
+
+	nft "add element inet filter test { icmpv6 . $a1 }"
+
+	dst_addr6="$a2"
+	send_icmp6
+
+	if [ "$(count_packets)" -gt "0" ]; then
+		err "False match for $a2"
+		return 1
+	fi
+}
+
 test_reported_issues() {
 	eval test_bug_"${subtest}"
 }
-- 
2.49.0

