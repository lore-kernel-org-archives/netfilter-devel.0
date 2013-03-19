From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC 2/3] NFQUEUE: coalesce IPv4 and IPv6 hashing
Date: Tue, 19 Mar 2013 10:27:49 -0400 (EDT)
Message-ID: <20130319.102749.234269518851550039.davem@davemloft.net>
References: <20130319141442.150005875@eitzenberger.org>
	<20130319141605.728912499@eitzenberger.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: holger@eitzenberger.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:43193 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3CSO1w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:27:52 -0400
In-Reply-To: <20130319141605.728912499@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: holger@eitzenberger.org
Date: Tue, 19 Mar 2013 15:14:44 +0100

> +	if (par->family == NFPROTO_IPV4)
> +		queue = (((u64) hash_v4(skb) * info->queues_total) >>
> +			 32) + queue;
>  #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> -		else if (par->family == NFPROTO_IPV6)
> -			queue = (((u64) hash_v6(skb) * info->queues_total) >>
> -				 32) + queue;
> +	else if (par->family == NFPROTO_IPV6)
> +		queue = (((u64) hash_v6(skb) * info->queues_total) >>
> +			 32) + queue;
>  #endif

Similarly, add a helper function.

Since there are so many similar call sites, perhaps put it into a
common header file.
