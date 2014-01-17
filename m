From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] ct: fix dir, is optional
Date: Fri, 17 Jan 2014 10:46:37 +0100
Message-ID: <20140117094637.GA8798@localhost>
References: <20140117011505.11704.46463.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54932 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaAQJqu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:46:50 -0500
Content-Disposition: inline
In-Reply-To: <20140117011505.11704.46463.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 17, 2014 at 02:15:06AM +0100, Arturo Borrero Gonzalez wrote:
> The dir attribute is optional as stated in the kernel sources.
> 
> Previous to this patch, using XML/JSON to manage this expr produces some
> undefined and erroneous behaviours.
> 
> While at it, fix also the default output format.

Applied, thanks. But see one thing below:

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/expr/ct.c |   63 +++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 47 insertions(+), 16 deletions(-)
> 
> diff --git a/src/expr/ct.c b/src/expr/ct.c
> index e960134..3442f06 100644
> --- a/src/expr/ct.c
> +++ b/src/expr/ct.c
> @@ -258,14 +258,12 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
>  	e->flags |= (1 << NFT_EXPR_CT_KEY);
>  
>  	if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST, BASE_DEC,
> -			       &dir, NFT_TYPE_U8, NFT_XML_MAND, err) != 0)
> -		return -1;

I think it's better if you convert dir to use the "original" (0) and
"reply" strings (1). Thanks.
