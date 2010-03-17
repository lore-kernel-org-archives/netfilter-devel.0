From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/9] netfilter: xtables: slightly more detailed checkentry
 return values
Date: Wed, 17 Mar 2010 15:36:39 +0100
Message-ID: <4BA0E8F7.6050905@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-3-git-send-email-jengelh@medozas.de> <4BA0DB87.9040709@trash.net> <alpine.LSU.2.01.1003171443330.6297@obet.zrqbmnf.qr> <4BA0E450.3010902@trash.net> <alpine.LSU.2.01.1003171522020.6297@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59141 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab0CQOgm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:36:42 -0400
In-Reply-To: <alpine.LSU.2.01.1003171522020.6297@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-03-17 15:16, Patrick McHardy wrote:
>>>> I guess this makes sense, however iptables has special interpretations
>>>> of errno values. How will this interact?
>>> Since we are "just going back", the effect should be none - dig out
>>> an old iptables and kernel and you get the same environment.
>> No, we're now returning additional errno values from modules.
>>
>>> Well, libiptc prints a few specialized error messages for certain
>>> codes (cf libiptc.c, TC_STRERROR), else uses plain libc strerror.
>> That's what I was talking about. Unfortunately quite a few
>> of the reasonable combinations have special meaning, f.i.
>> TC_INIT/ENOENT, TC_INIT/EINVAL, ...
> 
> We need only be concerned about TC_COMMIT (which calls setsockopt
> with SO_SET_REPLACE, which leads to checkentry).
> 
> TC_COMMIT returns 0 or 1, with errno set from what setsockopt
> left - this will be the error code, as it is also just propagated
> inside the kernel, if I read it right.
> 
> So flow control ends up at iptables-standalone.c at the end
> and the errno code is just used for printing/choosing an error code.
> 
> If I missed something, please enlighten me.

OK that seems mostly fine. Basically its just the NULL/ENOENT
interpretation that might be confusing.
