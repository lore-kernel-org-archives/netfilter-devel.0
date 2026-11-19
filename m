Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795068217;
	b=RdXas+9vrixyKf5llP+jzPwIDQSZUsw0QVF/Dz3CXRIZh6DeN7R68dnDmaC0EhdLJVcC
	 g65fgvBvH7/gNAVf1a0V1uRAhy/Hay1Q1VpflCwordkjxJgkuRZx1cEMba0wR+L75V3vs
	 G4Oq7DzRYMODUXASN/jDNlGqzHkKUhDoHqfJ9KnctQNcmvM4q/3DX46KSU4qCW15Qzrqg
	 gzqxRicF72RFS5v7LpCsnIIkGWhUL6y7tlVo97JVagwsY8qz4sDzbkKHmJZl2ofMkViFC
	 cB+TtOSVWs84cpxoMiS+L4DOYCNBEDcZDWbeVUrFSBhFr1Vayr9kKGWPZqRPw4ZldMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795068217;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=CFm8JwJY+oJknTSUuXklFqNIqha5SX3xPeg7yKd/o7M=;
	b=UDKExLzDW90wOycytyfhVQ62+VJranhy5uz8zWf7k7G0LpNMl0OZjgMr6pKpO9LFT6rE
	 vbe3Kl2YAUCLLmDWOrBVxDChfr1CUVOTZlL6wo+yMbjqFjZF6S4mMYZnP5FrU6MsIsGEL
	 5kn6WUW5QMYH8vELzi0qW857cgdGfLWGdFlXQXq8yO4eGQkKi9RLQxN8LjOAVAUkxu3qF
	 HHaWxIGnGWJ6LemMPlPI4imMy/Wid/FH6S9k1kQJRyQwJk5xMGm7xu2f9NQsQ7Aq6RMVB
	 gz/pE0djNeTDy6u4/vF/cN5ZwZMHn6UwX5tFs0cLTQ9jr9DTKYjQTlMmIzXJQ0s31kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fp86Fv5L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC359606A32F;
	Thu, 19 Nov 2026 06:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fp86Fv5L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447411F000C6;
	Thu, 19 Nov 2026 06:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795068217;
	bh=CFm8JwJY+oJknTSUuXklFqNIqha5SX3xPeg7yKd/o7M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Fp86Fv5LuUJXc6lXLpLI79eT8vKmUKxtuLZUlYOWQjjFw/Uu0ArrvwFqb2kRb/u8T
	 iJeXHC+sGTuEptprxo2jnfG/FIN9vP0507XbqFTzivATdeBibs9NBCq9eyByGLiWZT
	 jVpxT+T9Ue5MHYExP3z+1P6aXenku1NhaDfPM3uXTlbbSpPfCJrQKWbNjQaIZyPrUB
	 BK3Lv7caQGaRRWdr2zJKDkXRuPexdTGZhlrGWN2pUKD9tL5HosoHeqL1583VLf18Lj
	 YxyJhs5OyNovxRWxW5zdkWwKuKBwhxdtgLaeBxykLrvxjLuNGc1okfFNjckkUyGKcP
	 uVlwxwGxgGdOg==
Subject: Re: [PATCH net v3 3/3] selftests: netfilter: cover IPv6 FIB prefix
 suppression
From: netdev-bot+sashiko@kernel.org
To: leonard@lausen.nl
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 shuah@kernel.org, daniel@iogearbox.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Thu, 19 Nov 2026 06:03:35 +0000
Message-ID: <179506821586.3136.4378259243876110125@kernel.org>
In-Reply-To: <20261116150132.9594-4-leonard@lausen.nl>
References: <20261116150132.9594-4-leonard@lausen.nl>
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

- [Low] In the "suppress cached default route" case, the nftables check
  cannot see the PMTU exception, so it adds no coverage beyond "suppress…
- [Low] If the PMTU exception is not created, the new block runs `exit 1`
  (nft_fib.sh lines 920-924).
- [Low] The new comment "The router's logging RPF rules have already been
  removed here." (nft_fib.sh line 894) is incomplete, and so is the…

--

selftests: netfilter: cover IPv6 FIB prefix suppression

This extends nft_fib.sh to check that IPv6 policy rules with
suppress_prefixlength 0 suppress a default route but keep a more-specific
route. It also checks that blackhole, unreachable and prohibit routes,
including a blackhole nexthop object, stay terminal. Each check needs a
positive nftables fib counter that agrees with an ordinary route lookup,
and one case seeds a PMTU exception to check that its parent default route
is still suppressed.

> diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
> index 04544905c2164..175bdfa825c9e 100755
> --- a/tools/testing/selftests/net/netfilter/nft_fib.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_fib.sh

[ ... ]

> @@ -845,6 +889,71 @@ test_fib_type "default table"
>  ip netns exec "$nsrouter" nft delete table ip filter
>  ip netns exec "$nsrouter" nft delete table ip6 filter
>  
> +# Keep the earlier IPv6 checks on the path without custom rules.
> +# The router's logging RPF rules have already been removed here.

[Severity: Low]
Is this comment accurate? The commit message makes the same claim:

  "The router's logging RPF rules have already been removed by then,
  allowing neighbour discovery during intentionally different
  reverse-route states."

The prerouting RPF rule from load_ruleset() is gone by this point. But
after the earlier nft flush ruleset, the script calls
load_pbr_ruleset "$nsrouter", which installs:

table inet filter {
	chain forward {
		type filter hook forward priority raw;
		fib saddr . iif oif gt 0 accept
		log drop
	}
}

After that, only the ip filter and ip6 filter tables are deleted. Nothing
removes inet filter until test_fib_vrf()->load_ruleset_vrf() runs flush
ruleset. So this logging RPF check on the forward hook is still loaded for
all of the new suppression checks.

None of the new probes are forwarded by nsrouter, so nothing breaks today.

Should the comment and the commit message say that the forward-hook RPF
rule is still in place? A later change that adds forwarded probes here
would have them logged and dropped.

> +if ip -net "$nsrouter" -6 rule add pref 100 to dead:1::99 table 128 \
> +	suppress_prefixlength 0; then

[ ... ]

> +	# Seed a PMTU exception while bypassing suppression of its parent route.
> +	ip -net "$ns2" -6 route add dead:1::99/128 via dead:2::1 \
> +		dev eth0 mtu 1280 || exit 1
> +	ip netns exec "$ns2" sysctl -qw net.ipv6.conf.all.forwarding=1
> +	ip -net "$nsrouter" -6 rule add pref 99 to dead:1::99 \
> +		table 128 || exit 1
> +	ip netns exec "$nsrouter" ping -6 -I dead:2::1 -M do -s 1400 -c 1 -W 1 \
> +		dead:1::99 > /dev/null 2>&1
> +	if ! ip -net "$nsrouter" -6 route get dead:1::99 from dead:1::1 |
> +		grep -q 'mtu 1280'; then
> +		echo "FAIL: could not create PMTU exception"
> +		exit 1

[Severity: Low]
Does a failure here need to abort the whole selftest?

Creating the exception depends on more than a plain route add. The ping
binary must support -6 -I <addr> -M do -s, which busybox ping may not.
ns2 must forward the packet and send an ICMPv6 Packet Too Big. nsrouter
must then handle it via icmpv6_err()->ip6_update_pmtu() into the table 128
default route.

If any of those steps fails, the exit 1 skips the later blackhole,
unreachable, prohibit and nexthop checks. It also skips test_fib_vrf, which
is unrelated. The /128 mtu 1280 route and forwarding=1 in ns2 also stay set
until namespace cleanup.

The rest of this block records failures with || ret=1 and keeps going, and
the later checks don't depend on the exception. Could this path set ret=1
and skip only the "suppress cached default route" check?

> +	fi
> +	ip -net "$nsrouter" -6 rule del pref 99
> +	test_fib_suppress "suppress cached default route" veth0 || ret=1

[Severity: Low]
Can the nftables part of this check see the PMTU exception at all?

The fib expression goes through nft_fib6_lookup():

net/ipv6/netfilter/nft_fib_ipv6.c:nft_fib6_lookup() {
	return fib6_lookup(net, fl6->flowi6_oif, fl6, res, flags);
}

With custom rules, this resolves through
fib6_rule_action_alt()->fib6_table_lookup(). That function only uses
fib6_node_lookup() and rt6_select() to fill res->f6i, and never looks up
cached exceptions.

The fib6_table_lookup branch of fib6_rule_suppress() reads
res->f6i->fib6_dst.plen. That is the parent /0 entry whether or not an
exception exists.

So the nft counter here behaves the same as in "suppress default route",
with or without the fix from "ipv6: Use the FIB prefix length when
suppressing cached routes".

Only the ordinary lookup in test_fib_suppress() tests that fix:

	ip -net "$nsrouter" -6 route get dead:1::99 from dead:1::1 |
		grep -q "dev $expected " || err=1

That lookup goes through
ip6_route_output()->ip6_pol_route()->rt6_find_cached_rt().

This makes it a core IPv6 routing regression test inside nft_fib.sh.
nft_fib.sh is skipped entirely when nft is missing
(checktool "nft --version"). fib_tests.sh already has fib_suppress_test,
but that test doesn't cover cached exceptions.

Would fib_tests.sh be a better home for the cached-route case? If it stays
here, could the label say that only the ordinary lookup covers the cached
route?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116150132.9594-1-leonard%40lausen.nl
