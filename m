From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ipset: Fix set:list type crash when
 flush/dump set in parallel
Date: Mon, 29 Feb 2016 13:22:18 +0100
Message-ID: <20160229122218.GA12101@salvia>
References: <1456345166-23605-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1456345166-23605-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53427 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbcB2MW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 07:22:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 103744B9E6
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:22:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F1445DA8FB
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:22:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DB1EFDA391
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:22:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1456345166-23605-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 24, 2016 at 09:19:26PM +0100, Jozsef Kadlecsik wrote:
> Flushing/listing entries was not RCU safe, so parallel flush/dump
> could lead to kernel crash. Bug reported by Deniz Eren.
> 
> Fixes netfilter bugzilla id #1050.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/netfilter/ipset/ip_set_core.c     |  3 ++
>  net/netfilter/ipset/ip_set_list_set.c | 55 ++++++++++++++++-------------------
>  2 files changed, 28 insertions(+), 30 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 95db43f..7e6568c 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -985,6 +985,9 @@ static int ip_set_destroy(struct net *net, struct sock *ctnl,
>  	if (unlikely(protocol_failed(attr)))
>  		return -IPSET_ERR_PROTOCOL;
>  
> +	/* Must wait for flush to be really finished in list:set */
> +	rcu_barrier();

Jozsef, are you sure you need this rcu_barrier()?

This is waiting for rcu callback completion (ie. decrement the set
reference counter and releasing the extension and object itself).

The rcu read side should be safe when accessing old copies from the
dumping path when using call_rcu().

Let me know, thanks!
