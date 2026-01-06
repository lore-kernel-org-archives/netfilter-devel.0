Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DF52D7DCE
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Jan 2026 19:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767729313; cv=none; b=aPIj9Uhltj03gY7isYxXGRyKMxJsgICtAIjgTMsSIST5yhyYpSk8zgwBMU9s1BmWDm2DQC2IMc66KLHu8MYdCtbIfZDUHat8LhhpjLCkZY0cnZ2F+939BVkYGeluIM0sJFLrFc1EXCRFX7rQuiMKQ16q+K2W5j7XnJfdeYuUXe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767729313; c=relaxed/simple;
	bh=ezRQarOjjBM21zauRZItcnGzBQWgx/j7g7YBZfAhrFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oLa9yi12fgOSeAT2jIflJI5Xq1rtzNDADU/wuaGdS7GOoNi0w6dDESNi4XnoKhka/TCFr2qKHDkSJihU0cn4xSgSaeVCDHqG5Fxm2RPEfUFyOSj+kJecbY70dYMD7iWQc45L7iuZ73HfjWWGTba7VJAwutlXQ0pJA+wpOS4NwE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kpx2AwBw; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpx2AwBw"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64b8123c333so2086309a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Jan 2026 11:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767729310; x=1768334110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BmSo9DVOGxS+EqfPBwMvHqn9WrIYsrAaibtCJtd/X8c=;
        b=kpx2AwBwqmt402iWht+jAPHIOEBlGQ/Go+EXWvSs5dk42obdR8Hztd2zlKIrJzKQx5
         fp5gWD5xjViZoTX+gg3Zqj9JUMOZg/v4g7n7X4Nbq8n0c0A70ohxm9GuAXmeftI3Hsft
         zOLPcVAHN0D38x++HVtF2tFj1lWVDKYml+VJycdA7ZM3VLaR9csZbqaqJqoHvP9wu59Y
         Wp35a0KQtmVR9XPTSJsVY6oHGt12QGk8fsQeC7VbXTc+12RQXAiNNzbZdQcKNIZwWstS
         sb/99L0dvplQw4+PFleU3/saPlHf8cU5HpeAmwuxFm67n9LmgqaB45IhJgVhqtoO0gKD
         iJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767729310; x=1768334110;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BmSo9DVOGxS+EqfPBwMvHqn9WrIYsrAaibtCJtd/X8c=;
        b=unGP0fwGGMFEDWsQxLN+53IOHLAWefQrqDxi5/0RLZJBNtWsMoZ0hOVn61uXcTjsMn
         +3h4KcZSJbq+q/BnlUJ/fuW3DLTXkbAcfGTtswSlgm92qOMkEWmoLNa4CrPWZq3IqO0H
         UjEcFma2JLILEfJMb91KkdWu8MtNmorg2HY41dpOmMASev5Ir9Iyf51nB1wbsnYuov3b
         Dp3a1FE2zYZBhDZyShtDX950j++a949D0TpoXlzZF9f9z7owhiqSyUkZLJaDg9HsQsO+
         3lwSIY3HmtEqBbGrXJP1jPsT+xytWb77IUWR6N3RwM2fNQeTR+BqyggNT3JGgKbP488j
         XKpQ==
X-Gm-Message-State: AOJu0Yxo30CbMbD8SjCQV05yYMYMLK2NEevn0nnquBSRPFngY9rStoWu
	umF7Gx7nl1wwfm7OxsfuEktrJ0r0GMIVhqC9Ec6V+KcMW5xmrE8L/EYr
X-Gm-Gg: AY/fxX70rWMiqEu5/UnXGS0FzBQvrUH31ODgxINE+1u3lg0hk4JM6aasdLAiNMCTzsS
	3z5Y5MuKweKBPH3Gh+pEVhgrurLZAZTYgRMWkEkkDWmeQxObApLgGq5y4k6K5MZN9guJN/0WBNY
	nLzYwN2uLDOAPOfjkLfG/OeEFYQuG68AOZB93iDbmnKuZtfY95Yn1ZKhx4YbevDezO/AHjl/Zaq
	PVgtTnZ3N2riilBuBKSWbyyNMoVgDKy+9tK22V1+1KTxPQaXH7/Aex/fcznBbUMSbeVuchErkzi
	sCE1YrbpgUA9Q6MwnCnrr8Fzrr/g/CaQYET5sHugp8rwJxWwhnF8zPfAySvbrT6IbmAQqo3StfM
	tfK/smuINR3yRzESWB7ZwJtmufl6WKdbYqvGXq6xKky8AmWTYHqAKAo53oIUqTW5ZIrG8iKHLnS
	HHo5Ccznhf+x6qsQReOLc/FheHQo48afODqnSZASXI3QAeTvlLjGIAcjX6/LLiOX81XHxsh2iaF
	knKsfINBRU7ElIu+XI/mfAKd4Bv1auJ/SRqLvcs1do/ElIELRaHhlYrC0MCSc+P3Q==
X-Google-Smtp-Source: AGHT+IGFE95wEtpfFwtjTiCcDiqd/x/VRp77b5we3rDpWf3zlfvwo6wItKcd0BaEkVYOWNXABbIVMg==
X-Received: by 2002:a05:6402:42c4:b0:64b:7b73:7d50 with SMTP id 4fb4d7f45d1cf-65097de8202mr162574a12.1.1767729309560;
        Tue, 06 Jan 2026 11:55:09 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b8c4454sm2902324a12.3.2026.01.06.11.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 11:55:09 -0800 (PST)
Message-ID: <6d77bdc4-a385-43bf-a8a5-6787f99d2b7d@gmail.com>
Date: Tue, 6 Jan 2026 20:55:07 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 nf-next 0/4] conntrack: bridge: add double vlan, pppoe
 and pppoe-in-q
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 bridge@lists.linux.dev, Simon Horman <horms@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Phil Sutter <phil@nwl.cc>, Ido Schimmel <idosch@nvidia.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Eric Dumazet
 <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>,
 Jozsef Kadlecsik <kadlec@netfilter.org>
References: <20251109192427.617142-1-ericwouds@gmail.com>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20251109192427.617142-1-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/9/25 8:24 PM, Eric Woudstra wrote:
> Conntrack bridge only tracks untagged and 802.1q.
> 
> To make the bridge-fastpath experience more similar to the
> forward-fastpath experience, introduce patches for double vlan,
> pppoe and pppoe-in-q tagged packets to bridge conntrack and to
> bridge filter chain.
> 
> Changes in v17:
> 
> - Add patch for nft_set_pktinfo_ipv4/6_validate() adding nhoff argument.
> - Stopped using skb_set_network_header() in nft_set_bridge_pktinfo,
>    using the new offset for nft_set_pktinfo_ipv4/6_validate instead.
> - When pskb_may_pull() fails in nft_set_bridge_pktinfo() set proto to 0,
>    resulting in pktinfo unspecified.
> 
> Changes in v16:
> 
> - Changed nft_chain_filter patch: Only help populating pktinfo offsets,
>    call nft_do_chain() with original network_offset.
> - Changed commit messages.
> - Removed kernel-doc comments.
> 
> Changes in v15:
> 
> - Do not munge skb->protocol.
> - Introduce nft_set_bridge_pktinfo() helper.
> - Introduce nf_ct_bridge_pre_inner() helper.
> - nf_ct_bridge_pre(): Don't trim on ph->hdr.length, only compare to what
>    ip header claims and return NF_ACCEPT if it does not match.
> - nf_ct_bridge_pre(): Renamed u32 data_len to pppoe_len.
> - nf_ct_bridge_pre(): Reset network_header only when ret == NF_ACCEPT.
> - nf_checksum(_partial)(): Use of skb_network_offset().
> - nf_checksum(_partial)(): Use 'if (WARN_ON()) return 0' instead.
> - nf_checksum(_partial)(): Added comments
> 
> Changes in v14:
> 
> - nf_checksum(_patial): Use DEBUG_NET_WARN_ON_ONCE(
>    !skb_pointer_if_linear()) instead of pskb_may_pull().
> - nft_do_chain_bridge: Added default case ph->proto is neither
>    ipv4 nor ipv6.
> - nft_do_chain_bridge: only reset network header when ret == NF_ACCEPT.
> 
> Changes in v13:
> 
> - Do not use pull/push before/after calling nf_conntrack_in() or
>    nft_do_chain().
> - Add patch to correct calculating checksum when skb->data !=
>    skb_network_header(skb).
> 
> Changes in v12:
> 
> - Only allow tracking this traffic when a conntrack zone is set.
> - nf_ct_bridge_pre(): skb pull/push without touching the checksum,
>    because the pull is always restored with push.
> - nft_do_chain_bridge(): handle the extra header similar to
>    nf_ct_bridge_pre(), using pull/push.
> 
> Changes in v11:
> 
> - nft_do_chain_bridge(): Proper readout of encapsulated proto.
> - nft_do_chain_bridge(): Use skb_set_network_header() instead of thoff.
> - removed test script, it is now in separate patch.
> 
> v10 split from patch-set: bridge-fastpath and related improvements v9
> 
> Eric Woudstra (4):
>   netfilter: utils: nf_checksum(_partial) correct data!=networkheader
>   netfilter: bridge: Add conntrack double vlan and pppoe
>   netfilter: nft_set_pktinfo_ipv4/6_validate: Add nhoff argument
>   netfilter: nft_chain_filter: Add bridge double vlan and pppoe
> 
>  include/net/netfilter/nf_tables_ipv4.h     | 21 +++--
>  include/net/netfilter/nf_tables_ipv6.h     | 21 +++--
>  net/bridge/netfilter/nf_conntrack_bridge.c | 92 ++++++++++++++++++----
>  net/netfilter/nft_chain_filter.c           | 59 ++++++++++++--
>  net/netfilter/utils.c                      | 28 +++++--
>  5 files changed, 176 insertions(+), 45 deletions(-)
> 

Can I kindly ask, what is the status of this patch-set?

Regards,

Eric

