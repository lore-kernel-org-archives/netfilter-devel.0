Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D781436CDFD;
	Fri, 10 Jul 2026 14:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694288; cv=none; b=K2bynRDn/S9WIy8nNWodV3OYp462UiOrzkxOZ7+fSDmKeZ3LpPuCHgIMfDd+kntcX79wOk3KVeoOmG7I6PL3YrtByvXqeOpwqRzMoAJNHztQ/9pmob5gNYNKSBRKq8sYBsZG+2Adudq/GIgUpIpAXLdPAPA4zCAz1u4Hz2RODcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694288; c=relaxed/simple;
	bh=xt5TYZWmeX+1uB1/dJbHRcr6LQkItZKl9fZYkgzVotU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEWWU8r9NdMLahSG6JU0pReCPf7J6ppVEoC8w7JCpSV/qA5EZqEnA3pHkha8j+FAwoMRJwFlpZ/pKAYce8WSbLu+/RW4xcauWQ+9PSnjkyLZckcUazwIB/BaMdOFdXByAUn/Urm1D0/N+Usi/C4P/LLfnCh8dgC0Ri42emJQx2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 271776059A; Fri, 10 Jul 2026 16:38:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 5/9] selftests: netfilter: add bridge tunnel flowtable regression
Date: Fri, 10 Jul 2026 16:37:29 +0200
Message-ID: <20260710143733.29741-6-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710143733.29741-1-fw@strlen.de>
References: <20260710143733.29741-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>

Add a nft_flowtable.sh regression test for the bridge direct-xmit plus
IPIP/IP6IP6 underlay configuration that reproduces the reachable
DIRECT+tunnel tuple combination exercised by the flowtable fix.

The test reuses the existing bridge and tunnel topology, installs flow
rules for the tunnel egress and bridge reply path, verifies IPv4 and
IPv6 forwarding, and checks the flowtable counters after the transfer.

Signed-off-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 08ad07500e8a..fb1c59d45567 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -736,6 +736,61 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "on bridge"; then
 	ret=1
 fi
 
+if ip -net "$nsr1" link show tun0 > /dev/null 2>&1 &&
+   ip -net "$nsr2" link show tun0 > /dev/null 2>&1; then
+	ip -net "$nsr1" route change default via 192.168.100.2
+	ip -net "$nsr2" route change default via 192.168.100.1
+	ip -6 -net "$nsr1" route delete default
+	ip -6 -net "$nsr1" route add default via fee1:3::2
+	ip -6 -net "$nsr2" route delete default
+	ip -6 -net "$nsr2" route add default via fee1:3::1
+	ip -net "$ns2" route add default via 10.0.2.1
+	ip -6 -net "$ns2" route add default via dead:2::1
+
+	ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+		'meta oif "tun0" tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
+	ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+		'meta oif "tun6" tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
+	ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+		'meta oif "veth0" tcp sport 12345 ct mark set 1 flow add @f1 counter name routed_repl accept'
+	ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+		'meta oif "br0" tcp sport 12345 ct mark set 1 flow add @f1 counter name routed_repl accept'
+	ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+		'meta oif "tun0" accept'
+	ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+		'meta oif "tun6" accept'
+
+	ip netns exec "$nsr1" nft reset counters table inet filter >/dev/null
+
+	if test_tcp_forwarding "$ns1" "$ns2" 1 4 10.0.2.99 12345; then
+		check_counters "bridge + IPIP tunnel"
+	else
+		echo "FAIL: flow offload for ns1/ns2 with bridge + IPIP tunnel" 1>&2
+		ip netns exec "$nsr1" nft list ruleset
+		ret=1
+	fi
+
+	if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
+		check_counters "bridge + IP6IP6 tunnel"
+	else
+		echo "FAIL: flow offload for ns1/ns2 with bridge + IP6IP6 tunnel" 1>&2
+		ip netns exec "$nsr1" nft list ruleset
+		ret=1
+	fi
+
+	ip -net "$nsr1" route change default via 192.168.10.2
+	ip -net "$nsr2" route change default via 192.168.10.1
+	ip -net "$ns2" route del default via 10.0.2.1
+	ip -6 -net "$nsr1" route delete default
+	ip -6 -net "$nsr1" route add default via fee1:2::2
+	ip -6 -net "$nsr2" route delete default
+	ip -6 -net "$nsr2" route add default via fee1:2::1
+	ip -6 -net "$ns2" route del default via dead:2::1
+else
+	echo "SKIP: bridge + tunnel flowtable regression (tun0 missing)"
+	[ "$ret" -eq 0 ] && ret=$ksft_skip
+fi
+
 
 # Another test:
 # Add bridge interface br0 to Router1, with NAT and VLAN.
-- 
2.54.0

