From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/5] netlink: delinarize chain policy
Date: Fri, 26 Jun 2015 10:09:03 +0200
Message-ID: <20150626080903.GA9817@salvia>
References: <1434571657-20047-1-git-send-email-koetter@rrzn.uni-hannover.de>
 <1434571657-20047-3-git-send-email-koetter@rrzn.uni-hannover.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Markus Koetter <koetter@rrzn.uni-hannover.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46739 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbbFZIDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 04:03:37 -0400
Content-Disposition: inline
In-Reply-To: <1434571657-20047-3-git-send-email-koetter@rrzn.uni-hannover.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 17, 2015 at 10:07:34PM +0200, Markus Koetter wrote:
> ---
>  include/rule.h | 1 +
>  src/netlink.c  | 4 ++++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/include/rule.h b/include/rule.h
> index fbd327b..40cb98a 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -119,6 +119,7 @@ struct chain {
>  	const char		*type;
>  	struct scope		scope;
>  	struct list_head	rules;
> +	uint32_t		policy;
>  };
>  
>  extern const char *chain_type_name_lookup(const char *name);
> diff --git a/src/netlink.c b/src/netlink.c
> index 84d9d27..17aabd4 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -675,6 +675,10 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
>  		chain->flags        |= CHAIN_F_BASECHAIN;
>  	}
>  
> +	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE))
> +		chain->policy =
> +		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_POLICY);
> +

Are you using a working copy from git?

This patch seems to apply to an old version of nftables.
