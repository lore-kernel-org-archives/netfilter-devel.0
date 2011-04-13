From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/2] rework of userspace expectation support
Date: Wed, 13 Apr 2011 14:28:48 +0200
Message-ID: <4DA59700.9000400@trash.net>
References: <20110412215458.3145.40830.stgit@decadence> <4DA58AE2.7000204@trash.net> <4DA58D48.4010307@netfilter.org> <4DA58F41.9080603@trash.net> <4DA592F3.1090201@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39501 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab1DMM2x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:28:53 -0400
In-Reply-To: <4DA592F3.1090201@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 13.04.2011 14:11, schrieb Pablo Neira Ayuso:
> On 13/04/11 13:55, Patrick McHardy wrote:
>> Am 13.04.2011 13:47, schrieb Pablo Neira Ayuso:
>>> On 13/04/11 13:37, Patrick McHardy wrote:
>>>> Am 12.04.2011 23:59, schrieb Pablo Neira Ayuso:
>>>>> Hi Patrick,
>>>>>
>>>>> The following patches rework the userspace expectation support
>>>>> to fix one problematic scenario: if the master conntrack vanishes
>>>>> while there are still userspace expectations, we hit an oops
>>>>> in the destroy event path for expectations.
>>>>
>>>> Just wondering, how can this happen? We take a reference for
>>>> userspace expectations just as we do for kernel expectations.
>>>>
>>>> Ok, I see, we are releasing it again at the end of
>>>> ctnetlink_create_expect(), that seems to be the actual problem
>>>> if I'm not mistaken.
>>>
>>> Indeed, we have keep that reference, that would fix the problem.
>>
>> We definitely need to hold it anyways since destroy_conntrack()
>> releases it again.
>>
>>> Still, with the curent approach the userspace expectation will be valid
>>> after the master conntrack has expired.
>>>
>>> So we can do the following: Fix this refcount issue in -stable and
>>> current, and schedule these patches for nf-next to change the behaviour.
>>>
>>> What do you think?
>>
>> I don't know, what's the difference to non-userspace expectations?
>> The same applies to them, we don't require the master to still be
>> active for expectations.
> 
> kernelspace expectations are released if the master is destroyed.
> userspace expectations will not.

I see, you're talking about unfulfilled expectations. Still, we're
releasing expectations in destroy_conntrack(), if we fix the refcount
issue, the master conntrack will not be destroyed while userspace
expectations exist.

> The helper extension is used to store a list of expectations for this
> master conntrack, so we can release the expectations that are
> associated. This is not true for userspace expectations, since the
> master has no list with expectations.

This raises the question - why are we treating userspace differently
in this regard?
