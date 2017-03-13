From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 nf] netfilter: nft_set_bitmap: keep a list of dummy
 elements
Date: Mon, 13 Mar 2017 18:23:44 +0100
Message-ID: <20170313172344.GA32297@salvia>
References: <1489408071-6123-1-git-send-email-pablo@netfilter.org>
 <CAML_gOf5DM6W81b34EQQz+hdsFb-72jq4BhtRK4d2657Ks9bHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753550AbdCMRXy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 13:23:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 59C8E1B2B86
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 18:23:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49BB1DA7E0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 18:23:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22774DA7E0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 18:23:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAML_gOf5DM6W81b34EQQz+hdsFb-72jq4BhtRK4d2657Ks9bHg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Liping,

On Mon, Mar 13, 2017 at 10:23:53PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-03-13 20:27 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > Element comments may come without any prior set flag, so we have to keep
> > a list of dummy struct nft_set_ext to keep this information around. This
> > is only useful for set dumps to userspace. From the packet path, this
> > set type relies on the bitmap representation. This patch simplifies the
> > logic since we don't need to allocate the dummy nft_set_ext structure
> > anymore on the fly at the cost of increasing memory consumption because
> > of the list of dummy struct nft_set_ext.
> 
> If I didn't misunderstand it, I think after introducing the dummy nft_set_ext,
> the nft_bitmap_estimate() should also be updated? i.e.:
> 
> 1. est->size should be recalculated
> 2. est->space should be changed to NFT_SET_CLASS_O_N

I would like this only describes the representation that is exposed to
the packet path, not the real memory consumption of it. I know I'm
kind of cheating, but with this I'm also giving this bitmap an
advantage over the hashtable representation, the performance numbers I
gathered here when evaluating it are better.

Anyway, I'll be fine if this triggers some discussions on the set
backend selection at some point, as well as more detailed performance
evaluation. Note this big O notation just tell about the scalability.
Size provides an accurate way to measure how much memory this consumes
but only if userspace tells us how many elements we're going to add
beforehand. On the CPU side, we have no such specific metric as the
memory size. Probably we can introduce some generic cycle metric that
represents the cost of the lookup path, this won't be simple as this
number is not deterministic since there are many things to consider,
so we have to agree on how we calculate this pseudo-metric.
