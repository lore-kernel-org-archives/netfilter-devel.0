From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/6] netfilter: reduce NF_VERDICT_MASK to 0xff
Date: Fri, 14 Jan 2011 15:05:42 +0100
Message-ID: <4D305836.8080007@trash.net>
References: <1293407904-31464-1-git-send-email-fw@strlen.de> <1293407904-31464-5-git-send-email-fw@strlen.de> <4D2DFAC5.8020802@netfilter.org> <20110112205216.GC10801@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35940 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab1ANOFy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:05:54 -0500
In-Reply-To: <20110112205216.GC10801@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.01.2011 21:52, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>>  /* only for userspace compatibility */
>>>  #ifndef __KERNEL__
>>> @@ -41,6 +44,9 @@
>>>     <= 0x2000 is used for protocol-flags. */
>>>  #define NFC_UNKNOWN 0x4000
>>>  #define NFC_ALTERED 0x8000
>>> +
>>> +/* NF_VERDICT_BITS should be 8 now, but userspace might break if this changes */
>>> +#define NF_VERDICT_BITS 16
>>>  #endif
>>
>> i don't find any use of this in user-space.
> 
> Alright, I will simply remove it, then :-)

I think we should still keep it around in the compat section,
just because we don't know of any userspace code using this
doesn't mean it doesn't exist.
