From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: invoke synchronize_rcu after set the
 _hook_ to NULL
Date: Fri, 24 Mar 2017 13:17:07 +0100
Message-ID: <20170324121707.GA2764@salvia>
References: <1490015030-16403-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45912 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935948AbdCXMRe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 08:17:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3A2C11E595
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 13:17:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3322DA863
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 13:17:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F9C0DA875
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 13:17:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1490015030-16403-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 20, 2017 at 09:03:50PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Otherwise, another CPU may access the invalid pointer. For example:
>     CPU0                CPU1
>      -              rcu_read_lock();
>      -              pfunc = _hook_;
>   _hook_ = NULL;          -
>   mod unload              -
>      -                 pfunc(); // invalid, panic
>      -             rcu_read_unlock();
> 
> So we must call synchronize_rcu() to wait the rcu reader to finish.
> 
> Also note, in nf_nat_snmp_basic_fini, synchronize_rcu() will be invoked
> by later nf_conntrack_helper_unregister, but I'm inclined to add a
> explicit synchronize_rcu after set the nf_nat_snmp_hook to NULL. Depend
> on such obscure assumptions is not a good idea.
> 
> Last, in nfnetlink_cttimeout, we use kfree_rcu to free the time object,
> so in cttimeout_exit, invoking rcu_barrier() is not necessary at all,
> remove it now.
> 
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> ---
>  net/ipv4/netfilter/nf_nat_snmp_basic.c | 1 +
>  net/netfilter/nf_conntrack_ecache.c    | 2 ++
>  net/netfilter/nf_conntrack_netlink.c   | 1 +
>  net/netfilter/nf_nat_core.c            | 2 ++
>  net/netfilter/nfnetlink_cttimeout.c    | 2 +-
>  5 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
> index c9b52c3..5a8f7c3 100644
> --- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
> +++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
> @@ -1304,6 +1304,7 @@ static int __init nf_nat_snmp_basic_init(void)
>  static void __exit nf_nat_snmp_basic_fini(void)
>  {
>  	RCU_INIT_POINTER(nf_nat_snmp_hook, NULL);
> +	synchronize_rcu();
>  	nf_conntrack_helper_unregister(&snmp_trap_helper);
>  }
>  
> diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
> index da9df2d..12cc98f 100644
> --- a/net/netfilter/nf_conntrack_ecache.c
> +++ b/net/netfilter/nf_conntrack_ecache.c
> @@ -290,6 +290,7 @@ void nf_conntrack_unregister_notifier(struct net *net,
>  	BUG_ON(notify != new);
>  	RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
>  	mutex_unlock(&nf_ct_ecache_mutex);
> +	synchronize_rcu();
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
>  
> @@ -326,6 +327,7 @@ void nf_ct_expect_unregister_notifier(struct net *net,
>  	BUG_ON(notify != new);
>  	RCU_INIT_POINTER(net->ct.nf_expect_event_cb, NULL);
>  	mutex_unlock(&nf_ct_ecache_mutex);
> +	synchronize_rcu();
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
>  
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 6806b5e..455c2c2 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -3441,6 +3441,7 @@ static void __exit ctnetlink_exit(void)
>  	nfnetlink_subsys_unregister(&ctnl_subsys);
>  #ifdef CONFIG_NETFILTER_NETLINK_GLUE_CT
>  	RCU_INIT_POINTER(nfnl_ct_hook, NULL);
> +	synchronize_rcu();
>  #endif
>  }
>  
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 94b14c5..82802e4 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -903,6 +903,8 @@ static void __exit nf_nat_cleanup(void)
>  #ifdef CONFIG_XFRM
>  	RCU_INIT_POINTER(nf_nat_decode_session_hook, NULL);
>  #endif
> +	synchronize_rcu();
> +
>  	for (i = 0; i < NFPROTO_NUMPROTO; i++)
>  		kfree(nf_nat_l4protos[i]);
>  
> diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
> index 139e086..47d6656 100644
> --- a/net/netfilter/nfnetlink_cttimeout.c
> +++ b/net/netfilter/nfnetlink_cttimeout.c
> @@ -646,8 +646,8 @@ static void __exit cttimeout_exit(void)
>  #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
>  	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
>  	RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
> +	synchronize_rcu();
>  #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
> -	rcu_barrier();

cttimeout relies on kfree_rcu().

Are you sure we don't need this?

According to:

https://www.kernel.org/doc/Documentation/RCU/rcubarrier.txt

"We could try placing a synchronize_rcu() in the module-exit code path,
but this is not sufficient."

Then:

"Please note that rcu_barrier() does -not- imply synchronize_rcu(), in
particular, if there are no RCU callbacks queued anywhere,
rcu_barrier() is within its rights to return immediately, without
waiting for a grace period to elapse."
