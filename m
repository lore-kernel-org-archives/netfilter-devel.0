Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795068216;
	b=jeQzURXx4K5pJ6y3LD7PMmflBqR4PlYO5pWiEK7hLqkxntliCveq5M9u/Oc6AWTAfxry
	 JPyN+VpVF6xFQliFgkxXrtAchL4cjE45MEuU08ZlIQvAZ3DkpxSwo0fVFp7+razQgdmM5
	 w4pAiZ/O6Xw2Ao2llZaNKbatbDEkAbAQj7Ssx+qbQIRKVFep+5tqhjfWDDQJNdU/0fh3g
	 VkG5yoAvGrTjoxiZa+odQDEfzluFVpVaneR2Bqdz8jToQRahJAoyOnA96U+zo7cGDX259
	 /KSOS14QV5Bpp8FS4hbbSiTHZxKsz6xgguLTcOgKPNXZ3t/tTlzf/foFcZVNQIAd4Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795068216;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=U/cThibxsyF+VwaxQAJCQn1jL0f0MWqy045GOQuzyuM=;
	b=myUSTxLW/5DrGakvzl7dN8iUER/9Dj0gjbwgFbDYwbYZ3OTGt1Mjncqa/nGe62NCvYu1
	 ZEmWAW5L9tbs2wkO6IooErDL5Ghueb2lP8j8dyNK1PE+3+43HFmFIwQwr8QLKCTs+gCzr
	 lG1VZk+iAI+r2hEDWSAbWdBuQgMvvCSeSiKxVqUHnxu224ujXx0eyv+sb5UQRedWHYonV
	 RBn8BctMn4jOyyco8JNdb88M6sdniwMTqeZnf0xhnp9sNFM+3HC7c3zINgR5X5HmcvXn2
	 Pkw0L2LrHxAvrWukRrLstxvu2w1DjIxafc3wuuOxm0w6MGz+kuUPlBe3bhx2Rsqqwxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ye9MJSlg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36BC606A320;
	Thu, 19 Nov 2026 06:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ye9MJSlg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3DF1F000C5;
	Thu, 19 Nov 2026 06:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795068215;
	bh=U/cThibxsyF+VwaxQAJCQn1jL0f0MWqy045GOQuzyuM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ye9MJSlgABhJiEBmlJP2nru0HDo196Dz68evEGBwiow5hO5P5+VznnJHisOB/hLW/
	 elH83ggvtFSuDrOSvTFLCkkSlAB2uHjAcYzLrIGCn5plW4tVe9vv8ZFCo2vHPRgYTV
	 RWarEgV/ZCUWvy1t5agEnW+vlVFIJQpGei7OYd8jIooJPDyRkS6/T+9Bd1oCJ629zb
	 Rtd/vLlW0GKf2MqL9fAyejdG+MZYX5vKTwFA1PTncjov2HxbA3cN6sxdZi3oE7HWiw
	 XF4RZfa1g4vYwAiEYxQBolfA5128vgRpe3YkdDu/LLaY9iA7oQqI+Wi5GOf11fJxGL
	 TxZMi5kPKT41g==
Subject:
 Re: [PATCH net v3 2/3] ipv6: Honor suppress_prefixlength in fib6_lookup()
From: netdev-bot+sashiko@kernel.org
To: leonard@lausen.nl
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 shuah@kernel.org, daniel@iogearbox.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Thu, 19 Nov 2026 06:03:34 +0000
Message-ID: <179506821413.3136.16876288075711504414@kernel.org>
In-Reply-To: <20261116150132.9594-3-leonard@lausen.nl>
References: <20261116150132.9594-3-leonard@lausen.nl>
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

- [Medium] The new RTF_REJECT exemption in fib6_rule_suppress() and the
  commit message's reason for it ("Do not suppress such routes so that…
- [Low] The commit message and Fixes: tag present this as a fix for the
  nftables regression from commit 1c32b24c234b, but the code change has…

--

ipv6: Honor suppress_prefixlength in fib6_lookup()

This patch makes fib6_rule_suppress() honour suppress_prefixlength when
the lookup goes through fib6_lookup(). That path uses
fib6_rule_action_alt(), which never populates res->rt6. The new code
compares the FIB entry prefix length against suppress_prefixlen, and it
does not suppress results that carry RTF_REJECT.

Link: https://github.com/firewalld/firewalld/issues/1600

> Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")

[Severity: Low]

This isn't a code bug, but should the changelog and Fixes: tag cover the
other fib6_lookup() callers too?

The new branch in fib6_rule_suppress() runs for every fib6_lookup() call
while custom IPv6 rules exist, not only for nft_fib6_lookup(). At least
two other callers change behaviour.

The first is bpf_ipv6_fib_lookup() in net/core/filter.c. This is the
bpf_fib_lookup() helper without BPF_FIB_LOOKUP_DIRECT:

    err = fib6_lookup(net, oif, &fl6, &res, strict);

The second is ip6_route_check_nh() in net/ipv6/route.c, which validates
the gateway when a route is added:

    err = fib6_lookup(net, cfg->fc_ifindex, &fl6, &res, flags);

With a WireGuard-style "ip -6 rule add table main suppress_prefixlength 0",
bpf_fib_lookup() now returns the VPN table route. Before this patch it
returned the main table default route.

For the BPF helper, the missing suppression is older than 1c32b24c234b.
The custom rules path of fib6_lookup() came from 138118ec96cb (2018). It
was converted to fib6_result in effda4dd97e878 (2019).
fib6_rule_action_alt() has never set res->rt6, so the old suppress code
always returned false on this path.

The v3 notes say this message and Fixes tag were suggested in review.
Even so, stable backports that follow the 1c32b24c234b tag won't reach
older kernels where BPF users are affected.

Would it make sense to mention the BPF and route-add callers in the
changelog? Should there also be a Fixes: tag for the older commit?

> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index 5e2a79a81bf35..2f43e4e48e0d0 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -288,6 +288,12 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
>  	struct fib6_info *from;
>  	int plen;
>  
> +	if (arg->lookup_ptr == fib6_table_lookup) {
> +		/* fib6_table_lookup() returns 0 for reject routes. */
> +		return !(res->fib6_flags & RTF_REJECT) &&
> +		       res->f6i->fib6_dst.plen <= rule->suppress_prefixlen;
> +	}

[Severity: Medium]

Is the RTF_REJECT exemption correct for RTN_THROW routes? The commit
message says:

  Do not suppress such routes so that they continue to terminate the
  lookup, as with ip6_route_output() and IPv4.

rtm_to_fib6_config() also sets RTF_REJECT on throw routes:

	if (rtm->rtm_type == RTN_UNREACHABLE ||
	    rtm->rtm_type == RTN_BLACKHOLE ||
	    rtm->rtm_type == RTN_PROHIBIT ||
	    rtm->rtm_type == RTN_THROW)
		cfg->fc_flags |= RTF_REJECT;

A throw route doesn't end the lookup in ip6_route_output(). This is what
__fib6_rule_action() does:

		err = rt->dst.error;
		if (err != -EAGAIN)
			goto out;

fib6_prop[RTN_THROW] is -EAGAIN, so fib_rules_lookup() goes on to the
next rule. IPv4 does the same through fib_props[RTN_THROW].error.

In the fib6_lookup() path, fib6_rule_action_alt() only checks for
fib6_null_entry:

	err = fib6_table_lookup(net, table, *oif, flp6, res, flags);
	if (!err && res->f6i != net->ipv6.fib6_null_entry)
		err = fib6_rule_saddr(net, rule, flags, flp6,
				      res->nh->fib_nh_dev);
	else
		err = -EAGAIN;

So a throw route gives err == 0. fib6_rule_suppress() then returns false
because of RTF_REJECT, and the rule walk stops with the throw route as
the result.

The callers then see:

  __nft_fib6_eval_type() returns RTN_THROW
  nft_fib6_eval() returns without setting an oif
  bpf_ipv6_fib_lookup() returns BPF_FIB_LKUP_RET_NOT_FWDED
  ip6_route_check_nh() returns -EHOSTUNREACH

In the same case, ip6_route_output() would use a later rule. An nft fib
rpfilter rule such as firewalld's "fib saddr . mark . iif oif missing
drop" can then drop legitimate packets.

The lookup already stopped at throw routes before this patch, because the
old suppress code always returned false here. For a throw route with
plen <= suppress_prefixlen, though, ip6_route_output() moves on to the
next rule. The new branch makes fib6_lookup() stop instead.

Would it be better for fib6_rule_action_alt() to return -EAGAIN when
res->fib6_type == RTN_THROW, as __fib6_rule_action() does?

Also, the selftest in "selftests: netfilter: cover IPv6 FIB prefix
suppression" covers blackhole, unreachable and prohibit, but not throw.

> +
>  	if (!rt)
>  		return false;
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116150132.9594-1-leonard%40lausen.nl
