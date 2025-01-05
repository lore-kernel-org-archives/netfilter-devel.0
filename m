Received: from smtp-out.freemail.hu (fmfe25.freemail.hu [46.107.16.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5012111CA9;
	Sun,  5 Jan 2025 21:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736111623; cv=none; b=qUHNb0talRMvxlNzCBQIpEZuvQyDZktfWnLZqXXC7/Omz35mM+jVff/zU4sx86ciWx0l7ZmL0DST9PIz+LJ7UGqzXpgcignxVdlvV7GFAJ3hsqwDTFevJivsxI6Cr0zFRBLl3aZHwSt0Iol/Mo3BITtWY6eEm3redvYztdcLL7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736111623; c=relaxed/simple;
	bh=0LP3xnzpAovJIxiGwNM8OVJnjOJlM0D+YgdycP+YY5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uVtXQuCG+wnWlyJYvwCfdPVzzNHkVk8VgcHFcvcR2Q3LRtnoS22mcv3w7i6qltFouJhXT49NEgLuFM/abEztqKEL26Ad97ZiIrT6UHOnuKktG+8HUr6M/KPSiaF1YOoP2zxXxV3SvFoNhuyQAf2rIdWvG6tJPOUMVMxDsncrVaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=mED5+lZl reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="mED5+lZl"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YR8tQ1wMLzMs6;
	Sun, 05 Jan 2025 22:03:42 +0100 (CET)
Message-ID: <fc5f6a8f-06f4-47bc-a659-82f5c0e2455b@freemail.hu>
Date: Sun, 5 Jan 2025 22:03:16 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] netfilter: x_tables: Merge xt_*.c source files which
 has same name.
To: Andrew Lunn <andrew@lunn.ch>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 kernel test robot <lkp@intel.com>
References: <20250104174155.611323-1-egyszeregy@freemail.hu>
 <83d71044-449a-4421-97b9-fc2dfcf3f283@lunn.ch>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <83d71044-449a-4421-97b9-fc2dfcf3f283@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736111024;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=7909; bh=8OQwVzGdrZu1/x9Tm8ry8OqO9k0cOMOMDhDl0ve11yk=;
	b=mED5+lZlOItCoPlaw8poWyNZ3BlaeHk5aVikj/nzxAGg6rtUo0z08RxITMrQLckX
	PYVNwWxf+aWAd9yVfBJGriU0GKqD3Zst6gLdZeBsnlCE8zi4k49wT/Mt+/c7mbPja/S
	y3QTPCYjUt8YnC162wCra3wvTjtAz4FIbao8zhk84Bsm+12Ka5Hc8OHIuuX5UJQyajS
	TERO+elA0WDQLKU7pV9QyxjOAPvq7pHoIxv3XQwau5x4Zoif+2/yAzV2MPLHVp34cIy
	l45U1ry4TkOMCAQ6XjF0JoAuN+a02j4lC/MGCp110mCdTSe3zuoPQyVZ+y/Bx5z1x5k
	k745ZJHogA==

2025. 01. 04. 23:24 keltezéssel, Andrew Lunn írta:
> On Sat, Jan 04, 2025 at 06:41:55PM +0100, egyszeregy@freemail.hu wrote:
>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>
>> Merge and refactoring xt_*.h, ipt_*.h and ip6t_*.h header and xt_*.c
>> source files, which has same upper and lower case name format. Combining
>> these modules should provide some decent code size and memory savings.
>>
>> test-build:
>> $ mkdir build
>> $ wget -O ./build/.config https://pastebin.com/raw/teShg1sp
>> $ make O=./build/ ARCH=x86 -j 16
>>
>> x86_64-before:
>> -rw-rw-r-- 1 user users 5120 jan 3 13.52 xt_dscp.o
>> -rw-rw-r-- 1 user users 5984 jan 3 13.52 xt_DSCP.o
>> -rw-rw-r-- 1 user users 4584 jan 3 13.52 xt_hl.o
>> -rw-rw-r-- 1 user users 5304 jan 3 13.52 xt_HL.o
>> -rw-rw-r-- 1 user users 5744 jan 3 13.52 xt_rateest.o
>> -rw-rw-r-- 1 user users 10080 jan 3 13.52 xt_RATEEST.o
>> -rw-rw-r-- 1 user users 4640 jan 3 13.52 xt_tcpmss.o
>> -rw-rw-r-- 1 user users 9504 jan 3 13.52 xt_TCPMSS.o
>> total size: 50960 bytes
>>
>> x86_64-after:
>> -rw-rw-r-- 1 user users 8000 jan 3 14.09 xt_dscp.o
>> -rw-rw-r-- 1 user users 6736 jan 3 14.09 xt_hl.o
>> -rw-rw-r-- 1 user users 12536 jan 3 14.09 xt_rateest.o
>> -rw-rw-r-- 1 user users 10992 jan 3 14.09 xt_tcpmss.o
>> total size: 38264 bytes
>>
>> Code size reduced by 24.913%.
> 
> The .o file is a lot more than code. It contains symbol tables, debug
> information etc. That is why i suggested size(1).
> 
> So in general, i'm sceptical about these changes. But we can keep
> going, in the end we might get to something which is mergable.
> 
> This patch is too big, and i think you can easily split it up. We want
> lots of simple patches which are obviously correct and easy to review,
> not one huge patch.

New patch series can be found here (split in 3 parts):
https://lore.kernel.org/lkml/20250105203452.101067-1-egyszeregy@freemail.hu/

If you like to see it in a human readable format you can found the diff in this 
link also:
https://github.com/torvalds/linux/compare/master...Livius90:linux:uapi

> 
> Also, this patch is doing two different things, merging some files,
> and addressing case insensitive filesystems. You should split these
> changes into two patchsets. Please first produce a patchset for
> merging files. Once that has been merged we can look at case
> insensitive files.
> 
> FYI:
> 
> ~/linux$ find . -name "*[A-Z]*.[ch]" | wc
>      214     214    9412
> 
> This is a much bigger issue than just a couple of networking files. Do
> you plan to submit patches for over 200 files?
> 

In case-insensitive filesystem porblem can be caused by only files which has the 
same name but one of written in lower case and other one written in upper case. 
So, not need to fix 200+ files.

These are the files which cause the problem in the repo (it is reported by git 
client):

warning: the following paths have collided (e.g. case-sensitive paths
on a case-insensitive filesystem) and only one from the same
colliding group is in the working tree:

   'include/uapi/linux/netfilter/xt_CONNMARK.h'
   'include/uapi/linux/netfilter/xt_connmark.h'
   'include/uapi/linux/netfilter/xt_DSCP.h'
   'include/uapi/linux/netfilter/xt_dscp.h'
   'include/uapi/linux/netfilter/xt_MARK.h'
   'include/uapi/linux/netfilter/xt_mark.h'
   'include/uapi/linux/netfilter/xt_RATEEST.h'
   'include/uapi/linux/netfilter/xt_rateest.h'
   'include/uapi/linux/netfilter/xt_TCPMSS.h'
   'include/uapi/linux/netfilter/xt_tcpmss.h'
   'include/uapi/linux/netfilter_ipv4/ipt_ECN.h'
   'include/uapi/linux/netfilter_ipv4/ipt_ecn.h'
   'include/uapi/linux/netfilter_ipv4/ipt_TTL.h'
   'include/uapi/linux/netfilter_ipv4/ipt_ttl.h'
   'include/uapi/linux/netfilter_ipv6/ip6t_HL.h'
   'include/uapi/linux/netfilter_ipv6/ip6t_hl.h'
   'net/netfilter/xt_DSCP.c'
   'net/netfilter/xt_dscp.c'
   'net/netfilter/xt_HL.c'
   'net/netfilter/xt_hl.c'
   'net/netfilter/xt_RATEEST.c'
   'net/netfilter/xt_rateest.c'
   'net/netfilter/xt_TCPMSS.c'
   'net/netfilter/xt_tcpmss.c'
   'tools/memory-model/litmus-tests/Z6.0+pooncelock+poonceLock+pombonce.litmus'
   'tools/memory-model/litmus-tests/Z6.0+pooncelock+pooncelock+pombonce.litmus'

>> -#endif /*_XT_CONNMARK_H_target*/
>> +#pragma message("xt_CONNMARK.h header is deprecated. Use xt_connmark.h instead.")
>> +
>> +#endif /* _XT_CONNMARK_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linux/netfilter/xt_DSCP.h
>> index 223d635e8b6f..bd550292803d 100644
>> --- a/include/uapi/linux/netfilter/xt_DSCP.h
>> +++ b/include/uapi/linux/netfilter/xt_DSCP.h
>> @@ -1,27 +1,9 @@
>>   /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> -/* x_tables module for setting the IPv4/IPv6 DSCP field
>> - *
>> - * (C) 2002 Harald Welte <laforge@gnumonks.org>
>> - * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
>> - * This software is distributed under GNU GPL v2, 1991
> 
> Removing copyright notices will not make lawyers happy. Are you really
> removing this, or just moving it somewere else.
> 
>> - *
>> - * See RFC2474 for a description of the DSCP field within the IP Header.
>> - *
>> - * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
>> -*/
>>   #ifndef _XT_DSCP_TARGET_H
>>   #define _XT_DSCP_TARGET_H
>> -#include <linux/netfilter/xt_dscp.h>
>> -#include <linux/types.h>
>>   
>> -/* target info */
>> -struct xt_DSCP_info {
>> -	__u8 dscp;
>> -};
>> +#include <linux/netfilter/xt_dscp.h>
>>   
>> -struct xt_tos_target_info {
>> -	__u8 tos_value;
>> -	__u8 tos_mask;
>> -};
>> +#pragma message("xt_DSCP.h header is deprecated. Use xt_dscp.h instead.")
>>   
>>   #endif /* _XT_DSCP_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter/xt_MARK.h b/include/uapi/linux/netfilter/xt_MARK.h
>> index f1fe2b4be933..9f6c03e26c96 100644
>> --- a/include/uapi/linux/netfilter/xt_MARK.h
>> +++ b/include/uapi/linux/netfilter/xt_MARK.h
>> @@ -1,7 +1,9 @@
>>   /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> -#ifndef _XT_MARK_H_target
>> -#define _XT_MARK_H_target
>> +#ifndef _XT_MARK_H_TARGET_H
>> +#define _XT_MARK_H_TARGET_H
>>   
>>   #include <linux/netfilter/xt_mark.h>
>>   
>> -#endif /*_XT_MARK_H_target */
>> +#pragma message("xt_MARK.h header is deprecated. Use xt_mark.h instead.")
>> +
>> +#endif /* _XT_MARK_H_TARGET_H */
>> diff --git a/include/uapi/linux/netfilter/xt_RATEEST.h b/include/uapi/linux/netfilter/xt_RATEEST.h
>> index 2b87a71e6266..ec3d68f67b2f 100644
>> --- a/include/uapi/linux/netfilter/xt_RATEEST.h
>> +++ b/include/uapi/linux/netfilter/xt_RATEEST.h
>> @@ -2,16 +2,8 @@
>>   #ifndef _XT_RATEEST_TARGET_H
>>   #define _XT_RATEEST_TARGET_H
>>   
>> -#include <linux/types.h>
>> -#include <linux/if.h>
>> +#include <linux/netfilter/xt_rateest.h>
>>   
>> -struct xt_rateest_target_info {
>> -	char			name[IFNAMSIZ];
>> -	__s8			interval;
>> -	__u8		ewma_log;
>> -
>> -	/* Used internally by the kernel */
>> -	struct xt_rateest	*est __attribute__((aligned(8)));
>> -};
>> +#pragma message("xt_RATEEST.h header is deprecated. Use xt_rateest.h instead.")
> 
> If you look througth include/uapi, how many instances of pragma
> message do you find? If you are doing something nobody else does, you
> are probably doing something wrong.
> 

#pragma message was already used in the kernel in other parts. This is the only 
way to tell customers, what is sustainable to use in the future, then for 
example 5 years later this ugly duplication can be removed in a real API 
breaking change which was tell and advertised in the codes nicely before. As 
other SW products handle it also.

>>   struct xt_tcpmss_match_info {
>> -    __u16 mss_min, mss_max;
>> -    __u8 invert;
>> +	__u16 mss_min, mss_max;
>> +	__u8 invert;
>> +};
> 
> If you want to change whitespacing, please do that in a separate
> patch, with an explanation why.
> 
> 	Andrew

