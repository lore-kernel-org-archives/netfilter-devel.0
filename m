From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] netfilter: nat: work around shared nfct struct in
 bridge case
Date: Tue, 30 Aug 2011 15:44:11 +0200
Message-ID: <4E5CE92B.2010006@trash.net>
References: <1314710938-25342-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55826 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1H3NoQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:44:16 -0400
In-Reply-To: <1314710938-25342-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30.08.2011 15:28, Florian Westphal wrote:
> diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
> index 9c71b27..bd89744 100644
> --- a/net/ipv4/netfilter/nf_nat_core.c
> +++ b/net/ipv4/netfilter/nf_nat_core.c
> @@ -265,6 +265,35 @@ out:
>  	rcu_read_unlock();
>  }
>  
> +/* bridge netfilter uses cloned skbs when forwarding to multiple bridge ports.
> + * when userspace queueing is involved, we might try to set up NAT bindings
> + * on the same conntrack simultaneoulsy.  Can happen e.g. when broadcast has
> + * to be forwarded by the bridge but is also passed up the stack.
> + *
> + * Thus, when bridge netfilter is enabled, we need to serialize and silently
> + * accept the packet in the collision case.
> + */
> +static inline bool nf_nat_bridge_lock(struct nf_conn *ct, enum nf_nat_manip_type maniptype)
> +{
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +	spin_lock_bh(&ct->lock);
> +
> +	if (unlikely(nf_nat_initialized(ct, maniptype))) {
> +		pr_debug("race with cloned skb? Not adding NAT extension\n");
> +		spin_unlock_bh(&ct->lock);
> +		return false;
> +	}
> +#endif
> +	return true;
> +}

Ugh, what beauty :) I can't see a much nicer way how to fix this right
now, but I really want to have another look for different possibilities
before applying this.

Unfortunately pushing this down to nf_nat_setup_info() could only fix
the BUG(), but we'd still have a possible memory leak when adding the
NAT extension simulaneously on multiple CPUs. I also fear this is not
going to be the only problem caused by breaking the "unconfirmed means
non-shared nfct" assumption.

> +
> +static inline void nf_nat_bridge_unlock(struct nf_conn *ct)
> +{
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +	spin_unlock_bh(&ct->lock);
> +#endif
> +}
> +
>  unsigned int
>  nf_nat_setup_info(struct nf_conn *ct,
>  		  const struct nf_nat_range *range,
> @@ -274,18 +303,23 @@ nf_nat_setup_info(struct nf_conn *ct,
>  	struct nf_conntrack_tuple curr_tuple, new_tuple;
>  	struct nf_conn_nat *nat;
>  
> +	NF_CT_ASSERT(maniptype == IP_NAT_MANIP_SRC ||
> +		     maniptype == IP_NAT_MANIP_DST);
> +
> +	if (!nf_nat_bridge_lock(ct, maniptype))
> +		return NF_ACCEPT;
> +
>  	/* nat helper or nfctnetlink also setup binding */
>  	nat = nfct_nat(ct);
>  	if (!nat) {
>  		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
>  		if (nat == NULL) {
> +			nf_nat_bridge_unlock(ct);
>  			pr_debug("failed to add NAT extension\n");
>  			return NF_ACCEPT;
>  		}
>  	}
>  
> -	NF_CT_ASSERT(maniptype == IP_NAT_MANIP_SRC ||
> -		     maniptype == IP_NAT_MANIP_DST);
>  	BUG_ON(nf_nat_initialized(ct, maniptype));
>  
>  	/* What we've got will look like inverse of reply. Normally
> @@ -332,6 +366,7 @@ nf_nat_setup_info(struct nf_conn *ct,
>  	else
>  		ct->status |= IPS_SRC_NAT_DONE;
>  
> +	nf_nat_bridge_unlock(ct);
>  	return NF_ACCEPT;
>  }
>  EXPORT_SYMBOL(nf_nat_setup_info);

