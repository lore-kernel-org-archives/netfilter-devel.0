From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v0] netns NOTRACK
Date: Fri, 12 Feb 2010 15:45:50 +0100
Message-ID: <4B75699E.9070901@trash.net>
References: <20100211173117.GD4099@x200> <4B744565.2010808@trash.net> <b6fcc0a1002120432t133ef769jc877d92b1f106af2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33495 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0BLOpx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:45:53 -0500
In-Reply-To: <b6fcc0a1002120432t133ef769jc877d92b1f106af2@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> On Thu, Feb 11, 2010 at 7:59 PM, Patrick McHardy <kaber@trash.net> wrote:
>> Alexey Dobriyan wrote:
>>> --- a/net/bridge/br_netfilter.c
>>> +++ b/net/bridge/br_netfilter.c
>>> @@ -792,9 +792,11 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff *skb,
>>>  }
>>>
>>>  #if defined(CONFIG_NF_CONNTRACK_IPV4) || defined(CONFIG_NF_CONNTRACK_IPV4_MODULE)
>>> +#include <net/netfilter/nf_conntrack.h>
>>> +
>>>  static int br_nf_dev_queue_xmit(struct sk_buff *skb)
>>>  {
>>> -     if (skb->nfct != NULL &&
>>> +     if ((skb->nfct != NULL || nf_ct_is_untracked(skb)) &&
>> Seems unnecessary since nfct should be NULL when the conntrack
>> is untracked.
> 
> Before untracked connections would pass the test, so additional check required.

Actually they are supposed to pass this test since they
are also defragmented.

