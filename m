Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173054;
	b=gpC5YpdlU3oERjGMlE/rtnl4dqo7iEStwGRGJs0RrfZssSRP+ErCzhAXpH4LfMieaUlR
	 DP5puifLHY3CddpHgmuAFLSljfTRkS1bCgBmrZOzHuBrWlh/r0KnRSYoNK4iEiLeq/T4L
	 puiTn8wfMA1IwyRPcC9yGd6USt1bXFud/i4Sq3cUHuOUbmFosZYUx/6l4/O10Q9lU2xay
	 glYoYfxHHT1Q5xyQNZ1mkAgerCBQKAxYd4Wg+o61Um0a+X6LpN533i4mfyVCQ63/OjLw3
	 bg4m2Ec2UkwFzNOtS4fmgqriHj4JUxhvpb8CRG4/DTiwIsMuq4x8I8WDW9a2lolBocw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173054;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=2bj2WTnjPiLjsE3k43qjyadZlVuZzndDK7/3eTPwHqQ=;
	b=aAihYe/vJ4lApYROn/f9u0naFnDAakSz7fNtkmpOHXI3xBvJiVGO1y41baKZFcZTGP78
	 QU5hwUukIPzxorOpVtCP/9FN+4OsK3oB2Fvtvt6g32kXO1FzhW5XHzXoqLEjlT3zc6C1T
	 042NPqKpR5dCCbrCK8rryJlyQmFNJ/nn8+CGXEW+bdChDcqzzV4rtGFF0vzNoiiOuf4kS
	 KFt8iQgal0WYdEfJmfN3ppU1USnVCSPCr9Duv4HCBrJt1gwPrnXaqeClNiDHpysZHoJSD
	 MSGeeTUVJltbGweHr/nnagsy89D57ctZ5vGlImXsOdazqfHbTQXYuO3jm/tlqAKAbvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4gIouMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A9E606A336;
	Fri, 20 Nov 2026 11:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4gIouMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434E11F000D8;
	Fri, 20 Nov 2026 11:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173054;
	bh=2bj2WTnjPiLjsE3k43qjyadZlVuZzndDK7/3eTPwHqQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Z4gIouMy2gpXBaY3WJ92xqOrONrBgfanHc39m1N5Hu9RlQQcAyvzr41n0hCNe+1z7
	 m9cpuNaO0X4sTrpy1GWC+mYR05yX3WG8ac//p95Bz1Kz7glAHpg3rJ5k+nJgy5N/4l
	 C5FDahJrW/v4Z4zKunw95Z9W3W73+9m7YxBITsLCmWJ8tz92cu2Ti0keTDiuF4n4bL
	 brIgEo77x3MD++ZDTy5bWXBAb6JOuCY4JObzTt5Z5HZloAi/fDjQU37f3GOjGpUskZ
	 iwWqPQoyMMDRPvzjXzSpzirRx/CjpQUV6HZGzHBT38rZNa7YHWjXC93Bu9T9zNkvdc
	 PXWpWEXjV2SQg==
Subject: Re: [PATCH net v4 2/2] selftests: netfilter: cover IPv6 FIB prefix
 suppression
From: netdev-bot+sashiko@kernel.org
To: leonard@lausen.nl
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 shuah@kernel.org, daniel@iogearbox.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 20 Nov 2026 11:10:52 +0000
Message-ID: <179517305282.3136.16580929973360319234@kernel.org>
In-Reply-To: <20261117110813.9894-4-leonard@lausen.nl>
References: <20261117110813.9894-4-leonard@lausen.nl>
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

- [Low] The new in-tree comment before the IPv6 prefix-suppression block
  in tools/testing/selftests/net/netfilter/nft_fib.sh says "The router's…

--

selftests: netfilter: cover IPv6 FIB prefix suppression

This adds IPv6 checks to nft_fib.sh for suppress_prefixlength 0. They
verify that a default route is suppressed while a more-specific route is
retained, and that blackhole, unreachable and prohibit routes (including
a blackhole nexthop object) stay terminal. The checks run after the
existing default-table tests.

The commit message says:

> The router's logging RPF rules have already been removed by then,
> allowing neighbour discovery during intentionally different reverse-route
> states.

The same statement appears as a comment in the patch, covered inline
below.

> diff --git a/tools/testing/selftests/net/netfilter/nft_fib.sh b/tools/testing/selftests/net/netfilter/nft_fib.sh
> index 04544905c2164..25e13197f0578 100755
> --- a/tools/testing/selftests/net/netfilter/nft_fib.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_fib.sh

[ ... ]

> @@ -845,6 +889,52 @@ test_fib_type "default table"
>  ip netns exec "$nsrouter" nft delete table ip filter
>  ip netns exec "$nsrouter" nft delete table ip6 filter
>  
> +# Keep the earlier IPv6 checks on the path without custom rules.
> +# The router's logging RPF rules have already been removed here.

[Severity: Low]
Is this comment accurate? Earlier, the script calls
load_pbr_ruleset "$nsrouter", and that installs a logging RPF check in
table inet filter:

load_pbr_ruleset() {
    ...
table inet filter {
	chain forward {
		type filter hook forward priority raw;
		fib saddr . iif oif gt 0 accept
		log drop
	}
}
    ...
}

Between that load and this block, the only deletions are
"nft delete table ip filter" and "nft delete table ip6 filter", after
each test_fib_type call. Table inet filter is not flushed until the
"flush ruleset" in load_ruleset_vrf().

The prerouting nft_rpfilter logging rules from load_ruleset() are gone
at this point, since the earlier "nft flush ruleset" removed them. The
forward-hook "log drop" chain is still loaded, though.

The new probes (ping to dead:1::1) and neighbour discovery are delivered
locally and never reach the forward hook, so the checks still pass.
Could the comment, and the matching sentence in the commit message, say
that it is the prerouting nft_rpfilter rules that have been removed,
rather than all of the router's logging RPF rules?

> +if ip -net "$nsrouter" -6 rule add pref 100 to dead:1::99 table 128 \
> +	suppress_prefixlength 0; then

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261117110813.9894-2-leonard%40lausen.nl
