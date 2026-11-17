Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913712;
	b=AHCORPzaTkzlfAEURazvP2HRrUtv1uLO3Nq1FfcdXCsfjvCgVl0ExyJ79MHXKrzFK6K1
	 7kDjmR0tJgZ+q603xfFDd6rt+3jjeuug8+Ep5YAey43gjHQi/LHrv7UxRVPaqzYr0TOTD
	 r34/jLACuHIncYeAH7se9c3NrBBDsL2oC+m2XLN2B3pplc06t4gC172yJb0/0RRZO1gdr
	 gS2NfArVItKIX5QeV3YeUddlSDuWYecZml36V9N1AB8AnyeEADY73V/sZSwWi/v3xqPzD
	 tXovnZdhEicVop0F8OA60aMhl1QMmJtGsz7xF8vJWk9WerufrCe7AUqBoQ3Fnw+tm+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913712;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:
	 DKIM-Signature;
	bh=/RvB3qJv6CSbIlr5KiUVbq8iym8xVaZo8csqTV6KZro=;
	b=KOONhyYCHdl1Y2rWbiSwV/HOGgvkjZ2AKRlAU4wQhtIqYXP4jNZSW1VWWmc6cu3swe6Z
	 nwrVw+89W6YUnwG870cQKK+odBnLdbLJlmRKH3y5V+89tdQktG30AYZCWH6O5Fvk63HF/
	 2OdL7Q+pDkzJK/5tPHIvaljmfL3u0mustxdAEQllK9AiNuhCy4Pzk8bKPYOapYUPYaM5D
	 WWWVl76plW5jrmtOKt/34g0vFWd+7E5PcXj9vrvz9MbHIwhjCJvmorZRkb7iWePTD7wUu
	 FvrM1e9S+v29In7BF+j6XKqjOWkFA1mJYqCqFR2bGz0igxmtUpGamPRXzog9Z/6tnEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b="FxKd/VOa";
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7746F606A8A1
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:08:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7746F606A8A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=FxKd/VOa
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id D382D61095
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 12:08:29 +0100 (CET)
Received: (qmail 22605 invoked by uid 990); 17 Nov 2026 11:08:29 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 17 Nov 2026 12:08:29 +0100
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
Subject: [PATCH net v4 2/2] selftests: netfilter: cover IPv6 FIB prefix suppression
Date: Tue, 17 Nov 2026 11:08:12 +0000
Message-ID: <20261117110813.9894-4-leonard@lausen.nl>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261117110813.9894-2-leonard@lausen.nl>
References: <20261117110813.9894-2-leonard@lausen.nl>
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
X-Rspamd-Report: REPLY(-4) BAYES_HAM(-2.999923) MID_CONTAINS_FROM(1) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -5.599923
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=0+6TucBtJP1EvGaCe3sII8W6Vv25yTZVBM+bEdyPi40=;
	b=FxKd/VOaJgjwnB4Tf7G/evoiBVXND85GdiEFotGnZOh+NzeDMCIjA1lVXNvlw6tOwIslSNHc9M
	4SsGpg+gXS9ynEyB0zMdpks6lIXvSwsBRjjh1UuKtiULDwT7hOTDwmeF6r3pQ8XR8aR7SkKN1dp2
	5fHB8qCr2KncDn42/zMWCWvJayeg5958WbskLDhcZ4ABTKmV+USxBDhQBf4LjYiHzlQLEtmzsImr
	hzXjVa4TUpHA1WLgyYyDDBaqlryTyS9TgnIcs9Q+2A9ZVdwSmopgWperNA2ZT7WdwvqnfUfJnt7l
	P6idt7eds3wOOrwo8Hv6z9DTmzDQ/iIpOapZW9mwPDwfT6JUBIBY8ZKsPPLAXw7RsVZNRd2/Ri8x
	SQzsTeBcbX3gWdvI1tRsQ5u94NvOn4Eog7lzjdyiEy3DpxtR2vWh+zBj6SvOnceuJ6S5AvDJm3PD
	ZouAAQyApf2ir0niVyDh0ryotmJ1uLUBnR41+TYI4gvUp5IA/p2R4HBsd7xGv0mZpXTCrzwcG2A0
	jLUkKhyhu/C4QQ+Vuge7GKaqETwLcqMnVBFP9pAGP57NJaDo9mZFBbcH5GBRhVsh+6wdS4R5/B1R
	dAWyh2tM6+p3PT4Ow9/VCHAYk+m+uiaP3kSqup2gQ4I29rsatayi+58ZIkcyffcuV0RgVZu1ACTR
	Q=

Extend nft_fib.sh using its existing namespaces and counter helper to
check that suppress_prefixlength 0 suppresses a default route while
retaining a more-specific route. Check that blackhole, unreachable and
prohibit routes remain terminal despite a usable route in a later table.
Include a blackhole nexthop object to distinguish result reject flags
from flags on the FIB entry.

Require a positive counter for the expected nftables FIB result. Compare
it with the output device or rejection error from an ordinary lookup.

Label ruleset-load failures and skip the affected checks when IPv6 prefix
suppression or nexthop objects are unavailable.

Run these checks after the existing default-table tests so that adding
policy rules does not remove coverage of the path without custom IPv6
rules. The router's logging RPF rules have already been removed by then,
allowing neighbour discovery during intentionally different reverse-route
states.

Signed-off-by: Leonard Lausen <leonard@lausen.nl>
---
v4:
- Drop the cached-default PMTU case and its fixture setup.
- Retain the six prefix-suppression and terminal-reject checks from v3.

Verified on the rebuilt v4 laptop kernel (7.4.0-rc2+ #6): all six added
checks pass in full normal and eight-second-delayed nft_fib.sh runs.
Both runs exit 0; twelve separate reject-route controls also pass.

V3 review:
https://lore.kernel.org/netdev/20261117091340.GA581197@shredder/T/#t

 .../selftests/net/netfilter/nft_fib.sh        | 90 +++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index 04544905c216..25e13197f057 100755
--- a/tools/testing/selftests/net/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
@@ -202,6 +202,50 @@ check_fib_counter() {
 	return 0
 }
 
+# Count probes matching the expected FIB result, then drop them.
+test_fib_suppress() {
+	local label="$1" expected="$2"
+	local result="${3:-oifname}" error err=0
+
+	if ! ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush table ip6 filter
+table ip6 filter {
+	chain prerouting {
+		type filter hook prerouting priority -1;
+		ip6 saddr dead:1::99 icmpv6 type echo-request \
+			fib saddr . mark $result "$expected" counter drop
+	}
+}
+EOF
+	then
+		echo "FAIL: $label (could not load ruleset)"
+		return 1
+	fi
+	ip netns exec "$ns1" ping -6 -c 1 -W 0.1 -q dead:1::1 > /dev/null 2>&1
+	if [ "$result" = type ]; then
+		case "$expected" in
+		blackhole) error="Invalid argument" ;;
+		unreachable) error="No route to host" ;;
+		prohibit) error="Permission denied" ;;
+		esac
+		LC_ALL=C ip -net "$nsrouter" -6 route get dead:1::99 \
+			from dead:1::1 2>&1 |
+			grep -Fxq "RTNETLINK answers: $error" || err=1
+	else
+		ip -net "$nsrouter" -6 route get dead:1::99 from dead:1::1 |
+			grep -q "dev $expected " || err=1
+	fi
+	if check_fib_type_counter_family ip6 1 "$nsrouter" prerouting \
+		"$result" "$label" &&
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
@@ -845,6 +889,52 @@ test_fib_type "default table"
 ip netns exec "$nsrouter" nft delete table ip filter
 ip netns exec "$nsrouter" nft delete table ip6 filter
 
+# Keep the earlier IPv6 checks on the path without custom rules.
+# The router's logging RPF rules have already been removed here.
+if ip -net "$nsrouter" -6 rule add pref 100 to dead:1::99 table 128 \
+	suppress_prefixlength 0; then
+	ip -net "$nsrouter" -6 route add table 128 default dev veth1 || exit 1
+	ip -net "$nsrouter" -6 route add table 129 dead:1::/64 \
+		dev veth0 || exit 1
+	ip -net "$nsrouter" -6 rule add pref 101 to dead:1::99 \
+		table 129 || exit 1
+	ip netns exec "$nsrouter" nft add table ip6 filter || exit 1
+
+	test_fib_suppress "suppress default route" veth0 || ret=1
+	ip -net "$nsrouter" -6 route add table 128 dead:1::/64 \
+		dev veth1 || exit 1
+	test_fib_suppress "retain non-default route" veth1 || ret=1
+	ip -net "$nsrouter" -6 route del table 128 dead:1::/64 \
+		dev veth1 || exit 1
+
+	for type in blackhole unreachable prohibit; do
+		ip -net "$nsrouter" -6 route replace "$type" default \
+			table 128 || exit 1
+		test_fib_suppress "retain $type" "$type" type || ret=1
+	done
+
+	if ip -net "$nsrouter" -6 nexthop add id 1 blackhole; then
+		ip -net "$nsrouter" -6 route replace default nhid 1 \
+			table 128 || exit 1
+		test_fib_suppress "retain blackhole nexthop" \
+			blackhole type || ret=1
+		ip -net "$nsrouter" -6 route del table 128 default
+		ip -net "$nsrouter" -6 nexthop del id 1
+	else
+		echo "SKIP: blackhole nexthop objects unavailable"
+		[ "$ret" -eq 0 ] && ret=$ksft_skip
+		ip -net "$nsrouter" -6 route del table 128 default
+	fi
+
+	ip -net "$nsrouter" -6 rule del pref 100
+	ip -net "$nsrouter" -6 rule del pref 101
+	ip -net "$nsrouter" -6 route flush table 129
+	ip netns exec "$nsrouter" nft delete table ip6 filter
+else
+	echo "SKIP: IPv6 prefix suppression unavailable"
+	[ "$ret" -eq 0 ] && ret=$ksft_skip
+fi
+
 test_fib_vrf
 
 exit $ret
-- 
2.55.0

