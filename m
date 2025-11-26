Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B37C341066;
	Wed, 26 Nov 2025 20:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190594; cv=none; b=d7e/aQyQxhQmuAlY0QA4QuuqeApgaeDbJZBwQrdRnyVACIlB66tM9Y5MFaLGbsWtR/8Wr7Xu5+VrnaMgz6LFERB50t1toAuoImc8I273qm8RtpuB70XLxyF3lhWoFWrHJnhetkn+GOaLVm3AMLEcgU3EunssUsMvFpdXuKHR0b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190594; c=relaxed/simple;
	bh=CCp337cOgWT3K/FBhL++UJabMQhj3hu5joXaJllx+OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8KNv5oXaPw6GX8w9Yj6dvFMaRfbZ2V7FuQwgIZ8kGLuJEG5z9QCx1C696zq12Y78Wauame+KvV6vI+9l7k/ZCf1jLRkUUicAeE1CVqx5WyB/Ij8c5r2+TlHt/TTmsFj2I1GbNsewWQ2IRiHi8pS49NaTXjCLk5mgsFxgR2+jJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rFvVyMSj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rFvVyMSj"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4BD4260272;
	Wed, 26 Nov 2025 21:56:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764190591;
	bh=T7bPM5KoP3jiWf5fkk9CB/l5L9hRQD0NeNXWmwX85yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFvVyMSj+oK29UXVnrJukbNXB0toHYpOnkY2wBkdCJwR3cqF0zsibeqg+rcaC6mmO
	 CtIR1ap6EyvScN3KhNFGaEzS2LvNBT8qPquPm3UXVHKCQ0zdiHERVVr64XO1He1BvV
	 uO94+rg3TxW0enFYIsv0+sYYvrH2uT4jqVYEWWkxHscrrEiMyWMdM3SChk3nEG7dBt
	 D8i2QnFH7NsQQrBoyPMh3VCGPE2o4ayaoBMPBbdok4J4acuOFWDINBAcSiHT5sVWj9
	 UkTUDNnD3IMn3CWIE6l3n1+Om8YQQbyPL+A9fyTO6ytU5KNWSCLWCOPIC+LsO/XWc8
	 ecSR3Vx0ucT+g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 09/16] selftests: netfilter: nft_flowtable.sh: Add IPIP flowtable selftest
Date: Wed, 26 Nov 2025 20:56:04 +0000
Message-ID: <20251126205611.1284486-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126205611.1284486-1-pablo@netfilter.org>
References: <20251126205611.1284486-1-pablo@netfilter.org>
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

