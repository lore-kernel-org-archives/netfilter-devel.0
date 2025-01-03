Received: from smtp-out.freemail.hu (fmfe07.freemail.hu [46.107.16.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5ED33DF;
	Fri,  3 Jan 2025 21:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735940890; cv=none; b=gggS0GqAZbVRVZxMk2yuZrPOJQfFYY41VtloUHkb1Q0+IqxbWvNzp1Rt68vKyI/YmmtwJl59CuNpZmuOsPINYu2TKtjI7bO5XkuNSV4EobZna0mi98wIwzJUkSypQerJd76VVkuvYSD94EadATmE6yQcq3sas+VfiFmAP2W3kwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735940890; c=relaxed/simple;
	bh=hR+6zQWBJsXnenEuboEy9Ua3VpOk3gzfeBnbGXrfmQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UzOvdvDEIz15CJ3F6M6/ijLoozN9iPq0AS6lZYfruwqsAGm97JF2wxPWt6Rjw4EnZg4E+OOD4LYa0+Zbvh33cq/WxDD21RbExECZVB83SKUqbfR6e7PGuYCxaLi5TY8mSbhb5mkAzk2P5rVPrrrKNp4+EWnqHyihAq1m5ftvzC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=uZk81Uo/ reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="uZk81Uo/"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YPxnc5RpvzJwr;
	Fri, 03 Jan 2025 22:40:20 +0100 (CET)
Message-ID: <19509642-1bef-4573-a4fe-d3cb16e97fb2@freemail.hu>
Date: Fri, 3 Jan 2025 22:39:55 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
To: Andrew Lunn <andrew@lunn.ch>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250102172115.41626-1-egyszeregy@freemail.hu>
 <6eab8f06-3f65-42cb-b42e-6ba13f209660@lunn.ch>
 <90b238e6-65d8-4a1d-b59b-e10445e4c61c@freemail.hu>
 <31331e58-bc0a-427b-8528-52448764a91e@lunn.ch>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <31331e58-bc0a-427b-8528-52448764a91e@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1735940421;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=2813; bh=OzTD4sULtZqsy2WlPu2w6i+mUdi8x06ZYJNkLWquh9M=;
	b=uZk81Uo/YapNllD2hPVp/y2YX0hK6EU68bhxv72jAoQkqlK/LzV7ilWK7Jr29xFU
	ilmnyqBdAqOwq6bb325iU/XWeqTwW6M/BBNC05BTArCo/K5KDVr3FPLD6qlmhFf7R2P
	6yTOGAjjPvrBzruD/nJJWfpV1pfOakOLqT0oQsLnswWhj2xhcUBzv+0y2GrzSDJvLwH
	ev8Yd+/plsPnQuwIgBkXQIMd/l81Ny4aDDfOVaEfdpHBrZjehTy0Rclks7s8NfiIJK0
	XwfJ0ULQ443pEUZyZiZReniZgfbBdQ6mp9HaS/5KM0rpEqNSlpfNw7kf52ieYsT1bsr
	NVo80k7Eag==

2025. 01. 02. 21:22 keltezéssel, Andrew Lunn írta:
> On Thu, Jan 02, 2025 at 07:53:36PM +0100, Szőke Benjamin wrote:
>> 2025. 01. 02. 18:39 keltezéssel, Andrew Lunn írta:
>>> On Thu, Jan 02, 2025 at 06:21:15PM +0100, egyszeregy@freemail.hu wrote:
>>>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>>>
>>>> Merge and refactoring xt_*.h, xt_*.c and ipt_*.h files which has the same
>>>> name in upper and lower case format. Combining these modules should provide
>>>> some decent memory savings.
>>>
>>> Numbers please. We don't normally accept optimisations without some
>>> form of benchmark showing there is an improvement.
>>
>> Some of you mentioned in a reply e-mail, that is a good benefits in merging
>> the codes. I do not have test result about it and i will no provide it.
> 
> Try looking at the man page of size(1).
> 
>>>> The goal is to fix Linux repository for case-insensitive filesystem,
>>>> to able to clone it and editable on any operating systems.
>>>
>>> This needs a much stronger argument, since as i already pointed out,
>>> how many case-insenstive file systems are still in use? Please give
>>> real world examples of why this matters.
>>>
>>
>> All of MacOS and Windows platform are case-insensitive.
> 
> Windows is generally case magic, not case insensitive. When opening a
> file it will first try to be case sensitive, if that fails, it tries
> case insensitive, in order to be backwards compatible with FAT.
> 
>>>>    delete mode 100644 include/uapi/linux/netfilter/xt_CONNMARK.h
>>>>    delete mode 100644 include/uapi/linux/netfilter/xt_DSCP.h
>>>>    delete mode 100644 include/uapi/linux/netfilter/xt_MARK.h
>>>>    delete mode 100644 include/uapi/linux/netfilter/xt_RATEEST.h
>>>>    delete mode 100644 include/uapi/linux/netfilter/xt_TCPMSS.h
>>>>    delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>>>>    delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_TTL.h
>>>>    delete mode 100644 include/uapi/linux/netfilter_ipv6/ip6t_HL.h
>>>
>>> How did you verify that there is no user space code using these
>>> includes?
>>>
>>> We take ABI very seriously. You cannot break user space code.
>>>
>>>       Andrew
>>
>> This is a minimal ABI change, which have to use lower case filenames for
>> example: xt_DSCP.h -> xt_dscp.h
> 
> You are not listening.
> 
> You cannot break user space code.
> 
> That is the end of it. No exceptions. It does not matter how bad the
> API is. You cannot break it.
> 
>      Andrew

It should not break the API:
[PATCH v3] netfilter: x_tables: Merge xt_*.c source files which has same name.
https://lore.kernel.org/lkml/20250103140158.69041-1-egyszeregy@freemail.hu/

If you prefere more a human readable format: 
https://github.com/Livius90/linux/commit/8ff73d36125f9a48eac98fd17b51b11d8f73f5a0


