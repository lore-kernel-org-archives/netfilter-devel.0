Received: from smtp-out.freemail.hu (fmfe17.freemail.hu [46.107.16.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2398C15E8B;
	Wed,  8 Jan 2025 21:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736371135; cv=none; b=dzCRBlxUC2TQ/1ZX8zlAVh5gccC3Ew7JveVaQRHsAOaUK1jdXmxW6uYFbColO3FYBNcFuGzxvCMb6YYSNzlvw1retpLj68ZijrxIYxMrIE5IywhOGgrH3lo5MW/TK3khSEBhovNBuruoUGO/gLk/SEzbpTxBHKjpJ4b/Bn4OyZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736371135; c=relaxed/simple;
	bh=XJ+BkLNAiJGNwT8LWDYrGH/GfIxN1GPwJc5rfL/LaiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pe2PnZg7iVaSXWM+dmA4tZWMrSJ1fbI8NN3eRmUQXDJ1XJo3+tmucrByU4DlhoYtRsP3bZE49Tk2t3/K8aUngNPVwGM4Oi6Dcw2ANnGFgUZKkUlvbSB2slCSyVS5XjwReEdIzTChRcwZnbUoha/0rZs3+Hu80zchDahGCME1EEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=BDRXmwMV reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="BDRXmwMV"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YT14M4VtSzP6c;
	Wed, 08 Jan 2025 22:18:43 +0100 (CET)
Message-ID: <78947796-9eef-4c53-b467-d32a151fcc92@freemail.hu>
Date: Wed, 8 Jan 2025 22:18:18 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] netfilter: Adjust code style of xt_*.h, ipt_*.h
 files.
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
 <20250107024120.98288-9-egyszeregy@freemail.hu>
 <2962ec51-4d32-76d9-4229-99001a437963@netfilter.org>
 <4cf2e26b-2727-4b50-9ada-56a6be814dca@freemail.hu>
 <27838d8f-7664-fdb9-3f8a-5ca812acdf72@netfilter.org>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <27838d8f-7664-fdb9-3f8a-5ca812acdf72@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736371124;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=1335; bh=bpq+oKwux8IsTKiPuR7ie84o8Ned3POd9DiwKAiebQk=;
	b=BDRXmwMVoCsVxY3+KMSMPXg2EogN3zWuV29qwe6er2hgLM+6SR3gBczVs4z2yLPj
	K/LoPOTb9SMbv3XSwwM/HAz+d97PPRnCrd+wNwp4zWGpsC/ORp/uQ1rSCetkLs1GkLS
	hGKRO/g7VK11cpkajfym/DD4+DGu8v9hfB8K1Jm5nVKBFgsmh2R38N1ohzH7SXFJYXD
	/Hn7Auy2aeQ84cJHdtZ7zhzQD+g36BMVHsLmX4K6TaEOwmyGp6YdKFVxmJEQ+aJfNwa
	aE9XzvYCYwfdyU46ByeFNSNCMMndVxkSw6hLtONYDbqa0yNfRbqvErboWaJY7wwifOT
	UG28JNPPEw==

2025. 01. 08. 21:20 keltezéssel, Jozsef Kadlecsik írta:
> On Tue, 7 Jan 2025, Szőke Benjamin wrote:
> 
>> 2025. 01. 07. 20:39 keltezéssel, Jozsef Kadlecsik írta:
>>> On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
>>>
>>>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>>>
>>>> - Adjust tab indents
>>>> - Fix format of #define macros
>>>
>>> I don't really understand why it'd be important to use parentheses
>>> around plain constant values in macros. The kernel coding style does
>>> not list it as a requirement, see 12) 4. in
>>> Documentation/process/coding-style.rst.
>>
>> If it would be more than just a const value, parentheses is a must have
>> thing for it (now for it, it is not critical to have it but better to
>> get used to this). This is how my hand automatically do it, to avoid the
>> syntax problem in this coding.
> 
> Are you going to "fix" this "issue" in the whole kernel tree?
> 
> If yes, then please propose changes to the coding style documentation as
> well.
> 
> If no, then please keep the macros as is because the changes would just
> introduce more different kind of notations in the source tree.
> 

I will keep it, sorry. It it not provide any different notation. It is just a 
parentheses for safe and defensive programming, it is not bad.

> Best regards,
> Jozsef

