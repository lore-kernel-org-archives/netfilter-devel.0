Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45054383991
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787608214; cv=none; b=QuIX2s3umui+yC+1SfEBfUgFZivuKd303DN0aA+F1roW5s/d0pqG1mLOwgkeiEVKHyhJOf+0DEbOhupPFntLM1fmvNwfHCBKm5ObOD+81z9kkl8Wr/NAwd7DfAsMwmCgvRW8chnPH8hpsmP4rlY+lUukK4aCBYilOSV7MIKLpnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787608214; c=relaxed/simple;
	bh=maUEaZe2/S38+OjX64X357za8LCvoWZMIwnYI0tMEeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y3lwYAakSu9iIE5LTcCfW7wpApkxcd5gqHxEmkX3qjm0wi7feGkRy3RVejVq8VQbEmsTzh5oOm6bSXl79s3ixmH+rTMXaEs9HiEIVWYI5WUYymN950kH0xrYMg1njL8xcm1h2HVesmjxNO8XLnrVWzI6CF0FLhBIEH0c1oG+sWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IzwVneSf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IzwVneSf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787608211;
	bh=8oGXOipPBqZMyx04i690581N7h38Zdrh1t69a6NIFT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IzwVneSfJCItOn25MPIb53iE27j/Xdc+ibtHLEBx/jIUuffKmCClTVStqAlHjBZ2t
	 yrwiKe7CvN88uxPba+ALrwc3mPN8r4TWohyZZppgyg4G1maOhAY0GS0DvBnOoAatZy
	 LjLghaHzK+7xJyVlzinC+iOa/5YxBrl94Q2XHUE9ffaktbGNAe+MZE5RInOFjh+IdO
	 fqhnHQMfVGXuJOkT9i1D9kjI9ZWP6I38UuYHQASNRCiOy3Cj6+UueIw4XDhP2tT7Wb
	 D8/9mb6GRHf+O8A6D7Cb3N2jWy1O911dKtyfOLROi1l0rH+uXuWK2LIgnuCHfXA7jy
	 54Jl48q++d8sg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 132066007D;
	Mon, 24 Aug 2026 23:50:11 +0200 (CEST)
Date: Mon, 24 Aug 2026 23:50:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Zhiling Zou <zhilinz@nebusec.ai>
Subject: Re: [PATCH nf-next] netfilter: x_tables: reject missing '-p' flag
 and check for INV flag
Message-ID: <aoy8kFZkXMNOHUcR@chamomile>
References: <20260821134136.18191-1-fw@strlen.de>
 <aohabszy_Ac23p7x@chamomile>
 <aolaWzC1PI7zeYRN@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aolaWzC1PI7zeYRN@strlen.de>

On Sat, Aug 22, 2026 at 10:14:19AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Aug 21, 2026 at 03:41:36PM +0200, Florian Westphal wrote:
> > > ip6tables traverser doesn't walk ipv6 extension headers unless the PROTO
> > > flag is set, so direct sockopt-users can bypass the check (ip6tables
> > > always sets it if '-p' flag is given.  This is a cleanup patch, it
> > > doesn't fix any real bug.
> > 
> > I really think it is better to squash the TPROXY fix into this one
> > too, it is the same logical fix.
> 
> I don't mind either way.  I did not do it because unlike TPROXY these
> are benign.
>
> > Sashiko also hinting to fix ip6_tables core check for this protocol
> > flag:
> > 
> > https://sashiko.dev/#/patchset/20260821134136.18191-1-fw%40strlen.de
> 
> Not so sure.  Maybe just do this?  I don't think proto > 0 and flag
> unset makes any sense.
> 
> diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> --- a/net/ipv6/netfilter/ip6_tables.c
> +++ b/net/ipv6/netfilter/ip6_tables.c
> @@ -647,6 +647,13 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
>  	/* Clear counters and comefrom */
>  	e->counters = ((struct xt_counters) { 0, 0 });
>  	e->comefrom = 0;
> +
> +	/* Make sure F_PROTO is set, else ip6_packet_match
> +	 * won't do the right thing.
> +	 */
> +	if (e->ipv6.proto)
> +		e->ipv6.flags |= IP6T_F_PROTO;

Userspace always provides a zeroed e->ipv6.proto when unused, correct?

If so, LGTM.

> +
>  	return 0;
>  }
>  
