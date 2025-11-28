Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0955A22B8B6;
	Fri, 28 Nov 2025 00:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289445; cv=none; b=TOVwH/lJg5DElSDB6sKoJz0XGpNM4fOaD58ZObqyNoJ4spJVco7dWROtF3rdrpu4LDPL6L9SwHCh6nA5b0xKmStKckRmMRF5MLw94sITXMX0RR+JwVroK4Ry9nWReT4m16ThaYlAv+fVABVOex8PHfYnGjxuvRAZRReWTzFS3A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289445; c=relaxed/simple;
	bh=CCp337cOgWT3K/FBhL++UJabMQhj3hu5joXaJllx+OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVLGoA3ZpRjV35CnQiJGnglFqIZAdIzBXIvXAUrRfM1bZevRIoYrigMmA27biyjedMejtT5vKu0DClFUUbx60vZjgHri/uhbyLhYhVbpYDGmJdEPMKgv6s9tczvwQDgRwSmbTHQXPEzhBJEai5/Ib7Qo0raINSYDFvps0GPP8cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WTVoGdEF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WTVoGdEF"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7FCBC600B5;
	Fri, 28 Nov 2025 01:24:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289441;
	bh=T7bPM5KoP3jiWf5fkk9CB/l5L9hRQD0NeNXWmwX85yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTVoGdEF8qdYfY+O7nsSzA2ypz2Uq26osjKDS/TGynlbOIz2qK8AbZaNk4k5bjVql
	 PomfK3NaplPR9OMlyruy0Hhb74PBKEAQyOyOl/yVRq3dglWxFRs6N2oMcb2dxWkXau
	 35vjgjPc5ybvqBqU7Eyt8I56OwLfiM+XV3GFqu6WLdRiIL99FGzHLvaoetGaZv3SJU
	 nWleCTU5P3paDsq2swiVZVeFbOaMs6k5mc6X6AMgJgdisRm3U7fF10XcMLwAvoMCy0
	 uLCJ9omPkT7VN3KDJGQzmjQuw1glw4wQ+/Ql3bKrVva6cQlUqTL2IN7C93iYtby6rG
	 TFzkqaO9ryPIQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 10/17] selftests: netfilter: nft_flowtable.sh: Add IPIP flowtable selftest
Date: Fri, 28 Nov 2025 00:23:37 +0000
Message-ID: <20251128002345.29378-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce specific selftest for IPIP flowtable SW acceleration in
nft_flowtable.sh

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 45832df98295..1fbfc8ad8dcd 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -558,6 +558,73 @@ if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 ""; then
 	ip netns exec "$nsr1" nft list ruleset
 fi
 
+# IPIP tunnel test:
+# Add IPIP tunnel interfaces and check flowtable acceleration.
+test_ipip() {
+if ! ip -net "$nsr1" link add name tun0 type ipip \
+     local 192.168.10.1 remote 192.168.10.2 >/dev/null;then
+	echo "SKIP: could not add ipip tunnel"
+	[ "$ret" -eq 0 ] && ret=$ksft_skip
+	return
+fi
+ip -net "$nsr1" link set tun0 up
+ip -net "$nsr1" addr add 192.168.100.1/24 dev tun0
+ip netns exec "$nsr1" sysctl net.ipv4.conf.tun0.forwarding=1 > /dev/null
+
+ip -net "$nsr2" link add name tun0 type ipip local 192.168.10.2 remote 192.168.10.1
+ip -net "$nsr2" link set tun0 up
+ip -net "$nsr2" addr add 192.168.100.2/24 dev tun0
+ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0.forwarding=1 > /dev/null
+
+ip -net "$nsr1" route change default via 192.168.100.2
+ip -net "$nsr2" route change default via 192.168.100.1
+ip -net "$ns2" route add default via 10.0.2.1
+
+ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0 accept'
+ip netns exec "$nsr1" nft -a insert rule inet filter forward \
+	'meta oif "veth0" tcp sport 12345 ct mark set 1 flow add @f1 counter name routed_repl accept'
+
+if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel"; then
+	echo "FAIL: flow offload for ns1/ns2 with IPIP tunnel" 1>&2
+	ip netns exec "$nsr1" nft list ruleset
+	ret=1
+fi
+
+# Create vlan tagged devices for IPIP traffic.
+ip -net "$nsr1" link add link veth1 name veth1.10 type vlan id 10
+ip -net "$nsr1" link set veth1.10 up
+ip -net "$nsr1" addr add 192.168.20.1/24 dev veth1.10
+ip netns exec "$nsr1" sysctl net.ipv4.conf.veth1/10.forwarding=1 > /dev/null
+ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif veth1.10 accept'
+ip -net "$nsr1" link add name tun1 type ipip local 192.168.20.1 remote 192.168.20.2
+ip -net "$nsr1" link set tun1 up
+ip -net "$nsr1" addr add 192.168.200.1/24 dev tun1
+ip -net "$nsr1" route change default via 192.168.200.2
+ip netns exec "$nsr1" sysctl net.ipv4.conf.tun1.forwarding=1 > /dev/null
+ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun1 accept'
+
+ip -net "$nsr2" link add link veth0 name veth0.10 type vlan id 10
+ip -net "$nsr2" link set veth0.10 up
+ip -net "$nsr2" addr add 192.168.20.2/24 dev veth0.10
+ip netns exec "$nsr2" sysctl net.ipv4.conf.veth0/10.forwarding=1 > /dev/null
+ip -net "$nsr2" link add name tun1 type ipip local 192.168.20.2 remote 192.168.20.1
+ip -net "$nsr2" link set tun1 up
+ip -net "$nsr2" addr add 192.168.200.2/24 dev tun1
+ip -net "$nsr2" route change default via 192.168.200.1
+ip netns exec "$nsr2" sysctl net.ipv4.conf.tun1.forwarding=1 > /dev/null
+
+if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel over vlan"; then
+	echo "FAIL: flow offload for ns1/ns2 with IPIP tunnel over vlan" 1>&2
+	ip netns exec "$nsr1" nft list ruleset
+	ret=1
+fi
+
+# Restore the previous configuration
+ip -net "$nsr1" route change default via 192.168.10.2
+ip -net "$nsr2" route change default via 192.168.10.1
+ip -net "$ns2" route del default via 10.0.2.1
+}
+
 # Another test:
 # Add bridge interface br0 to Router1, with NAT enabled.
 test_bridge() {
@@ -643,6 +710,8 @@ ip -net "$nsr1" addr add dead:1::1/64 dev veth0 nodad
 ip -net "$nsr1" link set up dev veth0
 }
 
+test_ipip
+
 test_bridge
 
 KEY_SHA="0x"$(ps -af | sha1sum | cut -d " " -f 1)
-- 
2.47.3

