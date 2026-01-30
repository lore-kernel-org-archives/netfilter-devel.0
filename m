Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F341D3033C7
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 18:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769797335; cv=none; b=IVUhi4ilR24TSR4+DgFjSDnQxOmPEsvDCYUno5GNnCGDPfoWToxlj1ZvwgvtQRVGIpq77J8mP3ftjhLzMSJg6lbqOT803YFyclQuXKE6KFvZZZjTVSGiNQi+zEo8fAHLfe6N+iS0UHzwpRYUtmvYMWZ9vnW1mjStFac1S/nPlFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769797335; c=relaxed/simple;
	bh=SzXUH8xA0CWVT4GbGHWqYMCuw+cDNP/x02+nuGEjs7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EI2kT9xOF4r2aWaem0+NAxdm3+aM+HnwFc/jiRqvbAfPlgBB3bhDoEHoNjLd8sfGDsq0Ci3bCBNBDQyoR3V3Y8sg5bMeIkqXIePjyKjz8ZRpVcoWT6br7yaaF9iyHw/qoHCrQie4mX54rBEXK9WS3Clbwarij7rwkHcaqCI6Nqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 87A89602AB; Fri, 30 Jan 2026 19:22:05 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: lorenzo@kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] selftests: netfilter: add IPV6_TUNNEL to config
Date: Fri, 30 Jan 2026 19:21:51 +0100
Message-ID: <20260130182155.93253-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The script now requires IPV6 tunnel support, enable this.
This should have caught by CI, but as the config option is missing,
the tunnel interface isn't added.  This results in an error cascade
that ends with "route change default" failure.

That in turn means the "ipv6 tunnel" test re-uses the previous
test setup so the "ip6ip6" test passes and script returns 0.

Make sure to catch such bugs, set ret=1 if device cannot be added
and delete the old default route before installing the new one.

After this change, IPV6_TUNNEL=n kernel builds fail with the expected
  FAIL: flow offload for ns1/ns2 with IP6IP6 tunnel

... while builds with IPV6_TUNNEL=m pass as before.

Fixes: 5e5180352193 ("selftests: netfilter: nft_flowtable.sh: Add IP6IP6 flowtable selftest")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/config  |  1 +
 .../selftests/net/netfilter/nft_flowtable.sh  | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 12ce61fa15a8..979cff56e1f5 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -29,6 +29,7 @@ CONFIG_IP_NF_RAW=m
 CONFIG_IP_SCTP=m
 CONFIG_IPV6=y
 CONFIG_IPV6_MULTIPLE_TABLES=y
+CONFIG_IPV6_TUNNEL=m
 CONFIG_IP_VS=m
 CONFIG_IP_VS_PROTO_TCP=y
 CONFIG_IP_VS_RR=m
diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 14d7f67715ed..7a34ef468975 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -601,14 +601,19 @@ ip -net "$nsr2" link set tun0 up
 ip -net "$nsr2" addr add 192.168.100.2/24 dev tun0
 ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0.forwarding=1 > /dev/null
 
-ip -net "$nsr2" link add name tun6 type ip6tnl local fee1:2::2 remote fee1:2::1
+ip -net "$nsr2" link add name tun6 type ip6tnl local fee1:2::2 remote fee1:2::1 || ret=1
 ip -net "$nsr2" link set tun6 up
 ip -net "$nsr2" addr add fee1:3::2/64 dev tun6 nodad
 
 ip -net "$nsr1" route change default via 192.168.100.2
 ip -net "$nsr2" route change default via 192.168.100.1
-ip -6 -net "$nsr1" route change default via fee1:3::2
-ip -6 -net "$nsr2" route change default via fee1:3::1
+
+# do not use "route change" and delete old default so
+# socat fails to connect in case new default can't be added.
+ip -6 -net "$nsr1" route delete default
+ip -6 -net "$nsr1" route add default via fee1:3::2
+ip -6 -net "$nsr2" route delete default
+ip -6 -net "$nsr2" route add default via fee1:3::1
 ip -net "$ns2" route add default via 10.0.2.1
 ip -6 -net "$ns2" route add default via dead:2::1
 
@@ -649,7 +654,8 @@ ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun0.10 a
 ip -net "$nsr1" link add name tun6.10 type ip6tnl local fee1:4::1 remote fee1:4::2
 ip -net "$nsr1" link set tun6.10 up
 ip -net "$nsr1" addr add fee1:5::1/64 dev tun6.10 nodad
-ip -6 -net "$nsr1" route change default via fee1:5::2
+ip -6 -net "$nsr1" route delete default
+ip -6 -net "$nsr1" route add default via fee1:5::2
 ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif tun6.10 accept'
 
 ip -net "$nsr2" link add link veth0 name veth0.10 type vlan id 10
@@ -664,10 +670,11 @@ ip -net "$nsr2" addr add 192.168.200.2/24 dev tun0.10
 ip -net "$nsr2" route change default via 192.168.200.1
 ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0/10.forwarding=1 > /dev/null
 
-ip -net "$nsr2" link add name tun6.10 type ip6tnl local fee1:4::2 remote fee1:4::1
+ip -net "$nsr2" link add name tun6.10 type ip6tnl local fee1:4::2 remote fee1:4::1 || ret=1
 ip -net "$nsr2" link set tun6.10 up
 ip -net "$nsr2" addr add fee1:5::2/64 dev tun6.10 nodad
-ip -6 -net "$nsr2" route change default via fee1:5::1
+ip -6 -net "$nsr2" route delete default
+ip -6 -net "$nsr2" route add default via fee1:5::1
 
 if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel over vlan"; then
 	echo "FAIL: flow offload for ns1/ns2 with IPIP tunnel over vlan" 1>&2
-- 
2.52.0

