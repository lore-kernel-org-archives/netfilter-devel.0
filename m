From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: [PATCH] netfilter: per network namespace nfacct
Date: Thu, 06 Aug 2015 15:44:47 +0200
Message-ID: <55C364CF.6060609@tpip.net>
References: <1438789905-5716-1-git-send-email-aschultz@tpip.net> <20150806100713.GA18520@salvia> <55C33D46.4080902@tpip.net> <20150806134210.GA3379@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:50748 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbbHFNou (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Aug 2015 09:44:50 -0400
In-Reply-To: <20150806134210.GA3379@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 08/06/2015 03:42 PM, Pablo Neira Ayuso wrote:
> On Thu, Aug 06, 2015 at 12:56:06PM +0200, Andreas Schultz wrote:
>> On 08/06/2015 12:07 PM, Pablo Neira Ayuso wrote:
>>> On Wed, Aug 05, 2015 at 05:51:45PM +0200, Andreas Schultz wrote:
>>
>> [..]
>>
>>>> +static void __net_exit nfnl_acct_net_exit(struct net *net)
>>>> +{
>>>> +	struct nf_acct *cur, *tmp;
>>>> +
>>>> +	list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head) {
>>>> +		list_del_rcu(&cur->head);
>>>> +
>>>> +		if (atomic_dec_and_test(&cur->refcnt))
>>>> +			kfree_rcu(cur, rcu_head);
>>>> +	}
>>>> +}
>>>
>>> You better use nfnl_acct_put() here, otherwise we leak a module
>>> refcount.
>>
>> The module refcount is only taken in nfnl_acct_find_get. The initial
>> insert into the list in nfnl_acct_new is not taking the module
>> refcount.
>>
>> Releasing the module refcount here would IMHO release one recount to
>> many. Or do I miss something?
>
> With netns in place, we don't know in what order the __net_exit
> functions are called, ie. We may still have references to objects from
> xt_nfacct.

Exactly my point, only the xt_nfacct object references also takes a 
module reference. We can not release this reference for them. So
we remove the nfacct object from the list and only free the object if 
xt_nfacct is *NOT* holding a reference.

If xt_nfacct is holding a reference, it will put that reference together
with the module reference later.
