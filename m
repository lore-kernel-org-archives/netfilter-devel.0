From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: CLUSTERIP: RCU conversion
Date: Tue, 15 Jun 2010 13:10:10 +0200
Message-ID: <4C175F92.8010001@trash.net>
References: <1276099861.2442.199.camel@edumazet-laptop>	 <4C0FC1B6.2050605@trash.net> <1276103507.2442.214.camel@edumazet-laptop>	 <4C1658CF.4040804@trash.net> <1276545574.2444.31.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab0FOLKN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:10:13 -0400
In-Reply-To: <1276545574.2444.31.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> [PATCH nf-next-2.6 v2] netfilter: CLUSTERIP: RCU conversion
>
> - clusterip_lock becomes a spinlock
> - lockless lookups
> - kfree() deferred after RCU grace period
> - rcu_barrier_bh() inserted in clusterip_tg_exit()
>
> v2) 
> - As Patrick pointed out, we use atomic_inc_not_zero() in
> clusterip_config_find_get().
> - list_add_rcu() and list_del_rcu() variants are used.
> - atomic_dec_and_lock() used in clusterip_config_entry_put()
>   

Applied, thanks Eric.

