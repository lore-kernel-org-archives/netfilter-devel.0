From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH] netfilter: nat: remove rcu_read_lock in __nf_nat_decode_session.
Date: Mon, 10 Apr 2017 21:30:48 +0900
Message-ID: <CAMArcTXwyZmKK49W9X6NvcJJn8S9-XS3sL4JNnXoZxpxtQBqug@mail.gmail.com>
References: <20170327152850.19812-1-ap420073@gmail.com> <20170406195125.GA6515@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33110 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752251AbdDJMau (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 08:30:50 -0400
Received: by mail-qk0-f195.google.com with SMTP id p22so18945520qka.0
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 05:30:49 -0700 (PDT)
In-Reply-To: <20170406195125.GA6515@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you for your review!

2017-04-07 4:51 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Tue, Mar 28, 2017 at 12:28:50AM +0900, Taehee Yoo wrote:
>> __nf_nat_decode_session is called from nf_nat_decode_session as decodefn.
>> before calling decodefn, it already set rcu_read_lock. so rcu_read_lock in
>> __nf_nat_decode_session can be removed.
>
> Could you have close look at the tree to confirm if we have more spots
> where rcu_read_lock is unnecessary?
>
> $ git grep rcu_read_lock net/netfilter/ | wc -l
> 158
> $ git grep rcu_read_lock
> net/ipv4/netfilter/ | wc -l
> 3
> $ git grep rcu_read_lock
> net/ipv6/netfilter/ | wc -l
> 2
> $ git grep rcu_read_lock
> net/bridge/netfilter/ | wc -l
>
> It's a fair good amount, it would take me around one hour probably to
> evaluate those here.
>
> If you can help us on verifying this, it would be simply great.
>
> Thanks!

okay, I confirm whole rcu_read_lock then I will resend a single patch
as soon as possible.
may be it needs a week.
