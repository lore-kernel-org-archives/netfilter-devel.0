From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/2] netfilter: conntrack: simplify the code by
 using nf_conntrack_get_ht
Date: Tue, 12 Jul 2016 15:03:03 +0200
Message-ID: <20160712130303.GE17163@breakpoint.cc>
References: <1468323901-15767-1-git-send-email-zlpnobody@163.com>
 <1468323901-15767-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40185 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933088AbcGLNDM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 09:03:12 -0400
Content-Disposition: inline
In-Reply-To: <1468323901-15767-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Since Commit 64b87639c9cb ("netfilter: conntrack: fix race between
> nf_conntrack proc read and hash resize") introdue the
> nf_conntrack_get_ht, so there's no need to check nf_conntrack_generation
> again and again to get the hash table and hash size.
> 
> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> ---
>  net/netfilter/nf_conntrack_core.c | 30 +++++++++++-------------------
>  1 file changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 2d46225..bafebf7 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -461,7 +461,8 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
>  }
>  
>  /* must be called with rcu read lock held */
> -void nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)
> +inline void
> +nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)

Which "inline void"?  This is very unusual.

I would suggest to not add it, and ...

>  {
>  	struct hlist_nulls_head *hptr;
>  	unsigned int sequence, hsz;
> @@ -489,14 +490,11 @@ ____nf_conntrack_find(struct net *net, const struct nf_conntrack_zone *zone,
>  	struct nf_conntrack_tuple_hash *h;
>  	struct hlist_nulls_head *ct_hash;
>  	struct hlist_nulls_node *n;
> -	unsigned int bucket, sequence;
> +	unsigned int bucket, hsize;
>  
>  begin:
> -	do {
> -		sequence = read_seqcount_begin(&nf_conntrack_generation);
> -		bucket = scale_hash(hash);
> -		ct_hash = nf_conntrack_hash;
> -	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
> +	nf_conntrack_get_ht(&ct_hash, &hsize);
> +	bucket = reciprocal_scale(hash, hsize);

leave ____nf_conntrack_find alone, but convert

> @@ -801,18 +799,15 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,

This one ..

> @@ -878,14 +873,11 @@ static noinline int early_drop(struct net *net, unsigned int _hash)


... and this one too.

