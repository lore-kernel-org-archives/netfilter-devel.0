Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2AF3C1419;
	Mon, 24 Aug 2026 12:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787573878; cv=none; b=J97fAXMnONrqeVfE1pYbjJOGxARLzwFtXS1Zhg2gtlkgKIomypmHaugDJc+bs4xllC+11LG4Kp6W6JoPYZgLnHlQVHqnlQA7lchtgJNnNuh2k4UO1Zspt7vhitSr2236hZcS2tdhoXdB1l7f3zgtNMgU/RWEX4HMK/taKi2+u2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787573878; c=relaxed/simple;
	bh=8iZRLdTY2uWNB/WjreXNvSnWAVlhsoht3UX/weBZ/7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DECeENSrH2msfJLjZkxLzJEX4YlKJWxrr9i8Ik+w/qumirEePoTtFs6T1WbIO6wucdZOfCrb618UlZpt7HycD2sVd8hZlscAZrfhEUYhCWGF4td6Humez0dJdW+kfSdDfILIjhppu8ShlaW3nV8dc8AkBqP5zqU8USGQk7WlDkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mdIEqwwZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mdIEqwwZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787573866;
	bh=AIR0A/Uj2z5p/14yHn1wPSrrDdFx2br5I5dXc+RKdvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mdIEqwwZbqn+b5exsnJqD1UxFAgMylDsR9r4P8nYLX9UJD4XVXaUqOiE32GjpPaUA
	 xEsqGO0UMTf7cUhcpDlfDpG8pCrKEBU4jLBHoY3yruEFwXjvbSHRfy0NIhIbwacHdE
	 3fc7uK1oboVbGSh55o3T4603SkuPPDAl5QaGuXSGRb4dOHTqrqYoYvW7XM5wLWxtdZ
	 It4+edIEjl4u5mhDXE442mSod7NQ8mjLE0iUlguf9YSFZizUr7tLL1/m4YfG7r0iL+
	 FdGEhxe5mWwl2tQi5VOOTq8gxHL9IS2eLQf4hTOwf4bTTolgVRzMHfLR+JZcsoTSCN
	 5JQ+Uf0b4MMRA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 47E3F60194;
	Mon, 24 Aug 2026 14:17:46 +0200 (CEST)
Date: Mon, 24 Aug 2026 14:17:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 05/10] netfilter: x_tables: remove pr_debug
Message-ID: <aow2ZwVZI-vdQ5tz@chamomile>
References: <20260821153833.245589-6-pablo@netfilter.org>
 <20260822195227.2202694-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260822195227.2202694-1-kuba@kernel.org>

On Sat, Aug 22, 2026 at 12:52:27PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: x_tables: remove pr_debug
> 
> This drops the pr_debug() calls from a set of xtables matches and
> targets, and converts the ones in the .check paths into
> pr_info_ratelimited() so that legacy iptables users get a hint in dmesg
> when a rule is rejected.
> 
> A few observations below.
> 
> > diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
> > index 6d1a5d2026a67..37c207d3152a4 100644
> > --- a/net/ipv6/netfilter/ip6t_hbh.c
> > +++ b/net/ipv6/netfilter/ip6t_hbh.c
> 
> [ ... ]
> 
> > @@ -166,16 +144,16 @@ static int hbh_mt6_check(const struct xt_mtchk_param *par)
> >  	const struct ip6t_opts *optsinfo = par->matchinfo;
> >  
> >  	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
> > -		pr_debug("unknown flags %X\n", optsinfo->invflags);
> > +		pr_info_ratelimited("unknown flags %X\n", optsinfo->invflags);
> >  		return -EINVAL;
> >  	}
> >  	if (optsinfo->optsnr > IP6T_OPTS_OPTSNR) {
> > -		pr_debug("too many supported opts specified\n");
> > +		pr_info_ratelimited("too many supported opts specified\n");
> >  		return -EINVAL;
> >  	}
> >  
> >  	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
> > -		pr_debug("Not strict - not implemented");
> > +		pr_info_ratelimited("Not strict - not implemented");
> >  		return -EINVAL;
> >  	}
> 
> [Severity: Low]
> Should this string get a trailing newline like its two siblings in
> hbh_mt6_check()?

Yes, this needs \n in all these pr_debug() to pr_info_ratelimited().
