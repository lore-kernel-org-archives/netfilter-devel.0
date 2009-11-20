From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nfnetlink_queue: Use hash to speed up finding entries
 in nfqueue
Date: Fri, 20 Nov 2009 14:12:59 +0100
Message-ID: <4B0695DB.3010401@trash.net>
References: <4B06217F.6060901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34819 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbZKTNMz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:12:55 -0500
In-Reply-To: <4B06217F.6060901@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> Use hash to speed up finding entries in nfqueue.
> 
> If user implements QoS in userland, packet verdict won't be received in order. At this moment, a hash table is faster than a double linked list when finding the corresponding entries in nfqueue.
> 
> This patch also fixes a potential bug, which will allows more than one entries with the same id are in the same nfqueue in the extreme.

Instead of a double ID in a purely hypothetical case, we'd now
get an endless loop. This part doesn't make much sense to me,
please remove it from the patch.

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 7a9dec9..38c7af1 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -37,6 +37,9 @@
>  #endif
>  
>  #define NFQNL_QMAX_DEFAULT 1024
> +#define NFQNL_QHT_BITS 8
> +#define NFQNL_QHT_SIZE (1 << NFQNL_QHT_BITS)
> +#define NFQNL_QHT_MASK (NFQNL_QHT_SIZE - 1)

Have you considered making the size configurable by passing a new
attribute in the NFQNL_CFG_CMD_BIND cmd message?
