Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9314EB36
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 15:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715960671; cv=none; b=NLCZJGok50v8OUdTZeLFEZsQTH9U5Jd+rHOry2PwUEVKphqu05hfjGfy4a6pFv8RgWwBLzsqXgbM0Mh9gQGJNSicRsz73fEFiUDgfyR7nWOLzrziiEhVeglPwK4WEJeykV6YWUJN1cmWF/C+ZE86fKEnPcWBKRsaQQ4ddVMIfZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715960671; c=relaxed/simple;
	bh=FUVQAAg37KcBRcCE7guXGu62yVBIrHE7wBbGiVJoPTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvSb66UFuB2fppzYPwCGjZfzP6JgcBDKBOh7UGMkB+dX55lu2xm5Otel2DFoOzcPECekoffHfqUKJRGptC7mzgdUjD8+e6Mw9jcrCaI+zkL8h9c6L3E+JAjtKCZGl2tWcEwC8dnk972I6Uqyl0nDRg7f7tz4jXZ349wjGSiVuE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QSldoxbC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QSldoxbC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715960668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i8HqQyOWHlJujYvayRRSEiSwNuwlA1E1VQsS+1lmH5E=;
	b=QSldoxbC+jfN4HlBsA+ZDUjBN/AB52cf8yD28L1Jm9V08G08om6VPn/2m7/vokSUhR40wa
	n2hzaHI69H3TRD4O44ntISxQHU59NHHVSRJSsWFE3v8J9ma7SH9Tz/3gAjRdDmk9gAeLm3
	lE9pd4AI7hBLWGhtefUC4M+/pAAzPKQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-30-2pACTQUDMhCmfX3nRk2Iig-1; Fri,
 17 May 2024 11:44:24 -0400
X-MC-Unique: 2pACTQUDMhCmfX3nRk2Iig-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B19281C05146;
	Fri, 17 May 2024 15:44:23 +0000 (UTC)
Received: from localhost (unknown [10.22.9.146])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 81F9B491032;
	Fri, 17 May 2024 15:44:23 +0000 (UTC)
Date: Fri, 17 May 2024 11:44:21 -0400
From: Eric Garver <eric@garver.life>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] netfilter: nft_fib: allow from forward/input
 without iif selector
Message-ID: <Zkd7VaibVl_KGLMq@egarver-mac>
Mail-Followup-To: Eric Garver <eric@garver.life>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
References: <20240517153807.90267-1-eric@garver.life>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240517153807.90267-1-eric@garver.life>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

This is of course for nf-next, not net-next. I failed to update the
subject after sending it to the wrong list.

On Fri, May 17, 2024 at 11:38:06AM -0400, Eric Garver wrote:
> This removes the restriction of needing iif selector in the
> forward/input hooks for fib lookups when requested result is
> oif/oifname.
> 
> Removing this restriction allows "loose" lookups from the forward hooks.
> 
> Signed-off-by: Eric Garver <eric@garver.life>
> ---
>  net/ipv4/netfilter/nft_fib_ipv4.c | 3 +--
>  net/ipv6/netfilter/nft_fib_ipv6.c | 3 +--
>  net/netfilter/nft_fib.c           | 8 +++-----
>  3 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> index 9eee535c64dd..975a4a809058 100644
> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> @@ -116,8 +116,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  		fl4.daddr = iph->daddr;
>  		fl4.saddr = get_saddr(iph->saddr);
>  	} else {
> -		if (nft_hook(pkt) == NF_INET_FORWARD &&
> -		    priv->flags & NFTA_FIB_F_IIF)
> +		if (nft_hook(pkt) == NF_INET_FORWARD)
>  			fl4.flowi4_iif = nft_out(pkt)->ifindex;
>  
>  		fl4.daddr = iph->saddr;
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> index 36dc14b34388..f95e39e235d3 100644
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -30,8 +30,7 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
>  		fl6->daddr = iph->daddr;
>  		fl6->saddr = iph->saddr;
>  	} else {
> -		if (nft_hook(pkt) == NF_INET_FORWARD &&
> -		    priv->flags & NFTA_FIB_F_IIF)
> +		if (nft_hook(pkt) == NF_INET_FORWARD)
>  			fl6->flowi6_iif = nft_out(pkt)->ifindex;
>  
>  		fl6->daddr = iph->saddr;
> diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
> index 37cfe6dd712d..b58f62195ff3 100644
> --- a/net/netfilter/nft_fib.c
> +++ b/net/netfilter/nft_fib.c
> @@ -35,11 +35,9 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  	switch (priv->result) {
>  	case NFT_FIB_RESULT_OIF:
>  	case NFT_FIB_RESULT_OIFNAME:
> -		hooks = (1 << NF_INET_PRE_ROUTING);
> -		if (priv->flags & NFTA_FIB_F_IIF) {
> -			hooks |= (1 << NF_INET_LOCAL_IN) |
> -				 (1 << NF_INET_FORWARD);
> -		}
> +		hooks = (1 << NF_INET_PRE_ROUTING) |
> +			(1 << NF_INET_LOCAL_IN) |
> +			(1 << NF_INET_FORWARD);
>  		break;
>  	case NFT_FIB_RESULT_ADDRTYPE:
>  		if (priv->flags & NFTA_FIB_F_IIF)
> -- 
> 2.43.0
> 
> 

