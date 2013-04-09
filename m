From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] Basic support for printing nft_data_reg
 in XML format.
Date: Tue, 9 Apr 2013 21:42:56 +0200
Message-ID: <20130409194255.GA5544@localhost>
References: <20130408083022.9188.50453.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56225 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964848Ab3DITnN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:43:13 -0400
Content-Disposition: inline
In-Reply-To: <20130408083022.9188.50453.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 08, 2013 at 10:30:22AM +0200, Arturo Borrero wrote:
> nft_data_reg now is printed in XML according to what it contains.
> ---
>  src/expr/bitwise.c   |   39 +++++++++------------
>  src/expr/cmp.c       |   27 +++++++-------
>  src/expr/data_reg.c  |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  src/expr/data_reg.h  |    3 ++
>  src/expr/immediate.c |   72 ++++++++++++++++++++++++++++++++++----
>  5 files changed, 193 insertions(+), 43 deletions(-)
> 
> diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> index ac89cba..052144e 100644
> --- a/src/expr/bitwise.c
> +++ b/src/expr/bitwise.c
> @@ -199,29 +199,26 @@ static int
>  nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
>  				   struct nft_expr_bitwise *bitwise)
>  {
> -	int len = size, offset = 0, ret, i;
> +	int len = size, offset = 0, ret;
>  
>  	ret = snprintf(buf, len, "\t\t<sreg>%u</sreg> "
>  					"<dreg>%u</dreg> ",
> -			bitwise->sreg, bitwise->dreg);
> +		       bitwise->sreg, bitwise->dreg);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	ret = snprintf(buf+offset, len, "<mask>");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<bitwise->mask.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ",
> -				bitwise->mask.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
> +				    NFT_RULE_O_XML, 0, DATA_VALUE);
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
> +				    NFT_RULE_O_XML, 0, DATA_VALUE);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	ret = snprintf(buf+offset, len, "</xor> ");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> @@ -231,29 +228,27 @@ nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
>  
>  static int
>  nft_rule_expr_bitwise_snprintf_default(char *buf, size_t size,
> -					struct nft_expr_bitwise *bitwise)
> +				       struct nft_expr_bitwise *bitwise)
>  {
> -	int len = size, offset = 0, ret, i;
> +	int len = size, offset = 0, ret;
>  
>  	ret = snprintf(buf, len, "sreg=%u dreg=%u ",
> -			bitwise->sreg, bitwise->dreg);
> +		       bitwise->sreg, bitwise->dreg);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	ret = snprintf(buf+offset, len, " mask=");
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<bitwise->mask.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", bitwise->mask.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &bitwise->mask,
> +				    NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
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
> +				    NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
>  	return offset;
>  }
> diff --git a/src/expr/cmp.c b/src/expr/cmp.c
> index 429f024..6b5a3a2 100644
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
> -			cmp->sreg, expr_cmp_str[cmp->op]);
> +	ret = snprintf(buf, len, "\t\t<sreg>%u</sreg> <op>%s</op> <cmpdata>",
> +		       cmp->sreg, expr_cmp_str[cmp->op]);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<cmp->data.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", cmp->data.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = nft_data_reg_snprintf(buf+offset, len, &cmp->data,
> +				    NFT_RULE_O_XML, 0, DATA_VALUE);
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
> -			cmp->sreg, expr_cmp_str[cmp->op]);
> +		       cmp->sreg, expr_cmp_str[cmp->op]);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret = nft_data_reg_snprintf(buf+offset, len, &cmp->data,
> +				    NFT_RULE_O_DEFAULT, 0, DATA_VALUE);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	for (i=0; i<cmp->data.len/sizeof(uint32_t); i++) {
> -		ret = snprintf(buf+offset, len, "%.8x ", cmp->data.val[i]);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
>  	return offset;
>  }
>  
> diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
> index 5b14695..d7010ad 100644
> --- a/src/expr/data_reg.c
> +++ b/src/expr/data_reg.c
> @@ -18,10 +18,105 @@
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
> +				    union nft_data_reg *reg, uint32_t flags)
> +{
> +	int len = size, offset = 0, ret, i, j;
> +	uint8_t *tmp;
> +	int data_len = reg->len/sizeof(uint32_t);
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
> +static int
> +nft_data_reg_value_snprintf_default(char *buf, size_t size,
> +				    union nft_data_reg *reg, uint32_t flags)
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
> +			  uint32_t output_format, uint32_t flags, int reg_type)
> +{
> +	switch(reg_type) {
> +	case DATA_VALUE:
> +		switch(output_format) {
> +		case NFT_RULE_O_XML:
> +			return nft_data_reg_value_snprintf_xml(buf, size,
> +							       reg, flags);
> +		case NFT_RULE_O_DEFAULT:
> +			return nft_data_reg_value_snprintf_default(buf, size,
> +								   reg, flags);
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
> index 496cbfd..082db76 100644
> --- a/src/expr/immediate.c
> +++ b/src/expr/immediate.c
> @@ -196,19 +196,77 @@ nft_rule_expr_immediate_parse(struct nft_rule_expr *e, struct nlattr *attr)
>  }
>  
>  static int
> -nft_rule_expr_immediate_snprintf(char *buf, size_t len, uint32_t type,
> -				 uint32_t flags, struct nft_rule_expr *e)
> +nft_rule_expr_immediate_snprintf_xml(char *buf, size_t len,
> +				     struct nft_rule_expr *e, uint32_t flags)
> +{
> +	int size = len, offset = 0, ret;
> +	struct nft_expr_immediate *imm = (struct nft_expr_immediate *)e->data;
> +
> +	ret = snprintf(buf, len, "\t\t<dreg>%u</dreg>"
> +				"\n\t\t<immediatedata>", imm->dreg);

Cannot use "data" instead of immediate data? This is nested in
<immediate>...</immediate>, it seems redundant to me.
