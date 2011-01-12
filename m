From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/6] netfilter: nfnetlink_queue: return error number to
 caller
Date: Wed, 12 Jan 2011 22:59:27 +0100
Message-ID: <4D2E243F.2070508@netfilter.org>
References: <1293407904-31464-1-git-send-email-fw@strlen.de> <1293407904-31464-3-git-send-email-fw@strlen.de> <4D2DF944.8060407@netfilter.org> <20110112204917.GA10801@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39110 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489Ab1ALV7c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 16:59:32 -0500
In-Reply-To: <20110112204917.GA10801@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/01/11 21:49, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> I've got some questions and comments on this patchset, please see below.
> 
> Thank you for spending time on reviewing this patchset!

welcome Florian ;-)

>> On 27/12/10 00:58, Florian Westphal wrote:
>>> instead of returning -1 on error, return an error number to allow the
>>> caller to handle some errors differently.
>>>
>>> To make things simpler try_module_get() failure is no longer special-cased.
>>>
>>> The new return values will be used in followup patch.
>>>
>>> Signed-off-by: Florian Westphal <fw@strlen.de>
>>> --- a/net/netfilter/core.c
>>> +++ b/net/netfilter/core.c
>>> @@ -179,9 +179,8 @@ next_hook:
>>>  		if (ret == 0)
>>>  			ret = -EPERM;
>>>  	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
>>> -		if (!nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
>>> -			      verdict >> NF_VERDICT_BITS))
>>> -			goto next_hook;
>>> +		nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
>>> +			       verdict >> NF_VERDICT_BITS);
>>
>> You have to remove the next_hook label if you want to do this.
>>
>> It's not clear to me why we need to remove the goto jump, could you
>> clarify this?
> 
> Sure. The only place where nf_queue returns 0 is this snippet in __nf_queue():

I see, only the try_module_get part.

>>> -	/* If it's going away, ignore hook. */
>>> -	if (!try_module_get(entry->elem->owner)) {
>>> -		rcu_read_unlock();
>>> -		kfree(entry);
>>> -		return 0;
>>> -	}
>>> +	if (!try_module_get(entry->elem->owner))
>>> +		goto err_unlock;
>>
>> With this change, we're now releasing the skb, is this deliberate?
> 
> I think its not necessary to make this a special case (i.e. just
> kfree_skb(skb) instead).

This case is rare but I'd prefer not to drop packets if the hook is
going away.

[...]
>> Better propagate the error of skb_gso_segment(...) with PTR_ERR()
> 
> The reason I did not do that is because I wanted to limit the number
> of code one has to check for possible errno values that can be returned
> by nf_queue.
> 
> Its probably reasonable to assume that skb_gso_segment() won't return
> ESRCH (which I use to determine that qeueuing failed because the queue number did
> not exist), so it might be safe to use PTR_ERR here.

Currently, it only return -EINVAL. Anyway, it makes sense what you
mention. Better use -EINVAL and add a short comment upon it that tells
why we're doing this.

