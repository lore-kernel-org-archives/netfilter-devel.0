Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E673B224B15;
	Thu, 26 Mar 2026 12:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529523; cv=none; b=Wj9r5gFw+Kmq/3jbACe617sacPQxibx9b/nN2bBfrN28PM6AA7Srs6Ia8jR9J9dZLF+J8+tnZb6fyCOMyzpHBLasmaLKB1l6k/P45mkWeZA7q8eqS9b6gEIAUbmcXpJkXpeI6ueXunSjeAK1inFAoLpBdMc/S5zbIBOwrPr0zXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529523; c=relaxed/simple;
	bh=v3QnGyrqEuj20HYOOxgD1tNsF7IXViS2JzxvkJaONFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMVM0kiDIqo9eGWOU4uFV14Ok7f3JTZR5LeNCgmOnyT+FziLZ5zo5dIksxTayXcn7mNmslBQDotDKE8v4+qC8SMxSFmikB1prdnTAYtn3ksDTencw3a/dWuvML1K8ZczCY+uQsO5rIl9Q589OMXM7/X2kw+SGInkfPR+DXKJiws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=k5f9KOVg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="k5f9KOVg"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B6FEA6026E;
	Thu, 26 Mar 2026 13:51:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774529520;
	bh=b5pdKOs5AE9x+8GGiMULGY+8VbgnoPwjO4IvUfTiWWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5f9KOVgfBnMIUBYYwmXYDmI73mslWQ2M431fbuNm5a10As1BbHlYH09fDiFXjOCf
	 /7Z+r6evAMvmVsqTRwzmAr+DLIMzGKexMo0myCIE0lsw1mlEgaLZ5unsYayQ/G8071
	 Nb14FOAvPaLd5V+iYvapdxha99FD6LJhBQn02YJje1/N+dR/LtcKcmnhWU//t9IzTq
	 VII5cSVGTZFW/xrS4M2duW/kKb/7zCabcbl0h6T1zUc1nvvU04RFNWDEjbAM5HBLtb
	 9K72NF94oHo8U3lnO6YxMs5zb07FnMZo/loWBgcZrBphx5aILcR8cNqzco2pdY5E7I
	 NAzj0iK8isSJw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/12] selftests: netfilter: nft_concat_range.sh: add check for flush+reload bug
Date: Thu, 26 Mar 2026 13:51:43 +0100
Message-ID: <20260326125153.685915-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326125153.685915-1-pablo@netfilter.org>
References: <20260326125153.685915-1-pablo@netfilter.org>
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

