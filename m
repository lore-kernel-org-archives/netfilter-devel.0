Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B345133EC
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 19:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762283758; cv=none; b=mIwWa9thPKxoztlI7sSzUpm+L7vWhkXXFYJxmuu4GRiKk6khUrCp9boYE8TNvUv6QL+BXhfsAyW7CXZY44siYEbUiP9Z4bEvWmLkXTpET8/s9Ntk1m70aaVNsA2Y1ytiI18yppTH2uaXWc2r6o+thbykZ+1pASBDl6t+pUYzEeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762283758; c=relaxed/simple;
	bh=7S8+vO3ASy53c9/QMBRYjqmZUqwJy9+RRobBAyVghQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B3gyHydg7SFF8fctcgwFKUqvYheM/krkSUjCLJ/AoM50wbcyNlrq/KAngT7D9ZssHgjZ8Ex3E4XEwCt+YiOOtJO8Ue0OQ4KGHcAQ3yjDZmeOpamPfqD97XCrkOed7DdWEmHgBjX6kgfEr6r+tO9crSPFq280P+yX7IT+Loxx9t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tted8uOH; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tted8uOH"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b71397df721so410447766b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Nov 2025 11:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762283755; x=1762888555; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0QMyfynSbIJu4PvSuals8RhlA+Y6TdmVDUTrRaQq4u0=;
        b=Tted8uOHUyq8Y3gfRjdnFf8UCc9v3+0jHMdlUyTqyvldEB081s3sJAD52jD9wepwOY
         ROP/gJfXC2DduCpLJGI5NvUKt+29w9699rlhPHF4vch7k7ccQcgT35+RBppqaQWWlqup
         03J2mSgLNgJ7J/qypBh8cIza4yZkowpjG/Rj+3t9lPkqaZCPmbKvVnemIlirJ5KDUMMl
         X2bLr/YH1QKErqEp8L3kSOOawCAjuwFp4nXi/n0h+dXnRm6jq3d6SEoVyZ3rxEEBFZXL
         21VqdgSs77qylaIFwQOElpoYrPcMUl/qf5m0dym8biyBQl7sOBcL6AhMRsVGArVX+e/a
         nKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762283755; x=1762888555;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0QMyfynSbIJu4PvSuals8RhlA+Y6TdmVDUTrRaQq4u0=;
        b=n3SocZM/65gmn8VzrYoiM+XgRmFvg+RY8p2uebeirdddHfi+GwLjcCCofmCX1ehycG
         t4WV/FAHly4F23DeR1yEo+FzzjtG3bt86zMpTxOohbg+9/kAAayf3zghFg1fTKq15dlg
         7nYouPaxPB8We+coNFiJ6r4Jf3hR+zfatnkRcEsiXKa4oGJkn6Vmfz8aDFlL633YhHgy
         yJ938OYjCBeTSUbmBQZ0Bk+HsrVNLZdad1eeJU02Jzs4d6eVuorxk4TBShQOSVA2P8sQ
         M+AadPibI6r8RY88iaoYqJyqoxblppO7KIle77mH32zfPV8LOSucvBiroROSD/k9q3/7
         Uddg==
X-Forwarded-Encrypted: i=1; AJvYcCUEnOL3bzQ9JLZ04TKM5p3W+QY49SExDxue5iEMN1f/9N6T7rcclRLgde+HVIvmFXTdfMsirjwgp0vGKFuprII=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSLd6dEdlvvtW+CgxRwWRXbJ7qQei8ZVVOzWzy+Wf+I/g8kC84
	r5b22CLmYH+t9jjDAJtcxB5cgDL/VkJt6s3jGsVxQyEyjeC8m4XcU8Wo
X-Gm-Gg: ASbGncvWm0QwLURG5RXZDDygLfiGLu+EdaRDHTAo55Z/VjiqbhfogfSnY4OXyGGgaPS
	IpRQgPprcWgJF/xDfjrtR69GXGscj5TQVnVYgUiUnESHSAmIi90TBdWhr5QYrLou/p219i3iuMU
	lKVCjEjU9onsYTzX9Lmh0J/ZDofj8UFq4T/ySu4l28qTxPOPyaIEi03khnhN1Kogj6XLR962VqF
	k7y//Bd7zLVFbum9x570j8Mq+/EpiIjrA3ojQ2yztXbwy1ffqIZlVMhfF7Pv0mLCfVpe4Mdy3qb
	oaCxBv463CTOJALGCQg8fJzkbrtkFZjL9NUc95OlGwI47ZqL8HnDbztohHs4urueaIg5TJuy/n5
	F5icKMPyDfHM7t4Obltmf+DLd0Lcbe8wNLBWMZzEFm1hQB+NC/c9zT8pRZLiq2v+nNh82fttH4h
	emiUxrAG73ROP+nNgoU6b5qsV7BU71N6ubwDdqAjYlCUn9S1d+U9aqwyp8yYt8maXCOz1ZefuG8
	Gqzvdr4ZyRxaycGF83aXI8V8A9tCwt2ZR4dWPncu0ZV9n0rHgNlbg==
X-Google-Smtp-Source: AGHT+IGKnATGAMZLZ7BfrzK+rb/mjrrF2BjsXgKd9+vxecCJZWw7vzWEChRRFBgO1QfKEyIV7kI6LA==
X-Received: by 2002:a17:907:6d0c:b0:b3f:5049:9e81 with SMTP id a640c23a62f3a-b726554c6fbmr23752866b.47.1762283754795;
        Tue, 04 Nov 2025 11:15:54 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723d3a336asm290222766b.7.2025.11.04.11.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 11:15:54 -0800 (PST)
Message-ID: <114f0b33-2c5f-4ae8-8ed8-e8bc7ef3dd2c@gmail.com>
Date: Tue, 4 Nov 2025 20:15:51 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org
References: <20251104145728.517197-1-ericwouds@gmail.com>
 <20251104145728.517197-4-ericwouds@gmail.com> <aQohjDYORamn7Gya@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aQohjDYORamn7Gya@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/4/25 4:53 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> +	switch (*proto) {
>> +	case htons(ETH_P_PPP_SES): {
>> +		struct ppp_hdr {
>> +			struct pppoe_hdr hdr;
>> +			__be16 proto;
>> +		} *ph;
>> +
>> +		if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
>> +			return -1;
>> +		ph = (struct ppp_hdr *)(skb->data);
>> +		switch (ph->proto) {
>> +		case htons(PPP_IP):
>> +			*proto = htons(ETH_P_IP);
>> +			skb_set_network_header(skb, PPPOE_SES_HLEN);
>> +			return PPPOE_SES_HLEN;
>> +		case htons(PPP_IPV6):
>> +			*proto = htons(ETH_P_IPV6);
>> +			skb_set_network_header(skb, PPPOE_SES_HLEN);
>> +			return PPPOE_SES_HLEN;
>> +		}
>> +		break;
>> +	}
>> +	case htons(ETH_P_8021Q): {
>> +		struct vlan_hdr *vhdr;
>> +
>> +		if (!pskb_may_pull(skb, VLAN_HLEN))
>> +			return -1;
>> +		vhdr = (struct vlan_hdr *)(skb->data);
>> +		*proto = vhdr->h_vlan_encapsulated_proto;
>> +		skb_set_network_header(skb, VLAN_HLEN);
>> +		return VLAN_HLEN;
>> +	}
>> +	}
>> +	return 0;
>> +}
>> +
>>  static unsigned int
>>  nft_do_chain_bridge(void *priv,
>>  		    struct sk_buff *skb,
>>  		    const struct nf_hook_state *state)
>>  {
>>  	struct nft_pktinfo pkt;
>> +	__be16 proto;
>> +	int offset;
>>  
>> -	nft_set_pktinfo(&pkt, skb, state);
>> +	proto = eth_hdr(skb)->h_proto;
>>  
>> -	switch (eth_hdr(skb)->h_proto) {
>> +	offset = nft_set_bridge_pktinfo(&pkt, skb, state, &proto);
>> +	if (offset < 0)
>> +		return NF_ACCEPT;
> 
> 
> Hmm.  I'm not sure, I think this should either drop them right away
> OR pass them to do_chain without any changes (i.e. retain existing
> behavior and have this be same as nft_set_pktinfo_unspec()).
> 
> but please wait until resend.
> 
> I hope to finish a larger set i've been working on by tomorrow.
> Then I can give this a more thorough review (and also make a summary +
> suggestion wrt. the bridge match semantics wrt.  vlan + pppoe etc.
> 
> My hunch is that your approach is pretty much the way to go
> but I need to complete related homework to make sure I did not
> miss/forget anything.

I understand. I've send this, because from v5 to v15 it moved towards
matching in the rule, but it all started with the fact that
nft_flow_offload_eval() uses nft_thoff().

At a bare minimum I need to address having pkt->thoff set correctly to
implement the software bridge-fastpath.

The fact that it also makes possible to match L3/L4 data in the rule is
also nice to have.

Hopefully you can take this in consideration during your review.

