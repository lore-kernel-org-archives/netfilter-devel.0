Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB0736215E;
	Sat, 19 Sep 2026 15:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789830171; cv=none; b=pqRB6xkDfQVtNs/JRAgN4bHldAQlYxLLSSNBNnXHcKc4DSg3ITEvOqjbd6H9LdAmLLSj8I8QSeUYzc2P6hh7zum/K2TBRYImjg//kofijtDY3XxHUFcbh3PGfQ/L/A37zCgjjOqQxGwXYRpYJDCmcLqzbi3sGdTokLL50omNRDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789830171; c=relaxed/simple;
	bh=nR3YZ04akHUoyNVdoBerCNgz8XUSb8qUTbtC19klQKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NoCnXYvk8NDDlgLgY0hI4iVIOoiVwO2pWsIOeXLqeKTgjbz+9qeBbIr5h8Epw7SsRnC6aA/VPaHnJIQAEv7vN+pI2LTU43yxOFPxm6H9MtARNHOTvjbvYyQrTVVt7nZ+Xh50KGm44WimlMWoi+F/4FgkuDcbnSD+fetKp2/lVu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=knLx2nb6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="knLx2nb6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789830166;
	bh=li+de4tFpfLExK0quVJsnK/mWXwkab4AONrGvjgUlHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=knLx2nb60zD+WeoKMhgi474tVhIWykjPBK+jHhwojswlgN1b/aONDXPExzGJys0lS
	 wT8tRpC/1Iu3/R59eEpMvDsNytwWg7HwtwJh3rPiL50Y0uKxtVdvs/S51SD8nWiiJT
	 WCRzn1vXbh+iAnwRyiKqOe8Mo2ZkbljMD4JjODPjrKnmdXv7jFn78CbtJDmwRjO2RI
	 MlOnvHR77t7HyWPXxAK/RTY5+zU7TOYO6We8chYugQxMMaGKmA7jEK/W0Nbo/MvR/q
	 nKhAkdKlF2iMBEPDEv5DDR6Su6f+P+3mTb0BGZnCq6TFeBZZkLICimYhRZQtFUYKe5
	 cnoYfiiVO3wfA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 88C8B60079;
	Sat, 19 Sep 2026 17:02:46 +0200 (CEST)
Date: Sat, 19 Sep 2026 17:02:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: kuba@kernel.org
Cc: netdev-bot+sashiko@kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, horms@kernel.org,
	fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 4/8] netfilter: ip6t_rt: fix zero-address non-strict
 match out-of-bounds read
Message-ID: <aq6kFM8gT_DRunm8@chamomile>
References: <20260918112844.194503-5-pablo@netfilter.org>
 <178982488999.22033.1436563513682437520@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178982488999.22033.1436563513682437520@kernel.org>

Hi Jakub,

IP6T_RT_FST_MASK is just fine.

On Sat, Sep 19, 2026 at 01:34:49PM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 0 · Medium: 0 · Low: 1
> 
> - [Low] Validator/matcher flag-semantics disagreement in
>   net/ipv6/netfilter/ip6t_rt.c.
> 
> --
> 
> netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read
> 
> This adds a loop-header bound (i < rtinfo->addrnr) to the non-strict
> address matching loop in rt_mt6(), removing the backwards break at the
> bottom of the loop.  It also adds a rt_mt6_check() rejection for rules
> that set IP6T_RT_FST_MASK with rtinfo->addrnr == 0.
> 
> > diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
> > index 8051425213dd..9880faf3cc7d 100644
> > --- a/net/ipv6/netfilter/ip6t_rt.c
> > +++ b/net/ipv6/netfilter/ip6t_rt.c
> > @@ -96,7 +96,8 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
> >  			unsigned int i = 0;
> >  
> >  			for (temp = 0;
> > -			     temp < (unsigned int)((hdrlen - 8) / 16);
> > +			     temp < (unsigned int)((hdrlen - 8) / 16) &&
> > +			     i < rtinfo->addrnr;
> >  			     temp++) {
> >  				ap = skb_header_pointer(skb,
> >  							ptr
> > @@ -112,8 +113,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
> >  
> >  				if (ipv6_addr_equal(ap, &rtinfo->addrs[i]))
> >  					i++;
> > -				if (i == rtinfo->addrnr)
> > -					break;
> >  			}
> >  			if (i == rtinfo->addrnr)
> >  				return ret;
> 
> [ ... ]
> 
> > @@ -162,6 +161,12 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
> >  		pr_info_ratelimited("too many addresses specified\n");
> >  		return -EINVAL;
> >  	}
> > +
> > +	if ((rtinfo->flags & IP6T_RT_FST_MASK) && !rtinfo->addrnr) {
> > +		pr_info_ratelimited("address list match requested but addrnr is 0\n");
> > +		return -EINVAL;
> > +	}
> > +
> 
> [Severity: Low]
> Is the mask used here wider than the flag the matcher actually keys on?
> IP6T_RT_FST_MASK is 0x30, covering both bits:
> 
> include/uapi/linux/netfilter_ipv6/ip6t_rt.h:
>     #define IP6T_RT_FST_MASK	0x30
>     #define IP6T_RT_FST 		0x10
>     #define IP6T_RT_FST_NSTRICT	0x20

This is from iptables:

        case O_RT0NSTRICT:
                if (!(cb->xflags & F_RT0ADDRS))
                        xtables_error(PARAMETER_PROBLEM,
                                   "`--rt-0-addr ...' required before `--rt-0-not-strict'");
                rtinfo->flags |= IP6T_RT_FST_NSTRICT;

The error message says that --rt-0-not-strict needs --rt-0-addr,
which is IP6T_RT_FST.

... that is IP6T_RT_FST_MASK.

> But rt_mt6() gates every access to rtinfo->addrs[] and rtinfo->addrnr on
> IP6T_RT_FST alone:
> 
> net/ipv6/netfilter/ip6t_rt.c:rt_mt6() {
> 	if (!(rtinfo->flags & IP6T_RT_FST)) {
> 		return ret;
> 	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
> 	...
> }
> 
> So a rule with only IP6T_RT_FST_NSTRICT set and addrnr == 0 never touches
> addrs[] at match time, yet it is now rejected with -EINVAL at load time.

Yes, but IP6T_RT_FST_NSTRICT set and addrnr == 0 should not ever
happen.

This LLM is lacking userspace context.

> Would narrowing the new test to IP6T_RT_FST avoid that load-time behaviour
> change?  Such blobs can only come from direct IP6T_SO_SET_REPLACE or
> nft_compat callers, since libip6t_rt requires --rt-0-addrs before
> --rt-0-not-strict, so no ruleset produced by iptables appears to be
> affected.
> 
> Does the new check also make the strict branch's addrnr == 0 case
> unreachable?  That branch has a meaningful zero-address semantic, matching
> a routing header that carries no addresses at all (hdrlen == 8):
> 
> net/ipv6/netfilter/ip6t_rt.c:rt_mt6() {
> 	...
> 			if (temp == rtinfo->addrnr &&
> 			    temp == (unsigned int)((hdrlen - 8) / 16))
> 				return ret;
> 	...
> }
> 
> With addrnr == 0 now refused at load time, that comparison can no longer be
> satisfied with addrnr == 0.
> 
> One more thing worth noting: is the new checkentry test needed for memory
> safety at all?  The loop-header change bounds i to addrnr, and addrnr is
> already capped at IP6T_RT_HOPS by the preceding test, so &rtinfo->addrs[i]
> stays inside the 16-entry array on its own.
> 
> Separately, and not something this patch introduces: a rule with
> IP6T_RT_TYP | IP6T_RT_FST_NSTRICT, rt_type 0 and addrnr > 0 still passes
> rt_mt6_check() as an address list match, but rt_mt6() returns at the
> !(rtinfo->flags & IP6T_RT_FST) test and silently ignores every configured
> address.  Should the validator and the matcher agree on which flag means
> "match the address list"?
> 
> -- 
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260918112844.194503-2-pablo%40netfilter.org
