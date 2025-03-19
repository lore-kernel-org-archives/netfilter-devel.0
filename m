Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46994212FBD;
	Wed, 19 Mar 2025 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742413053; cv=none; b=HHItc+amCXk0Y+WFiuyutE/ulLL366pNK1I6fnCuVMF/1YAH3mCJJXl3yj3bs11LekC4gE/EyPZgDyWPAT1WoPbqFF/iyKL5TIgcqO0CMJKIfTfGVMyqSLwFXXRuO0t4y/XYooUV6NQ8v7G5pcYkS2Yaxoag04bP/rww5XBoGrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742413053; c=relaxed/simple;
	bh=NUjywNL79Bcz4+kco3+goMMB0g0EPgUwAxsOhv4kh1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=poITFQ7AoQLaI8cy6xvgVseYZ4eM68DuWeT6I7mq5E9aaQ6mLDMrd+NN1yhTVrGCCki2q2q5Ggc9XcEU3pFdZCQROWqVox/4VpKLdXmW3iDKpu1eb4UhjjDC6zfvp0wVPhPK5ygNX57PeIvWrP77N8nN6PGxfhxDiHzHu/Z0seM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NDeFIrH5; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDeFIrH5"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac2bfcd2a70so12556966b.0;
        Wed, 19 Mar 2025 12:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742413050; x=1743017850; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/hWjp2lAOR+xlpu16vpG0lA3R8Vrfh8sFtASS1Glky4=;
        b=NDeFIrH58b0as23jtqDnr6ZDqDruXPv0od6poETwRfviXoIu75d/zQ4+M5uj+gjP37
         EmgLMV9jCQnYQ9SKVh0ikohlfKDGPsmUxJzK9VIEvOl97lFzffKGye38uBbNSRO44rBG
         rLdVQLUiqw2+4/ARegu83pt6Gy8mtKZhte2ZKrkYMnT+FNhj8gaYqZGGDftaK8uWa368
         3tNYCAX/9fOLBKqyPtMpGIy3XfLvUvMAu/m1TZjkOmU+ziLon7gxN2C/e0+V8k/EREWd
         4ZbTvEVKhpvQwjj1qJ/KWVHIwtIqR+ceA/TPXLCutZ2gydsyPWilUU6PwhTP/YRFA7zp
         F/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742413050; x=1743017850;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/hWjp2lAOR+xlpu16vpG0lA3R8Vrfh8sFtASS1Glky4=;
        b=FPgzz6rWMtFVzEVT+F3SbeA2eEK9nteall0Aac54a3zZ4WjB3esuGoCMvRd3knduxp
         UfyOmjv47iHFuCMGB7paFXRwvSxpZLac6Gzu2x2j/zpyX0szmEETMhcL6pW7Ib1FKYZH
         vXfaFc+SODPisFiQ/CdJN4lVFFjPZGxqtbONprKrrhUY474ZHaJX0B/h6lMO8dlJhmIS
         an4cpMK3hXRFonMkpgmNiIvbRIdFc8MWifTH7EQMswRC2mMrVdicW6Q2ikRPdnENBmWZ
         6ZHGmIW9pEisTY79bzUI3AWixNfSo+6TsGgR0zj9ZtGuUivq750uMPpdkvG9xkkGb23A
         bofg==
X-Forwarded-Encrypted: i=1; AJvYcCU9Wja1OMZDM9GnU19LVWlBJQ6pzTRo0OU3MMPLLl47EL5cijhHuEiDKQe9AHQZlPVkfplGqENF@vger.kernel.org, AJvYcCV96C3BA9uezoZFgwPP97NDWjHFcOrwZrIVvHyc8pNlccRXcBI9TAPOdu6TyhXvEwazbvjJtTDjgUogMysOvjHW@vger.kernel.org, AJvYcCWxRZVX6NdREPvMPpdZBBvqmobjkY3jiNJal264QosXEngUBoQsOOwmMhgdqCqYOfLj2C+15A4YY3pO7lBj+HI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3EYFPNZTmOG0P8ThioXTnxM2W5I/AOqA1cqRoPJ2DIzjGfD3E
	VJRkDEgb1EySjvkxLBr0UFJw/DGGoOV9Sqaop2TnlSWl3CrOLQq/
X-Gm-Gg: ASbGnct+R53EUevpzBP3c7Sc5Fyg5LO0cjrzmEQQ7ZQV4IL/kc1/mpHVyAv84fIHoyu
	gi5hFp7ueePrVue+lfF7p74hd64UtqCCttUFbJvbQiHpPuSjk0yxHhXJiXAbwuuloLRkukI6OXL
	do1yZKdnjgDdZOp3N30e7vty9S11kcojMimFitisQuYv+3OgIGBkbRmawD8FHOFPUunCgZgkQ14
	xB4DJqMcYaOyuetwxwK0pX5R4YyIJmevjUr24qFWJtrb03DFcV90O9Xmy+C2Hon0QSKudmqBqd+
	UjxO6WTLDRraBQUuKPAnqI9VQcydh63BqIB/ElehVwR4Uc5ZO8OrkFzeE0usI6zXMbrbI1mZWGi
	cwIaN0SsP1Fa0fU8KRc9cL8frhjSWpQbcIuM4/eVZAeUyJ2giL7LVNFD3MZgAnLMSXdp/wIfg2n
	fSdPaJPeV2goHWJZFYOss=
X-Google-Smtp-Source: AGHT+IFxBYUpzqxGSZdBA0JubUlnSNecSwjgT24V4GH75JqqwyWr1waPwEMz8/JdpX6S2eAzwSPnRw==
X-Received: by 2002:a17:907:ec0d:b0:ac2:dcb9:d2d7 with SMTP id a640c23a62f3a-ac3b7a97454mr522728466b.12.1742413050194;
        Wed, 19 Mar 2025 12:37:30 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3146aecbasm1039783166b.37.2025.03.19.12.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 12:37:29 -0700 (PDT)
Message-ID: <eacbd4b8-b8dc-4402-9cbe-666c1ae112e2@gmail.com>
Date: Wed, 19 Mar 2025 20:37:27 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 nf-next 2/3] netfilter: nf_flow_table_offload: Add
 nf_flow_encap_push() for xmit direct
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Michal Ostrowski <mostrows@earthlink.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 linux-hardening@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>
References: <20250315195910.17659-1-ericwouds@gmail.com>
 <20250315195910.17659-3-ericwouds@gmail.com> <Z9oAeJ5KifLxllEa@calendula>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <Z9oAeJ5KifLxllEa@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/19/25 12:23 AM, Pablo Neira Ayuso wrote:
> On Sat, Mar 15, 2025 at 08:59:09PM +0100, Eric Woudstra wrote:
>> Loosely based on wenxu's patches:
>>
>> "nf_flow_table_offload: offload the vlan/PPPoE encap in the flowtable".
> 
> I remember that patch.
> 
>> Fixed double vlan and pppoe packets, almost entirely rewriting the patch.
>>
>> After this patch, it is possible to transmit packets in the fastpath with
>> outgoing encaps, without using vlan- and/or pppoe-devices.
>>
>> This makes it possible to use more different kinds of network setups.
>> For example, when bridge tagging is used to egress vlan tagged
>> packets using the forward fastpath. Another example is passing 802.1q
>> tagged packets through a bridge using the bridge fastpath.
>>
>> This also makes the software fastpath process more similar to the
>> hardware offloaded fastpath process, where encaps are also pushed.
> 
> I am not convinced that making the software flowtable more similar
> hardware is the way the go, we already have to deal with issues with
> flow teardown mechanism (races) to make it more suitable for hardware
> offload.
> 
> I think the benefit for pppoe is that packets do not go to userspace
> anymore, but probably pppoe driver can be modified push the header
> itself?
> 
> As for vlan, this is saving an indirection?
> 
> Going in this direction means the flowtable datapath will get more
> headers to be pushed in this path in the future, eg. mpls.
> 
> Is this also possibly breaking existing setups? eg. xfrm + vlan
> devices, but maybe I'm wrong.
> 

If you do not want to touch the software fastpath, It should be possible
to do it without.

For bridged interfaces, only use the hardware fastpath, not installing a
hook for the software fastpath at all.

Another option is installing the hook (matching the hash, updating
counter and perhaps calling flow_offload_refresh() and so), but then
letting traffic continue the normal path. That is, until the hardware
offload takes over.

In both cases only allow to add the flowtable if the offload flag is set.

What do you think?

But in all cases (including existing cases in existing code), I think we
need the patches from "[PATCH v10 nf-next 0/3] netfilter: fastpath fixes".

Could you look at these?

