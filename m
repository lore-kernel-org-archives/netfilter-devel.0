From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf V2] netfilter: nf_ct_helper: permit cthelpers with
 different names via nfnetlink
Date: Fri, 14 Apr 2017 07:50:26 +0800
Message-ID: <CAML_gOdLUzEteQC1UEw8N9FEnudWHfM3K-hv7hy5xKwehRWNCA@mail.gmail.com>
References: <1490792404-6035-1-git-send-email-zlpnobody@163.com>
 <CAML_gOdMiDPy==pvW5D5MrJZ1UfnpAzK172R4QbehnSkmHZP0w@mail.gmail.com> <20170413222914.GA5089@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36213 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753288AbdDMXu1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:50:27 -0400
Received: by mail-vk0-f53.google.com with SMTP id q78so4289025vke.3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 16:50:27 -0700 (PDT)
In-Reply-To: <20170413222914.GA5089@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-04-14 6:29 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>> After I have a closer look, inside hlist_for_each_entry_rcu, we use the
>> rcu_dereference_raw() to get the pointer, and this will not generate warning:
>>
>> #define hlist_for_each_entry_rcu(pos, head, member) \
>>     for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
>>                          typeof(*(pos)), member);
>>    ....
>>
>> Then "This is likely going to spot false positives with the RCU
>> debugging instrumentation"
>> will not happen.
>
> Right, instrumentation will not trigger any problem.
>
> But even if instrumention is not a problem, I just would like to avoid
> people sending me "obvious" fixes afterwards, by removing _rcu since
> they see this code runs under mutex or how knows what.

I'm a little confusing about this one.

I found "http://patchwork.ozlabs.org/patch/744786/" and
"http://patchwork.ozlabs.org/patch/743472/" were both set
to "Changes Requested".

So which one is you prefer to :)? What's next step should I do?
