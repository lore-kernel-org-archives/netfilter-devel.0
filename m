Received: from smtp-out.freemail.hu (fmfe39.freemail.hu [46.107.16.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD02D13B58A;
	Tue,  7 Jan 2025 23:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736292853; cv=none; b=g6pbS+A4jmAgWHb5krfNdPpJvk+6f87aj9C12rpcWWtvEIHCYgmS/rsjAnRESSwK4F2XnvGgWgh92rAvhSBn6iaAdOctJqikmA1imScXhzOxenntNC8MljqT+26hCBoEV96SdAedT6wB9b5FNz3R4snsVUFjqE/EsK/v1oI6JBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736292853; c=relaxed/simple;
	bh=bonpXxrJ0xaABuIWeP1IuxzJgFfghUGO4YXwb9D2hDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E6VG6iNJPwFbUwngIrG87bzmOBuJRHRhKpZ1g67cXxKtGeeo2imOL+0QbgTcTWxfbb84E/tWlkY25jVz3dyeUc8b88qdDiLaTcLlO21+axe1myYF9xLbBbG/nzFEi0pqXrNWMN+mn33l2MNaP0rrc8loxmkIszFWroku87Y0I2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=0q/uzL8d reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="0q/uzL8d"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSRwD2DwYzc9m;
	Wed, 08 Jan 2025 00:24:44 +0100 (CET)
Message-ID: <283ffe91-5181-4544-8913-e4d1d6895d5c@freemail.hu>
Date: Wed, 8 Jan 2025 00:24:16 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] netfilter: Add message pragma for deprecated
 xt_*.h, ipt_*.h.
To: Jan Engelhardt <ej@inai.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, fw@strlen.de,
 pablo@netfilter.org, lorenzo@kernel.org, daniel@iogearbox.net,
 leitao@debian.org, amiculas@cisco.com, davem@davemloft.net,
 dsahern@kernel.org, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
 <20250107024120.98288-10-egyszeregy@freemail.hu>
 <1cd443f7-df1e-20cf-cfe8-f38ac72491e4@netfilter.org>
 <0e51464d-301d-4b48-ad38-ca04ff7d9151@freemail.hu>
 <n72qp2s8-00q1-3n32-n600-p59o2oqo7s43@vanv.qr>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <n72qp2s8-00q1-3n32-n600-p59o2oqo7s43@vanv.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736292285;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=1227; bh=N+FkWU7Mz3NOYleJmg4vXcLfo+S1arFspJ+RdUxvHPw=;
	b=0q/uzL8d788uNqOmgIIBGhGCLCuH+YJwfA8n4PyovTHhEVhdgYIdKg8mbMV+bOtv
	1eJLF5FfWNZWFZwQdLLI0rjd94tGao2/NOSIqZgx/rr+iyY8QuSXpIqIhD6LUnGBPmc
	N7+fl4Hfob0wPvjxmhTFTBGGH4mzmYnzg5ccWptYgB4yVQ6mygPyy4XaIpdm1v+r8GJ
	jJ8lM8OKWG01q+Rz4lvRi+3IW0ypMtfMWPizX9IHZHxB+PAGvqnztbCOi+lvRIyzbJB
	7mDlmAakZH4ZCsZ92NrnMa+T+L3PEILyzy0cfSQAD0uz9JXSGC1uSUBZgPWcbXc022e
	OXn4wLPJ+w==

2025. 01. 07. 23:38 keltezéssel, Jan Engelhardt írta:
> 
> On Tuesday 2025-01-07 23:06, Szőke Benjamin wrote:
>>>
>>> I still don't know whether adding the pragmas to notify about header file
>>> deprecation is a good idea.
>>
>> Do you have any other ideas how can you display this information to the
>> users/customers, that it is time to stop using the uppercase header files then
>> they shall to use its merged lowercase named files instead in their userspace
>> SW?
> 
> ``__attribute__`` is just as implementation-specific as ``#pragma``, so it's
> not really an improvement, but here goes:
> 
> ----
> struct __attribute__((deprecated("This header file is deprecated"))) dontusethisstruct {
> };
> extern struct dontusethisstruct undefinedstruct;
> ----

As i know it is a feature only in GCC, can it work with Clang compiler?
https://renenyffenegger.ch/notes/development/languages/C-C-plus-plus/GCC/__attribute__/deprecated/index

By the way it is perfect for through a warning for a deprecated struct, function 
etc ... only in GCC, but it is not ideal to use a simple header file include and 
the syntax of it is horryble. Usage of a generic #pragma message is more 
feasible in all compilers.

