Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BC3136353
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 06:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728887417; cv=none; b=uUBYy7iAbCjjtUHk7RJEo/NjZ+kZ/2BcLJsJdm86mMTc8I2bzUoZufb+f2wi4s6QTgGvM5pATbxRlWlrP+6x4wLspotu0CJuOPfqXpDcF0Pyr6tzO0NaQL0hkZFTNHfLGNQkJgbIVnbt33GxRaVgxW66fjK8G5WnpQdTG5Y3bsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728887417; c=relaxed/simple;
	bh=FoZ1WDbxnUEwmUw8PHXl/qZbVhSzDOxKuZzVtGA2gb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=brA5nWoZDbcjf5/kTkc3H7vU84Qq1iLoZK93gARKD9I8zIhBnDEuFAXkELlB7+d8oItOvjV2KikdDVSU/LwgCswfyjBu7mDOx9075jqS/pXH5bfu2AcPAVOBC5T6m4QDQYoA/Jon93hrv1yFIi6mITPq0hYkpLlKFsxcDqf6jec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=J7Og9be8; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="J7Og9be8"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c96b2a11e7so1746948a12.3
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Oct 2024 23:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1728887414; x=1729492214; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MJyb8Bc81miKQbLjUTUq/NpdzgBcv4rRrfPYMdCJ8WE=;
        b=J7Og9be88aKrG+ipSsKp1mjbCXV61v/ViSyovyt1kLLk8OPcK7FNYPHTbRUAZyjgQe
         A7pgJ91159XZ63oSuV8AmmVzzWFD4wKri9inZdtLRbOYBFTSjsGaUMsJjimYLVTqfqEc
         eyuCJcARO6hxMc79/Cqv9dC9dZ2258LD+9SLN+u2XwyMASjw8CN0dINyWQVNpdN0Yegt
         1XF1C4oiASdRcMcCkCZjGATxAIylfyafWrA1gt0T0gIfUDL8uP2Oe6RmQt6GXi60F1kq
         8OQYfpS+8gIBWfSR/f3qZjUZw9edi3SxGICHNRJz92nDxMEL2JLgwTHSOivncjsOxSFg
         MlHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728887414; x=1729492214;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MJyb8Bc81miKQbLjUTUq/NpdzgBcv4rRrfPYMdCJ8WE=;
        b=tZSgPOAtxZgURZAIqQR88Yw/GA1N6ecRq1hi06HMgENECSluJNoS/bd4F9zWcIAKGb
         IZFsoo+TEGwZmyd4/mdj428DXXMmVypZUkub1xAdT+ETtgr5NuLueABQYoeguEE+FbUn
         L4VFAo0B3/zlRV+xYL6kSeevMuLamz2rlwnUUwl7KAn/0/vtqTxh/e908l0+VrseBmAr
         d0VHwBSUTP1Ramk8KkApAigzEbqElBxyE+7+c/7gt16r2YLu22rAdJseWw7zNixu1GzP
         b6cLD6wQskRm8T8YD0n/THsovf1YrMiR9PXd91xRiDSBlxVFLpyJqHkpugBMO6tDgJ75
         vPjA==
X-Forwarded-Encrypted: i=1; AJvYcCUC9yQu+2j+fsK2B0lqLpTH7C3O6n6mj8Pvg+8XVIXpCJPhkfHPE1WLiqg1xm6mx75GtHEcPqY845GeME4nXaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyhYaWT8kIY8/gj8pdgamMwgvi6yOmFxUb+ui8BZ9FENWrkAjM
	2iFaW/zJKdfEGy/aypeQFDwucmjCz/DZiW+pgBQmWdHD9ihM0n4pkXgu9tnWBc8=
X-Google-Smtp-Source: AGHT+IFIRcBU0W5yzI+xWDzvWEmzUxkcMqg4gm1s6fiPZ1qxh06hlXKcpE9+hLiy8wzVE/ywprsQkw==
X-Received: by 2002:a05:6402:4409:b0:5c9:85ce:d9e3 with SMTP id 4fb4d7f45d1cf-5c985cedd76mr14840a12.16.1728887414349;
        Sun, 13 Oct 2024 23:30:14 -0700 (PDT)
Received: from [192.168.0.245] ([62.73.69.208])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c93711bdbasm4517929a12.38.2024.10.13.23.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2024 23:30:13 -0700 (PDT)
Message-ID: <524ff98e-a7d2-4228-b1cf-4465b6ac1ce8@blackwall.org>
Date: Mon, 14 Oct 2024 09:30:12 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 05/12] bridge: br_fill_forward_path add
 port to port
To: Eric Woudstra <ericwouds@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
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
 <20241013185509.4430-6-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20241013185509.4430-6-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/10/2024 21:55, Eric Woudstra wrote:
> If handed a bridge port, use the bridge master to fill the forward path.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/bridge/br_device.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 26b79feb385d..e242e091b4a6 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -384,15 +384,25 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
>  				struct net_device_path *path)
>  {
>  	struct net_bridge_fdb_entry *f;
> -	struct net_bridge_port *dst;
> +	struct net_bridge_port *src, *dst;
> +	struct net_device *br_dev;

reverse xmas tree order

>  	struct net_bridge *br;
>  
> -	if (netif_is_bridge_port(ctx->dev))
> -		return -1;
> +	if (netif_is_bridge_port(ctx->dev)) {
> +		br_dev = netdev_master_upper_dev_get_rcu((struct net_device *)ctx->dev);
> +		if (!br_dev)
> +			return -1;
> +
> +		br = netdev_priv(br_dev);
>  
> -	br = netdev_priv(ctx->dev);
> +		src = br_port_get_rcu(ctx->dev);
>  
> -	br_vlan_fill_forward_path_pvid(br, ctx, path);
> +		br_vlan_fill_forward_path_pvid(br, src, ctx, path);
> +	} else {
> +		br = netdev_priv(ctx->dev);
> +
> +		br_vlan_fill_forward_path_pvid(br, NULL, ctx, path);
> +	}
>  
>  	f = br_fdb_find_rcu(br, ctx->daddr, path->bridge.vlan_id);
>  	if (!f)

