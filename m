Received: from smtp-out.freemail.hu (fmfe36.freemail.hu [46.107.16.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A561802AB;
	Tue,  7 Jan 2025 21:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736286572; cv=none; b=jtrEwpwPR1dJJ/LZM15JMYiTEeRaTvluXAuMNcX1OcW4kGQOS22cQWzdgVBG9bQZNNmsnkkxnFJ46HrdqIHEuMXSfZL8N1BaOX8rLvhp2GzHLaSB8rTh5VLeFMmUfQPa1SReRi0Bb5AcPGvT6Gu8dp17QcitToplAkZyFPbjnQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736286572; c=relaxed/simple;
	bh=UjzaIZ9cNSABdz4+5geIRAI88q3X1A9hZD0GHn07TYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FZDpixufaLG0vhvsuWoGGtk34ptzuho4Ve+Geqkl+Ch0kFJwg4tUOQXre7tOR+G76wdzn+FzNiWNT7r/mnr5miZe05lb1RWk8BfhrdUxbFcu7dAAiGFLpPfH79jeVc3zQq9AkIVVNosla+DCe1/mYICYYPhKp/NiH83s7uvTu/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=kUhQYXtH reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="kUhQYXtH"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSPp75QqpzhfK;
	Tue, 07 Jan 2025 22:49:19 +0100 (CET)
Message-ID: <f53d51a9-e6d6-4376-8601-420ac756b7af@freemail.hu>
Date: Tue, 7 Jan 2025 22:48:55 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] netfilter: iptables: Merge ipt_ECN.h to ipt_ecn.h
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250107024120.98288-1-egyszeregy@freemail.hu>
 <20250107024120.98288-6-egyszeregy@freemail.hu>
 <eb46258b-0fb2-c0be-f1aa-79497f3dc536@netfilter.org>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <eb46258b-0fb2-c0be-f1aa-79497f3dc536@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736286560;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=4406; bh=tNUCdlivEY1+/Xn3yNuxvZQNlQe57yfHUbtboowh3HQ=;
	b=kUhQYXtHJW2eoyg0qiLXV+cb/q3wQKWe3tYkgQv92H1mCQ4lHjrDPp3+RRdKkIXn
	sk4Ji5IdcLRH7A/zlfROIqO33PCz5fGeN0uNYfjDC2W/3ZIFcipUxeboCmpxE/gB8TU
	/e7mGVG1fitPU33aCNhX5h3UMkvHAdomPbWZAdk+0NzBFgdMoiul1JCsnKm6vnY0yZR
	fDdnU7X3AgB5DPDfX3xGluIKdyKtpFcLF6TLQE9lL7vKR9oIsreTkgRGOomVdcvic7i
	miccOaNFACbfkAUo2yNSU7UywreZaJEDL9eq1uLfAEglmlj3RlJbemq1TOXjw5ngLCS
	hZBuGhWziw==

2025. 01. 07. 20:26 keltezéssel, Jozsef Kadlecsik írta:
> On Tue, 7 Jan 2025, egyszeregy@freemail.hu wrote:
> 
>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>
>> Merge ipt_ECN.h to ipt_ecn.h header file.
>>
>> Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
>> ---
>>   include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 29 +--------------------
>>   include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 26 ++++++++++++++++++
>>   2 files changed, 27 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>> index e3630fd045b8..6727f5a44512 100644
>> --- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>> @@ -1,34 +1,7 @@
>>   /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> -/* Header file for iptables ipt_ECN target
>> - *
>> - * (C) 2002 by Harald Welte <laforge@gnumonks.org>
>> - *
>> - * This software is distributed under GNU GPL v2, 1991
>> - *
>> - * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
>> -*/
>>   #ifndef _IPT_ECN_TARGET_H
>>   #define _IPT_ECN_TARGET_H
>>   
>> -#include <linux/types.h>
>> -#include <linux/netfilter/xt_DSCP.h>
>> -
>> -#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
> 

If it is not dropped out in the merged header file, it will cause a build error 
because of the previous bad and duplicated header architects in the UAPI:

In file included from ../net/ipv4/netfilter/ipt_ECN.c:17:
../include/uapi/linux/netfilter_ipv4/ipt_ecn.h:17:25: error: expected identifier 
before ‘(’ token
  #define IPT_ECN_IP_MASK (~XT_DSCP_MASK)
                          ^
../include/uapi/linux/netfilter_ipv4/ipt_ecn.h:27:2: note: in expansion of macro 
‘IPT_ECN_IP_MASK’
   IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
   ^~~~~~~~~~~~~~~

Please spent more time then 10 mins about the reviewing and make some test build 
and you can see there was a conflict about how mades a fixed constant in the 
code -> It is a #define vs. enum issue.

Only one style should have been used before, and not mix them.

> The definition above is removed from here but not added to ipt_ecn.h, so
> it's missing now. Please fix it in the next round of the patchset.
> 
>> -#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
>> -#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
>> -#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
>> -
>> -#define IPT_ECN_OP_MASK		0xce
>> -
>> -struct ipt_ECN_info {
>> -	__u8 operation;	/* bitset of operations */
>> -	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
>> -	union {
>> -		struct {
>> -			__u8 ece:1, cwr:1; /* TCP ECT bits */
>> -		} tcp;
>> -	} proto;
>> -};
>> +#include <linux/netfilter_ipv4/ipt_ecn.h>
>>   
>>   #endif /* _IPT_ECN_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
>> index 8121bec47026..a6d479aece21 100644
>> --- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
>> +++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
>> @@ -1,10 +1,26 @@
>>   /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/* Header file for iptables ipt_ECN target and match
>> + *
>> + * (C) 2002 by Harald Welte <laforge@gnumonks.org>
>> + *
>> + * This software is distributed under GNU GPL v2, 1991
>> + *
>> + * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
>> + */
>>   #ifndef _IPT_ECN_H
>>   #define _IPT_ECN_H
>>   
>> +#include <linux/types.h>
>> +#include <linux/netfilter/xt_dscp.h>
>>   #include <linux/netfilter/xt_ecn.h>
>> +
>>   #define ipt_ecn_info xt_ecn_info
>>   
>> +#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
>> +#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
>> +#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
>> +#define IPT_ECN_OP_MASK		0xce
>> +
>>   enum {
>>   	IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
>>   	IPT_ECN_OP_MATCH_IP   = XT_ECN_OP_MATCH_IP,
>> @@ -13,4 +29,14 @@ enum {
>>   	IPT_ECN_OP_MATCH_MASK = XT_ECN_OP_MATCH_MASK,
>>   };
>>   
>> +struct ipt_ECN_info {
>> +	__u8 operation;	/* bitset of operations */
>> +	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
>> +	union {
>> +		struct {
>> +			__u8 ece:1, cwr:1; /* TCP ECT bits */
>> +		} tcp;
>> +	} proto;
>> +};
>> +
>>   #endif /* IPT_ECN_H */
>> -- 
>> 2.43.5
>>
>>
> 
> Best regards,
> Jozsef

