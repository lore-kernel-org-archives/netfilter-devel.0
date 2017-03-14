From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 nf] netfilter: nft_set_bitmap: keep a list of dummy
 elements
Date: Tue, 14 Mar 2017 16:21:53 +0100
Message-ID: <20170314152153.GA4586@salvia>
References: <1489408071-6123-1-git-send-email-pablo@netfilter.org>
 <CAML_gOf5DM6W81b34EQQz+hdsFb-72jq4BhtRK4d2657Ks9bHg@mail.gmail.com>
 <20170313172344.GA32297@salvia>
 <CAML_gOfwcikXVQGOHUXTqhrQAUP4u5sWcci9PzM5q9sAdgx-qA@mail.gmail.com>
 <20170314102131.GB1281@salvia>
 <20170314121905.GA3560@salvia>
 <CAML_gOfLeDrNxuK2egqJntJOy+vSB=WhyOW5hU1qkihmw1qqzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54688 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbdCNPWH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 11:22:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 55A12E9761
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 16:22:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42F4CDA7E9
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 16:22:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8E6ADA872
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 16:22:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAML_gOfLeDrNxuK2egqJntJOy+vSB=WhyOW5hU1qkihmw1qqzQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 10:44:43PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 2017-03-14 20:19 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> [...]
> > Another possibility is to simply regard desc->size over the memory
> > scalability notation when provided. I think this just needs an update
> > from nft userspace. Look, bitmap and hashtable are both described as
> > O(1) in terms of performance. If the user provides the set size (this
> > is known in anonymous sets) we can select the one that takes less
> > memory. When no size is specified, we rely on the set policy that is
> > specified.
> >
> > Still, for anonymous sets we will select hashtable instead, this is
> > going to be slower in systems that have plenty of memory. I think we
> > cannot escape the new per-table global knob to select
> > memory/performance for anononymous sets after all.
> 
> After we implement more and more sets types, I think just based on
> POL_PERFORMANCE or POL_MEMORY to select a suitable set will
> become a more and more difficult task. So how about this method:
> 1. For compatibility, POL_PERFORMANCE means hash set, and
>     POL_MEMORY means rbtree set.(I know this maybe incorrect when
>     the set->size is 0)
> 2. When the user create the set, he(she) can specify a new settype to
>     select the set type, such as hash, rbtree, bitmap... a little similar to
>     ipset.
> 
> I know this method is not perfect, but this will provide big
> flexibility to the user.

Then, we cannot deprecate sets like the rbtree, that I'm very much in
favour to find a replacement, as it would be exposed to userspace and
anyone could be using it, and we cannot break existing user setups.

Moreover, if we, the developers, don't know exactly what is a good
choice, how can users just know what is best for them? I would prefer
developers come to us to tune the set backend selection so we get it
better. We can enhance this model incrementally.

Leaking details to userspace is easy, just a matter of exposing all
these knobs to userspace via netlink. If this turns out to be the way,
we'll do it at a given time, but I'm still willing to spend time on
this set backend selection routine.

> > I'm curious, what kind of device are you thinking of with such memory
> > restrictions that cannot take 320 kB? I would expect such embedded
> > device that cannot afford such memory consumption will come also with
> > a smallish cpu.
> 
> We had a small router with 32MB memory in my previous company.
> On such an embedded device, occupy 320KB is also no problem of
> course.
> 
> But I guess the user  will not happy to know the fact, inputting such a
> nft rule "nft add x y tcp dport {21, 22} drop" will consume more than
> 16KB memory :)

For such small usecase, we can expose something like:

table x {
        policy memory; <----

        chain y {
                type filter hook output priority 0; policy drop;

                tcp dport {22, 80} ct state established,related accept
        }
}

So the kernel knows memory is more important that performance, and
this policy exposes what the user needs. If not specified, the
performance representation is selected.
