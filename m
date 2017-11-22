From: Giuseppe Scrivano <gscrivan@redhat.com>
Subject: Re: [RFC PATCH] netfilter: call synchronize_net only once from nf_register_net_hooks
Date: Wed, 22 Nov 2017 12:25:00 +0100
Message-ID: <87a7zea73n.fsf@redhat.com>
References: <20171122104026.7592-1-gscrivan@redhat.com>
        <20171122110606.GF24866@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5263 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751988AbdKVLZC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 06:25:02 -0500
In-Reply-To: <20171122110606.GF24866@breakpoint.cc> (Florian Westphal's
        message of "Wed, 22 Nov 2017 12:06:06 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> writes:

> Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>> SELinux, if enabled, registers for each new network namespace 6
>> netfilter hooks.  Avoid to use synchronize_net for each new hook, but do
>> it once after all the hooks are added.  The net benefit on an SMP
>> machine with two cores is that creating a new network namespace takes
>> -40% of the original time.
>
> but this needs more work.
>
>> Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
>> ---
>>  net/netfilter/core.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>> 
>> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
>> index 52cd2901a097..beeb0b36f429 100644
>> --- a/net/netfilter/core.c
>> +++ b/net/netfilter/core.c
>> @@ -252,7 +252,7 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
>>  	return NULL;
>>  }
>>  
>> -int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
>> +static int __nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
>
> Change this to return struct nf_hook_entries *

thanks for the quick review.  Are you fine if I change it to:

static int __nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg, struct nf_hook_entries **old)

so that it is still possible to return other errors as the current code does?

Giuseppe
