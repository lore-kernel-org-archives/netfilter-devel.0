Received: from smtp-out.freemail.hu (fmfe28.freemail.hu [46.107.16.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DC6202C58;
	Wed,  8 Jan 2025 21:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736372351; cv=none; b=ae1tYb+MdU8t7RiTY+/9K+vWD1a83qj0/BXdneE3AOP6bueKOswLS5Jt2SIJiGOjsFOcGpBvPd4u/8yVsvxBUyT5TjrNOB6F727ijgNzFMI9BNsECda/Qa1uVQMkLuWjIp6gJGWn9uSXd3nypHKj6SpkHPPrMOtmk2AKGa3yDv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736372351; c=relaxed/simple;
	bh=msZrxrJ2w2+V2eW8BoxWZCFBMUfeH7jKpq8mo9QvVY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tg1LuB8F44wt4DxkhzqGKW9U229i5izEq7klsWtg4+/JiDgm0cvfVjHqhjplPRt4Y6jZdHUkjIkUCczpIYevXC7oNyjVp6kzTT8moTGEeLCAlmDjHFP4dRaw49seyRTzcW4PuN9Hktbtq0MGlN92Qj0hYCJUuOQLKVH3ym6p2V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=dVrVHayB reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="dVrVHayB"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YT1Wm0SJWz166P;
	Wed, 08 Jan 2025 22:39:00 +0100 (CET)
Message-ID: <8d25e36a-b598-4b18-896c-d0dcb7233800@freemail.hu>
Date: Wed, 8 Jan 2025 22:38:34 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] netfilter: Add message pragma for deprecated
 xt_*.h, ipt_*.h.
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
 <20250107024120.98288-10-egyszeregy@freemail.hu>
 <1cd443f7-df1e-20cf-cfe8-f38ac72491e4@netfilter.org>
 <0e51464d-301d-4b48-ad38-ca04ff7d9151@freemail.hu>
 <2b9c44e0-4527-db29-4e5e-b7ddd41bda8d@netfilter.org>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <2b9c44e0-4527-db29-4e5e-b7ddd41bda8d@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736372340;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=2558; bh=j1LCUzCb/lTdPMZPJ2sOeNhrpAI71sLmAcJs4gaJXV8=;
	b=dVrVHayBVVLNiC+xfzX0mKqQkiy0kZG+Gkiy3MdoWeCQVGYpgWr6A8+GdscMW3s/
	WglqXjDWFozMq3Khc5aRoR7pnnMwUwALT2B1wQSkxWpwf9qmlr2QwugVaBCW21dAyiB
	QjTvwGP5kseq/VrmTUjHASHwDTwgQ6y9F2lMDF1aR4aaZP3LszPdzMiSRLOG4a4M6qh
	mxDq35vCa/JGu47vSPhRMnMsj1zOMMBt+2jnGCkyFvt/C2Hj8DqNQZwuN6up2bMLQoe
	AYNQ/PfgmdVjJAcId1pW8NOA1KGeQT3x6ZxDm+lodx4+3Rs9WD0X2BMc1DfsEj8ODCO
	SA15+Z9Cig==

2025. 01. 08. 21:51 keltezéssel, Jozsef Kadlecsik írta:
> On Tue, 7 Jan 2025, Szőke Benjamin wrote:
> 
>> 2025. 01. 07. 20:39 keltezéssel, Jozsef Kadlecsik írta:
>>> On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
>>>
>>>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>>>
>>>> Display information about deprecated xt_*.h, ipt_*.h files
>>>> at compile time. Recommended to use header files with
>>>> lowercase name format in the future.
>>>
>>> I still don't know whether adding the pragmas to notify about header
>>> file deprecation is a good idea.
>>
>> Do you have any other ideas how can you display this information to the
>> users/customers, that it is time to stop using the uppercase header
>> files then they shall to use its merged lowercase named files instead in
>> their userspace SW?
> 
> Honestly, I don't know. What about Jan's clever idea of having the
> clashing filenames with identical content, i.e.
> 
> ipt_ttl.h:
> #ifndef _IPT_TTL_H
> #define _IPT_TTL_H
> #include <linux/netfilter_ipv4/ipt_ttl_common.h>
> #endif _IPT_TTL_H
> 
> ipt_TTL.h:
> #ifndef _IPT_TTL_H
> #define _IPT_TTL_H
> #include <linux/netfilter_ipv4/ipt_ttl_common.h>
> #endif _IPT_TTL_H
> 
> Would cloning such a repo on a case-insensitive filesystem produce errors
> or would work just fine?
> 

What is this suggestion, in ipt_ttl.h and ipt_TTL.h really? How it can solve and 
provide in compile or run-time information for the users about the recomendded 
changes? (It seems to me that you are completely misunderstanding the purpose of 
this message at this time.)


Listen carefully, this are the points/scope.

This patchset provide the following:
- 1. Merge upper and lowercase named haeder files in UAPI netfilter.
- 2. Merge upper and lowercase named source files in UAPI netfilter. (uppercase 
named files can be removed)
- 3. Keep the backward compatibility, there is no any breaking API changes yet.
- 4. Keep uppercase header files as just a "wrapper" for include same lowercase 
header files.
- 5. Provide a clear message for the UAPI's users that in the future should have 
to use the lowercase named files instead.

Later, for example when Linux kernel goes to 7.0 version, uppercase header files 
can be removed. Breaking API possibble when version of a SW is incremented in 
major field. Before, in first patchset, UAPI users were informed about what is 
better to use. So it can be a clear and slow roadmap to solve case-insensitive 
filesystem issue on this files.


> Best regards,
> Jozsef

