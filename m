Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1764908D8
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 14:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787320950; cv=none; b=ei9euXTIwSnTw9PE662NaRo/4SHQrlNNeKK2LtNhnQi5P4a4+K/7shhpPeKOycFWkTwxHooWMm2xzdNBKf0l5h1H478gY90jmnYd1Vysz/71Z5l631LgwUB8ZpPXn3lEdhxDLU62vq1dzm7XRyf9yCFB9ZatBaY4W/R/WWuIYzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787320950; c=relaxed/simple;
	bh=MYwKCYlpxs6RYzV8/2cja2K2vORTDV48s0iVyIdz+TU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9Ibe8dd5oIZUaOuNxegK4y49d0fRaZyQWbPvTCOuZz08qs1lv+23lvzc1AiY1V7vijmwd8Dwvja0GJFyQaGY1lutAYKK2IcUo5yegii/ZyYmVuEB3f6joDaYYOKUNC1mIIjGfITKneNRITdANUwK5xm7MowM/riG3QxsQ/ZvU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Dw3681r2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Dw3681r2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787320946;
	bh=am2Bof4oaRQC7DX6OwjnwGdKcMkHD/1tjUAAvky7cz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dw3681r2ip98nxsi8AkseLqMgt8lDvigKDoqrM8+etGKaT3hUBRbAshmHtb4BJTvI
	 Ymx4bLRK1X7cS1cc76REMRiFaL917OJma1I6t2cBAgzUYGFhXk7WhQvqRUSq8eDqjP
	 V/jr50RAnn2G4/X1S60cxRzvTgavO0b4McsP04/jWnOGinNkc4o12a9Qj5cMAgLSy7
	 sck3PTMJk0OgvGuf+uLlEx6vJ5+Msa54/RD2YQIHjd0IjXQKUGMstM6pwO62C26HEG
	 feqQDaj9GY9r0KIzpozV/5YOtty5tXyE6/LFpbiSs98l7kVhuxuY71NbyFC+Pne4lh
	 qEbsRHHV6oTCw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 213D96008B;
	Fri, 21 Aug 2026 16:02:26 +0200 (CEST)
Date: Fri, 21 Aug 2026 16:02:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Zhiling Zou <zhilinz@nebusec.ai>
Subject: Re: [PATCH nf-next] netfilter: x_tables: reject missing '-p' flag
 and check for INV flag
Message-ID: <aohabszy_Ac23p7x@chamomile>
References: <20260821134136.18191-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260821134136.18191-1-fw@strlen.de>

Hi,

On Fri, Aug 21, 2026 at 03:41:36PM +0200, Florian Westphal wrote:
> ip6tables traverser doesn't walk ipv6 extension headers unless the PROTO
> flag is set, so direct sockopt-users can bypass the check (ip6tables
> always sets it if '-p' flag is given.  This is a cleanup patch, it
> doesn't fix any real bug.

I really think it is better to squash the TPROXY fix into this one
too, it is the same logical fix.

Sashiko also hinting to fix ip6_tables core check for this protocol
flag:

https://sashiko.dev/#/patchset/20260821134136.18191-1-fw%40strlen.de

Thanks!

> Reported-by: Zhiling Zou <zhilinz@nebusec.ai>
> Fixes: 74f77a6b2b1c ("netfilter: introduce l2tp match extension")
> Fixes: af0d29cd2a73 ("netfilter: xtables: add an IPv6 capable version of the ECN match")
> Fixes: a89ecb6a2ef7 ("[NETFILTER]: x_tables: unify IPv4/IPv6 multiport match")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Can also be applied to nf, but I don't think this one is urgent.
> 
>  net/netfilter/xt_ecn.c       |  3 ++-
>  net/netfilter/xt_l2tp.c      | 11 +++++++----
>  net/netfilter/xt_multiport.c |  3 +++
>  3 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
> index a8503f5d26bf..008e7fcbeb22 100644
> --- a/net/netfilter/xt_ecn.c
> +++ b/net/netfilter/xt_ecn.c
> @@ -139,7 +139,8 @@ static int ecn_mt_check6(const struct xt_mtchk_param *par)
>  		return -EINVAL;
>  
>  	if (info->operation & (XT_ECN_OP_MATCH_ECE | XT_ECN_OP_MATCH_CWR) &&
> -	    (ip->proto != IPPROTO_TCP || ip->invflags & IP6T_INV_PROTO)) {
> +	    (!(ip->flags & IP6T_F_PROTO) ||
> +	     ip->proto != IPPROTO_TCP || ip->invflags & IP6T_INV_PROTO)) {
>  		pr_info_ratelimited("cannot match TCP bits for non-tcp packets\n");
>  		return -EINVAL;
>  	}
> diff --git a/net/netfilter/xt_l2tp.c b/net/netfilter/xt_l2tp.c
> index a61eb81e9f49..ad2d559caa99 100644
> --- a/net/netfilter/xt_l2tp.c
> +++ b/net/netfilter/xt_l2tp.c
> @@ -267,8 +267,9 @@ static int l2tp_mt_check4(const struct xt_mtchk_param *par)
>  	if (ret != 0)
>  		return ret;
>  
> -	if ((ip->proto != IPPROTO_UDP) &&
> -	    (ip->proto != IPPROTO_L2TP)) {
> +	if (ip->invflags & IPT_INV_PROTO ||
> +	    (ip->proto != IPPROTO_UDP &&
> +	    ip->proto != IPPROTO_L2TP)) {
>  		pr_info_ratelimited("missing protocol rule (udp|l2tpip)\n");
>  		return -EINVAL;
>  	}
> @@ -294,8 +295,10 @@ static int l2tp_mt_check6(const struct xt_mtchk_param *par)
>  	if (ret != 0)
>  		return ret;
>  
> -	if ((ip->proto != IPPROTO_UDP) &&
> -	    (ip->proto != IPPROTO_L2TP)) {
> +	if (((ip->flags & IP6T_F_PROTO) == 0 ||
> +	     ip->invflags & IP6T_INV_PROTO ||
> +	   (ip->proto != IPPROTO_UDP &&
> +	    ip->proto != IPPROTO_L2TP))) {
>  		pr_info_ratelimited("missing protocol rule (udp|l2tpip)\n");
>  		return -EINVAL;
>  	}
> diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
> index a1691ff405d3..48aa25749063 100644
> --- a/net/netfilter/xt_multiport.c
> +++ b/net/netfilter/xt_multiport.c
> @@ -160,6 +160,9 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
>  	const struct ip6t_ip6 *ip = par->entryinfo;
>  	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
>  
> +	if (!(ip->flags & IP6T_F_PROTO))
> +		return -EINVAL;
> +
>  	if (!check(ip->proto, ip->invflags, multiinfo->flags, multiinfo->count))
>  		return -EINVAL;
>  
> -- 
> 2.54.0
> 
> 
