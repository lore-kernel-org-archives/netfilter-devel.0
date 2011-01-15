From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/6] netfilter: reduce NF_VERDICT_MASK to 0xff
Date: Sat, 15 Jan 2011 15:33:21 +0100
Message-ID: <4D31B031.9020304@trash.net>
References: <1293407904-31464-1-git-send-email-fw@strlen.de> <1293407904-31464-5-git-send-email-fw@strlen.de> <4D2DFAC5.8020802@netfilter.org> <20110112205216.GC10801@Chamillionaire.breakpoint.cc> <4D305836.8080007@trash.net> <4D31AF2E.8030305@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58777 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1AOOdZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Jan 2011 09:33:25 -0500
In-Reply-To: <4D31AF2E.8030305@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.01.2011 15:29, schrieb Pablo Neira Ayuso:
> On 14/01/11 15:05, Patrick McHardy wrote:
>>>>> >>>> +/* NF_VERDICT_BITS should be 8 now, but userspace might break if this changes */
>>>>> >>>> +#define NF_VERDICT_BITS 16
>>>>> >>>>  #endif
>>>> >>>
>>>> >>> i don't find any use of this in user-space.
>>> >>
>>> >> Alright, I will simply remove it, then :-)
>> > 
>> > I think we should still keep it around in the compat section,
>> > just because we don't know of any userspace code using this
>> > doesn't mean it doesn't exist.
> Yes, that's true, but I don't fine any sane use of that macro in userspace.
> 

Well, as Florian said, using (queue_nr << NF_VERDICT_BITS) in userspace
is a valid use when reinjecting packets.
