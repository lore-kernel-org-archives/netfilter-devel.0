Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C8D2FD1DA
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 09:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783848496; cv=none; b=RVwyxsCbUznf/e4bFGyF1K6akLndlVyh4pi80Ua8XRXFYijsnXUZnqsPZz24xU3ZSW0okqUlytVysc6t7SNEdPF350HKbFQnQw6Jmi+iZcSe8PlKpIPlTrK7IYcqgk7PlGTl/McarQOYlg2gDYzlWYqFsgbPzVnmHbRrbthYQcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783848496; c=relaxed/simple;
	bh=bLKV4NYDeKWHPAIPA8DHEW0gmWY1K2b80CTdJlDXpLQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=YHmOR/pz1ies8GbhqaZvyL1uaOu14OxHrdn0eO90f5hY1x06ERa0PiEjTXhiQtSXqcUNnp5O8QPAFV6KdDqL9wkceDObJ902u8iB0ROFfwLT6fkie62qHaMP3Ss0/gI+unaNHVBYS6o5ri5+Rlu1YIHLGJiecTctHiYM+APiLmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TeZ5AVLk; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TeZ5AVLk"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6974a6e54dbso3177509a12.2
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 02:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783848493; x=1784453293; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4yrJMABWt2zXSZGuLzEGRfiMrU2SYPLpYJYM1NEnO/c=;
        b=TeZ5AVLkLvgp+E++Ie63ed2VjrACfMTeFWIcpdCWIX/TIxdKa0gx448NVre2f/lEVY
         SBdmW+cC4ZWo5+Ar0CVjY+8uRkdlYLQB8JRYws1cNhJtf+PjSJ9dAUYIBAInAO8rTWV6
         IWjpl4kuY+TsPNE7ZHkM66NOdrlhbeUnbjAmOeY6msM05+phYn411Sl2G2w/F7V3ENXV
         bIp3HAU0IKPTA2pJVvcKsQIeBtblu/pnG/xBLc7av2liPBC50E6UGnmTCOtuXda5ipya
         wLsnTixYHXUl9J988X3eodYAzxbvaInjh1EqeWDw7xbezfBe6vKN3IFUEW3mQiXe5WGl
         kzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783848493; x=1784453293;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4yrJMABWt2zXSZGuLzEGRfiMrU2SYPLpYJYM1NEnO/c=;
        b=Q2UIbmv0eKIOiORjKzNnWVbcb4awQ02i26CYgTG2JJczNxw0hXWy7+lzJcdvtLcNAS
         mRnOc/xCbAqItR3VBAs95wBhbFd9LHaQGR7LqBr2s6xwO6urdRpKu+nWmM1/HiMntIFa
         znFPUCXK939F8d/dbjukm87sah/R/+djTbtFrGGN5rI0+tEVamU3guI2s1yXKj3ONZ2f
         3gzl/9LyPbrdx1HLeeT5M4QQWeYvOkdUrjd0c/2MqjPVDOF2+1eIkMleWPx244IvAv9R
         Jk5XSdLlgcWr8SoBlkLzcsVJVkjfqdZKggtpdJCo43xkoJBYVPGqtBhxADKjfZzbMpg/
         kdQQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpb8kWfwehILsKJPcIRlKPboOgU55oFJDt3HQdfTqt1j6Jnq42pYON8PVkmGBZRA/AavJAdGqACpPTdTHbxCK4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa+uX0fmes4UvHQkNDT9AhyabytelQOe0KcT4fcKQ44E1RCIOZ
	LEMA+bJrAMhRyA4SQYlyT20XpBRefI+amlR4/eQuQv9pf6++FHjBVqsu
X-Gm-Gg: AfdE7cnJJaFcHeDRpGa/mALmE0CwGvVdhXibdFGqjDJXbDq7LW4pjdEaAQ4W22Qdvcx
	WxB8SZt56zbOtshLF35yPwjdthEl+cgXufKnSwSQyKE4Uhe1lb8eNxUbGM2tDrD3QNmzRRlkP0i
	rJ+sF1u3O+oUbDBFh2VG9dVLmpL3cYg0k2hQm+o0RzhW4W2PukQo/0onRKnqSn/l9do/fxNE/3s
	B/HWuscg05+Le4DWrXxIdHUkvQ1+ormmfXNt0tJXoi+wAZuNAF9Y+xZiRXwLvMRgv4mCJ62SRAA
	uypGMoXhRtfjqvkhMTD5ve9c1KSt/Ht+0z9T8A7DRcpIcQF59UH9ra41cNCaRm6Iaaetp3ljYFg
	TOtMxlK7Yb9FffJ27hMDPrrhYpPSCbyxh06BR2BPBKarZyGmvrx2e7gJEKRfjGgsJnQZl9BvZmh
	cLy4tcUzDdCXhZyUL5a2NRbgaSrTcaCjwcNLC7rz5TYcTPbgFws17wqZxQ9x4NMDoll+uwkKkG7
	sFadNYlRA/iY37eJB8JQaLllUg1vZEI3iqe/drMY5VeXxYngIhtuI2XYg293pC4EHHL/+4nZOKn
	mRtPQDTAqiGJWR8feTc8KbM=
X-Received: by 2002:a17:907:1ca0:b0:c15:bea2:d209 with SMTP id a640c23a62f3a-c161e956e63mr217842266b.4.1783848493262;
        Sun, 12 Jul 2026 02:28:13 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15ada023acsm839251166b.54.2026.07.12.02.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 02:28:12 -0700 (PDT)
Message-ID: <5f4d5f1e-edab-4b9c-9c86-b9554492e0dd@gmail.com>
Date: Sun, 12 Jul 2026 11:28:11 +0200
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

Calling dev_fill_forward_path() from nft_dev_fill_bridge_path()
it does not traverse the bridge. It exits at the source "indev"
already. After calling nft_dev_path_info(), the info structure
is filled in with the opposite device and the encaps of the
opposite device.

Would need to add something like this:

int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
			 struct net_device_path_stack *stack)
{
	const struct net_device *last_dev, *br_dev;
	struct net_device_path *path;

	if (!ctx->dev || !netif_is_bridge_port(ctx->dev))
		return -1;

	br_dev = netdev_master_upper_dev_get_rcu((struct net_device *)ctx->dev);
	if (!br_dev || !br_dev->netdev_ops->ndo_fill_forward_path)
		return -1;

	last_dev = ctx->dev;
	path = dev_fwd_path(stack);
	if (!path)
		return -1;

	memset(path, 0, sizeof(struct net_device_path));
	if (br_dev->netdev_ops->ndo_fill_forward_path(ctx, path) < 0)
		return -1;

	if (!ctx->dev || WARN_ON_ONCE(last_dev == ctx->dev))
		return -1;

	return dev_fill_forward_path(ctx, stack);
}
EXPORT_SYMBOL_GPL(dev_fill_bridge_path);

First need to find the bridge device to call ndo_fill_forward_path()
from it.

This also needs the patch "bridge: Add filling forward path from port to
port"
That patch still needs a change according to Nikolay.

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

Need to move:

stack->num_paths = 0;

To here, remove it from dev_fill_forward_path().

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

