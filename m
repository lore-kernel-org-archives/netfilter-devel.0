From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Mon, 08 Feb 2010 00:19:42 +0100
Message-ID: <4B6F4A8E.4040507@pandora.be>
References: <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr> <20100205140021.GB21611@Chamillionaire.breakpoint.cc> <4B6C5231.7040702@pandora.be> <20100205.100241.17593999.davem@davemloft.net> <4B6D69D3.7050008@pandora.be> <20100207223802.GA27427@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:33468 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab0BGXTs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2010 18:19:48 -0500
In-Reply-To: <20100207223802.GA27427@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal schreef:
> Bart De Schuymer <bdschuym@pandora.be> wrote:
>   
>> I can't tell how many of these systems are running ebtables but
>> considering most of the functionality has been working on a
>> user32/kernel64 system since 2004 I think it's safe to say that
>> Florian's patch will break a few systems.
>>     
>
> Yes, I had feared that.
> The way I see it we have a couple of alternatives.
>
> One way would be to disable the in-kernel ebt-compat layer for
> sparc64. Of course this assumes that this userland-side padding
> is only used on the sparc platform.
>
>   
>> I'm not familiar with the way this compat layer works, but is there a
>> standard way to ensure that old ebtables binaries don't use the compat
>> layer, while a new version of the userspace program would?
>>     
>
> It should be possible to figure out if we need to do fixups,
> because struct ebt_replace size differs (and the sockopt *len
> includes this value).
>
> In some cases this is as simple as "if (*len == sizeof(struct
> ebt_replace)". But even in case of EBT_SO_GET_ENTRIES it seems
> possible. We can try the "native" getsockopt call first, it should
> then error out early due to this check:
>
> if (*len != sizeof(struct ebt_replace) + entries_size +
>            (tmp.num_counters? nentries * sizeof(struct ebt_counter): 0)) {
> 				    sizeof(struct ebt_counter): 0)) {
> 	/* -EINVAL */
>
> we can then re-try with all the compat fixups.
>
> What do you think?
>
>   
I think it's best to have the compat code in the fast path, since that's
the code that will be needed in the future on those machines (I'll make
the userspace workaround a compile-time option that is turned off by
default in the next release of ebtables).
Shouldn't it be possible for the compat code to know when a certain
wrong size is due to the userspace workaround? If that situation is the
case, then the compat code can execute the "native" getsockopt instead
of producing a kernel error message...

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

