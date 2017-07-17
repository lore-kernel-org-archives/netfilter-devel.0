From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] monitor: fix printing of range elements in named sets
Date: Mon, 17 Jul 2017 18:26:59 +0200
Message-ID: <20170717162659.GA1162@salvia>
References: <149935174634.19966.16018870027671610502.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53454 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751284AbdGQQ1I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 12:27:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1DCDD24714
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:26:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E07BCE360
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:26:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C808ED1CAB
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:26:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149935174634.19966.16018870027671610502.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Thu, Jul 06, 2017 at 04:36:45PM +0200, Arturo Borrero Gonzalez wrote:
> If you add set elements to interval sets, the output is wrong.
> Fix this by caching first element of the range (first event),
> then wait for the second element of the range (second event) to
> print them both at the same time.
> 
> We also avoid printing the first null element required in the RB tree.
> 
> Before this patch:
> 
> % nft add element t s {10-20, 30-40}
> add element ip t s { 0 }
> add element ip t s { 10 }
> add element ip t s { ftp }
> add element ip t s { 30 }
> add element ip t s { 41 }
> 
> After this patch:
> 
> % nft add element t s {10-20, 30-40}
> add element ip t s { 10-20 }
> add element ip t s { 30-40 }
> 
> CC: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> ---
> 
> This was discussed during Netfilter Workshop 2017 in Faro, Portugal.
> I think Phil has another patch to address this issue from a different
> approach.

I like this approach, it's simple. Still you mentioned it doesn't work
for several cases. One of them are deletions.

Also Phil has found a number of corner cases that still need special
handling, problems are:

1) nft flush set gets elements in reverse order, we can probably fix
   this from the kernel (flush set support is quite recent). Or just
   use the mergesort function to get them sorted out from userspace.

2) Half-open ranges, it's just a single element with the end flag
   interval set on, in such case, we just print what we have.

Anything else?

There's a list of threads discussing this split in several patches,
it's making it a bit hard to follow you guys ;-).

>  include/rule.h |    2 ++
>  src/netlink.c  |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/include/rule.h b/include/rule.h
> index 7424b21..1b44e4c 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -217,6 +217,7 @@ extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
>   * @datalen:	mapping data len
>   * @objtype:	mapping object type
>   * @init:	initializer
> + * @rg_cache:	cached range element (left)
>   * @policy:	set mechanism policy
>   * @desc:	set mechanism desc
>   */
> @@ -234,6 +235,7 @@ struct set {
>  	unsigned int		datalen;
>  	uint32_t		objtype;
>  	struct expr		*init;
> +	struct expr		*rg_cache;

Why not just add this element to the set, instead of caching it here
in this new field? I mean, place it in set->init?

>  	uint32_t		policy;
>  	struct {
>  		uint32_t	size;
