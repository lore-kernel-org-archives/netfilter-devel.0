Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDD73563F6
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 22:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780008907; cv=none; b=oNsJ+qeIBQMyVeoTzMltmLHsBFUedqlnm1iQuTDuyN55io7CC0tNDUWe5RGGvOvu1uWedx21rrbn9omTyGXvSmiO8QWIBRD0Sb7Z3UTCxJBtZjk0TUev7ZFj9BqKGjVI3llOn+/1XjJfiAprF4efcRsc91sD0bniwFvPHwDLGYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780008907; c=relaxed/simple;
	bh=gtljMXsLt3yuATSOx6mN+Y1Zs+1DRSvC1XdeM0vs0f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2PV3mYlet4DtOSKNxglCT69Oxz9byYcPZNITUHc9JWRN0s6CRYEyiito4MwtdDlKBP3817x4cQVQQ2audhPF9eBWdhQSNbLolqV+d4Pl8yjXYxYKXOxIS/ZizHbP4GVgKcOa9zmqYiX/siMwzcftAdUvIqdZzK5XBmnrvwQCUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io; spf=none smtp.mailfrom=jrife.io; dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b=ZQcHhRoi; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=jrife.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b="ZQcHhRoi"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-30436e8f582so891129eec.3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 15:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrife-io.20251104.gappssmtp.com; s=20251104; t=1780008905; x=1780613705; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T+Bu3whT8wDoGy2urfE3+6z84iXvQgIkWagXFGYPZBs=;
        b=ZQcHhRoiGR38XJVF/n6G2Psao3II+34qFYoBDdFiVh9EfpFhbUwIBhURdWC4kZ8IfD
         ce7GBpdWersACKR7dFQP7kJcvm+7YTTzr79y9TbU1hlOBpbsFx8Swwrlwm4sksxZXWnM
         oNRyEtyq89SLGFPIIfqFf1LSiklec8Hccu8O7YoR+A5okWXJqfxQRuNDy2WWll30ZjCU
         4EafKsD5FQpiRj26IkWQ0/6RT8XzvR4nIZQzq2fNTQflLJZ6+Ia4KrlKhg31OTVgBzH2
         cTD6/h8ubuSmYjd1u5iT8pPx/1n+0MF6WeWCd7YQuzrnZKzx+WmwCMEQM+5gtOw/AaWT
         ZQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780008905; x=1780613705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T+Bu3whT8wDoGy2urfE3+6z84iXvQgIkWagXFGYPZBs=;
        b=lIe9NGtXotMwcjTjNknGfiTVxn4CK5rvqiKXVoSOyB71S+3gSvV0D5Un+j17n/o29T
         VBtKKHyRM69gRpy6vGSCe67FNMz4kUpn9hrdmN1bubm0/Jq3FdyCbfCL0YpoisbQlHgy
         RShK5lSZ1wdFfcrruw566hEVCgDmc0Tqy4F7lTYcJKGtyc+Y6QlyT3WFsVMV7pd6m3+6
         6VYyprK2V19PpMla3ws7fHuLBScIs4/9aoCtdLG1dcmtFKoQYFOR28hCRhn+vuHbb7Sw
         TKrYi2RYzDrDaETR/WngLESZ2zrhA1S1s7+oSXHzYOVnojo4fDYthSvvqOT+C13/hoT0
         vHww==
X-Forwarded-Encrypted: i=1; AFNElJ9bpo1OVBDmwB7CpZdftXm9ASeGdj9xVf3b5kWpLHEKzJx6jeMR6GJcmq58U7ms5x8FSl7iwlFycsaZf/QYrYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM00SP00QH7yx050zj/yw+37RSU9ysDpRSimUGCwSe6YLxIJ56
	Kwjit/UFLxgjaQA5ZIk9hX4749KSC/KpbkrxpIs9weqIGiRbCAwr5yK62NtPNCvKS8M=
X-Gm-Gg: Acq92OEoyRlxPDw0tl7GbWiGQrs5LwYs6eD8DfB+VM0H8THZTihRwaQnBteNMJRT29/
	3InG5/GYyk7IADqs98qZd1ZrC2VZqH5wBGsiIM75+9T3Csx6GP6Rpi/da9kPe9ip+GwoAMAeaqE
	77WgzgZmaAfaVo5o9mIIjQz/ormSKiLRv6qTgVat+Khly17Dif3YNIvU+hnJQ60k4jo+kzt4k+v
	0RvCX95CWxgHAM0BS5o6B7PWXUGG0oO10LSNeeFuN64uCoxAhZUVMuNkyDostVN1c/SyxhGjLr8
	RCNbFrIgUvAGOB7znNydx6I6RTxiVEvWVj4IjP0fpA0CAqgRfA1IDqlMec5HjhcEpAE09DPQkEb
	iDZzS/zwNsshuBtZ4Nzni4+YINvfNfzln9k8cOaHY0a79oEtbv4Z582u7Gudpy8t5t2Zh+JUysa
	qfDg9gyBBWNiAYNt9SahtHdfMw
X-Received: by 2002:a05:7300:5b9e:b0:2da:a813:a629 with SMTP id 5a478bee46e88-304eadf06bfmr126990eec.2.1780008904637;
        Thu, 28 May 2026 15:55:04 -0700 (PDT)
Received: from m2 ([83.171.251.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304eb9cea7fsm172041eec.9.2026.05.28.15.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 15:55:04 -0700 (PDT)
Date: Thu, 28 May 2026 15:55:02 -0700
From: Jordan Rife <jordan@jrife.io>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net, 
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org, yonghong.song@linux.dev, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v7 2/7] net: move netfilter
 nf_reject6_fill_skb_dst to core ipv6
Message-ID: <gh2qntycqbbsaotyrzisuvv7nqckehtiz25negdykjdvnewv3h@zquvaw6h5dq5>
References: <20260526153708.279717-1-mahe.tardy@gmail.com>
 <20260526153708.279717-3-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526153708.279717-3-mahe.tardy@gmail.com>

On Tue, May 26, 2026 at 03:37:03PM +0000, Mahe Tardy wrote:
> Move and rename nf_reject6_fill_skb_dst from
> ipv6/netfilter/nf_reject_ipv6 to ip6_route_reply_fill_dst in
> ipv6/route.c so that it can be reused in the following patches by BPF
> kfuncs.
> 
> Netfilter uses nf_ip6_route that is almost a transparent wrapper around
> ip6_route_output so this patch inlines it.
> 
> Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
> ---
>  include/net/ip6_route.h             |  2 ++
>  net/ipv6/netfilter/nf_reject_ipv6.c | 17 +----------------
>  net/ipv6/route.c                    | 18 ++++++++++++++++++
>  3 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> index 09ffe0f13ce7..eb5a60d3babe 100644
> --- a/include/net/ip6_route.h
> +++ b/include/net/ip6_route.h
> @@ -100,6 +100,8 @@ static inline struct dst_entry *ip6_route_output(struct net *net,
>  	return ip6_route_output_flags(net, sk, fl6, 0);
>  }
> 
> +int ip6_route_reply_fill_dst(struct sk_buff *skb);
> +
>  /* Only conditionally release dst if flags indicates
>   * !RT6_LOOKUP_F_DST_NOREF or dst is in uncached_list.
>   */
> diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
> index ef5b7e85cffa..7d2f577e72b8 100644
> --- a/net/ipv6/netfilter/nf_reject_ipv6.c
> +++ b/net/ipv6/netfilter/nf_reject_ipv6.c
> @@ -293,21 +293,6 @@ nf_reject_ip6_tcphdr_put(struct sk_buff *nskb,
>  						   sizeof(struct tcphdr), 0));
>  }
> 
> -static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
> -{
> -	struct dst_entry *dst = NULL;
> -	struct flowi fl;
> -
> -	memset(&fl, 0, sizeof(struct flowi));
> -	fl.u.ip6.daddr = ipv6_hdr(skb_in)->saddr;
> -	nf_ip6_route(dev_net(skb_in->dev), &dst, &fl, false);
> -	if (!dst)
> -		return -1;
> -
> -	skb_dst_set(skb_in, dst);
> -	return 0;
> -}
> -
>  void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>  		    int hook)
>  {
> @@ -440,7 +425,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
>  	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
>  		skb_in->dev = net->loopback_dev;
> 
> -	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
> +	if (!skb_dst(skb_in) && ip6_route_reply_fill_dst(skb_in) < 0)
>  		return;
> 
>  	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index e3d355d1fbd6..37a7627a94de 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -2725,6 +2725,24 @@ struct dst_entry *ip6_route_output_flags(struct net *net,
>  }
>  EXPORT_SYMBOL_GPL(ip6_route_output_flags);
> 
> +int ip6_route_reply_fill_dst(struct sk_buff *skb)
> +{
> +	struct dst_entry *result;
> +	struct flowi6 fl = {
> +		.daddr = ipv6_hdr(skb)->saddr
> +	};
> +	int err;
> +
> +	result = ip6_route_output(dev_net(skb->dev), NULL, &fl);
> +	err = result->error;
> +	if (err)
> +		dst_release(result);
> +	else
> +		skb_dst_set(skb, result);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(ip6_route_reply_fill_dst);
> +
>  struct dst_entry *ip6_blackhole_route(struct net *net, struct dst_entry *dst_orig)
>  {
>  	struct rt6_info *rt, *ort = dst_rt6_info(dst_orig);
> --
> 2.34.1
> 

Reviewed-by: Jordan Rife <jordan@jrife.io>
