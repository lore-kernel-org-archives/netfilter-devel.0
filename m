From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] netfilter: don't use INIT_RCU_HEAD()
Date: Thu, 11 Feb 2010 14:46:51 -0800
Message-ID: <20100211224651.GF6759@linux.vnet.ibm.com>
References: <20100211194911.GA9756@x200>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43618 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab0BKWqy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:46:54 -0500
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o1BMaV1S021768
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 17:36:31 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o1BMkqce102134
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 17:46:52 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o1BMkqs2001644
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 17:46:52 -0500
Content-Disposition: inline
In-Reply-To: <20100211194911.GA9756@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 11, 2010 at 09:49:11PM +0200, Alexey Dobriyan wrote:
> call_rcu() will unconditionally reinitialize RCU head anyway.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  net/netfilter/nf_conntrack_expect.c |    1 -
>  net/netfilter/nf_conntrack_extend.c |    1 -
>  net/netfilter/nfnetlink_queue.c     |    1 -
>  3 files changed, 3 deletions(-)
> 
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -232,7 +232,6 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
> 
>  	new->master = me;
>  	atomic_set(&new->use, 1);
> -	INIT_RCU_HEAD(&new->rcu);
>  	return new;
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
> --- a/net/netfilter/nf_conntrack_extend.c
> +++ b/net/netfilter/nf_conntrack_extend.c
> @@ -59,7 +59,6 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
>  	if (!*ext)
>  		return NULL;
> 
> -	INIT_RCU_HEAD(&(*ext)->rcu);
>  	(*ext)->offset[id] = off;
>  	(*ext)->len = len;
> 
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -112,7 +112,6 @@ instance_create(u_int16_t queue_num, int pid)
>  	inst->copy_mode = NFQNL_COPY_NONE;
>  	spin_lock_init(&inst->lock);
>  	INIT_LIST_HEAD(&inst->queue_list);
> -	INIT_RCU_HEAD(&inst->rcu);
> 
>  	if (!try_module_get(THIS_MODULE)) {
>  		err = -EAGAIN;
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
