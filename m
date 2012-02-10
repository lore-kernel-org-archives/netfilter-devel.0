From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: alignment problem with ebt_among on ppc
Date: Fri, 10 Feb 2012 18:39:18 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1202101838280.4760@frira.zrqbmnf.qr>
References: <Pine.LNX.4.64.1202030819151.17732@brian.int.clnt.de> <4F341D0E.3020209@pandora.be> <Pine.LNX.4.64.1202101314380.17215@brian.int.clnt.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org
To: Joerg Willmann <joe@clnt.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54837 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab2BJRjT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:39:19 -0500
In-Reply-To: <Pine.LNX.4.64.1202101314380.17215@brian.int.clnt.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-02-10 13:17, Joerg Willmann wrote:

> On Thu, 9 Feb 2012, Bart De Schuymer wrote:
>
>> Op 3/02/2012 8:21, joe@clnt.de schreef:
>>> What I've seen is that ebt_among extension of ebtables uses
>>> __alignof__(_xt_align) while the corresponding kernel module uses
>>> __alignof__(ebt_replace) to determin the alignment in EBT_ALIGN().
>>>
>>> These are the results of these values on different platforms:
>>>
>>> x86 x86_64 ppc
>>> __alignof__(_xt_align) 4 8 8
>>> __alignof__(ebt_replace) 4 8 4
>>>
>>> So I assume here we can see why ebtales fails to add rules which use the
>>> among extension.
>>>
>>> I'm using kernel 2.6.33 and ebtables 2.0.10-4
>>>
>>> Is this a known issue or are there any suggestions how to circumvent this
>>> problem?
>>> Thankyou very much.
>>
>> The userspace alignment was changed to _xt_align to fix an alignment issue on
>> a userspace32-kernel64 system (I think it was for an ARM device). So userspace
>> must be right. The kernel alignment macro needs to change so it also uses
>> _xt_align instead of ebt_replace. The userspace changes date back from June
>> 29, 2009.
>> Can you do these changes and provide a patch?
>>
> Thank you very much for the input. I did the proposed changes which solved my
> problem.
> See below for the patch (hopefully it's the way you expect it...)
>
> -#define EBT_ALIGN(s) (((s) + (__alignof__(struct ebt_replace)-1)) & \
> -		     ~(__alignof__(struct ebt_replace)-1))
> +#define EBT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) & \
> +		     ~(__alignof__(struct _xt_align)-1))

I think we had such a patch before (and the fact that it was not apply
probably tells some story), let me check the history books..
