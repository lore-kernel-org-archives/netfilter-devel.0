Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F761917EB;
	Thu, 15 Aug 2024 08:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723710743; cv=none; b=bB71Si1Kf7JHDMO18veuMa6RPPdxDWKJvEYcYdp6Spvz+m1Fq+Oku6Eylw6CDTAcXj8oTNNHQAXBYiOERQzP1ccpiSzMEF768zYsMtaM9wAS++b7vCrUo2+WFiex3XQKX+prJDfk9EkdM67FJzkiDneszhBsbvJh5ZhRmNqTvDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723710743; c=relaxed/simple;
	bh=+dAX0UQxceJZdmBGazyjyPdhj/+kl5T7PVlc+E4psPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CHblcAOS+Fyxw84i9g/8bGfWrgq97SO15VCj39m9qu4LUkWM0mQBboQ1vLaJv6dPNJerxe0KptA3HJDo/FUswYNm6aJWMIk/FMm9deiHwOpyNl9qpkn64vOo9514/ka2+P6MiuZgFByEGhViuMgN759JGwrHNApu8jZw2UgblKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43940 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1seVtw-00Gq8k-Hj; Thu, 15 Aug 2024 10:32:11 +0200
Date: Thu, 15 Aug 2024 10:32:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: icejl <icejl0001@gmail.com>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink: fix uninitialized local variable
Message-ID: <Zr29B7UWlDCYQMCR@calendula>
References: <20240815082733.272087-1-icejl0001@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240815082733.272087-1-icejl0001@gmail.com>
X-Spam-Score: -1.9 (-)

There is a fix already traveling for this in a pull request.

On Thu, Aug 15, 2024 at 04:27:33PM +0800, icejl wrote:
> In the nfnetlink_rcv_batch function, an uninitialized local variable
> extack is used, which results in using random stack data as a pointer.
> This pointer is then used to access the data it points to and return
> it as the request status, leading to an information leak. If the stack
> data happens to be an invalid pointer, it can cause a pointer access
> exception, triggering a kernel crash.
> 
> Signed-off-by: icejl <icejl0001@gmail.com>
> ---
>  net/netfilter/nfnetlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 4abf660c7baf..b29b281f4b2c 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -427,6 +427,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>  
>  	nfnl_unlock(subsys_id);
>  
> +	memset(&extack, 0, sizeof(extack));
>  	if (nlh->nlmsg_flags & NLM_F_ACK)
>  		nfnl_err_add(&err_list, nlh, 0, &extack);
>  
> -- 
> 2.34.1
> 
