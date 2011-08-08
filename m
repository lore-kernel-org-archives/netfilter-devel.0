From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables-2.0.10-1: a build problem
Date: Mon, 08 Aug 2011 20:57:20 +0200
Message-ID: <4E403190.6090702@pandora.be>
References: <j01p1c$p9b$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Sergei Zhirikov <sfzhi@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:42048 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1HHS5Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:57:24 -0400
In-Reply-To: <j01p1c$p9b$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Sergei,

Thanks for the report.
I finally figured out I have to run "make headers_install" in the kernel 
source directory to get sanitized headers. That removes the need for 
this __EXPORTED_HEADERS__ stuff. I'll be releasing an updated version 
later this week.

Bart


On 18-07-11 19:03, Sergei Zhirikov wrote:
> Hi,
>
> Just want to let you know that I've encountered a small problem while 
> trying to build ebtables-2.0.10-1:
>
> cc1: warnings being treated as errors
> In file included from /usr/include/asm/sigcontext.h:5:0,
>                  from /usr/include/bits/sigcontext.h:28,
>                  from /usr/include/signal.h:339,
>                  from ebtables.c:29:
> include/linux/types.h:13:2: error: #warning "Attempt to use kernel 
> headers from user space, see http://kernelnewbies.org/KernelHeaders"
> make: *** [ebtables.o] Error 1
>
> The problem is that, even though "include/ebtables_u.h" defines 
> __EXPORTED_HEADERS__ to prevent exactly this from happening, 
> "include/linux/types.h" that throws the error is pulled in *before* 
> that indirectly via "signal.h". (I'm using gcc-4.5.1, glibc-2.12.1, 
> kernel headers 2.6.35.11.)
>
> To be able to proceed with the build I had to remove "#define 
> __EXPORTED_HEADERS__" from "include/ebtables_u.h" and "getethertype.c" 
> and add "-D__EXPORTED_HEADERS__" to CFLAGS instead, although i"m not 
> sure that was the best solution.
>
> -- 
> Regards,
> Sergei.
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Bart De Schuymer
www.artinalgorithms.be

