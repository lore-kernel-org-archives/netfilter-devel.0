Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C8D3290C4;
	Wed, 25 Mar 2026 22:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477595; cv=none; b=TyaEC32FeVfhTp18q1yHrjZrdDB7ZC9vBN3s5dhgK111YQ+n7a7o0easYLXuZvkF5GtuvJ/OT7Zm4gV/gGl0QFCbtDs7ZXIf0cJ0vJTPwzwXo6o6DEF2eKGzsuJC2Ys2RnN2yPlBjltzV366iYec4n8cmSvy8GLqVCWb3AwzQ4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477595; c=relaxed/simple;
	bh=v3QnGyrqEuj20HYOOxgD1tNsF7IXViS2JzxvkJaONFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNk8XVINW1AGGfx5u992fGMHbw9nFKYvRurMvEbd/7IRcEB1dTygQJHf2i9C1vX64H40X4dKdvtCoHisUn/NcvRr67WayLO6RQKuf9v3JMcgbq1LBCu284T1/1JlVKAsuv93mNJ3/ElrKtcOh4pkTKxFQLZ7cDJT1N/KmKPiUbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H9s/1MrU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H9s/1MrU"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4D8AB6017D;
	Wed, 25 Mar 2026 23:26:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477586;
	bh=b5pdKOs5AE9x+8GGiMULGY+8VbgnoPwjO4IvUfTiWWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9s/1MrUoMBNh1BkmjBJerLTgT4w1ly6n/EhSGikRX3nGq7wU3pZJTBCV2EIeokJH
	 1/ZBjH2cn1dxXJzAFkIXPRbCqKeE6tnlhlDwxdV4VedWPLkw7lwKa8Z+28aMQx47Yb
	 90EoSdzP8CgSbv6we0/t2OlsUZipZl/OFMO9pLNEiv9+SaTMvr0VF54/67vwOdkr1K
	 5Ce+uFCLwdPd42mY6gyeRRL6c3gGTsctzYUuYHXEtj2V8ghm9YlzzYV36W/gpSUI8h
	 stfsmf2YkD2KL4bqVup15qtMUE1iRiIF5AJ5FRBSyWhxCPhgJYmcLL1WuKj+QSw+h1
	 BhjiOW/mlhJ8A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/14] selftests: netfilter: nft_concat_range.sh: add check for flush+reload bug
Date: Wed, 25 Mar 2026 23:26:03 +0100
Message-ID: <20260325222615.637793-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

This test will fail without
the preceding commit ("netfilter: nft_set_pipapo_avx2: fix match retart if found element is expired"):

  reject overlapping range on add       0s                              [ OK ]
  reload with flush                 /dev/stdin:59:32-52: Error: Could not process rule: File exists
add element inet filter test { 10.0.0.29 . 10.0.2.29 }

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/netfilter/nft_concat_range.sh         | 70 ++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 394166f224a4..ffdc6ccc6511 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -29,7 +29,8 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch doublecreate insert_overlap"
+BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch doublecreate
+      insert_overlap load_flush_load4 load_flush_load8"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -432,6 +433,30 @@ race_repeat	0
 perf_duration	0
 "
 
+TYPE_load_flush_load4="
+display		reload with flush, 4bit groups
+type_spec	ipv4_addr . ipv4_addr
+chain_spec	ip saddr . ip daddr
+dst		addr4
+proto		icmp
+
+race_repeat	0
+
+perf_duration	0
+"
+
+TYPE_load_flush_load8="
+display		reload with flush, 8bit groups
+type_spec	ipv4_addr . ipv4_addr
+chain_spec	ip saddr . ip daddr
+dst		addr4
+proto		icmp
+
+race_repeat	0
+
+perf_duration	0
+"
+
 # Set template for all tests, types and rules are filled in depending on test
 set_template='
 flush ruleset
@@ -1997,6 +2022,49 @@ test_bug_insert_overlap()
 	return 0
 }
 
+test_bug_load_flush_load4()
+{
+	local i
+
+	setup veth send_"${proto}" set || return ${ksft_skip}
+
+	for i in $(seq 0 255); do
+		local addelem="add element inet filter test"
+		local j
+
+		for j in $(seq 0 20); do
+			echo "$addelem { 10.$j.0.$i . 10.$j.1.$i }"
+			echo "$addelem { 10.$j.0.$i . 10.$j.2.$i }"
+		done
+	done > "$tmp"
+
+	nft -f "$tmp" || return 1
+
+	( echo "flush set inet filter test";cat "$tmp") | nft -f -
+	[ $? -eq 0 ] || return 1
+
+	return 0
+}
+
+test_bug_load_flush_load8()
+{
+	local i
+
+	setup veth send_"${proto}" set || return ${ksft_skip}
+
+	for i in $(seq 1 100); do
+		echo "add element inet filter test { 10.0.0.$i . 10.0.1.$i }"
+		echo "add element inet filter test { 10.0.0.$i . 10.0.2.$i }"
+	done > "$tmp"
+
+	nft -f "$tmp" || return 1
+
+	( echo "flush set inet filter test";cat "$tmp") | nft -f -
+	[ $? -eq 0 ] || return 1
+
+	return 0
+}
+
 test_reported_issues() {
 	eval test_bug_"${subtest}"
 }
-- 
2.47.3

