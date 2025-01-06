Received: from smtp-out.freemail.hu (fmfe07.freemail.hu [46.107.16.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C241DE2CC;
	Mon,  6 Jan 2025 12:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167345; cv=none; b=TelTNzlOJOOFnOVU/xfSK4qzD7jh2rfjnudAar/YIaa+rvu67GATsaqSUGewMFyWyjF3kHNMwLNanJbYGJo1pNNUKeCBGFxmEXLmblCU1KETUOF4m8VJ6BMk8MwGwg+5h+eIrFSEVzxkuWfWrDwEquAtZiBNJoqivh0VD3aWwBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167345; c=relaxed/simple;
	bh=m5xi1UE1L1q3JiErjoQYn/5mv930SegOrKMorf4zx6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LDBkKXLMN2RKZSolZbGoEYyRUj3ouLHSId44+6N69IViWRyR2zbaw1F9M22y60ngO9iGhpIDx8pn+oQ1P6hHX5z2u8beO5pgLC5Z4NnoezE5gI5YrEdHXjM8w1hpeYdllEec+roapqAApDkY/5zFeEO+NlaWgCvaaaQIiCZPvGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=1cJwILu3 reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="1cJwILu3"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRYjP46RYzKQ8;
	Mon, 06 Jan 2025 13:42:17 +0100 (CET)
Message-ID: <33196cbc-2763-48d5-9e26-7295cd70b2c4@freemail.hu>
Date: Mon, 6 Jan 2025 13:41:55 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
 lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org,
 amiculas@cisco.com, kadlec@netfilter.org, David Miller
 <davem@davemloft.net>, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250105231900.6222-1-egyszeregy@freemail.hu>
 <20250105231900.6222-2-egyszeregy@freemail.hu>
 <8f20c793-7985-72b2-6420-fd2fd27fe69c@blackhole.kfki.hu>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <8f20c793-7985-72b2-6420-fd2fd27fe69c@blackhole.kfki.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736167338;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=5295; bh=EMW5iYB2TliQXChb2PBgUubKkUz9ykJAqun8jlrmVTE=;
	b=1cJwILu3bFx9EYRahgYnGiNHFrArV46AM2XHi6jNbSAUYTxJZg85ukZToYNKmKiK
	+gWvKKDTzQXTqTp9O26+bKeNi5lyPOKKpJTaHQA/vsDuQfQf7rnW8nSS6EZRdvrhyQu
	yKEbGHXllEg68aBX09PuDxtMpasnNkwwA40FQpUhN8d67Jj9+ZRA0n6r/pp89b915mx
	Q2groMR6fxL6RcvLkY/Lwx3NGjfZUmEnp3r8y5EZ8z8T48dlk1E75uK66c2w2R/KEFG
	Tw4eG2Okb47hdcE7GttOqArpvai8HOa9rLKQXjNSYpG1bj8PSoBGs/nXM5B9GxzWQoc
	Ue3XkYP2QA==

2025. 01. 06. 9:19 keltezéssel, Jozsef Kadlecsik írta:
> On Mon, 6 Jan 2025, egyszeregy@freemail.hu wrote:
> 
>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>
>> Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
>> same upper and lower case name format.
>>
>> Add #pragma message about recommended to use
>> header files with lower case format in the future.
>>
>> Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
>> ---
>> include/uapi/linux/netfilter/xt_CONNMARK.h  |  8 +++---
>> include/uapi/linux/netfilter/xt_DSCP.h      | 22 ++--------------
>> include/uapi/linux/netfilter/xt_MARK.h      |  8 +++---
>> include/uapi/linux/netfilter/xt_RATEEST.h   | 12 ++-------
>> include/uapi/linux/netfilter/xt_TCPMSS.h    | 14 ++++------
>> include/uapi/linux/netfilter/xt_connmark.h  |  7 +++--
>> include/uapi/linux/netfilter/xt_dscp.h      | 20 +++++++++++---
>> include/uapi/linux/netfilter/xt_mark.h      |  6 ++---
>> include/uapi/linux/netfilter/xt_rateest.h   | 15 ++++++++---
>> include/uapi/linux/netfilter/xt_tcpmss.h    | 12 ++++++---
>> include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 29 ++-------------------
>> include/uapi/linux/netfilter_ipv4/ipt_TTL.h | 25 ++++--------------
>> include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 26 ++++++++++++++++++
>> include/uapi/linux/netfilter_ipv4/ipt_ttl.h | 23 +++++++++++++---
>> include/uapi/linux/netfilter_ipv6/ip6t_HL.h | 26 ++++--------------
>> include/uapi/linux/netfilter_ipv6/ip6t_hl.h | 22 +++++++++++++---
>> net/ipv4/netfilter/ipt_ECN.c                |  2 +-
>> net/netfilter/xt_DSCP.c                     |  2 +-
>> net/netfilter/xt_HL.c                       |  4 +--
>> net/netfilter/xt_RATEEST.c                  |  2 +-
>> net/netfilter/xt_TCPMSS.c                   |  2 +-
>> 21 files changed, 143 insertions(+), 144 deletions(-)
> 
> Technically you split up your single patch into multiple parts but not separated 
> it into functionally disjunct parts. So please prepare
> 
> - one patch for
>      include/uapi/linux/netfilter_ipv6/ip6t_HL.h
>      include/uapi/linux/netfilter_ipv6/ip6t_hl.h
>      net/netfilter/xt_HL.c
>      net/netfilter/xt_hl.c
>      [ I'd prefer corresponding Kconfig and Makefile changes as well]
> - one patch for
>      include/uapi/linux/netfilter/xt_RATEEST.h
>      include/uapi/linux/netfilter/xt_rateest.h
>      net/netfilter/xt_RATEEST.c
>      net/netfilter/xt_rateest.c
>      [I'd prefer corresponding Kconfig and Makefile changes as well]
> - and so on...
> 
> That way the reviewers can follow what was moved from where to where in a 
> functionally compact way.

First suggestion was to split it 2 parts, it is done, i split in 3 parts, it was 
more then needed. Your idea will lead to split it about to 20 patch parts, then 
the next problem from you could be "there are to many small singel patches, 
please reduce it".

If you like to see it in a human readable format you can found the full diff and 
the separted patches also in this link:
https://github.com/torvalds/linux/compare/master...Livius90:linux:uapi

Please start to use any modern reviewing tool in 2025 and you can solve your 
problem. In GitHub history view i can see easly what was moved from where to 
where in 1-3 mouse clicking, eg.: click to xt_DSCP.h then click to xt_dscp.h and 
you can see everything nicely. So it is ready for reviewing, please sit down and 
start work on it as a maintainer, It's your turn now.

https://github.com/torvalds/linux/commit/1ee2f4757ff025b74569cce922147a6a8734b670

> 
> Also, mechanically moving the comments results in text like this:
> 
>> /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> -/* ip6tables module for matching the Hop Limit value
>> +/* Hop Limit modification module for ip6tables
>> + * ip6tables module for matching the Hop Limit value
> 
> which is ... not too nice. The comments need manual fixing.

I do not know what small and compact "title" should be good here in the merged 
header files. Most simplest solution was to copy paste them and merge these 
titles text.

You should know it better, please send a new compact and perfectly good "title" 
text for all header files which are in the patchset and i can change them 
finally. I think it is out of my scope in this business.

> 
> I also still don't like adding pragmas to emit warnings about deprecated header 
> files. It doesn't make breaking API easier and it doesn't make possible to 
> remove the warnings and enforce the changes just after a few kernel releases.

I also still like adding pragmas, because duplicating these header files is not 
acceptable in SW dev/coding. It must have to be taught for the user how should 
use it in the future. This is a common way in any SW, for example Python or 
Matlab always send a notice in run-time for you which will be a deprecated 
things soon, when you import or start to use an old function or module.

Why don't you think it can not help breaking API easier? This is the bare 
minimum what you can do for it. Tell to user what should use instead, then 3-5 
years later you can change it finally, when 90-95% percent of your customers 
learnt to it and already started to use it in their userspace codes.

> 
> Best regards,
> Jozsef

