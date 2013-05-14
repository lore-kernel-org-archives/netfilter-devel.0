From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 7/7] chain: handle attribute is relevant if
 only there is no name to use
Date: Wed, 15 May 2013 00:20:51 +0200
Message-ID: <20130514222051.GB10082@localhost>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1368528682-10041-8-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54218 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758437Ab3ENWU4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 18:20:56 -0400
Content-Disposition: inline
In-Reply-To: <1368528682-10041-8-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 14, 2013 at 01:51:22PM +0300, Tomasz Bursztyka wrote:
> While changing chain's settings, like its policy, it requires either the
> handle or the name, but not both.
> 
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  src/chain.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/chain.c b/src/chain.c
> index 1b1c3fe..e9a7896 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -263,7 +263,8 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
>  		mnl_attr_put_u64(nlh, NFTA_COUNTER_BYTES, be64toh(c->bytes));
>  		mnl_attr_nest_end(nlh, nest);
>  	}
> -	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE))
> +	if (c->flags & (1 << NFT_CHAIN_ATTR_HANDLE) &&
> +	    !(c->flags & (1 << NFT_CHAIN_ATTR_NAME)))
>  		mnl_attr_put_u64(nlh, NFTA_CHAIN_HANDLE, be64toh(c->handle));

The kernel will ignore the name if the handle is set. So no need to
make this artificial restriction in user-space.

>  	if (c->flags & (1 << NFT_CHAIN_ATTR_TYPE))
>  		mnl_attr_put_strz(nlh, NFTA_CHAIN_TYPE, c->type);
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
