From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_limit: Add translation to nft
Date: Tue, 22 Dec 2015 17:47:08 +0100
Message-ID: <20151222164708.GC18134@salvia>
References: <20151222075021.GA30824@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33325 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbbLVQrN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 11:47:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CBF7023CF67
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:47:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BF133DA862
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:47:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D40F9DA808
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:47:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151222075021.GA30824@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 01:20:21PM +0530, Shivani Bhardwaj wrote:
> Add translation for module limit to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -m limit --limit 5/s
> nft add rule ip filter INPUT limit rate 5/second counter
> 
> $ sudo iptables-translate -A INPUT -m limit --limit 3/m --limit-burst 3
> nft add rule ip filter INPUT limit rate 3/minute  burst 3 packets counter
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  extensions/libxt_limit.c | 57 +++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 49 insertions(+), 8 deletions(-)
> 
> diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
> index f75ef2f..e4374a7 100644
> --- a/extensions/libxt_limit.c
> +++ b/extensions/libxt_limit.c
> @@ -25,8 +25,8 @@ static void limit_help(void)
>  {
>  	printf(
>  "limit match options:\n"
> -"--limit avg			max average match rate: default "XT_LIMIT_AVG"\n"
> -"                                [Packets per second unless followed by \n"
> +"--limit avg		max average match rate: default "XT_LIMIT_AVG"\n"
> +"                                [Packets per second unless followed by\n"
>  "                                /sec /minute /hour /day postfixes]\n"
>  "--limit-burst number		number to match in a burst, default %u\n",
>  XT_LIMIT_BURST);
> @@ -73,7 +73,8 @@ int parse_rate(const char *rate, uint32_t *val)
>  		 * The rate maps to infinity. (1/day is the minimum they can
>  		 * specify, so we are ok at that end).
>  		 */
> -		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
> +		xtables_error(PARAMETER_PROBLEM,
> +			      "Rate too fast \"%s\"\n", rate);
>  	return 1;
>  }
>  
> @@ -86,10 +87,11 @@ static void limit_init(struct xt_entry_match *m)
>  
>  }
>  
> -/* FIXME: handle overflow:
> -	if (r->avg*r->burst/r->burst != r->avg)
> -		xtables_error(PARAMETER_PROBLEM,
> -			   "Sorry: burst too large for that avg rate.\n");
> +/*
> + * FIXME: handle overflow:
> + * if (r->avg*r->burst/r->burst != r->avg)
> + *		xtables_error(PARAMETER_PROBLEM,
> + *			"Sorry: burst too large for that avg rate.\n");
>  */
>  
>  static void limit_parse(struct xt_option_call *cb)
> @@ -129,7 +131,7 @@ static void print_rate(uint32_t period)
>  
>  	for (i = 1; i < ARRAY_SIZE(rates); ++i)
>  		if (period > rates[i].mult
> -            || rates[i].mult/period < rates[i].mult%period)
> +		    || rates[i].mult/period < rates[i].mult%period)
>  			break;
>  
>  	printf(" %u/%s", rates[i-1].mult / period, rates[i-1].name);
> @@ -139,6 +141,7 @@ static void
>  limit_print(const void *ip, const struct xt_entry_match *match, int numeric)
>  {
>  	const struct xt_rateinfo *r = (const void *)match->data;
> +
>  	printf(" limit: avg"); print_rate(r->avg);
>  	printf(" burst %u", r->burst);
>  }
> @@ -152,6 +155,43 @@ static void limit_save(const void *ip, const struct xt_entry_match *match)
>  		printf(" --limit-burst %u", r->burst);
>  }
>  
> +static const struct
> +rates rates_xlate[] = { { "day", XT_LIMIT_SCALE*24*60*60 },
> +			{ "hour", XT_LIMIT_SCALE*60*60 },
> +			{ "minute", XT_LIMIT_SCALE*60 },
> +			{ "second", XT_LIMIT_SCALE } };

Better, like this:

static const struct rate rates_xlate[] = {
        { "day",        XT_LIMIT_SCALE*24*60*60 },
        { "hour",       XT_LIMIT_SCALE*60*60 },
        ...
};

> +
> +static void print_rate_xlate(uint32_t period, struct xt_buf *buf)
> +{
> +	unsigned int i;
> +
> +	if (period == 0) {
> +		xt_buf_add(buf, " %f", INFINITY);
> +		return;
> +	}
> +
> +	for (i = 1; i < ARRAY_SIZE(rates); ++i)
> +		if (period > rates_xlate[i].mult
> +		    || rates_xlate[i].mult/period < rates_xlate[i].mult%period)

This should be:

        if (period > rates_xlate[i].mult ||
            rates_xlate[i].mult/period < rates_xlate[i].mult % period)
                                                            ^ ^
                                        mind the space between modulus.

Operands (like ||) should be placed at the end of the line.

Please, send a v2.
