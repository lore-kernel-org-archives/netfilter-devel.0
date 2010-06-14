From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: nfnetlink_log: RCU conversion
Date: Mon, 14 Jun 2010 16:16:26 +0200
Message-ID: <4C1639BA.9000402@trash.net>
References: <1276099088.2442.196.camel@edumazet-laptop>	 <4C0FBE33.3030100@trash.net> <1276106970.2442.221.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51013 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab0FNOQ3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:16:29 -0400
In-Reply-To: <1276106970.2442.221.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> [PATCH nf-next-2.6] netfilter: nfnetlink_log: RCU conversion, part 2
>
> - must use atomic_inc_not_zero() in instance_lookup_get()
>
> - must use hlist_add_head_rcu() instead of hlist_add_head()
>
> - must use hlist_del_rcu() instead of hlist_del()
>
> - Introduce NFULNL_COPY_DISABLED to stop lockless reader from using an
> instance, before we do final instance_put() on it.
>
>   

Applied, thanks Eric.
