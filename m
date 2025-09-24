Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3712135D7;
	Wed, 24 Sep 2025 14:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758722850; cv=none; b=mBA9SFzarNUv91K88ls5vJqS3EY/qgzL2x6b4rXloNo6WmU/k09NQnXMVn6FUDFkpP/VeUvrneNQquMLUwAMEVkGMpdHZrR+yREYFl9K2uFBn2CYoWNdhFzz5TJDcar/gqTpYFdTgyKScmN51GkDyc+4MkZo0Ipc0zzWu9gQgZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758722850; c=relaxed/simple;
	bh=PMuIXw6D0/PRLixd3amMXiUS7hj4rJGTlBoNyOUeO0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGAzvp/lrhEnNohDzNubx7p+m+0cswcTcZLmS+0o6klcY3T66cWkvK4KZ+bHFs2Ht6MEjAjBVR/KjqFRb5vX+Pgzq0N3K3afaXYNhLteEr0KWyvi4mwZlIE9jTnzyjJo5oNsiLE8w6HapIJG7bSkGh5bEapB8SP9j2/d+JJ/rvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 13895601C9; Wed, 24 Sep 2025 16:07:26 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 5/6] selftests: netfilter: nft_concat_range.sh: add check for double-create bug
Date: Wed, 24 Sep 2025 16:06:53 +0200
Message-ID: <20250924140654.10210-6-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250924140654.10210-1-fw@strlen.de>
References: <20250924140654.10210-1-fw@strlen.de>
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

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 56 ++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 20e76b395c85..ad97c6227f35 100755
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
@@ -1900,6 +1912,48 @@ test_bug_avx2_mismatch()
 	fi
 }
 
+test_bug_doublecreate()
+{
+	local elements="1.2.3.4 . 1.2.4.1, 1.2.4.1 . 1.2.3.4"
+	local ret=1
+	local i
+
+	setup veth send_"${proto}" set || return ${ksft_skip}
+
+	add "{ $elements }" || return 1
+	# expected to work: 'add' on existing should be no-op.
+	add "{ $elements }" || return 1
+
+	# 'create' should return an error.
+	if nft create element inet filter test "{ $elements }" 2>/dev/null; then
+		err "Could create an existing element"
+		return 1
+	fi
+nft -f - <<EOF 2>/dev/null
+flush set inet filter test
+create element inet filter test { $elements }
+create element inet filter test { $elements }
+EOF
+	ret=$?
+	if [ $ret -eq 0 ]; then
+		err "Could create element twice in one transaction"
+		err "$(nft -a list ruleset)"
+		return 1
+	fi
+
+nft -f - <<EOF 2>/dev/null
+flush set inet filter test
+create element inet filter test { $elements }
+EOF
+	ret=$?
+	if [ $ret -ne 0 ]; then
+		err "Could not flush and re-create element in one transaction"
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

