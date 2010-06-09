From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: CLUSTERIP: RCU conversion
Date: Wed, 09 Jun 2010 18:30:46 +0200
Message-ID: <4C0FC1B6.2050605@trash.net>
References: <1276099861.2442.199.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37485 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599Ab0FIQap (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:30:45 -0400
In-Reply-To: <1276099861.2442.199.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> @@ -121,16 +128,14 @@ clusterip_config_find_get(__be32 clusterip, int entry)
>  {
>  	struct clusterip_config *c;
>  
> -	read_lock_bh(&clusterip_lock);
> +	rcu_read_lock_bh();
>  	c = __clusterip_config_find(clusterip);
> -	if (!c) {
> -		read_unlock_bh(&clusterip_lock);
> -		return NULL;
> +	if (c) {
> +		atomic_inc(&c->refcount);
> +		if (entry)
> +			atomic_inc(&c->entries);
>   

Shouldn't this be using atomic_inc_not_zero() to avoid races with
clusterip_config_entry_put()?

