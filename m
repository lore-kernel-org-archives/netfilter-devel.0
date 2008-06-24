From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCHv2] deliver events for conntracks created via ctnetlink
Date: Tue, 24 Jun 2008 17:54:17 +0200
Message-ID: <486118A9.5030808@trash.net>
References: <4857A939.6050701@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57032 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYFXPyW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:54:22 -0400
In-Reply-To: <4857A939.6050701@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> As for now, the creation and update of conntracks via ctnetlink do not
> propagate an event to userspace. This can result in inconsistent
> situations if several userspace processes modify the connection tracking
> table by means of ctnetlink at the same time. Specifically, using the
> conntrack command line tool and conntrackd at the same time can trigger
> unconsistencies.
> 
> This patch fixes this inconsistent situation. Note that the deletion
> does not suffer from this problem.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 

Unfortunately all the change functions are deadlock prone,
they are called while holding the conntrack lock and
event delivery might trigger destruction of the conntrack
entry already in the cache, which takes the lock again.

Perhaps we can do all this much easier. Conntrack updates
over netlink are a lot more rare than events triggered
by packet processing. What do you think about just sending
the full entry on successful changes over ctnetlink?

A few minor nits:

> +			atomic_inc(&ct->ct_general.use);

Should be using nf_conntrack_get().

Also the patch adds newlines excessively, to a file already
containing about 20% empty lines. Things like

>  		ct->status |= IPS_SEQ_ADJUST;
> +
> +		nf_conntrack_event_cache_ct(IPCT_NATSEQADJ, ct);

or

>  	rcu_read_unlock();
>  
> +	nf_ct_deliver_cached_events(ct);
> +
> +	nf_ct_put(ct);
> +
>  	return 0;

don't aid readability.
