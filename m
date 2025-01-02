Received: from smtp-out.freemail.hu (fmfe04.freemail.hu [46.107.16.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB5A1BD000;
	Thu,  2 Jan 2025 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735844554; cv=none; b=OBHYf1i03zAMHx9ZnnTPZYlxT57XpuHus0fV/pHJe+vHVNJ9q/XzMo+RSlRTVhVty7vb/Q9FZvIj0ZVLi7jOrhzXqd9Rgme7F+K1axkqYWow0hpMNX9kvnGCUlFi0thh5QRdte6CKkb1pr7GzXUsU/cyMF/3+9oswtiFZ0SLpG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735844554; c=relaxed/simple;
	bh=MFAChTCWnc4powJqPNhWIqRo1yBpNbyay9OeDGMt0MI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RM0B/jbHAKrY7lMr90xCjz3/FL0TaQX/M19EnhRafJWI2picYCb7garYLYNQdkO87DQl5BPoZ86YkxPOdNukU5FTadSg1naP7FJiV0THXuUEfCXM6VanLasKs3xrkAhMwbkgp96jrKYVRWFCyO8nNUpV0k30XenJxOOjVIb5hUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=aiRrqYGi reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="aiRrqYGi"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YPG846MfwzKNf;
	Thu, 02 Jan 2025 19:53:56 +0100 (CET)
Message-ID: <90b238e6-65d8-4a1d-b59b-e10445e4c61c@freemail.hu>
Date: Thu, 2 Jan 2025 19:53:36 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
To: Andrew Lunn <andrew@lunn.ch>
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250102172115.41626-1-egyszeregy@freemail.hu>
 <6eab8f06-3f65-42cb-b42e-6ba13f209660@lunn.ch>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <6eab8f06-3f65-42cb-b42e-6ba13f209660@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1735844037;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=3770; bh=pd7Epz5kInMqfCmFFe9kT7Ku2czQtdZ0efDTT061zoI=;
	b=aiRrqYGiiOKrXfnsGjuwiKy2Ih8vtHxz2/dQ9n4C5DgwpgSMlKzcRURjeHBjdDl2
	vQ6adgH31DLDYsofutjsiJt7I6sJNbFp6yno5aypU+YHn8a/50v1UckLoMbmTrB3UbU
	sWn/O7APq7BFxh70xvYBIndQA9lK9642wpDP3XIvchZPmcPSobxjmZpag1Ovt54zXGR
	Y4z+w/OvaCi2z+XSJQmkYCI5psTp2gmLktjE4TeXR63qCTLLjrFv2vAZYSzMhFUgfhq
	KdKphO14vlpOpd+9H7Bfc1GKUKAgqdsCE+ZiGk4RuebHtbbWLQ5vVyXKigqy2F/xOmO
	/kLqtJj9Aw==

2025. 01. 02. 18:39 keltezéssel, Andrew Lunn írta:
> On Thu, Jan 02, 2025 at 06:21:15PM +0100, egyszeregy@freemail.hu wrote:
>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>
>> Merge and refactoring xt_*.h, xt_*.c and ipt_*.h files which has the same
>> name in upper and lower case format. Combining these modules should provide
>> some decent memory savings.
> 
> Numbers please. We don't normally accept optimisations without some
> form of benchmark showing there is an improvement.
>   

Some of you mentioned in a reply e-mail, that is a good benefits in merging the 
codes. I do not have test result about it and i will no provide it.

>> The goal is to fix Linux repository for case-insensitive filesystem,
>> to able to clone it and editable on any operating systems.
> 
> This needs a much stronger argument, since as i already pointed out,
> how many case-insenstive file systems are still in use? Please give
> real world examples of why this matters.
> 

All of MacOS and Windows platform are case-insensitive. So it means, who like to 
edit Linux kernel code on them, then build it in a remote SSH solution, there 
are lot of them.

>>   delete mode 100644 include/uapi/linux/netfilter/xt_CONNMARK.h
>>   delete mode 100644 include/uapi/linux/netfilter/xt_DSCP.h
>>   delete mode 100644 include/uapi/linux/netfilter/xt_MARK.h
>>   delete mode 100644 include/uapi/linux/netfilter/xt_RATEEST.h
>>   delete mode 100644 include/uapi/linux/netfilter/xt_TCPMSS.h
>>   delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>>   delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_TTL.h
>>   delete mode 100644 include/uapi/linux/netfilter_ipv6/ip6t_HL.h
> 
> How did you verify that there is no user space code using these
> includes?
> 
> We take ABI very seriously. You cannot break user space code.
> 
>      Andrew

This is a minimal ABI change, which have to use lower case filenames for 
example: xt_DSCP.h -> xt_dscp.h

By the way this UAPI code part was changed 8-10 years ago last time. There are 
many ugly codes, ugly styles in headers, there are no any consístent code style 
and technical code/solution between the variouse header and soruce files (struct 
names, const values etc...).

Somebody used enum for bit mask defining, somebody else use macros for the same 
scope. It is terrible to refactoring it without any ABI breaking change. Because 
of the code quality is terrible wrong, it should be much better to take care 
about to improve it with a heavy refactoring instead of just says ABI breaking 
change is not possible. In this way, sooner or later the house of cards will 
crumble. For long term maintainability shall need a big code changes here in 
UAPI in order to provide a good and maintainable clean code. (independent from 
case-insensitive, it should be needed)

First sign of it which can not be solved without ABI issue:
I think, "linux/include/uapi/linux/netfilter_ipv4
/ipt_ecn.h" and "linux/include/uapi/linux/netfilter_ipv4
/ipt_ECN.h" can not be merged without ABI breaking because "IPT_ECN_IP_MASK" is 
implemented in both in a different technical way. (It should not have accepted 
+10 years ago in the codebase, and then our legs wouldn't be tremble now for an 
ABI change)


ipt_ecn.h: 
https://github.com/torvalds/linux/blob/master/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
ipt_ECN.h: 
https://github.com/torvalds/linux/blob/master/include/uapi/linux/netfilter_ipv4/ipt_ECN.h


In my merge i needed to drop "#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)" and i 
hope it will be replaced well with the other enum definition in any code.

merged ipt_ecn.h: 
https://github.com/Livius90/linux/blob/uapi-work/include/uapi/linux/netfilter_ipv4/ipt_ecn.h

> 
> ---
> pw-bot: cr

