Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794829783;
	b=sbrYquCVFdK5aVvg61HL445xYeoYG9zaZOLKsqhFPxqKlmRylaHAfzu31qz8cMbHc7L0
	 WAi+2CRBhLSzVkSxuxBKQyFlZ6+d7o1i1tQC1PZU9fsh+dDJcwUKENBw2s0Sztv4CRxg7
	 2tvs7GVxvudN/RNSUpVMH5ORfQz2uMV9+S7i5Y+Nm+daJUPTsDoshRqv6t0+0G3KLTlw6
	 Ut6R6s93U1G04vucj9EJz4SKKGnhU+fOqHPxLWLCRk9yQRgijqPwUCwRfelkYLxzR01lZ
	 PM7DhnbS6YawJXQmGYXhoHw/8nINsLnXghsCFmItzSUSr3LuYbL3pmebkfFtCL6Jf8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794829783;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=c8Uk0HRRR9fJ1b23voau7UQA2yTmva6WPz14a7yZLkc=;
	b=JFYqnNr/xzGblacDqoMs2N+Szxw6AVO8+chgNO2JsPznlDRiYEWu9m3FlNHBDGRqIRt4
	 DXSuJj/fIlWWhienSKj3uWJJqrdyiuqUHEkEodCk2GabJYNZonah1KRZCvegTZYdvAfd+
	 qB9amE/d0igha7QzY2fAYmILEuAZU71SgA7A401oNvUDJEQMTTbcHCVmH2C95ilvlG2t4
	 wunwpDSYblL3jth7Lobe24u7jzdkj7/SvuGh+WA6ZZpHZe7ZupnvrTx1Qw8lXykmzeC7U
	 +YzJWqvF1djFm86paKoXbuhnKQn1pKN9n1bD5HGKcaL4lAxDEoOtS+y+myPtG0yS5Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJSAN9SE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23FE606A336;
	Mon, 16 Nov 2026 11:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJSAN9SE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8453A1F000C8;
	Mon, 16 Nov 2026 11:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794829782;
	bh=c8Uk0HRRR9fJ1b23voau7UQA2yTmva6WPz14a7yZLkc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=TJSAN9SEe14Nf2L6/4KBP/SuzCHh/m5w1tShzL8caS2Kdq/xB7U+6Jda1fcaKZ1Xf
	 8Y1q76EOF9bBhVbsDDIG8v9B7bJSxH7go3wB4vX6e7laPjY95HSdRGP0IKYNekPP3P
	 zJVRs3leHHRSq1fmt8/7Lh21D8rjDDvPD4w7gbseo7Om6kl0xFmcdyuEpD/nvFo7qV
	 H1Wv3d9Ia+Z6Mca5dX0u5jo/rAhQXhDuI3Z13v4evdIJmTvt+adkNqmKuhiE4LCEV3
	 mD+d4pE4loAWDzJYcKB7BX5HAz+khWqVnA+WHyOpzhCer3HIIYpAcWdNSG4fUlqJK6
	 eJ5erjiX5HWrA==
Subject: Re: [PATCH net v2 1/2] ipv6: honor prefix-length suppression in raw
 FIB lookups
From: netdev-bot+sashiko@kernel.org
To: leonard@lausen.nl
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 shuah@kernel.org, daniel@iogearbox.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Mon, 16 Nov 2026 11:49:41 +0000
Message-ID: <179482978100.3136.17418106822071501090@kernel.org>
In-Reply-To: <20261115114434.10343-4-leonard@lausen.nl>
References: <20261115114434.10343-4-leonard@lausen.nl>
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

- [Medium] After this patch, the two halves of fib6_rule_suppress()
  (net/ipv6/fib6_rules.c) take the prefix length from different places,…

--

ipv6: honor prefix-length suppression in raw FIB lookups

Raw IPv6 FIB lookups through fib6_lookup() fill in f6i and nh in
fib6_result but not rt6. Because of that, fib6_rule_suppress() never
applied suppress_prefixlength to them. This patch adds a raw-lookup branch
that compares the FIB entry's destination prefix length against the rule
and skips RTF_REJECT results. The dst-based path is left as it was.

Link: https://github.com/firewalld/firewalld/issues/1600

> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index 0ffd7b47a0460..ceb4180bcf2f8 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -283,9 +283,16 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
>  						struct fib_lookup_arg *arg)
>  {
>  	struct fib6_result *res = arg->result;
> -	struct rt6_info *rt = res->rt6;
> +	struct rt6_info *rt;
>  	struct net_device *dev = NULL;
>
> +	if (arg->lookup_ptr == fib6_table_lookup) {
> +		/* Raw lookups report reject routes without an error. */
> +		return !(res->fib6_flags & RTF_REJECT) &&
> +		       res->f6i->fib6_dst.plen <= rule->suppress_prefixlen;
> +	}

[Severity: Medium]

Can the raw and dst paths now disagree for a destination that has a
cached exception route?

The new raw branch checks res->f6i->fib6_dst.plen, which is the FIB
entry's prefix length. The unchanged dst branch further down in
fib6_rule_suppress() checks the clone's prefix length instead:

    if (rt->rt6i_dst.plen <= rule->suppress_prefixlen)
        goto suppress_route;

For RTF_CACHE exception clones, ip6_rt_cache_alloc() always sets a /128
prefix:

net/ipv6/route.c:ip6_rt_cache_alloc() {
    ...
	rt->rt6i_flags |= RTF_CACHE;
	rt->rt6i_dst.addr = *daddr;
	rt->rt6i_dst.plen = 128;
    ...
}

When a clone exists, ip6_pol_route() returns it directly, and
ip6_pol_route_lookup() does the same:

net/ipv6/route.c:ip6_pol_route() {
    ...
	rt = rt6_find_cached_rt(&res, &fl6->daddr, &fl6->saddr);
	if (rt) {
		goto out;
    ...
}

Take a rule like "table main suppress_prefixlength 0", and a destination D
with a PMTU or redirect exception on the main-table default route.

An ordinary dst lookup for D does not suppress (128 > 0), so it keeps the
main default. With this patch, fib6_lookup() for D does suppress (0 <= 0)
and moves on to the next rule, for example the VPN table. Before the
patch, both paths returned the main default for D.

In a wg-quick style setup this could look like:

  1. Unmarked traffic to D is routed out eth0.
  2. Replies from D arrive on eth0.
  3. nft_fib6_eval() runs "fib saddr . iif oif". The raw lookup now
     resolves to the VPN table's wg0 route.
  4. nft_fib6_info_nh_uses_dev() fails, and strict rpfilter drops the
     replies, which passed before this patch.

bpf_fib_lookup and ip6_route_check_nh also go through fib6_lookup(), so
they could return a different egress than the stack in the same case.

A remote ICMPv6 Packet Too Big can create such an exception via
__ip6_rt_update_pmtu()->ip6_rt_cache_alloc()->rt6_insert_exception(). A
redirect can do the same. The mismatch then lasts until the exception
expires.

The commit message says "Keep the dst-based path unchanged" and treats the
ordinary lookup as the reference. However, that path already ignores
suppression for exception routes.

Should the dst branch use the parent FIB entry's prefix length for
RTF_CACHE routes (via rt->from), so that both paths agree? That would also
be closer to what fib4_rule_suppress() does for IPv4. If not, could the
commit message document this divergence?

> +
> +	rt = res->rt6;
>  	if (!rt)
>  		return false;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261115114434.10343-2-leonard%40lausen.nl
