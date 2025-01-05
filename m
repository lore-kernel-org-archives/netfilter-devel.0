Received: from smtp-out.freemail.hu (fmfe07.freemail.hu [46.107.16.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAD31465BA;
	Sun,  5 Jan 2025 23:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736120687; cv=none; b=NU8wjQ9ITw8ceMzWJlEHNnFx+vUIoBZZpOHi5jhGv5zqoJDzmd5jOWV4UD3FPDcFj2k84NNy58U0slM3T04xQhliEGghdxZDzWJEsqCexHjtI2yodxVvLABeYKFIz5UmgR9xA4Lgf/aha8N2pY5tkS/VPrNBsd6Uw81f2gVj6SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736120687; c=relaxed/simple;
	bh=zvVMWlYuZMDelzUPeJa7bHncL/XnFyEnogNqnzkaIus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GeVT9pDx5ARjYwCIFNZY6mD76uEKycgDZUosiPpspBIRiog9O4/6JLwYYtGh+AvTrq3cy6EtGPIFrkK7PtRJyCh0PdmDDaw+J969WG+fLjxC/oXgRFTFZOBlnCztV5Tzhtn/gZaJqruLmQ2TNB6LGjP03uqCquWvWIrxUaNVCFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=JA6QUbul reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="JA6QUbul"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRDS42TRkzKnw;
	Mon, 06 Jan 2025 00:44:36 +0100 (CET)
Message-ID: <defa70d2-0f0c-471e-88c0-d63f3f1cd146@freemail.hu>
Date: Mon, 6 Jan 2025 00:44:11 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
To: Andrew Lunn <andrew@lunn.ch>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250105203452.101067-1-egyszeregy@freemail.hu>
 <43f658e7-b33e-4ac9-8152-42b230a416b7@lunn.ch>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <43f658e7-b33e-4ac9-8152-42b230a416b7@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736120677;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=1311; bh=9G+g0eBF3wfdx+kwUmqJIHPF2WU7tQ4kikQuat/LwyQ=;
	b=JA6QUbulmBsoQaKVnOhvWXKngGsg2lCKGakLBoi0esC0UHmysCRj6luCra5ZL/nw
	YLG9D0JOmdKG5+a5wcxddJsq2mjjrhmGtYxwoikqS/gbclqpk9Qr/kft14ED0nJA43s
	3hkvl5mVUY4KYtMRnzOpigUhlfzZW+d0NW6f1phvVzFG9Gs4Hk7LpiqzpySYdI5H51e
	YtXaa90IobdohN2VelDxgFt3eBKKKFYkL/uJ84sON6PQX+7tDNt2pChkQAnednqjqFU
	Mc8Sc5z7utXFv9VC40ji25k/+VMjwenm1JWEM6s3cmqo1TcXxptoFRQETP7EsOjh4k0
	nz+pzg3vPA==

2025. 01. 05. 22:27 keltezéssel, Andrew Lunn írta:
> On Sun, Jan 05, 2025 at 09:34:52PM +0100, egyszeregy@freemail.hu wrote:
>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>
>> Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
>> same upper and lower case name format.
>>
>> Add #pragma message about recommended to use
>> header files with lower case format in the future.
> 
> It looks like only patch 1/3 make it to the list.
> 
> Also, with a patchset, please include a patch 0/X which gives the big
> picture of what the patchset does. The text will be used for the merge
> commit, so keep it formal. 'git format-patch --cover-letter' will
> create the empty 0/X patch you can edit, or if you are using b4 prep,
> you can use 'b4 prep --edit-cover' and then 'b4 send' will
> automatically generate and send it.
> 
> https://docs.kernel.org/process/maintainer-netdev.html
> https://docs.kernel.org/process/submitting-patches.html
> 
>      Andrew

https://lore.kernel.org/lkml/20250105233157.6814-1-egyszeregy@freemail.hu/T/

It is terribly chaotic how slowly start to appear the full patch list in the 
mailing list website. It's really time to replace 1990s dev technology with 
something like GitLab or GitHub developing style can provide in 2024.

> 
> ---
> pw-bot: cr

