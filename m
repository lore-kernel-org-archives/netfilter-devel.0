Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB924356A24
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 20:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771791609; cv=none; b=MAzTpHcDAbiFcgiI+tvqaf6oXVFJg7HXaR2dAb6+GrQZDv/YfRVrrbVoJbicBRwHpvR34IKuT+SK9K6dR8fO7JrGfKu4pNDE4RMbO4K3RJo+qV+qYyGrV2MVEsQ9IkyeLZeeiCGTpUVVhZybDc5TPRVhqTFXgoNpU8F+oXh0DNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771791609; c=relaxed/simple;
	bh=AvPUejLylMe6jxtFjp+4uu3x6b6UYh1yyZKXO4RB18g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDP005cr0B6zDFVXeUy6mFOOTejOMe9Dh3zpmcRZS+Jn2YS7kZgB/bdc+8ARqjJ1Czk/S8CQI5MgKVkKxBsJK0jpAA7c4KSWfDilRfMdQUayivJMrxhpd22D0GYLXXnAeI0w+QQhmju6KFB+UZtT2OgoVG3ZJUqMLh9X/n8T8Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Im5+F6P9; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Im5+F6P9"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b885a18f620so652679066b.3
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 12:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771791606; x=1772396406; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ziqVjObozmBP/YMpMD3gIg2L0bYhVbhRy21Cs0R6NM4=;
        b=Im5+F6P9mQnTRX6lgEV7pYRTS5FxSC6LH2GxXTbY553unxaWlpMZBCn2C9nS44M79U
         wFouC2OvIKcB+qoSmWZjCHB4lVDpZBV5rmOKrQiOY9a+CvfnWIVuGg8QFisW7/j1nNQz
         NFWHJARiDrDLEEwQC/yhoDp+Ge1o1mskdSA+HcEf6/Ru3pwMxXcr2I+5pVQcrKb6OAet
         /sWAm7oaslecI06aHwmptjaf5IXnKGbFiw6Nt6PH5C2p0uYZGJTpKNG6JLlYqK3SU+wb
         XghlSwLBaN3FVELPBxv6l6HBUWqR/kgeEtSJ/R7pNhC0SxgeCTulRAIlJoAwxw8qnv66
         Qn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771791606; x=1772396406;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ziqVjObozmBP/YMpMD3gIg2L0bYhVbhRy21Cs0R6NM4=;
        b=aJxzjCLxvCwEbwinv5D7q7gkvvF9GpjToqfGib3Wd3ngSLKeerlcCrDN+LsJ6jGvDi
         mk5mfMgtB+1/xY6+hyhtdxGpp5waMatacpfrpWCjEknu3VoH5Qr0todzeZxTz4NNTn7b
         5GArg2DljqX0pPGWfXlvA4V60+LdpRDNcRs9wUSb5NUXubP0AvFT7M95e9d/GZ2TuuvS
         V0wNHtRLLUq9YT3Y0BRO/21mx7wY1mrNGpDOK0L/62aJi+gUp0gwtKv9SxSM8PegeV0x
         DzpAeMl6doNJkzF0XN/QqzVwJFcngqdv8NNYdN2mwbHOnn7po1r6zajWlMS6AQlmMIQ+
         2nOA==
X-Forwarded-Encrypted: i=1; AJvYcCW9LExj/SG9OaV7Aw1QLqkc+cyTmrB0AGW8MbpD3xz3+jKBFnKSmCCvkraIoFOrQSOd75Cenncj4G7tFtRsbjU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi0NK1/KXIiAjmaFplHmT7Y7K6YrdxJvKJP8Mld4dKOPnhcOBM
	HMKDRjVEZ+2qdstXSiAl8LnDO1g97YjooPmdakyUK5vhMZiXm8eKUmXmnQSetA==
X-Gm-Gg: AZuq6aJxMAQ67I/trVYBAT4xYztf+7wFtkTq3DLYpRZUkvCwUhU87eBiqaKwSe8M6EW
	EwjtVwjMF4SBmNj8R4j94UIt46kW8u3PMVC35/cy8Mvx1xDF02jJgL9s5gSxuGENHUjjLx7rGBL
	L0HAqQR6/7pM7obPEM2Q+1ZZUgG+SPqIXRD+5w4ac6JybvSJYWufJlXIzxRVCexpcXX22KdYNAW
	odgwSH1/wiSiDzyUip0aOa3sxf4bcs/MI3rN48L0b1w9T9zwrjJEYCoQPpe9xUU4jbieijeDyre
	CFiWmMyGHwCx2cLWf5IU1c+IQmMtHZjprTiqKFwV5RMx/6UhxUvDHow8qg+F7lJAlIX0gnXcFJl
	3AlqBKg+90lOAfCWAKN5BeyhNv+dGtZoPAju3TxUHviMGoP3Xr6+gtByXwsOHeziPA270ZaFfgD
	oH8+7ek2rt/g+M+E6TeXcr5z6cXUbu3oobLQB1VLIXfFfA4khzNa8oJ9ex40RpRkVEvBbqB+rOx
	nVW097c7DVgy9nWBNhp1hhikqmeUR6Eu0pkuoYElXplthixd9B1aIKIBjczd1JcBnCXqUuTYtcr
	0oLjr+WmuDyptCAxDzASTiit40rtEl7zPw==
X-Received: by 2002:a17:907:3d4b:b0:b8f:e43d:d5fe with SMTP id a640c23a62f3a-b9081a0cbc8mr417794866b.20.1771791605886;
        Sun, 22 Feb 2026 12:20:05 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eab9ac4acsm1892737a12.14.2026.02.22.12.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Feb 2026 12:20:04 -0800 (PST)
Message-ID: <a4af5ff8-7aff-454d-8990-2922f1b9bbf3@gmail.com>
Date: Sun, 22 Feb 2026 21:20:03 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 nf-next] netfilter: nf_flow_table_ip: Introduce
 nf_flow_vlan_push()
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org
References: <20260222155251.76886-1-ericwouds@gmail.com>
 <aZs8atSEZTjkzzQ3@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aZs8atSEZTjkzzQ3@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/22/26 6:27 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> With double vlan tagged packets in the fastpath, getting the error:
>>
>> skb_vlan_push got skb with skb->data not at mac header (offset 18)
>>
>> Introduce nf_flow_vlan_push, that can push the inner vlan in the
>> fastpath.
>>
>> Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
> 
> This change is in net/nf tree, so why are you targetting nf-next?
> Are you proposing a revert for nf?  If so, please first send a revert
> for nf.
> 
> Is there a test case for this that demonstrages the breakage?
> 
> And why is this tagged as RFC, what is the problem with this patch?
> 

I have run into this, when testing my branch for implementing the
bridge-fastpath, not in the forward-fastpath. But anyway, no matter how
packets are handled in the original path (forwarding or bridged), once
going through the fastpath it would not matter, so it is broken in any
fastpath.

I have the complete testcase for bridge-fastpath here:

https://github.com/ericwoud/linux/commits/bpir-nftflow-nf-next

I do not have a ready to use testcase in the forward-fastpath, but is is
clearly broken. So this is why I started with an RFC first.

>> +	if (skb_vlan_tag_present(skb)) {
>> +		struct vlan_hdr *vhdr;
>> +
>> +		if (skb_cow_head(skb, VLAN_HLEN))
>> +			return -1;
>> +
>> +		__skb_push(skb, VLAN_HLEN);
>> +		skb_reset_network_header(skb);
>> +
>> +		vhdr = (struct vlan_hdr *)(skb->data);
>> +		vhdr->h_vlan_TCI = htons(id);
>> +		vhdr->h_vlan_encapsulated_proto = skb->protocol;
>> +		skb->protocol = proto;
> 
> Ok, I see, this opencodes a variant of skb_vlan_push().
> Would it be possible to correct skb->data so it points to the mac header
> temporarily?  skb->data always points to network header so this cannot
> have worked, ever.

The code here for the inner header is an almost exact copy of
nf_flow_pppoe_push(), which was also implemented at the same time.
So handling pppoe and inner-vlan header is implemented in the same
manner, which keeps it simple and uniform. If one functions
(in)correctly, then so would the other.

I've been implementing handling the inner vlan header like this for a
half year now. My version of nf_flow_encap_push() was a bit different,
but after this patch it is quite similar.

