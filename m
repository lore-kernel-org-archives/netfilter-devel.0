From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8] [PATCH] Helper modules load-on-demand support for
 ctnetlink
Date: Thu, 09 Oct 2008 15:34:22 +0200
Message-ID: <48EE085E.2020701@trash.net>
References: <20081009083339.9824.24056.stgit@Decadence> <20081009083422.9824.35589.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51337 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084AbYJINeZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:34:25 -0400
In-Reply-To: <20081009083422.9824.35589.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds module loading for helpers via ctnetlink.
> 
> * Creation path: We support explicit and implicit helper assignation. For
>   the explicit case, we try to load the module. If the module is correctly
>   loaded and the helper is present, we return EAGAIN to re-start the
>   creation. Otherwise, we return EOPNOTSUPP.
> * Update path: release the spin lock, load the module and check. If it is
>   present, then return EAGAIN to re-start the update.
> 
> This patch includes a minor change in nfnetlink to support EAGAIN.
> Based on a suggestion from Patrick McHardy.
> 
> This patch provides a refactorized function to lookup-and-set the
> connection tracking helper. The function removes the exported symbol
> __nf_ct_helper_find as it has not clients anymore.

This one doesn't apply:

patching file include/net/netfilter/nf_conntrack_helper.h
patching file net/netfilter/nf_conntrack_core.c
Hunk #1 FAILED at 581.
Hunk #2 succeeded at 753 (offset -5 lines).
Hunk #3 succeeded at 764 (offset -5 lines).
1 out of 3 hunks FAILED -- saving rejects to file 
net/netfilter/nf_conntrack_core.c.rej
patching file net/netfilter/nf_conntrack_helper.c
patching file net/netfilter/nf_conntrack_netlink.c
Hunk #2 succeeded at 1131 with fuzz 1.
patching file net/netfilter/nfnetlink.c

> +static inline int nf_ct_set_helper(struct nf_conn *ct, gfp_t flags)
> +{
> +	int ret;
> +
> +	rcu_read_lock();
> +	ret = __nf_ct_set_helper(ct, flags);
> +	rcu_read_unlock();

Its a bit confusing to use rcu_read_lock for a function called
_set_something, I would suggest to just do the rcu_read_lock
in that function itself.

> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index f38c649..a649f7b 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -952,8 +952,22 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
>  	}
>  
>  	helper = __nf_conntrack_helper_find_byname(helpname);
> -	if (helper == NULL)
> +	if (helper == NULL) {
> +#ifdef CONFIG_KMOD
> +		spin_unlock_bh(&nf_conntrack_lock);
> +
> +		if (request_module("nfct-helper-%s", helpname) < 0) {
> +			spin_lock_bh(&nf_conntrack_lock);
> +			return -EOPNOTSUPP;

EOPNOTSUPP doesn't seem wrong, but we usually use ENOENT for lookup
failures. It also needs to drop the nfnl_lock for request_module().

> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index b75c9c4..323dcf8 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -165,7 +165,8 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  		} else
>  			return -EINVAL;
>  
> -		return nc->call(nfnl, skb, nlh, cda);
> +		while ((err = nc->call(nfnl, skb, nlh, cda)) == -EAGAIN);

Ughh no hiding of ";" please :) With dropping nfnl_lock() in ctnetlink,
this needs to do the get_subsys() and find_client() again anyways since
both are protected by that lock.

I have this patch in my nftables tree:

@@ -132,6 +140,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, 
struct nlmsghdr *nlh)
                 return 0;

         type = nlh->nlmsg_type;
+replay:
         ss = nfnetlink_get_subsys(type);
         if (!ss) {
  #ifdef CONFIG_KMOD
@@ -165,7 +174,10 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, 
struct nlmsghdr *nlh)
                 } else
                         return -EINVAL;

-               return nc->call(nfnl, skb, nlh, cda);
+               err = nc->call(nfnl, skb, nlh, cda);
+               if (err == -EAGAIN)
+                       goto replay;
+               return err;
         }
  }

