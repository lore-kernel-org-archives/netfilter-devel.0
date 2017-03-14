From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH 1/2 nf] netfilter: nft_set_bitmap: keep a list of dummy elements
Date: Tue, 14 Mar 2017 22:44:43 +0800
Message-ID: <CAML_gOfLeDrNxuK2egqJntJOy+vSB=WhyOW5hU1qkihmw1qqzQ@mail.gmail.com>
References: <1489408071-6123-1-git-send-email-pablo@netfilter.org>
 <CAML_gOf5DM6W81b34EQQz+hdsFb-72jq4BhtRK4d2657Ks9bHg@mail.gmail.com>
 <20170313172344.GA32297@salvia> <CAML_gOfwcikXVQGOHUXTqhrQAUP4u5sWcci9PzM5q9sAdgx-qA@mail.gmail.com>
 <20170314102131.GB1281@salvia> <20170314121905.GA3560@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:34511 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbdCNOou (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 10:44:50 -0400
Received: by mail-ua0-f176.google.com with SMTP id f54so166317439uaa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 07:44:49 -0700 (PDT)
In-Reply-To: <20170314121905.GA3560@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
2017-03-14 20:19 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
> Another possibility is to simply regard desc->size over the memory
> scalability notation when provided. I think this just needs an update
> from nft userspace. Look, bitmap and hashtable are both described as
> O(1) in terms of performance. If the user provides the set size (this
> is known in anonymous sets) we can select the one that takes less
> memory. When no size is specified, we rely on the set policy that is
> specified.
>
> Still, for anonymous sets we will select hashtable instead, this is
> going to be slower in systems that have plenty of memory. I think we
> cannot escape the new per-table global knob to select
> memory/performance for anononymous sets after all.

After we implement more and more sets types, I think just based on
POL_PERFORMANCE or POL_MEMORY to select a suitable set will
become a more and more difficult task. So how about this method:
1. For compatibility, POL_PERFORMANCE means hash set, and
    POL_MEMORY means rbtree set.(I know this maybe incorrect when
    the set->size is 0)
2. When the user create the set, he(she) can specify a new settype to
    select the set type, such as hash, rbtree, bitmap... a little similar to
    ipset.

I know this method is not perfect, but this will provide big
flexibility to the user.

> I'm curious, what kind of device are you thinking of with such memory
> restrictions that cannot take 320 kB? I would expect such embedded
> device that cannot afford such memory consumption will come also with
> a smallish cpu.

We had a small router with 32MB memory in my previous company.
On such an embedded device, occupy 320KB is also no problem of
course.

But I guess the user  will not happy to know the fact, inputting such a
nft rule "nft add x y tcp dport {21, 22} drop" will consume more than
16KB memory :)
