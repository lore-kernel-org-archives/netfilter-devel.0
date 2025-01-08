Received: from smtp-out.freemail.hu (fmfe13.freemail.hu [46.107.16.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0F1201264;
	Wed,  8 Jan 2025 21:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736370534; cv=none; b=BGBd/vYhSewa9pcB+o7HMuTOkcC0hyjoodjMjpJEwxyOvTPql+Ai+u1Cob9ZRrbQ9/zKzorR3Y37Qp2jmNvaGROudp3lxmehe+yMD8UutrDjks+v7X8S3hTCDT5Fwm7Sxw2zWDRIA7JJi7DJRqDpw1J2K3pNowKUFnARx6gC3YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736370534; c=relaxed/simple;
	bh=s9PoHsJJ5uKhGfHi/VLw5n2m/SWLZyx+4nmrvCVINiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tq4YEt0O125C6mGfLwuuWl3NETWs2wJmeALcg3vFne2B3HcaGlktj6AiqviXtZxpCDNJADKtROjK4EgyWQy3vhtfTOg63+iS2v8GXbzmHdH7lTVDWdtDpJ6TI8tB9VrFx401FbFgx+T3JIryeJ2wtRk8ChayrmnOhV+Hy6UZ9Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=MSiQ3s4s reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="MSiQ3s4s"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YT0rt5Pyfzt4W;
	Wed, 08 Jan 2025 22:08:46 +0100 (CET)
Message-ID: <a42bcc51-255f-4c52-b95c-56e562946d3a@freemail.hu>
Date: Wed, 8 Jan 2025 22:08:17 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] netfilter: x_tables: Merge xt_DSCP.h to xt_dscp.h
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
 lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org,
 amiculas@cisco.com, David Miller <davem@davemloft.net>, dsahern@kernel.org,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
 <20250107024120.98288-2-egyszeregy@freemail.hu>
 <4fab5e14-2782-62d2-a32d-54b673201f26@netfilter.org>
 <98387132-330e-4068-9b71-e98dbcc9cd40@freemail.hu>
 <d7190f89-da4d-40df-2910-5e87ca3cd314@netfilter.org>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <d7190f89-da4d-40df-2910-5e87ca3cd314@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736370527;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=4393; bh=bwRFfAxn+bHMRLWLMvqlcQcWt6ReJU6wnM30CnTqbbY=;
	b=MSiQ3s4sHVu5bOQewuTHu8e5w14H3sNlPsjqWrW1Wty7562/A2H9YhTSoGYj7TGO
	Tz3toogikjhh5rN/89+x6jI+nccRzKHkepo/4TmhC+pQ/FRbEhxB6S2l4bdO6WkFd0h
	6X+DO55zoe471eMyT51ZMMH0AOhdhQLuYUBUwNAsmi7mM4qYp6rUsRIWshE46FuAWns
	0aBSDNyBOddJp4ZqOGraIgY1kW8BiJtKnIg4AMIgP72RhfBHLag0ZgEcbbwOpLhm9mc
	RbtBAXfng7UxdYJkiY51hNLcGoVwBKYN1gEyz+ktstbS+YFPxEfMsKcur7+DN/Yz1AU
	tZkeAg5RAA==

2025. 01. 08. 21:11 keltezéssel, Jozsef Kadlecsik írta:
> On Tue, 7 Jan 2025, Szőke Benjamin wrote:
> 
>> 2025. 01. 07. 20:23 keltezéssel, Jozsef Kadlecsik írta:
>>> On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
>>>
>>>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>>>
>>>> Merge xt_DSCP.h to xt_dscp.h header file.
>>>
>>> I think it'd be better worded as "Merge xt_DSCP.h into the xt_dscp.h
>>> header file." (and in the other patches as well).
>>
>> There will be no any new patchset refactoring anymore just of some
>> cosmetics change. If you like to change it, feel free to modify it in my
>> pacthfiles before the final merging. You can do it as a maintainer.
> 
> We don't modify accepted patches. It rarely happens when time presses and
> even in that case it is discussed publicly: "sorry, no time to wait for
> *you* to respin your patch, so I'm going to fix this part, OK?"
> 
> But there's no time constrain here. So it'd be strange at the minimum if
> your submitted patches were modified by a maintainer at merging.
> 
> Believe it or not, I'm just trying to help to get your patches into the
> best shape.
>   

Holyday session is end, i have no time to refactoring and regenerate my patchset 
in every day, because you have a new idea about cosmetics changes in every next 
days. (this is why asked you before what you like to get, there was no any answer)
If you feel it is need, you can solve it as a maintainer, i know. If you found 
any critical issue i can fix it later, please start to look for them, but i will 
not waste my time with this usless commit name and header comment changes, 
sorry. It is a hobby, i am not a paied Linux developer which is supported by a 
company for this stuff.

As a maintainer you can solve this cosmetics things later in an extra patch or 
before the merging, lets do it.

>>>> -#ifndef _XT_DSCP_H
>>>> -#define _XT_DSCP_H
>>>> +#ifndef _UAPI_XT_DSCP_H
>>>> +#define _UAPI_XT_DSCP_H
>>>
>>> In the first four patches you added the _UAPI_ prefix to the header
>>> guards while in the next three ones you kept the original ones. Please
>>> use one style consistently.
>>
>> Style consistently is done in the following files:
>>
>> - All of xt_*.h files in uppercase name format (old headers for "target")
>> - All of xt_*.h files in lowercase name format (merged header files)
>>
>> Originally, in these files there was a chaotic state before, it was a
>> painful for my eyes, this is why they got these changes. In ipt_*.h
>> files the original codes got a far enough consistently style before,
>> they was not changed.
>>
>> In my patchsets, It's not my scope/job to make up for the
>> improvements/refactoring of the last 10 years.
> 
> But you are just introducing new inconsistencies:
> 
> --- a/include/uapi/linux/netfilter/xt_dscp.h
> +++ b/include/uapi/linux/netfilter/xt_dscp.h
> ...
> -#ifndef _XT_DSCP_H
> -#define _XT_DSCP_H
> +#ifndef _UAPI_XT_DSCP_H
> +#define _UAPI_XT_DSCP_H
> 
> however
> 
> --- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
> ...
>   #ifndef _IPT_ECN_H
>   #define _IPT_ECN_H
> 
> Why the "_UAPI_" prefixes are needed in the xt_*.h header files?
> 

Because it is in the UAPI region, don't you hear about the namespace? It is not 
only relevant for OOP languages.
https://www.educative.io/answers/what-is-a-namespace

Here is a good any nice example which also got _UAPI prefix in Linux kernel 
source: 
https://github.com/torvalds/linux/blob/master/include/uapi/linux/iio/buffer.h

By the way, in the API folder, all header should have have had a prefix 
otherwise it can cause conflict with a same non-uapi header like these:
include/net/netfilter
/xt_rateest.h -> 
https://github.com/torvalds/linux/blob/master/include/net/netfilter/xt_rateest.h
include/uapi/linux/netfilter
/xt_rateest.h -> 
https://github.com/torvalds/linux/blob/master/include/uapi/linux/netfilter/xt_rateest.h

In ipt_*.h, include guards are consistent (where i did any changes) but sure 
they should have to got that _UAPI prefix also. But this is not the scpoe in my 
patch, to rafectoring the full netfilter part of the UAPI in Linux, sorry. 
Please sit down and do it as a maintainer, there were no any relevant 
refactoring in the past 10 years in this code parts.

> Best regards,
> Jozsef

