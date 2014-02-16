From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: [RFC PATCH] netfilter: nf_tables: add new write expression
Date: Sun, 16 Feb 2014 12:05:19 +0100
Message-ID: <53009B6F.7020403@redhat.com>
References: <1392470242-4515-1-git-send-email-nikolay@redhat.com> <61379b1e-8f7e-4596-badb-fd41e1657f83@email.android.com> <52FF6D3A.6020202@redhat.com> <20140216100953.GA4952@localhost> <20140216103621.GA28646@macbook.localnet> <530097A8.8010606@redhat.com> <20140216110029.GA29168@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbaBPLF5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 06:05:57 -0500
In-Reply-To: <20140216110029.GA29168@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/16/2014 12:00 PM, Patrick McHardy wrote:
> On Sun, Feb 16, 2014 at 11:49:12AM +0100, Nikolay Aleksandrov wrote:
>> On 02/16/2014 11:36 AM, Patrick McHardy wrote:
>>>>
>>>>     netfilter: nf_tables: nft_meta module get/set ops
>>>>
>>>> That patch is similar to what you propose, but it sets the meta fields
>>>> of a packet.
>>>
>>> Actually I'd propose two different init functions, that's just not pretty.
>>>
>> Hm, okay.
>> How about something else, since I wanted to make use of the inlined payload
>> fast op, couldn't I just break the dreg/sreg in separate variables and
>> based on whether sreg is set act in the fast op (i.e. get/set based on
>> that) ? That way we can save some code duplication and keep the ops as
>> they're. (That'll work for the slow op as well actually)
> 
> I don't agree to adding a set fast op. The get fast op is meant to be
> small since its the most common case and is inlined into the main loop.
> Anything added there needs a *really* good justification. Modifying
> packet data isn't a very common operation and should be kept seperate.
> 
> Outside of the main loop, there's no need for a fast op as well since
> memcpy *is* fast and any optimized implementation will already do the
> same thing you do.
> 
Right, okay going the standard way then :-)

>> Also, there's a small problem for payload because the code in the
>> select_ops function:
>>         if (len <= 4 && IS_ALIGNED(offset, len) && base !=
>> NFT_PAYLOAD_LL_HEADER)
>>                 return &nft_payload_fast_ops;
>>         else
>>                 return &nft_payload_ops;
>>
>> Has a problem when the offset ends in 101b and length of 3 is used, then
>> the fast ops get selected but since that case isn't handled there, we'll
>> only load 1 byte from the offset, which is fine for loading since we can
>> just switch to 4 bytes and mask out later the unneeded byte when comparing
>> for example, but for writing it's a problem since someone might actually
>> want to write out 3 bytes. Of course one can always add 2 expressions (1
>> byte + 2 byte write) :-)
> 
> Good catch, we should make sure the offset is a power of two since the
> fast version is only intended for well aligned loads.
> 
> Would you care to send a patch?
Sure, I'll take care of it.

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

