Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCBC3793DD;
	Thu, 29 Jan 2026 10:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769684096; cv=none; b=Hy6lsk+nZO6NrCzWdWpHhTLO159Fe12lXZtNb80JMszSANutyVNZxQUWwy4uPzgRk8ZTa7e5M9dcvDgUgV6LLtGXyGVCug4hCDuL+aVJq0mrMf4hOk3iXdgOi6b6PGKeQQ6dqJHCFGAaH4XPb5qUBD4wznTSjQSvtqLKGqDW9Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769684096; c=relaxed/simple;
	bh=eBnBvH3g+J0skf8I7q0Qjp30GtqlVU2nOzST/Vymuw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndaLXRhdPStpZ9ZtK30cYRO08dnLP8/5YpqS3jmzRdCjgyU3CI6OTOx/vXaTwhhzwgvJUk/bGd3AsWg41C/nL+YAphviz13iXQWsBhbBL/1+aNdZTDEwWv2PRL2ffZB37O7GGKOjJ7f95I1S1oeL52vUs2hgBXHRx5t6GdPlQYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6F25960577; Thu, 29 Jan 2026 11:54:53 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 5/7] selftests: netfilter: nft_flowtable.sh: Add IP6IP6 flowtable selftest
Date: Thu, 29 Jan 2026 11:54:25 +0100
Message-ID: <20260129105427.12494-6-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129105427.12494-1-fw@strlen.de>
References: <20260129105427.12494-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Similar to IPIP, introduce specific selftest for IP6IP6 flowtable SW
acceleration in nft_flowtable.sh

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 62 ++++++++++++++++---
 1 file changed, 53 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index a68bc882fa4e..14d7f67715ed 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -592,16 +592,28 @@ ip -net "$nsr1" link set tun0 up
 ip -net "$nsr1" addr add 192.168.100.1/24 dev tun0
 ip netns exec "$nsr1" sysctl net.ipv4.conf.tun0.forwarding=1 > /dev/null
 
+ip -net "$nsr1" link add name tun6 type ip6tnl local fee1:2::1 remote fee1:2::2
+ip -net "$nsr1" link set tun6 up
+ip -net "$nsr1" addr add fee1:3::1/64 dev tun6 nodad
+
 ip -net "$nsr2" link add name tun0 type ipip local 192.168.10.2 remote 192.168.10.1
 ip -net "$nsr2" link set tun0 up
 ip -net "$nsr2" addr add 192.168.100.2/24 dev tun0
 ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0.forwarding=1 > /dev/null
 
+ip -net "$nsr2" link add name tun6 type ip6tnl local fee1:2::2 remote fee1:2::1
+ip -net "$nsr2" link set tun6 up
+ip -net "$nsr2" addr add fee1:3::2/64 dev tun6 nodad
+
 ip -net "$nsr1" route change default via 192.168.100.2
 ip -net "$nsr2" route change default via 192.168.100.1
+ip -6 -net "$nsr1" route change default via fee1:3::2
+ip -6 -net "$nsr2" route change default via fee1:3::1
 ip -net "$ns2" route add default via 10.0.2.1
+ip -6 -net "$ns2" route add default via dead:2::1
 
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0 accept'
+ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6 accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward \
 	'meta oif "veth0" tcp sport 12345 ct mark set 1 flow add @f1 counter name routed_repl accept'
 
@@ -611,28 +623,51 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel"; then
 	ret=1
 fi
 
+if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
+	echo "PASS: flow offload for ns1/ns2 IP6IP6 tunnel"
+else
+	echo "FAIL: flow offload for ns1/ns2 with IP6IP6 tunnel" 1>&2
+	ip netns exec "$nsr1" nft list ruleset
+	ret=1
+fi
+
 # Create vlan tagged devices for IPIP traffic.
 ip -net "$nsr1" link add link veth1 name veth1.10 type vlan id 10
 ip -net "$nsr1" link set veth1.10 up
 ip -net "$nsr1" addr add 192.168.20.1/24 dev veth1.10
+ip -net "$nsr1" addr add fee1:4::1/64 dev veth1.10 nodad
 ip netns exec "$nsr1" sysctl net.ipv4.conf.veth1/10.forwarding=1 > /dev/null
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif veth1.10 accept'
-ip -net "$nsr1" link add name tun1 type ipip local 192.168.20.1 remote 192.168.20.2
-ip -net "$nsr1" link set tun1 up
-ip -net "$nsr1" addr add 192.168.200.1/24 dev tun1
+
+ip -net "$nsr1" link add name tun0.10 type ipip local 192.168.20.1 remote 192.168.20.2
+ip -net "$nsr1" link set tun0.10 up
+ip -net "$nsr1" addr add 192.168.200.1/24 dev tun0.10
 ip -net "$nsr1" route change default via 192.168.200.2
-ip netns exec "$nsr1" sysctl net.ipv4.conf.tun1.forwarding=1 > /dev/null
-ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun1 accept'
+ip netns exec "$nsr1" sysctl net.ipv4.conf.tun0/10.forwarding=1 > /dev/null
+ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0.10 accept'
+
+ip -net "$nsr1" link add name tun6.10 type ip6tnl local fee1:4::1 remote fee1:4::2
+ip -net "$nsr1" link set tun6.10 up
+ip -net "$nsr1" addr add fee1:5::1/64 dev tun6.10 nodad
+ip -6 -net "$nsr1" route change default via fee1:5::2
+ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6.10 accept'
 
 ip -net "$nsr2" link add link veth0 name veth0.10 type vlan id 10
 ip -net "$nsr2" link set veth0.10 up
 ip -net "$nsr2" addr add 192.168.20.2/24 dev veth0.10
+ip -net "$nsr2" addr add fee1:4::2/64 dev veth0.10 nodad
 ip netns exec "$nsr2" sysctl net.ipv4.conf.veth0/10.forwarding=1 > /dev/null
-ip -net "$nsr2" link add name tun1 type ipip local 192.168.20.2 remote 192.168.20.1
-ip -net "$nsr2" link set tun1 up
-ip -net "$nsr2" addr add 192.168.200.2/24 dev tun1
+
+ip -net "$nsr2" link add name tun0.10 type ipip local 192.168.20.2 remote 192.168.20.1
+ip -net "$nsr2" link set tun0.10 up
+ip -net "$nsr2" addr add 192.168.200.2/24 dev tun0.10
 ip -net "$nsr2" route change default via 192.168.200.1
-ip netns exec "$nsr2" sysctl net.ipv4.conf.tun1.forwarding=1 > /dev/null
+ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0/10.forwarding=1 > /dev/null
+
+ip -net "$nsr2" link add name tun6.10 type ip6tnl local fee1:4::2 remote fee1:4::1
+ip -net "$nsr2" link set tun6.10 up
+ip -net "$nsr2" addr add fee1:5::2/64 dev tun6.10 nodad
+ip -6 -net "$nsr2" route change default via fee1:5::1
 
 if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel over vlan"; then
 	echo "FAIL: flow offload for ns1/ns2 with IPIP tunnel over vlan" 1>&2
@@ -640,10 +675,19 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel over vlan"; then
 	ret=1
 fi
 
+if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
+	echo "PASS: flow offload for ns1/ns2 IP6IP6 tunnel over vlan"
+else
+	echo "FAIL: flow offload for ns1/ns2 with IP6IP6 tunnel over vlan" 1>&2
+	ip netns exec "$nsr1" nft list ruleset
+	ret=1
+fi
+
 # Restore the previous configuration
 ip -net "$nsr1" route change default via 192.168.10.2
 ip -net "$nsr2" route change default via 192.168.10.1
 ip -net "$ns2" route del default via 10.0.2.1
+ip -6 -net "$ns2" route del default via dead:2::1
 }
 
 # Another test:
-- 
2.52.0

