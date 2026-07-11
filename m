Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33E438F92A
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2026 09:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783762242; cv=none; b=tV74kgPpiIXOCpDLIW41xIIoR4xE7+WEn9GxwgM/C9uHTeoxNgxHPjA0Xfn5OG8jzCV1SUUw9I7XCel0PF5iudG4ptY0oUlMi5j6ffRQ1tHECCcoczkJ4UikCyByjLXSKuolwEjMGNCkC8zOgECRyU5gTCVnZO21831XTRuP8BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783762242; c=relaxed/simple;
	bh=oHtQcSNkl0cTcrDM+Y0CMOz29lDfecgCvqu+1+chNQQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=keFMhJWzCysqh8i3u2SV2OdPINtxJ3VsXSy0iMwlNEdILuK/jQl6KvwzWj/UivmslDBd6MMamENxIevTdAYqnMUKQAzolQ9r6K+HZ3zloc3/XUtUJGCbVXf0w1b2EH7y8DJ1jJOrcbYzs7PlbAG6SFQ7iPzdU7agO+JB2lxgP0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LdGaOgxs; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdGaOgxs"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15fd3a299eso208260266b.2
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2026 02:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783762239; x=1784367039; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fnMrllSBoOXzaNUANzg8j1Ayva0eFN9/IXQ5KJz42Mg=;
        b=LdGaOgxsPSu4t6Rm/2GsREgZUQgwg2XywDDDCnWIjS2MtQonujmfVIxp1buaXOtr35
         uAMzC9NGxIve7KCZVOsiN0DjJqnAHrmoSaSHux8LFJqDZeXtb11VlWSTHMBbbf5A5LN7
         n5wPiz5GP4WM/xIXCgW0twxdMvILbis1zLb3HSwWD3yqcY/M99bj6UloAR+rf1JxvG/o
         ZTPxS5UQsQTtUknmNJPJVqFugvHfv5ZVjnd3DasGuLXkvpzfxyKVeOMeYqn44n6U8u8Q
         601HCMWSz2wIsOu0shTgJSWH3q3Yd3ZbzoZURFry2dfrwD+EFCKk4Pi1AiFRg7/9/445
         YynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783762239; x=1784367039;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fnMrllSBoOXzaNUANzg8j1Ayva0eFN9/IXQ5KJz42Mg=;
        b=BEMrUymHsGNLaOM6HE/5axnhjEd5uZGEb0uH27F/yZtfCq7BG1tBp6Z41k1FSeWbjS
         NN2ajOCAWdo7M9OZVllxVkOvECQlfecP579+ngu6bYNrm/7vWxq0z3RIcD5Kjf6/ocy1
         ece94vj6BZiHC+4Tdn6cmfswrEV2G8k9WmiVPvnUHrFMtUHVG/pfP3xfFLXMUh7jOyKI
         XT5hYi7OL6eIJiUgTrlY5LD1N2CdChMD5ga1OnDGRzO00MC9x1Am/ENqblZsPdrH1hmy
         NPJD9JT5qlS7YG4ut1RoF3hHZ/ot1gMc0+g+s31HdjSIJE+Ed2PNteXa2cVKG98MyBDu
         x9sQ==
X-Forwarded-Encrypted: i=1; AHgh+RoqKhCyeHORc/RIfWDMa2p+R+/iUHf2BSTeS3ZGkCwzaQjW3/gXd+K9Rxsk4DLEy8ySCDWApDYKB5+fN78RBaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyOXXC6euujEKSa/6twoheXsCwuGlQgxBoK5a321mWpdPR0fro
	waCpwYa87Sm5uqwWvdbIcu/LvkGNwCW/0epQCFLWDQPzy396lYjSJbO8QjfOrGzg
X-Gm-Gg: AfdE7clYydKFJ3laNrDAZRYRurcxTea8ltxCLU2kM5M1LcMl7NHuNK6cz8WFDEZzdvN
	T1UvURDgvI7LjuD7K/tFBaOqOMf6GVCPlQN+fmDCbRPash/H8ZO19fXqRvAW7Fwl1Zu3dtAQst+
	IShSW7htwB3uB4iPp31BE86iJfMld1FBsAWUpNkI+X/h5q4cUuP+6xlk7/5c5Rgy0iyX5MZTDaO
	4x01bbpc8HQgArf6c1HMq+ZM7I8jDmKxS/wXcBMdF4KpLdk3qqLsbhM9fZFCSWBKnNRglvOFOrO
	gPdKGcYm0l5YBcrbfbOIbXLPrLUwgYHyKTRJE67PVoYf8p9EuSqe12n0lqCpRQwnjfKKi1x890K
	b6Nu9h7AhShQzpe1ZpuPMhpYqst+OmTCNOy+pkSHLKeZzf0tFbHffwpX69hhcQx7wx1bTfuFMfy
	2GRxlTn+V2VQbGk/oMOrY8jfv2xD7aCvLTocIV0fhZ/huCX9S4L6rrAO2gtWuvo691mEaMqrhup
	C5ODw2DeP7r0OjzlpQVsQwbOTswsnyjeBFONxVWMUx0MAhpujbmYDZqTne6uXwykryrtrHK6vNa
	k9nKZmXJ9dtu7d46GF59Lu0=
X-Received: by 2002:a17:907:8b99:b0:c16:3187:997c with SMTP id a640c23a62f3a-c163187a0e0mr18458166b.1.1783762238913;
        Sat, 11 Jul 2026 02:30:38 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15e6286a5csm354979566b.11.2026.07.11.02.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2026 02:30:37 -0700 (PDT)
Message-ID: <aaa42109-b5d4-486d-b55d-7d4ea0a0e48a@gmail.com>
Date: Sat, 11 Jul 2026 11:30:36 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Woudstra <ericwouds@gmail.com>
Subject: Re: [PATCH nf-next,v2 1/3] net: pass net_device_path_ctx struct to
 dev_fill_forward_path()
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: razor@blackwall.org, fw@strlen.de
References: <20260710100729.1383580-1-pablo@netfilter.org>
 <20260710100729.1383580-2-pablo@netfilter.org>
Content-Language: en-US
In-Reply-To: <20260710100729.1383580-2-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/10/26 12:07 PM, Pablo Neira Ayuso wrote:
> Generalize dev_fill_forward_path() so it can be used by the bridge
> family to retrieve the bridge vlan filtering information from the
> bridge port when discovering the bridge flowtable path.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: - move nft_dev_fill_forward_path_init() call after out: goto tag
>       to fix a crash otherwise in the existing flowtable ip family.
> 
>  include/linux/netdevice.h          |  2 +-
>  net/core/dev.c                     | 18 +++++++-----------
>  net/netfilter/nf_flow_table_path.c | 14 ++++++++++++--
>  3 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 9981d637f8b5..db04b6d2e8d2 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3420,7 +3420,7 @@ void dev_remove_offload(struct packet_offload *po);
>  
>  int dev_get_iflink(const struct net_device *dev);
>  int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
> -int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
> +int dev_fill_forward_path(struct net_device_path_ctx *ctx,
>  			  struct net_device_path_stack *stack);
>  struct net_device *dev_get_by_name(struct net *net, const char *name);
>  struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);

dev_fill_forward_path is also used in mtk_ppe_offload.c and airoha_ppe.c

This is the build error for mtk_ppe_offload.c:

drivers/net/ethernet/mediatek/mtk_ppe_offload.c: In function
'mtk_flow_get_wdma_info':
drivers/net/ethernet/mediatek/mtk_ppe_offload.c:105:37: error: passing
argument 1 of 'dev_fill_forward_path' from incompatible pointer type
[-Wincompatible-pointer-types]
  105 |         err = dev_fill_forward_path(dev, addr, &stack);
      |                                     ^~~
      |                                     |
      |                                     struct net_device *
In file included from ./include/net/sock.h:46,
                 from ./include/linux/tcp.h:19,
                 from ./include/linux/ipv6.h:103,
                 from drivers/net/ethernet/mediatek/mtk_ppe_offload.c:9:
./include/linux/netdevice.h:3435:55: note: expected 'struct
net_device_path_ctx *' but argument is of type 'struct net_device *'
 3435 | int dev_fill_forward_path(struct net_device_path_ctx *ctx,
      |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
drivers/net/ethernet/mediatek/mtk_ppe_offload.c:105:42: error: passing
argument 2 of 'dev_fill_forward_path' from incompatible pointer type
[-Wincompatible-pointer-types]
  105 |         err = dev_fill_forward_path(dev, addr, &stack);
      |                                          ^~~~
      |                                          |
      |                                          const u8 * {aka const
unsigned char *}
./include/linux/netdevice.h:3436:57: note: expected 'struct
net_device_path_stack *' but argument is of type 'const u8 *' {aka
'const unsigned char *'}
 3436 |                           struct net_device_path_stack *stack);
      |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~
drivers/net/ethernet/mediatek/mtk_ppe_offload.c:105:15: error: too many
arguments to function 'dev_fill_forward_path'; expected 2, have 3
  105 |         err = dev_fill_forward_path(dev, addr, &stack);
      |               ^~~~~~~~~~~~~~~~~~~~~            ~~~~~~
./include/linux/netdevice.h:3435:5: note: declared here
 3435 | int dev_fill_forward_path(struct net_device_path_ctx *ctx,
      |     ^~~~~~~~~~~~~~~~~~~~~
make[6]: *** [scripts/Makefile.build:289:
drivers/net/ethernet/mediatek/mtk_ppe_offload.o] Error 1
make[5]: *** [scripts/Makefile.build:549: drivers/net/ethernet/mediatek]
Error 2
make[4]: *** [scripts/Makefile.build:549: drivers/net/ethernet] Error 2


> diff --git a/net/core/dev.c b/net/core/dev.c
> index 714d05283500..24c384ef9e78 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -750,41 +750,37 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
>  	return &stack->path[k];
>  }
>  
> -int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
> +int dev_fill_forward_path(struct net_device_path_ctx *ctx,
>  			  struct net_device_path_stack *stack)
>  {
>  	const struct net_device *last_dev;
> -	struct net_device_path_ctx ctx = {
> -		.dev	= dev,
> -	};
>  	struct net_device_path *path;
>  	int ret = 0;
>  
> -	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
>  	stack->num_paths = 0;
> -	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
> -		last_dev = ctx.dev;
> +	while (ctx->dev && ctx->dev->netdev_ops->ndo_fill_forward_path) {
> +		last_dev = ctx->dev;
>  		path = dev_fwd_path(stack);
>  		if (!path)
>  			return -1;
>  
>  		memset(path, 0, sizeof(struct net_device_path));
> -		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
> +		ret = ctx->dev->netdev_ops->ndo_fill_forward_path(ctx, path);
>  		if (ret < 0)
>  			return -1;
>  
> -		if (WARN_ON_ONCE(last_dev == ctx.dev))
> +		if (WARN_ON_ONCE(last_dev == ctx->dev))
>  			return -1;
>  	}
>  
> -	if (!ctx.dev)
> +	if (!ctx->dev)
>  		return ret;
>  
>  	path = dev_fwd_path(stack);
>  	if (!path)
>  		return -1;
>  	path->type = DEV_PATH_ETHERNET;
> -	path->dev = ctx.dev;
> +	path->dev = ctx->dev;
>  
>  	return ret;
>  }
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> index 98c03b487f52..5455149e5d9a 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -42,6 +42,14 @@ static bool nft_is_valid_ether_device(const struct net_device *dev)
>  	return true;
>  }
>  
> +static void nft_dev_fill_forward_path_init(struct net_device_path_ctx *ctx,
> +					   const struct net_device *dev, const u8 *daddr)
> +{
> +	memset(ctx, 0, sizeof(*ctx));
> +	ctx->dev	= dev;
> +	memcpy(ctx->daddr, daddr, sizeof(ctx->daddr));
> +}
> +
>  static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
>  				     const struct dst_entry *dst_cache,
>  				     const struct nf_conn *ct,
> @@ -50,6 +58,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
>  {
>  	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
>  	struct net_device *dev = dst_cache->dev;
> +	struct net_device_path_ctx ctx;
>  	struct neighbour *n;
>  	u8 nud_state;
>  
> @@ -70,9 +79,10 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
>  
>  	if (!(nud_state & NUD_VALID))
>  		return -1;
> -
>  out:
> -	return dev_fill_forward_path(dev, ha, stack);
> +	nft_dev_fill_forward_path_init(&ctx, dev, ha);
> +
> +	return dev_fill_forward_path(&ctx, stack);
>  }
>  
>  struct nft_forward_info {

