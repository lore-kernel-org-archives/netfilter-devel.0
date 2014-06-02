From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 2/2] src: expr: log: Do not print unset values in xml.
Date: Mon, 2 Jun 2014 12:21:06 +0200
Message-ID: <20140602102106.GB15498@localhost>
References: <1401703893-17050-1-git-send-email-anarey@gmail.com>
 <1401703893-17050-3-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52218 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbaFBKVQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:21:16 -0400
Content-Disposition: inline
In-Reply-To: <1401703893-17050-3-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 02, 2014 at 12:11:33PM +0200, Ana Rey wrote:
> It changes the parse and the snprint functions to omit unset values.
> 
> If we used this rule:
> ntt add rule ip test output log
> 
> We got this xml file:
> 
> <rule><family>ip</family>
> <table>test</table>
> <chain>output</chain>
> <handle>88</handle>
> <expr type="log">
> 	<prefix>(null)</prefix>
> 	<group>0</group>
> 	<snaplen>0</snaplen>
> 	<qthreshold>0</qthreshold>
> </expr>
> </rule>
> 
> And It was imposible import this file.
> 
> Now, That rule creates this xml file without null values:
> 
> <rule><family>ip</family>
> <table>test</table>
> <chain>output</chain>
> <handle>88</handle>
> <expr type="log">
> </expr>
> </rule>
> 
> and It's possible import this xml file.
> 
> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
> [Changes in v2]
> This patch has some changes that derive from the previous
> "src: expr: log: Code refactoring to use nft_rule_expr_set_* functions"
> patch.
> 
> 
>  src/expr/log.c | 57 ++++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 21 deletions(-)
> 
> +	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST, BASE_DEC,
> +			       &log->qthreshold, NFT_TYPE_U16, NFT_XML_MAND,
> +			       err) == 0) {
> +		nft_rule_expr_set_u16(e, NFT_EXPR_LOG_QTHRESHOLD,
> +				      log->qthreshold);
> +		}
        ^------^

wrong indentation.

>  
>  	return 0;
>  #else
> @@ -254,14 +252,31 @@ static int nft_rule_expr_log_snprintf_default(char *buf, size_t len,
>  static int nft_rule_expr_log_snprintf_xml(char *buf, size_t size,
>  					  struct nft_rule_expr *e)
>  {
> +	int ret, len = size, offset = 0;
>  	struct nft_expr_log *log = nft_expr_data(e);
>  
> -	return snprintf(buf, size, "<prefix>%s</prefix>"
> -				   "<group>%u</group>"
> -				   "<snaplen>%u</snaplen>"
> -				   "<qthreshold>%u</qthreshold>",
> -			log->prefix, log->group,
> -			log->snaplen, log->qthreshold);
> +	if (e->flags & (1 << NFT_EXPR_LOG_PREFIX)) {
> +		ret = snprintf(buf+offset, len, "<prefix>%s</prefix>",
> +			       log->prefix);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +	if (e->flags & (1 << NFT_EXPR_LOG_GROUP)) {
> +		ret = snprintf(buf+offset, len, "<group>%u</group>",
> +			       log->group);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +	if (e->flags & (1 << NFT_EXPR_LOG_SNAPLEN)) {
> +		ret = snprintf(buf+offset, len, "<snaplen>%u</snaplen>",
> +			       log->snaplen);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +	}
> +	if (e->flags & (1 << NFT_EXPR_LOG_QTHRESHOLD)) {
> +		ret = snprintf(buf+offset, len, "<qthreshold>%u</qthreshold>",
> +			       log->qthreshold);
> +		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +		}

Same wrong indentation here.
