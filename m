From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] ct: fix key and dir requirements
Date: Thu, 16 Jan 2014 19:05:38 +0100
Message-ID: <20140116180538.GA18501@localhost>
References: <20140115181939.25239.19905.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60202 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbaAPSFx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:05:53 -0500
Content-Disposition: inline
In-Reply-To: <20140115181939.25239.19905.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 07:20:22PM +0100, Arturo Borrero Gonzalez wrote:
> Follow linux/net/netfilter/nft_ct.c to adjust key and dir attributes.
> 
> The dir attribute is needed only when using certaing keys, and prohibited with
> others.
> 
> Key is always mandatory.
> 
> Previous to this patch, using XML/JSON to manage this expr led to some
> undefined and erroneous behaviours.
> 
> While at it, update tests files in order to pass nft-parsing-test.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v2: fixed wrong logic in the XML parser. Added support for NFT_CT_L3PROTOCOL
> 
>  src/expr/ct.c                   |   97 +++++++++++++++++++++++++++------------
>  tests/xmlfiles/24-rule-ct.xml   |    2 -
>  tests/xmlfiles/37-rule-real.xml |    2 -
>  tests/xmlfiles/39-rule-real.xml |    2 -
>  tests/xmlfiles/50-rule-real.xml |    2 -
>  tests/xmlfiles/51-rule-real.xml |    2 -
>  tests/xmlfiles/52-rule-real.xml |    2 -
>  tests/xmlfiles/53-rule-real.xml |    2 -
>  tests/xmlfiles/54-rule-real.xml |    2 -
>  tests/xmlfiles/55-rule-real.xml |    2 -
>  tests/xmlfiles/56-rule-real.xml |    2 -
>  tests/xmlfiles/57-rule-real.xml |    2 -
>  12 files changed, 78 insertions(+), 41 deletions(-)
> 
> diff --git a/src/expr/ct.c b/src/expr/ct.c
> index e960134..e74c36c 100644
> --- a/src/expr/ct.c
> +++ b/src/expr/ct.c
> @@ -179,6 +179,28 @@ static inline int str2ctkey(const char *ctkey)
>  	return -1;
>  }
>  
> +static bool ctkey_req_dir(int ctkey)
> +{
> +	switch (ctkey) {
> +	case NFT_CT_STATE:
> +	case NFT_CT_DIRECTION:
> +	case NFT_CT_STATUS:
> +	case NFT_CT_MARK:
> +	case NFT_CT_SECMARK:
> +	case NFT_CT_EXPIRATION:
> +	case NFT_CT_HELPER:
> +		return false;
> +	case NFT_CT_L3PROTOCOL:
> +	case NFT_CT_SRC:
> +	case NFT_CT_DST:
> +	case NFT_CT_PROTOCOL:
> +	case NFT_CT_PROTO_SRC:
> +	case NFT_CT_PROTO_DST:
> +	default:
> +		return true;
> +	}

The kernel will complain if we pass invalid combinations, I don't want
to have this early validation code in the library.

> +}
> +
>  static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json_t *root,
>  				       struct nft_parse_err *err)
>  {
> @@ -193,22 +215,19 @@ static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json_t *root,
>  
>  	nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, reg);
>  
> -	if (nft_jansson_node_exist(root, "key")) {
> -		key_str = nft_jansson_parse_str(root, "key", err);
> -		if (key_str == NULL)
> -			return -1;
> -
> -		key = str2ctkey(key_str);
> -		if (key < 0)
> -			goto err;
> +	key_str = nft_jansson_parse_str(root, "key", err);
> +	if (key_str == NULL)
> +		return -1;
>  
> -		nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
> +	key = str2ctkey(key_str);
> +	if (key < 0)
> +		goto err;
>  
> -	}
> +	nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
>  
> -	if (nft_jansson_node_exist(root, "dir")) {
> -		if (nft_jansson_parse_val(root, "dir", NFT_TYPE_U8, &dir,
> -					  err) < 0)
> +	if (ctkey_req_dir(key)) {
> +		if (nft_jansson_parse_val(root, "dir", NFT_TYPE_U8,
> +					  &dir, err) < 0)
>  			return -1;
>  
>  		if (dir != IP_CT_DIR_ORIGINAL && dir != IP_CT_DIR_REPLY)
> @@ -257,15 +276,18 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
>  	ct->key = key;
>  	e->flags |= (1 << NFT_EXPR_CT_KEY);
>  
> -	if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST, BASE_DEC,
> -			       &dir, NFT_TYPE_U8, NFT_XML_MAND, err) != 0)
> -		return -1;
> +	if (ctkey_req_dir(key)) {

so this should be: if "dir" is present, parse it. Otherwise, just
skip it.

> +		if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST,
> +				       BASE_DEC, &dir, NFT_TYPE_U8,
> +				       NFT_XML_MAND, err) != 0)
> +				return -1;
>  
> -	if (dir != IP_CT_DIR_ORIGINAL && dir != IP_CT_DIR_REPLY)
> -		goto err;
> +		if (dir != IP_CT_DIR_ORIGINAL && dir != IP_CT_DIR_REPLY)
> +			goto err;
>  
> -	ct->dir = dir;
> -	e->flags |= (1 << NFT_EXPR_CT_DIR);
> +		ct->dir = dir;
> +		e->flags |= (1 << NFT_EXPR_CT_DIR);

Not related to this patch, but better I prefer if you use:
nft_rule_expr_set_u8(...) instead of these two lines above.

> +	}
>  
>  	return 0;
>  err:
> @@ -286,19 +308,37 @@ nft_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr *e)
>  	ret = snprintf(buf, len, "\"dreg\":%u", ct->dreg);
>  	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
> -		ret = snprintf(buf+offset, len, ",\"key\":\"%s\"",
> -						ctkey2str(ct->key));
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -	}
> +	ret = snprintf(buf+offset, len, ",\"key\":\"%s\"",
> +		       ctkey2str(ct->key));
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> -	if (e->flags & (1 << NFT_EXPR_CT_DIR)) {
> +	if (ctkey_req_dir(ct->key) && (e->flags & (1 << NFT_EXPR_CT_DIR))) {

Same thing here, you should print this if the direction is set,
otherwise, skip it.

I prefer if you use nft_rule_expr_is_set(...) instead.

>  		ret = snprintf(buf+offset, len, ",\"dir\":%u", ct->dir);
>  		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  	}
>  
>  	return offset;
> +}
> +
> +static int
> +nft_expr_ct_snprintf_xml(char *buf, size_t size, struct nft_rule_expr *e)
> +{
> +	int ret, len = size, offset = 0;
> +	struct nft_expr_ct *ct = nft_expr_data(e);
> +
> +	ret = snprintf(buf, len, "<dreg>%u</dreg>", ct->dreg);
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +
> +	ret = snprintf(buf+offset, len, "<key>%s</key>",
> +		       ctkey2str(ct->key));
> +	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>  
> +	if (ctkey_req_dir(ct->key) && (e->flags & (1 << NFT_EXPR_CT_DIR))) {
> +		ret = snprintf(buf+offset, len, "<dir>%u</dir>", ct->dir);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +
> +	return offset;
>  }
>  
>  static int
> @@ -312,10 +352,7 @@ nft_rule_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
>  		return snprintf(buf, len, "load %s => reg %u dir %u ",
>  				ctkey2str(ct->key), ct->dreg, ct->dir);
>  	case NFT_OUTPUT_XML:
> -		return snprintf(buf, len, "<dreg>%u</dreg>"
> -					  "<key>%s</key>"
> -					  "<dir>%u</dir>",
> -				ct->dreg, ctkey2str(ct->key), ct->dir);
> +		return nft_expr_ct_snprintf_xml(buf, len, e);
>  	case NFT_OUTPUT_JSON:
>  		return nft_expr_ct_snprintf_json(buf, len, e);
>  	default:
