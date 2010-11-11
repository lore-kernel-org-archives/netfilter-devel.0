From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/5] include: use C++ headers in C++ mode
Date: Thu, 11 Nov 2010 13:59:29 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011111358370.13616@obet.zrqbmnf.qr>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-3-git-send-email-jengelh@medozas.de> <4CDBE83D.30705@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53475 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546Ab0KKM7a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:59:30 -0500
In-Reply-To: <4CDBE83D.30705@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-11-11 13:57, Pablo Neira Ayuso wrote:

>On 11/11/10 00:08, Jan Engelhardt wrote:
>> diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
>> index 7094af2..37c502a 100644
>> --- a/include/libmnl/libmnl.h
>> +++ b/include/libmnl/libmnl.h
>> @@ -1,13 +1,16 @@
>>  #ifndef _LIBMNL_H_
>>  #define _LIBMNL_H_
>>  
>> -#include <stdio.h>
>> -#include <stdint.h>
>> +#ifdef __cplusplus
>> +#	include <cstdio>
>> +#	include <cstdint>
>> +#else
>> +#	include <stdbool.h> /* not in C++ */
>> +#	include <stdio.h>
>> +#	include <stdint.h>
>> +#endif
>>  #include <sys/socket.h> /* for sa_family_t */
>>  #include <linux/netlink.h>
>> -#ifndef __cplusplus
>> -#	include <stdbool.h>
>> -#endif
>
>A c++ example compiles fine without this here, so do we really need
>these extra ifdef's?

Well there is a purpose for having <cXXX> over <XXX.h> in C++. IIRC it 
was proper namespacing of Standard Library functions.
