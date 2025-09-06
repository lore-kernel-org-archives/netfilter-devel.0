Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D879D2367D5;
	Sat,  6 Sep 2025 12:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757161609; cv=none; b=TtZlmyKNUWIyqgoaNBByxAvJxm5dDall3TCkr3dgRN1ZQ1jj0d8Hu0y6q8uu59zXroC/zYSUJCbNQ7yZLkF8R1iP6evrNbnTcMdGOikBZkcBAyq5bQBJ2dmVW9uVZZxOb6a5O2r2h5CFsPqO0lOuNNBGBdYjJb82nrRnCLm12BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757161609; c=relaxed/simple;
	bh=uyLHMnAZiaTBpdwrmMUjgQtsM/l0FVDb2WilloB6myE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jUQGSwd0DiDDlkNV7g8oN0sQvH5PovduJCDyS6mBGsw/6mz5F84bqAbM5Wx+xZlFbYvszxUDLUry6HJKTwtwIIYxxAp1Y+I+pTo/JXBJwEHicJ9OUHpbcoPkCH6TyPCGGTan+XvJ+g5ePlvnpX2wpsQIvDaKceAe2Gzse/ONCoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cl7SaN7l; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cl7SaN7l"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61cd6089262so4840289a12.3;
        Sat, 06 Sep 2025 05:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757161606; x=1757766406; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GYPCD/NPkTxuL2mcgrjhRFxILZrrbtXYYqo86fwBS9I=;
        b=cl7SaN7lruN92nHUghNNB9Z7Tx9BvgCC/MDHP7XUYqjcc2UMjp2/yJmIGJAT3cCTXu
         VLBjlEk8QPda96Wyv0dIGCPu4pNqjrKRWSPmoIU4PMU5aE798sWvjd0wEAHIQ0cDU8+b
         E3BetwHCpbrMEO/UBXHh3xJUVXNfDpXuMjIUwSc6G6hyW/IK7Ts/qk2DajWeXWOzrpfC
         5NmNVQtr4qnQmFeZvY4rYnLtO16m255GeFWfCBCkl+zP0qaWjzA9H8It0p3tMLh+IYdZ
         yqA4MiAfZyhW5axJAFw00dVQYtAmt/5HeYU1jWiByTlcQeTdQHm+A95xFoc+YuZYi/V9
         R8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757161606; x=1757766406;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GYPCD/NPkTxuL2mcgrjhRFxILZrrbtXYYqo86fwBS9I=;
        b=xUTyDTf55QDKAHYJTLhKbyhQSOPZwti+X/J0eTq2I4PATabaDvGZWrHW3sSPJk56hL
         1qphMtBmlQvizQXtDPssoDZIOqlcvIhR/GXJS8QXLMxlalPKLhqJenLY3B/2fsMTbcNl
         NjO++tu2ZdxI0p+n6X32YeR5U6ae44oJux42671Z4KCKTPcQeBPOUvyVoA1TCccsP6kY
         aYMvaQxhWmU+Fo0DZUQx1uW+D5/UG8swHq2LLxaHnPGTq6+Pzj9AOea/zsj16RahKrwz
         +g9Vck4rmt+zxoS82mFFhbvbTDfc8XqBdNyOBKrPkdzKKrIiYL+Up3IPBN+q8tAi7G/D
         HF8w==
X-Forwarded-Encrypted: i=1; AJvYcCUVHxl93z2RB7R/zgQqEeCOUI6bKT7LGdcbyyG2FO/M1WPXWkYYJJcp2WQDq+JfFq7X/p0kNCY=@vger.kernel.org, AJvYcCUWMVVMr7Yl6sr/ieTx2FMj8pPL9faXv12Wr/3TCB0HWpeGYuZTAqUosMZuPhuI7iA5qCWq1skO/E03F28U4h4P@vger.kernel.org
X-Gm-Message-State: AOJu0YxVZf5OVGBvH7LcfLwdK2cBNznXJayz6k2bWRQSJrzFz9YtTdTc
	dTkxUgPBdCZJ3MmKJnF30dxzKyFKwKA6+dgloto2/oplKFSVkn42nbMN
X-Gm-Gg: ASbGncumsbQmqsM12mB5VZrIKrneL3wvDpsj1e5a2aaobPVJLOo9uw4pxCwKYfs0+HT
	khSvT6TYDC18o5it4vhn8DPjfyfbDjhpts5bh2vrIUKNgo4oTsjkX48B8SivZ/bEwv8/RPUDWEs
	VPW1DUOnRv1v1DkeRfPqp6pAwMSBjWwGX4t1DG61nFaYT9Jb+LUyGNEey+Vthh/f2ZmlACsWRDA
	nOwG044pYX5Oh0TX+4tNp6A7dIp0cuz1p+JJXWBoNwNZNFTY+l1t/6CY29g4sP2rbGw9EFJ5TdU
	SegmdLqoIuGi3pTxsf7zkv9uwtnZBd2oWSPvl4ODUn/lpLJFs7JmHBQt4p7JYbMmtwWWn22larj
	Guljcl145sCfbIbD53eN5XPOm8dDjGLsJCjUV8xrUkCjwPtYcV9ksEI4fgPquVP8SHYmkqz+a5R
	gu8bggxYCqnqgJmlMB2bX4zu+njbJ4KZeFkZ3RFJ2Y9l2CTZZZ6B74KZvpuiVhlDivagnEFM1NX
	wUaFcmBRD+/qsFLSxU6AKnuAuaobmts35UY3vO+Ndc=
X-Google-Smtp-Source: AGHT+IGlmLdeGtuKvTH0MqCFaPfDo0A7tkqYM1S1rxpawOca3ZnjsfsapUwJICz2nhbV/8xz+LeIZw==
X-Received: by 2002:a17:907:3cc9:b0:b04:6e60:4df1 with SMTP id a640c23a62f3a-b04b17672femr212961366b.53.1757161605812;
        Sat, 06 Sep 2025 05:26:45 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b042fcae867sm1397299366b.58.2025.09.06.05.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Sep 2025 05:26:45 -0700 (PDT)
Message-ID: <4398dc1f-5454-4e06-806e-34ee02108ce2@gmail.com>
Date: Sat, 6 Sep 2025 14:26:43 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-4-ericwouds@gmail.com> <aG2Vfqd779sIK1eL@strlen.de>
 <6e12178f-e5f8-4202-948b-bdc421d5a361@gmail.com> <aHEcYTQ2hK1GWlpG@strlen.de>
 <2d207282-69da-401e-b637-c12f67552d8d@gmail.com> <aLbuokOe9zcN27sd@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aLbuokOe9zcN27sd@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/2/25 3:18 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>>> Thats because of implicit dependency insertion on userspace side:
>>> # ip saddr 1.2.3.4 counter ip daddr 3.4.5.6
>>> bridge test-bridge input
>>>   [ meta load protocol => reg 1 ]
>>>   [ cmp eq reg 1 0x00000008 ]
>>>   [ payload load 4b @ network header + 12 => reg 1 ]
>>>   ...
>>>
>>> So, if userspace would NOT do that it would 'just work'.
>>>
>>> Pablo, whats your take on this?
>>> We currently don't have a 'nhproto' field in nft_pktinfo
>>> and there is no space to add one.
>>>
>>> We could say that things work as expected, and that
>>>  ip saddr 1.2.3.4
>>>
>>> should not magically match packets in e.g. pppoe encap.
> 
> FTR, I think 'ip saddr 1.2.3.4' (standalone with no other info),
> should NOT match inside a random l2 tunnel.
> 
>>> I suspect it will start to work if you force it to match in pppoe, e.g.
>>> ether type 0x8864 ip saddr ...
>>>
>>> so nft won't silently add the skb->protocol dependency.
>>>
>>> Its not a technical issue but about how matching is supposed to work
>>> in a bridge.
>>>
>>> If its supposed to work automatically we need to either:
>>> 1. munge skb->protocol in kernel, even tough its wrong (we don't strip
>>>    the l2 headers).
>>> 2. record the real l3 protocol somewhere and make it accessible, then
>>>    fix the dependency generation in userspace to use the 'new way' (meta
>>>    l3proto)?
>>> 3. change the dependency generation to something else.
>>>    But what? 'ether type ip' won't work either for 8021ad etc.
>>>    'ip version' can't be used for arp.
>>>
>>
>> Hi Florian,
>>
>> Did you get any information on how to handle this issue?
> 
> Did you check if you can get it to match if you add the relevant
> l3 dependency in the rule?
> 
> I don't think we should (or can) change how the rules get evaluated by
> making 'ip saddr' match on other l2 tunnel protocols by default.
> 
> It is even incompatible with any exiting rulesets, consider e.g.
> "ip daddr 1.2.3.4 drop" on a bridge, now this address becomes
> unreachable but it works before your patch (if the address is found in
> e.g. pppoe header).
> 
> 'ip/ip6' should work as expected as long as userspace provides
> the correct ether type and dependencies.
> 
> I.e., what this patch adds as C code should work if being provided
> as part of the rule.
> 
> What might make sense is to add the ppp(oe) header to src/proto.c
> in nftables so users that want to match the header following ppp
> one don't have to use raw payload match syntax.
> 
> What might also make sense is to either add a way to force a call
> to nft_set_pktinfo_ipv4_validate() from the ruleset, or take your
> patch but WITHOUT the skb->protocol munging.
> 
> However, due to the number of possible l2 header chain combinations
> I'm not sure we should bother with trying to add all of them.
> 
> I worry we would end up turning nft_do_chain_bridge() preamble or
> nft_set_pktinfo() into some kind of l2 packet dissector.
> 
> Maybe one way forward is to introduce
> 
> 	NFT_META_BRI_INET_VALIDATE
> 
> nft add rule ... meta inet validate ...
> (just an idea, come up with better names...)
> 
> We'd have to add NFT_PKTINFO_L3PROTO flag to
> include/net/netfilter/nf_tables.h.
> (or, alternatively NFT_PKTINFO_UNSPEC).
> 
> Then, set this flag in struct nft_pktinfo, from
> nft_set_pktinfo_ipv4|6_validate (or from nft_set_pktinfo_unspec).
> 
> NFT_META_BRI_INET_VALIDATE, would call nft_set_pktinfo_ipv4_validate
> or nft_set_pktinfo_ipv6_validate depending on iph->version and set
> NFT_BREAK verdict if the flag is still absent.
> 
> **USERSPACE IS RESPONSIBLE** to prevent arp packets from entering
> this expression. If they do, then header validation should fail
> but there would be an off-chance that the garbage is also a valid
> ipv4 or ipv6 packet.

I'll try to recap what this would mean for this patch, correct me if I
am wrong.

'ip saddr 1.2.3.4' should NOT match inside a random l2 tunnel. That
makes the 'issue' expected behavior. If the user must need to match
ip(v6) address, it must be solved from userspace, modifying the rule.

This patch (3/3) can be applied as-is, with only one change: remove
munging skb->protocol.

