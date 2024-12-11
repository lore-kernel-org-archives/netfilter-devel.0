Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D76A1DD0FE;
	Wed, 11 Dec 2024 23:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733958105; cv=none; b=TdebJ0coU0ZbLyvsrJJRDMXVb/Hh2snI+wG+VqPeyImvq6YPfVdAg6k7/90Nlso3UhEwRtzTGho/k+ki4OihD0UQiuEU67hMP975dmmrqHAR3x/uFxQRQ+ac2q8G6zliJ2JUNaTVQxjPzxumEx2zsYTmiY63mVIxMPWBmTdmhfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733958105; c=relaxed/simple;
	bh=jF6aZVIKGs2z0glJGb/foE/SdXqX/dhp9xSLKYLZxF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aTmAD31iHB8SIQkTs/0w8bHsqLw8WJGF1yBggy9IAmGvid89EDtqPgGxkg1KtcLoimZ850TuzRLFZP8ArJjQ0e+n65RfrgdNH/WkLy+IHU1gQcXNgW8osk61r30jacU5aplI2UoPlJwFoxmxJdtZB0Qd28VcQl5THK0um/2DQeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	phil@netfilter.org
Subject: [PATCH net 1/3] selftests: netfilter: Stabilize rpath.sh
Date: Thu, 12 Dec 2024 00:01:28 +0100
Message-Id: <20241211230130.176937-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241211230130.176937-1-pablo@netfilter.org>
References: <20241211230130.176937-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

On some systems, neighbor discoveries from ns1 for fec0:42::1 (i.e., the
martian trap address) would happen at the wrong time and cause
false-negative test result.

Problem analysis also discovered that IPv6 martian ping test was broken
in that sent neighbor discoveries, not echo requests were inadvertently
trapped

Avoid the race condition by introducing the neighbors to each other
upfront. Also pin down the firewall rules to matching on echo requests
only.

Fixes: efb056e5f1f0 ("netfilter: ip6t_rpfilter: Fix regression with VRF interfaces")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/rpath.sh | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/rpath.sh b/tools/testing/selftests/net/netfilter/rpath.sh
index 4485fd7675ed..86ec4e68594d 100755
--- a/tools/testing/selftests/net/netfilter/rpath.sh
+++ b/tools/testing/selftests/net/netfilter/rpath.sh
@@ -61,9 +61,20 @@ ip -net "$ns2" a a 192.168.42.1/24 dev d0
 ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
+# avoid neighbor lookups and enable martian IPv6 pings
+ns2_hwaddr=$(ip -net "$ns2" link show dev v0 | \
+	     sed -n 's, *link/ether \([^ ]*\) .*,\1,p')
+ns1_hwaddr=$(ip -net "$ns1" link show dev v0 | \
+	     sed -n 's, *link/ether \([^ ]*\) .*,\1,p')
+ip -net "$ns1" neigh add fec0:42::1 lladdr "$ns2_hwaddr" nud permanent dev v0
+ip -net "$ns1" neigh add fec0:23::1 lladdr "$ns2_hwaddr" nud permanent dev v0
+ip -net "$ns2" neigh add fec0:42::2 lladdr "$ns1_hwaddr" nud permanent dev d0
+ip -net "$ns2" neigh add fec0:23::2 lladdr "$ns1_hwaddr" nud permanent dev v0
+
 # firewall matches to test
 [ -n "$iptables" ] && {
 	common='-t raw -A PREROUTING -s 192.168.0.0/16'
+	common+=' -p icmp --icmp-type echo-request'
 	if ! ip netns exec "$ns2" "$iptables" $common -m rpfilter;then
 		echo "Cannot add rpfilter rule"
 		exit $ksft_skip
@@ -72,6 +83,7 @@ ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 }
 [ -n "$ip6tables" ] && {
 	common='-t raw -A PREROUTING -s fec0::/16'
+	common+=' -p icmpv6 --icmpv6-type echo-request'
 	if ! ip netns exec "$ns2" "$ip6tables" $common -m rpfilter;then
 		echo "Cannot add rpfilter rule"
 		exit $ksft_skip
@@ -82,8 +94,10 @@ ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 table inet t {
 	chain c {
 		type filter hook prerouting priority raw;
-		ip saddr 192.168.0.0/16 fib saddr . iif oif exists counter
-		ip6 saddr fec0::/16 fib saddr . iif oif exists counter
+		ip saddr 192.168.0.0/16 icmp type echo-request \
+			fib saddr . iif oif exists counter
+		ip6 saddr fec0::/16 icmpv6 type echo-request \
+			fib saddr . iif oif exists counter
 	}
 }
 EOF
-- 
2.30.2

