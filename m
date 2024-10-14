Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98961C82F4;
	Mon, 14 Oct 2024 18:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728930852; cv=none; b=WEGRBj/SDKeKe7GqjqqcNNlXBbauJU+DEZJ07FWfhDdnlaJoR+lyF06iz0wKy3CZVpu1LntCimkrhCxcMC8iWKOoBuJWA0SF3xS27404xN+On9vuBOVo9FG/o+SiTVlF1pnrMMwlR4INjQUXVKW0Xf9LWYEJTvkbLtRPNMAGjSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728930852; c=relaxed/simple;
	bh=UO2Bad4J5y0XW53XxtAm0h5XmWXUfxO04tiAMyE160U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FAhZDu3wIKEf5QvzBlGUHNROXDz3TW+8+YFFckl7eZTGRA2TFvcGvfQwM3So/EMLF89CTPxiKZ+YHPPgmeYgii3jbVAogLVM7GJVqNpO1yMzf7AboegvCNWP5z90TJvzFK+vi+qsnrYNUafNtk9Q0siw0Om5fWsO4vwwrYGjk4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jeDcHjAK; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jeDcHjAK"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a86e9db75b9so665903966b.1;
        Mon, 14 Oct 2024 11:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728930849; x=1729535649; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VlOnxyLsKzjPmX7mgEUAeOELC286PF6R2i4tL7ZkhEQ=;
        b=jeDcHjAKHo9pO8oKHIsC6kLiPjNYsWRoulcGf5Wipz2wQjA7tCtlocQLgJTomFUCtW
         XoB0uxM7/oLsDMzVDmJbHo5k+IYAGbXSyZjnFWb/yZ9ozCvurPvGnaRJDj28/+2BVdN5
         bZGdPY4OgA28wSQuB1nwBS7XdB5sJOKyE4nKlCpa+ZkhsL3WW/jV8Fv18iW+ZwQnUxub
         Tgi2YcG0r71rKyrYKs6d9wXqcCg2g8bF0VLHxpTVlp12vyO6OldI5g4pVJ96wzW9z348
         V1RFKSvZQvvTcl/YbTZDfXkXrtOxLbPtt6akvorsngWorcQA5xsfeQ1uzINU2M5EIrib
         ZdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728930849; x=1729535649;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VlOnxyLsKzjPmX7mgEUAeOELC286PF6R2i4tL7ZkhEQ=;
        b=EMZzj9U/+pF03nhPC6KqGVVDgP+uwVsJu0SDmSDJuDbAf25eq7aXL7b8O8GacwnOjV
         GU4WENMh8rKr3Pbp1ToT/1LShgRhrRog8d+v8gDLnYX4ze6NvuMxHyKl6oKYeI6c0QN3
         br67G1srqiVNdKBaoqMCF6C5Mh+Iclelr9cN12i313ryguqHTDNgaQdAZf8F0FZVuCNw
         e/2A0ttMpFLmvaZNb5AxrzvW7TRd1VQrIr+YdcBTJOjRqmDg9adtvGxHvw4QM5TkULXq
         ZXreoXkx00bxdru6rD//6Bbp0fadL4isuXdWKD+xg8Jt7aoClAPOc4+v8KXYmr39QTZD
         Yh3w==
X-Forwarded-Encrypted: i=1; AJvYcCU3HUyNPrcPjmrfLYSRUK3sGoHsB/F2jHBjLCKmIrHLGqp0L1XIJG1uS5YmIISWv6iRrSFvZNUOn0BExPM=@vger.kernel.org, AJvYcCWq2T8G6J73U4bM2byTaCR0Q57zED2oj+AeJquwW/JgZPwACBI3Hri43zeKK46uQj5bqaw9YOkjcJpK0rGmHDAy@vger.kernel.org
X-Gm-Message-State: AOJu0YwGYNs6+wZGYgywTANuCJwXgPj83GGrubonNmoxAUennUVLxwZx
	Q31LWsQ3u5yQi7ADo+WCFIlN0zncXgQ4T3e4vd1atSnDdZ1dg6z/
X-Google-Smtp-Source: AGHT+IHKZO+fC56r4LaVpTKQzX/+/pa5l07qojFohlY7OCNXpmf0sPt3hbXHuNvHiBIPoGLRAmVB1g==
X-Received: by 2002:a17:907:97cd:b0:a99:dfb3:dcb4 with SMTP id a640c23a62f3a-a99dfb3df63mr790057066b.39.1728930848857;
        Mon, 14 Oct 2024 11:34:08 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a04223e3csm261266766b.52.2024.10.14.11.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 11:34:08 -0700 (PDT)
Message-ID: <a0db4efa-2328-4935-9eb6-3344fcbc4b07@gmail.com>
Date: Mon, 14 Oct 2024 20:34:07 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 06/12] net: core: dev: Add
 dev_fill_bridge_path()
To: Nikolay Aleksandrov <razor@blackwall.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Jiri Pirko <jiri@resnulli.us>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <20241013185509.4430-7-ericwouds@gmail.com>
 <c3678626-7f5c-4446-9b4d-2650ddf5d5a6@blackwall.org>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <c3678626-7f5c-4446-9b4d-2650ddf5d5a6@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/14/24 8:59 AM, Nikolay Aleksandrov wrote:
> On 13/10/2024 21:55, Eric Woudstra wrote:
>> New function dev_fill_bridge_path(), similar to dev_fill_forward_path().
>> It handles starting from a bridge port instead of the bridge master.
>> The structures ctx and nft_forward_info need to be already filled in with
>> the (vlan) encaps.
>>
>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
>> ---
>>  include/linux/netdevice.h |  2 +
>>  net/core/dev.c            | 77 ++++++++++++++++++++++++++++++++-------
>>  2 files changed, 66 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index e87b5e488325..9d80f650345e 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -3069,6 +3069,8 @@ void dev_remove_offload(struct packet_offload *po);
>>  
>>  int dev_get_iflink(const struct net_device *dev);
>>  int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
>> +int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
>> +			 struct net_device_path_stack *stack);
>>  int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
>>  			  struct net_device_path_stack *stack);
>>  struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index cd479f5f22f6..49959c4904fc 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -713,44 +713,95 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
>>  	return &stack->path[k];
>>  }
>>  
>> -int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
>> -			  struct net_device_path_stack *stack)
>> +static int dev_fill_forward_path_common(struct net_device_path_ctx *ctx,
>> +					struct net_device_path_stack *stack)
>>  {
>>  	const struct net_device *last_dev;
>> -	struct net_device_path_ctx ctx = {
>> -		.dev	= dev,
>> -	};
>>  	struct net_device_path *path;
>>  	int ret = 0;
>>  
>> -	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
>> -	stack->num_paths = 0;
>> -	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
>> -		last_dev = ctx.dev;
>> +	while (ctx->dev && ctx->dev->netdev_ops->ndo_fill_forward_path) {
>> +		last_dev = ctx->dev;
>>  		path = dev_fwd_path(stack);
>>  		if (!path)
>>  			return -1;
>>  
>>  		memset(path, 0, sizeof(struct net_device_path));
>> -		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
>> +		ret = ctx->dev->netdev_ops->ndo_fill_forward_path(ctx, path);
>>  		if (ret < 0)
>>  			return -1;
>>  
>> -		if (WARN_ON_ONCE(last_dev == ctx.dev))
>> +		if (WARN_ON_ONCE(last_dev == ctx->dev))
>>  			return -1;
>>  	}
>>  
>> -	if (!ctx.dev)
>> +	if (!ctx->dev)
>>  		return ret;
>>  
>>  	path = dev_fwd_path(stack);
>>  	if (!path)
>>  		return -1;
>>  	path->type = DEV_PATH_ETHERNET;
>> -	path->dev = ctx.dev;
>> +	path->dev = ctx->dev;
>> +
>> +	return ret;
>> +}
>> +
>> +int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
>> +			 struct net_device_path_stack *stack)
>> +{
>> +	const struct net_device *last_dev, *br_dev;
>> +	struct net_device_path *path;
>> +	int ret = 0;
>> +
>> +	stack->num_paths = 0;
>> +
>> +	if (!ctx->dev || !netif_is_bridge_port(ctx->dev))
>> +		return -1;
>> +
>> +	br_dev = netdev_master_upper_dev_get_rcu((struct net_device *)ctx->dev);
>> +	if (!br_dev || !br_dev->netdev_ops->ndo_fill_forward_path)
>> +		return -1;
>> +
>> +	last_dev = ctx->dev;
>> +	path = dev_fwd_path(stack);
>> +	if (!path)
>> +		return -1;
>> +
>> +	memset(path, 0, sizeof(struct net_device_path));
>> +	ret = br_dev->netdev_ops->ndo_fill_forward_path(ctx, path);
>> +	if (ret < 0)
>> +		return -1;
>> +
>> +	if (!ctx->dev || WARN_ON_ONCE(last_dev == ctx->dev))
>> +		return -1;
>> +
>> +	if (!netif_is_bridge_master(ctx->dev))
> 
> hmm, do we expect ctx->dev to be a bridge master? Looking at
> br_fill_forward_path, it seems to be == fdb->dst->dev which
> should be the target port

It would indeed be very unlikely. It was a left-over from code I wrote,
thinking that here I could handle cascaded bridges (via vlan-device). I
dropped that, since conntrack does not follow this flow.

So would it be better to only make sure that ctx->dev is not a bridge
master?

	if (netif_is_bridge_master(ctx->dev))
		return -1;

	return dev_fill_forward_path_common(ctx, stack);

>> +		return dev_fill_forward_path_common(ctx, stack);
>> +
>> +	path = dev_fwd_path(stack);
>> +	if (!path)
>> +		return -1;
>> +	path->type = DEV_PATH_ETHERNET;
>> +	path->dev = ctx->dev;
>>  
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(dev_fill_bridge_path);
>> +
>> +int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
>> +			  struct net_device_path_stack *stack)
>> +{
>> +	struct net_device_path_ctx ctx = {
>> +		.dev	= dev,
>> +	};
>> +
>> +	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
>> +
>> +	stack->num_paths = 0;
>> +
>> +	return dev_fill_forward_path_common(&ctx, stack);
>> +}
>>  EXPORT_SYMBOL_GPL(dev_fill_forward_path);
>>  
>>  /**
> 
