Received: from smtp-out.freemail.hu (fmfe06.freemail.hu [46.107.16.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FBD56446;
	Tue,  7 Jan 2025 21:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736286491; cv=none; b=oCoBvM65Ss5AVMM/99K25mkvH2dDRUMGHzkBIAXgctGxxqwo20LRReXeAsM4Xibcls8h7qUj1X8DwM/SZ36wqiF9AJYcFq1V09RCFL0QvSkYxf5U5itHBwLR7n/YXvThwcdPF4LlZShJ3TuZzU6opjTSY+xUIbhJs/YcWB3o+NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736286491; c=relaxed/simple;
	bh=t+n+dSqcXSh20PF7rGAK11Zx3hEG02JNHuFZ7muGAoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1GtGSoeUtXONaNBTjloUHGHNz9uSA2ODBXiD7MlGLvxZ3CYVeupUqxG+Kd/vuGW4L0gFCkyhbE/0pNMGU2ifAw5bTvSRKnE0Uq3FXSN8mPSJKYJS9iqQvXejsJzTg7gpyGn87exYZTNsK2FLHMqiTnNu4pp1/SmflOdUlFj6eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=yhz79RQV reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="yhz79RQV"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSPZK1nLNzL1m;
	Tue, 07 Jan 2025 22:39:05 +0100 (CET)
Message-ID: <98387132-330e-4068-9b71-e98dbcc9cd40@freemail.hu>
Date: Tue, 7 Jan 2025 22:38:36 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] netfilter: x_tables: Merge xt_DSCP.h to xt_dscp.h
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
 <20250107024120.98288-2-egyszeregy@freemail.hu>
 <4fab5e14-2782-62d2-a32d-54b673201f26@netfilter.org>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <4fab5e14-2782-62d2-a32d-54b673201f26@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736285946;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=4733; bh=eApSBXF5H1/8Qcn5xrAeJwwSbwRStJkvYiXHl0m33kk=;
	b=yhz79RQVfUCuaC8qcl9EZh4qu4erLPL9TX5jMZejfnA8yJnvKT0kPxA/ffsSvFmJ
	iI0Zl+R2W05w6Ln/BQ7Rwm2quS4zrv0bNJyY0Lcm+58zboFKXqos1aoFaT54dtXBMsD
	Bt+uuYIlivZi0Tcxhp7L+L/ZxCDQE1NRoPx3XYDXqCV2bNBM4VXiHCmhYhN/3TqX0nF
	ab7Ap+jGQEL2PiBMXY/zDRAl66PUVfyDoil0fut9AuOhaS5nVkzxJxKJrRT6aQjF7z/
	HJ6VsA5wREINN8gY/ZXUwzEb3Ey/p4Tq2IBePivYlpfnrJrh1uB6cdkvAtuvjPHcPSt
	JMn80knYlg==

2025. 01. 07. 20:23 keltezéssel, Jozsef Kadlecsik írta:
> On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
> 
>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>
>> Merge xt_DSCP.h to xt_dscp.h header file.
> 
> I think it'd be better worded as "Merge xt_DSCP.h into the xt_dscp.h
> header file." (and in the other patches as well).
>   

There will be no any new patchset refactoring anymore just of some cosmetics 
change. If you like to change it, feel free to modify it in my pacthfiles before 
the final merging. You can do it as a maintainer.

>> Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
>> ---
>>   include/uapi/linux/netfilter/xt_DSCP.h | 22 +---------------------
>>   include/uapi/linux/netfilter/xt_dscp.h | 20 ++++++++++++++++----
>>   2 files changed, 17 insertions(+), 25 deletions(-)
>>
>> diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linux/netfilter/xt_DSCP.h
>> index 223d635e8b6f..fcff72347256 100644
>> --- a/include/uapi/linux/netfilter/xt_DSCP.h
>> +++ b/include/uapi/linux/netfilter/xt_DSCP.h
>> @@ -1,27 +1,7 @@
>>   /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> -/* x_tables module for setting the IPv4/IPv6 DSCP field
>> - *
>> - * (C) 2002 Harald Welte <laforge@gnumonks.org>
>> - * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
>> - * This software is distributed under GNU GPL v2, 1991
>> - *
>> - * See RFC2474 for a description of the DSCP field within the IP Header.
>> - *
>> - * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
>> -*/
>>   #ifndef _XT_DSCP_TARGET_H
>>   #define _XT_DSCP_TARGET_H
>> -#include <linux/netfilter/xt_dscp.h>
>> -#include <linux/types.h>
>> -
>> -/* target info */
>> -struct xt_DSCP_info {
>> -	__u8 dscp;
>> -};
>>   
>> -struct xt_tos_target_info {
>> -	__u8 tos_value;
>> -	__u8 tos_mask;
>> -};
>> +#include <linux/netfilter/xt_dscp.h>
>>   
>>   #endif /* _XT_DSCP_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
>> index 7594e4df8587..bcfe4afa6351 100644
>> --- a/include/uapi/linux/netfilter/xt_dscp.h
>> +++ b/include/uapi/linux/netfilter/xt_dscp.h
>> @@ -1,15 +1,17 @@
>>   /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> -/* x_tables module for matching the IPv4/IPv6 DSCP field
>> +/* x_tables module for matching/modifying the IPv4/IPv6 DSCP field
>>    *
>>    * (C) 2002 Harald Welte <laforge@gnumonks.org>
>> + * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
>>    * This software is distributed under GNU GPL v2, 1991
>>    *
>>    * See RFC2474 for a description of the DSCP field within the IP Header.
>>    *
>> + * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
>>    * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
>>   */
> 
> For the sake of history it'd worth to prepend the last two lines with
> something like: "Original version informations before merging the contents
> of the files:"
> 
This was a question a day ago, what do you like to see in each top of header 
files's comments. You did not care about it, you was not willing to say 
something which to be implemented, but now you have new ideas, please it is too 
late.

I will not plan to make any new patchset version just for this new thing which 
is just a cosmetic change not a critical bugfix. If you like to change it, lets 
do it, feel free to modify it in my pacthfiles before the final merging or apply 
your a new patch later.


>> -#ifndef _XT_DSCP_H
>> -#define _XT_DSCP_H
>> +#ifndef _UAPI_XT_DSCP_H
>> +#define _UAPI_XT_DSCP_H
> 
> In the first four patches you added the _UAPI_ prefix to the header
> guards while in the next three ones you kept the original ones. Please
> use one style consistently.
> 

Style consistently is done in the following files:

- All of xt_*.h files in uppercase name format (old headers for "target")
- All of xt_*.h files in lowercase name format (merged header files)

Originally, in these files there was a chaotic state before, it was a painful 
for my eyes, this is why they got these changes. In ipt_*.h files the original 
codes got a far enough consistently style before, they was not changed.

In my patchsets, It's not my scope/job to make up for the 
improvements/refactoring of the last 10 years.

>>   #include <linux/types.h>
>>   
>> @@ -29,4 +31,14 @@ struct xt_tos_match_info {
>>   	__u8 invert;
>>   };
>>   
>> -#endif /* _XT_DSCP_H */
>> +/* target info */
>> +struct xt_DSCP_info {
>> +	__u8 dscp;
>> +};
>> +
>> +struct xt_tos_target_info {
>> +	__u8 tos_value;
>> +	__u8 tos_mask;
>> +};
>> +
>> +#endif /* _UAPI_XT_DSCP_H */
>> -- 
>> 2.43.5
>>
>>
> 
> Best regards,
> Jozsef

