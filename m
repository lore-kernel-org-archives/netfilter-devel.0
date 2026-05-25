Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5A32D73A0
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779726795; cv=none; b=XhwtLoZvIbhM4/foNILiYVc9muj5FxZh2L+I9cTtu8m91A1x8TxjWD/gO0/RGkjHc9UOHiqs2oUyK+xSrvpjHKB7rYig4e/vfwXtnHw+O05xI7RpgPB2JzELlN+BOjAwKpPp3mw1rrSkU8mqfCKlVi0DvmbNfJNWVDPIPb8z3wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779726795; c=relaxed/simple;
	bh=UpGyyfESJRUoBXq6ccvFWX/oFP8M9fGs3HanZnsY9fM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NNv8BYiesFCbWfZNlG6mFeJDb6BG+iGCaT4X0fZU673Fu5Q6WoRk48r8WN6xy6qpAUuiP5ZEpHl+CvA+dBFtjaPV4yX4PPIWgPWmAbeb315s6/TabOsYyjapGRpv1LV7F5PaaHUm4nMrm321Q4jsV9Mtnwfvj8xUaCxP0g+OkFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dh0tI9yZ; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dh0tI9yZ"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-365d8e43759so4945057a91.0
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 09:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779726793; x=1780331593; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kBUf0fucX65WDE0lfr4qPTUB638LzijiF1+B/2S3P90=;
        b=dh0tI9yZ26Jds6qNV1hEQ/U1CiYwA0CcQUsHG1ocAmEekMhqXIJu5kZj6VB8FHbeSE
         14cF1hG0nCKgyjx9BzMj4tapxefheEK01ig1e/yxKs8mmAvNFyY35R0xOBLaXAellROZ
         F+XLns6ficJpGaIpAKbgFVVjaWafTcpvoPbviMyLRqEdMGfTKD1d483dAkS8L9YtcrL+
         4yhOJyeyzv4VGtuYeg7CGCdPz+tYLVJrS7GhEUjsptCyL2isAp3JtWdoYdSeeijssYNm
         3fzUz8ulMbONSlFdJLGyzSzbs1YHPhzVHqWmuX6jYzqxxEm22hrP5lPNcWq7giw/cOWe
         bk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779726793; x=1780331593;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kBUf0fucX65WDE0lfr4qPTUB638LzijiF1+B/2S3P90=;
        b=n7JHTMAQTOFWXRqBlIIg1XOjG8Of1GpsvSUcDxnXpsvhBcGDBKBXCmfdDVD0nK8SKP
         ibcT3wlEpzibbQqmigacC1JU5ESBasK+16uEFUSJB5hZFzctqgEs6qtvRLYfzD/aHtAc
         N2DX0ixodfTf3/78oNvYO4bffe0Zs5ZfZcD3THmCEofNLzEb+TFj1TkRTKrEIlEgSRNm
         vsvGMIac+VDAAGMj07XgydAqc0PsudRQaPBBnVHV/YaLdT3YgaoQoOG9gme3c1bHl9Oy
         xp12N0uIk2Qifdvg6T3174Gqk0hjJq4UMjZWlzoEaNzvkgC9tkuc6z0McoxJGd9Bgbmd
         bndA==
X-Forwarded-Encrypted: i=1; AFNElJ9rNXCgAvmMSZeK0TshOGbHsJb9gtmqoJcFodCOa54otMCvoh+/4jj/+vi0tJYWASVhPFU7h+DK70OwZSBZUJA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN/4fHctLSF7N2g4vWQdPsqyGeQKRViQqAwJb6HO9Ev5N1Oo+7
	gW5Dc+5sORj+y2wFn9UxS053JFZijzkzr2X+YdHRHK412+/E5gFunugf
X-Gm-Gg: Acq92OF55dLPT1Qu+VIfwxUwUk8mqRpYukGEkKaRw1hB1B7ezU9yrbzQK64OA+89Tc3
	s5lS+Ybqsh7HwB2CjNnyqFixb9iFcfpX5XB8JOQ7KSIwn4SNUcrU+A64SsOmRTmB5DdPmiEJ33Y
	uyw5EzA/qbUUFqnxNSvTpsRWaWVOHpDgeWixdpRtqwPDqsIPEni3e8S1g6trm373CemrQMqUxPb
	62BbNaHDnYxNhYu+EWa6+4Lc5uE4m0W85QNXLS16v6rI+w2HbNwVyosAc77886vOXNe552ITxh1
	RUjyzd6LGjSCUD3Am77whZY8Q0BW8uUkxNFKKFK6Xp9jlaxvXdwi2plrAXq+xFodwCqI0qR4w8s
	Bfhv/w/HjYvsNed+5w6v25p0PAb4MtTR1fKg9yXWRLIzNGhPVGidn57w5jE7Zuse8qkWz9gMmOn
	ne+KneYt+olTGCFpDhXjNj/G9JHtqj0Q==
X-Received: by 2002:a17:90b:560b:b0:35b:d795:cf5d with SMTP id 98e67ed59e1d1-36a6bb5b91dmr11101224a91.5.1779726792876;
        Mon, 25 May 2026 09:33:12 -0700 (PDT)
Received: from [192.168.89.2] ([119.214.48.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36af17d8595sm940757a91.6.2026.05.25.09.33.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 09:33:12 -0700 (PDT)
Message-ID: <da748e80-450f-42bd-a3bd-fde52c1c7d90@gmail.com>
Date: Tue, 26 May 2026 01:33:09 +0900
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: flowtable: resolve LAG slave for direct HW
 offload
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, coreteam@netfilter.org,
 netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260525162417.366556-1-hurryman2212@gmail.com>
Content-Language: en-US
From: Jihong Min <hurryman2212@gmail.com>
In-Reply-To: <20260525162417.366556-1-hurryman2212@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Sorry for the noise.

While preparing the git-send-email command, I noticed that the subject
prefix was not set correctly. This should have been sent with the
nf-next prefix.

I also noticed that the Assisted-by trailer was missing. Most of the
patch was written by me, but I did get help from GPT-5.5 for some of
the RCU and lifetime details, so the patch should have included:

Assisted-by: Codex:gpt-5.5

Also, this change was tested on a Lumen W1700K2 with a Linux 6.18
OpenWrt-based image, where it enabled flow offload in a bonding setup.
I have also applied the same diff on top of nf-next and completed a
compile test there. I checked that the relevant infrastructure for
bonding flow offload support is identical between the tested tree and
nf-next.

I will be more careful in the next submission and will correct this
there.

Best regards,
Jihong

On 5/26/26 01:24, Jihong Min wrote:
> FLOW_OFFLOAD_XMIT_DIRECT path discovery can stop at a LAG master because
> the real egress port is selected later through ndo_get_xmit_slave().
> Hardware flow offload drivers that program per-port redirects need the
> selected lower device, while software forwarding must still transmit
> through the LAG master.
> 
> Keep the route tuple software egress ifindex on the LAG master and carry
> a separate hardware redirect ifindex. When the direct egress device is a
> LAG master, resolve the selected slave with netdev_get_xmit_slave(),
> verify that it belongs to the flowtable, and store it as the hardware
> redirect device.
> 
> Signed-off-by: Jihong Min <hurryman2212@gmail.com>
> ---
>  include/net/netfilter/nf_flow_table.h |  1 +
>  net/netfilter/nf_flow_table_core.c    |  1 +
>  net/netfilter/nf_flow_table_offload.c |  2 +-
>  net/netfilter/nf_flow_table_path.c    | 34 ++++++++++++++++++++++++++-
>  4 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 7b23b245a5a8..ada9db7e5c38 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -163,6 +163,7 @@ struct flow_offload_tuple {
>  		};
>  		struct {
>  			u32		ifidx;
> +			u32		hw_ifidx;
>  			u8		h_source[ETH_ALEN];
>  			u8		h_dest[ETH_ALEN];
>  		} out;
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 785d8c244a77..bc329420f882 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -132,6 +132,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
>  		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
>  		       ETH_ALEN);
>  		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
> +		flow_tuple->out.hw_ifidx = route->tuple[dir].out.hw_ifindex;
>  		dst_release(dst);
>  		break;
>  	case FLOW_OFFLOAD_XMIT_XFRM:
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 002ec15d988b..7c46baa1546d 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -596,7 +596,7 @@ static int flow_offload_redirect(struct net *net,
>  	switch (this_tuple->xmit_type) {
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
>  		this_tuple = &flow->tuplehash[dir].tuple;
> -		ifindex = this_tuple->out.ifidx;
> +		ifindex = this_tuple->out.hw_ifidx;
>  		break;
>  	case FLOW_OFFLOAD_XMIT_NEIGH:
>  		other_tuple = &flow->tuplehash[!dir].tuple;
> diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
> index 9e88ea6a2eef..10f38ca27a6f 100644
> --- a/net/netfilter/nf_flow_table_path.c
> +++ b/net/netfilter/nf_flow_table_path.c
> @@ -5,6 +5,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/netlink.h>
>  #include <linux/netfilter.h>
> +#include <linux/netdevice.h>
>  #include <linux/spinlock.h>
>  #include <linux/netfilter/nf_conntrack_common.h>
>  #include <linux/netfilter/nf_tables.h>
> @@ -76,6 +77,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
>  struct nft_forward_info {
>  	const struct net_device *indev;
>  	const struct net_device *outdev;
> +	const struct net_device *hw_outdev;
>  	struct id {
>  		__u16	id;
>  		__be16	proto;
> @@ -179,6 +181,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>  		}
>  	}
>  	info->outdev = info->indev;
> +	info->hw_outdev = info->indev;
>  
>  	if (nf_flowtable_hw_offload(flowtable) &&
>  	    nft_is_valid_ether_device(info->indev))
> @@ -250,6 +253,7 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
>  	struct net_device_path_stack stack;
>  	struct nft_forward_info info = {};
>  	unsigned char ha[ETH_ALEN];
> +	struct net_device *lag_slave = NULL;
>  	int i;
>  
>  	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
> @@ -258,9 +262,34 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
>  	if (info.outdev)
>  		route->tuple[dir].out.ifindex = info.outdev->ifindex;
>  
> -	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
> +	if (!info.indev)
>  		return;
>  
> +	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
> +	    netif_is_lag_master(info.hw_outdev)) {
> +		rcu_read_lock();
> +		lag_slave = netdev_get_xmit_slave((struct net_device *)info.hw_outdev,
> +						  pkt->skb, false);
> +		if (lag_slave)
> +			dev_hold(lag_slave);
> +		rcu_read_unlock();
> +
> +		if (!lag_slave)
> +			return;
> +
> +		if (!nft_is_valid_ether_device(lag_slave)) {
> +			dev_put(lag_slave);
> +			return;
> +		}
> +
> +		info.hw_outdev = lag_slave;
> +	}
> +
> +	if (!nft_flowtable_find_dev(info.hw_outdev, ft)) {
> +		dev_put(lag_slave);
> +		return;
> +	}
> +
>  	route->tuple[!dir].in.ifindex = info.indev->ifindex;
>  	for (i = 0; i < info.num_encaps; i++) {
>  		route->tuple[!dir].in.encap[i].id = info.encap[i].id;
> @@ -281,9 +310,12 @@ static void nft_dev_forward_path(const struct nft_pktinfo *pkt,
>  	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
>  		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
>  		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
> +		route->tuple[dir].out.hw_ifindex = info.hw_outdev->ifindex;
>  		route->tuple[dir].xmit_type = info.xmit_type;
>  	}
>  	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
> +
> +	dev_put(lag_slave);
>  }
>  
>  int nft_flow_route(const struct nft_pktinfo *pkt, const struct nf_conn *ct,

