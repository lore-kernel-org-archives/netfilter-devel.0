From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v3 1/2] expr: log: Code refactoring to use
 nft_rule_expr_set_* functions
Date: Mon, 2 Jun 2014 14:33:52 +0200
Message-ID: <20140602123352.GA17953@localhost>
References: <1401710770-23662-1-git-send-email-anarey@gmail.com>
 <1401710770-23662-2-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46185 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaFBMd7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:33:59 -0400
Content-Disposition: inline
In-Reply-To: <1401710770-23662-2-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 02, 2014 at 02:06:09PM +0200, Ana Rey wrote:
> @@ -211,30 +216,25 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e,
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
                               ^^^^^^^^^^^
                               note this

>  			       err) != 0)
>  		return -1;
> -
> -	e->flags |= (1 << NFT_EXPR_LOG_GROUP);
> +	nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, log->group);

I know Arturo asked for this, but it doesn't make much sense to set
log->group from nft_mxml_num_parse() and then reset it again via
nft_rule_expr_set_u16().

My suggestion is to make something similar to what the _json() parse
function currently do, ie.

        uint16_t group;

        ...
        if (nft_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST,
                               BASE_DEC, &group, NFT_TYPE_U16,
                               NFT_XML_MAND, err) < 0)
                return -1;

        nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, group);

Note that, while at it, we can consolidate the if check to < 0 instead
of != 0 as we do in many other parts of the code.

Please, send me a v4 version.

Regarding the title, I'd suggest: "Use nft_rule_expr_set_* the xml parsing code"

The json chunk below, you can send me in a different patch as a
cleanup. Thanks.

@@ -166,7 +170,8 @@  static int nft_rule_expr_log_json_parse(struct
nft_rule_expr *e, json_t *root,
 #ifdef JSON_PARSING
        const char *prefix;
        uint32_t snaplen;
-       uint16_t uval16;
+       uint16_t group;
+       uint16_t qthreshold;
 
        prefix = nft_jansson_parse_str(root, "prefix", err);
        if (prefix == NULL)
@@ -174,11 +179,11 @@  static int nft_rule_expr_log_json_parse(struct
nft_rule_expr *e, json_t *root,
 
        nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);
 
-       if (nft_jansson_parse_val(root, "group", NFT_TYPE_U16,
        &uval16,
+       if (nft_jansson_parse_val(root, "group", NFT_TYPE_U16, &group,
                                  err) < 0)
                return -1;
 
-       nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, uval16);
+       nft_rule_expr_set_u16(e, NFT_EXPR_LOG_GROUP, group);
 
        if (nft_jansson_parse_val(root, "snaplen", NFT_TYPE_U32,
&snaplen,
                                  err) < 0)
@@ -187,10 +192,10 @@  static int nft_rule_expr_log_json_parse(struct
nft_rule_expr *e, json_t *root,
        nft_rule_expr_set_u32(e, NFT_EXPR_LOG_SNAPLEN, snaplen);
 
        if (nft_jansson_parse_val(root, "qthreshold", NFT_TYPE_U16,
-                                 &uval16, err) < 0)
+                                 &qthreshold, err) < 0)
                return -1;
 
-       nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, uval16);
+       nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD, qthreshold);
 
        return 0;
 #else
