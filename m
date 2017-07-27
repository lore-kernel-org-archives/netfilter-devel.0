From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH V2] netfilter: x_tables: Fix use-after-free in ipt_do_table.
Date: Thu, 27 Jul 2017 10:12:06 +0900
Message-ID: <CAMArcTUd9f7b9291CKWLeFsbZyH3icvQg7GwZSGp5Pf3i0mHKA@mail.gmail.com>
References: <20170726091648.20639-1-ap420073@gmail.com> <20170726092716.GB28392@breakpoint.cc>
 <20170726110627.GC1607@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36819 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdG0BMH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2017 21:12:07 -0400
Received: by mail-yw0-f195.google.com with SMTP id i6so6416557ywb.3
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 18:12:07 -0700 (PDT)
In-Reply-To: <20170726110627.GC1607@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-07-26 20:06 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Wed, Jul 26, 2017 at 11:27:16AM +0200, Florian Westphal wrote:
>> Taehee Yoo <ap420073@gmail.com> wrote:
>> > If verdict is NF_STOLEN in the SYNPROXY target,
>> > the skb is consumed.
>> > However, ipt_do_table() always tries to get ip header from the skb.
>> > So that, KASAN triggers the use-after-free message.
>>
>> In case anyone wonders, ip6tables doesn't have this problem
>> because we pass *skb, not ip6hdr to ip6_packet_match().
>
> I think it would be good to make these code converge to what ip6tables
> is doing while fixing up this?
>
>> arptables has the same bug, it seems (no target returns STOLEN,
>> but I think we should fix it there as well).
>
> Yes, even if no target returns what triggers the problem, it's good if
> we fix this now so we make sure whatever new extension gets in in the
> future works accordingly.
>
> Thanks!

Thank you for reviews!
I will send the V3 patch that includes modified arpt_do_table()
that is reviewed point.
