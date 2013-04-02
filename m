From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] Basic support for printing nft_data_reg
 in XML format.
Date: Tue, 2 Apr 2013 13:41:23 +0200
Message-ID: <20130402114123.GC9973@localhost>
References: <20130329153155.30122.21803.stgit@nfdev.cica.es>
 <20130329153432.30122.86772.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47759 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760571Ab3DBLl2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:41:28 -0400
Content-Disposition: inline
In-Reply-To: <20130329153432.30122.86772.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Fri, Mar 29, 2013 at 04:34:32PM +0100, Arturo Borrero wrote:
> 
> ---
>  src/expr/bitwise.c   |   33 ++++++++++++++-------------------
>  src/expr/cmp.c       |   23 +++++++++++------------
>  src/expr/data_reg.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  src/expr/data_reg.h  |    3 +++
>  src/expr/immediate.c |   43 ++++++++++++++++++++++++++++++++++++++-----
>  5 files changed, 114 insertions(+), 36 deletions(-)
> 
> diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> index ac89cba..249307a 100644
> --- a/src/expr/bitwise.c
> +++ b/src/expr/bitwise.c
> @@ -199,7 +199,7 @@ static int
>  nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
>  				   struct nft_expr_bitwise *bitwise)
>  {
> -	int len = size, offset = 0, ret, i;
> +	int len = size, offset = 0, ret;
>  
>  	ret = snprintf(buf, len, "\t\t<sreg>%u</sreg> "
>  					"<dreg>%u</dreg> ",
> @@ -209,19 +209,16 @@ nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
>  	ret = snprintf(buf+offset, len, "<mask>");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<bitwise->mask.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ",
> -				bitwise->mask.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
> +							NFT_RULE_O_XML, 0);

I think we need something similar to:

int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type);

We should pass a 'type' that indicates:

        DATA_VALUE,
        DATA_VERDICT,
        DATA_CHAIN,

So you know if you have print what the data_reg contains.

For bitwise, it should be DATA_VALUE.

> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	ret = snprintf(buf+offset, len, "</mask> <xor>");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<bitwise->xor.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", bitwise->xor.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
> +							NFT_RULE_O_XML, 0);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	ret = snprintf(buf+offset, len, "</xor> ");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> @@ -233,7 +230,7 @@ static int
>  nft_rule_expr_bitwise_snprintf_default(char *buf, size_t size,
>  					struct nft_expr_bitwise *bitwise)
>  {
> -	int len = size, offset = 0, ret, i;
> +	int len = size, offset = 0, ret;
>  
>  	ret = snprintf(buf, len, "sreg=%u dreg=%u ",
>  			bitwise->sreg, bitwise->dreg);
> @@ -242,18 +239,16 @@ nft_rule_expr_bitwise_snprintf_default(char *buf, size_t size,
>  	ret = snprintf(buf+offset, len, " mask=");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<bitwise->mask.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", bitwise->mask.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
> +							NFT_RULE_O_DEFAULT, 0);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	ret = snprintf(buf+offset, len, " xor=");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<bitwise->xor.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", bitwise->xor.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
> +							NFT_RULE_O_DEFAULT, 0);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	return offset;
>  }
> diff --git a/src/expr/cmp.c b/src/expr/cmp.c
> index 429f024..6a5c4c2 100644
> --- a/src/expr/cmp.c
> +++ b/src/expr/cmp.c
> @@ -169,18 +169,17 @@ static char *expr_cmp_str[] = {
>  static int
>  nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr_cmp *cmp)
>  {
> -	int len = size, offset = 0, ret, i;
> +	int len = size, offset = 0, ret;
>  
> -	ret = snprintf(buf, len, "\t\t<sreg>%u</sreg> <op>%s</op> <data>",
> +	ret = snprintf(buf, len, "\t\t<sreg>%u</sreg> <op>%s</op> <cmpdata>",
>  			cmp->sreg, expr_cmp_str[cmp->op]);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<cmp->data.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", cmp->data.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &cmp->data,
> +							NFT_RULE_O_XML, 0);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	ret = snprintf(buf+offset, len, "</data> ");
> +	ret = snprintf(buf+offset, len, "</cmpdata> ");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	return offset;
> @@ -190,16 +189,16 @@ static int
>  nft_rule_expr_cmp_snprintf_default(char *buf, size_t size,
>  				   struct nft_expr_cmp *cmp)
>  {
> -	int len = size, offset = 0, ret, i;
> +	int len = size, offset = 0, ret;
>  
>  	ret = snprintf(buf, len, "sreg=%u op=%s data=",
>  			cmp->sreg, expr_cmp_str[cmp->op]);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<cmp->data.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", cmp->data.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &cmp->data,
> +							NFT_RULE_O_DEFAULT, 0);

For cmp, it should also be DATA_VALUE.

> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
>  	return offset;
>  }
>  
> diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
> index 5b14695..b188571 100644
> --- a/src/expr/data_reg.c
> +++ b/src/expr/data_reg.c
> @@ -18,10 +18,58 @@
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <libnftables/expr.h>
> +#include <libnftables/rule.h>
>  #include "expr_ops.h"
>  #include "data_reg.h"
>  #include "internal.h"
>  
> +static int nft_data_reg_snprintf_xml(char *buf, size_t size, uint32_t flags,
> +						union nft_data_reg *reg)
> +{
> +	/* NOTE: The other struct in the union (the one with veredict/chain)
> +	* is not supported yet */
> +
> +	int len = size, offset = 0, ret, i;
> +
> +	for (i=0; i<4; i++) {
> +		ret = snprintf(buf+offset, len, "<data%d>0x%.8x</data%d>",
> +							i, reg->val[i], i);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +
> +	return offset;
> +}
> +
> +static int nft_data_reg_snprintf_default(char *buf, size_t size, uint32_t flags,
> +						union nft_data_reg *reg)
> +{
> +	/* NOTE: The other struct in the union (the one with veredict/chain)
> +	* is not supported yet */
> +
> +	int len = size, offset = 0, ret, i;
> +
> +	for (i=0; i<reg->len/sizeof(uint32_t); i++) {
> +		ret = snprintf(buf+offset, len, "0x%.8x ", reg->val[i]);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +
> +	return offset;
> +}
> +
> +int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
> +						uint32_t type, uint32_t flags)
> +{
> +	switch(type) {
> +	case NFT_RULE_O_XML:
> +		return nft_data_reg_snprintf_xml(buf, size, flags, reg);
> +	case NFT_RULE_O_DEFAULT:
> +		return nft_data_reg_snprintf_default(buf, size, flags, reg);
> +	default:
> +		break;
> +	}
> +	return -1;
> +}
> +
>  static int nft_data_parse_cb(const struct nlattr *attr, void *data)
>  {
>  	const struct nlattr **tb = data;
> diff --git a/src/expr/data_reg.h b/src/expr/data_reg.h
> index 00eab63..8441dc8 100644
> --- a/src/expr/data_reg.h
> +++ b/src/expr/data_reg.h
> @@ -18,6 +18,9 @@ union nft_data_reg {
>  	};
>  };
>  
> +int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
> +						uint32_t type, uint32_t flags);
> +int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml);
>  int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type);
>  
>  #endif
> diff --git a/src/expr/immediate.c b/src/expr/immediate.c
> index 496cbfd..f244783 100644
> --- a/src/expr/immediate.c
> +++ b/src/expr/immediate.c
> @@ -196,6 +196,42 @@ nft_rule_expr_immediate_parse(struct nft_rule_expr *e, struct nlattr *attr)
>  }
>  
>  static int
> +nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
> +			struct nft_expr_immediate *imm, uint32_t flags)
> +{
> +	int size = len, offset = 0, ret;
> +
> +	ret = snprintf(buf, len, "\t\t<dreg>%u</dreg>"
> +				"\n\t\t<immediatedata>", imm->dreg);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
> +							NFT_RULE_O_XML, flags);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret = snprintf(buf+offset, len, "</immediatedata>");
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	return offset;
> +}
> +
> +static int
> +nft_rule_expr_immediate_snprintf_default(char *buf, size_t len,
> +				struct nft_expr_immediate *imm, uint32_t flags)
> +{
> +	int size = len, offset = 0, ret;
> +
> +	ret = snprintf(buf, len, "dreg=%u data=", imm->dreg);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
> +						NFT_RULE_O_DEFAULT, flags);

For immediate, it depends on the attribute set:

NFT_EXPR_IMM_VERDICT => DATA_VERDICT
NFT_EXPR_IMM_CHAIN => DATA_CHAIN
NFT_EXPR_IMM_VALUE => DATA_VALUE

Please, re-spin and send me a new patch.

Thanks.
