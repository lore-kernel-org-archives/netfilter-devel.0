Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B209C2E282B
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Dec 2025 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764847267; cv=none; b=GfoyzMSSddnaumV49ug8egrOS/zgFnZXHL1SKautr+m8XcVuEzy70zQ2JQK+rtQylOvfjYyhGppQbGgalqz6xzCX6Q/gWDO8iV4/NLv5MLggekDMBKj/6ECR0kBFsdxn9OgKDfqr7g36uSoCGemKYP6GKqbS9sNHr5mcSrD9akw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764847267; c=relaxed/simple;
	bh=AhKbyBU7IhnqvGIvYSDp6Fplmv8AgPqF6uygxmLQjUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh/AR/r0ibPvNTrHQaciECVEQeHWnwtzgOOKjlJK1EAnc430s9pBocK+UdOJCyCmnaYFalO9C4Ed1FzJ5MHpvajytzzJY+yVLMB5R5Yh2GLp1RqBAz36Td9NCiIEli4RDin4+6rGRbK3IzmCRN0QjbI/L7BsZkBx0AOzXqgqPG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 01B8D60336; Thu, 04 Dec 2025 12:20:56 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] selftests: netfilter: nft_concat_range.sh: add check for overlap detection bug
Date: Thu,  4 Dec 2025 12:20:36 +0100
Message-ID: <20251204112041.27440-2-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251204112041.27440-1-fw@strlen.de>
References: <20251204112041.27440-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

without 'netfilter: nft_set_pipapo: fix range overlap detection':

  reject overlapping range on add       0s         [FAIL]
Returned success for add { 1.2.3.4 . 1.2.4.1-1.2.4.2 } given set:
table inet filter {
	[..]
       elements = { 1.2.3.4 . 1.2.4.1 counter packets 0 bytes 0,
                    1.2.3.0-1.2.3.4 . 1.2.4.2 counter packets 0 bytes 0 }
}

The element collides with existing ones and was not added, but kernel
returned success to userspace.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 45 ++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index ad97c6227f35..394166f224a4 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -29,7 +29,7 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
        net6_port_net6_port net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch doublecreate"
+BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch doublecreate insert_overlap"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -420,6 +420,18 @@ race_repeat	0
 perf_duration	0
 "
 
+TYPE_insert_overlap="
+display		reject overlapping range on add
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
@@ -1954,6 +1966,37 @@ EOF
 	return 0
 }
 
+add_fail()
+{
+	if nft add element inet filter test "$1" 2>/dev/null ; then
+		err "Returned success for add ${1} given set:"
+		err "$(nft -a list set inet filter test )"
+		return 1
+	fi
+
+	return 0
+}
+
+test_bug_insert_overlap()
+{
+	local elements="1.2.3.4 . 1.2.4.1"
+
+	setup veth send_"${proto}" set || return ${ksft_skip}
+
+	add "{ $elements }" || return 1
+
+	elements="1.2.3.0-1.2.3.4 . 1.2.4.1"
+	add_fail "{ $elements }" || return 1
+
+	elements="1.2.3.0-1.2.3.4 . 1.2.4.2"
+	add "{ $elements }" || return 1
+
+	elements="1.2.3.4 . 1.2.4.1-1.2.4.2"
+	add_fail "{ $elements }" || return 1
+
+	return 0
+}
+
 test_reported_issues() {
 	eval test_bug_"${subtest}"
 }
-- 
2.51.2

