From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8] [PATCH] dynamic calculation of event message size
 for	ctnetlink
Date: Mon, 17 Nov 2008 16:32:51 +0100
Message-ID: <49218EA3.8090801@trash.net>
References: <20081117083924.11368.38741.stgit@Decadence> <20081117084141.11368.26975.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46432 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYKQPc4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:32:56 -0500
In-Reply-To: <20081117084141.11368.26975.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds dynamic message size calculation for ctnetlink. This
> reduces CPU consumption since the overhead in the message trimming
> is removed.
> 
>  static int ctnetlink_conntrack_event(struct notifier_block *this,
>  				     unsigned long events, void *ptr)
>  {
> @@ -437,7 +538,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
>  	if (!nfnetlink_has_listeners(group))
>  		return NOTIFY_DONE;
>  
> -	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
> +	skb = alloc_skb(ctnetlink_calculate_room_size(ct, events), GFP_ATOMIC);
>  	if (!skb)
>  		return NOTIFY_DONE;

These calculations look somewhat expensive to perform for every message.
Do you have any numbers for this new patch that shows the difference
in CPU usage compared to the resizing done by af_netlink.c?

Since many of these are static in size an alternative would be to
update those sizes during protocol/helper/whatever (un)registration.
But if this patch already improves things, we can put it in and work
on perfecting it later :)

