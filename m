From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/3] segtree: Introduce flag for half-open range
 elements
Date: Tue, 18 Jul 2017 18:44:50 +0200
Message-ID: <20170718164450.GA17003@salvia>
References: <20170718154029.23976-1-phil@nwl.cc>
 <20170718154029.23976-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56648 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbdGRQpM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 12:45:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2071D4D659
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 18:44:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12E25DA80A
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 18:44:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFCAFDA46D
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 18:44:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170718154029.23976-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

This series looks to good to me. Only one comment below.

On Tue, Jul 18, 2017 at 05:40:27PM +0200, Phil Sutter wrote:
> This flag is required by userspace only, so can live within userdata.
> It's sole purpose is for 'nft monitor' to detect half-open ranges (which
> are comprised of a single element only).
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/expression.h |  1 +
>  include/rule.h       |  7 ++++++
>  src/netlink.c        | 66 ++++++++++++++++++++++++++++++++++++++--------------
>  src/segtree.c        |  5 ++++
>  4 files changed, 62 insertions(+), 17 deletions(-)
> 
> diff --git a/include/expression.h b/include/expression.h
> index 68a36e8af792a..202eb4c140eda 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -180,6 +180,7 @@ enum expr_flags {
>  	EXPR_F_PROTOCOL		= 0x4,
>  	EXPR_F_INTERVAL_END	= 0x8,
>  	EXPR_F_BOOLEAN		= 0x10,
> +	EXPR_F_INTERVAL_OPEN	= 0x20,

Could you place this here?

diff --git a/include/expression.h b/include/expression.h
index 7ddcc3226267..12434b335b71 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -256,6 +256,7 @@ struct expr {
                        uint64_t                expiration;
                        const char              *comment;
                        struct stmt             *stmt;
+                       unsigned int            elem_flags;
                };
                struct {
                        /* EXPR_UNARY */

We can probably move EXPR_F_INTERVAL_END there too in a follow up
patch.

>  };
>  
>  #include <payload.h>
> diff --git a/include/rule.h b/include/rule.h
> index 7424b21c6e019..592c93ddd0e2f 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -503,4 +503,11 @@ enum udata_set_type {
>  };
>  #define UDATA_SET_MAX (__UDATA_SET_MAX - 1)
>  
> +enum udata_set_elem_type {
> +	UDATA_SET_ELEM_COMMENT,
> +	UDATA_SET_ELEM_FLAGS,
> +	__UDATA_SET_ELEM_MAX,
> +};
> +#define UDATA_SET_ELEM_MAX (__UDATA_SET_ELEM_MAX - 1)
> +
>  #endif /* NFTABLES_RULE_H */
> diff --git a/src/netlink.c b/src/netlink.c
> index 2e30622de4bb1..be26188e097aa 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -211,7 +211,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
>  	const struct expr *elem, *key, *data;
>  	struct nftnl_set_elem *nlse;
>  	struct nft_data_linearize nld;
> -	struct nftnl_udata_buf *udbuf;
> +	struct nftnl_udata_buf *udbuf = NULL;
>  
>  	nlse = nftnl_set_elem_alloc();
>  	if (nlse == NULL)
> @@ -232,13 +232,22 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
>  	if (elem->timeout)
>  		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_TIMEOUT,
>  				       elem->timeout);
> -	if (elem->comment) {
> +	if (elem->comment || expr->flags & EXPR_F_INTERVAL_OPEN) {
>  		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
>  		if (!udbuf)
>  			memory_allocation_error();
> -		if (!nftnl_udata_put_strz(udbuf, UDATA_TYPE_COMMENT,
> +	}
> +	if (elem->comment) {
> +		if (!nftnl_udata_put_strz(udbuf, UDATA_SET_ELEM_COMMENT,
>  					  elem->comment))
>  			memory_allocation_error();
> +	}
> +	if (expr->flags & EXPR_F_INTERVAL_OPEN) {
> +		if (!nftnl_udata_put_u32(udbuf, UDATA_SET_ELEM_FLAGS,
> +					 EXPR_F_INTERVAL_OPEN))

Better make a new definition for this? Instead of using
EXPR_F_INTERVAL_OPEN which is 0x20.

Once we expose this value, we cannot change it otherwise we may break
nft between software updates, we should avoid this.
