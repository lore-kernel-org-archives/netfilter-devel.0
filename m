From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 1/2] src: expr: log: Code refactoring to use
 nft_rule_expr_set_* functions
Date: Mon, 2 Jun 2014 12:19:59 +0200
Message-ID: <20140602101959.GA15498@localhost>
References: <1401703893-17050-1-git-send-email-anarey@gmail.com>
 <1401703893-17050-2-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51575 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbaFBKUL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:20:11 -0400
Content-Disposition: inline
In-Reply-To: <1401703893-17050-2-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Ana,

No need to include "src: " in the tag, "expr: log: ..." should be
enough.

The "src: " is sort of wildcard, when the change applies to different
aspects of the tree.

On Mon, Jun 02, 2014 at 12:11:32PM +0200, Ana Rey wrote:
> Code refactoring to use nft_rule_expr_set_* in parse functions.
> 
> This change was supported by Arturo Borrero Gonzalez.
                  ^-------^
                  suggested

Or you could just include:

Suggested-by: Arturo Borrero Gonzalez <...>

> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
>  src/expr/log.c | 32 +++++++++++++++-----------------
>  1 file changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/src/expr/log.c b/src/expr/log.c
> index a61a8d3..bf18b42 100644
> --- a/src/expr/log.c
> +++ b/src/expr/log.c
> @@ -133,6 +133,9 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
>  {
>  	struct nft_expr_log *log = nft_expr_data(e);
>  	struct nlattr *tb[NFTA_LOG_MAX+1] = {};
> +	const char *prefix;
> +	uint32_t snaplen;
> +	uint16_t uval16;

Please, no uval16 or tmp variable names for code readability reasons.

>  
>  	if (mnl_attr_parse_nested(attr, nft_rule_expr_log_cb, tb) < 0)
>  		return -1;
> @@ -141,20 +144,20 @@ nft_rule_expr_log_parse(struct nft_rule_expr *e, struct nlattr *attr)
>  		if (log->prefix)
>  			xfree(log->prefix);
>  
> -		log->prefix = strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
> -		e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
> +		prefix = strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
> +		nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
>  	}
>  	if (tb[NFTA_LOG_GROUP]) {
> -		log->group = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_GROUP]));
> -		e->flags |= (1 << NFT_EXPR_LOG_GROUP);
> +		uval16 = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_GROUP]));

I'd suggest here:

        if (tb[NFTA_LOG_GROUP]) {
                uint16_t group = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_GROUP]));
                nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, group);
        }

> +		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, uval16);
>  	}
>  	if (tb[NFTA_LOG_SNAPLEN]) {
> -		log->snaplen = ntohl(mnl_attr_get_u32(tb[NFTA_LOG_SNAPLEN]));
> -		e->flags |= (1 << NFT_EXPR_LOG_SNAPLEN);
> +		snaplen = ntohl(mnl_attr_get_u32(tb[NFTA_LOG_SNAPLEN]));
> +		nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, snaplen);
>  	}
>  	if (tb[NFTA_LOG_QTHRESHOLD]) {
> -		log->qthreshold = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_QTHRESHOLD]));
> -		e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
> +		uval16 = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_QTHRESHOLD]));
> +		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, uval16);
>  	}
>  
>  	return 0;
> @@ -211,30 +214,25 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
>  				    NFT_XML_MAND, err);
>  	if (prefix == NULL)
>  		return -1;
> -
> -	log->prefix = strdup(prefix);
> -	e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
> +	nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
>  
>  	if (nft_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST, BASE_DEC,
>  			       &log->group, NFT_TYPE_U16, NFT_XML_MAND,
>  			       err) != 0)
>  		return -1;
> -
> -	e->flags |= (1 << NFT_EXPR_LOG_GROUP);
> +	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, log->group);
>  
>  	if (nft_mxml_num_parse(tree, "snaplen", MXML_DESCEND_FIRST, BASE_DEC,
>  			       &log->snaplen, NFT_TYPE_U32, NFT_XML_MAND,
>  			       err) != 0)
>  		return -1;
> -
> -	e->flags |= (1 << NFT_EXPR_LOG_SNAPLEN);
> +	nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, log->snaplen);
>  
>  	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST,
>  			       BASE_DEC, &log->qthreshold,
>  			       NFT_TYPE_U16, NFT_XML_MAND, err) != 0)
>  		return -1;
> -
> -	e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
> +	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, log->qthreshold);
>  
>  	return 0;
>  #else
> -- 
> 2.0.0.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
