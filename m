From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: [PATCH 3/6] libxtables: prefix exit_error to xtables_error
Date: Sat, 21 Feb 2009 08:37:00 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0902210828580.21582@ask.diku.dk>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
 <1235186284-31661-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	hadi@cyberus.ca
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:60156 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbZBUHhF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Feb 2009 02:37:05 -0500
In-Reply-To: <1235186284-31661-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On Sat, 21 Feb 2009, Jan Engelhardt wrote:

> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
> extensions/dscp_helper.c        |    4 +-
> extensions/expr                 |  179 +++++++++++++++++++++++++++++++++++++++

What is "extensions/expr", and what has it to do with "xtables_error" 
changes?

<cut>

> diff --git a/extensions/expr b/extensions/expr
> new file mode 100644
> index 0000000..f00b70d
> --- /dev/null
> +++ b/extensions/expr
> @@ -0,0 +1,179 @@
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <libHX/option.h>
> +
> +enum ttl_rel {
> +	REL_EQ,
> +	REL_LT,
> +	REL_GT,
> +};
> +
> +static bool ttl_inv;
> +static uint8_t ttl_value;
> +static unsigned int ttl_rel;
> +
> +/**
> + * @name:	name of the option
> + * @act:	pointer to variable to indicate the action
> + */
> +struct edesc {
> +	const char *name;
> +	unsigned int *act;
> +};
> +
> +static const struct HXoption ttl_options[] = {
> +	{.name = "ttl-eq", .act = &ttl_rel, .avl = TTL_EQ,
> +	 .type = XTO_UINT8, .ptr = &ttl_value,
> +	 .inv = &ttl_inv, .opt_id = 0x01, .opt_conflict = 0xFF,
> +	 .help = "Match time to live value"},
> +	{.ln = "ttl-lt", .type = XTO_UINT8, .ptr = &ttl_value,
> +	 .inv = &ttl_inv, .optid = 0x02, .optconflict = 0xFF,
> +	 .help = "Match TTL < value"},
> +	{.ln = "ttl-gt", .type = XTO_UINT8, .ptr = &ttl_value,
> +	 .val = TTL_GT,
> +	 .help = "Match TTL > value"},
> +	HXOPT_TABLEEND,
> +};
> +
> +static const char *const ttl_relsym[] = {"=", "<", ">"};
> +
> +static int ttl_mt_expr(void)
> +{
> +	snprintf(exprbuf, sizeof(exprbuf), "*8(nh+1)%s%hhu", ttl_relsym, ttl_rel);
> +}
> +
> +static struct expr_expander ttl_reg[] = {
> +	{.name = "ttl", .build_expr = ttl_mt_expr},
> +	{.name = "TTL", .build_expr = ttl_tg_expr},
> +};
> +
> +
> +			if (invert)
> +				info->mode = IPT_TTL_NE;
> +			else
> +				info->mode = IPT_TTL_EQ;
> +
> +			/* is 0 allowed? */
> +			info->ttl = value;
> +			break;
> +		case '3':
> +			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
> +				exit_error(PARAMETER_PROBLEM,
> +				           "ttl: Expected value between 0 and 255");
> +
> +			if (invert)
> +				exit_error(PARAMETER_PROBLEM,
> +						"ttl: unexpected `!'");
> +
> +			info->mode = IPT_TTL_LT;
> +			info->ttl = value;
> +			break;
> +		case '4':
> +			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
> +				exit_error(PARAMETER_PROBLEM,
> +				           "ttl: Expected value between 0 and 255");
> +
> +			if (invert)
> +				exit_error(PARAMETER_PROBLEM,
> +						"ttl: unexpected `!'");
> +
> +			info->mode = IPT_TTL_GT;
> +			info->ttl = value;
> +			break;
> +		default:
> +			return 0;
> +
> +	}
> +
> +	if (*flags)
> +		exit_error(PARAMETER_PROBLEM,
> +				"Can't specify TTL option twice");
> +	*flags = 1;
> +
> +	return 1;
> +}
> +
> +static void ttl_check(unsigned int flags)
> +{
> +	if (!flags)
> +		exit_error(PARAMETER_PROBLEM,
> +			"TTL match: You must specify one of "
> +			"`--ttl-eq', `--ttl-lt', `--ttl-gt");
> +}
> +
> +static void ttl_print(const void *ip, const struct xt_entry_match *match,
> +                      int numeric)
> +{
> +	const struct ipt_ttl_info *info =
> +		(struct ipt_ttl_info *) match->data;
> +
> +	printf("TTL match ");
> +	switch (info->mode) {
> +		case IPT_TTL_EQ:
> +			printf("TTL == ");
> +			break;
> +		case IPT_TTL_NE:
> +			printf("TTL != ");
> +			break;
> +		case IPT_TTL_LT:
> +			printf("TTL < ");
> +			break;
> +		case IPT_TTL_GT:
> +			printf("TTL > ");
> +			break;
> +	}
> +	printf("%u ", info->ttl);
> +}
> +
> +static void ttl_save(const void *ip, const struct xt_entry_match *match)
> +{
> +	const struct ipt_ttl_info *info =
> +		(struct ipt_ttl_info *) match->data;
> +
> +	switch (info->mode) {
> +		case IPT_TTL_EQ:
> +			printf("--ttl-eq ");
> +			break;
> +		case IPT_TTL_NE:
> +			printf("! --ttl-eq ");
> +			break;
> +		case IPT_TTL_LT:
> +			printf("--ttl-lt ");
> +			break;
> +		case IPT_TTL_GT:
> +			printf("--ttl-gt ");
> +			break;
> +		default:
> +			/* error */
> +			break;
> +	}
> +	printf("%u ", info->ttl);
> +}
> +
> +static const struct option ttl_opts[] = {
> +	{ "ttl", 1, NULL, '2' },
> +	{ "ttl-eq", 1, NULL, '2'},
> +	{ "ttl-lt", 1, NULL, '3'},
> +	{ "ttl-gt", 1, NULL, '4'},
> +	{ .name = NULL }
> +};
> +
> +static struct xtables_match ttl_mt_reg = {
> +	.name		= "ttl",
> +	.version	= XTABLES_VERSION,
> +	.family		= NFPROTO_IPV4,
> +	.size		= XT_ALIGN(sizeof(struct ipt_ttl_info)),
> +	.userspacesize	= XT_ALIGN(sizeof(struct ipt_ttl_info)),
> +	.help		= ttl_help,
> +	.parse		= ttl_parse,
> +	.final_check	= ttl_check,
> +	.print		= ttl_print,
> +	.save		= ttl_save,
> +	.extra_opts	= ttl_opts,
> +};
> +
> +
> +void _init(void)
> +{
> +	xtables_register_match(&ttl_mt_reg);
> +}


Cheers,
   Jesper Brouer

-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
