From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH 1/2 nf] netfilter: nft_set_bitmap: keep a list of dummy elements
Date: Tue, 14 Mar 2017 17:04:17 +0800
Message-ID: <CAML_gOfwcikXVQGOHUXTqhrQAUP4u5sWcci9PzM5q9sAdgx-qA@mail.gmail.com>
References: <1489408071-6123-1-git-send-email-pablo@netfilter.org>
 <CAML_gOf5DM6W81b34EQQz+hdsFb-72jq4BhtRK4d2657Ks9bHg@mail.gmail.com> <20170313172344.GA32297@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:33596 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdCNJET (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 05:04:19 -0400
Received: by mail-ua0-f182.google.com with SMTP id u30so167944124uau.0
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 02:04:18 -0700 (PDT)
In-Reply-To: <20170313172344.GA32297@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-14 1:23 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
> I would like this only describes the representation that is exposed to
> the packet path, not the real memory consumption of it. I know I'm
> kind of cheating, but with this I'm also giving this bitmap an
> advantage over the hashtable representation, the performance numbers I
> gathered here when evaluating it are better.

Yes, I agree, bitmap_set is faster than hash_set, so for POL_PERFORMANCE
policy, we should prefer to use bitmap_set.

> Anyway, I'll be fine if this triggers some discussions on the set
> backend selection at some point, as well as more detailed performance
> evaluation. Note this big O notation just tell about the scalability.
> Size provides an accurate way to measure how much memory this consumes
> but only if userspace tells us how many elements we're going to add
> beforehand. On the CPU side, we have no such specific metric as the
> memory size. Probably we can introduce some generic cycle metric that
> represents the cost of the lookup path, this won't be simple as this
> number is not deterministic since there are many things to consider,
> so we have to agree on how we calculate this pseudo-metric.

Hmm... I think a better selection algorithm is necessary now. I find an
obvious drawback for the time being, for example:

When set->klen is 2, the bitmap_set's memory consumption is much
higer than others. Only one single set with few elements will occupy at
least 16kB, so only 20 rules using sets will consume roughly 320kB, it will
become a high burden for these embedded systems which with low memory.

It's worse that we cannot ignore the bitmap_set, even if we select the the
NFT_SET_POL_MEMORY policy without the set size specified, we will still
choose the bitmap_set, since it claims that it's space complexity is
NFT_SET_CLASS_O_1.
