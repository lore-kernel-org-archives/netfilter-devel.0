From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH RFC] netfilter: nf_tables: defer all object release via
 rcu
Date: Thu, 10 Apr 2014 15:01:47 +0300
Message-ID: <5346882B.30605@linux.intel.com>
References: <1397130696-3760-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6581 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030282AbaDJMDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:03:37 -0400
In-Reply-To: <1397130696-3760-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi  Pablo,

2 minor issues.

>   include/net/netfilter/nf_tables.h |    2 +
>   net/netfilter/nf_tables_api.c     |  100 ++++++++++++++++++++++---------------
>   2 files changed, 62 insertions(+), 40 deletions(-)
>
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index b08f2a9..65656f7 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -391,12 +391,14 @@ struct nft_rule {
>   /**
>    *	struct nft_trans - nf_tables object update in transaction
>    *
> + *	rcu_head: rcu head to defer release of transaction data

an '@' is missing

>    *	@list: used internally
>    *	@msg_type: message type
>    *	@ctx: transaction context
>    *	@data: internal information related to the transaction
>    */
>   struct nft_trans {
> +	struct rcu_head			rcu_head;
>   	struct list_head		list;
>   	int				msg_type;
>   	struct nft_ctx			ctx;
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 5606ae30..fd03212 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2612,7 +2612,8 @@ static void nft_set_destroy(struct nft_set *set)
>   static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
>   {
>   	list_del(&set->list);
> -	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);
> +	if (!set->flags & NFT_SET_ANONYMOUS)
> +		nf_tables_set_notify(ctx, set, NFT_MSG_DELSET);

It's a fix for anonymous set, so it's should be on another patch.



Tomasz
