Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE072D7BF;
	Fri,  6 Feb 2026 15:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770391881; cv=none; b=qTG1wtyNbV3RnnPc6NAoIJeuNuUsK/dsiVz5hZoyNG3sBkW8tkQ6S4yQO2AmZgO8VID0Vrpjnimti/YVijAgrigAzBJFtuyZcF/0iUu5axyr4nkGTxxlF2KtLWHnwf3deJpphHSPl5pOghtlRzVfrFq483ivZYJre4Efcwat42A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770391881; c=relaxed/simple;
	bh=8FMC7Ze0tJR47IX7eivWP8GzEgLJJ4tbl1aE8m+SfeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YV5vZHySkvQX7afu78UYDK0PTHE++AUWCVdNvk6No6s8cYyoRmowN4aV7v6+Rn7mRTeVSqsR+NSlTZIukHWetcIvwJNphGtaJp13wqbDSG9xIGneVj75Z8TueeMKdhzsoR6f5i1XTAHqJYDYng2ocp2eBqDglhjgrCTfqMhav7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7DA3E60345; Fri, 06 Feb 2026 16:31:19 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 05/11] selftests: netfilter: add IPV6_TUNNEL to config
Date: Fri,  6 Feb 2026 16:30:42 +0100
Message-ID: <20260206153048.17570-6-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206153048.17570-1-fw@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
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
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
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

