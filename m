Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B449143C72;
	Mon,  9 Dec 2024 21:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733779984; cv=none; b=C+iYSQ+H5IcpGx1A58FcFMxAW++iu1hxQbx8hGd0nihrZCFbTJQG+Zb1VILM8jBsVzMPnf749//hByunRZUE3rbd+d6ZsfHaIGN377Tng3//4oyJkwQgevyLiOdwp9/3fiyLfB54JlCrGfKibGKcg4dnPsafF7vYfKp4hrAhyak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733779984; c=relaxed/simple;
	bh=83gwKi7BLovwK9je6MrzbbaKBaNBu9p0RTnu0ulteFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jb9r6rkS+bebIHOBS1L/PctzO/GIFhPF6h8O1V8rF+08Kv3sWZVpZ6aIWyrw+EeTyJ8g/yerqRn4HDwI0AMUquEP3CDZustBRtZi9p0SxrR4NH6lG8PiUPuie6utY216lFlThE/pdaLKWmmYRCgG4Gy4hi8gmRoFJzy3OwXL1m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=34580 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tKlN9-00GAmA-3x; Mon, 09 Dec 2024 22:32:58 +0100
Date: Mon, 9 Dec 2024 22:32:53 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Karol Przybylski <karprzy7@gmail.com>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] netfilter: nfnetlink_queue: Fix redundant comparison of
 unsigned value
Message-ID: <Z1diBYlJUIRBIc2L@calendula>
References: <20241209204918.56943-1-karprzy7@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241209204918.56943-1-karprzy7@gmail.com>
X-Spam-Score: -1.7 (-)

Hi,

On Mon, Dec 09, 2024 at 09:49:18PM +0100, Karol Przybylski wrote:
> The comparison seclen >= 0 in net/netfilter/nfnetlink_queue.c is redundant because seclen is an unsigned value, and such comparisons are always true.
>
> This patch removes the unnecessary comparison replacing it with just 'greater than'
> 
> Discovered in coverity, CID 1602243
> 
> Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
> ---
>  net/netfilter/nfnetlink_queue.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 5110f29b2..eacb34ffb 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -643,7 +643,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  
>  	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
>  		seclen = nfqnl_get_sk_secctx(entskb, &ctx);
> -		if (seclen >= 0)
> +		if (seclen > 0)

What tree are you using? I don't see this code in net-next.git

>  			size += nla_total_size(seclen);
>  	}
>  
> @@ -810,7 +810,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	}
>  
>  	nlh->nlmsg_len = skb->len;
> -	if (seclen >= 0)
> +	if (seclen > 0)
>  		security_release_secctx(&ctx);
>  	return skb;
>  
> @@ -819,7 +819,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  	kfree_skb(skb);
>  	net_err_ratelimited("nf_queue: error creating packet message\n");
>  nlmsg_failure:
> -	if (seclen >= 0)
> +	if (seclen > 0)
>  		security_release_secctx(&ctx);
>  	return NULL;
>  }
> -- 
> 2.34.1
> 
