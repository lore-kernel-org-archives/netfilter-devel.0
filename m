From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/5] include: use C++ headers in C++ mode
Date: Sat, 13 Nov 2010 19:19:51 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011131918150.15190@obet.zrqbmnf.qr>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-3-git-send-email-jengelh@medozas.de> <4CDBE83D.30705@netfilter.org> <alpine.LNX.2.01.1011111358370.13616@obet.zrqbmnf.qr> <4CDBEC7C.8030107@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35043 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab0KMST4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Nov 2010 13:19:56 -0500
In-Reply-To: <4CDBEC7C.8030107@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-11-11 14:15, Pablo Neira Ayuso wrote:
>>>> -#include <stdio.h>
>>>> -#include <stdint.h>
>>>> +#ifdef __cplusplus
>>>> +#	include <cstdio>
>>>> +#	include <cstdint>
>>>> +#else
>>>> +#	include <stdbool.h> /* not in C++ */
>>>> +#	include <stdio.h>
>>>> +#	include <stdint.h>
>>>> +#endif
>>>>  #include <sys/socket.h> /* for sa_family_t */
>>>>  #include <linux/netlink.h>
>>>> -#ifndef __cplusplus
>>>> -#	include <stdbool.h>
>>>> -#endif
>>>
>>> A c++ example compiles fine without this here, so do we really need
>>> these extra ifdef's?
>> 
>> Well there is a purpose for having <cXXX> over <XXX.h> in C++. IIRC it 
>> was proper namespacing of Standard Library functions.
>
>I'm looking at other library code but I don't find any doing this. If
>you can point to any, I'd appreciate it.

/usr/include/gmp.h from libgmp-devel, for example.

