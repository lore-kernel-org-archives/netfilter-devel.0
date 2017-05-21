From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: fix incorrect nf_ct_put during
 hash resize
Date: Sun, 21 May 2017 08:59:45 +0800
Message-ID: <CAML_gOdnZkbCp8JnVpd8bbeTQuhK7hMtQio4iuLQe137HxE_+g@mail.gmail.com>
References: <1495322569-63361-1-git-send-email-zlpnobody@163.com> <20170521000047.GA1004@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33773 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755824AbdEUA7q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 May 2017 20:59:46 -0400
Received: by mail-vk0-f51.google.com with SMTP id x71so27070759vkd.0
        for <netfilter-devel@vger.kernel.org>; Sat, 20 May 2017 17:59:46 -0700 (PDT)
In-Reply-To: <20170521000047.GA1004@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

2017-05-21 8:00 GMT+08:00 Florian Westphal <fw@strlen.de>:
[...]
> Yes, you're right, seems this was added in
> 93bb0ceb75be2fdfa9fc0dd1fb522d9ada515d9c (it adds the 'goto out').

I added some trace logs, and when the hash size reduced, for example,
from 60000 to 500, then the issue would happen.

Actually, hitting 'goto out' is not easy, so the issue exists for a very long
time. Maybe commit 89f2e21883b5("[NETFILTER]: ctnetlink: change
table dumping not to require an unique ID") is to blame for it.

> Your patch looks correct.
>
> However, why do we bump refcnt of 'last' in the first place?
>
> Its only the continuation marker, i.e. its expected to reside
> in the hash slot at cb->args[0], but after rehash this might not
> be true either.
>
> I think we should simplify this, just take the verbatim address,
> and clear it right at start of ctnetlink_dump_table, i.e.
>
> unsigned long last = cb->args[1];
> cb->args[1] = 0;
>
> for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
>          ...
>     hlist_nulls_for_each_entry ... {
>        ...
>        if (last) {
>             if (last != (unsigned long)ct))
>                cont;
>             last = 0;
>        }
>        ...
>        dump();
>     }
>     last = 0; /* reset it, as it wasn't in args[0] slot */
>  }
>
> Do you see any problem with that?

I think this will be better, this will make code more clean.
Also we can clean up the ctnetlink_exp_ct_dump_table too.

>
> [ It might be better to take your patch for nf- though and do
>   this no-refcnt thing in nf-next ... ]
