From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: [RFC PATCH] netfilter: nf_tables: extend payload to support writing
 data
Date: Wed, 19 Feb 2014 17:22:45 +0100
Message-ID: <5304DA55.90409@redhat.com>
References: <1392660737-10149-1-git-send-email-nikolay@redhat.com> <20140217183751.GB10701@macbook.localnet> <5302585A.9070309@redhat.com> <20140217184651.GA11041@macbook.localnet> <5304D7DD.6040004@redhat.com> <20140219162542.GA9882@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbaBSQ1T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:27:19 -0500
In-Reply-To: <20140219162542.GA9882@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/19/2014 05:25 PM, Patrick McHardy wrote:
> On Wed, Feb 19, 2014 at 05:12:13PM +0100, Nikolay Aleksandrov wrote:
>> On 02/17/2014 07:46 PM, Patrick McHardy wrote:
>>>>>
>>>>> We need to take care of checksumming. Shouldn't be too hard to get *most*
>>>>> cases right using the existing checksum helpers.
>>>>>
>>>> Yes, but would you like to do that in here or have a separate op which
>>>> is configurable i.e. you can set what to calculate and where to put it,
>>>> or would you prefer to make it automatic based on what we're changing here ?
>>>
>>> Something here is a lot cheaper since we can use incremental checksumming.
>>> That won't be possible somewhere else, additionally we'd have to check
>>> the checksum before recalculating it to make sure we don't fix up bad
>>> packets. So yes, I think it should be done here.
>>>
>> Okay, I've been working on this today and have gotten to a point where it works :)
>> But I have a few questions, currently I've made it so the header that you modify
>> is the only one that gets its checksum updated (with the exception of pseudo
>> header if the address gets written to), I recompute the changed bytes one at a
>> time because of the freedom of offset and length. Now this works fine and I can
>> mangle the ip/ip6 headers or the transport headers (tcp/udp, I'll look into
>> adding sctp as well), but there's a problem with the cross-header writing i.e.
>> if a write spills from the network header to the transport header, currently I
>> only update the network header part (correctly, only up to the bytes that were
>> changed inside) and leave the transport header broken.
>> This also applies to the LL header, if a write spills into the network header
>> then we'll have a broken packet.
>>
>> Would you like me to add additional logic to support the cross-header writes or
>> leave it as it is ?
> 
> I think that should be fine. 
> 
> Regarding the one byte at a time - update, how about rounding down to the
> next multiple of four, adjusting the replacement data accordingly and using
> csum_replace4() instead?
> 
I was hoping you wouldn't say that :-) (joking)
Yep, I know, I'll do it.

Thanks again
