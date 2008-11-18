From: Patrick McHardy <kaber@trash.net>
Subject: Re: crash in death_by_timeout()
Date: Tue, 18 Nov 2008 12:07:20 +0100
Message-ID: <4922A1E8.7080405@trash.net>
References: <20081117221855.GD3271@zebra.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: BORBELY Zoltan <bozo@andrews.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33969 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYKRLHZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:07:25 -0500
In-Reply-To: <20081117221855.GD3271@zebra.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

BORBELY Zoltan wrote:
> Hi,
> 
> There's a race in the nfct netlink code, the result is a crash in the
> death_by_timeout() function. When a timer interrupt occures during a
> new entry addition, the kernel will crash due to a NULL deref. The
> attached patch has solved the problem for us. I haven't tested it on
> the latest kernels, but the problem still seems to be there.

> --- /tmp/nf_conntrack_netlink.c-orig	2008-09-29 23:28:55.000000000 +0200
> +++ /tmp/nf_conntrack_netlink.c	2008-09-29 23:29:11.000000000 +0200
> @@ -1177,8 +1177,8 @@
>  		ct->master = master_ct;
>  	}
>  
> -	add_timer(&ct->timeout);
>  	nf_conntrack_hash_insert(ct);
> +	add_timer(&ct->timeout);
>  	rcu_read_unlock();

That code looks very fishy. We should be holding the conntrack lock,
otherwise the addition is not only racy against the timer, but also
against addition of identical conntracks. Let me look into what
happened here.

