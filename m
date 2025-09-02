Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D54220311;
	Tue,  2 Sep 2025 08:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756802940; cv=none; b=bQooFym3rdXIimzuZfEl4GhRi507mRuBJHnLBQ99Z2vg+GvW5b5RRgfJAhW4zVsx/iT8cIQ8R6qBDk+LgonBtZg8ftIZcw+qcEkY2rKFT1s8nLIurW/5uV3a+V4IpSMOnSLgzEqQej5ZVv+dc7nhP9WoAMd5op4wRy2eUVMpr+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756802940; c=relaxed/simple;
	bh=2wVL7DUI0EjgOovlyJtaHodUa4Nb7PkMiJ+oBK/yrAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+cjIveC6fwZluZZf+JnWD1vJybUQAm0UIBAg0CoFgbceUVJ5mO1RHOreUzfLKdnMrH/Uqam7R4GaBbR/j+HIzjv7EGAXDvYQIiAdRp0Ml3seVrHvXrVdcQqVVQ5eh6qa7uBkjbbtPNHEF+tRSQbdrFLBgTkFpeAXnyoJberh5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PwcoTwou; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PwcoTwou"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61cb9e039d9so10219720a12.1;
        Tue, 02 Sep 2025 01:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756802937; x=1757407737; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3u4DU53ZStZI8TtGH19n60e9se0poMcUbUdRTXQJkNU=;
        b=PwcoTwouuBAxJ/9VaD99VzHWxeWd72OPupu9EG/wTmW1P1N7XCw9hFeJoAjpTyRGjJ
         UoBDQDIR3zY8mbwNDkuZr1+q9hkVqds5VhyZKt0rBskVIoBN2uAVgsDQ3eCZe1l32tI1
         6O8EoQITLciNdDcKjO0M6atJqYz/Gu48vja1944IPIfDTOCBSJ3hwaVhfuR+9CCUxiW8
         brrXdqbtD1uU4Uad5JUbAgAR/9YREsil4jjBz/83qrr1otqhJXwvdxk6bWYT6VhLRS1A
         GCnxyIHC7RwSMDAVDQePLX+4h/ywmNEv2Lrx8eP45CsRGLi6J7qb/MhSw5O+dx30BrDS
         3ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802937; x=1757407737;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3u4DU53ZStZI8TtGH19n60e9se0poMcUbUdRTXQJkNU=;
        b=FJe+MTQIOSpsPAb09n9JDMw8LKS3FWq+oGDhCq38ZS59UUGv0AhHQ3zRMOX0lnRj7o
         wumtQWg+Vqk7y+G9kqwtKw2z6E6jnmUn8nPoEHtz55BQwrG2dmvQAGP9k9z3xw40t6/0
         j9XwZ6ZpItSOf7ValYS98JVUvqCX454MRnynVu4zs2fXND9isozywh+AC23/mQ2Nsrkq
         XrR7OTyxO7WPBNI5k/RsATt22fz2+/YE1I2HjRZJ6qOqQDBsFtYjcYU9gu0fVYexyg6A
         GNczkRTnkn9ZVGeFnHsUie5CeDEv/HX4t2o/BqSnk7gY7B2+S8Zz3+FisFGapZQ6Iv6i
         9fAA==
X-Forwarded-Encrypted: i=1; AJvYcCVqSneZabwU/hednqqjGNCEe1BIm3TDmHmz2Q4wTiqDC2yAOE3Uyadi80HzB/iqZiZo2P8SzGJogDOQH2wedCSD@vger.kernel.org, AJvYcCWPShB/wFDoiqZVNBBoy9HoTzMW6e8/5Z4ZWpFmRG4S+a7PAysFNya5o1+RhyVktBsafuPHKOA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwT0qd3iqVjIiibL4xO0X/rNnZuIa+f3621V+58XWN5YBQxuh5N
	rcEq68aFrQ6DbTXR94VEyhvKgVHscKFKCTRTM3IYIHqL7Y2FlAfGkxeJ
X-Gm-Gg: ASbGncswQrsimnX1UmJ8YWDRbnbttJqtkLFfzMl3k+Jry5TvFTgVf/zLdVGtK9Wq61O
	uLsNR3BLYOjgX4PeokAYiN5wpEw4B//nfqEc+dhnhm9StaTgx+mztHcIbwNQdH52fAbqnXWk/2n
	qzHiaDlpVkuy2S11CXblH8qQMzGcqDstPTwonPbWsJhvbQvW76cfP3YGBGgM23GsnpbZ42OU1Bd
	7kr68JjIu9bjspq0B0WQcWYmTjihjraGisYRVlz58MkSSXQ9h32hbF5Jwo8tu9KJhO1HwSrY1cr
	IX1bwNhExChkcUqDcF2BokUfj1CGSuawrsZhBR1gQdpBfTRbC9sZHJ86NPdmVX1oWeGTj4v1pOE
	0O2hAEY/dwEwgnRIkva8FCRe8SEq4CU+CTEJ329ZBNeNc1OSiDF0M0q9FJQWzwlNhO1ULga2oKr
	OZrUpPwBFzEJIJPFAbQRfmXEgEg4e5DXeVPs+OmB+n9aw5pp5sA2XGrmmRbLbjcGDDw9qFZkqjm
	HjeOxttWeA5Ys6He9WOMjp3n4oz8sTh0HZ73OLwLVNzCFYhM3khuw==
X-Google-Smtp-Source: AGHT+IGnk+M6JtRt1++JxUrcqAy/3+2qIzpIG/SKfC/t/CmkS+op4CWifCvXgv07BmglGVSJS50K7g==
X-Received: by 2002:a05:6402:4414:b0:61d:3dad:228d with SMTP id 4fb4d7f45d1cf-61d3dad22c7mr8400226a12.13.1756802937232;
        Tue, 02 Sep 2025 01:48:57 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc1c7dfesm9141306a12.7.2025.09.02.01.48.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:48:56 -0700 (PDT)
Message-ID: <2d207282-69da-401e-b637-c12f67552d8d@gmail.com>
Date: Tue, 2 Sep 2025 10:48:55 +0200
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
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
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
> 

Hi Florian,

Did you get any information on how to handle this issue?

>> I haven't found where yet, but It seems nft is checking skb->protocol,
>> before it tries to match the ip(6) saddr/daddr.
> 
> Yes, userspace inserts this, see 'nft --debug=netlink add rule bridge ..'

