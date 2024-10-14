Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5013FD83
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 06:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728887822; cv=none; b=T7lbsK3H4D6qRfQOGnO+4JDBuLXoJs6Wbpjg/DdUZsB+0Em7dMma+5IB6XSh8I+jQDabiLsphQ8eiAqtYFgKxdXPSKtAUAJp7UG56nl9cG6xg/IRC9Az/CpC9mqdNi214j04EanTstu866w90cXFPrpKWOOmz8jH507zWDiH/x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728887822; c=relaxed/simple;
	bh=HLEWN8F2imePOAbI3obQsi4luEyITeU3XTYrIFTHsg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ObDPKbVLEfLgr6Cr3mNZT+2FQqBGE2d5AtSfdnumB4mEHYqDsrF89li693ua02CfdBFqG4EONIsUmJ1nA+KZ93Do7iJ8HRixuFmgKSswhP4dNrDExp3xA24ztOpa4dQGENCijMEtkRffUDiVqWArrO07cqB0xXj1SHuJM4L3o8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=GysHt8y2; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="GysHt8y2"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c94dd7e1c0so3526119a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Oct 2024 23:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1728887819; x=1729492619; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n/x9sCHASM4Rf3zEKoLCrNEGmjLCGHbguwi/XAkNj6o=;
        b=GysHt8y2C60BmbYUzxvv5Vo3ZoT+hLp0zff03hmsbCr++tlGBjkyB/w6vHfSjCIbL7
         s6Z/ccoHnOxVqBoexj5rS5Wl1JXnnyrx0yLqz43BeR6FJt7MOTlF7LO4bQsFBIHcpPza
         Gmp3aAvXdC2iZuH3xcBKM9sloqwpYB6IuYaHAzEdDl+O05streuDPoWECn3U777l+Hig
         107f061ZHr4z9YbTx2x90jYgosI1Y6S8FxBpcEqzvL3Sko9V4EFunHPjU2/gNfLDZc3V
         gCYaCaw4TNRJ5NK4wEAhMoryZjRTUnbb/0cSM6xvNF4Ohsu2MTHOYhMAPhvi9M5KQN6a
         Ehww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728887819; x=1729492619;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n/x9sCHASM4Rf3zEKoLCrNEGmjLCGHbguwi/XAkNj6o=;
        b=a7o9rakOt9r3I/tufRunLjgILGnWhIAlvqzDD22kPXebQRUPxcVW15zM7gIQlsCO+w
         N5OuglYsImcIzOUxda7+xdYvZNjtScIOFwdef8uoP9h3uv12uXG5vWO34JzTncukXyrl
         r2kHggTOYBtQ/K93MYXMMNcGVLiZN/XHVsc7hNY3vg+QqdkWEyIQ21ivD3QUTG00E3ud
         AyCagBSBxCJAYsipi0HCx0DJw5o8CK//TCXasyBKbYzpgUaoCw+ZRNn9+hy7AbVV0WWE
         CnTUezAC6pne8rvn0fpeKB94OW5ZZzXPaAnup4yX8q5YYCshPkOmT0zjsPH3DFN73rzt
         OUYg==
X-Forwarded-Encrypted: i=1; AJvYcCUP6i2i+9+GwTXXMeXGe9AFo4rh9jRJ2X6od+FyeAK7ybEdt/o8owgAQZb6uor1bepqBBcxurJo3MCp2adkvIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdrMTblhtZdiNu9RX4SetVScZ3Y0Q0hcsXL7C4IeRk09nOzDxD
	88bbidxSahLhAWvjnxd6vfWB3IVFhMT+B2OLPlSR9GOer7SopBRI6pwZAg53zNI=
X-Google-Smtp-Source: AGHT+IHOmz4mXDYoNl9wKMY13pPq7T3XsGapXwSYgN3NOm+dxPajvUmbY2eZ6VnNrvCAhA5bOXjuSw==
X-Received: by 2002:a17:907:ea2:b0:a9a:33c:f6e1 with SMTP id a640c23a62f3a-a9a033cf8b4mr405516566b.5.1728887819334;
        Sun, 13 Oct 2024 23:36:59 -0700 (PDT)
Received: from [192.168.0.245] ([62.73.69.208])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99fcb57647sm206072266b.129.2024.10.13.23.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2024 23:36:58 -0700 (PDT)
Message-ID: <6c0154a9-b21d-4f1d-af74-19690dad68a6@blackwall.org>
Date: Mon, 14 Oct 2024 09:36:57 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 net-next 04/12] bridge:
 br_vlan_fill_forward_path_pvid: Add port to port
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
 <20241013185509.4430-5-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20241013185509.4430-5-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/10/2024 21:55, Eric Woudstra wrote:
> Lookup vlan group from bridge port, if it is passed as argument.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/bridge/br_private.h | 1 +
>  net/bridge/br_vlan.c    | 6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index d4bedc87b1d8..8da7798f9368 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1581,6 +1581,7 @@ bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
>  			     const struct net_bridge_vlan *range_end);
>  
>  void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
> +				    struct net_bridge_port *p,
>  				    struct net_device_path_ctx *ctx,
>  				    struct net_device_path *path);
>  int br_vlan_fill_forward_path_mode(struct net_bridge *br,

You haven't updated the !CONFIG_BRIDGE_VLAN_FILTERING version of this helper.

> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 9c2fffb827ab..1830d7d617cd 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -1441,6 +1441,7 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
>  EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
>  
>  void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
> +				    struct net_bridge_port *p,
>  				    struct net_device_path_ctx *ctx,
>  				    struct net_device_path *path)
>  {
> @@ -1453,7 +1454,10 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
>  	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
>  		return;
>  
> -	vg = br_vlan_group(br);
> +	if (p)
> +		vg = nbp_vlan_group(p);
> +	else
> +		vg = br_vlan_group(br);
>  
>  	if (idx >= 0 &&
>  	    ctx->vlan[idx].proto == br->vlan_proto) {

