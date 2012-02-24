From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Fri, 24 Feb 2012 02:24:49 +0100
Message-ID: <20120224012449.GA7005@1984>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20120221145234.GB25826@1984>
 <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
 <20120223101250.GA3547@1984>
 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu>
 <20120223154646.GA4790@1984>
 <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37606 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab2BXBZJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:25:09 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 23, 2012 at 09:44:21PM +0100, Jozsef Kadlecsik wrote:
> OK, here it comes:
> 
> The previous patch with the title "netfilter: fix soft lockup
> when netlink adds new entries" introduced a race: conntrack and
> ctnetlink could insert the same entry twice into the hash table.
> The patch eliminates the race condition by using the same checking
> as conntrack confirm does.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/net/netfilter/nf_conntrack.h |    2 +
>  net/netfilter/nf_conntrack_core.c    |   41 ++++++++++++++++++++++++++++++++++
>  net/netfilter/nf_conntrack_netlink.c |    9 +++----
>  3 files changed, 47 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 8a2b0ae..48bfe75 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -210,6 +210,8 @@ __nf_conntrack_find(struct net *net, u16 zone,
>  		    const struct nf_conntrack_tuple *tuple);
>  
>  extern void nf_conntrack_hash_insert(struct nf_conn *ct);
> +extern int nf_conntrack_hash_check_insert(struct net *net, u16 zone,
> +					  struct nf_conn *ct);

nf_conntrack_hash_insert has no clients anymore after this change.

We have two choices here:

1) Expand nf_conntrack_hash_insert to perform the checking inside. You can
use the same prototype btw, net and zone can be extracted from the ct.

2) For better code readability (and we save one exported symbol), add
the code that you propose for nf_conntrack_hash_check_insert to
nf_conntrack_netlink.c. I don't think we would ever have another client
of nf_conntrack_hash_insert.

I think I prefer option 2.

BTW, nf_conntrack_alloc allocation can now be GFP_KERNEL.

>  extern void nf_ct_delete_from_lists(struct nf_conn *ct);
>  extern void nf_ct_insert_dying_list(struct nf_conn *ct);
>  
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 76613f5..3d829d6 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -418,6 +418,47 @@ void nf_conntrack_hash_insert(struct nf_conn *ct)
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_hash_insert);
>  
> +int
> +nf_conntrack_hash_check_insert(struct net *net, u16 zone, struct nf_conn *ct)
> +{
> +	unsigned int hash, repl_hash;
> +	struct nf_conntrack_tuple_hash *h;
> +	struct hlist_nulls_node *n;
> +
> +	hash = hash_conntrack(net, zone,
> +			      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
> +	repl_hash = hash_conntrack(net, zone,
> +				   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
> +
> +	spin_lock_bh(&nf_conntrack_lock);
> +
> +	/* See if there's one in the list already, including reverse */
> +	hlist_nulls_for_each_entry(h, n, &net->ct.hash[hash], hnnode)
> +		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> +				      &h->tuple) &&
> +		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
> +			goto out;
> +	hlist_nulls_for_each_entry(h, n, &net->ct.hash[repl_hash], hnnode)
> +		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> +				      &h->tuple) &&
> +		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
> +			goto out;
> +
> +	add_timer(&ct->timeout);
> +	atomic_inc(&ct->ct_general.use);

better nf_conntrack_get?

> +	__nf_conntrack_hash_insert(ct, hash, repl_hash);
> +	NF_CT_STAT_INC(net, insert);

Good catch, this stats increment was missing.

> +	spin_unlock_bh(&nf_conntrack_lock);
> +
> +	return 0;
> +
> +out:
> +	NF_CT_STAT_INC(net, insert_failed);
> +	spin_unlock_bh(&nf_conntrack_lock);
> +	return -EEXIST;
> +}
> +EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
> +
>  /* Confirm a connection given skb; places it in hash table */
>  int
>  __nf_conntrack_confirm(struct sk_buff *skb)
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index cc70517..379d34e 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1465,11 +1465,10 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
>  	if (tstamp)
>  		tstamp->start = ktime_to_ns(ktime_get_real());
>  
> -	add_timer(&ct->timeout);

Hm, this timer addition out of the lock slipped through the previous
patch.

I think it's better if we revert the previous patch and we pass a new
revamped version including the initial and this change.

It will be easier to pass it to -stable.

Would you be OK with this?

Thanks Jozsef.
