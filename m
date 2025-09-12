Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F5E301015
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2025 13:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757683220; cv=none; b=A6wWMDoLXzRy1vHwcFKut65X0Iow9Ioo6zols5jfFf/KtW2CmkjLKcho3CRzLnHVGaSbpAIyTIJkyzPbJk+DjLywoDrmFlsm6r2jN03i3EzAl8EowXio3TCkRMf9S0017DIRTTlDj/GPGF2TJeMjV/PQKaBRV8U7x3RmeJw9AXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757683220; c=relaxed/simple;
	bh=25krmPZ0mlB/9yegug7TJHkWmqY4UfCa1VLDcDntb3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wnj8KdHyAwPCV2alvgybB374Ej4AxfhhEsJ8nj/4Wm1JyJpurPP9ZotrBeG6nSyODng9VgHmfY6ZIv/o61TBiaRzAWCw4N5KYmMoaFiog4RkFiA7lMQWfcC93Kswm4d3JZuhIR3QytJSn3qpc1uy/achQY/CnjbCn4kcQ4+h+EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9268060324; Fri, 12 Sep 2025 15:20:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH RFC nf-next 2/2] selftests: netfilter: nft_concat_range.sh: add check for double-create bug
Date: Fri, 12 Sep 2025 15:20:00 +0200
Message-ID: <20250912132004.7925-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250912132004.7925-1-fw@strlen.de>
References: <20250912132004.7925-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test case for bug resolved with:
'netfilter: nft_set_pipapo_avx2: fix skip of expired entries'.

It passes on nf.git (it uses the generic/C version for insertion
duplicate check) but fails on unpatched nf-next if AVX2 is supported:

  cannot create same element twice      0s                        [FAIL]
Could create element twice in same transaction
table inet filter { # handle 8
[..]
  elements = { 1.2.3.4 . 1.2.4.1 counter packets 0 bytes 0,
               1.2.4.1 . 1.2.3.4 counter packets 0 bytes 0,
               1.2.3.4 . 1.2.4.1 counter packets 0 bytes 0,
               1.2.4.1 . 1.2.3.4 counter packets 0 bytes 0 }

Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 38 ++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 20e76b395c85..4d4d5004684c 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -29,7 +29,7 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch"
+BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch doublecreate"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -408,6 +408,18 @@ perf_duration	0
 "
 
 
+TYPE_doublecreate="
+display		cannot create same element twice
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
@@ -1900,6 +1912,30 @@ test_bug_avx2_mismatch()
 	fi
 }
 
+test_bug_doublecreate()
+{
+	local elements="1.2.3.4 . 1.2.4.1, 1.2.4.1 . 1.2.3.4"
+	local ret=1
+
+	setup veth send_"${proto}" set || return ${ksft_skip}
+
+	nft add element inet filter test "{ $elements }"
+nft -f - <<EOF 2>/dev/null
+flush set inet filter test
+create element inet filter test { $elements }
+create element inet filter test { $elements }
+EOF
+	ret=$?
+
+	if [ $ret -eq 0 ];then
+		err "Could create element twice in same transaction"
+		err "$(nft -a list ruleset)"
+		return 1
+	fi
+
+	return 0
+}
+
 test_reported_issues() {
 	eval test_bug_"${subtest}"
 }
-- 
2.49.1

