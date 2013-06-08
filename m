From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/5] include: use C++ headers in C++ mode
Date: Sat, 8 Jun 2013 15:38:14 +0200 (CEST)
Message-ID: <alpine.LNX.2.10.1306081534160.19100@nerf07.vanv.qr>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-3-git-send-email-jengelh@medozas.de> <1648235.41SkZRnnpI@storm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42980 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab3FHNiP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 09:38:15 -0400
In-Reply-To: <1648235.41SkZRnnpI@storm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2013-06-07 10:35, Thomas Jarosch wrote:

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
>
>The header "<cstdint>" is part of the C++11 standard.
>(http://www.cplusplus.com/reference/cstdint/)
>
>g++ forces you to enable C++11 mode if you want to use it.
>Tested with g++ (GCC) 4.4.4.
>
>Do we really need this? It compiles fine without
>the special headers inside the __cplusplus part.
>Pablo asked the same back in 2010 ;)

Add an extra condition:

#if defined(__cplusplus) && __cplusplus >= 201100L
