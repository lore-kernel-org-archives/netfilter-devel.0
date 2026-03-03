Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3CB37104C;
	Tue,  3 Mar 2026 07:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523636; cv=none; b=mR+iFY+d0C8fSPGCx6yTf/mA1Nu7wzpHCqk4Z91o8he2mV6r+zugWzPr/ALdG7QtIchvlU0a1xvQzrA39w6itXHAH1+KVIkkCQBXvDq22Mh5lbSNbUCYw8jhTjiiqChGznxebenUWaD6xOzvZ0XIP81VQdVF57NDf3kJ3HCDbF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523636; c=relaxed/simple;
	bh=zRSElPdGzu2LhVP2rBWdcwsU9RSB/TLKssEPgoMAbDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ge59WAwqSlu29x38RK28V7UQ0wKu83lTdfMfH5vV8dKgpqdCVN0II+wZIQDZQbMJc5WLAYUW3xPVKIhYgBzoaExRpf0Miq55C+PggETEoTYqGSXYlD6vOIh5RZn7Y06GPKPm88O901O48uUZXhFcQPrLXB4fFa651VHTs8vmzew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=g9ZqU/r4; arc=none smtp.client-ip=188.68.63.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="g9ZqU/r4"
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4fQ6tk2b2cz43yp;
	Tue,  3 Mar 2026 08:31:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1772523102;
	bh=zRSElPdGzu2LhVP2rBWdcwsU9RSB/TLKssEPgoMAbDs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g9ZqU/r4vaYO2B0cvIABz5KVVrZQngeGOCAdUM3cqpLFV7QV4ubAjp/5ZTsFCANNd
	 H0BwVl/NzRWMR8Ffhp00gmMUwNm8v8cTHg2M+Ki/AOjz3kUrw5bNxpRSBRwvURDp4+
	 GBVyYoQlJ/ACOZRvkbZ9ukdNhgOaqztGUCrOb1Z7iS9BOXDJAeXKemJaKa8MxSUt7O
	 jPNDkZE0GuTonD+nsMrcqNEojHZ+drAYVHkG9SF0kH7qNS4fz6q6/oQ7SnXkLJEwOr
	 JCtzwNnxj/DyUU4ji3DLdBVSj6V0fJ+UUReKiE9G5yCIohIaMNqxiNffR/o5K30EFP
	 v9o+JeCbn1HPw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4fQ6tk1pt6z43xB;
	Tue,  3 Mar 2026 08:31:42 +0100 (CET)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4fQ6th2Yfjz8sgW;
	Tue,  3 Mar 2026 08:31:40 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 61E9961742;
	Tue,  3 Mar 2026 08:31:39 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <d43b9da4-99ee-4516-9bec-71a9de19618e@leemhuis.info>
Date: Tue, 3 Mar 2026 08:31:39 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables [resolved]
To: Jindrich Makovicka <makovick@gmail.com>, Genes Lists
 <lists@sapience.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, coreteam@netfilter.org,
 netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 stable@vger.kernel.org, regressions@lists.linux.dev,
 "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
 <143e1a402ad78dd7076516a6ceb637f378310b16.camel@sapience.com>
 <10537f2b74da2b8a5cb8dc939f723291db39ff84.camel@sapience.com>
 <2026022755-quail-graveyard-93e8@gregkh>
 <b231fcdb6c66a7b24dcef3ee5c35c5f612d5c1a7.camel@sapience.com>
 <9d110d860c0c7e110d018ea53a7666eba275da20.camel@gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <9d110d860c0c7e110d018ea53a7666eba275da20.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: 
 <177252309976.2451573.16092133249809936027@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 61E9961742
X-NC-CID: 9S29m2v6rwUma5J1nIVUGQwnAtflXylm8fpGCfC5j0uQeAzMcHs=

On 3/3/26 08:00, Jindrich Makovicka wrote:
> On Fri, 2026-02-27 at 08:39 -0500, Genes Lists wrote:
>> On Fri, 2026-02-27 at 05:17 -0800, Greg KH wrote:
>>> On Fri, Feb 27, 2026 at 08:12:59AM -0500, Genes Lists wrote:
>>>> On Fri, 2026-02-27 at 07:23 -0500, Genes Lists wrote:
>>>>> On Fri, 2026-02-27 at 09:00 +0100, Thorsten Leemhuis wrote:
>>>>>> Lo!
>>>>>>
>>>>>
>>>>> Repeating the nft error message here for simplicity:
>>>>>
>>>>>  Linux version 7.0.0-rc1-custom-1-00124-g3f4a08e64442 ...
>>>>>   ...
>>>>>   In file included from /etc/nftables.conf:134:2-44:
>>>>>   ./etc/nftables.d/set_filter.conf:1746:7-21: Error:
>>>>>   Could not process rule: File exists
>>>>>                  xx.xxx.xxx.x/23,
>>>>>                  ^^^^^^^^^^^^^^^
>>>>>
>>>>
>>>> Resolved by updating userspace.
>>>>
>>>> I can reproduce this error on non-production machine and found
>>>> this
>>>> error is resolved by re-bulding updated nftables, libmnl and
>>>> libnftnl:
>>>>
>>>> With these versions nft rules now load without error:
>>>>
>>>>  - nftables commit de904e22faa2e450d0d4802e1d9bc22013044f93
>>>>  - libmnl   commit 54dea548d796653534645c6e3c8577eaf7d77411
>>>>  - libnftnl commit 5c5a8385dc974ea7887119963022ae988e2a16cc
>>>>
>>>> All were compiled on machine running 6.19.4.
>>>
>>> Odd, that shouldn't be an issue, as why would the kernel version
>>> you
>>> build this on matter?
>>>
>>> What about trying commit f175b46d9134 ("netfilter: nf_tables: add
>>> .abort_skip_removal flag for set types")?
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> - all were rebuilt from git head 
>>   Have not had time to explore what specific change(s)
>>   triggered the issue yet.
>>
>> - commit f175b46d9134
>>   I can reproduce on non-production machine - will check this and
>> report back.
> 
> I had a similar problem, solved by reverting the commit below. It fails
> only with a longer set. My wild guess is a closed interval with start
> address at the  end of a chunk and end address at the beginning of the
> next one gets misidentified as an open interval.
> 
> commit 12b1681793e9b7552495290785a3570c539f409d
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Fri Feb 6 13:33:46 2026 +0100
> 
>     netfilter: nft_set_rbtree: validate open interval overlap
> 
> Example set definition is here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=221158

Does that problem happen with 7.0-rc2 as well? This is important to know
to determine if this is a general problem or a backporting problem.

Ciao, Thorsten

> Using nft from Debian unstable
> 
> $ ./nft --version
> nftables v1.1.6 (Commodore Bullmoose #7)
> 
> Regards,

