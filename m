From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: conntrack: use mod_timer_pending()
Date: Wed, 10 Jun 2009 15:07:02 +0200
Message-ID: <4A2FAFF6.50909@trash.net>
References: <4A2FAFB4.1050100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Martin Josefsson <gandalf@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58138 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZFJNHD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:07:03 -0400
In-Reply-To: <4A2FAFB4.1050100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> This patch changes conntrack to use the new mod_timer_pending()
> function, which only rearms the timer if it was still active.
> This allows to only grab the lock in __nf_ct_refresh_acct when
> accounting is used.
> 
> Anyone seing anything wrong with this?

>  		if (acct) {
> +			spin_lock_bh(&nf_conntrack_lock);
>  			acct[CTINFO2DIR(ctinfo)].packets++;
>  			acct[CTINFO2DIR(ctinfo)].bytes +=
>  				skb->len - skb_network_offset(skb);
> +			spin_unlock_bh(&nf_conntrack_lock);
>  		}

In fact, we could additionally change it to use the per-conntrack lock.
