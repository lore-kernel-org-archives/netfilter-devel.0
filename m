From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 libnetfilter_acct 3/29] bugfix: correct xml name
 parsing
Date: Tue, 16 Jul 2013 00:24:23 +0200
Message-ID: <20130715222423.GA5405@localhost>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-4-git-send-email-michael.zintakis@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46034 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab3GOWYc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:24:32 -0400
Content-Disposition: inline
In-Reply-To: <1373480727-11254-4-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 10, 2013 at 07:25:01PM +0100, Michael Zintakis wrote:
> * allow accounting object names to be properly encoded and displayed when xml
> output is needed, to fully conform to the xml specification.
> 
> Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
> ---
>  src/libnetfilter_acct.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
> index ba89e2d..4d87da3 100644
> --- a/src/libnetfilter_acct.c
> +++ b/src/libnetfilter_acct.c
> @@ -228,6 +228,43 @@ uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type)
>  }
>  EXPORT_SYMBOL(nfacct_attr_get_u64);
>  
> +static
> +void parse_nfacct_name_xml(char *buf, const char *name)

Please, use the prefix nfacct_* for consistency. My suggestion for
this function name is nfacct_name_to_xml.

> +{
> +	static const char escape_chars[] = "\"'<>&";

You have to escape the apostroph as well.

> +	int length;
> +	int n;
> +	char e[10];
> +	const char *p;
> +
> +	if (buf == NULL)
> +		return;

This checking is superfluous, it always evaluates false.

> +
> +	buf[0] = '\0';

Don't need this initial zeroing.

> +	if (name == NULL)
> +		return;

Same thing above.

> +	length = strcspn(name, escape_chars);
> +	if (length > 0 && name[length] == 0) {
> +		/* no escaping required */
> +		strncat(buf, name, length);
> +	} else {
> +		for (p = strpbrk(name, escape_chars); p != NULL;
> +		     p = strpbrk(name, escape_chars)) {
> +			if (p > name)
> +				strncat(buf, name, p - name);
> +
> +			n = *p;
> +			snprintf(e, sizeof(e), "&#%d;", n);
> +			strncat(buf, e, strlen(e));

Please use snprintf to build the string (instead of strncat) you can
use BUFFER_SIZE to update the buffer offset.

> +			name = p + 1;
> +		}
> +
> +		/* strncat the rest */
> +		strncat(buf, name, length);
> +	}
> +}
> +
>  static int
>  nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
>  		      uint16_t flags)
> @@ -292,12 +329,16 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
>  {
>  	int ret = 0;
>  	unsigned int size = 0, offset = 0;
> +	char nfacct_name[NFACCT_NAME_MAX * 6 + 1];

Why this buffer length?

> +	parse_nfacct_name_xml(nfacct_name,
> +				nfacct_attr_get_str(nfacct,
> +						    NFACCT_ATTR_NAME));
>  	ret = snprintf(buf, rem,
>  			"<obj><name>%s</name>"
>  			"<pkts>%.20"PRIu64"</pkts>"
>  			"<bytes>%.20"PRIu64"</bytes>",
> -			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME),
> +			nfacct_name,
>  			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
>  			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS));
>  	BUFFER_SIZE(ret, size, rem, offset);
> -- 
> 1.8.3.1
> 
