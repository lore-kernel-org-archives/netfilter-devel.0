Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4C020DD63;
	Fri, 11 Apr 2025 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744385202; cv=none; b=IDio1fD0so6Cujbz+zbO76QnGz3AOvHQSq/JU+1JsczbVHmaeK8RnRvgVzNsrymjuxxeYUSm+QLf9qJ2bxh716Uf9VvsKe7kRDtKQ+VIL2rYkFyrzjJ0N1mYIsRBL1q50/anxX2m1hYX3d179yRdro0qN3Cs0dwsRWzF2hQ/C+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744385202; c=relaxed/simple;
	bh=2sL5WhAgHgwK/PFrD/Vx5SQk1yPq+Ev+0dD6iJuE/bc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aHBn9r62dF3Nj+IdyfjxPxWWyC515eAvuF+uWdS2fikN0EZU25yCTlPV41I4POBaIsITgSGzy95HL5qk9LME5F4V0rFPhTO/z4AYpQ5D4PSS+xlhSYfwfx3mDYBdMe45e3uQM+6OUXu4vLzWlieyhTfUdD/NaZkZBzfB6OpQ9qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OqIQbwnF; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OqIQbwnF"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac3fcf5ab0dso371335566b.3;
        Fri, 11 Apr 2025 08:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744385199; x=1744989999; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IZKqzrx5hRCgai3AuCLiU+d5ywcPsQ7sfpurxCMMBt4=;
        b=OqIQbwnFer04k0vKc3kbEpd5XZPfpBzBln8OCGjbcj/RcvC7nGULmh8xYbhLmSZsjh
         ws9/KaDXB9lYnrd0YKudzNBJCSZZpMWDXIvsLNWcFZe3vPWDk+vwD5oE861vl+ZaoQhm
         XHnT8gs9FLL0hQFQBM+9rw+ZgIKb+9EYOa3LWfLnKUsDG+WpCEzJYkROuYIl5eLqpAxQ
         BRX8CZZBdpJ1P1K8AtvPs69y467SEx2++zl3rbly/h8kBWpVnBmG9LdOY3K1t3KvMkKo
         IM5qRQrBBmu4owgkHGT27InJscK+EBFCH2beYEFo3Uu0t36vWKiHUBLBwzR0N+jiVLd1
         u6uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744385199; x=1744989999;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IZKqzrx5hRCgai3AuCLiU+d5ywcPsQ7sfpurxCMMBt4=;
        b=oU5G7UvBM/67t7FjaCCTm9SvXpD5TyYBBPdDltIYfpe7fbYRCcJvl6YEJ5dgxb3bxI
         lUWP7a7Zjr0lOFsOWWOY7QA5HK4H5O+2QFmi6VALJe1L0CD/tUF46JPIqmC3XAf+vw9O
         8LnzRIl9BZV31Jh6dRFcsH+yOHhzGg91WmJ2/EUij+o8SS6d71BACADdo1B5jzSP4tWe
         BhY0EBhzsDKmeEKjyCmpJdz+LU4b1gBxuAqMaP/y7r3JxPsZ7A+voXvT2kUKKofT74A1
         +HBJXgcb9bK7FcK1PTb9Dn11MTe6FtTB9A6aOL/JnboPIQNQdWfTvK+2DdZS/nL6s6E4
         94qg==
X-Forwarded-Encrypted: i=1; AJvYcCUjVUVsRALOxf7/gBMjxCKVpEch8fqbJR+g9OH18rEZ2gbWxpYLxFPAyeBfBmAxfitRgnMeYDN/e+Z8bhyCDBey@vger.kernel.org, AJvYcCXKvIoXRwO9bbtnYWDG/8t6iwFzsTt5Dte40dC9QyMYUERV1W5ib13H7aMp3yUaCukko8l7LLw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTSFnOF+zqwMg+4ivZyt0Y3UALozfbdjZouoSIrCe6OlMuoVyU
	4DPO+iLvYsLA4rzVXzjHUZoaWZKX0mgaj7FnhrKPVVB44PzfTQNX
X-Gm-Gg: ASbGnctp/O8jTDEpoO6MFt1Fs77xkYalM0fYHFDnB9kt8G15uVChD0aZbUe+mQeJOQW
	F3tP7u9YQwVA/982BuIJ5c3JFWmO73d+mMDvzR8+bU5xYnwfFEYcTGIgi80XNEp/gIpd9sEr7VB
	jttG3JRxHv3MrfH2WRs7whqDBozHF/YHsBHq7nEt6WqgNKjVYAFu4BFwZJccNnK7D5LPnWyxHVs
	M2qIe+JJblQYHWd638MY232NR9lJ33+b6RYXpbm3bv+SAfSxIFOxE9TEENkNUXiLNwjHAbJw0Vj
	9ZIm40MvQ9Z+9Uc1TYfnEpNnemdROEcUkVAULc4dKw9fKbzwKYV0sThD1nEqE2lPw0mNiGYH7yV
	4KA3ZufuiNQ==
X-Google-Smtp-Source: AGHT+IGgz/Pec6w5rYpCzRkxb/yZ/cHyCP0h9jjZ87Wbc/1SNmOO15GdiTD6j5FYBstIyICYu9EGJA==
X-Received: by 2002:a17:907:7249:b0:ac4:751:5f16 with SMTP id a640c23a62f3a-acad34d93bbmr236633366b.30.1744385199121;
        Fri, 11 Apr 2025 08:26:39 -0700 (PDT)
Received: from [192.168.1.149] (84-106-48-54.cable.dynamic.v4.ziggo.nl. [84.106.48.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acac8a494f5sm202450866b.85.2025.04.11.08.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Apr 2025 08:26:38 -0700 (PDT)
Message-ID: <f6fa54fc-223f-426c-be83-7f7c2d366077@gmail.com>
Date: Fri, 11 Apr 2025 17:24:24 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 nf-next 6/6] netfilter: nft_flow_offload: Add
 bridgeflow to nft_flow_offload_eval()
To: Simon Horman <horms@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Ahmed Zaki <ahmed.zaki@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, bridge@lists.linux.dev
References: <20250408142802.96101-1-ericwouds@gmail.com>
 <20250408142802.96101-7-ericwouds@gmail.com>
 <20250411105751.GA1156507@horms.kernel.org>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20250411105751.GA1156507@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/11/25 12:57 PM, Simon Horman wrote:
> On Tue, Apr 08, 2025 at 04:28:02PM +0200, Eric Woudstra wrote:
>> Edit nft_flow_offload_eval() to make it possible to handle a flowtable of
>> the nft bridge family.
>>
>> Use nft_flow_offload_bridge_init() to fill the flow tuples. It uses
>> nft_dev_fill_bridge_path() in each direction.
>>
>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
>> ---
>>  net/netfilter/nft_flow_offload.c | 148 +++++++++++++++++++++++++++++--
>>  1 file changed, 143 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> 
> ...
> 
>> +static int nft_dev_fill_bridge_path(struct flow_offload *flow,
>> +				    struct nft_flowtable *ft,
>> +				    enum ip_conntrack_dir dir,
>> +				    const struct net_device *src_dev,
>> +				    const struct net_device *dst_dev,
>> +				    unsigned char *src_ha,
>> +				    unsigned char *dst_ha)
>> +{
>> +	struct flow_offload_tuple_rhash *th = flow->tuplehash;
>> +	struct net_device_path_ctx ctx = {};
>> +	struct net_device_path_stack stack;
>> +	struct nft_forward_info info = {};
>> +	int i, j = 0;
>> +
>> +	for (i = th[dir].tuple.encap_num - 1; i >= 0 ; i--) {
>> +		if (info.num_encaps >= NF_FLOW_TABLE_ENCAP_MAX)
>> +			return -1;
>> +
>> +		if (th[dir].tuple.in_vlan_ingress & BIT(i))
>> +			continue;
>> +
>> +		info.encap[info.num_encaps].id = th[dir].tuple.encap[i].id;
>> +		info.encap[info.num_encaps].proto = th[dir].tuple.encap[i].proto;
>> +		info.num_encaps++;
>> +
>> +		if (th[dir].tuple.encap[i].proto == htons(ETH_P_PPP_SES))
>> +			continue;
>> +
>> +		if (ctx.num_vlans >= NET_DEVICE_PATH_VLAN_MAX)
>> +			return -1;
>> +		ctx.vlan[ctx.num_vlans].id = th[dir].tuple.encap[i].id;
>> +		ctx.vlan[ctx.num_vlans].proto = th[dir].tuple.encap[i].proto;
>> +		ctx.num_vlans++;
>> +	}
>> +	ctx.dev = src_dev;
>> +	ether_addr_copy(ctx.daddr, dst_ha);
>> +
>> +	if (dev_fill_bridge_path(&ctx, &stack) < 0)
>> +		return -1;
>> +
>> +	nft_dev_path_info(&stack, &info, dst_ha, &ft->data);
>> +
>> +	if (!info.indev || info.indev != dst_dev)
>> +		return -1;
>> +
>> +	th[!dir].tuple.iifidx = info.indev->ifindex;
>> +	for (i = info.num_encaps - 1; i >= 0; i--) {
>> +		th[!dir].tuple.encap[j].id = info.encap[i].id;
>> +		th[!dir].tuple.encap[j].proto = info.encap[i].proto;
>> +		if (info.ingress_vlans & BIT(i))
>> +			th[!dir].tuple.in_vlan_ingress |= BIT(j);
>> +		j++;
>> +	}
>> +	th[!dir].tuple.encap_num = info.num_encaps;
>> +
>> +	th[dir].tuple.mtu = dst_dev->mtu;
>> +	ether_addr_copy(th[dir].tuple.out.h_source, src_ha);
>> +	ether_addr_copy(th[dir].tuple.out.h_dest, dst_ha);
>> +	th[dir].tuple.out.ifidx = info.outdev->ifindex;
>> +	th[dir].tuple.out.hw_ifidx = info.hw_outdev->ifindex;
>> +	th[dir].tuple.out.bridge_vid = info.bridge_vid;
> 
> Hi Eric,
> 
> I guess I am doing something daft.
> But with this patchset applied on top of nf-next I see
> the following with allmodconfig builds on x86_64.:
> 
>   CC [M]  net/netfilter/nft_flow_offload.o
> net/netfilter/nft_flow_offload.c: In function 'nft_dev_fill_bridge_path':
> net/netfilter/nft_flow_offload.c:248:26: error: 'struct <anonymous>' has no member named 'bridge_vid'
>   248 |         th[dir].tuple.out.bridge_vid = info.bridge_vid;
>       |                          ^
> net/netfilter/nft_flow_offload.c:248:44: error: 'struct nft_forward_info' has no member named 'bridge_vid'
>   248 |         th[dir].tuple.out.bridge_vid = info.bridge_vid;
>       |                                            ^
> 
>> +	th[dir].tuple.xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
>> +
>> +	return 0;
>> +}
> 
> ...

Hi Simon,

This is from the patch-set:

[PATCH v2 nf-next 0/3] flow offload teardown when layer 2 roaming

My guess is that it could be accepted before this patch-set.

They do not need each other, but 1 needs to be applied before the other.

Regards,

Eric
