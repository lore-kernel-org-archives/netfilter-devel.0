Received: from mail.sgstbr.de (mail.sgstbr.de [94.130.16.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FE52F0671;
	Wed, 27 Aug 2025 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.130.16.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756314756; cv=none; b=vFk5rGb3vxcKyJP7rIdk3kAebcQNc86YuYv16Y66N4/3jVXMxbY+hLgI8fQ5oJKICwZYfb/J8scok5ZTxexksiMyDB9gbF0Zm/eHa58x62adUa3/vX/gnT1UjwhqFLIls865Ydwi3JodIafb5WeEgfK0W06xzxMrITj1eMFunZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756314756; c=relaxed/simple;
	bh=txdx1s8qFjy7bZfp6A8JGTnYvXtIPXGL5WG4K4rhisU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=NDYpxQcrK5ypyijzpuIiaT/S9TceRuAOKlMEWBu6GVZjuS7DK8JRcOQNFsPCzMZf2A+ObioupdbpPenh4Pl82+ZiE9LZb3tj5tmsoykgPudMf/6FJlNDsP//zxJ2xwWipVewykLwRqEbF7YCFQVR+pZ+fieXA/bnwWW/Fxhj01o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=blaese.de; spf=pass smtp.mailfrom=blaese.de; dkim=pass (2048-bit key) header.d=blaese.de header.i=@blaese.de header.b=NpZ8pKvV; arc=none smtp.client-ip=94.130.16.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=blaese.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blaese.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blaese.de header.i=@blaese.de header.b="NpZ8pKvV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blaese.de; s=201803;
	t=1756314743; bh=w3BdMIdi4mu9DyHfL8aSx5oylHchPpBewyakd30mWLQ=;
	h=Date:From:Subject:To:References:In-Reply-To:From;
	b=NpZ8pKvVCFxkJMlRixFVcLXUzjnRGo8w0dVLdGIJBMjrgSQIOzY3FQB//q91IToh/
	 SyYc4jvc7vkC2e+foi0G/zzwAOIfnGynoKsZNFvlqSU5OlBDanmbPnWsBYAKg/eMC0
	 AzPrebvWm8ePzreYUA2Kc8kfACRryB8j6XjZenPLE5sZeszEPb0ShXAnxxa3SwIq7N
	 cPSF1bS9EDioqr9caUID6FV3Sn3Fa0dZarrrMg+QI11mb2MIM7NXdnlUEu1sBiRalp
	 6qWhFGsa9/paWfjMzM/pxlj78uRGVC3lhRIXufwpbh7mshK1nimN+qiZRiSUa9MOdw
	 YraZHV3/Pe6Fg==
Received: from [IPV6:2a0b:f4c0:c8:6d:77a2:ec00:2663:dfdb] (2a0b.f4c0.00c8.006d.77a2.ec00.2663.dfdb.rdns.f3netze.de [IPv6:2a0b:f4c0:c8:6d:77a2:ec00:2663:dfdb])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: fabian@blaese.de)
	by mail.sgstbr.de (Postfix) with ESMTPSA id 5E16F24B485;
	Wed, 27 Aug 2025 19:12:22 +0200 (CEST)
Message-ID: <e1bf6193-d075-4593-81ef-99e8b93a4f74@blaese.de>
Date: Wed, 27 Aug 2025 19:12:19 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?Fabian_Bl=C3=A4se?= <fabian@blaese.de>
Subject: Re: [PATCH v2] icmp: fix icmp_ndo_send address translation for reply
 direction
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <20250825201717.3217045-1-fabian@blaese.de>
 <20250825203826.3231093-1-fabian@blaese.de> <aK7KYr5D7bD3OcHb@strlen.de>
Content-Language: de-DE, en-US
Autocrypt: addr=fabian@blaese.de; keydata=
 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
In-Reply-To: <aK7KYr5D7bD3OcHb@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27.08.25 11:05, Florian Westphal wrote:
> If the connection isn't subject to snat, why to we need to mangle the
> source address in the first place?
It is not limited to SNAT/MASQUERADE.
DNAT also affects which source address should be used, depending on the packet
direction.

With DNAT, the *destination* of the original direction is changed.
In the reply direction, this becomes the *source* address.

So reply packets of a DNAT connection are effectively subject to source address
translation. If icmp_ndo_send doesn’t account for this, rate limiting breaks,
which is exactly the problem this function was meant to solve.

> Don't understand this either.  Why these checks?
> AFAICS you can keep the original check in place, and then:
> 
> replace this
>>  	orig_ip = ip_hdr(skb_in)->saddr;
>> -	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
> 
> ... with ...
You are right: the code can be simplified. I'm not sure show this slipped through.
I will send an updated patch with this change — thanks for the suggestion.
However, the old check (IPS_SRC_NAT only) cannot be kept, because:
- Reply packets of a DNAT connection also need handling.
- Reply packets of a pure SNAT connection don’t need it, but replacing the
   address is a no-op in that case (tuple == skb address).

To avoid unnecessary translations, I suggested the direction-specific checks.
Another option is to simplify them to:

     if (!(ct->status & IPS_NAT_MASK)) { … }

This ensures we only ever touch connections with NAT, while keeping the code
straightforward.

> Without dnat, the reply tuple saddr == original tuple daddr.
> 
> With dnat, its the dnat targets' address (i.e., the real destination
> the client is talking to).
Yes, exactly.

> If you are worried about "dnat to", then please update the commit
> message, which only mentions masquerade/snat.
Correct — the change not only fixes SNAT-in-reply handling, but also adds
proper handling for DNAT in the reply direction, which was missing entirely.
I will update the commit message to reflect this.

Best regards,
Fabian
