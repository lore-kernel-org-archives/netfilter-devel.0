Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1744136B07E
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783850169; cv=none; b=MngUyxrcVwub24uOi0vtHvjPgm6TUWsq3Y22Nbm2ZUKCTUQ6xKcMlgfZWdTXjOV0ZOliaCmO2pygR09j/hhxklqjJ4NcbnRPQM6tJ9qK33Iaua2JHf1hcEdyII46w0rKd1rYsDnfZYAX5qLDy0qZjPF+WCqVkyqQeB4WWtjU0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783850169; c=relaxed/simple;
	bh=ENT5LG9FB4cixTTOJQNnoZiYXZ8KN/m8IdpmKN8KGOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=ldVHBQhF4e2Kjn2e0zifWjjtyTHhNI+KEiVGMU+Lwqr6hVFroNZnwrDkhCmsg1aNMQDXAja7JLt+KdBbpXYyRx18t/+nufEXo/cGkU/UeOqVJ565j+SCYniKzU1qaKcKvO5CpkfqJBjV3i5uuY9VJzK3F08UZWDpmo4c8kar5v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AMfwnPv6; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMfwnPv6"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-697564cb69eso4919515a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 02:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783850166; x=1784454966; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:cc:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9oePL6KVxBhy41D/iPJEuD2vI8ckk8u2UQmCBU4pLsQ=;
        b=AMfwnPv6SG8dFrlJXH6W46G05Mc6tMdwoT6HdY/h7RCktLTdPVgYzTm9KXo0kYhayC
         kkQTnxgzDAi/YYjMIvL4phZigebMRHWIz3QR361fCYoYaU4MhNorwgkPxIO7EHB9hAkB
         u9t/TDfrf+I7T1Po27ZaNNN2lghndTHDch5jnuycc4FAhwfQkKLlCxFbwh32spqE0jos
         Kim12V9e4wuCZhpjk08KcPyJ+oPfQif2/kpkWtj5Xes/JrS994awJExnrNf51JEFK90E
         sYZqMSX31b6Slz/Km3WQO/D6JYJ7ceJiDF+m4hYQPq/tDdfqU2MwYtEV6G0JDG7e7VKX
         nH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783850166; x=1784454966;
        h=content-transfer-encoding:content-type:in-reply-to:cc:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9oePL6KVxBhy41D/iPJEuD2vI8ckk8u2UQmCBU4pLsQ=;
        b=De2/SkEAUFOKCmaxN2x3hYFf+QWVwH5GLb9ADIvywE72iUU7RTvoEktFcg9jU5nECo
         mj5QQMz1w7fLJcEHjSxK1z8B+zj+1lL4YWdZqefTDuLEAOI2u5jRIPmPJC1248zgbhwU
         ttTRs9AUr5TFNNCgZby1TpWhLn/98Qcp14WsjZclMds4LUXNqOYhM25Dq4LC77vB5CfK
         qRCWzqX1P/rLX4o24IQmJLh337XwD1TI9CzNI9UCgQa4XEn30JnP9hlToUNjRmHpbfCA
         hJjg7slJoy8eTXYF7++XtFVCvgX2Iz66ART8cRQmVzvVKW6D/fuAGgOkU3MMniqfMCN+
         fypQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr6g/iAa8tCXj5jz+TepaPGE3OikCY6T+3ksxTUjTwndyD75cT1bOwWje5R0Da98LY5z81i/8bjIcxDW5BIaUU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDeoD7+d7d6EAZmPO3D/FPhbfde2v68mz2zyiRj0RZq1XPRByr
	BEI2Pg6SgLTkWJY+OwMwbROTYimaOfbpKBzmCr2rx3PC1lFnCj0fsmy7js1MxkuD
X-Gm-Gg: AfdE7cnQ8vLFNHZ9BWEPF+douuQ8fZDi7ZODI0n/dUsNHgz0wvlWPq1e0yL0twyfWSh
	FtTApYrfWRIC9xdFuixxy5vmxYJF4pvM6DucrJATLl4TpLGMN9dA2Os3i8lIkoimN4Y4vWnSr8T
	/zD4SxwP4dyOcPYxpZm+lriHl/pFCoXn25ZA4uKe6Pvq9yG5pfvrqfR/496+lIcVTQR3Jt5Sbd4
	XLi+1uwfF0nKRv6SIN3eGmiSUph/q0/GNJlSxGNv77yKmza1+gMkFzwUUPLbjO7ShlmpJNqq8Bx
	AOIe6TQy8xA4Boo0W+XPI5XgjgFqQW40xht7URm4KCP9LE21gzeZn/2u+Yx/uToltYeRjm33DRl
	/15Pw1+pnS5unLVqxy4Ae5U/MasChWkr4zLUUzKf6otqxxegpocx/UBmfqzcJerBliStkW9/Lcb
	xDfM1Dt666DtCeiiY0GF6M2nEh3Mmn85anq2/V6ZyxRGqGih3jK4eObkmtauaUFbXxG5XLQ0KVT
	wVF2rMDB/0mK8bviAhsWrato0ZBhX+0uFOcasH3r9a/1EWRwI9IrXlYW212XrJYWnMxSITwqF22
	RosetHw1+n4BCMxfLdX1V7g=
X-Received: by 2002:a17:907:c084:b0:c15:c658:dc0d with SMTP id a640c23a62f3a-c161f35366dmr261224566b.39.1783850166084;
        Sun, 12 Jul 2026 02:56:06 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15ae0bb618sm851852366b.20.2026.07.12.02.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 02:56:05 -0700 (PDT)
Message-ID: <79beda2e-e7b7-4488-9aef-bfa21da18ac7@gmail.com>
Date: Sun, 12 Jul 2026 11:56:04 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next,v1 1/4] bridge: Add filling forward path from port
 to port
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
References: <20260708093250.1187068-1-pablo@netfilter.org>
Content-Language: en-US
From: Eric Woudstra <ericwouds@gmail.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>, Florian Westphal <fw@strlen.de>
In-Reply-To: <20260708093250.1187068-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/8/26 11:32 AM, Pablo Neira Ayuso wrote:
> From: Eric Woudstra <ericwouds@gmail.com>
> 
> If a port is passed as argument instead of the master, then:
> 
> At br_fill_forward_path(): find the master and use it to fill the
> forward path.
> 
> At br_vlan_fill_forward_path_pvid(): lookup vlan group from port
> instead.
> 
> Changed call to br_vlan_group() into br_vlan_group_rcu() while at it.
> 
> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v1: I took this existing patch for the bridge vlan filtering, but
>     bridge vlan filtering is untested at this stage at least for me.
> 
>  net/bridge/br_device.c  | 19 ++++++++++++++-----
>  net/bridge/br_private.h |  2 ++
>  net/bridge/br_vlan.c    |  6 +++++-
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index e7f343ab22d3..89f4525a7279 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -385,16 +385,25 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
>  static int br_fill_forward_path(struct net_device_path_ctx *ctx,
>  				struct net_device_path *path)
>  {
> +	struct net_bridge_port *src, *dst;
>  	struct net_bridge_fdb_entry *f;
> -	struct net_bridge_port *dst;
>  	struct net_bridge *br;
>  
> -	if (netif_is_bridge_port(ctx->dev))
> -		return -1;
> +	if (netif_is_bridge_port(ctx->dev)) {
> +		struct net_device *br_dev;
> +
> +		br_dev = netdev_master_upper_dev_get_rcu((struct net_device *)ctx->dev);
> +		if (!br_dev)
> +			return -1;
>  
> -	br = netdev_priv(ctx->dev);
> +		src = br_port_get_rcu(ctx->dev);
> +		br = netdev_priv(br_dev);
> +	} else {

So as per Nikolay's comment on another thread, Can add here:

		if (!netif_is_bridge_master(ctx->dev))
			return -1;

So that it can continue normally if ctx->dev is a bridge master.

> +		src = NULL;
> +		br = netdev_priv(ctx->dev);
> +	}
>  
> -	br_vlan_fill_forward_path_pvid(br, ctx, path);
> +	br_vlan_fill_forward_path_pvid(br, src, ctx, path);
>  
>  	f = br_fdb_find_rcu(br, ctx->daddr, path->bridge.vlan_id);
>  	if (!f)
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index d55ea9516e3e..00f5b72ff42d 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1630,6 +1630,7 @@ bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
>  			     const struct net_bridge_vlan *range_end);
>  
>  void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
> +				    struct net_bridge_port *p,
>  				    struct net_device_path_ctx *ctx,
>  				    struct net_device_path *path);
>  int br_vlan_fill_forward_path_mode(struct net_bridge *br,
> @@ -1799,6 +1800,7 @@ static inline int nbp_get_num_vlan_infos(struct net_bridge_port *p,
>  }
>  
>  static inline void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
> +						  struct net_bridge_port *p,
>  						  struct net_device_path_ctx *ctx,
>  						  struct net_device_path *path)
>  {
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 5560afcaaca3..71531499bc73 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -1450,6 +1450,7 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
>  EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
>  
>  void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
> +				    struct net_bridge_port *p,
>  				    struct net_device_path_ctx *ctx,
>  				    struct net_device_path *path)
>  {
> @@ -1462,7 +1463,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
>  	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
>  		return;
>  
> -	vg = br_vlan_group_rcu(br);
> +	if (p)
> +		vg = nbp_vlan_group_rcu(p);
> +	else
> +		vg = br_vlan_group_rcu(br);
>  
>  	if (idx >= 0 &&
>  	    ctx->vlan[idx].proto == br->vlan_proto) {

