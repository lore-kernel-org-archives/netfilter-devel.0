From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] Helper modules load on-demand support for ctnetlink
Date: Wed, 30 Jul 2008 13:10:51 +0200
Message-ID: <48904C3B.7060004@trash.net>
References: <48904A9F.8010509@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45316 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYG3LLl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:11:41 -0400
In-Reply-To: <48904A9F.8010509@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> [PATCH] Helper modules load on-demand support for ctnetlink
>
> This patch adds helper load on-demand support for ctnetlink. This patch
> also refactorizes the code to provide a couple of functions to look up
> and set the connection tracking helper. The function removes the
> exported symbol __nf_ct_helper_find as it has not clients anymore.
>
> This patch uses the persistent helper aliasing defined in the previous
> patch.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>
>   
> Index: net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c
> ===================================================================
> --- net-next-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-07-30 08:50:04.000000000 +0200
> +++ net-next-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-07-30 09:00:05.000000000 +0200
> @@ -1120,8 +1120,6 @@ ctnetlink_create_conntrack(struct nlattr
>  {
>  	struct nf_conn *ct;
>  	int err = -EINVAL;
> -	struct nf_conn_help *help;
> -	struct nf_conntrack_helper *helper;
>  
>  	ct = nf_conntrack_alloc(otuple, rtuple, GFP_KERNEL);
>  	if (ct == NULL || IS_ERR(ct))
> @@ -1152,17 +1150,7 @@ ctnetlink_create_conntrack(struct nlattr
>  #endif
>  
>  	rcu_read_lock();
> -	helper = __nf_ct_helper_find(rtuple);
> -	if (helper) {
> -		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
> -		if (help == NULL) {
> -			rcu_read_unlock();
> -			err = -ENOMEM;
> -			goto err;
> -		}
> -		/* not in hash table yet so not strictly necessary */
> -		rcu_assign_pointer(help->helper, helper);
> -	}
> +	__nf_ct_set_helper(ct, GFP_KERNEL);

This one should be checking the return value.

