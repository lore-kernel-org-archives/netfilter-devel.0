Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF052DCF74;
	Sat, 19 Sep 2026 13:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789824892; cv=none; b=mSPvCIkj31fP6dInq/uxi+Kol0XnuQ1087Ema4Astm+zKZNVEcRIo9xRlGsNznUqURFawjS0wrCa4mX82kMzb/wLMsSJMH2xn/3DL59ZNGnIBDuRZqxWq6hrqurCyVeK6c/C7Z3Q6ACfaTAvf3XrNVrRik0HldjWk+Ue0J6ppXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789824892; c=relaxed/simple;
	bh=FeTBOISQHPCR1ov1W23RZhpn8rju4ps2k3Er+/m3DeM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PqfW+C7RB/PTBfFBWHpmquAfX+U5lWkCCWTt5rmbEPYnpGp362TE9Ilpsrk01TunGdzZ9QN73qG4jv+sIWO3V6R1q6NO8uYsyFpfvfRDY6zj/mSIZNsP3eTiHON9luZWy2FUnhQAKv622nAE9mdVUltKcS+b6GLa9jygs2a9vPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lhWJjJVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhWJjJVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F29A1F00893;
	Sat, 19 Sep 2026 13:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789824891;
	bh=vYMt+HEO26iSBpI3MGjr4rysqT8GpmI/Kr4HilhR7YE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lhWJjJVlzCI7/hUI7TMj4Y5I99WJl5GQOIHjV5/99hVPApBMabL/r4pY8TcnX/hMk
	 bJYP7seiMvEEGBdT78J1QoLd1Z5O+f7qNjCxiPX+1oKj8QVfQZXXCB/NZV5dTGsMA+
	 HdR9xcLmgpo2p98ED8dkTLhaIDr/DGZ3un1BqoEtDK4YjK2DYtqepXD9U6SCS2U0Jj
	 c/yopiZTyZgN3nOEQ6t5FHgRzE1DNQiTVbqS0aklp4diSEjYur8N/ic/VFjdqO1I4n
	 6z9zOCB4/6KIIHgFkbyphRYNW3IXoLNdsw7lAbVmoIbTjGo4JIRhgSlkJUaIW+zcA0
	 xzeZn2Y+cKZEg==
Subject: Re: [PATCH net 4/8] netfilter: ip6t_rt: fix zero-address non-strict
 match out-of-bounds read
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 19 Sep 2026 13:34:49 +0000
Message-ID: <178982488999.22033.1436563513682437520@kernel.org>
In-Reply-To: <20260918112844.194503-5-pablo@netfilter.org>
References: <20260918112844.194503-5-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] Validator/matcher flag-semantics disagreement in
  net/ipv6/netfilter/ip6t_rt.c.

--

netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read

This adds a loop-header bound (i < rtinfo->addrnr) to the non-strict
address matching loop in rt_mt6(), removing the backwards break at the
bottom of the loop.  It also adds a rt_mt6_check() rejection for rules
that set IP6T_RT_FST_MASK with rtinfo->addrnr == 0.

> diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
> index 8051425213dd..9880faf3cc7d 100644
> --- a/net/ipv6/netfilter/ip6t_rt.c
> +++ b/net/ipv6/netfilter/ip6t_rt.c
> @@ -96,7 +96,8 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
>  			unsigned int i = 0;
>  
>  			for (temp = 0;
> -			     temp < (unsigned int)((hdrlen - 8) / 16);
> +			     temp < (unsigned int)((hdrlen - 8) / 16) &&
> +			     i < rtinfo->addrnr;
>  			     temp++) {
>  				ap = skb_header_pointer(skb,
>  							ptr
> @@ -112,8 +113,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
>  
>  				if (ipv6_addr_equal(ap, &rtinfo->addrs[i]))
>  					i++;
> -				if (i == rtinfo->addrnr)
> -					break;
>  			}
>  			if (i == rtinfo->addrnr)
>  				return ret;

[ ... ]

> @@ -162,6 +161,12 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
>  		pr_info_ratelimited("too many addresses specified\n");
>  		return -EINVAL;
>  	}
> +
> +	if ((rtinfo->flags & IP6T_RT_FST_MASK) && !rtinfo->addrnr) {
> +		pr_info_ratelimited("address list match requested but addrnr is 0\n");
> +		return -EINVAL;
> +	}
> +

[Severity: Low]
Is the mask used here wider than the flag the matcher actually keys on?
IP6T_RT_FST_MASK is 0x30, covering both bits:

include/uapi/linux/netfilter_ipv6/ip6t_rt.h:
    #define IP6T_RT_FST_MASK	0x30
    #define IP6T_RT_FST 		0x10
    #define IP6T_RT_FST_NSTRICT	0x20

But rt_mt6() gates every access to rtinfo->addrs[] and rtinfo->addrnr on
IP6T_RT_FST alone:

net/ipv6/netfilter/ip6t_rt.c:rt_mt6() {
	if (!(rtinfo->flags & IP6T_RT_FST)) {
		return ret;
	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
	...
}

So a rule with only IP6T_RT_FST_NSTRICT set and addrnr == 0 never touches
addrs[] at match time, yet it is now rejected with -EINVAL at load time.

Would narrowing the new test to IP6T_RT_FST avoid that load-time behaviour
change?  Such blobs can only come from direct IP6T_SO_SET_REPLACE or
nft_compat callers, since libip6t_rt requires --rt-0-addrs before
--rt-0-not-strict, so no ruleset produced by iptables appears to be
affected.

Does the new check also make the strict branch's addrnr == 0 case
unreachable?  That branch has a meaningful zero-address semantic, matching
a routing header that carries no addresses at all (hdrlen == 8):

net/ipv6/netfilter/ip6t_rt.c:rt_mt6() {
	...
			if (temp == rtinfo->addrnr &&
			    temp == (unsigned int)((hdrlen - 8) / 16))
				return ret;
	...
}

With addrnr == 0 now refused at load time, that comparison can no longer be
satisfied with addrnr == 0.

One more thing worth noting: is the new checkentry test needed for memory
safety at all?  The loop-header change bounds i to addrnr, and addrnr is
already capped at IP6T_RT_HOPS by the preceding test, so &rtinfo->addrs[i]
stays inside the 16-entry array on its own.

Separately, and not something this patch introduces: a rule with
IP6T_RT_TYP | IP6T_RT_FST_NSTRICT, rt_type 0 and addrnr > 0 still passes
rt_mt6_check() as an address list match, but rt_mt6() returns at the
!(rtinfo->flags & IP6T_RT_FST) test and silently ignores every configured
address.  Should the validator and the matcher agree on which flag means
"match the address list"?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260918112844.194503-2-pablo%40netfilter.org
