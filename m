From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] rework of userspace expectation support
Date: Wed, 13 Apr 2011 13:47:20 +0200
Message-ID: <4DA58D48.4010307@netfilter.org>
References: <20110412215458.3145.40830.stgit@decadence> <4DA58AE2.7000204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44329 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab1DMLr0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:47:26 -0400
In-Reply-To: <4DA58AE2.7000204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13/04/11 13:37, Patrick McHardy wrote:
> Am 12.04.2011 23:59, schrieb Pablo Neira Ayuso:
>> Hi Patrick,
>>
>> The following patches rework the userspace expectation support
>> to fix one problematic scenario: if the master conntrack vanishes
>> while there are still userspace expectations, we hit an oops
>> in the destroy event path for expectations.
> 
> Just wondering, how can this happen? We take a reference for
> userspace expectations just as we do for kernel expectations.
> 
> Ok, I see, we are releasing it again at the end of
> ctnetlink_create_expect(), that seems to be the actual problem
> if I'm not mistaken.

Indeed, we have keep that reference, that would fix the problem.

Still, with the curent approach the userspace expectation will be valid
after the master conntrack has expired.

So we can do the following: Fix this refcount issue in -stable and
current, and schedule these patches for nf-next to change the behaviour.

What do you think?
