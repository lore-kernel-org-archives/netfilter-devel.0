From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] Helper modules load on-demand support for ctnetlink
Date: Thu, 31 Jul 2008 10:46:08 +0200
Message-ID: <48917BD0.9050105@trash.net>
References: <48904A9F.8010509@netfilter.org> <48904C3B.7060004@trash.net> <48905083.1040002@netfilter.org> <4890519C.80407@netfilter.org> <48906E10.9020902@trash.net> <48917974.3090304@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37685 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYGaIqL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:46:11 -0400
In-Reply-To: <48917974.3090304@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> Sorry, it's wrong. Please, take this.
>>> @@ -1672,9 +1660,24 @@ ctnetlink_create_expect(struct nlattr *c
>>>      help = nfct_help(ct);
>>>  
>>>      if (!help || !help->helper) {
>>> -        /* such conntrack hasn't got any helper, abort */
>>> +#ifdef CONFIG_KMOD
>>> +        char *name;
>>> +
>>>          err = -EINVAL;
>>> +        if (!cda[CTA_EXPECT_HELP_NAME])
>>> +            goto out;
>>> +
>>> +        err = -ENOTSUPP;
>>> +        name = nla_data(cda[CTA_EXPECT_HELP_NAME]);
>>> +        if (request_module("nfct-helper-%s", name) < 0)
>>> +            goto out;
>>> +
>>> +        if (nf_ct_set_helper(ct, GFP_KERNEL) < 0)
>>> +            goto out;
>> This strikes me as quite inconsistent. First, we only perform
>> autoloading for expectation creation, but not for conntracks.
> 
> The module autoloading for conntracks is tricky, it's easy to add for
> the creation case, but I don't see a sane way to do this in the update
> case because of the spin lock that we hold most of the time.
> 
> The only idea that comes to my mind is to do the module load-on-demand
> in a very early stage - just after the tuple parsing in the
> new_conntrack function - but then we'll have to do another look up for
> the helper inside the change_helper function - that would make two
> invocations of find_byname() to assign the helper.
> 
> Moreover, someone may remove the module in the middle just after the
> module loading but, well, we have lost the race in the case.

I'd do something similar to qdiscs etc:

- lookup helper
- if not found: request_module, take lock again, repeat lookup, return 
EAGAIN if found now
- in the nfnetlink command handler: if ret == EAGAIN replay message

grep for "replay" in net/ for a few examples of this. This also
handles the race BTW.

>> Second, this implicit helper assignment is also a bit unusual,
>> why don't we simply insist that the conntrack has a helper
>> assigned through the ctnetlink conntrack interface?
> 
> If I understood well, then we simply assign the helper to the conntrack
> and the expectation part of ctnetlink should rely on the existing
> assigned helper, right?

Yes, I think thats cleaner.

> 
> Please, have a look at the patch attached.

Looks fine.

