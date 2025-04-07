Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9D921B191
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Apr 2025 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744047698; cv=none; b=kdvsskKafT30sQLS/lYRd/1CAptfIHT4ODQeKVrtXvk0Gh9TnEteyyb+a8fvB0pD4uJhyW06LoBZShiGSFDtfuplq1k1uTctJCGkdooVX70DxYxURL7ylj6RwPDoVe8kAancZeOYSx9S6KWIlslApd0f6qyupLvwxN96KPMAobM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744047698; c=relaxed/simple;
	bh=NqpSO2ImoYsshtwN7g2dE8TPQq2APjsP55pmbwY+Ogs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkApXSIkG4eDOIiOVsR8qXQ5qszbw8LjMFCWkXUQ92VA2Jk+xGZh7E68WJGwVodyyh7bPqV0Gaofk97yMAvxS/VGSMGewFdWc6vDamQVNPjvK82v924/YEkxrr4QKX8AWw3JCwxtJxpEJEfcQ+jQwreuHcNZD07jhO5XxbEtT/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u1qTW-0008IK-9z; Mon, 07 Apr 2025 19:41:34 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf 2/3] selftests: netfilter: add test case for recent mismatch bug
Date: Mon,  7 Apr 2025 19:40:19 +0200
Message-ID: <20250407174048.21272-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250407174048.21272-1-fw@strlen.de>
References: <20250407174048.21272-1-fw@strlen.de>
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
  Add two elements, flush, re-add    1s  [ OK ]
  net,mac with reload                0s  [ OK ]
  net,port,proto                     3s  [ OK ]
  avx2 false match                   0s  [FAIL]
False match for fe80:dead:01fe:0a02:0b03:6007:8009:a001

Other tests do not detect the kernel bug as they only alter parts in
the /64 netmask.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
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

