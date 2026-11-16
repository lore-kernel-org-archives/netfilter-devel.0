Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794841315;
	b=MtlKwP5LzImgxZf2X4oEoLSesZv2X1AlT6xkAepVuEci49OmioE/0UjLB3fBkoIRWf/h
	 whjNCuD4hBH6hW2kfuis4ucnhcIa1c2WUagYU9ZuEN/xN/MpqXkkY249xRL/N4r31z8il
	 T26qE61W6yJrQ/KiWO6wG+Ufd9Z0QGVVT12LNXG1L0P2q3OAEZmZ6/8tP1QlXg07mEwS+
	 yy82sXOQEd2bvRBBbTXNAfjvg4Eqh2bRDTiZEOqByoz1/lQSSMU7CWo9hkiSZ/QXzSj37
	 Ak9LOPawttjp2EImVJnw8GErfvO/uwVLXN673aZNBvcNcj67Otx+UYBlqEVVRMLQyQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794841315;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:
	 DKIM-Signature;
	bh=wU42Xv+oriwKZx/rxk+EnNc9SsYqK4jjpZoanBLi7Wo=;
	b=ftYlbZWLJKwxzAiJ3rn+a6gT9Dt+NDe2ljEhclvtZP3z6cNNRlXNsFPf9cq2O1vR0oMv
	 0IZ8L2kWNRs9tlAneHUp2/+BTd/N5/agiE3iSj4hEqQ3z/6PYtaS4wniDX/LEQesPcqoG
	 Clamw2YxtyJt9ojGrcjeDmCBbHPPeAMOKx5AFqxI7wMenDlOeBfkvVF6BF5OoLcdqars4
	 Ey6L+NBWio7assMylE3pfNl0Dl+M4k/tl+GrBpPcdXoqrRCn3rEpQs3VL6aWJrFhVMwAe
	 v8cs1ZRnEfCvvWMkM9O8sPIYzmXuKXcB3575nhXk1SD1A23euYRGlSdRDgjPhMf0wvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=DyAulS2B;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE691606A332
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 15:01:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE691606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=DyAulS2B
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 15E2D6116C
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 16:01:48 +0100 (CET)
Received: (qmail 22990 invoked by uid 990); 16 Nov 2026 15:01:47 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Mon, 16 Nov 2026 16:01:47 +0100
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
Subject: [PATCH net v3 3/3] selftests: netfilter: cover IPv6 FIB prefix suppression
Date: Mon, 16 Nov 2026 15:01:30 +0000
Message-ID: <20261116150132.9594-4-leonard@lausen.nl>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116150132.9594-1-leonard@lausen.nl>
References: <20261116150132.9594-1-leonard@lausen.nl>
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
X-Rspamd-Report: REPLY(-4) BAYES_HAM(-2.999838) MID_CONTAINS_FROM(1) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -5.599838
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=lOr4fHWDJmDbv/ZQHO6T7OQiyEAQ/Lb9RxYZKQiNakc=;
	b=DyAulS2BaAkK3Ym+Nm2xUoNNuscFK5rsovTLXwQ2ExAb66CbC7I0BuE66Mi8M4TwY8Ojs+FHdm
	Xd2Pxd5/nn9YH+iFL4sCyqD0ur1Cuqv3aGqA90Fn1QnRISDaS/zSLtm51+PPeZlbdDio8a+KiUdP
	e8+hrHpqQTArW16OSmVS9iYiKJg7e1/jN+L0uAdzdpxYH6lyOIZrZ3A7GaOe/StpQnhP0+tclf0j
	2nQb/Xz8ZVfuOeB914vyjLMZjK9Vr++vCoqlOLQghsdX37wez8BSkzQPSlkjWRyxztuEXurkVVhp
	GikWSPnmvxyfBSw9amrF8Cv2SdIzukLTQdaC7mcShbKu7KrzA5Dk2cnAw5NWwSrj6eXVqzk4N8Fx
	+siB3Xk0duRoL8SeDQ3/BPKfYem5q+783QyjOia2RFHzqcLfJi+hfiNXpxaZBNV5KdGsyEOt8OMV
	2vVid9W1zfVK49yMJrS84IvFH/lkODK5R6/y1mtaN83/FPIK6qoPk11PdAvsHipSy4aaramV4CUS
	Oy7YCJDD0MY6FukYocUjj8sifA47xO+2Iqpg6NfY4uaYmJiv2f8CLKoWZyMLiaX7pJT1yfpIrK5c
	9dwYGzTOVDWjUsWFeadrV/y4tQPXL4GmQcaKXfDd6S+QLveZxA86artBs1aK94DbrchaIXNvKYeA
	c=

Extend nft_fib.sh using its existing namespaces and counter helper to
check that suppress_prefixlength 0 suppresses a default route while
retaining a more-specific route. Check that blackhole, unreachable and
prohibit routes remain terminal despite a usable route in a later table.
Include a blackhole nexthop object to distinguish result reject flags
from flags on the FIB entry.

Require a positive counter for the expected nftables FIB result. Compare
it with the output device or rejection error from an ordinary lookup.
Create a PMTU exception through the existing peer namespace and check
that its parent default route is still suppressed.

Label ruleset-load failures and skip the affected checks when IPv6 prefix
suppression or nexthop objects are unavailable.

Run these checks after the existing default-table tests so that adding
policy rules does not remove coverage of the path without custom IPv6
rules. The router's logging RPF rules have already been removed by then,
allowing neighbour discovery during intentionally different reverse-route
states.

Signed-off-by: Leonard Lausen <leonard@lausen.nl>
---
v3:
- Add a cached-default PMTU case using the existing peer namespace.
- Run after default-table tests; label load failures, skip unavailable
  optional features and match ordinary rejection errors exactly.
- Remove Assisted-by.

v2: https://lore.kernel.org/netdev/20261115114434.10343-2-leonard@lausen.nl/

 .../selftests/net/netfilter/nft_fib.sh        | 109 ++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
index 04544905c216..175bdfa825c9 100755
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
@@ -845,6 +889,71 @@ test_fib_type "default table"
 ip netns exec "$nsrouter" nft delete table ip filter
 ip netns exec "$nsrouter" nft delete table ip6 filter
 
+# Keep the earlier IPv6 checks on the path without custom rules.
+# The router's logging RPF rules have already been removed here.
+if ip -net "$nsrouter" -6 rule add pref 100 to dead:1::99 table 128 \
+	suppress_prefixlength 0; then
+	ip -net "$nsrouter" -6 route add table 128 default \
+		via dead:2::99 dev veth1 || exit 1
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
+	# Seed a PMTU exception while bypassing suppression of its parent route.
+	ip -net "$ns2" -6 route add dead:1::99/128 via dead:2::1 \
+		dev eth0 mtu 1280 || exit 1
+	ip netns exec "$ns2" sysctl -qw net.ipv6.conf.all.forwarding=1
+	ip -net "$nsrouter" -6 rule add pref 99 to dead:1::99 \
+		table 128 || exit 1
+	ip netns exec "$nsrouter" ping -6 -I dead:2::1 -M do -s 1400 -c 1 -W 1 \
+		dead:1::99 > /dev/null 2>&1
+	if ! ip -net "$nsrouter" -6 route get dead:1::99 from dead:1::1 |
+		grep -q 'mtu 1280'; then
+		echo "FAIL: could not create PMTU exception"
+		exit 1
+	fi
+	ip -net "$nsrouter" -6 rule del pref 99
+	test_fib_suppress "suppress cached default route" veth0 || ret=1
+	ip -net "$ns2" -6 route del dead:1::99/128
+	ip netns exec "$ns2" sysctl -qw net.ipv6.conf.all.forwarding=0
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
