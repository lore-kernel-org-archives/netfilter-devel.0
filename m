From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 2/4] libnftables: Introduce nft_ctx_flush_cache()
Date: Wed, 25 Oct 2017 11:25:15 +0200
Message-ID: <20171025092515.GB350@salvia>
References: <20171023153319.13415-1-phil@nwl.cc>
 <20171023153319.13415-3-phil@nwl.cc>
 <20171024155258.GB11705@salvia>
 <20171024174021.GR32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Eric Leblond <eric@regit.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50844 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932284AbdJYJZU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2017 05:25:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA2F76138E
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2017 11:25:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B97D4DA3B1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2017 11:25:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171024174021.GR32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Tue, Oct 24, 2017 at 07:40:21PM +0200, Phil Sutter wrote:
[...]
> I wonder whether we need to reset the cache at all:

Good point.

> We could make cache_update() ignore cache->initialized and instead
> check whether nft_genid did change after calling netlink_genid_get()
> - if not, cache is up to date, otherwise call cache_init(). When we
> discussed possible performance implications of cache updates, I
> suggested just that as a first counter-measure.
> 
> Could this work? Or am I missing something?

For the simple API, I think it makes sense to remove this
nft_ctx_flush_cache() and just perform inconditional cache refresh on
every nft_cmd_*() call by now.

We can revisit later on to do incremental cache updates based on
generation ID as you said. If we keep track of incremental updates,
then we will need event handling. But for now I will go simple.

Thanks!
