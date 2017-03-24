From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: invoke synchronize_rcu after set the _hook_
 to NULL
Date: Fri, 24 Mar 2017 21:01:17 +0800
Message-ID: <CAML_gOeOE_TSJb2hsNoGBopF_-kxdj3n4c4nzge9qR0q52wpYA@mail.gmail.com>
References: <1490015030-16403-1-git-send-email-zlpnobody@163.com> <20170324121707.GA2764@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:36303 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932990AbdCXNBT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 09:01:19 -0400
Received: by mail-vk0-f50.google.com with SMTP id s68so1849833vke.3
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 06:01:18 -0700 (PDT)
In-Reply-To: <20170324121707.GA2764@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-24 20:17 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
>> --- a/net/netfilter/nfnetlink_cttimeout.c
>> +++ b/net/netfilter/nfnetlink_cttimeout.c
>> @@ -646,8 +646,8 @@ static void __exit cttimeout_exit(void)
>>  #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
>>       RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
>>       RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
>> +     synchronize_rcu();
>>  #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
>> -     rcu_barrier();
>
> cttimeout relies on kfree_rcu().
>
> Are you sure we don't need this?
>
> According to:
>
> https://www.kernel.org/doc/Documentation/RCU/rcubarrier.txt
>
> "We could try placing a synchronize_rcu() in the module-exit code path,
> but this is not sufficient."
>
> Then:
>
> "Please note that rcu_barrier() does -not- imply synchronize_rcu(), in
> particular, if there are no RCU callbacks queued anywhere,
> rcu_barrier() is within its rights to return immediately, without
> waiting for a grace period to elapse."

This is because we use kfree_rcu to free the cttimeout objects. So I think
rcu_barrier() is not needed anymore.

Quoted from https://lwn.net/Articles/433493/ :
"And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
queue any function which belong to the module, so a rcu_barrier() can
be avoid when module exit."

Also from commit 9ab1544eb419 ("rcu: introduce kfree_rcu()"):
"Many rcu callbacks functions just call kfree() on the base structure.
These functions are trivial, but their size adds up, and furthermore
when they are used in a kernel module, that module must invoke the
high-latency rcu_barrier() function at module-unload time."
