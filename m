Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794696903;
	b=LGPs2rrE3tszJHUvXA6FeC8j2NPdgq0HQHYumx4RLVuoAwxy4QqRbSMH6aNzAodenCE9
	 57PnBVkx8dyRHdL+GG93Jfl7AhndaKVo0vf8Ul0wfsKZj414cjKNE56KcZxYY/cM0GhpJ
	 LmKPtjU3MNdAuDUP+rnpMn4Iqummk7f/W8LJa9L9nzs94OpgDtLaA3p0KrHK/Z/AGAEnu
	 yHdb9rCpooPrADjiOj6SWIFtpfTtzmn+LZX/KtiozFKyciMF1nSjnOqv83j+AQaT5yJG4
	 Qx/0+DAFt2Y0y6hQCrC6ib9fFkrs5oZ8ZO2CxG3uQ9oU47on32rfjguHRb8zJDl9XnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794696903;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=AwLtpM86VpsnnK+7uMHIt8eLqok2JSlouQ2cKrdoe24=;
	b=Ro7hmhcWYokOycUBcftfUvVmCmmXcOZpjKgYYeKYyWR1/6y2rQ+PlR1YDNS+Ox2gmcMQ
	 AxsoSh640wxrg4lojrYO7hF9DSi9lN8KcgnLf6vL/Lk/iwi/UTutJAOa1bVDfN/VVX4hg
	 4rdENisThRxShZYrwzBBXHjaXPrJOrJLQ1t3UBhPJg81Fvx5Jfh7WRC0Io5zLid/G4Tkc
	 gY1eyrq5SqGvJyjG4Yqh6IP4GQXMOXv3vZ5iIC9CvwIEUlLCWJ5wj9aeKla1emwc2iLv+
	 t7OxkhVA9toS9fPWVpXlQ5AW3wKae/OZUEI3lRcnCRT8V9BYwbJCJ9S5YZtQsEnUgtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PaRg3yZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEFA606A329;
	Sat, 14 Nov 2026 22:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PaRg3yZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CC91F000C4;
	Sat, 14 Nov 2026 22:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794696903;
	bh=AwLtpM86VpsnnK+7uMHIt8eLqok2JSlouQ2cKrdoe24=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PaRg3yZ2KodS4qjZTfLXAgWRKyc3dVn4Y7qSiVlmcl9ANTZP9U6aYG5+ClzLFbp1u
	 i95xLc6DjBLiPkK86ymbA9CDlmRnRj12xVY/Z6fRw2D7faFpsOuvLwlJZUpE0Fx0vB
	 u4F4WGrNVlEQUhDRIw9UnfR8tr89X4pBZcIOQl4Jxj5hu1Om5UjpRmkPdHQetXnFjF
	 abQlqHN6JKKDIubWIQDqUmzFkEPJieOloPi4UzYkv2z6NF/eg4I5eTIcDrwPt7ULL0
	 JRYL+rV0QhELnsd8a0if+U67SrJYCaVJxUvIMv8AKXUbULqyDWKhe3ttCOH1/Q39bU
	 MeKzQYjNy/zrg==
Subject:
 Re: [PATCH net 2/2] selftests: netfilter: cover IPv6 FIB rule suppression
From: netdev-bot+sashiko@kernel.org
To: leonard@lausen.nl
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 shuah@kernel.org, daniel@iogearbox.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sat, 14 Nov 2026 22:55:01 +0000
Message-ID: <179469690148.2199510.9157183592994872143@kernel.org>
In-Reply-To: <20261110131638.15004-7-leonard@lausen.nl>
References: <20261110131638.15004-7-leonard@lausen.nl>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The ICMPv6 neighbour discovery replies that this test itself
  triggers can make the existing logging RPF rule fire, and…
- [Low] The new reject-route checks in nft_fib.sh only create legacy
  reject route types, via `ip -6 route replace $type default table 128`…

--

selftests: netfilter: cover IPv6 FIB rule suppression

This commit extends nft_fib.sh to exercise suppress_prefixlength and
suppress_ifgroup for IPv6 FIB rules. It checks that default routes and
routes through a matching interface group are suppressed. It also checks
that non-default routes and nonmatching groups stay usable, and that
blackhole, unreachable and prohibit routes remain terminal.

> diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
> index 04544905c2164..02b6257946694 100755
> --- a/tools/testing/selftests/net/netfilter/nft_fib.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_fib.sh
> @@ -202,6 +202,38 @@ check_fib_counter() {
>  	return 0
>  }
>  
> +# Count and drop probes before the existing RPF rules can log expected failures.
> +test_fib_suppress() {
> +	local label="$1" expected="$2"
> +	local result="${3:-oifname}" err=0
> +
> +	ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF || return 1
> +flush table ip6 filter
> +table ip6 filter {
> +	chain prerouting {
> +		type filter hook prerouting priority -1;
> +		ip6 saddr dead:1::99 icmpv6 type echo-request \
> +			fib saddr . mark $result "$expected" counter drop
> +	}
> +}
> +EOF

[Severity: Medium]

The comment above test_fib_suppress() says probes are dropped before the
existing RPF rules can log expected failures. This chain only matches
echo-request, though.

Can other ICMPv6 packets from dead:1::99 still reach the logging rule that
load_ruleset() installed on nsrouter?

load_ruleset() {
    ...
	        fib saddr . iif oif missing counter log prefix "$netns nft_rpfilter: " drop
    ...
}

In most of the states this block sets up, dead:1::99 does not resolve to
veth0. In "retain non-default route" and "retain nonmatching interface
group" the lookup picks dead:1::/64 dev veth1. In the six reject loop
states, nft_fib6_eval() returns with no oif.

The block itself looks like it produces such a packet:

1. The first ping makes ns1 send an NS from dead:1::99. ndisc_recv_ns() on
   nsrouter creates a NUD_STALE neighbour entry. Sending the NA reply moves
   it to NUD_DELAY with a DELAY_PROBE_TIME (5s) timer.

2. All echo-requests are dropped, so nothing confirms the entry. About 5s
   later neigh_timer_handler() moves it to NUD_PROBE, and nsrouter sends a
   unicast NS to dead:1::99.

3. ns1 answers through ndisc_send_na(). The target is its own address, so
   the NA is sourced from dead:1::99:

   net/ipv6/ndisc.c:ndisc_send_na() {
       ...
	ifp = ipv6_get_ifaddr(dev_net(dev), solicited_addr, dev, 1);
	if (ifp) {
		src_addr = solicited_addr;
       ...
   }

4. The NA does not match the echo-request chain. The RPF rule checks it
   under the current pref 100/101 rules, then logs and drops it. With
   ucast_probes=3, nsrouter retries at about +1s and +2s.

ns1's own NUD probes do not seem to cause this. In the NUD_PROBE state,
ndisc_send_ns() uses the link-local source, and the "to dead:1::99" rules
do not match that. The trigger is nsrouter's NUD_DELAY to NUD_PROBE
transition.

Right after the block, check_drops() greps the global dmesg:

    test_ping 10.0.2.1 dead:2::1 || exit 1
    check_drops

Would this print "FAIL: rpfilter did drop packets" and set ret=1?

That would also hide the later "PASS: fib expression did not cause
unwanted packet drops" message, even when every suppression check passed.
It only happens if the block runs longer than about 5s after the first
probe. That seems plausible on slow or debug kernels such as KASAN or
lockdep builds.

Some possible ways to avoid it:

- Install permanent neighbour entries on both sides while the block runs.
- Temporarily flush or replace the logging inet prerouting rule.
- Also drop nd-neighbor-advert from dead:1::99 in the priority -1 chain.

An accept in the priority -1 chain would not help, because the priority 0
base chain still runs.

[ ... ]

> @@ -724,6 +756,42 @@ test_fib_vrf()

[ ... ]

> +# Reject routes use loopback (group 0) and must remain terminal.
> +ip -net "$nsrouter" -6 route flush table 128
> +for suppress in suppress_prefixlength suppress_ifgroup; do
> +	ip -net "$nsrouter" -6 rule del pref 100
> +	ip -net "$nsrouter" -6 rule add pref 100 to dead:1::99 table 128 "$suppress" 0 || exit 1
> +	for type in blackhole unreachable prohibit; do
> +		ip -net "$nsrouter" -6 route replace "$type" default table 128 || exit 1
> +		test_fib_suppress "retain $type ($suppress)" "$type" type || ret=1
> +	done
> +done

[Severity: Low]

This loop only creates legacy reject route types. Should it also cover a
route that uses a blackhole nexthop object?

The companion commit "ipv6: honor rule suppression in raw FIB lookups"
reads the result flags in fib6_rule_suppress(). Its commit message says
this is so blackhole nexthop objects are covered too:

net/ipv6/fib6_rules.c:fib6_rule_suppress() {
    ...
	if (arg->lookup_ptr == fib6_table_lookup) {
		/* Raw lookups report reject routes without an error. */
		if (res->fib6_flags & RTF_REJECT)
			return false;
    ...
}

Blackhole, unreachable and prohibit routes have RTF_REJECT both in
f6i->fib6_flags and in the result. A blackhole nexthop sets it only in the
result, in __find_rr_leaf():

net/ipv6/route.c:__find_rr_leaf() {
    ...
			if (nexthop_is_blackhole(f6i->nh)) {
				res->fib6_flags = RTF_REJECT;
				res->fib6_type = RTN_BLACKHOLE;
    ...
}

This means the new checks cannot tell res->fib6_flags apart from
res->f6i->fib6_flags.

Suppose the guard were changed to read the FIB entry flags. A blackhole
nexthop default route in table 128 would then be suppressed, and the lookup
would fall through to table 129 (veth0). The tests here would still pass.

Something like this inside the suppress loop might cover it:

    ip -net "$nsrouter" nexthop add id N blackhole
    ip -net "$nsrouter" -6 route replace default nhid N table 128
    test_fib_suppress "retain blackhole nexthop ($suppress)" blackhole type

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110131638.15004-3-leonard%40lausen.nl
