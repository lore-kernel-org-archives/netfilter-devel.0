From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 nf] netfilter: nft_set_bitmap: keep a list of dummy
 elements
Date: Tue, 14 Mar 2017 13:19:05 +0100
Message-ID: <20170314121905.GA3560@salvia>
References: <1489408071-6123-1-git-send-email-pablo@netfilter.org>
 <CAML_gOf5DM6W81b34EQQz+hdsFb-72jq4BhtRK4d2657Ks9bHg@mail.gmail.com>
 <20170313172344.GA32297@salvia>
 <CAML_gOfwcikXVQGOHUXTqhrQAUP4u5sWcci9PzM5q9sAdgx-qA@mail.gmail.com>
 <20170314102131.GB1281@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38494 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbdCNMTP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 08:19:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5C72DB6C9E
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 13:19:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44E9EDA4E3
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 13:19:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA46DDA3A0
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 13:19:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170314102131.GB1281@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 11:21:31AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 14, 2017 at 05:04:17PM +0800, Liping Zhang wrote:
> > 2017-03-14 1:23 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > [...]
> > > Anyway, I'll be fine if this triggers some discussions on the set
> > > backend selection at some point, as well as more detailed performance
> > > evaluation. Note this big O notation just tell about the scalability.
> > > Size provides an accurate way to measure how much memory this consumes
> > > but only if userspace tells us how many elements we're going to add
> > > beforehand. On the CPU side, we have no such specific metric as the
> > > memory size. Probably we can introduce some generic cycle metric that
> > > represents the cost of the lookup path, this won't be simple as this
> > > number is not deterministic since there are many things to consider,
> > > so we have to agree on how we calculate this pseudo-metric.
> > 
> > Hmm... I think a better selection algorithm is necessary now. I find an
> > obvious drawback for the time being, for example:
> > 
> > When set->klen is 2, the bitmap_set's memory consumption is much
> > higer than others. Only one single set with few elements will occupy at
> > least 16kB, so only 20 rules using sets will consume roughly 320kB, it will
> > become a high burden for these embedded systems which with low memory.
> >
> > It's worse that we cannot ignore the bitmap_set, even if we select the the
> > NFT_SET_POL_MEMORY policy without the set size specified, we will still
> > choose the bitmap_set, since it claims that it's space complexity is
> > NFT_SET_CLASS_O_1.
> 
> Make sense. Please, submit patches for nf-next to revisit POL_MEMORY
> selection explaining the new criteria. I guess we will need more
> iterations on this set selection as we get more set backends. I wanted
> to dedicate some time on this during the Netfilter Workshop (to be
> announce, by Q2 2017).
> 
> Note that an anonymous sets default to POL_PERFORMANCE, so 20 rules
> with anonymous sets would still consumed those 320 kB. So probably we
> need a per-table global policy switch that we can set when the table
> is created. I think updating such knob would result in EOPNOTSUPP at
> this stage, as we would need a way to transfer set representations
> from one backend to another if the policy update results in a
> different set backend configuration in order to support
> performance/memory policy updates.

Another possibility is to simply regard desc->size over the memory
scalability notation when provided. I think this just needs an update
from nft userspace. Look, bitmap and hashtable are both described as
O(1) in terms of performance. If the user provides the set size (this
is known in anonymous sets) we can select the one that takes less
memory. When no size is specified, we rely on the set policy that is
specified.

Still, for anonymous sets we will select hashtable instead, this is
going to be slower in systems that have plenty of memory. I think we
cannot escape the new per-table global knob to select
memory/performance for anononymous sets after all.

I'm curious, what kind of device are you thinking of with such memory
restrictions that cannot take 320 kB? I would expect such embedded
device that cannot afford such memory consumption will come also with
a smallish cpu.
