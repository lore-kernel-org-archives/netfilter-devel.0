Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316719;
	b=zbhtV8QMO3cwgzaMTWVBDiYv+WPeHXPIsLidowcAZKNew4UapYxZ9wR/2zOdX3e2KlWZ
	 ZUADwAaWDHylnzXjepZtAEwGab4CR/z5WVIE1mUtxMuraKYxOLxgZdhOIajcLYwUCG7ij
	 lsn2ecix8M/2YO996hiMq/tVnEMM7YZcDhXxUsVianZIZMTcGJBz6IxIDfiUA6f98Kce0
	 N9WRSnELFkHu8ZyJTjP7Rttp+WC3Kzr11hXmgDTPltmE/CYrcP20E/MaLEhHUAjixyoVn
	 Cpg6hdDYfQpOkoYmPT0/cL8EHEsF7V8HDEz9d2sy3OaZi5dNGyqo1XZk+HPM6SrkuIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316719;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:
	 DKIM-Signature;
	bh=1C/fnf89cUNx1UL0oOgTgDMQKEaqlsJP/h5JbLgPiys=;
	b=fyesk8FC8yg1SJ95cLWCe0kNHux+cuBgRCBakEoJ+4K/kzxR4I9nNhusyL4b5GdssP2N
	 sMu92AXfHaWZ0kGoFq6YegqqInZmmcWhbFJPKu2RvP0qMyCfEH9oc0TLg2i9poRgCeUa9
	 CZetAV6uSqy6EjuQCJp+Cxfts5+CEGu5x7dKoYjGWx0fWkNsMp6THHBJniMXPr8rrKCBf
	 GRIKBYBFNoYGuOo5Hh3K5xV9m1MUU4pvr5/XMjP2j7Mf2/e0L3kfpGlcybarahztPQXAZ
	 A4nifUf30P0f49L3jiWffav12Biw0SFWixzYl87nkcQ+THcY2gDk3PVzWiTs6+EaoJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=bKyDX1oT;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD05606B6DC
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BD05606B6DC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=bKyDX1oT
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 7DC1060D3F
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 14:18:37 +0100 (CET)
Received: (qmail 19616 invoked by uid 990); 10 Nov 2026 13:18:37 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 10 Nov 2026 14:18:37 +0100
From: Leonard Lausen <leonard@lausen.nl>
To: netdev@vger.kernel.org
Cc: leonard@lausen.nl,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] selftests: netfilter: cover IPv6 FIB rule suppression
Date: Tue, 10 Nov 2026 13:16:40 +0000
Message-ID: <20261110131638.15004-7-leonard@lausen.nl>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261110131638.15004-3-leonard@lausen.nl>
References: <20261110131638.15004-3-leonard@lausen.nl>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -----
X-Rspamd-Report: REPLY(-4) BAYES_HAM(-2.999956) MID_CONTAINS_FROM(1) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -5.599956
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=qynhRgY2JpWjstGEijv7L+7dlXnlYftKDMuVeub5Zm0=;
	b=bKyDX1oTz4UOAJyRZB6msfxVRrBhxcHE0BVxbONt5m4kSfr6ExGzHDREjq7nTvWK1EBWoONwJU
	tbARIvsUdy2iMqizWCLogE/Y9BT5vb8tmNvtwYopYo8v7M115R9+oq3BFh5YGDv5iXwrZRuEcrCh
	5S4gnbeBY/RljYlEUUY4YuXlApHK6mmcxy6SZsmnELwqj+25cu3eu8sl9hbkgI0CPUkvE+scRBXD
	MSoAHOSpqMyKN5KstMYBNQY+eDQ77gGjSEPbSq4MxNzAF/uNwzW2SOIQmVkq2SGAATearHsgDKbP
	2yJOD0S5aT5dZ3bW7Rh7oE88g8IA7elCVyEt8BPjqU1Suym8CJzPI4o2n45gANO2v93bbc8N12TZ
	9Rwx+P/ji80WvVs7SzGjlGXvzlwV4RbmSHVseJOk7s/RDaECPHa8tX8NiKD8HBqekHTS9ckpOlBL
	NS3q4FB6Bo3QIdxly8j9SwJsVZ9bU/b7DbKA7DTR8sPvRZWhd19hmBmR1rfAEdwHAXFasvbMNKob
	GL4NlKUuZ7gNfFcQC/l4KTHWh044GT2fZFLg1xzYZSu4FxZ5KCOEnRsn/KCBsT0JBfuqX8xVDRfP
	1bPpsozXaZHILkDJ2zNTKOJydV/w6PhKaYyrpKI4HGEJLgCGUsCw8A2evqqY/uPC9dbfijVrLpJB
	8=

Extend nft_fib.sh using its existing namespaces, interfaces and counter
helper to exercise suppress_prefixlength and suppress_ifgroup.

Check that a default route and a route through a matching interface group
are suppressed, while a non-default route and a nonmatching group remain
usable. Also check that blackhole, unreachable and prohibit routes remain
terminal under either suppression attribute despite a usable route in a
later table.

Count an arriving probe only when the nftables FIB result matches the
expected output interface or reject type. Compare this with an ordinary
route lookup, which must select the expected device or fail for a reject
route. Requiring a positive counter avoids treating a missing packet as
proof of correct suppression.

Assisted-by: LLM
Signed-off-by: Leonard Lausen <leonard@lausen.nl>
---
 .../selftests/net/netfilter/nft_fib.sh        | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index 04544905c216..02b625794669 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -202,6 +202,38 @@ check_fib_counter() {
 	return 0
 }
 
+# Count and drop probes before the existing RPF rules can log expected failures.
+test_fib_suppress() {
+	local label="$1" expected="$2"
+	local result="${3:-oifname}" err=0
+
+	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF || return 1
+flush table ip6 filter
+table ip6 filter {
+	chain prerouting {
+		type filter hook prerouting priority -1;
+		ip6 saddr dead:1::99 icmpv6 type echo-request \
+			fib saddr . mark $result "$expected" counter drop
+	}
+}
+EOF
+	ip netns exec "$ns1" ping -6 -c 1 -W 0.1 -q dead:1::1 > /dev/null 2>&1
+	if [ "$result" = type ]; then
+		ip -net "$nsrouter" -6 route get dead:1::99 from dead:1::1 > /dev/null 2>&1 && err=1
+	else
+		ip -net "$nsrouter" -6 route get dead:1::99 from dead:1::1 |
+			grep -q "dev $expected " || err=1
+	fi
+	if check_fib_type_counter_family ip6 1 "$nsrouter" prerouting "$result" "$label" &&
+	   [ "$err" -eq 0 ]; then
+		echo "PASS: $label"
+	else
+		echo "FAIL: $label"
+		ret=1
+		return 1
+	fi
+}
+
 load_ruleset "$nsrouter"
 load_ruleset "$ns1"
 load_ruleset "$ns2"
@@ -724,6 +756,42 @@ test_fib_vrf()
 	check_fib_veth_vrf_type "fib expression address types match (iif in vrf)"
 }
 
+# Test both suppression attributes before the other policy-routing tests.
+# The non-default route and nonmatching group must remain usable.
+ip -net "$nsrouter" -6 route add table 128 default dev veth1 || exit 1
+ip -net "$nsrouter" -6 route add table 129 dead:1::/64 dev veth0 || exit 1
+ip -net "$nsrouter" link set veth1 group 42 || exit 1
+ip -net "$nsrouter" -6 rule add pref 100 to dead:1::99 table 128 suppress_prefixlength 0 || exit 1
+ip -net "$nsrouter" -6 rule add pref 101 to dead:1::99 table 129 || exit 1
+ip netns exec "$nsrouter" nft add table ip6 filter || exit 1
+
+test_fib_suppress "suppress default route" veth0 || ret=1
+ip -net "$nsrouter" -6 route add table 128 dead:1::/64 dev veth1 || exit 1
+test_fib_suppress "retain non-default route" veth1 || ret=1
+ip -net "$nsrouter" -6 rule del pref 100
+ip -net "$nsrouter" -6 rule add pref 100 to dead:1::99 table 128 suppress_ifgroup 42 || exit 1
+test_fib_suppress "suppress matching interface group" veth0 || ret=1
+ip -net "$nsrouter" link set veth1 group 43 || exit 1
+test_fib_suppress "retain nonmatching interface group" veth1 || ret=1
+
+# Reject routes use loopback (group 0) and must remain terminal.
+ip -net "$nsrouter" -6 route flush table 128
+for suppress in suppress_prefixlength suppress_ifgroup; do
+	ip -net "$nsrouter" -6 rule del pref 100
+	ip -net "$nsrouter" -6 rule add pref 100 to dead:1::99 table 128 "$suppress" 0 || exit 1
+	for type in blackhole unreachable prohibit; do
+		ip -net "$nsrouter" -6 route replace "$type" default table 128 || exit 1
+		test_fib_suppress "retain $type ($suppress)" "$type" type || ret=1
+	done
+done
+
+ip -net "$nsrouter" -6 rule del pref 100
+ip -net "$nsrouter" -6 rule del pref 101
+ip -net "$nsrouter" -6 route flush table 128
+ip -net "$nsrouter" -6 route flush table 129
+ip -net "$nsrouter" link set veth1 group 0
+ip netns exec "$nsrouter" nft delete table ip6 filter
+
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
-- 
2.55.0

