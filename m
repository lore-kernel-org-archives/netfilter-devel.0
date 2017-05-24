From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: fix incorrect nf_ct_put during
 hash resize
Date: Wed, 24 May 2017 08:52:49 +0800
Message-ID: <CAML_gOcOaq_jMkWpjBLxo9Hr=sUu6hSWrRv=y89D--iCutEX7g@mail.gmail.com>
References: <1495322569-63361-1-git-send-email-zlpnobody@163.com>
 <20170521000047.GA1004@breakpoint.cc> <CAML_gOdnZkbCp8JnVpd8bbeTQuhK7hMtQio4iuLQe137HxE_+g@mail.gmail.com>
 <20170523213427.GA9071@salvia> <20170523222855.GA11547@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:34038 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758773AbdEXAwu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 20:52:50 -0400
Received: by mail-ua0-f178.google.com with SMTP id u10so88358606uaf.1
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 17:52:50 -0700 (PDT)
In-Reply-To: <20170523222855.GA11547@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-05-24 6:28 GMT+08:00 Florian Westphal <fw@strlen.de>:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
>> I will append the Fixes: tag:
>>
>> Fixes: 89f2e21883b5 ("[NETFILTER]: ctnetlink: change table dumping not to require an unique ID")
>
> That commit looks fine to me, it seems to make sure to put
> "last" only once in all cases.
>
> 93bb0ceb75be2fdfa9fc0dd1 however adds a check on cb->args[0], and if
> that is hit it will do a put() on last, and then, the "done" netlink
> callback will do another put operation on cb->args[1] (i.e., last).

After I have a closer look, I think this patch should add:

Fixes: d205dc40798d ("[NETFILTER]: ctnetlink: fix deadlock in table dumping")

After this commit, when the hash size was reduced, for example,
from 60000 to 600, then we may put the "last" ct twice, as we may
fail to go into the iteration and clear the cb->args[1], so:

1. nf_ct_put(last) by ctnetlink_dump_table, but cb->args[1] still
point to the "last"
2. nf_ct_put((struct nf_conn *)cb->args[1]) by ctnetlink_done
