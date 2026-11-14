Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794696901;
	b=V1E9bSqS59YOGkh7BGKdnUnx6hVbsTkHIhvVFQCTxbd2lsS556J5Dj5AHGIMDCSm6TbK
	 AAkBbuENxu24nSN3zI8RnnqXmfSHVbAPW8Qs8iViZsAZNeSfuN3lOpYUi3kP/ZPdoffUM
	 hmu2JRf/W7bQfl52Tq6Y1KqeFpv1h2N8YBn7bhuVCB+q4wL4El5sh3bWQtW/nCte7D7AH
	 RuCUhHWGOK2xwAnFkNxcAnTxpobvG6Eok5qVWNnfFhSk/x/IrqkMP3DOEPjzPV/oW0Uqg
	 Bu1J7dLORu0Q/nGNRh+I4Hza/LyYpgqVtKt+Inzp4yxWfKmKr0rK7xPjW5Aa2bjBb1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794696901;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=vBn5GRO1f/3jEjWYYhhLct/b2kRb+lUMrgvM2hcJkSM=;
	b=iy7wUxIBiXREC5GVvh8lteNZNPUyj+HrvcoeKdeXI5+Z5YBzSsDEIb9n9v4UphFscJm1
	 JSrdS854DGnLlDC+TfsMOj9cGzoljZr2cqwZfrfxAiMBRhA8Ot2dczwbw8r/kBxC5LaJj
	 /sr9490v/G5XTEfmhbDTC1RwnISfFXo0EjhsxWbjsYGT9BIQQK/si2oKHxwCRVz4KGuQF
	 LUKGHIuknd6Ov/fX+pXk2yWLcVAOXdw/sYu7kGwsmbwMpAfp1PyEq57999YP2uRY1E9H6
	 V9QZyjF17tcuYmkByMYMCeUqTvd78xbsxh9YpHZVFElQqwjkkfwK02u6A/O7OS2N6dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=klc4f5dD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE5B606A323;
	Sat, 14 Nov 2026 22:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=klc4f5dD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5256D1F000C4;
	Sat, 14 Nov 2026 22:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794696901;
	bh=vBn5GRO1f/3jEjWYYhhLct/b2kRb+lUMrgvM2hcJkSM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=klc4f5dD6RqurZdHnFUBa4fUvfA7paDow5pDwrYFT+Sjs44/CPVPQ46o5Fs9z+KZu
	 BbnKBJgOb6KQwB+eSv3QNf/J3ZcpOfMKJ58Q8VwKFhK+tTlTvnrVL4hO0k3+9ojrm0
	 b9EhbmP4sPco1yBk3ib0EqeScT2b3miRawqPF1TtbVDFbQmJDMEqGMa58wvALTEuyy
	 lCgeQwN/57zhQn0mloAzbbRnUq0x1P4F5cil1pZ/7868nQdCl6VAAepFxgsDrQHHIK
	 gPoQ4eFlx9KDh1qg0pKRllVzkodNN+RaOojpQRVGD0Aqz4QzW2PPFsThXvf+q5ctt5
	 Bp2TV8aokEsIg==
Subject: Re: [PATCH net 1/2] ipv6: honor rule suppression in raw FIB lookups
From: netdev-bot+sashiko@kernel.org
To: leonard@lausen.nl
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 shuah@kernel.org, daniel@iogearbox.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Sat, 14 Nov 2026 22:54:59 +0000
Message-ID: <179469689962.2199510.1299009420613186748@kernel.org>
In-Reply-To: <20261110131638.15004-5-leonard@lausen.nl>
References: <20261110131638.15004-5-leonard@lausen.nl>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] For raw lookups, fib6_rule_suppress() (net/ipv6/fib6_rules.c)
  evaluates suppress_ifgroup against a different nexthop than the dst-…

--

ipv6: honor rule suppression in raw FIB lookups

This patch makes fib6_rule_suppress() apply suppress_prefixlength and
suppress_ifgroup to raw fib6_table_lookup() results. For those results it
takes the prefix length from res->f6i and the device from res->nh. Raw
results marked RTF_REJECT are never suppressed, so a later rule cannot
bypass the rejection.

Link: https://github.com/firewalld/firewalld/issues/1600

> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index 0ffd7b47a0460..e8a44b540291d 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -283,19 +283,29 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
>  						struct fib_lookup_arg *arg)
>  {
>  	struct fib6_result *res = arg->result;
> -	struct rt6_info *rt = res->rt6;
> +	struct rt6_info *rt = NULL;
>  	struct net_device *dev = NULL;
> -
> -	if (!rt)
> -		return false;
> -
> -	if (rt->rt6i_idev)
> -		dev = rt->rt6i_idev->dev;
> +	int plen;
> +
> +	if (arg->lookup_ptr == fib6_table_lookup) {
> +		/* Raw lookups report reject routes without an error. */
> +		if (res->fib6_flags & RTF_REJECT)
> +			return false;
> +		plen = res->f6i->fib6_dst.plen;
> +		dev = res->nh->fib_nh_dev;

[Severity: Medium]
For multipath routes, is this the same nexthop that the dst-based path
checks?

On the raw path, res->nh is whatever fib6_table_lookup() picked. For
multipath that is usually the first sibling or the first usable member of
the nexthop group. fib6_rule_action_alt() never calls fib6_select_path().

The dst-based path selects the path before it builds the rt6_info whose
rt6i_idev the old code looked at:

net/ipv6/route.c:ip6_pol_route() {
    ...
	fib6_select_path(net, &res, fl6, oif, have_oif_match, skb, strict);
    ...
}

fib6_select_path() then replaces res->nh (and res->f6i for siblings) with
the hash-selected path, which may be on a different device:

net/ipv6/route.c:fib6_select_path() {
    ...
	if (unlikely(match->nh)) {
		nexthop_path_fib6_result(res, fl6->mp_hash);
		return;
	}
    ...
out:
	res->f6i = match;
	res->nh = match->fib6_nh;
}

bpf_ipv6_fib_lookup() runs path selection only after fib6_lookup() has
already made the suppression decision:

net/core/filter.c:bpf_ipv6_fib_lookup() {
    ...
	err = fib6_lookup(net, oif, &fl6, &res, strict);
    ...
	fib6_select_path(net, &res, &fl6, fl6.flowi6_oif,
			 fl6.flowi6_oif != 0, NULL, strict);
    ...
	dev = res.nh->fib_nh_dev;
	params->ifindex = dev->ifindex;
    ...
}

Consider a multipath route whose nexthops are on devices in different
interface groups, plus a rule like "ip -6 rule ... lookup <tbl>
suppress_ifgroup N". Could a flow be suppressed by the ordinary route
lookup but not by the nft fib or BPF raw lookup, or the other way round?

Can bpf_fib_lookup also return a device in the suppressed group that
suppression never evaluated?

That would leave the same raw versus ordinary disagreement the commit
message says this patch removes. suppress_prefixlength does not appear to
be affected, since siblings share one prefix.

> +	} else {
> +		rt = res->rt6;
> +		if (!rt)
> +			return false;
> +		plen = rt->rt6i_dst.plen;
> +		if (rt->rt6i_idev)
> +			dev = rt->rt6i_idev->dev;
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110131638.15004-3-leonard%40lausen.nl
