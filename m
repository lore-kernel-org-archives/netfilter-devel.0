Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC25372ED7;
	Thu, 23 Jul 2026 16:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824781; cv=none; b=PhD1GZfdMObtUc/F/8gXk33XbQmooh4tauqckktJPpoNZPrKacnoY5husy5L8lAvE7xwaUqPf6bvVjcAgKWE7pvA/YkaP6RXE9TJ0S3AlcE4eyLSMKfkckg3X9aguXIak5A1rE6jyofxHYcVsEjZyCuT6nVdZYAfLuNGvV+p5js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824781; c=relaxed/simple;
	bh=NIdmLCTd7Q2NsvVjj05jcbnXKZQTagFAuAnpP96l1jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qAyPxxBFCOb98r1RjsiPws45VvSQvlXW/nWhjGL2mJ2CNcSd9gVovqhZyAz947ZyK3VqSMntDFplrzBiMK66WgKiU7DAxiCezaW76LN98WqqqEfeF8Lg4rwysaCEziWnwY4MG9wnyjIrINpc2liwYUHXG2OkmDRFn29o33uXlZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vg+tqtgD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vg+tqtgD"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2CE9B601B1;
	Thu, 23 Jul 2026 18:39:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784824767;
	bh=Rfo0NPKv1IXCNVA+a/iUoCJP+bUvGckzA86APzAyVBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vg+tqtgDJCoLcFxHRNKedColgw0dEPiahsCPxCKzaefFkMqdDHbSMeWNHVGt3CpYa
	 5nbo2DDSkjd5ZAtlmRAjI1y00Z9dByQodjSX3H6GhrpvTkfP+t0wJUOXrvOm2wm7Sc
	 uNchEQKU5VDpqASA8JwXWm8gUsETbOf6a7d/7RdYRy4OuGQfzIzerZ9YJtM43KwpPw
	 vXMmkYyFOzavbTt9RkN7RRnXn2llxQ0VIZG/GryZNEIoCl1XG1Ov9BeNVdTXPi9cGn
	 p22+DyU8n6+ScPFdQtsGrB8vByDDnN6WqWarvr+agD49p26WBPuwuBXKX3YuIhxk9u
	 7RXx3MC3em1Qg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 02/13] selftests: netfilter: nft_flowtable.sh: fix offload counter verification for tunnel tests
Date: Thu, 23 Jul 2026 18:38:59 +0200
Message-ID: <20260723163910.274695-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723163910.274695-1-pablo@netfilter.org>
References: <20260723163910.274695-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

The IPIP and IP6IP6 tunnel tests call check_counters() to verify
flowtable offloading occurred, but the flow-add rule only matches
meta oif "veth1". When traffic is routed through a tunnel device,
oif is the tunnel interface (tun0, tun6, etc.), not veth1, so
the flow-add rule never fires, no flowtable entry is created,
and counters stay at zero — producing a silent false pass.
Fix by adding tunnel-specific flow-add rules for each tunnel
interface. These match TCP dport 12345 traffic before the bare
accept rule, set ct mark, add the flow to the flowtable, and
increment routed_orig. The existing routed_repl rule on veth0
already handles the reply direction since decapsulated reply
packets exit through the physical interface.
Also add check_counters() for the IP6IP6 non-VLAN and
IP6IP6-over-VLAN tests which previously used a bare PASS message.

Fixes: fe8313316eaf ("selftests: netfilter: nft_flowtable.sh: Add IPIP flowtable selftest")
Fixes: 5e5180352193 ("selftests: netfilter: nft_flowtable.sh: Add IP6IP6 flowtable selftest")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/nft_flowtable.sh       | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index fb1c59d45567..449c518bd947 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -617,7 +617,11 @@ ip -6 -net "$nsr2" route add default via fee1:3::1
 ip -net "$ns2" route add default via 10.0.2.1
 ip -6 -net "$ns2" route add default via dead:2::1
 
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif tun0 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0 accept'
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif tun6 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6 accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward \
 	'meta oif "veth0" tcp sport 12345 ct mark set 1 flow add @f1 counter name routed_repl accept'
@@ -629,7 +633,7 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel"; then
 fi
 
 if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
-	echo "PASS: flow offload for ns1/ns2 IP6IP6 tunnel"
+	check_counters "flow offload for ns1/ns2 IP6IP6 tunnel"
 else
 	echo "FAIL: flow offload for ns1/ns2 with IP6IP6 tunnel" 1>&2
 	ip netns exec "$nsr1" nft list ruleset
@@ -642,6 +646,8 @@ ip -net "$nsr1" link set veth1.10 up
 ip -net "$nsr1" addr add 192.168.20.1/24 dev veth1.10
 ip -net "$nsr1" addr add fee1:4::1/64 dev veth1.10 nodad
 ip netns exec "$nsr1" sysctl net.ipv4.conf.veth1/10.forwarding=1 > /dev/null
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif veth1.10 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif veth1.10 accept'
 
 ip -net "$nsr1" link add name tun0.10 type ipip local 192.168.20.1 remote 192.168.20.2
@@ -649,6 +655,8 @@ ip -net "$nsr1" link set tun0.10 up
 ip -net "$nsr1" addr add 192.168.200.1/24 dev tun0.10
 ip -net "$nsr1" route change default via 192.168.200.2
 ip netns exec "$nsr1" sysctl net.ipv4.conf.tun0/10.forwarding=1 > /dev/null
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif tun0.10 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0.10 accept'
 
 ip -net "$nsr1" link add name tun6.10 type ip6tnl local fee1:4::1 remote fee1:4::2 encaplimit none
@@ -656,6 +664,8 @@ ip -net "$nsr1" link set tun6.10 up
 ip -net "$nsr1" addr add fee1:5::1/64 dev tun6.10 nodad
 ip -6 -net "$nsr1" route delete default
 ip -6 -net "$nsr1" route add default via fee1:5::2
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif tun6.10 tcp dport 12345 ct mark set 1 flow add @f1 counter name routed_orig accept'
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6.10 accept'
 
 ip -net "$nsr2" link add link veth0 name veth0.10 type vlan id 10
@@ -683,7 +693,7 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel over vlan"; then
 fi
 
 if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
-	echo "PASS: flow offload for ns1/ns2 IP6IP6 tunnel over vlan"
+	check_counters "flow offload for ns1/ns2 IP6IP6 tunnel over vlan"
 else
 	echo "FAIL: flow offload for ns1/ns2 with IP6IP6 tunnel over vlan" 1>&2
 	ip netns exec "$nsr1" nft list ruleset
-- 
2.47.3

