Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9782853F1;
	Tue,  9 Sep 2025 09:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757409667; cv=none; b=BbHU9JSYkXXnHA+eNUjK7X7AQe/CmTwW5m/8ORIBCDqojsXQqZkDSzZDLDrJEBVvvk8XQ71wskTqtJSUmlu11Vm2QTyWdNkd/go8/lRkEGOZ/5GOsv7tDK/X2T975HMr+uEd7eM5zRC0R8jo0BQ6R5CyMLsd5tUytcXTqIYOopE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757409667; c=relaxed/simple;
	bh=WuzPPifEQj9HHVMmiWcrGA+eJ4Bw5fBh6CnZszj0M4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a53kbGS0JVCT4UaRCHfGnCUlDGikaYJvVnM2WHVil1r27HeEsl3Qgt4lFwrjoLOP/eVXubJCIzi+0+z4acMrKbe88/x/ZiHQdREcW7YljdSwN+873IlXMODl4FYCpLWq5r6e2Fc9geD9VY62I/GKIDEYutCmS32vvYWQo5Fj0ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKwPSCRv; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKwPSCRv"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b04163fe08dso913476466b.3;
        Tue, 09 Sep 2025 02:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409664; x=1758014464; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I2plwHTeZpARhSkuJ9Y2jpaZ80nzRFMhPMwl83KVZn8=;
        b=WKwPSCRv4qhpYn/3vXKFrZmHEm6+ORjQdXir1t8onbs04N/E1ba+AcBNJAltF0DyTL
         Lcm1Cc11zbslHK6NKJhkZhYUmByZSw16jMCQFzk5GFiV3gWe/TSD7zhjUSUmGuY820bZ
         XWxS3V9H251ZY234PmjXpYXkj3wAGXCcqE51s1qte9QL58L5HAObrwjCUUnPbZnw7JHR
         dh1qfSin9OKw1ssbbPSI2IBalGVpPi64SH2+B93nthzBZI6v8ps331ijPbCqXxhPu0eE
         v9xeAUj0Ocvqmn9dSZnbey6bQhvG/9lI+2d4oOMhRQfhIOcGFvW/uscCCmhFbPnrISrL
         sqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409664; x=1758014464;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2plwHTeZpARhSkuJ9Y2jpaZ80nzRFMhPMwl83KVZn8=;
        b=H74Ebm86H9Egi3klsmJcBi1uaHySZw76XlsRJiCsxJNqCBiUrmN80rlj8wRaw8KQGA
         EhwMeGu57F2RsYbfsamrY4IvgVBXxgX36ayODdFg6Jb3rBDHolF2QP58bIPiargctL46
         Uxvh5LoaJo+skUhMpCWMZO/7aIAEp2zTdygnyiXKh7+rz3P2SXLfSgwDUNF8gALn7jUg
         9xnWnnyv3NEPtGmcoeT4gEf3Es67fKfPxS52+N2XN9TQK8ffB5FSD2bc315kxr0otgLa
         BMQITVZ0ts0TmBKeTjeIsQmGY71xkPquUUarEqwy/jPgrboURdgbB+KsZ3E7Rb6uaBlh
         29nQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6a719hXgVB7Q8eVzp8i/ptSh/PgCbNpTuK2zlSkyhEmEQb4epUz276f4J5i+oy0benmy2TWw=@vger.kernel.org, AJvYcCV98jLeyiBnOOTbKoQ3Vn1o3C16VCzXdWPq/p8x4jTQfVUaSWZCw4MJrngHDsOobvISnnTDrG577PTYGpeAxT23@vger.kernel.org
X-Gm-Message-State: AOJu0YyM+CgWKNOLJl7rEGLF58H3BwClm9TDdRy0FDKbAM3qLOsIZWhY
	ImsUd0lxZm8k4ga9/PofRDrkWMO/bKw4DnoGry9AubZjZOmcTtIEWHVu
X-Gm-Gg: ASbGnctByiYw+jsAxulK2YBAyTpOMOKvtAqF0KO9dK1rlTQLHccTIbZF2IhP+Sy8B7O
	I8wWxWpa15HeEFqA5eaFR3iT56LE7goE7IBQk4xfUtBDdbya5gYYuOILXivBDyVytx2S8HbepAX
	KREZCU3YZj6TnSy2prjdLPO5TA3sIgBQJk7R8ySOYGpnU7MuRSGuqPOXl3ALjUuSerb5ShFI/BR
	SoqRP+auYo86f3lnPL8fU6AunjNplWOZy1U1yOYDMJYkB4F0RAjLFrHPDKW27h1uvCpa9LDBriG
	dJmLrPpsCdLHE+/LAA7MHzbz+o2KQ3/amqVxkCjAy0jnbg5sHXmnjYZQTzJuCSoLvTmoup95kOc
	hzTOl9k+rCTB3HoEsC8sWrf2oypt+dUuLF6GmJFsNFY33dHSjhp7s31AStocOaQ2poP/hXNpX5I
	oyWbT2QfoVfeGwdzjpC1avylDF1RWcWOXCalYxD5fqD449BVOgUmje51qgglvVCsTeQrhb69gDL
	hDYaYHtZi0yuNl6HJnX2J1+Aczmk5EunxfQESbOY24=
X-Google-Smtp-Source: AGHT+IGS/aJ996YKDZSFeqCFIy50lExzH/QqxhiTSTzJ51+0XLvp+rrAxwtXLJPKmlt+0wvatIZOCg==
X-Received: by 2002:a17:907:1c8c:b0:afe:ed71:80aa with SMTP id a640c23a62f3a-b04b16d6406mr1209586266b.57.1757409664029;
        Tue, 09 Sep 2025 02:21:04 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62bfe99ffcbsm904264a12.3.2025.09.09.02.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:21:03 -0700 (PDT)
Message-ID: <5334812c-37cb-42fa-9d53-402cf3d63786@gmail.com>
Date: Tue, 9 Sep 2025 11:21:02 +0200
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
 <20250708151209.2006140-4-ericwouds@gmail.com> <aLykN7EjcAzImNiT@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aLykN7EjcAzImNiT@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/6/25 11:14 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> +	__be16 outer_proto, proto = 0;
>>  	struct nft_pktinfo pkt;
>> +	int ret, offset = 0;
>>  
>>  	nft_set_pktinfo(&pkt, skb, state);
>>  
>>  	switch (eth_hdr(skb)->h_proto) {
>> +	case htons(ETH_P_PPP_SES): {
>> +		struct ppp_hdr {
>> +			struct pppoe_hdr hdr;
>> +			__be16 proto;
>> +		} *ph;
> 
> Maybe add nft_set_bridge_pktinfo() and place this
> entire switch/case there?
> 

Ok. At the end of nft_do_chain_bridge() I've added (after removing
skb->protocol munging):

	if (offset && ret == NF_ACCEPT)
		skb_reset_network_header(skb);

To reset the network header, only when it had been changed.

Do you want this helper to return the offset, so it can be used here?
Or do you think it is more clean to always reset the network header like so:

	if (ret == NF_ACCEPT)
		skb_reset_network_header(skb);

(Same question for nf_ct_bridge_pre())

>> +		skb_set_network_header(skb, offset);
> 
> I assume thats because the network header still points to
> the ethernet header at this stage?

That is correct.

