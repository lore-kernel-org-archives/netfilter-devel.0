From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] Basic support for printing nft_data_reg in
 XML format.
Date: Fri, 5 Apr 2013 14:45:22 +0200
Message-ID: <20130405124522.GA8670@localhost>
References: <20130405105403.15226.22899.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35762 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161243Ab3DEMpe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:45:34 -0400
Content-Disposition: inline
In-Reply-To: <20130405105403.15226.22899.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

Looks almost good, some comments below.

On Fri, Apr 05, 2013 at 12:54:03PM +0200, Arturo Borrero wrote:
> nft_data_reg now is printed in XML according to what it contains.
> ---
>  src/expr/bitwise.c   |   34 ++++++++----------
>  src/expr/cmp.c       |   23 ++++++------
>  src/expr/data_reg.c  |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  src/expr/data_reg.h  |    3 ++
>  src/expr/immediate.c |   83 +++++++++++++++++++++++++++++++++++++++++---
>  5 files changed, 201 insertions(+), 36 deletions(-)
> 
> diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> index ac89cba..5bed78a 100644
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
> +					NFT_RULE_O_XML, 0, DATA_VALUE);
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
> +					NFT_RULE_O_XML, 0, DATA_VALUE);

Cosmetic change, this is prefered:

        ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
                                    NFT_RULE_O_XML, 0, DATA_VALUE);
                                    ^
Note the second line is aligned with the parenthesis.

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
> @@ -242,18 +239,17 @@ nft_rule_expr_bitwise_snprintf_default(char *buf, size_t size,
>  	ret = snprintf(buf+offset, len, " mask=");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<bitwise->mask.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", bitwise->mask.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
> +					NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	ret = snprintf(buf+offset, len, " xor=");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<bitwise->xor.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", bitwise->xor.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +
> +	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->xor,
> +					NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	return offset;
>  }
> diff --git a/src/expr/cmp.c b/src/expr/cmp.c
> index 429f024..5c42db6 100644
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
> +					NFT_RULE_O_XML, 0, DATA_VALUE);
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
> +					NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
>  	return offset;
>  }
>  
> diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
> index 5b14695..a3b8130 100644
> --- a/src/expr/data_reg.c
> +++ b/src/expr/data_reg.c
> @@ -18,10 +18,104 @@
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <libnftables/expr.h>
> +#include <libnftables/rule.h>
>  #include "expr_ops.h"
>  #include "data_reg.h"
>  #include "internal.h"
>  
> +static
> +int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
> +				union nft_data_reg *reg, uint32_t flags)
> +{
> +	int len = size, offset = 0, ret, i, j;
> +	uint8_t *tmp;
> +	int data_len=reg->len/sizeof(uint32_t);

Another minor nitpick, for consistency:

data_len = reg...
        ^ ^

> +
> +	ret = snprintf(buf, len, "<data_reg type=\"value\" >");
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret = snprintf(buf+offset, len, "<len>%d</len>", data_len);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	for (i=0; i<data_len; i++) {
> +		ret = snprintf(buf+offset, len, "<data%d>0x", i);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +		tmp = (uint8_t *)&reg->val[i];
> +
> +		for (j=0; j<sizeof(int); j++) {
> +			ret = snprintf(buf+offset, len, "%.02x", tmp[j]);
> +			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +		}
> +
> +		ret = snprintf(buf+offset, len, "</data%d>", i);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +
> +	ret = snprintf(buf+offset, len, "</data_reg>");
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	return offset;
> +}
> +
> +static int nft_data_reg_value_snprintf_default(char *buf, size_t size,
> +				union nft_data_reg *reg, uint32_t flags)
> +{
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
> +			uint32_t output_format, uint32_t flags, int reg_type)
> +{
> +	switch(reg_type) {
> +	case DATA_VALUE:
> +		switch(output_format) {
> +		case NFT_RULE_O_XML:
> +			return nft_data_reg_value_snprintf_xml(buf, size,
> +							reg, flags);
> +		case NFT_RULE_O_DEFAULT:
> +			return nft_data_reg_value_snprintf_default(buf, size,
> +							reg, flags);
> +		default:
> +			break;
> +		}
> +	case DATA_VERDICT:
> +		switch(output_format) {
> +		case NFT_RULE_O_XML:
> +			return snprintf(buf, size,
> +					"<data_reg type=\"verdict\" >"
> +						"<verdict>%d</verdict>"
> +					"</data_reg>", reg->verdict);
> +		case NFT_RULE_O_DEFAULT:
> +			return snprintf(buf, size, "verdict=%d", reg->verdict);
> +		default:
> +			break;
> +		}
> +	case DATA_CHAIN:
> +		switch(output_format) {
> +		case NFT_RULE_O_XML:
> +			return snprintf(buf, size,
> +					"<data_reg type=\"chain\" >"
> +						"<chain>%s</chain>"
> +					"</data_reg>", reg->chain);
> +		case NFT_RULE_O_DEFAULT:
> +			return snprintf(buf, size, "chain=%s", reg->chain);
> +		default:
> +			break;
> +		}
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
> index 00eab63..1552c1e 100644
> --- a/src/expr/data_reg.h
> +++ b/src/expr/data_reg.h
> @@ -18,6 +18,9 @@ union nft_data_reg {
>  	};
>  };
>  
> +int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
> +                        uint32_t output_format, uint32_t flags, int reg_type);
> +int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml);
>  int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type);
>  
>  #endif
> diff --git a/src/expr/immediate.c b/src/expr/immediate.c
> index 496cbfd..edccbd2 100644
> --- a/src/expr/immediate.c
> +++ b/src/expr/immediate.c
> @@ -196,6 +196,82 @@ nft_rule_expr_immediate_parse(struct nft_rule_expr *e, struct nlattr *attr)
>  }
>  
>  static int
> +nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
> +			struct nft_expr_immediate *imm, uint32_t flags)
> +{
> +	int size = len, offset = 0, ret;
> +	size_t *voidpointer=NULL;
> +
> +	ret = snprintf(buf, len, "\t\t<dreg>%u</dreg>"
> +				"\n\t\t<immediatedata>", imm->dreg);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	/* If nft_rule_expr_immediate_get return != NULL then
> +	* the attribute is set and we need to print it out */
> +
> +	if (nft_rule_expr_immediate_get((struct nft_rule_expr *)imm,
> +				NFT_EXPR_IMM_DATA, voidpointer) != NULL) {
> +		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
> +					NFT_RULE_O_XML, flags, DATA_VALUE);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	} else if (nft_rule_expr_immediate_get((struct nft_rule_expr *)imm,
> +				NFT_EXPR_IMM_VERDICT, voidpointer) != NULL) {
> +		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
> +					NFT_RULE_O_XML, flags, DATA_VERDICT);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	} else if (nft_rule_expr_immediate_get((struct nft_rule_expr *)imm,
> +				NFT_EXPR_IMM_CHAIN, voidpointer) != NULL) {
> +		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
> +					NFT_RULE_O_XML, flags, DATA_CHAIN);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +
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
> +	size_t *voidpointer=NULL;
> +
> +	ret = snprintf(buf, len, "dreg=%u", imm->dreg);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	/* If nft_rule_expr_immediate_get return != NULL then
> +	* the attribute is set and we need to print it out */

Comments in the Linux kernel, and by extension netfilter codebase,
should be like:

/* If nft_rule_expr_immediate_get return != NULL then
 * the attribute is set and we need to print it out.
 */

> +
> +	if (nft_rule_expr_immediate_get((struct nft_rule_expr *)imm,
> +				NFT_EXPR_IMM_DATA, voidpointer) != NULL) {

The get/set interface is for third party applications, it's an
extensibility trick that allows us to add new attributes without
breaking backward compatibility.

>From the library itself, you can use imm->data.val directly. You will
have to check if the attribute is set, ie.

if (e->flags & (1 << NFT_EXPR_IMM_DATA))
        ...

> +		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
> +					NFT_RULE_O_DEFAULT, flags, DATA_VALUE);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	} else if (nft_rule_expr_immediate_get((struct nft_rule_expr *)imm,
> +				NFT_EXPR_IMM_VERDICT, voidpointer) != NULL) {

Same thing here, but imm->data.verdict in this case.

> +		ret = nft_data_reg_snprintf(buf+offset, len, &imm->data,
> +					NFT_RULE_O_DEFAULT, flags, DATA_VERDICT);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	} else if (nft_rule_expr_immediate_get((struct nft_rule_expr *)imm,
> +				NFT_EXPR_IMM_CHAIN, voidpointer) != NULL) {

And imm->data.chain in this case.

Please, revamp and submit a v2. We're almost at it.

Thanks.
