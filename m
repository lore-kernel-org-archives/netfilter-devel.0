From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Tue, 21 Feb 2012 15:52:34 +0100
Message-ID: <20120221145234.GB25826@1984>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38563 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2BUOwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:52:37 -0500
Content-Disposition: inline
In-Reply-To: <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Tue, Feb 21, 2012 at 02:53:57PM +0100, Jozsef Kadlecsik wrote:
> Marcell Zambo and Janos Farago noticed and reported that when
> new conntrack entries are added via netlink and the conntrack table
> gets full, soft lockup happens. This is because the nf_conntrack_lock
> is held while nf_conntrack_alloc is called, which is in turn wants
> to lock nf_conntrack_lock while evicting entries from the full table.

Good catch.

> The patch fixes the soft lockup with limiting the holding of the
> nf_conntrack_lock to the minimum, where it's absolutely required.

Still one issue, see below.

> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/netfilter/nf_conntrack_netlink.c |   43 ++++++++++++---------------------
>  1 files changed, 16 insertions(+), 27 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 9307b03..cc70517 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1367,15 +1367,12 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
>  						    nf_ct_protonum(ct));
>  		if (helper == NULL) {
>  			rcu_read_unlock();
> -			spin_unlock_bh(&nf_conntrack_lock);
>  #ifdef CONFIG_MODULES
>  			if (request_module("nfct-helper-%s", helpname) < 0) {
> -				spin_lock_bh(&nf_conntrack_lock);
>  				err = -EOPNOTSUPP;
>  				goto err1;
>  			}
>  
> -			spin_lock_bh(&nf_conntrack_lock);
>  			rcu_read_lock();
>  			helper = __nf_conntrack_helper_find(helpname,
>  							    nf_ct_l3num(ct),
> @@ -1469,7 +1466,10 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
>  		tstamp->start = ktime_to_ns(ktime_get_real());
>  
>  	add_timer(&ct->timeout);
> +	spin_lock_bh(&nf_conntrack_lock);
>  	nf_conntrack_hash_insert(ct);
> +	nf_conntrack_get(&ct->ct_general);
> +	spin_unlock_bh(&nf_conntrack_lock);
>  	rcu_read_unlock();
>  
>  	return ct;
> @@ -1490,6 +1490,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
>  	struct nf_conntrack_tuple otuple, rtuple;
>  	struct nf_conntrack_tuple_hash *h = NULL;
>  	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
> +	struct nf_conn *ct;
>  	u_int8_t u3 = nfmsg->nfgen_family;
>  	u16 zone;
>  	int err;
> @@ -1512,25 +1513,22 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
>  
>  	spin_lock_bh(&nf_conntrack_lock);
>  	if (cda[CTA_TUPLE_ORIG])
> -		h = __nf_conntrack_find(net, zone, &otuple);
> +		h = nf_conntrack_find_get(net, zone, &otuple);
>  	else if (cda[CTA_TUPLE_REPLY])
> -		h = __nf_conntrack_find(net, zone, &rtuple);
> +		h = nf_conntrack_find_get(net, zone, &rtuple);
> +	spin_unlock_bh(&nf_conntrack_lock);

We still have to keep the lock for the update case. Otherwise we may
clash with one update from the kernel.
