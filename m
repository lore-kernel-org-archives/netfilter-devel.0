Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608673E7150
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 11:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777376902; cv=none; b=EGghmmheZqVzKp/snH7u+kIgyalZna8SSEdpLdm/wYKm4TJZhM8LDWFYgjb4n0YOlN+zOdlL6x5fOpXcm54hfDNQFmbUjqxnyhoxDdPjaM/FZlOLI8jl/rZQO7zg4oZvEgO5Z4YlCDuRUHvfF5h2sD65s9qSZKfmFSWuywA9QYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777376902; c=relaxed/simple;
	bh=fo44eK1mjgu6SPlhUzz68aZT76S6cce0j6kpZs41AeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iWrYJuJCx0w5ydBBu+EF80EFOdiNjKVT71MgMTeowK5g6/nKTqVn9FTcmZPi+h0CGrrc6DBl4DJFFSrhiv1xJJLfdemL5by9ynMlgxoYKya4Utx76LUKPaxbC9K9lWg1/SSpksgMITotWOD2ZaX1oXP8NMwR1J7LDeHIwPxnGr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-445795cf6f1so1029261f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 04:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777376900; x=1777981700;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bTsNAjrH0UFxRflQYVr5GW5Csd6A2n7L+wVJmLEWCYw=;
        b=sk91q5/WBJIe83eEZQab9fhBkeckWLEDiqFDTgqGRf6TpOUBBSf3208uP78J8RyxYM
         OR0rRvv8x+3Hxuo8pYbPRHqV1cQ5nmEtO1QQ0dvhyckhQKjbaIGWg9wbNZ/HPkLnuBLn
         ztBOGwYtoIUgD2z1aTnDywZCg9N0Ddj9F+2lYroa9mvVudQpnrpeVq+P6ueLftkgTCyo
         IRBZQ2NwGn86mnAOs1Hf3At7z/C7smPrg9gmm31lM+T5xE888IVL0wFrK5zcMZiFjHfN
         wFceCGveUV50MUIb0qutpiq8rc3LzEwcqxNK9FZ4Pcfn2/IBf6npc6OB12u3PngQXwCH
         DRlQ==
X-Gm-Message-State: AOJu0Yz7pxNfgD12bWJT2aT5y6X1PTr/hp9pR4f9F0LBC7NybuZTExDC
	rUHaJRpl2FPegBuWqYPiLFs30jk3rjgUHvQYiLXUIoc+yvhDmurJYcXnDTdmnm+hbs0=
X-Gm-Gg: AeBDieu/KU/0dg5L7NHPotA87fGGHlrakYwksoUCJVe2uf/38iWs7wcX6mW3AtkxMBm
	G9dCRgWA9H3ihxf4h/LB+7p/eGwSEPhmf9N+RHB46F5ER4E93eBjLssQEj0ZDC4WQser0SSOkDm
	a4XJHOSP27KJUtSEGQFvQJOPddtzbTyxi6KCzH5hbRZ2mvhiOZdxIJ3sUhpHxpss24qhDFd1Tjh
	Oe8yR5BUUrznVRNWqzjpMo9ZUgAxYkTTANOSQXbB8btEs9t5VMY87rqr4Lze595jlW+Shmxl66e
	oj/d8kayMq2cT+3e1SSmEitqOSPQC7mlOdf2KPqKqgh1KzPiLX52/ONk4GNw/aMrpdfaBtrAJoA
	U8jOSQlHVShWsrNUORP8tSu5zo5Kw26d4DyOMlmmX8kInE/0Dq7JtnKR7033oXxUSMV10fMLpfD
	05c2jklcFUN9360U0tG6wYXyZTtiX5n5Rh538XYU2QEpVP4qTUHTpeDcltQswcbFK/64+zL30HF
	3jI6OjTxJzYSjO66aeicyTZgQCEN8nhGj5/zok0JCQHorqYgQaxAGFD1CM6ab4ArfI=
X-Received: by 2002:a05:6000:18a4:b0:43d:7e11:1b72 with SMTP id ffacd0b85a97d-44648f28e43mr5118800f8f.9.1777376899427;
        Tue, 28 Apr 2026 04:48:19 -0700 (PDT)
Received: from ?IPV6:2003:fa:af26:200:51a:ef03:a698:a1fc? (p200300faaf260200051aef03a698a1fc.dip0.t-ipconnect.de. [2003:fa:af26:200:51a:ef03:a698:a1fc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4464004edc8sm5904206f8f.37.2026.04.28.04.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 04:48:18 -0700 (PDT)
Message-ID: <91091356-7e7d-4664-bd20-67c70f23e655@grsecurity.net>
Date: Tue, 28 Apr 2026 13:48:02 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netfilter: nf_nat: avoid invalid nat_net pointer use
 on failed nf_nat_init()
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
 netdev@vger.kernel.org
References: <20260428090917.3851366-1-minipli@grsecurity.net>
 <afCFlxjOiEs2ouKY@chamomile>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <afCFlxjOiEs2ouKY@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28.04.26 12:01, Pablo Neira Ayuso wrote:
> On Tue, Apr 28, 2026 at 11:09:17AM +0200, Mathias Krause wrote:
>> --- a/net/netfilter/nf_nat_core.c
>> +++ b/net/netfilter/nf_nat_core.c
>> @@ -1187,6 +1187,16 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
>>  	struct nf_hook_ops *nat_ops;
>>  	int i, ret;
>>  
>> +#ifndef MODULE
>> +	/* If nf_nat_core is built-in and nf_nat_init() fails, dependent
>> +	 * modules like nft_chain_nat.ko may still call this function.
>> +	 * However, nat_net would be invalid, likely pointing to some other
>> +	 * per-net structure.
> 
> Hm, if nf_nat_init() fails, then nft_chain_nat should fail to load.

If nf_nat is a module, that is the case, yes. However, the failing case
had it built-in (CONFIG_NF_NAT=y) and there's little the kernel can do
when some init function fails -- the code and data will still be part of
vmlinux.

> 
> Maybe there is a different way to validate this dependency?

Yeah, maybe. Maybe move the 'nf_nat_hook != NULL' test to
nft_chain_nat_init()? It's exported already, so this should work --
assuming the respective init functions get called in the right order
(nf_nat_init() first, then nft_chain_nat_init()). But that should be the
case, even if both are built-in, according to the order in
net/netfilter/Makefile.

It's a little fragile, though. In case the link order changes one day,
the test would lead to a false positive, making nft_chain_nat fail for
the wrong reason.

Also, I'm uncertain if the link order is really that deterministic wrt.
init functions for LTO builds?

Mathias

> 
>> +	 */
>> +	if (WARN_ON_ONCE(!nf_nat_hook))
>> +		return -EOPNOTSUPP;
>> +#endif
>> +
>>  	if (WARN_ON_ONCE(pf >= ARRAY_SIZE(nat_net->nat_proto_net)))
>>  		return -EINVAL;
>>  
>> -- 
>> 2.47.3
>>

