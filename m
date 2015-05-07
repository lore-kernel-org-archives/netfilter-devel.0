From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 02/34] netfilter: ipset: Prepare the ipset core to use
 RCU at set level
Date: Fri, 8 May 2015 01:39:42 +0200
Message-ID: <20150507233942.GA3971@salvia>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1430587703-3387-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45168 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbbEGXfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 May 2015 19:35:12 -0400
Content-Disposition: inline
In-Reply-To: <1430587703-3387-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 02, 2015 at 07:27:51PM +0200, Jozsef Kadlecsik wrote:
> Replace rwlock_t with spinlock_t in "struct ip_set" and change the locking
> accordingly. Also, simplify the timeout routines.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
[...]
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index d259da3..a8e55c8 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -208,15 +208,15 @@ ip_set_type_register(struct ip_set_type *type)
>  		pr_warn("ip_set type %s, family %s with revision min %u already registered!\n",
>  			type->name, family_name(type->family),
>  			type->revision_min);
> -		ret = -EINVAL;
> -		goto unlock;
> +		ip_set_type_unlock();
> +		return -EINVAL;
>  	}
>  	list_add_rcu(&type->list, &ip_set_type_list);
>  	pr_debug("type %s, family %s, revision %u:%u registered.\n",
>  		 type->name, family_name(type->family),
>  		 type->revision_min, type->revision_max);
> -unlock:
>  	ip_set_type_unlock();
> +	synchronize_rcu();

You don't need to call synchronize() after list_add_rcu().
