From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Fri, 24 Feb 2012 12:18:00 +0100
Message-ID: <20120224111800.GA9669@1984>
References: <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
 <20120223101250.GA3547@1984>
 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu>
 <20120223154646.GA4790@1984>
 <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu>
 <20120224012449.GA7005@1984>
 <alpine.DEB.2.00.1202240850220.14113@blackhole.kfki.hu>
 <20120224095959.GA9127@1984>
 <alpine.DEB.2.00.1202241104580.14329@blackhole.kfki.hu>
 <alpine.DEB.2.00.1202241143001.14577@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36224 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab2BXLSF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:18:05 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202241143001.14577@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 24, 2012 at 11:45:49AM +0100, Jozsef Kadlecsik wrote:
> On Fri, 24 Feb 2012, Jozsef Kadlecsik wrote:
> 
> > OK, and I remove nf_conntrack_hash_insert then, and use a single ct 
> > argument because as you noted net and zone can be extracted from the ct.
> 
> Here comes the second version of the patch, which assumes that the 
> previous one is reverted.
> 
> Best regards,
> Jozsef
> 
> Marcell Zambo and Janos Farago noticed and reported that when
> new conntrack entries are added via netlink and the conntrack table
> gets full, soft lockup happens. This is because the nf_conntrack_lock
> is held while nf_conntrack_alloc is called, which is in turn wants
> to lock nf_conntrack_lock while evicting entries from the full table.
> 
> The patch fixes the soft lockup with limiting the holding of the
> nf_conntrack_lock to the minimum, where it's absolutely required.
> It required to extend (and thus change) nf_conntrack_hash_insert
> so that it makes sure conntrack and ctnetlink do not add the same entry
> twice to the conntrack table.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/net/netfilter/nf_conntrack.h |    2 +-
>  net/netfilter/nf_conntrack_core.c    |   38 ++++++++++++++++++++--
>  net/netfilter/nf_conntrack_netlink.c |   58 +++++++++++++--------------------
>  3 files changed, 58 insertions(+), 40 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 8a2b0ae..ab86036 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -209,7 +209,7 @@ extern struct nf_conntrack_tuple_hash *
>  __nf_conntrack_find(struct net *net, u16 zone,
>  		    const struct nf_conntrack_tuple *tuple);
>  
> -extern void nf_conntrack_hash_insert(struct nf_conn *ct);
> +extern int nf_conntrack_hash_check_insert(struct nf_conn *ct);
>  extern void nf_ct_delete_from_lists(struct nf_conn *ct);
>  extern void nf_ct_insert_dying_list(struct nf_conn *ct);
>  
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 76613f5..ed86a3b 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -404,19 +404,49 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
>  			   &net->ct.hash[repl_hash]);
>  }
>  
> -void nf_conntrack_hash_insert(struct nf_conn *ct)
> +int
> +nf_conntrack_hash_check_insert(struct nf_conn *ct)
>  {
>  	struct net *net = nf_ct_net(ct);
>  	unsigned int hash, repl_hash;
> +	struct nf_conntrack_tuple_hash *h;
> +	struct hlist_nulls_node *n;
>  	u16 zone;
>  
>  	zone = nf_ct_zone(ct);
> -	hash = hash_conntrack(net, zone, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
> -	repl_hash = hash_conntrack(net, zone, &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
> +	hash = hash_conntrack(net, zone,
> +			      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
> +	repl_hash = hash_conntrack(net, zone,
> +				   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
> +
> +	spin_lock_bh(&nf_conntrack_lock);
>  
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
> +	nf_conntrack_get(&ct->ct_general);
>  	__nf_conntrack_hash_insert(ct, hash, repl_hash);
> +	NF_CT_STAT_INC(net, insert);
> +	spin_unlock_bh(&nf_conntrack_lock);
> +
> +	return 0;
> +
> +out:
> +	NF_CT_STAT_INC(net, insert_failed);
> +	spin_unlock_bh(&nf_conntrack_lock);
> +	return -EEXIST;
>  }
> -EXPORT_SYMBOL_GPL(nf_conntrack_hash_insert);
> +EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
>  
>  /* Confirm a connection given skb; places it in hash table */
>  int
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 9307b03..6d73501 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1345,7 +1345,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
>  	struct nf_conntrack_helper *helper;
>  	struct nf_conn_tstamp *tstamp;
>  
> -	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
> +	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_KERNEL);
>  	if (IS_ERR(ct))
>  		return ERR_PTR(-ENOMEM);
>  

Sorry, I was wrong. I didn't notice that this is called holding
rcu_read_lock() inside nfnetlink.c and we cannot use GFP_KERNEL
inside read-lock area.

I'm going to take the patch and will fix this myself.

Thanks Jozsef.
