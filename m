Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378E219F121;
	Mon, 13 Jul 2026 12:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947229; cv=none; b=agGjv2IZ3JPCPmfdGPwAOT+EGi1j93CCdadFK64TT1KCOJNUL+NCAgkUO7JzKtdfzvN4XfmvL+OCzMKO0whWq9G5dTz0HyRIvqJL6NS2qkIxLTuPATNzvpUoGnzSfnELcitcenFZ9OceK3a953DrYvKLECwN0WTg9YIZxZ6H95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947229; c=relaxed/simple;
	bh=df0/tk71ArwqJYZi6UifNS1IPX5FyJGZ3vBtfAg/bPw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=cxr3LxUFdTg5koOxXtAxkdBdbhMBKcVcQjiupRNEvEps+lI+YeTkzVisB9ToKq5hKzFV4bJsKc4aJz6TQ5IGHPYMqG40btBxUzbQn0N+lxzJKZTSaVoWROmlId0js8xkmZctQ6fgKm5ajAC+OdzVUD0BaUVeLtQSx8TIyM7901U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrdN4YQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrdN4YQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAFF1F000E9;
	Mon, 13 Jul 2026 12:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783947228;
	bh=BYxt9eG8OStjECbJndGaUeWfB8kBjIV89GTDnz69wUw=;
	h=From:Date:Subject:To:Cc;
	b=MrdN4YQta14aUHZ32FcZjrjmqLhIX07Z+TFIdqOkhe638RiH/fV6xQI8lyKnHGPpi
	 lQLVfM67eIZFImx+ylkAyiOg1HqudOEn03PTerrSZylm7tQ/0GfMVoBb9VM+DALbkr
	 xvVCjfQDyHBOXwfZpyDDlA6uyy35Mw9wqdQymVQmWAjwW2+eO4sS7s6tFxe2/heeUm
	 q5cf74ERgkcGFdDVj6+ZpANS6eOR52XE2aQnivXGo75rXgsASuKdROZG6/Lh3Zc+nZ
	 eaR8X/9C0K82JwdL/+pIK6IgUX/fsWrxEn55O0iqwaDAB5Qztln8Qy6RwMdH2Bt/TU
	 kAOvDWeXZBHrg==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 13 Jul 2026 14:53:22 +0200
Subject: [PATCH nf v2] selftests: netfilter: nft_flowtable.sh: fix offload
 counter verification for tunnel tests
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260713-flowtable-selftest-ip6ip6-fix-v2-1-b49edb4f9620@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42NQQrCMBBFr1Jm7UiTlqS68h7SRbSTdjAkJQlRK
 b27oScQ/ub9D+9vkCgyJbg2G0QqnDj4CvLUwHMxfibkqTLIVqpWC4HWhXc2D0eYyNlMKSOvqgY
 tf7CfBqNkJ3ttOqiONVKtD/8dvIWxdgunHOL3uCziWP60F4ECVUsX0t3QT1bfXhQ9uXOIM4z7v
 v8A0AYchc8AAAA=
X-Change-ID: 20260711-flowtable-selftest-ip6ip6-fix-4d8a623247a3
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Mailer: b4 0.14.3

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
---
Changes in v2:
- Add missing tunnel-specific flow-add rules for each tunnel interface.
- Link to v1: https://lore.kernel.org/r/20260711-flowtable-selftest-ip6ip6-fix-v1-1-60e9e7384df7@kernel.org
---
 tools/testing/selftests/net/netfilter/nft_flowtable.sh | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 08ad07500e8a..d9a21ca8ed2c 100755
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

---
base-commit: 3f1f755366687d051174739fb99f7d560202f60b
change-id: 20260711-flowtable-selftest-ip6ip6-fix-4d8a623247a3

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

