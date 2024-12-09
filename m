Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E2419CD0B;
	Mon,  9 Dec 2024 22:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733782859; cv=none; b=K7bBcSlRwGu1sxzKi9/lXlVA41lptiRKOSR9A28OQ0YoOUGb3B3MwOCbmA3qqUVz5DwrlfMCDetYY95Z1BpKXyTC+4p1/yDAtSNznd6iPalrgxMqTKsmOqMW+fil/9e4fCfm5t1jKWPMS6fyCayzcHtGdkJJ69VtKYF9ufUMXs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733782859; c=relaxed/simple;
	bh=Cs06nYZjCamsC5t3oilkrWOG7mho1lwC6TBmhVBTV+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D8JoWQXfVQEb7DNbTW+rgM3kP0kPT7ohSVVJI6AK/Qwe8MFEjBgBod9Pyj2alo31WcDKARUuy01wImqt5KTwhTLVLoP2nEHSqIGZPWWTl80aeqLUtEVgC0IEwIxq3W1gz08gUUTDdvWUih8iURWrib0I7RfIGWS5iL/l/6cbCd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tKm7a-0001NZ-1t; Mon, 09 Dec 2024 23:20:54 +0100
Date: Mon, 9 Dec 2024 23:20:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Karol Przybylski <karprzy7@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	casey@schaufler-ca.com
Subject: Re: [PATCH] netfilter: nfnetlink_queue: Fix redundant comparison of
 unsigned value
Message-ID: <20241209222054.GB4709@breakpoint.cc>
References: <20241209204918.56943-1-karprzy7@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209204918.56943-1-karprzy7@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Karol Przybylski <karprzy7@gmail.com> wrote:

[ CC original patch author and mass-trimming CCs ]

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
>  			size += nla_total_size(seclen);

Casey, can you please have a look?

AFAICS security_secid_to_secctx() could return -EFOO, so it seems
nfqnl_get_sk_secctx has a bug and should conceal < 0 retvals
(the function returns u32), in addition to the always-true >= check
fixup.
