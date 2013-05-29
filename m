From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] data_reg: Add generic interface for parsing:
 nft_data_reg_parse().
Date: Wed, 29 May 2013 14:16:34 +0200
Message-ID: <20130529121634.GE6099@localhost>
References: <20130528150640.5305.34507.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35666 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965495Ab3E2MRv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 08:17:51 -0400
Content-Disposition: inline
In-Reply-To: <20130528150640.5305.34507.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 28, 2013 at 05:06:40PM +0200, Arturo Borrero wrote:
> This was missing in previous patches, but was the original intention.

Not sure what we get with this patch.

nft_rule_expr_bitwise_xml_parse can be used internally from
libnftables. So unless I'm missing anything, the current code looks
good to me.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/expr/bitwise.c   |    4 ++--
>  src/expr/cmp.c       |    2 +-
>  src/expr/data_reg.c  |   18 +++++++++++++++++-
>  src/expr/data_reg.h  |   10 +++++++++-
>  src/expr/immediate.c |    2 +-
>  5 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> index 9ebe3dc..1c7198b 100644
> --- a/src/expr/bitwise.c
> +++ b/src/expr/bitwise.c
> @@ -265,7 +265,7 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, char *xml)
>  	/* hack for mxmSaveAllocString to print just the current node */
>  	save = node->next;
>  	node->next = NULL;
> -	if (nft_data_reg_xml_parse(&data_regtmp,
> +	if (nft_data_reg_parse(&data_regtmp, NFT_DATA_REG_PARSE_XML,
>  			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
>  		mxmlDelete(tree);
>  		return -1;
> @@ -287,7 +287,7 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, char *xml)
>  	/* hack for mxmSaveAllocString to print just the current node */
>  	save = node->next;
>  	node->next = NULL;
> -	if (nft_data_reg_xml_parse(&data_regtmp,
> +	if (nft_data_reg_parse(&data_regtmp, NFT_DATA_REG_PARSE_XML,
>  			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
>  		mxmlDelete(tree);
>  		return -1;
> diff --git a/src/expr/cmp.c b/src/expr/cmp.c
> index 673f3e0..bf285d5 100644
> --- a/src/expr/cmp.c
> +++ b/src/expr/cmp.c
> @@ -237,7 +237,7 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, char *xml)
>  		save = node->next;
>  		node->next = NULL;
>  
> -		if (nft_data_reg_xml_parse(&data_regtmp,
> +		if (nft_data_reg_parse(&data_regtmp, NFT_DATA_REG_PARSE_XML,
>  			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
>  			mxmlDelete(tree);
>  			return -1;
> diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
> index be2b47a..5ebc1de 100644
> --- a/src/expr/data_reg.c
> +++ b/src/expr/data_reg.c
> @@ -225,7 +225,7 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
>  #endif
>  }
>  
> -int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml)
> +static int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml)
>  {
>  #ifdef XML_PARSING
>  	mxml_node_t *node = NULL;
> @@ -267,6 +267,22 @@ int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml)
>  #endif
>  }
>  
> +int nft_data_reg_parse(union nft_data_reg *reg,
> +		       enum nft_data_reg_parse_type type, char *data) {
> +	int ret;
> +
> +	switch (type) {
> +	case NFT_DATA_REG_PARSE_XML:
> +		ret = nft_data_reg_xml_parse(reg, data);
> +		break;
> +	default:
> +		errno = EOPNOTSUPP;
> +		ret = -1;
> +	}
> +
> +	return ret;
> +}
> +
>  static
>  int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
>  				    union nft_data_reg *reg, uint32_t flags)
> diff --git a/src/expr/data_reg.h b/src/expr/data_reg.h
> index 1552c1e..0a290a8 100644
> --- a/src/expr/data_reg.h
> +++ b/src/expr/data_reg.h
> @@ -20,7 +20,15 @@ union nft_data_reg {
>  
>  int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
>                          uint32_t output_format, uint32_t flags, int reg_type);
> -int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml);
> +
> +enum nft_data_reg_parse_type {
> +	NFT_DATA_REG_PARSE_NONE		= 0,
> +	NFT_DATA_REG_PARSE_XML,
> +	NFT_DATA_REG_PARSE_MAX,
> +};
> +
> +int nft_data_reg_parse(union nft_data_reg *reg,
> +                       enum nft_data_reg_parse_type type, char *data);
>  int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type);
>  
>  #endif
> diff --git a/src/expr/immediate.c b/src/expr/immediate.c
> index 7cfb4bf..f10a785 100644
> --- a/src/expr/immediate.c
> +++ b/src/expr/immediate.c
> @@ -251,7 +251,7 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, char *xml)
>  	save = node->next;
>  	node->next = NULL;
>  
> -	if (nft_data_reg_xml_parse(&data_regtmp,
> +	if (nft_data_reg_parse(&data_regtmp, NFT_DATA_REG_PARSE_XML,
>  			mxmlSaveAllocString(node, MXML_NO_CALLBACK)) < 0) {
>  		mxmlDelete(tree);
>  		return -1;
> 
