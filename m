Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131931C8639
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 20:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745441748; cv=none; b=Hj86DYss+osRnT4fuOOi+JQU2k9HU7hmlr0RUTDYEyjKDUOL1SPGlrw8OoBGO5KdeOyrMQ/wuRCCepJVUlIjdjW7RCnsDHzMoG1oamDlfzHaVqg9K4O/kEJFfAJ6GRH5mshu976RDKhO47NhjesLyfG/Cotv5Sk1FdH/N///DD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745441748; c=relaxed/simple;
	bh=IlF+0PUgdaUEvEfs9QeuxEvkaHr0eLwTSfwzVaiEubY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCgc0PuOyOrzi+zUDVfb8eyX3uIVcwfJ6KB+xQWyU6y9oEQyJG2WK7xBr/HnLf2elO5LD+FQK+DzP09/syToPAqiLptGAFh+YvJi4RntfQxuskhqUWzASYHcFokxJu9YIP1ZMBjof0RbVw40D+nzabmwiiftjUECpSWnRF8vqmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GbUwaQf6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NBckZ0tn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GbUwaQf6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NBckZ0tn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 10E3B608D2; Wed, 23 Apr 2025 22:55:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745441737;
	bh=bq2nc8mT+tioBO+jxf1vWH6Up4odOcaK021kdgXr1Qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GbUwaQf6fa3Yrh+olEZimm6tiyOCzSVzrMmybY678Mi5WVxtkEV52Cv+3ncgqqYyv
	 z7+MbYWEv5tDEmFCVfQ0mBkRcu8L+Dej+ZsTZu7aa0gL8VJzL4T04TeEXsQtT4voYj
	 zsHsY0TRSM7zLAO/BhGnWBOP4sI0NizormVxb/Avf1cCzjQH6xdAXGti2FGc+GMPvq
	 CyrH+oc16OmJvzhcDAZNs1qTDf3KWJj4qqGJNmG2QuMQY0kyuTdU/lA+IdhhfIGm82
	 ixDhIF3UcebrIl+xRyFdBsX9NcKfph5ZOKkX7fPpvsuQaAyItxWxFl8aULBLU30fmY
	 niuDzOnsKy0Zw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6E65260760;
	Wed, 23 Apr 2025 22:55:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745441736;
	bh=bq2nc8mT+tioBO+jxf1vWH6Up4odOcaK021kdgXr1Qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NBckZ0tnGRJ1YUSdm2we08eTwa84CjPlsUs8TtCxSAUbTlIaOoIeIfsgx0u6c6Wd/
	 Oz+L2nVmBKik/474E3AkTRzntLfRuYu/EO0IiJoraXd9LWWtnCU/yVI7WcWUAay2OP
	 rBf3L/6CPhVV0mRieBd8D4GhrG/0wH4ehKaEsU6UfuCkAdYd5l5GP6k3pGBlTkjTqC
	 qnMsMKMGV+UNju1TGYKTkBernzzoOWveC0aWlxIZMIlANekhs/qtuDqo7CG9Tu0Crx
	 F/j9Qo/P0y2WlgJwP2pYuOXhFdFLLMPwN9OEDPfT3gewIDeyPf6M2MLNZ67pnMbu6c
	 OInaH/HGPnh0A==
Date: Wed, 23 Apr 2025 22:55:33 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: fix debug splat when
 dumping pipapo avx2 set
Message-ID: <aAlTxYCXPR3H1VRl@calendula>
References: <20250423151702.17438-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250423151702.17438-1-fw@strlen.de>

On Wed, Apr 23, 2025 at 05:16:59PM +0200, Florian Westphal wrote:
> debug kernel gives:
>  ------------[ cut here ]------------
>  WARNING: CPU: 3 PID: 265 at net/netfilter/nf_tables_api.c:4780 nf_tables_fill_set_info+0x1c8/0x210 [nf_tables]
>  Modules linked in: nf_tables
>  CPU: 3 UID: 0 PID: 265 Comm: nft Not tainted 6.15.0-rc2-virtme #1 PREEMPT(full)
>  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>  RIP: 0010:nf_tables_fill_set_info+0x1c8/0x210 [nf_tables]
> 
> ... because '%ps' includes the module name, so the output
> string is truncated.

I will squash this, thanks.

> Fixes: 2cbe307c6046 ("netfilter: nf_tables: export set count and backend name to userspace")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  You can squash merge this if you prefer.
> 
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 90e73462fb69..b28f6730e26d 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4769,7 +4769,7 @@ static noinline_for_stack int
>  nf_tables_fill_set_info(struct sk_buff *skb, const struct nft_set *set)
>  {
>  	unsigned int nelems;
> -	char str[32];
> +	char str[40];
>  	int ret;
>  
>  	ret = snprintf(str, sizeof(str), "%ps", set->ops);
> -- 
> 2.49.0
> 
> 
