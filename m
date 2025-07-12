Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96652FB2;
	Sat, 12 Jul 2025 10:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752314935; cv=none; b=swNPkdRyvtel+Z5Qko47pUDtEXPaK5+w5w2BaptqesvZcA9JTw0IHV81TTGQPnkzehvGd3fqPwkXCXEeEnhbuuJiMe1heMOKFJ6Usj4jCXj2smee/SGxg/fDujhCrfJr/uKp1H6QxsDui6qhsYZmVA5SOro25MRl00E0wB0+acc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752314935; c=relaxed/simple;
	bh=/7FhxhUKRdXLcCpht0SasLliMovD6ZI97aLJBeweMEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q8rGzj5TFBXgHXVZ2c5egGvzkUAYAc6a4RWSP2xyLoYwD2xJVVGtJpI8gyYNGP8MRsMwmSDBij+vwIZ6T65u0fieJnEAytVcC32t1Jax4yjR/MduEbPveY8O/Ph/5vYQkm3rk7AdGI6+t5xM0FPFGVt/kicHdPbEg1wfZv023GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jcAw5h89; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcAw5h89"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6077dea37easo5199714a12.3;
        Sat, 12 Jul 2025 03:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752314932; x=1752919732; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X+eJO7lZ+aUO3GREvLxb2HdalOKZ6MnXGDlkmXm5ze4=;
        b=jcAw5h89TGusaOxZyaNLEfcc8ARrk0rFKjfPkMXBTK+BsVJQJm0VfQKhXWXYNNCsbr
         syzlwZUvzs+tHFPIMjYEEVdd7DM+9gMpLIR+3lNStjxYPmmAwudBlQ0DgCDOu1pKrWy7
         RskuTAbgtzSddFQdDpkw4Mgqdtzwdjg7nYF2f0llBQmDPtsMjwrQtAQwyINIgztOOH1z
         YCe46mdlxhxTKTbiymJWI/MaLxCFMggFo66DGR78qeeBIWiGw0t27DbusoKCNkyDJ69C
         9yMWUWxncpT5Z4m7TI32iED4o/94AitUTL3VXHofoQAI/KgXK5hMVNOpEDRuwRPFmpmT
         2nYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752314932; x=1752919732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+eJO7lZ+aUO3GREvLxb2HdalOKZ6MnXGDlkmXm5ze4=;
        b=Yl78XXKQleQTjXXAofx8jAuUui1I/2gIpIdDaURdloMSmSkz6Ins3N3RcdasYRyPoN
         sPYTybu/AJhOvrquN/9WH2pYvdTYz297InoqhNJj9smAuwYzidrw/PEY8nBnFMBqW4st
         cM49/XnTSEJWjQofF7m5SkwL7DtpHrcqdKKjk2xkPd7UiNTU4XtH6rUWrMNgpQueVw7h
         plp8XLiLueMND1wevlsJuwCzNePwfkXyLHSkL7Id00Bo8fZd937tfyGEixmbUXyNhzec
         sI6SgOaZmnQIOGN33gSqKhuNtQLPpfLiX0SjO1h+kaavCEr2RJon5z+wA6fvh6GL7St6
         avEg==
X-Forwarded-Encrypted: i=1; AJvYcCV52cXC9oViNF1LqrK8JDHMSDodxhbLq8m5rbj4uTfWRR19+IkedASjvV5P33uigSv88yNHEPA=@vger.kernel.org, AJvYcCXQTd5XTXy/mGgiiYrMagvl8gjjQA0m1k+LACvJphHQpzb5K1GaFICeYj5ungbZc+xjZMAdvZxNn2cMBZuwBo0f@vger.kernel.org
X-Gm-Message-State: AOJu0YwbNn1EB6EWC2DJ+9DXzNn27161M7tHdMs9OL4SiQNLnfO18lef
	AWthu+G4xRCkjEZfLQi8jLWrmkG4pV/3EWefYsSRps8Rq/USnHEBvdGq
X-Gm-Gg: ASbGnctjhzHz45kgKu3tPbQeF/LvLevQOLNEz3LC3l1lO3mX+XnaS4OnOFu36gcwQ4o
	K8iRhOyDjZJrpYg2hZIRzNo2BZMrMWRKJdFC3xfI9YpMn389FP/pM+FoGpMftgTxNc/wyJA1uvF
	pmpaIordccaqx0FTKUo7JRQJmQNvxgO9hYVw1qJ+kV566cL0K29cbbdlEzjga688VAO4E1l3P+k
	HgaBjcMaAs/P8Sc0g3DLsnQWDr3A+9mqB5jD7kAMLaDwwPyaIuD9xRTdAnWpaw1l2m6DM7ZqbAi
	VO9LL5OZTGCux81NzDr3AQr/dzjudHo0BVZL+iSP8LggzS7vnizIPL5Za9gRSpMTIpvvVTixx50
	iIcOzcuLCoy5WteGod8SECD2lqcUCQYOFyQgKlIKqsMD92xGybJcEOFxTYfGBY/Qz5m5bkWiHvS
	/hlsPoFDiEU9/ysEGEHvBNliKfn8M2/e7iwfdIwoktdBvMktkfJWWac3dLgFvKExn9pHU70maX
X-Google-Smtp-Source: AGHT+IFIOLuDKv6c9RfzlcBDtf/CyOztjAQJPRECB+fyUnEIdhY9dn3XgfrqLeSDdWwQTsjQTwhhrQ==
X-Received: by 2002:a17:907:6d0f:b0:ae3:c968:370 with SMTP id a640c23a62f3a-ae6fcb67267mr675808666b.59.1752314931597;
        Sat, 12 Jul 2025 03:08:51 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e82df594sm458235066b.159.2025.07.12.03.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jul 2025 03:08:51 -0700 (PDT)
Message-ID: <5db98a41-37b5-41f9-8a57-f143cc0eb39b@gmail.com>
Date: Sat, 12 Jul 2025 12:08:50 +0200
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
Content-Language: en-US
From: Eric Woudstra <ericwouds@gmail.com>
In-Reply-To: <aHEcYTQ2hK1GWlpG@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/11/25 4:14 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
> 
> [ skb->protocl munging ]
> 
>> But in nft_do_chain_bridge() it is needed in the case of matching 'ip
>> saddr', 'ip daddr', 'ip6 saddr' or 'ip6 daddr'. I suspect all ip/ip6
>> matches are suffering.
> 
> Thats because of implicit dependency insertion on userspace side:
> # ip saddr 1.2.3.4 counter ip daddr 3.4.5.6
> bridge test-bridge input
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 4b @ network header + 12 => reg 1 ]
>   ...
> 
> So, if userspace would NOT do that it would 'just work'.
> 
> Pablo, whats your take on this?
> We currently don't have a 'nhproto' field in nft_pktinfo
> and there is no space to add one.
> 
> We could say that things work as expected, and that
>  ip saddr 1.2.3.4
> 
> should not magically match packets in e.g. pppoe encap.
> I suspect it will start to work if you force it to match in pppoe, e.g.
> ether type 0x8864 ip saddr ...
> 
> so nft won't silently add the skb->protocol dependency.
> 
> Its not a technical issue but about how matching is supposed to work
> in a bridge.
> 
> If its supposed to work automatically we need to either:
> 1. munge skb->protocol in kernel, even tough its wrong (we don't strip
>    the l2 headers).
> 2. record the real l3 protocol somewhere and make it accessible, then
>    fix the dependency generation in userspace to use the 'new way' (meta
>    l3proto)?
> 3. change the dependency generation to something else.
>    But what? 'ether type ip' won't work either for 8021ad etc.
>    'ip version' can't be used for arp.

Is using 'meta nfproto ipv4' instead an option? This looks at
pkt->state->pf, which holds the correct value, not at skb->protcol.

> 
>> I haven't found where yet, but It seems nft is checking skb->protocol,
>> before it tries to match the ip(6) saddr/daddr.
> 
> Yes, userspace inserts this, see 'nft --debug=netlink add rule bridge ..'

