From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: invoke synchronize_rcu after set the
 _hook_ to NULL
Date: Fri, 24 Mar 2017 19:45:16 +0100
Message-ID: <20170324184516.GA2388@salvia>
References: <1490015030-16403-1-git-send-email-zlpnobody@163.com>
 <20170324121707.GA2764@salvia>
 <CAML_gOeOE_TSJb2hsNoGBopF_-kxdj3n4c4nzge9qR0q52wpYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53792 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751410AbdCXSpX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 14:45:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B2D6C1EC2C4
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 19:45:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A570BFC2DC
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 19:45:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4453EFB471
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 19:45:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAML_gOeOE_TSJb2hsNoGBopF_-kxdj3n4c4nzge9qR0q52wpYA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 24, 2017 at 09:01:17PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-03-24 20:17 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> >> --- a/net/netfilter/nfnetlink_cttimeout.c
> >> +++ b/net/netfilter/nfnetlink_cttimeout.c
> >> @@ -646,8 +646,8 @@ static void __exit cttimeout_exit(void)
> >>  #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
> >>       RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
> >>       RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
> >> +     synchronize_rcu();
> >>  #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
> >> -     rcu_barrier();
> >
> > cttimeout relies on kfree_rcu().
> >
> > Are you sure we don't need this?
> >
> > According to:
> >
> > https://www.kernel.org/doc/Documentation/RCU/rcubarrier.txt
> >
> > "We could try placing a synchronize_rcu() in the module-exit code path,
> > but this is not sufficient."
> >
> > Then:
> >
> > "Please note that rcu_barrier() does -not- imply synchronize_rcu(), in
> > particular, if there are no RCU callbacks queued anywhere,
> > rcu_barrier() is within its rights to return immediately, without
> > waiting for a grace period to elapse."
> 
> This is because we use kfree_rcu to free the cttimeout objects. So I think
> rcu_barrier() is not needed anymore.
> 
> Quoted from https://lwn.net/Articles/433493/ :
> "And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
> queue any function which belong to the module, so a rcu_barrier() can
> be avoid when module exit."
> 
> Also from commit 9ab1544eb419 ("rcu: introduce kfree_rcu()"):
> "Many rcu callbacks functions just call kfree() on the base structure.
> These functions are trivial, but their size adds up, and furthermore
> when they are used in a kernel module, that module must invoke the
> high-latency rcu_barrier() function at module-unload time."

Right, thanks for explaining.

I think we can get this smaller: it should be possible to avoid this
synchronize_rcu() call from nf_conntrack_{register,unregister}_notifier().
These two are called from ctnetlink netns path, this patch already
adds a synchronize_rcu() spot to ctnetlink module removal which is
where the event callback can vanish.

You can just add a comment there so we don't forget about this, eg.

@@ -290,6 +290,7 @@  void nf_conntrack_unregister_notifier(struct net
*net,
        BUG_ON(notify != new);
        RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
        mutex_unlock(&nf_ct_ecache_mutex);
+       /* synchronize_rcu() is called from ctnetlink. */
 }

What do you think?
