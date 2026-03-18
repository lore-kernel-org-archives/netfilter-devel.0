Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B842135D7
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 13:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773840274; cv=none; b=YyISQdZqETB5kUXD3U4NJgdA2jZB3kqmC9qkxL/Hj3FFBLlZRSqhbtf7k6QXGb5veRCArZZ9/E8qUNt7k5cQ/DWd7F89+TbfwB9clo1/BIz6wq7b3D4AO875sS/+ZsnQSFZe43dUEkZ2c3GNNkZfWA21q8iTLSaLj5ujFNBwXBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773840274; c=relaxed/simple;
	bh=izGUBbC2F8ZCNtLEsJwXfTcALaBVuAY3kQM8v1pnkJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkOZM56QMEdl1Nie4Ndz0o5+WDTwuNVN3CpQPnjr68E1mLlSKW+2Ut6XuwBYI1woiNyiHsI/7Pp7b08w7fL+KggofsENcKMwQIBsJyHk03SI18B5PKMHerMOA95hZ3uSehC78dYYKSr1eWdNuKqjPmJuhagVU7IwIm+a9Z8z9AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5B74D608E0; Wed, 18 Mar 2026 14:24:31 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] selftests: netfilter: nft_concat_range.sh: add check for flush+reload bug
Date: Wed, 18 Mar 2026 14:24:14 +0100
Message-ID: <20260318132417.31661-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318132417.31661-1-fw@strlen.de>
References: <20260318132417.31661-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test will fail without
the preceeding commit ("netfilter: nft_set_pipapo_avx2: fix match retart if found element is expired"):

  reject overlapping range on add       0s                              [ OK ]
  reload with flush                 /dev/stdin:59:32-52: Error: Could not process rule: File exists
add element inet filter test { 10.0.0.29 . 10.0.2.29 }

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 68 ++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 394166f224a4..c1ee0c2da583 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -29,7 +29,7 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch doublecreate insert_overlap"
+BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch doublecreate insert_overlap load_flush_load4 load_flush_load8"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -432,6 +432,30 @@ race_repeat	0
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
@@ -1997,6 +2021,48 @@ test_bug_insert_overlap()
 	return 0
 }
 
+test_bug_load_flush_load4()
+{
+	local i
+
+	setup veth send_"${proto}" set || return ${ksft_skip}
+
+	for i in $(seq 0 255); do
+		local j
+
+		for j in $(seq 0 20); do
+			echo "add element inet filter test { 10.$j.0.$i . 10.$j.1.$i }"
+			echo "add element inet filter test { 10.$j.0.$i . 10.$j.2.$i }"
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
2.52.0

