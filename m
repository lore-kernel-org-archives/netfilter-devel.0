From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2 nf] netfilter: nft_queue: restrict queueing to
 supported families
Date: Fri, 26 Jun 2015 10:02:01 +0200
Message-ID: <20150626080201.GA10981@acer.localdomain>
References: <1435305700-8768-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33369 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbFZICF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 04:02:05 -0400
Content-Disposition: inline
In-Reply-To: <1435305700-8768-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.06, Pablo Neira Ayuso wrote:
> We only support IPv4 and IPv6 at this moment.

That's not a restriction but just a module alias. If the module is
already loaded it will still be usable for any family.

Packets will of course simply get dropped by nf_queue(). If we
really want to restrict this, we'd also have to restrict queueing
verdict codes for other families.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_queue.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
> index 96805d2..45b9f7f 100644
> --- a/net/netfilter/nft_queue.c
> +++ b/net/netfilter/nft_queue.c
> @@ -129,4 +129,5 @@ module_exit(nft_queue_module_exit);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Eric Leblond <eric@regit.org>");
> -MODULE_ALIAS_NFT_EXPR("queue");
> +MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "queue");
> +MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "queue");
> -- 
> 1.7.10.4
> 
