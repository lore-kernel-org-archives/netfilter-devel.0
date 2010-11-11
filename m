From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/5] include: use C++ headers in C++ mode
Date: Thu, 11 Nov 2010 14:15:40 +0100
Message-ID: <4CDBEC7C.8030107@netfilter.org>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-3-git-send-email-jengelh@medozas.de> <4CDBE83D.30705@netfilter.org> <alpine.LNX.2.01.1011111358370.13616@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46533 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489Ab0KKNPo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:15:44 -0500
In-Reply-To: <alpine.LNX.2.01.1011111358370.13616@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/11/10 13:59, Jan Engelhardt wrote:
> On Thursday 2010-11-11 13:57, Pablo Neira Ayuso wrote:
> 
>> On 11/11/10 00:08, Jan Engelhardt wrote:
>>> diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
>>> index 7094af2..37c502a 100644
>>> --- a/include/libmnl/libmnl.h
>>> +++ b/include/libmnl/libmnl.h
>>> @@ -1,13 +1,16 @@
>>>  #ifndef _LIBMNL_H_
>>>  #define _LIBMNL_H_
>>>  
>>> -#include <stdio.h>
>>> -#include <stdint.h>
>>> +#ifdef __cplusplus
>>> +#	include <cstdio>
>>> +#	include <cstdint>
>>> +#else
>>> +#	include <stdbool.h> /* not in C++ */
>>> +#	include <stdio.h>
>>> +#	include <stdint.h>
>>> +#endif
>>>  #include <sys/socket.h> /* for sa_family_t */
>>>  #include <linux/netlink.h>
>>> -#ifndef __cplusplus
>>> -#	include <stdbool.h>
>>> -#endif
>>
>> A c++ example compiles fine without this here, so do we really need
>> these extra ifdef's?
> 
> Well there is a purpose for having <cXXX> over <XXX.h> in C++. IIRC it 
> was proper namespacing of Standard Library functions.

I'm looking at other library code but I don't find any doing this. If
you can point to any, I'd appreciate it.
