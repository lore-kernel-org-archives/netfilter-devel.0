Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794829784;
	b=fjuasmjNNr60zigtll5AOE2Vt5LE2DziiBMUw7lgs/bZxcnD6Mjym34No6FtKwfh1MHs
	 8tYOdT7WEAgWx8z9YM4Xt4R3omlQKv7nymVpuThgkeAl7wIlbzlztkTxYLEPsRgy8tVWp
	 Rb+IqDDOwyPbzoYqfx/xRdHH+J5LoqbtIG33zMlvdZXO/m8flMWmNNkUMrULeLYMLOHFP
	 /xG8QkRpDjR+zirkWi4Iik1AVRSVJJ8k5EdEq4Ke3Y73cMyyJRZqwaZFiZWvtFbVBWsU9
	 SJqg667fNxxFYUD+IWoq3qDc7PocAx1hmwMUJltZEBQw2d7FA7o8OGvXk4JINN9MdKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794829784;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=YF9uPbRNMFJDe58jYR2SHD4cB2dtFZ0yoAnGUomr6pU=;
	b=F1c26F/Wzq8uhh+m5nsaKCM5VP35zIuu+UwauZjQFM22G8SoJZotOIgAXS+FQtWAItfr
	 ZH7lDu6Sb0k8qtf9kK4L3WZfCG9A5m+5N4HVVlOrTPFL2iA1VtcbaPzUIBe1+YwrpSQjA
	 dShxZmt9G89ySm0gVChst9qTZUmZdWWjmRGxZRr+v/+RIUzPaxNQWs6zychcTlvBomsRw
	 RRPG9zwSEJDHdFZ4My4jICNSvb2Ye5885cTzEWRGMPl0Ti8CfTGvChtCYxDyevZYJY1NW
	 EkNPTpSXogcvmbCMyVVUiccrrUTczL9zHqY+srek4zGmyjKEu078/5qWXyJUQOkD9og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HEJPA1ce;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89550606A88E;
	Mon, 16 Nov 2026 11:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HEJPA1ce
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398271F000C6;
	Mon, 16 Nov 2026 11:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794829784;
	bh=YF9uPbRNMFJDe58jYR2SHD4cB2dtFZ0yoAnGUomr6pU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HEJPA1ceqr2psUJ8fdQ8CCHLPdb+IpZhzdHtScMXHknNqxlLgsQ9aMskTepGY7IgG
	 7FJXlbNEVxc8ibStAtjrUghOvUoIukPt677vQJ0IkW6xtlcT48kwb0aPz7ye5Cmkj+
	 7MDURK9sSlEh+ucWrS7i8TtYrdkgIVHCBepA7mK11tp00NaTZtyjeIqQdZ1IcFSb85
	 PEm8TVvPekcwfvifcFOHr9DAC0nPqlh7xEEzvZFG+cmQ1DIC7Nkb1MjuTRjle6NuYl
	 pqqkGk8zxNrEjkKFZkSZacoJRGxKtGCzjZX5BdYpk5lRQnTR3q7t2EPdHq5digT4aW
	 ZR5BjNfEPEbXg==
Subject: Re: [PATCH net v2 2/2] selftests: netfilter: cover IPv6 FIB prefix
 suppression
From: netdev-bot+sashiko@kernel.org
To: leonard@lausen.nl
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 shuah@kernel.org, daniel@iogearbox.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Mon, 16 Nov 2026 11:49:42 +0000
Message-ID: <179482978277.3136.16783433298012482293@kernel.org>
In-Reply-To: <20261115114434.10343-6-leonard@lausen.nl>
References: <20261115114434.10343-6-leonard@lausen.nl>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The new prefix-suppression block in
  tools/testing/selftests/net/netfilter/nft_fib.sh runs at top level…
- [Low] In test_fib_suppress()
  (tools/testing/selftests/net/netfilter/nft_fib.sh, line 210), the per-…
- [Low] The new block adds IPv6 policy rules in nsrouter (`ip -6 rule add
  pref 100 ...` and `pref 101 ...`, lines 762-763) and deletes them at…
- [Low] For the blackhole, unreachable, prohibit and blackhole-nexthop
  cases, test_fib_suppress() (nft_fib.sh line 222) checks the nft side…

--

selftests: netfilter: cover IPv6 FIB prefix suppression

This patch extends nft_fib.sh with IPv6 policy routing checks. They
verify that suppress_prefixlength 0 suppresses a default route but keeps
a more-specific route. They also verify that blackhole, unreachable,
prohibit and blackhole-nexthop routes stay terminal. Each check counts
matching nft fib results, compares them with ip -6 route get, and the
router's ruleset is now loaded after these checks.

> diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
> index 04544905c2164..65d4687622e20 100755
> --- a/tools/testing/selftests/net/netfilter/nft_fib.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
> @@ -202,7 +202,38 @@ check_fib_counter() {
>  	return 0
>  }
>  
> -load_ruleset "$nsrouter"
> +# Count probes matching the expected FIB result, then drop them.
> +test_fib_suppress() {
> +	local label="$1" expected="$2"
> +	local result="${3:-oifname}" err=0
> +
> +	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF || return 1

[Severity: Low]
If nft rejects this ruleset, test_fib_suppress() returns before it
reaches the PASS/FAIL echo at the end. That can happen when
nft_fib_ipv6 is unavailable or the "fib saddr . mark type" syntax is not
supported.

The callers' "|| ret=1" still makes the overall result FAIL. However,
the log never prints "FAIL: <label>", so it doesn't show which of the
six cases failed. It also doesn't show that the cause was a ruleset
load error and not a FIB mismatch.

Could this path print a labelled FAIL or SKIP? Other helpers in this
file do that when a ruleset fails to load, for example test_fib_type().

> +flush table ip6 filter
> +table ip6 filter {
> +	chain prerouting {
> +		type filter hook prerouting priority -1;
> +		ip6 saddr dead:1::99 icmpv6 type echo-request \
> +			fib saddr . mark $result "$expected" counter drop
> +	}
> +}
> +EOF
> +	ip netns exec "$ns1" ping -6 -c 1 -W 0.1 -q dead:1::1 > /dev/null 2>&1
> +	if [ "$result" = type ]; then
> +		ip -net "$nsrouter" -6 route get dead:1::99 from dead:1::1 > /dev/null 2>&1 && err=1

[Severity: Low]
In the type branch, the nft side has to match one exact result
(fib saddr . mark type "$expected"). The route get side only checks that
the lookup fails. Any non-zero exit counts as agreement, whether it is
-EINVAL for blackhole, -EHOSTUNREACH for unreachable, -EACCES for
prohibit, or an unrelated error.

The commit message says:

    Require a positive packet counter for the expected nftables FIB result
    and compare it with an ordinary route lookup.

Does that comparison hold for the blackhole, unreachable, prohibit and
blackhole nexthop cases? Only the oifname branch checks the actual
result ("dev $expected ").

Could the type branch check the error text instead (Invalid argument,
No route to host, Permission denied)? Using ip -6 route get ... fibmatch
would also work. Either way, the ordinary lookup would have to end on
the same reject type.

Table 129 gives a usable route for dead:1::99. If the dst path wrongly
suppressed the reject route, route get would still succeed and the test
would catch it. So the gap only covers a mismatched reject type.

> +	else
> +		ip -net "$nsrouter" -6 route get dead:1::99 from dead:1::1 |
> +			grep -q "dev $expected " || err=1
> +	fi

[ ... ]

> @@ -724,6 +755,36 @@ test_fib_vrf()
>  	check_fib_veth_vrf_type "fib expression address types match (iif in vrf)"
>  }
>  
> +# Test prefix suppression before installing the router's logging RPF rules.
> +# Neighbour discovery must remain usable even when reverse routes differ.
> +ip -net "$nsrouter" -6 route add table 128 default dev veth1 || exit 1
> +ip -net "$nsrouter" -6 route add table 129 dead:1::/64 dev veth0 || exit 1
> +ip -net "$nsrouter" -6 rule add pref 100 to dead:1::99 table 128 suppress_prefixlength 0 || exit 1
> +ip -net "$nsrouter" -6 rule add pref 101 to dead:1::99 table 129 || exit 1

[Severity: Low]
Adding these IPv6 rules in nsrouter latches fib6_has_custom_rules:

net/ipv6/fib6_rules.c:fib6_rule_configure() {
    ...
	net->ipv6.fib6_has_custom_rules = true;
    ...
}

Deleting the rules later in this block does not clear the flag. Only
netns init resets it. fib6_lookup(), which nft_fib6_lookup() calls,
branches on the flag:

net/ipv6/fib6_rules.c:fib6_lookup() {
    ...
	if (net->ipv6.fib6_has_custom_rules) {
    ...

Before this patch, nsrouter had no IPv6 rules until test_fib_vrf(), and
the PBR section only adds IPv4 rules. That means the IPv6 halves of
several checks used to take the direct local/main table lookup in
fib6_lookup():

  - the unwanted-drop checks
  - the loopback checks
  - the fib counter check
  - test_fib_type "policy routing" and "default table"

Now that this block runs first, does nft_fib.sh still cover the IPv6
lookup path without custom rules?

Would that coverage survive if the suppression checks ran in a separate
namespace, or after the tests that rely on having no custom IPv6 rules?

> +ip netns exec "$nsrouter" nft add table ip6 filter || exit 1
> +
> +test_fib_suppress "suppress default route" veth0 || ret=1
> +ip -net "$nsrouter" -6 route add table 128 dead:1::/64 dev veth1 || exit 1
> +test_fib_suppress "retain non-default route" veth1 || ret=1
> +ip -net "$nsrouter" -6 route del table 128 dead:1::/64 dev veth1 || exit 1
> +
> +for type in blackhole unreachable prohibit; do
> +	ip -net "$nsrouter" -6 route replace "$type" default table 128 || exit 1
> +	test_fib_suppress "retain $type" "$type" type || ret=1
> +done
> +
> +ip -net "$nsrouter" -6 nexthop add id 1 blackhole || exit 1
> +ip -net "$nsrouter" -6 route replace default nhid 1 table 128 || exit 1

[Severity: Low]
This block now runs at top level before load_ruleset "$nsrouter", the
forwarding sysctls and the first test_ping. Every setup command here
ends in "|| exit 1".

If ip -6 rule add fails (a kernel without CONFIG_IPV6_MULTIPLE_TABLES),
does the whole script exit with FAIL? The same question applies when
ip -6 nexthop add fails (an iproute2 without nexthop object support).
None of the existing checks would run then: unwanted-drop, loopback,
fib counter, PBR, fib type and VRF.

In other places, this script reports a missing feature as SKIP and keeps
going, for example the veth check, test_fib_type() and
load_pbr_ruleset(). Could these setup failures skip only the new
suppression checks instead of exiting?

The netfilter selftest config already sets
CONFIG_IPV6_MULTIPLE_TABLES=y, so this mostly affects nonstandard
environments.

> +test_fib_suppress "retain blackhole nexthop" blackhole type || ret=1
> +
> +ip -net "$nsrouter" -6 rule del pref 100
> +ip -net "$nsrouter" -6 rule del pref 101
> +ip -net "$nsrouter" -6 route del table 128 default
> +ip -net "$nsrouter" -6 route flush table 129
> +ip -net "$nsrouter" -6 nexthop del id 1
> +ip netns exec "$nsrouter" nft delete table ip6 filter
> +load_ruleset "$nsrouter"
> +

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261115114434.10343-2-leonard%40lausen.nl
