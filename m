From: Aaron Conole <aconole@bytheb.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: convert hook list to an array
Date: Wed, 23 Aug 2017 16:54:14 -0400
Message-ID: <f7tpobmovih.fsf@dhcp-25-97.bos.redhat.com>
References: <20170823152627.19865-1-fw@strlen.de>
        <20170823152627.19865-2-fw@strlen.de>
        <1503505040.2499.60.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35567 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932407AbdHWUyS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 16:54:18 -0400
Received: by mail-qk0-f195.google.com with SMTP id l68so662402qke.2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 13:54:17 -0700 (PDT)
In-Reply-To: <1503505040.2499.60.camel@edumazet-glaptop3.roam.corp.google.com>
        (Eric Dumazet's message of "Wed, 23 Aug 2017 09:17:20 -0700")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On Wed, 2017-08-23 at 17:26 +0200, Florian Westphal wrote:
>> From: Aaron Conole <aconole@bytheb.org>
>
> ...
>
>> -static struct nf_hook_entry __rcu **nf_hook_entry_head(struct net
>> *net, const struct nf_hook_ops *reg)
>> +static struct nf_hook_entries *allocate_hook_entries_size(u16 num)
>> +{
>> +	struct nf_hook_entries *e;
>> +	size_t alloc = sizeof(*e) +
>> +		       sizeof(struct nf_hook_entry) * num +
>> +		       sizeof(struct nf_hook_ops *) * num;
>> +
>> +	if (num == 0)
>> +		return NULL;
>> +
>> +	e = kvmalloc(alloc, GFP_KERNEL);
>> +	if (e) {
>> +		memset(e, 0, alloc);
>> +		e->num_hook_entries = num;
>> +	}
>
>
> nit:
>
> 	e = kvzalloc(alloc, GFP_KERNEL);
> 	if (e)
> 		e->num_hook_entries = num;

d'oh!  Thanks for spotting.
