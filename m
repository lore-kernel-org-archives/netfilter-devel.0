From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/8] netfilter: ipset: Prepare ipset core for RCU locking
 instead of rwlock per set
Date: Thu, 18 Dec 2014 19:38:33 +0100
Message-ID: <20141218183833.GA3552@salvia>
References: <1418421489-17411-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1418421489-17411-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51859 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaLRSgE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:36:04 -0500
Content-Disposition: inline
In-Reply-To: <1418421489-17411-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

Several comments to this new round.

On Fri, Dec 12, 2014 at 10:58:03PM +0100, Jozsef Kadlecsik wrote:
> @@ -1407,9 +1407,13 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
>  	bool eexist = flags & IPSET_FLAG_EXIST, retried = false;
>  
>  	do {
> -		write_lock_bh(&set->lock);
> +		spin_lock_bh(&set->lock);
>  		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
> -		write_unlock_bh(&set->lock);
> +		spin_unlock_bh(&set->lock);
> +		if (ret == -EINPROGRESS) {
> +			synchronize_rcu_bh();

Let me zoom in to code that is related to this -EINPROGRESS case.

> +			ret = 0;
> +		}
>  		retried = true;
>  	} while (ret == -EAGAIN &&
>  		 set->variant->resize &&

>From list_set_uadd():

       ...
       if (n) {
               list_set_replace(set, e, n);
               ret = -EINPROGRESS;

This EINPROGRESS is propagated via set->variant->uadt(), which results
in th synchronize_rcu_bh() from the core.

Then, let's have a look at list_set_replace():

>static inline void
>list_set_replace(struct ip_set *set, struct set_elem *e, struct set_elem *old)
>{
>       list_replace_rcu(&old->list, &e->list);
>       __list_set_del(set, old);
>}

This uses list rcu safe variant, this is good.

>static void
>__list_set_del(struct ip_set *set, struct set_elem *e)
> {
[...]
>        kfree_rcu(e, rcu);
>}

You use kfree_rcu() to defer the release of the object by when no
readers are walking over those bits, good.

But then, you don't need the synchronize_rcu(). To clarify:

1) If you release memory synchronously, you use this pattern:

  list_replace_rcu(...);
  synchronize_rcu(); <---- waits until no readers are referencing to
                           objects that we removes with the rcu safe list
                           variant
  kfree(...);

2) If you release memory asynchronously, then:

  list_replace_rcu(...);
  kfree_rcu(...);

In this case, I think you don't need to call synchronize_rcu() since
you selected approach 2).

More concerns: Let's revisit __list_set_del():

>static void
>__list_set_del(struct ip_set *set, struct set_elem *e)
> {
>        struct list_set *map = set->data;
> 
>        ip_set_put_byindex(map->net, e->id);
>        /* We may call it, because we don't have a to be destroyed
>         * extension which is used by the kernel.
>         */
>        ip_set_ext_destroy(set, e);
         ^.......................^

You may have a reader still walking on the extension area of the
element by when you call this.

>        kfree_rcu(e, rcu);
>}

The alternative to make sure that everything is released by when no
readers are accessing the object anymore is to use call_rcu():

        call_rcu(e, ipset_list_free_rcu);

Then:

static void ipset_list_free_rcu(struct rcu_head *rcu)
{
        ip_set_put_byindex(...);
        ip_set_ext_destroy(...);
        kfree(set);
}

This safely release memory with 100% guarantee no readers are accesing
the object you're destroying.

*But* you have to make sure none of those function in the callback may
sleep. Since this callback is called from the rcu softirq (interrupt
context).

I suspect (actually I would need to make a closer look) you cannot use
this pattern easily unless elements keep a pointer to the set they
belong to, to access the data you need from the callback.

Let me know,
Thanks.
