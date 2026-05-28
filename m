Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C1B368276
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 22:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780008891; cv=none; b=BWvu7lLIXeydd+gMPVs//50AzPu0pKpLV+K9PzfOXm+Yl23aMOwp5nr1uI9tnv2IodJ1ZLhoaH7YHRDmich4/x9tlIycb/NsvfSIfHF1qqsV5UE2noWWNZJ9/KCr3WnGmlQ1b6apahuTp9BOeT5mensd0y1n26iSwhrNedccmas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780008891; c=relaxed/simple;
	bh=CkIgU+9p9BfiCkr8KKIac0MYY7FTP/DUbBoGj0dhHrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQ8IKYg/56HuiEL2h5OEn9+LvhRcywEA0+aqMtl0GO2KkpsAnyKOzsXc+U6cSas4VB+kMwd/BRoiB5KUxD5yvtNpDhkgohMBs+W29ze2xZeLAP3M+rZhnnQ4gWQ4LKAyBUyYa+E2UsHRcEKcHevDc/hH6vyzB1InJ3sGuw2hd4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io; spf=none smtp.mailfrom=jrife.io; dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b=T07ZFvxo; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=jrife.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b="T07ZFvxo"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-304dd3bb7a6so98120eec.0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 15:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrife-io.20251104.gappssmtp.com; s=20251104; t=1780008889; x=1780613689; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5eVZ4DejMwq9y5/TGGt0Qr2Xm4AzQr3mA1ghIFaC058=;
        b=T07ZFvxoSRswgnTAKD7m62ZuUCYnDuQvlJx0JfoN+Y9nMCscibM4usYiq8YgqJYne0
         JbM1DJrmdRzBle7DVEQnwcIdi4alvQyXftpuHvkPumMO4kNkNpjgDACMwe0elhxgWABp
         jGndyO6MMXvrk0UoPxefZEEg2NRHiKwWZVGKZgNQmMeEZ5GZhFMBYg4EMGHkGEWqBm5R
         1TC4SRmAFjEMH0yLP0COWZWg1mN33XKrEtp/EvjfH61Pb39ZOinL+BqrLrH0VDVyQP5d
         nF0OlzgFvawV3JHzqm2LgSp3Ei4wkEf0WBVQo9UFblsX0ki6bKY4Jt73X5lYGbfWNRSJ
         47hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780008889; x=1780613689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5eVZ4DejMwq9y5/TGGt0Qr2Xm4AzQr3mA1ghIFaC058=;
        b=BMRW6Xl+eVAvWanMKtfKtjBHWlavX4Fjpjn0qBXGub5LUhwc51LGOgES7Cs4fkkaH1
         L7vRWcTYGC4OaJh9fYHrNtZwREepsqNAEyuPVCvDdMjj9W7/ipJdj1GW6Y7rtygVT9a/
         8gGwS1GrBC4AHSQ75ig1i7xAHbe6ha3zoSI7Nmin6beqs4vQnlTHPPUwFE7r/Kca/qA+
         r3mdu74MM3LC7m1TXkZ5ScOAbOyU4R52x/qXfTjupVmLpd+pI2hjVkvq4TfPRrq5GJWy
         smlifNyTnuEaMO8I+SjdrReaOcfLwXkLTxFx0W09+2xOEKmj1NOyGcLrxXKx+O8gF781
         g/nQ==
X-Forwarded-Encrypted: i=1; AFNElJ/JDzFk3E7QCkJsYy7VaVDbbW/e5M7gmJaUssvdTCdGEEmLSn9p5SV4PjvovZVR9PWAt9T+Lr4absLxHJhX+Fg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdKJmfBJ6/OCFfEZpxc6yKMD4vvZ5yeDTbocGgo3SSpQmBizyL
	KCV9vGCHCMzWjid9HlyHrPsAwwGU18CHV/V7c2CdRcaLRys2t84BBo+mx+tpA0YfV94=
X-Gm-Gg: Acq92OEeNb7W4dHwMW4/Kfs9OteGBMh7zbhFTDGYbOgltTY8KoI0bHEISm776vu/Jmk
	EfEUhOEoxi9CprKfFnXR+TgPw6MPmALMWc3OEYn18O+s8FkA2Z/1OXfwp0NPZ8EfV2VCwe7r5Zf
	Aqwytxl3ZDLpeE/zXFbnvC6iZfgO1q2AKr+jyBO8gGF6qiegPzTnFwhRN1aOuLvgdi8SV+Hil71
	u6XR+6JNzjpnYANYl2BqynRHwtId2l+m0yESeRiAH6ObjVxYOtwUdefElpPu2m3VCC1ExNU0y6l
	k+ceczIksCHHAWXQRW7qTPlWtEihs33a8/H4A0w1M1Mn0yChEhvPZqNYZyoegc3kVkFYXIQREJs
	JyiymHPHDmi1LX8Xgj5LvVmsGrsDFuecOYQnzuAjBxaJBgnganIn2z8i7ohOCuvojogcFO7xhBl
	F5Est9cpK3ohIBpR/VJyjXPYa7+tCH5YOjvjo=
X-Received: by 2002:a05:7301:4186:b0:2ea:5057:a320 with SMTP id 5a478bee46e88-304eb0f1c17mr99701eec.2.1780008888653;
        Thu, 28 May 2026 15:54:48 -0700 (PDT)
Received: from m2 ([83.171.251.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304eb9975b7sm181947eec.6.2026.05.28.15.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 15:54:48 -0700 (PDT)
Date: Thu, 28 May 2026 15:54:46 -0700
From: Jordan Rife <jordan@jrife.io>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net, 
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org, yonghong.song@linux.dev, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v7 1/7] net: move netfilter
 nf_reject_fill_skb_dst to core ipv4
Message-ID: <46rav7qeseaysu5tlzvkst2ukbqgzj5nyk5joar4pnlokj5e6o@4fh4loahchyi>
References: <20260526153708.279717-1-mahe.tardy@gmail.com>
 <20260526153708.279717-2-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526153708.279717-2-mahe.tardy@gmail.com>

On Tue, May 26, 2026 at 03:37:02PM +0000, Mahe Tardy wrote:
> Move and rename nf_reject_fill_skb_dst from
> ipv4/netfilter/nf_reject_ipv4 to ip_route_reply_fill_dst in ipv4/route.c
> so that it can be reused in the following patches by BPF kfuncs.
> 
> Netfilter uses nf_ip_route that is almost a transparent wrapper around
> ip_route_output_key so this patch inlines it.
> 
> Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
> ---
>  include/net/route.h                 |  1 +
>  net/ipv4/netfilter/nf_reject_ipv4.c | 19 ++-----------------
>  net/ipv4/route.c                    | 15 +++++++++++++++
>  3 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/include/net/route.h b/include/net/route.h
> index f90106f383c5..300d292cd9a1 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -173,6 +173,7 @@ struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
>  				    const struct sock *sk);
>  struct dst_entry *ipv4_blackhole_route(struct net *net,
>  				       struct dst_entry *dst_orig);
> +int ip_route_reply_fill_dst(struct sk_buff *skb);
> 
>  static inline struct rtable *ip_route_output_key(struct net *net, struct flowi4 *flp)
>  {
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index fecf6621f679..c1c0724e4d4d 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -252,21 +252,6 @@ static void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *
>  	nskb->csum_offset = offsetof(struct tcphdr, check);
>  }
> 
> -static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
> -{
> -	struct dst_entry *dst = NULL;
> -	struct flowi fl;
> -
> -	memset(&fl, 0, sizeof(struct flowi));
> -	fl.u.ip4.daddr = ip_hdr(skb_in)->saddr;
> -	nf_ip_route(dev_net(skb_in->dev), &dst, &fl, false);
> -	if (!dst)
> -		return -1;
> -
> -	skb_dst_set(skb_in, dst);
> -	return 0;
> -}
> -
>  /* Send RST reply */
>  void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>  		   int hook)
> @@ -279,7 +264,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>  	if (!oth)
>  		return;
> 
> -	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
> +	if (!skb_dst(oldskb) && ip_route_reply_fill_dst(oldskb) < 0)
>  		return;
> 
>  	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
> @@ -352,7 +337,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
>  	if (iph->frag_off & htons(IP_OFFSET))
>  		return;
> 
> -	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
> +	if (!skb_dst(skb_in) && ip_route_reply_fill_dst(skb_in) < 0)
>  		return;
> 
>  	if (skb_csum_unnecessary(skb_in) ||
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index bc1296f0ea69..1f031c5ef554 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2945,6 +2945,21 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
>  }
>  EXPORT_SYMBOL_GPL(ip_route_output_flow);
> 
> +int ip_route_reply_fill_dst(struct sk_buff *skb)
> +{
> +	struct rtable *rt;
> +	struct flowi4 fl4 = {
> +		.daddr = ip_hdr(skb)->saddr
> +	};
> +
> +	rt = ip_route_output_key(dev_net(skb->dev), &fl4);
> +	if (IS_ERR(rt))
> +		return PTR_ERR(rt);
> +	skb_dst_set(skb, &rt->dst);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ip_route_reply_fill_dst);
> +
>  /* called with rcu_read_lock held */
>  static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
>  			struct rtable *rt, u32 table_id, dscp_t dscp,
> --
> 2.34.1
> 

Reviewed-by: Jordan Rife <jordan@jrife.io>
